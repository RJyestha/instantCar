Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration

Public Class WebForm18
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
    Private vehicleID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if user is logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        ' Get vehicle ID from query string
        If Request.QueryString("id") IsNot Nothing Then
            If Integer.TryParse(Request.QueryString("id"), vehicleID) Then
                If Not IsPostBack Then
                    LoadVehicleDetails()
                    LoadAddons()
                    SetMinimumDates()
                End If
                CalculatePricing()
            Else
                Response.Redirect("~/SearchVehicles.aspx")
            End If
        Else
            Response.Redirect("~/SearchVehicles.aspx")
        End If
    End Sub

    Private Sub LoadVehicleDetails()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                Dim query As String = "SELECT v.VehicleID, v.LicensePlate, v.Color, v.Mileage, " &
                                    "v.PricePerDay, v.Status, v.Features, " &
                                    "m.MakeName, mod.ModelName, mod.Year, mod.FuelType, " &
                                    "mod.Transmission, mod.SeatingCapacity, mod.Description, " &
                                    "vi.ImagePath " &
                                    "FROM Vehicles v " &
                                    "INNER JOIN Model mod ON v.ModelID = mod.ModelID " &
                                    "INNER JOIN Make m ON mod.MakeID = m.MakeID " &
                                    "LEFT JOIN VehicleImages vi ON v.VehicleID = vi.VehicleID AND vi.ImageType = 'Primary' AND vi.IsActive = 1 " &
                                    "WHERE v.VehicleID = @VehicleID AND v.IsActive = 1"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@VehicleID", vehicleID)

                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    ' Basic Information
                    lblVehicleName.Text = reader("MakeName").ToString() & " " & reader("ModelName").ToString()
                    lblLicensePlate.Text = reader("LicensePlate").ToString()
                    lblStatus.Text = reader("Status").ToString()
                    lblPricePerDay.Text = CDec(reader("PricePerDay")).ToString("#,##0")

                    ' Specifications
                    lblYear.Text = reader("Year").ToString()
                    lblFuelType.Text = reader("FuelType").ToString()
                    lblTransmission.Text = reader("Transmission").ToString()
                    lblSeating.Text = reader("SeatingCapacity").ToString()
                    lblColor.Text = If(IsDBNull(reader("Color")), "Not specified", reader("Color").ToString())
                    lblMileage.Text = If(IsDBNull(reader("Mileage")), "0", reader("Mileage").ToString())

                    ' Description
                    If Not IsDBNull(reader("Description")) AndAlso Not String.IsNullOrEmpty(reader("Description").ToString()) Then
                        lblDescription.Text = reader("Description").ToString()
                        pnlDescription.Visible = True
                    End If

                    ' Image
                    If Not IsDBNull(reader("ImagePath")) AndAlso Not String.IsNullOrEmpty(reader("ImagePath").ToString()) Then
                        Dim imagePath As String = reader("ImagePath").ToString()
                        If imagePath.StartsWith("~/") Then
                            imagePath = imagePath.Substring(2)
                        End If
                        imgVehicle.ImageUrl = imagePath
                    Else
                        imgVehicle.ImageUrl = "images/no-vehicle-image.jpg"
                    End If

                    ' Features
                    LoadFeatures(If(IsDBNull(reader("Features")), "", reader("Features").ToString()))

                    ' Check if vehicle is available
                    If reader("Status").ToString() <> "Available" Then
                        btnAddToCart.Enabled = False
                        btnBookNow.Enabled = False
                        lblStatus.CssClass = "badge bg-danger fs-6"
                        ShowMessage("This vehicle is currently not available for booking.", "alert-warning")
                    Else
                        lblStatus.CssClass = "badge bg-success fs-6"
                    End If
                Else
                    ' Vehicle not found
                    Response.Redirect("~/SearchVehicles.aspx")
                End If
                reader.Close()
            End Using

        Catch ex As Exception
            ShowMessage("Error loading vehicle details: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Sub LoadFeatures(featuresJson As String)
        Try
            If Not String.IsNullOrEmpty(featuresJson) Then
                ' Simple feature parsing (assumes comma-separated features)
                Dim features() As String = featuresJson.Split(","c)
                Dim featureList As New System.Text.StringBuilder()

                featureList.Append("<ul class='feature-list'>")
                For Each feature As String In features
                    feature = feature.Trim()
                    If Not String.IsNullOrEmpty(feature) Then
                        featureList.AppendFormat("<li><i class='fas fa-check text-success me-2'></i>{0}</li>", feature)
                    End If
                Next
                featureList.Append("</ul>")

                pnlFeatures.Controls.Add(New LiteralControl(featureList.ToString()))
            Else
                pnlFeatures.Controls.Add(New LiteralControl("<p class='text-muted'>No additional features specified.</p>"))
            End If

        Catch ex As Exception
            pnlFeatures.Controls.Add(New LiteralControl("<p class='text-muted'>Features information not available.</p>"))
        End Try
    End Sub

    Private Sub LoadAddons()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                Dim query As String = "SELECT AddonID, AddonName, Description, PricePerDay " &
                                    "FROM Addons WHERE IsActive = 1 ORDER BY AddonName"

                Dim cmd As New SqlCommand(query, con)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                rptAddons.DataSource = dt
                rptAddons.DataBind()
            End Using

        Catch ex As Exception
            ShowMessage("Error loading add-ons: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Sub SetMinimumDates()
        ' Set minimum dates to today
        Dim today As String = DateTime.Now.ToString("yyyy-MM-dd")
        txtStartDate.Attributes.Add("min", today)
        txtEndDate.Attributes.Add("min", today)

        ' Set default dates
        If String.IsNullOrEmpty(txtStartDate.Text) Then
            txtStartDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd")
        End If

        If String.IsNullOrEmpty(txtEndDate.Text) Then
            txtEndDate.Text = DateTime.Now.AddDays(2).ToString("yyyy-MM-dd")
        End If
    End Sub

    Protected Sub DateChanged(sender As Object, e As EventArgs)
        CalculatePricing()
    End Sub

    Protected Sub AddonChanged(sender As Object, e As EventArgs)
        CalculatePricing()
    End Sub

    Private Sub CalculatePricing()
        Try
            ' Get rental days
            Dim rentalDays As Integer = 0
            If Not String.IsNullOrEmpty(txtStartDate.Text) AndAlso Not String.IsNullOrEmpty(txtEndDate.Text) Then
                Dim startDate As DateTime = DateTime.Parse(txtStartDate.Text)
                Dim endDate As DateTime = DateTime.Parse(txtEndDate.Text)
                rentalDays = Math.Max(1, (endDate - startDate).Days + 1)

                ' Check for maximum rental period (90 days)
                If rentalDays > 90 Then
                    ShowMessage("Maximum rental period is 90 days. Please adjust your dates.", "alert-warning")
                    Return
                End If
            End If

            lblRentalDays.Text = rentalDays.ToString()

            If rentalDays > 0 Then
                ' Get base price per day
                Dim basePricePerDay As Decimal = CDec(lblPricePerDay.Text.Replace(",", ""))

                ' Calculate discount based on duration
                Dim discountPercent As Decimal = GetDiscountPercentage(rentalDays)
                Dim discountedPricePerDay As Decimal = basePricePerDay * ((100 - discountPercent) / 100)

                ' Calculate subtotal
                Dim subTotal As Decimal = discountedPricePerDay * rentalDays
                lblSubTotal.Text = subTotal.ToString("#,##0")

                ' Show/hide discount section
                If discountPercent > 0 Then
                    pnlDiscount.Visible = True
                    lblDiscountPercent.Text = discountPercent.ToString()
                    lblDiscountAmount.Text = ((basePricePerDay - discountedPricePerDay) * rentalDays).ToString("#,##0")
                Else
                    pnlDiscount.Visible = False
                End If

                ' Calculate addon total
                Dim addonTotal As Decimal = 0
                For Each item As RepeaterItem In rptAddons.Items
                    Dim chkAddon As CheckBox = CType(item.FindControl("chkAddon"), CheckBox)
                    If chkAddon IsNot Nothing AndAlso chkAddon.Checked Then
                        Dim hdnPrice As HiddenField = CType(item.FindControl("hdnAddonPrice"), HiddenField)
                        If hdnPrice IsNot Nothing Then
                            addonTotal += CDec(hdnPrice.Value) * rentalDays
                        End If
                    End If
                Next

                lblAddonTotal.Text = addonTotal.ToString("#,##0")

                ' Calculate total
                Dim totalAmount As Decimal = subTotal + addonTotal
                lblTotalAmount.Text = totalAmount.ToString("#,##0")
            Else
                ' Reset pricing display
                lblSubTotal.Text = "0"
                lblAddonTotal.Text = "0"
                lblTotalAmount.Text = "0"
                pnlDiscount.Visible = False
            End If

        Catch ex As Exception
            ShowMessage("Error calculating pricing: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Function GetDiscountPercentage(days As Integer) As Decimal
        ' Discount structure as per coursework requirements
        If days >= 61 AndAlso days <= 90 Then
            Return 20 ' 20% discount for 61-90 days
        ElseIf days >= 31 AndAlso days <= 60 Then
            Return 15 ' 15% discount for 31-60 days
        ElseIf days >= 11 AndAlso days <= 30 Then
            Return 12 ' 12% discount for 11-30 days
        ElseIf days >= 4 AndAlso days <= 10 Then
            Return 8 ' 8% discount for 4-10 days
        Else
            Return 0 ' No discount for 1-3 days
        End If
    End Function

    Protected Sub btnAddToCart_Click(sender As Object, e As EventArgs)
        Try
            If ValidateBookingData() Then
                AddToSessionCart()
                ShowMessage("Vehicle added to cart successfully! <a href='Cart.aspx' class='alert-link'>View Cart</a>", "alert-success")
            End If

        Catch ex As Exception
            ShowMessage("Error adding to cart: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub btnBookNow_Click(sender As Object, e As EventArgs)
        Try
            If ValidateBookingData() Then
                ' Create booking directly
                If CreateBooking() Then
                    Response.Redirect("~/MyBookings.aspx")
                End If
            End If

        Catch ex As Exception
            ShowMessage("Error creating booking: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Private Function ValidateBookingData() As Boolean
        ' Validate required fields
        If String.IsNullOrEmpty(txtStartDate.Text) Then
            ShowMessage("Please select a start date.", "alert-warning")
            txtStartDate.Focus()
            Return False
        End If

        If String.IsNullOrEmpty(txtEndDate.Text) Then
            ShowMessage("Please select an end date.", "alert-warning")
            txtEndDate.Focus()
            Return False
        End If

        If String.IsNullOrEmpty(txtDropoffLocation.Text.Trim()) Then
            ShowMessage("Please enter a drop-off location.", "alert-warning")
            txtDropoffLocation.Focus()
            Return False
        End If

        ' Validate dates
        Dim startDate As DateTime = DateTime.Parse(txtStartDate.Text)
        Dim endDate As DateTime = DateTime.Parse(txtEndDate.Text)

        If startDate < DateTime.Now.Date Then
            ShowMessage("Start date cannot be in the past.", "alert-warning")
            txtStartDate.Focus()
            Return False
        End If

        If endDate <= startDate Then
            ShowMessage("End date must be after start date.", "alert-warning")
            txtEndDate.Focus()
            Return False
        End If

        Dim rentalDays As Integer = (endDate - startDate).Days + 1
        If rentalDays > 90 Then
            ShowMessage("Maximum rental period is 90 days.", "alert-warning")
            Return False
        End If

        ' Check vehicle availability for the selected dates
        If Not IsVehicleAvailable(startDate, endDate) Then
            ShowMessage("This vehicle is not available for the selected dates. Please choose different dates.", "alert-warning")
            Return False
        End If

        Return True
    End Function

    Private Function IsVehicleAvailable(startDate As DateTime, endDate As DateTime) As Boolean
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                ' Check for overlapping bookings
                Dim query As String = "SELECT COUNT(*) FROM Bookings " &
                                    "WHERE VehicleID = @VehicleID " &
                                    "AND Status IN ('Pending', 'Confirmed', 'Active') " &
                                    "AND ((@StartDate BETWEEN StartDate AND EndDate) " &
                                    "OR (@EndDate BETWEEN StartDate AND EndDate) " &
                                    "OR (StartDate BETWEEN @StartDate AND @EndDate))"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)

                Dim count As Integer = CInt(cmd.ExecuteScalar())
                Return count = 0
            End Using

        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub AddToSessionCart()
        Try
            ' Get cart from session
            Dim cart As List(Of CartItem) = GetSessionCart()

            ' Check if vehicle already in cart
            Dim existingItem = cart.FirstOrDefault(Function(c) c.VehicleID = vehicleID)
            If existingItem IsNot Nothing Then
                ShowMessage("This vehicle is already in your cart!", "alert-info")
                Return
            End If

            ' Create new cart item
            Dim cartItem As New CartItem With {
                .VehicleID = vehicleID,
                .VehicleName = lblVehicleName.Text,
                .StartDate = DateTime.Parse(txtStartDate.Text),
                .EndDate = DateTime.Parse(txtEndDate.Text),
                .DeliveryTime = If(String.IsNullOrEmpty(txtDeliveryTime.Text), Nothing, TimeSpan.Parse(txtDeliveryTime.Text)),
                .DropoffLocation = txtDropoffLocation.Text.Trim(),
                .SpecialRequests = txtSpecialRequests.Text.Trim(),
                .PricePerDay = CDec(lblPricePerDay.Text.Replace(",", "")),
                .TotalAmount = CDec(lblTotalAmount.Text.Replace(",", "")),
                .Addons = GetSelectedAddons()
            }

            cart.Add(cartItem)
            Session("Cart") = cart

        Catch ex As Exception
            Throw New Exception("Error adding item to cart: " & ex.Message)
        End Try
    End Sub

    Private Function GetSessionCart() As List(Of CartItem)
        If Session("Cart") Is Nothing Then
            Session("Cart") = New List(Of CartItem)()
        End If
        Return CType(Session("Cart"), List(Of CartItem))
    End Function

    Private Function GetSelectedAddons() As List(Of CartAddon)
        Dim addons As New List(Of CartAddon)()

        Try
            For Each item As RepeaterItem In rptAddons.Items
                Dim chkAddon As CheckBox = CType(item.FindControl("chkAddon"), CheckBox)
                If chkAddon IsNot Nothing AndAlso chkAddon.Checked Then
                    Dim hdnAddonID As HiddenField = CType(item.FindControl("hdnAddonID"), HiddenField)
                    Dim hdnPrice As HiddenField = CType(item.FindControl("hdnAddonPrice"), HiddenField)

                    If hdnAddonID IsNot Nothing AndAlso hdnPrice IsNot Nothing Then
                        addons.Add(New CartAddon With {
                            .AddonID = CInt(hdnAddonID.Value),
                            .PricePerDay = CDec(hdnPrice.Value)
                        })
                    End If
                End If
            Next
        Catch ex As Exception
            ' Handle error silently and return empty list
        End Try

        Return addons
    End Function

    Private Function CreateBooking() As Boolean
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim transaction As SqlTransaction = con.BeginTransaction()

                Try
                    ' Calculate pricing details
                    Dim startDate As DateTime = DateTime.Parse(txtStartDate.Text)
                    Dim endDate As DateTime = DateTime.Parse(txtEndDate.Text)
                    Dim rentalDays As Integer = (endDate - startDate).Days + 1
                    Dim basePricePerDay As Decimal = CDec(lblPricePerDay.Text.Replace(",", ""))
                    Dim discountPercent As Decimal = GetDiscountPercentage(rentalDays)
                    Dim discountedPricePerDay As Decimal = basePricePerDay * ((100 - discountPercent) / 100)
                    Dim subTotal As Decimal = discountedPricePerDay * rentalDays
                    Dim addonTotal As Decimal = CDec(lblAddonTotal.Text.Replace(",", ""))
                    Dim totalAmount As Decimal = subTotal + addonTotal

                    ' Insert booking
                    Dim bookingQuery As String = "INSERT INTO Bookings (UserID, VehicleID, StartDate, EndDate, " &
                                               "PricePerDay, DiscountPercentage, SubTotal, AddonTotal, TotalAmount, " &
                                               "DeliveryTime, DropoffLocation, SpecialRequests, Status) " &
                                               "VALUES (@UserID, @VehicleID, @StartDate, @EndDate, @PricePerDay, " &
                                               "@DiscountPercentage, @SubTotal, @AddonTotal, @TotalAmount, " &
                                               "@DeliveryTime, @DropoffLocation, @SpecialRequests, 'Pending'); " &
                                               "SELECT SCOPE_IDENTITY();"

                    Dim bookingCmd As New SqlCommand(bookingQuery, con, transaction)
                    bookingCmd.Parameters.AddWithValue("@UserID", Session("UserID"))
                    bookingCmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                    bookingCmd.Parameters.AddWithValue("@StartDate", startDate)
                    bookingCmd.Parameters.AddWithValue("@EndDate", endDate)
                    bookingCmd.Parameters.AddWithValue("@PricePerDay", discountedPricePerDay)
                    bookingCmd.Parameters.AddWithValue("@DiscountPercentage", discountPercent)
                    bookingCmd.Parameters.AddWithValue("@SubTotal", subTotal)
                    bookingCmd.Parameters.AddWithValue("@AddonTotal", addonTotal)
                    bookingCmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                    bookingCmd.Parameters.AddWithValue("@DeliveryTime", If(String.IsNullOrEmpty(txtDeliveryTime.Text), DBNull.Value, TimeSpan.Parse(txtDeliveryTime.Text)))
                    bookingCmd.Parameters.AddWithValue("@DropoffLocation", txtDropoffLocation.Text.Trim())
                    bookingCmd.Parameters.AddWithValue("@SpecialRequests", If(String.IsNullOrEmpty(txtSpecialRequests.Text.Trim()), DBNull.Value, txtSpecialRequests.Text.Trim()))

                    Dim bookingID As Integer = CInt(bookingCmd.ExecuteScalar())

                    ' Insert booking addons
                    For Each item As RepeaterItem In rptAddons.Items
                        Dim chkAddon As CheckBox = CType(item.FindControl("chkAddon"), CheckBox)
                        If chkAddon IsNot Nothing AndAlso chkAddon.Checked Then
                            Dim hdnAddonID As HiddenField = CType(item.FindControl("hdnAddonID"), HiddenField)
                            Dim hdnPrice As HiddenField = CType(item.FindControl("hdnAddonPrice"), HiddenField)

                            If hdnAddonID IsNot Nothing AndAlso hdnPrice IsNot Nothing Then
                                Dim addonQuery As String = "INSERT INTO BookingAddons (BookingID, AddonID, Quantity, PricePerDay) " &
                                                         "VALUES (@BookingID, @AddonID, 1, @PricePerDay)"

                                Dim addonCmd As New SqlCommand(addonQuery, con, transaction)
                                addonCmd.Parameters.AddWithValue("@BookingID", bookingID)
                                addonCmd.Parameters.AddWithValue("@AddonID", CInt(hdnAddonID.Value))
                                addonCmd.Parameters.AddWithValue("@PricePerDay", CDec(hdnPrice.Value))
                                addonCmd.ExecuteNonQuery()
                            End If
                        End If
                    Next

                    transaction.Commit()
                    ShowMessage("Booking created successfully! Your booking ID is: " & bookingID, "alert-success")
                    Return True

                Catch ex As Exception
                    transaction.Rollback()
                    Throw ex
                End Try
            End Using

        Catch ex As Exception
            ShowMessage("Error creating booking: " & ex.Message, "alert-danger")
            Return False
        End Try
    End Function

    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ " &
            "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
            "if(msgPanel) msgPanel.style.display = 'none'; " &
            "}, 5000);", True)
    End Sub

End Class

' Helper classes for cart functionality - should be in App_Code folder
Public Class CartItem
    Public Property VehicleID As Integer
    Public Property VehicleName As String
    Public Property StartDate As DateTime
    Public Property EndDate As DateTime
    Public Property DeliveryTime As TimeSpan?
    Public Property DropoffLocation As String
    Public Property SpecialRequests As String
    Public Property PricePerDay As Decimal
    Public Property TotalAmount As Decimal
    Public Property Addons As List(Of CartAddon)
End Class

Public Class CartAddon
    Public Property AddonID As Integer
    Public Property PricePerDay As Decimal
End Class