Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI.WebControls
Public Class WebForm6
    Inherits System.Web.UI.Page

    ' Page Load event
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Redirect non-admins to login
        If Session("Username") Is Nothing OrElse Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' Only load data on initial load, not on postback
        If Not IsPostBack Then
            LoadDashboardData()
        End If
    End Sub

    ' Main function to load all dashboard data
    Private Sub LoadDashboardData()
        Try
            LoadStatistics()
            LoadRecentActivity()
            LoadRecentUsers()
            LoadPendingActions()
            UpdateProgressBars()
        Catch ex As Exception
            ShowMessage("Error loading dashboard data: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Loads core counts and values from the database
    Private Sub LoadStatistics()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        Using con As New SqlConnection(connStr)
            con.Open()

            ' Total Users
            Dim cmdUsers As New SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'Client'", con)
            lblTotalUsers.Text = cmdUsers.ExecuteScalar().ToString()

            ' Total Vehicles
            Dim cmdVehicles As New SqlCommand("SELECT COUNT(*) FROM Vehicles", con)
            lblTotalVehicles.Text = cmdVehicles.ExecuteScalar().ToString()

            ' Available Vehicles
            Dim cmdAvailable As New SqlCommand("SELECT COUNT(*) FROM Vehicles WHERE Status = 'Available'", con)
            lblAvailableVehicles.Text = cmdAvailable.ExecuteScalar().ToString()

            ' Active Bookings
            Dim cmdBookings As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Active' OR Status = 'Confirmed'", con)
            lblActiveBookings.Text = cmdBookings.ExecuteScalar().ToString()

            ' Monthly Revenue
            Dim cmdRevenue As New SqlCommand("SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE MONTH(BookingDate) = MONTH(GETDATE()) AND YEAR(BookingDate) = YEAR(GETDATE())", con)
            lblMonthlyRevenue.Text = Convert.ToDecimal(cmdRevenue.ExecuteScalar()).ToString("N0")

            ' Active Clients
            Dim cmdActiveClients As New SqlCommand("SELECT COUNT(DISTINCT UserID) FROM Bookings WHERE Status = 'Active' OR Status = 'Confirmed'", con)
            lblActiveClients.Text = cmdActiveClients.ExecuteScalar().ToString()
        End Using
    End Sub

    ' Loads sample recent activity list (replace with DB version later)
    Private Sub LoadRecentActivity()
        Dim activities As New List(Of ActivityItem) From {
            New ActivityItem With {.ActivityType = "New User Registration", .Description = "A new client has registered to the system", .ActivityDate = DateTime.Now.AddHours(-2)},
            New ActivityItem With {.ActivityType = "Vehicle Added", .Description = "New vehicle 'Toyota Camry' added to fleet", .ActivityDate = DateTime.Now.AddHours(-5)},
            New ActivityItem With {.ActivityType = "Booking Completed", .Description = "Booking #1234 has been completed successfully", .ActivityDate = DateTime.Now.AddHours(-8)},
            New ActivityItem With {.ActivityType = "Payment Received", .Description = "Payment of Rs. 15,000 received for booking #1233", .ActivityDate = DateTime.Now.AddDays(-1)},
            New ActivityItem With {.ActivityType = "User Account Blocked", .Description = "User account 'john_doe' has been temporarily blocked", .ActivityDate = DateTime.Now.AddDays(-2)}
        }

        ' Bind to repeater
        rptRecentActivity.DataSource = activities
        rptRecentActivity.DataBind()

        ' Update count badge
        lblActivityCount.Text = activities.Count.ToString()
    End Sub

    ' Loads recent registered users
    Private Sub LoadRecentUsers()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        Using con As New SqlConnection(connStr)
            Try
                con.Open()
                Dim cmd As New SqlCommand("SELECT TOP 5 FirstName + ' ' + LastName AS FirstName, Email, UserType, CreatedDate AS RegistrationDate FROM Users ORDER BY CreatedDate DESC", con)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                gvRecentUsers.DataSource = dt
                gvRecentUsers.DataBind()
            Catch ex As Exception
                ' Use sample data as fallback
                Dim sample As New DataTable()
                sample.Columns.Add("FirstName")
                sample.Columns.Add("Email")
                sample.Columns.Add("UserType")
                sample.Columns.Add("RegistrationDate", GetType(DateTime))

                sample.Rows.Add("John Doe", "john@email.com", "Client", DateTime.Now.AddDays(-1))
                sample.Rows.Add("Jane Smith", "jane@email.com", "Client", DateTime.Now.AddDays(-2))

                gvRecentUsers.DataSource = sample
                gvRecentUsers.DataBind()
            End Try
        End Using
    End Sub

    ' Loads pending actions: bookings, new users, maintenance
    Private Sub LoadPendingActions()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        Using con As New SqlConnection(connStr)
            con.Open()

            ' Pending bookings
            Dim cmdPending As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Pending'", con)
            lblPendingBookings.Text = cmdPending.ExecuteScalar().ToString()

            ' New registrations this week
            Dim cmdNewUsers As New SqlCommand("SELECT COUNT(*) FROM Users WHERE CreatedDate >= DATEADD(day, -7, GETDATE())", con)
            lblNewRegistrations.Text = cmdNewUsers.ExecuteScalar().ToString()

            ' Placeholder for maintenance
            lblMaintenanceDue.Text = "2"
        End Using
    End Sub

    ' Refresh button click
    Protected Sub btnRefreshData_Click(sender As Object, e As EventArgs) Handles btnRefreshData.Click
        LoadDashboardData()
        ShowMessage("Dashboard data refreshed successfully!", "alert-success")
    End Sub

    ' Navigation buttons
    Protected Sub btnAddVehicle_Click(sender As Object, e As EventArgs) Handles btnAddVehicles.Click
        Response.Redirect("AddVehicles.aspx")
    End Sub

    Protected Sub btnRegisterAdmin_Click(sender As Object, e As EventArgs) Handles btnRegisterAdmin.Click
        Response.Redirect("RegisterAdmin.aspx")
    End Sub

    Protected Sub btnManageUsers_Click(sender As Object, e As EventArgs) Handles btnManageUsers.Click
        Response.Redirect("ManageUsers.aspx")
    End Sub

    Protected Sub btnManageBookings_Click(sender As Object, e As EventArgs) Handles btnManageBookings.Click
        Response.Redirect("ManageBookings.aspx")
    End Sub

    ' Update progress bars with calculated percentages
    Private Sub UpdateProgressBars()
        Try
            Dim availablePct As Integer = GetAvailableVehiclePercentage()
            progressAvailable.Style("width") = availablePct & "%"
            progressAvailable.Attributes("aria-valuenow") = availablePct.ToString()

            Dim clientPct As Integer = GetActiveClientPercentage()
            progressClients.Style("width") = clientPct & "%"
            progressClients.Attributes("aria-valuenow") = clientPct.ToString()
        Catch
            ' Silent catch (log if needed)
        End Try
    End Sub

    ' Calculate available vehicle %
    Public Function GetAvailableVehiclePercentage() As Integer
        Try
            Dim total As Integer = Integer.Parse(lblTotalVehicles.Text)
            Dim available As Integer = Integer.Parse(lblAvailableVehicles.Text)
            If total > 0 Then
                Return (available * 100) \ total
            End If
        Catch
        End Try
        Return 0
    End Function

    ' Calculate active client %
    Public Function GetActiveClientPercentage() As Integer
        Try
            Dim total As Integer = Integer.Parse(lblTotalUsers.Text)
            Dim active As Integer = Integer.Parse(lblActiveClients.Text)
            If total > 0 Then
                Return (active * 100) \ total
            End If
        Catch
        End Try
        Return 0
    End Function

    ' Show alert message
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "alert alert-dismissible fade show " & cssClass
        pnlMessage.Visible = True
    End Sub

    ' Class used to bind recent activity
    Public Class ActivityItem
        Public Property ActivityType As String
        Public Property Description As String
        Public Property ActivityDate As DateTime
    End Class

End Class