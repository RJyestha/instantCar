Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.IO
Imports System.Web.UI
Public Class WebForm7
    Inherits System.Web.UI.Page

    ' Connection string from Web.config
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Redirect to login if user is not an admin
        If Session("Username") Is Nothing OrElse Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
            Return
        End If

        If Not IsPostBack Then
            LoadMakes() ' Load makes into dropdown on first page load
            ClearValidationErrors() ' Hide any previous validation messages
        End If
    End Sub

    ' Loads active makes from database into ddlMake dropdown
    Private Sub LoadMakes()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT MakeID, MakeName FROM Make WHERE IsActive = 1 ORDER BY MakeName", con)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ddlMake.DataSource = dt
                ddlMake.DataTextField = "MakeName"
                ddlMake.DataValueField = "MakeID"
                ddlMake.DataBind()
                ddlMake.Items.Insert(0, New ListItem("Select Make", "0")) ' Default option
            End Using
        Catch ex As Exception
            ShowMessage("Error loading makes: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Triggered when make dropdown changes; loads corresponding models
    Protected Sub ddlMake_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlMake.SelectedIndexChanged
        LoadModels()
    End Sub

    ' Loads models for selected make from the database
    Private Sub LoadModels()
        Try
            ddlModel.Items.Clear()
            ddlModel.Items.Add(New ListItem("Select Model", "0")) ' Default option

            If ddlMake.SelectedValue <> "0" Then
                Using con As New SqlConnection(connStr)
                    con.Open()
                    Dim cmd As New SqlCommand("SELECT ModelID, ModelName FROM Model WHERE MakeID = @MakeID AND IsActive = 1 ORDER BY ModelName", con)
                    cmd.Parameters.AddWithValue("@MakeID", ddlMake.SelectedValue)

                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    ddlModel.DataSource = dt
                    ddlModel.DataTextField = "ModelName"
                    ddlModel.DataValueField = "ModelID"
                    ddlModel.DataBind()
                    ddlModel.Items.Insert(0, New ListItem("Select Model", "0"))
                End Using
            End If
        Catch ex As Exception
            ShowMessage("Error loading models: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Save button - saves the vehicle and redirects to list
    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateForm() Then
            If SaveVehicle() Then
                ShowMessage("Vehicle added successfully!", "alert-success")
                ' Redirect to manage page after 2 seconds
                ClientScript.RegisterStartupScript(Me.GetType(), "redirect",
                    "setTimeout(function(){ window.location.href='ManageVehicles.aspx'; }, 2000);", True)
            End If
        End If
    End Sub

    ' Save and add another button - saves the vehicle but keeps the form open
    Protected Sub btnSaveAndAddAnother_Click(sender As Object, e As EventArgs) Handles btnSaveAndAddAnother.Click
        If ValidateForm() Then
            If SaveVehicle() Then
                ShowMessage("Vehicle added successfully! You can add another vehicle.", "alert-success")
                ClearForm() ' Reset form fields for new entry
            End If
        End If
    End Sub

    ' Cancel button - return to manage page
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Response.Redirect("ManageVehicles.aspx")
    End Sub

    ' Back to list button
    Protected Sub btnBackToList_Click(sender As Object, e As EventArgs) Handles btnBackToList.Click
        Response.Redirect("ManageVehicles.aspx")
    End Sub

    ' Validates all form fields and returns True if all are valid
    Private Function ValidateForm() As Boolean
        Dim isValid As Boolean = True
        ClearValidationErrors()

        ' Validate Make
        If ddlMake.SelectedValue = "0" Then
            lblMakeError.Text = "Please select a make"
            lblMakeError.Visible = True
            isValid = False
        End If

        ' Validate Model
        If ddlModel.SelectedValue = "0" Then
            lblModelError.Text = "Please select a model"
            lblModelError.Visible = True
            isValid = False
        End If

        ' Validate Color
        If String.IsNullOrEmpty(txtColor.Text.Trim()) Then
            lblColorError.Text = "Color is required"
            lblColorError.Visible = True
            isValid = False
        ElseIf txtColor.Text.Trim().Length < 2 Then
            lblColorError.Text = "Color must be at least 2 characters"
            lblColorError.Visible = True
            isValid = False
        End If

        ' Validate License Plate
        If String.IsNullOrEmpty(txtLicensePlate.Text.Trim()) Then
            lblLicensePlateError.Text = "License plate is required"
            lblLicensePlateError.Visible = True
            isValid = False
        ElseIf CheckLicensePlateExists(txtLicensePlate.Text.Trim()) Then
            lblLicensePlateError.Text = "License plate already exists"
            lblLicensePlateError.Visible = True
            isValid = False
        End If

        ' Validate Price Per Day
        If String.IsNullOrEmpty(txtPricePerDay.Text.Trim()) Then
            lblPriceError.Text = "Price per day is required"
            lblPriceError.Visible = True
            isValid = False
        Else
            Dim price As Decimal
            If Decimal.TryParse(txtPricePerDay.Text.Trim(), price) Then
                If price <= 0 Then
                    lblPriceError.Text = "Price per day must be greater than 0"
                    lblPriceError.Visible = True
                    isValid = False
                ElseIf price > 50000 Then
                    lblPriceError.Text = "Price per day seems too high (max Rs 50,000)"
                    lblPriceError.Visible = True
                    isValid = False
                End If
            Else
                lblPriceError.Text = "Please enter a valid price per day"
                lblPriceError.Visible = True
                isValid = False
            End If
        End If

        ' Validate Image file extension and size
        If fuVehicleImage.HasFile Then
            Dim allowedExtensions As String() = {".jpg", ".jpeg", ".png", ".gif"}
            Dim fileExtension As String = Path.GetExtension(fuVehicleImage.FileName).ToLower()

            If Not allowedExtensions.Contains(fileExtension) Then
                ShowMessage("Please upload a valid image file (JPG, JPEG, PNG, GIF)", "alert-danger")
                isValid = False
            ElseIf fuVehicleImage.PostedFile.ContentLength > (2 * 1024 * 1024) Then ' 2MB max
                ShowMessage("Image file size must be less than 2MB", "alert-danger")
                isValid = False
            End If
        End If

        Return isValid
    End Function

    ' Checks if the license plate already exists in the database
    Private Function CheckLicensePlateExists(licensePlate As String) As Boolean
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Vehicles WHERE LicensePlate = @LicensePlate AND IsActive = 1", con)
                cmd.Parameters.AddWithValue("@LicensePlate", licensePlate.ToUpper())
                Return CInt(cmd.ExecuteScalar()) > 0
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

    ' Saves vehicle information into database and uploads image
    Private Function SaveVehicle() As Boolean
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Using transaction As SqlTransaction = con.BeginTransaction()
                    Try
                        ' Insert vehicle data into Vehicles table
                        Dim query As String = "INSERT INTO Vehicles (ModelID, LicensePlate, Color, Mileage, PricePerDay, " &
                                             "Status, Features, Location, IsActive, CreatedBy, CreatedDate) " &
                                             "VALUES (@ModelID, @LicensePlate, @Color, @Mileage, @PricePerDay, " &
                                             "@Status, @Features, @Location, 1, @CreatedBy, GETDATE()); " &
                                             "SELECT SCOPE_IDENTITY();"

                        Dim cmd As New SqlCommand(query, con, transaction)
                        cmd.Parameters.AddWithValue("@ModelID", ddlModel.SelectedValue)
                        cmd.Parameters.AddWithValue("@LicensePlate", txtLicensePlate.Text.Trim().ToUpper())
                        cmd.Parameters.AddWithValue("@Color", txtColor.Text.Trim())

                        ' Handle mileage input
                        Dim mileage As Integer = 0
                        If Not String.IsNullOrEmpty(txtMileage.Text.Trim()) Then
                            Integer.TryParse(txtMileage.Text.Trim(), mileage)
                        End If
                        cmd.Parameters.AddWithValue("@Mileage", mileage)

                        cmd.Parameters.AddWithValue("@PricePerDay", CDec(txtPricePerDay.Text.Trim()))
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue)
                        cmd.Parameters.AddWithValue("@Features", GetSelectedFeatures())
                        cmd.Parameters.AddWithValue("@Location", If(String.IsNullOrEmpty(txtLocation.Text.Trim()), DBNull.Value, txtLocation.Text.Trim()))
                        cmd.Parameters.AddWithValue("@CreatedBy", Session("UserID"))

                        ' Get new VehicleID
                        Dim vehicleID As Integer = CInt(cmd.ExecuteScalar())

                        ' Save image if uploaded
                        If fuVehicleImage.HasFile Then
                            SaveVehicleImage(vehicleID, con, transaction)
                        End If

                        transaction.Commit()
                        Return True

                    Catch ex As Exception
                        transaction.Rollback()
                        ShowMessage("Error saving vehicle: " & ex.Message, "alert-danger")
                        Return False
                    End Try
                End Using
            End Using
        Catch ex As Exception
            ShowMessage("Database connection error: " & ex.Message, "alert-danger")
            Return False
        End Try
    End Function

    ' Collects all selected features and returns as comma-separated string
    Private Function GetSelectedFeatures() As String
        Dim features As New List(Of String)

        If chkAirConditioning.Checked Then features.Add("Air conditioning")
        If chkBluetooth.Checked Then features.Add("Bluetooth")
        If chkGPS.Checked Then features.Add("GPS")
        If chk4WD.Checked Then features.Add("4WD")
        If chkLeatherSeats.Checked Then features.Add("Leather seats")
        If chkSunroof.Checked Then features.Add("Sunroof")
        If chkPremiumSound.Checked Then features.Add("Premium sound")

        ' Handle custom feature input
        If Not String.IsNullOrEmpty(txtCustomFeatures.Text.Trim()) Then
            Dim customFeatures As String() = txtCustomFeatures.Text.Trim().Split(","c)
            For Each feature As String In customFeatures
                If Not String.IsNullOrEmpty(feature.Trim()) Then
                    features.Add(feature.Trim())
                End If
            Next
        End If

        Return String.Join(", ", features)
    End Function

    ' Saves uploaded image file to disk and database
    Private Sub SaveVehicleImage(vehicleID As Integer, con As SqlConnection, transaction As SqlTransaction)
        Try
            ' Ensure upload folder exists
            Dim uploadsFolder As String = Server.MapPath("~/image/")
            If Not Directory.Exists(uploadsFolder) Then
                Directory.CreateDirectory(uploadsFolder)
            End If

            ' Generate unique filename
            Dim makeName As String = ddlMake.SelectedItem.Text.ToLower().Replace(" ", "").Replace("-", "")
            Dim modelName As String = ddlModel.SelectedItem.Text.ToLower().Replace(" ", "").Replace("-", "")
            Dim fileExtension As String = Path.GetExtension(fuVehicleImage.FileName).ToLower()
            Dim fileName As String = makeName & " " & modelName & vehicleID.ToString() & fileExtension
            Dim filePath As String = Path.Combine(uploadsFolder, fileName)

            ' Save image to server
            fuVehicleImage.SaveAs(filePath)

            ' Insert image record into VehicleImages table
            Dim imageQuery As String = "INSERT INTO VehicleImages (VehicleID, ImagePath, ImageType, Description, DisplayOrder, IsActive, UploadedDate, UploadedBy) " &
                                      "VALUES (@VehicleID, @ImagePath, @ImageType, @Description, @DisplayOrder, 1, GETDATE(), @UploadedBy)"

            Dim imageCmd As New SqlCommand(imageQuery, con, transaction)
            imageCmd.Parameters.AddWithValue("@VehicleID", vehicleID)
            imageCmd.Parameters.AddWithValue("@ImagePath", "~/image/" & fileName)
            imageCmd.Parameters.AddWithValue("@ImageType", "Primary")
            imageCmd.Parameters.AddWithValue("@Description", ddlMake.SelectedItem.Text & " " & ddlModel.SelectedItem.Text & " - Main Image")
            imageCmd.Parameters.AddWithValue("@DisplayOrder", 1)
            imageCmd.Parameters.AddWithValue("@UploadedBy", Session("UserID"))

            imageCmd.ExecuteNonQuery()

        Catch ex As Exception
            ' Image upload error should not abort vehicle save
            ShowMessage("Vehicle saved successfully, but there was an issue with the image upload: " & ex.Message, "alert-warning")
        End Try
    End Sub

    ' Resets all form fields and validation labels
    Private Sub ClearForm()
        ddlMake.SelectedValue = "0"
        ddlModel.Items.Clear()
        ddlModel.Items.Add(New ListItem("Select Model", "0"))
        txtColor.Text = ""
        txtLicensePlate.Text = ""
        txtMileage.Text = ""
        txtPricePerDay.Text = ""
        ddlStatus.SelectedValue = "Available"
        txtLocation.Text = ""
        txtCustomFeatures.Text = ""

        chkAirConditioning.Checked = False
        chkBluetooth.Checked = False
        chkGPS.Checked = False
        chk4WD.Checked = False
        chkLeatherSeats.Checked = False
        chkSunroof.Checked = False
        chkPremiumSound.Checked = False

        ClearValidationErrors()
    End Sub

    ' Hides all error messages
    Private Sub ClearValidationErrors()
        lblMakeError.Visible = False
        lblModelError.Visible = False
        lblColorError.Visible = False
        lblLicensePlateError.Visible = False
        lblPriceError.Visible = False
    End Sub

    ' Displays alert message in a Bootstrap alert box
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert alert-dismissible fade show " & cssClass
        pnlMessage.Visible = True

        ' Auto-hide success messages after 5 seconds
        If cssClass.Contains("success") Then
            ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
                "setTimeout(function(){ " &
                "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
                "if(msgPanel) msgPanel.style.display = 'none'; " &
                "}, 5000);", True)
        End If
    End Sub

End Class