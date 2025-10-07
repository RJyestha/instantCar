Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Text
Public Class WebForm12
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' When the page first loads (not a postback), load make dropdown and vehicle list
        If Not IsPostBack Then
            LoadMakes()        ' Populate dropdown with car makes
            LoadVehicles()     ' Load and display vehicles based on filters
        End If
    End Sub
    ' Load car makes into ddlMake dropdown
    Private Sub LoadMakes()
    Try
        Using con As New SqlConnection(connStr)
            con.Open()
            Dim cmd As New SqlCommand("SELECT MakeID, MakeName FROM Make WHERE IsActive = 1 ORDER BY MakeName", con)
            Dim reader As SqlDataReader = cmd.ExecuteReader()

            ddlMake.Items.Clear()
            ddlMake.Items.Add(New ListItem("-- Select Make --", ""))

            While reader.Read()
                ddlMake.Items.Add(New ListItem(reader("MakeName").ToString(), reader("MakeID").ToString()))
            End While
        End Using
    Catch ex As Exception
        ShowMessage("Error loading makes: " & ex.Message, "alert-danger")
    End Try
End Sub

' When a make is selected, load corresponding models
Protected Sub ddlMake_SelectedIndexChanged(sender As Object, e As EventArgs)
    LoadModels()
End Sub

' Load models related to the selected make
Private Sub LoadModels()
    ddlModel.Items.Clear()
    ddlModel.Items.Add(New ListItem("-- Select Model --", ""))

    If ddlMake.SelectedValue <> "" Then
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT ModelID, ModelName FROM Model WHERE MakeID = @MakeID AND IsActive = 1 ORDER BY ModelName", con)
                cmd.Parameters.AddWithValue("@MakeID", ddlMake.SelectedValue)
                Dim reader As SqlDataReader = cmd.ExecuteReader()

                While reader.Read()
                    ddlModel.Items.Add(New ListItem(reader("ModelName").ToString(), reader("ModelID").ToString()))
                End While
            End Using
        Catch ex As Exception
            ShowMessage("Error loading models: " & ex.Message, "alert-danger")
        End Try
    End If
End Sub

' When search button is clicked, load filtered vehicles
Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
    LoadVehicles()
End Sub

' Clear all filters and reload all vehicles
Protected Sub btnClearFilters_Click(sender As Object, e As EventArgs)
    ClearFilters()
    LoadVehicles()
End Sub

' Reset all filter fields
Private Sub ClearFilters()
    ddlMake.ClearSelection()
    ddlModel.Items.Clear()
    ddlModel.Items.Add(New ListItem("-- Select Model --", ""))
    ddlFuelType.ClearSelection()
    ddlTransmission.ClearSelection()
    ddlSeating.ClearSelection()
    ddlSortBy.SelectedValue = "PriceAsc"
    txtMinPrice.Text = ""
    txtMaxPrice.Text = ""
    txtSearchName.Text = ""
End Sub

' Load and filter vehicle results based on selected filters
Private Sub LoadVehicles()
    Try
        Using con As New SqlConnection(connStr)
            con.Open()

            Dim query As New StringBuilder()
            Dim cmd As New SqlCommand()

            ' Start SQL query
            query.AppendLine("
                SELECT v.VehicleID, v.LicensePlate, v.Color, v.PricePerDay, v.Status,
                       m.MakeName, mod.ModelName, mod.Year, mod.FuelType, mod.Transmission, 
                       mod.SeatingCapacity, mod.Description, vi.ImagePath
                FROM Vehicles v
                INNER JOIN Model mod ON v.ModelID = mod.ModelID
                INNER JOIN Make m ON mod.MakeID = m.MakeID
                LEFT JOIN VehicleImages vi ON v.VehicleID = vi.VehicleID AND vi.ImageType = 'Primary' AND vi.IsActive = 1
                WHERE v.IsActive = 1 AND v.Status = 'Available'")

            ' Add filters dynamically to the query
            If ddlMake.SelectedValue <> "" Then
                query.Append(" AND m.MakeID = @MakeID")
                cmd.Parameters.AddWithValue("@MakeID", ddlMake.SelectedValue)
            End If

            If ddlModel.SelectedValue <> "" Then
                query.Append(" AND mod.ModelID = @ModelID")
                cmd.Parameters.AddWithValue("@ModelID", ddlModel.SelectedValue)
            End If

            If ddlFuelType.SelectedValue <> "" Then
                query.Append(" AND mod.FuelType = @FuelType")
                cmd.Parameters.AddWithValue("@FuelType", ddlFuelType.SelectedValue)
            End If

            If ddlTransmission.SelectedValue <> "" Then
                query.Append(" AND mod.Transmission = @Transmission")
                cmd.Parameters.AddWithValue("@Transmission", ddlTransmission.SelectedValue)
            End If

            If ddlSeating.SelectedValue <> "" Then
                If ddlSeating.SelectedValue = "7" Then
                    query.Append(" AND mod.SeatingCapacity >= @Seating")
                Else
                    query.Append(" AND mod.SeatingCapacity = @Seating")
                End If
                cmd.Parameters.AddWithValue("@Seating", ddlSeating.SelectedValue)
            End If

            If txtMinPrice.Text <> "" Then
                query.Append(" AND v.PricePerDay >= @MinPrice")
                cmd.Parameters.AddWithValue("@MinPrice", CDec(txtMinPrice.Text))
            End If

            If txtMaxPrice.Text <> "" Then
                query.Append(" AND v.PricePerDay <= @MaxPrice")
                cmd.Parameters.AddWithValue("@MaxPrice", CDec(txtMaxPrice.Text))
            End If

            If txtSearchName.Text <> "" Then
                query.Append(" AND (m.MakeName LIKE @Search OR mod.ModelName LIKE @Search)")
                cmd.Parameters.AddWithValue("@Search", "%" & txtSearchName.Text & "%")
            End If

            ' Apply sorting based on user selection
            Select Case ddlSortBy.SelectedValue
                Case "PriceAsc" : query.Append(" ORDER BY v.PricePerDay ASC")
                Case "PriceDesc" : query.Append(" ORDER BY v.PricePerDay DESC")
                Case "MakeAsc" : query.Append(" ORDER BY m.MakeName ASC")
                Case "ModelAsc" : query.Append(" ORDER BY mod.ModelName ASC")
                Case "Newest" : query.Append(" ORDER BY v.CreatedDate DESC")
                Case Else : query.Append(" ORDER BY v.PricePerDay ASC")
            End Select

            ' Set command text and connection
            cmd.CommandText = query.ToString()
            cmd.Connection = con

            ' Execute the query and bind to ListView
            Dim adapter As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            adapter.Fill(dt)

            lvVehicles.DataSource = dt
            lvVehicles.DataBind()

            ' Update results count label
            lblResultsCount.Text = If(dt.Rows.Count > 0, dt.Rows.Count & " vehicle(s) found", "No vehicles found")
        End Using
    Catch ex As Exception
        ShowMessage("Error loading vehicles: " & ex.Message, "alert-danger")
    End Try
End Sub

' Redirect user to vehicle details page for booking
Protected Sub BookNow_Command(sender As Object, e As CommandEventArgs)
    Try
        Response.Redirect("VehicleDetails.aspx?id=" & e.CommandArgument.ToString())
    Catch ex As Exception
        ShowMessage("Error redirecting to booking: " & ex.Message, "alert-danger")
    End Try
End Sub

    ' Add selected vehicle to the user's session cart (your logic will be placed here)
    Protected Sub AddToCart_Command(sender As Object, e As CommandEventArgs)
        Try
            ' Check if user is logged in
            If Session("UserID") Is Nothing Then
                ShowMessage("Please log in to add vehicles to cart.", "alert-warning")
                Return
            End If

            Dim vehicleID As Integer = CInt(e.CommandArgument)

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Check if vehicle is available
                Dim checkAvailabilityCmd As New SqlCommand("SELECT Status FROM Vehicles WHERE VehicleID = @VehicleID", con)
                checkAvailabilityCmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                Dim status As String = checkAvailabilityCmd.ExecuteScalar()?.ToString()

                If status <> "Available" Then
                    ShowMessage("This vehicle is not available for booking.", "alert-warning")
                    Return
                End If

                ' Get vehicle information for cart
                Dim vehicleQuery As String = "SELECT v.VehicleID, v.PricePerDay, m.MakeName, mod.ModelName " &
                                         "FROM Vehicles v " &
                                         "INNER JOIN Model mod ON v.ModelID = mod.ModelID " &
                                         "INNER JOIN Make m ON mod.MakeID = m.MakeID " &
                                         "WHERE v.VehicleID = @VehicleID"

                Dim vehicleCmd As New SqlCommand(vehicleQuery, con)
                vehicleCmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                Dim reader As SqlDataReader = vehicleCmd.ExecuteReader()

                If reader.Read() Then
                    Dim cartItem As New CartItem With {
                    .VehicleID = CInt(reader("VehicleID")),
                    .VehicleName = reader("MakeName").ToString() & " " & reader("ModelName").ToString(),
                    .PricePerDay = CDec(reader("PricePerDay")),
                    .StartDate = DateTime.Now.AddDays(1).Date,
                    .EndDate = DateTime.Now.AddDays(2).Date,
                    .DropoffLocation = "To be specified",
                    .SpecialRequests = "",
                    .Addons = New List(Of CartAddon)()
                }

                    cartItem.TotalAmount = cartItem.PricePerDay

                    Dim cart As List(Of CartItem) = GetSessionCart()
                    Dim existingItem = cart.FirstOrDefault(Function(c) c.VehicleID = vehicleID)
                    If existingItem IsNot Nothing Then
                        ShowMessage("This vehicle is already in your cart!", "alert-info")
                        Return
                    End If

                    cart.Add(cartItem)
                    Session("Cart") = cart
                    ShowMessage("Vehicle added to cart successfully!", "alert-success")
                Else
                    ShowMessage("Vehicle not found.", "alert-danger")
                End If

                reader.Close()
            End Using
        Catch ex As Exception
            ShowMessage("Error adding vehicle to cart: " & ex.Message, "alert-danger")
        End Try

    End Sub

    ' Get current cart from session or create a new one
    Private Function GetSessionCart() As List(Of CartItem)
    If Session("Cart") Is Nothing Then
        Session("Cart") = New List(Of CartItem)()
    End If
    Return CType(Session("Cart"), List(Of CartItem))
End Function

' Get the correct image path from database or return default image
Protected Function GetVehicleImagePath(vehicleData As Object) As String
    If vehicleData IsNot Nothing AndAlso Not IsDBNull(vehicleData) AndAlso Not String.IsNullOrWhiteSpace(vehicleData.ToString()) Then
        Dim path As String = vehicleData.ToString()
        If path.StartsWith("~/") Then path = path.Substring(2)
        Return path
    End If
    Return "images/no-vehicle-image.jpg"
End Function

' Display an alert message on the page
Private Sub ShowMessage(message As String, cssClass As String)
    lblMessage.Text = message
    pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
    pnlMessage.Visible = True

    ' Auto-hide message panel after 5 seconds
    ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
        "setTimeout(function() { document.getElementById('" & pnlMessage.ClientID & "').style.display = 'none'; }, 5000);", True)
End Sub
    End Class
