Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration

Public Class WebForm11
    Inherits System.Web.UI.Page

    ' Page Load Event - Executes when the page is first loaded
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security Check: Ensure only admin users can access this page
        If Session("Username") Is Nothing Or Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' Only load data on initial page load (not on postback events like button clicks)
        If Not IsPostBack Then
            LoadBookingStatistics()  ' Load statistics cards at the top
            LoadBookings()          ' Load the main bookings grid
        End If
    End Sub

    ' Method to load booking statistics for dashboard cards
    Private Sub LoadBookingStatistics()
        ' Get database connection string from web.config
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        ' Using statement ensures database connection is properly closed
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' Execute SQL queries to count bookings by different statuses

                ' Count total bookings
                Dim cmdTotal As New SqlCommand("SELECT COUNT(*) FROM Bookings", con)
                lblTotalBookings.Text = cmdTotal.ExecuteScalar().ToString()

                ' Count pending bookings (waiting for admin approval)
                Dim cmdPending As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Pending'", con)
                lblPendingBookings.Text = cmdPending.ExecuteScalar().ToString()

                ' Count confirmed bookings (approved by admin)
                Dim cmdConfirmed As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Confirmed'", con)
                lblConfirmedBookings.Text = cmdConfirmed.ExecuteScalar().ToString()

                ' Count active bookings (currently in use)
                Dim cmdActive As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Active'", con)
                lblActiveBookings.Text = cmdActive.ExecuteScalar().ToString()

                ' Count completed bookings (rental finished)
                Dim cmdCompleted As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Completed'", con)
                lblCompletedBookings.Text = cmdCompleted.ExecuteScalar().ToString()

                ' Count cancelled bookings
                Dim cmdCancelled As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Cancelled'", con)
                lblCancelledBookings.Text = cmdCancelled.ExecuteScalar().ToString()

            Catch ex As Exception
                ' Display error message if database operation fails
                ShowMessage("Error loading statistics: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' Method to load all bookings data into the GridView
    Private Sub LoadBookings()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' Build dynamic SQL query based on search filters
                Dim query As String = BuildBookingQuery()
                Dim cmd As New SqlCommand(query, con)

                ' Add parameters to prevent SQL injection attacks
                AddSearchParameters(cmd)

                ' Execute query and fill DataTable
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Bind data to GridView for display
                gvBookings.DataSource = dt
                gvBookings.DataBind()

            Catch ex As Exception
                ShowMessage("Error loading bookings: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' Method to build SQL query dynamically based on search filters
    Private Function BuildBookingQuery() As String
        ' Base query with JOIN statements to get related data
        Dim query As String = "SELECT b.BookingID, " &
                             "u.FirstName + ' ' + u.LastName as CustomerName, " &
                             "u.Email, u.Phone, " &
                             "mk.MakeName + ' ' + md.ModelName as VehicleName, " &
                             "v.LicensePlate, " &
                             "b.StartDate, b.EndDate, b.TotalDays, " &
                             "b.TotalAmount, b.Status, b.BookingDate, " &
                             "b.SpecialRequests " &
                             "FROM Bookings b " &
                             "INNER JOIN Users u ON b.UserID = u.UserID " &
                             "INNER JOIN Vehicles v ON b.VehicleID = v.VehicleID " &
                             "INNER JOIN Model md ON v.ModelID = md.ModelID " &
                             "INNER JOIN Make mk ON md.MakeID = mk.MakeID " &
                             "WHERE 1=1"  ' Always true condition to simplify adding filters

        ' Add WHERE clauses based on user input filters

        ' Search filter: Search in booking ID, customer name, or email
        If Not String.IsNullOrEmpty(txtSearch.Text.Trim()) Then
            query += " AND (b.BookingID LIKE @Search OR u.FirstName LIKE @Search OR u.LastName LIKE @Search OR u.Email LIKE @Search)"
        End If

        ' Status filter: Filter by booking status
        If ddlStatus.SelectedValue <> "All" Then
            query += " AND b.Status = @Status"
        End If

        ' Date range filters
        If Not String.IsNullOrEmpty(txtDateFrom.Text) Then
            query += " AND b.StartDate >= @DateFrom"
        End If

        If Not String.IsNullOrEmpty(txtDateTo.Text) Then
            query += " AND b.EndDate <= @DateTo"
        End If

        ' Order results by booking date (newest first)
        query += " ORDER BY b.BookingDate DESC"

        Return query
    End Function

    ' Method to add parameterized values to SQL command (prevents SQL injection)
    Private Sub AddSearchParameters(cmd As SqlCommand)
        ' Add search parameter with wildcard characters for LIKE operation
        If Not String.IsNullOrEmpty(txtSearch.Text.Trim()) Then
            cmd.Parameters.Add("@Search", SqlDbType.NVarChar).Value = "%" & txtSearch.Text.Trim() & "%"
        End If

        ' Add status filter parameter
        If ddlStatus.SelectedValue <> "All" Then
            cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = ddlStatus.SelectedValue
        End If

        ' Add date range parameters
        If Not String.IsNullOrEmpty(txtDateFrom.Text) Then
            cmd.Parameters.Add("@DateFrom", SqlDbType.Date).Value = DateTime.Parse(txtDateFrom.Text)
        End If

        If Not String.IsNullOrEmpty(txtDateTo.Text) Then
            cmd.Parameters.Add("@DateTo", SqlDbType.Date).Value = DateTime.Parse(txtDateTo.Text)
        End If
    End Sub

    ' Event handler for Search button click
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        LoadBookings()  ' Reload bookings with current filter criteria
    End Sub

    ' Event handler for Clear button click
    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ' Reset all filter controls to default values
        txtSearch.Text = ""
        ddlStatus.SelectedValue = "All"
        txtDateFrom.Text = ""
        txtDateTo.Text = ""
        LoadBookings()  ' Reload bookings without filters
    End Sub

    ' Event handler for GridView pagination
    Protected Sub gvBookings_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvBookings.PageIndexChanging
        gvBookings.PageIndex = e.NewPageIndex  ' Set new page index
        LoadBookings()  ' Reload data for new page
    End Sub

    ' Event handler for changing page size (number of records per page)
    Protected Sub ddlPageSize_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvBookings.PageSize = Integer.Parse(ddlPageSize.SelectedValue)  ' Set new page size
        gvBookings.PageIndex = 0  ' Reset to first page
        LoadBookings()  ' Reload data with new page size
    End Sub

    ' Event handler for GridView row commands (Confirm, Cancel, Complete buttons)
    Protected Sub gvBookings_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvBookings.RowCommand
        ' Get the booking ID from the command argument
        Dim bookingID As Integer = Convert.ToInt32(e.CommandArgument)

        ' Determine which action to perform based on command name
        Select Case e.CommandName
            Case "ConfirmBooking"
                UpdateBookingStatus(bookingID, "Confirmed")
            Case "CancelBooking"
                CancelBooking(bookingID)
            Case "CompleteBooking"
                UpdateBookingStatus(bookingID, "Completed")
        End Select
    End Sub

    ' Method to update booking status in database
    Private Sub UpdateBookingStatus(bookingID As Integer, newStatus As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' SQL command to update booking status and track who confirmed it
                Dim cmd As New SqlCommand("UPDATE Bookings SET Status = @Status, ConfirmedDate = @ConfirmedDate, ConfirmedBy = @ConfirmedBy WHERE BookingID = @BookingID", con)
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = newStatus
                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingID
                cmd.Parameters.Add("@ConfirmedBy", SqlDbType.Int).Value = Session("UserID")

                ' Set confirmation date only for confirmed bookings
                If newStatus = "Confirmed" Then
                    cmd.Parameters.Add("@ConfirmedDate", SqlDbType.DateTime).Value = DateTime.Now
                Else
                    cmd.Parameters.Add("@ConfirmedDate", SqlDbType.DateTime).Value = DBNull.Value
                End If

                ' Execute the update command
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                ' Check if update was successful
                If rowsAffected > 0 Then
                    ShowMessage($"Booking #{bookingID} has been {newStatus.ToLower()} successfully!", "alert-success")
                    LoadBookingStatistics()  ' Refresh statistics
                    LoadBookings()          ' Refresh booking list
                Else
                    ShowMessage("Failed to update booking status.", "alert-danger")
                End If

            Catch ex As Exception
                ShowMessage("Error updating booking: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' Method to cancel a booking with additional tracking information
    Private Sub CancelBooking(bookingID As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' SQL command to cancel booking and record cancellation details
                Dim cmd As New SqlCommand("UPDATE Bookings SET Status = 'Cancelled', CancelledDate = @CancelledDate, CancelledBy = @CancelledBy, CancellationReason = @Reason WHERE BookingID = @BookingID", con)
                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingID
                cmd.Parameters.Add("@CancelledDate", SqlDbType.DateTime).Value = DateTime.Now
                cmd.Parameters.Add("@CancelledBy", SqlDbType.Int).Value = Session("UserID")
                cmd.Parameters.Add("@Reason", SqlDbType.NVarChar).Value = "Cancelled by admin"

                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                If rowsAffected > 0 Then
                    ShowMessage($"Booking #{bookingID} has been cancelled successfully!", "alert-success")
                    LoadBookingStatistics()  ' Refresh statistics
                    LoadBookings()          ' Refresh booking list
                Else
                    ShowMessage("Failed to cancel booking.", "alert-danger")
                End If

            Catch ex As Exception
                ShowMessage("Error cancelling booking: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' Method to display success/error messages to user
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message  ' Set message text
        ' Set CSS classes for styling (Bootstrap alert classes)
        pnlMessage.CssClass = "position-fixed alert alert-dismissible fade show " & cssClass
        pnlMessage.Visible = True  ' Make message visible

        ' JavaScript to auto-hide message after 5 seconds
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ var alert = document.querySelector('.alert'); if(alert) alert.remove(); }, 5000);", True)
    End Sub

End Class