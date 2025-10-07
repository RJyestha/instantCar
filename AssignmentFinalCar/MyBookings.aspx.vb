
Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Public Class WebForm16
    Inherits System.Web.UI.Page

    ' Connection string to the database
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    ' Page Load event: fires when page is loaded
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Redirect to login page if user is not logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        ' Only load bookings and stats on first load, not postbacks (like button clicks)
        If Not IsPostBack Then
            LoadBookings()
            LoadBookingStats()
        End If
    End Sub

    ' Loads total and active booking counts
    Private Sub LoadBookingStats()
        Try
            Dim userID As Integer = CInt(Session("UserID"))

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Count all bookings for the logged-in user
                Dim totalCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE UserID = @UserID", con)
                totalCmd.Parameters.AddWithValue("@UserID", userID)
                lblTotalBookings.Text = totalCmd.ExecuteScalar().ToString()

                ' Count only active bookings (Pending, Confirmed, Active)
                Dim activeCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE UserID = @UserID AND Status IN ('Pending', 'Confirmed', 'Active')", con)
                activeCmd.Parameters.AddWithValue("@UserID", userID)
                lblActiveBookings.Text = activeCmd.ExecuteScalar().ToString()
            End Using

        Catch ex As Exception
            ShowMessage("Error loading booking statistics: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Loads the list of bookings with optional filters applied
    Private Sub LoadBookings()
        Try
            Dim userID As Integer = CInt(Session("UserID"))

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Base SQL query joining related tables
                Dim query As String = "SELECT b.BookingID, b.StartDate, b.EndDate, b.TotalAmount, " &
                                    "b.DiscountPercentage, b.Status, b.BookingDate, b.ConfirmedDate, " &
                                    "b.CancelledDate, b.CancellationReason, b.DeliveryTime, b.DropoffLocation, " &
                                    "b.SpecialRequests, v.VehicleID, v.LicensePlate, " &
                                    "m.MakeName, mod.ModelName, mod.Year, mod.FuelType, mod.Transmission " &
                                    "FROM Bookings b " &
                                    "INNER JOIN Vehicles v ON b.VehicleID = v.VehicleID " &
                                    "INNER JOIN Model mod ON v.ModelID = mod.ModelID " &
                                    "INNER JOIN Make m ON mod.MakeID = m.MakeID " &
                                    "WHERE b.UserID = @UserID"

                ' Filter: Booking status
                If Not String.IsNullOrEmpty(ddlStatusFilter.SelectedValue) Then
                    query &= " AND b.Status = @Status"
                End If

                ' Filter: From date
                If Not String.IsNullOrEmpty(txtFromDate.Text) Then
                    query &= " AND b.StartDate >= @FromDate"
                End If

                ' Filter: To date
                If Not String.IsNullOrEmpty(txtToDate.Text) Then
                    query &= " AND b.EndDate <= @ToDate"
                End If

                ' Filter: Search term (make, model, license)
                If Not String.IsNullOrEmpty(txtSearch.Text.Trim()) Then
                    query &= " AND (m.MakeName LIKE @SearchTerm OR mod.ModelName LIKE @SearchTerm OR v.LicensePlate LIKE @SearchTerm)"
                End If

                ' Order results by booking date descending
                query &= " ORDER BY b.BookingDate DESC"

                ' Build SQL command with parameters
                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@UserID", userID)

                If Not String.IsNullOrEmpty(ddlStatusFilter.SelectedValue) Then
                    cmd.Parameters.AddWithValue("@Status", ddlStatusFilter.SelectedValue)
                End If

                If Not String.IsNullOrEmpty(txtFromDate.Text) Then
                    cmd.Parameters.AddWithValue("@FromDate", DateTime.Parse(txtFromDate.Text))
                End If

                If Not String.IsNullOrEmpty(txtToDate.Text) Then
                    cmd.Parameters.AddWithValue("@ToDate", DateTime.Parse(txtToDate.Text))
                End If

                If Not String.IsNullOrEmpty(txtSearch.Text.Trim()) Then
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" & txtSearch.Text.Trim() & "%")
                End If

                ' Execute and bind results to ListView
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                lvBookings.DataSource = dt
                lvBookings.DataBind()
            End Using

        Catch ex As Exception
            ShowMessage("Error loading bookings: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Triggered when the status dropdown changes
    Protected Sub ddlStatusFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlStatusFilter.SelectedIndexChanged
        LoadBookings()
    End Sub

    ' Triggered when "Apply Filter" button is clicked
    Protected Sub btnApplyFilter_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnApplyFilter.Click
        LoadBookings()
    End Sub

    ' Triggered when "Clear Filter" button is clicked
    Protected Sub btnClearFilter_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClearFilter.Click
        ddlStatusFilter.SelectedIndex = 0
        txtFromDate.Text = ""
        txtToDate.Text = ""
        txtSearch.Text = ""
        LoadBookings()
    End Sub

    ' Handles cancellation of a booking
    Protected Sub CancelBooking_Command(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            Dim bookingID As Integer = CInt(e.CommandArgument)

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Check current booking status
                Dim checkCmd As New SqlCommand("SELECT Status, StartDate FROM Bookings WHERE BookingID = @BookingID", con)
                checkCmd.Parameters.AddWithValue("@BookingID", bookingID)

                Dim reader As SqlDataReader = checkCmd.ExecuteReader()
                If reader.Read() Then
                    Dim status As String = reader("Status").ToString()
                    Dim startDate As DateTime = CDate(reader("StartDate"))
                    reader.Close()

                    ' Validations before cancellation
                    If status = "Cancelled" Then
                        ShowMessage("This booking is already cancelled.", "alert-warning")
                        Return
                    End If

                    If status = "Completed" Then
                        ShowMessage("Cannot cancel a completed booking.", "alert-warning")
                        Return
                    End If

                    If startDate <= DateTime.Now.Date Then
                        ShowMessage("Cannot cancel a booking that has already started.", "alert-warning")
                        Return
                    End If

                    ' Proceed with cancellation
                    Dim cancelCmd As New SqlCommand("UPDATE Bookings SET Status = 'Cancelled', " &
                                                  "CancelledDate = @CancelledDate, " &
                                                  "CancelledBy = @CancelledBy, " &
                                                  "CancellationReason = @Reason " &
                                                  "WHERE BookingID = @BookingID", con)

                    cancelCmd.Parameters.AddWithValue("@BookingID", bookingID)
                    cancelCmd.Parameters.AddWithValue("@CancelledDate", DateTime.Now)
                    cancelCmd.Parameters.AddWithValue("@CancelledBy", Session("UserID"))
                    cancelCmd.Parameters.AddWithValue("@Reason", "Cancelled by customer")

                    If cancelCmd.ExecuteNonQuery() > 0 Then
                        ShowMessage("Booking cancelled successfully!", "alert-success")
                        LoadBookings()
                        LoadBookingStats()
                    Else
                        ShowMessage("Failed to cancel booking. Please try again.", "alert-danger")
                    End If
                Else
                    reader.Close()
                    ShowMessage("Booking not found.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ShowMessage("Error cancelling booking: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Returns CSS class based on booking status
    Protected Function GetStatusClass(status As Object) As String
        If status Is Nothing OrElse IsDBNull(status) Then Return "status-pending"

        Select Case status.ToString().ToLower()
            Case "pending"
                Return "status-pending"
            Case "confirmed"
                Return "status-confirmed"
            Case "active"
                Return "status-active"
            Case "completed"
                Return "status-completed"
            Case "cancelled"
                Return "status-cancelled"
            Case Else
                Return "status-pending"
        End Select
    End Function

    ' Determines whether cancel button should be shown
    Protected Function CanCancelBooking(status As Object, startDate As Object) As Boolean
        If status Is Nothing OrElse startDate Is Nothing Then Return False

        Try
            Dim statusStr As String = status.ToString()
            Dim start As DateTime = CDate(startDate)

            Return (statusStr = "Pending" OrElse statusStr = "Confirmed") AndAlso start > DateTime.Now.Date
        Catch
            Return False
        End Try
    End Function

    ' Calculates the number of days between two dates
    Protected Function CalculateDays(startDate As Object, endDate As Object) As Integer
        If startDate Is Nothing OrElse endDate Is Nothing Then Return 0

        Try
            Dim start As DateTime = CDate(startDate)
            Dim endD As DateTime = CDate(endDate)
            Return Math.Max(1, (endD - start).Days + 1)
        Catch
            Return 0
        End Try
    End Function

    ' Returns the image path for the vehicle
    Protected Function GetVehicleImagePath(vehicleID As Object) As String
        Try
            If vehicleID IsNot Nothing AndAlso Not IsDBNull(vehicleID) Then
                Using con As New SqlConnection(connStr)
                    con.Open()

                    Dim query As String = "SELECT TOP 1 ImagePath FROM VehicleImages " &
                                    "WHERE VehicleID = @VehicleID AND IsActive = 1 " &
                                    "ORDER BY CASE WHEN ImageType = 'Primary' THEN 1 ELSE 2 END, DisplayOrder"

                    Dim cmd As New SqlCommand(query, con)
                    cmd.Parameters.AddWithValue("@VehicleID", vehicleID)

                    Dim imagePath As Object = cmd.ExecuteScalar()
                    If imagePath IsNot Nothing AndAlso Not IsDBNull(imagePath) Then
                        Dim dbPath As String = imagePath.ToString()

                        If dbPath.StartsWith("~/") Then
                            Return ResolveUrl(dbPath)
                        Else
                            Return dbPath
                        End If
                    End If
                End Using
            End If

            Return ResolveUrl("~/image/no-vehicle-image.jpg")
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error loading vehicle image: " & ex.Message)
            Return ResolveUrl("~/image/no-vehicle-image.jpg")
        End Try
    End Function

    ' Returns FontAwesome icon class based on booking status
    Protected Function GetBookingStatusIcon(status As Object) As String
        If status Is Nothing OrElse IsDBNull(status) Then Return "fas fa-clock"

        Select Case status.ToString().ToLower()
            Case "pending"
                Return "fas fa-clock"
            Case "confirmed"
                Return "fas fa-check-circle"
            Case "active"
                Return "fas fa-car"
            Case "completed"
                Return "fas fa-flag-checkered"
            Case "cancelled"
                Return "fas fa-times-circle"
            Case Else
                Return "fas fa-clock"
        End Select
    End Function

    ' Formats the delivery time into readable string
    Protected Function GetFormattedDeliveryTime(deliveryTime As Object) As String
        Try
            If deliveryTime IsNot Nothing AndAlso Not IsDBNull(deliveryTime) AndAlso
               Not String.IsNullOrEmpty(deliveryTime.ToString()) Then

                Dim timeValue As TimeSpan

                If TypeOf deliveryTime Is TimeSpan Then
                    timeValue = CType(deliveryTime, TimeSpan)
                ElseIf TypeOf deliveryTime Is DateTime Then
                    timeValue = CType(deliveryTime, DateTime).TimeOfDay
                Else
                    If TimeSpan.TryParse(deliveryTime.ToString(), timeValue) Then
                    Else
                        Return ""
                    End If
                End If

                Return String.Format("<div class='mt-2'><strong><i class='fas fa-clock me-1'></i>Delivery Time:</strong> {0:hh\:mm}</div>", timeValue)
            End If

            Return ""
        Catch ex As Exception
            Return ""
        End Try
    End Function

    ' Formats confirmed date
    Protected Function GetFormattedConfirmedDate(confirmedDate As Object) As String
        Try
            If confirmedDate IsNot Nothing AndAlso Not IsDBNull(confirmedDate) Then
                Dim confirmDate As DateTime = CDate(confirmedDate)
                Return String.Format("<div class='timeline-item'><strong>Confirmed:</strong> {0:dd MMM yyyy HH:mm}</div>", confirmDate)
            End If
            Return ""
        Catch ex As Exception
            Return ""
        End Try
    End Function

    ' Formats cancelled date with reason
    Protected Function GetFormattedCancelledDate(cancelledDate As Object, cancellationReason As Object) As String
        Try
            If cancelledDate IsNot Nothing AndAlso Not IsDBNull(cancelledDate) Then
                Dim cancelDate As DateTime = CDate(cancelledDate)
                Dim reasonText As String = ""

                If cancellationReason IsNot Nothing AndAlso Not IsDBNull(cancellationReason) AndAlso
                   Not String.IsNullOrEmpty(cancellationReason.ToString()) Then
                    reasonText = String.Format("<br><small>Reason: {0}</small>", cancellationReason.ToString())
                End If

                Return String.Format("<div class='timeline-item text-danger'><strong>Cancelled:</strong> {0:dd MMM yyyy HH:mm}{1}</div>",
                                   cancelDate, reasonText)
            End If
            Return ""
        Catch ex As Exception
            Return ""
        End Try
    End Function

    ' Displays a Bootstrap alert message on the page
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ' Auto-hide the alert after 5 seconds using JavaScript
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ " &
            "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
            "if(msgPanel) msgPanel.style.display = 'none'; " &
            "}, 5000);", True)
    End Sub

End Class