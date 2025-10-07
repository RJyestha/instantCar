Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI.WebControls
Public Class WebForm9
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' ====== SECURITY CHECK ======
        ' Verify that user is logged in and has admin privileges before allowing access
        ' If not authenticated as admin, redirect to login page
        If Session("Username") Is Nothing Or Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' ====== INITIAL PAGE LOAD ======
        ' Only load data on first visit (not on postback events like button clicks)
        ' This prevents unnecessary database calls when user interacts with controls
        If Not IsPostBack Then
            LoadUserStatistics()  ' Load the statistics dashboard
            LoadUsers()          ' Load the main user data grid
        End If
    End Sub

    ' ====================================================================================================
    ' LOAD USER STATISTICS - DASHBOARD METRICS
    ' ====================================================================================================
    ' Executes multiple SQL queries to get user counts for the statistics dashboard
    ' Updates the labels that display Total, Active, Blocked, and Admin user counts
    ' ====================================================================================================
    Private Sub LoadUserStatistics()
        ' Get database connection string from web.config
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' ====== COUNT TOTAL USERS ======
                ' Simple count of all records in Users table
                Dim cmdTotal As New SqlCommand("SELECT COUNT(*) FROM Users", con)
                lblTotalUsers.Text = cmdTotal.ExecuteScalar().ToString()

                ' ====== COUNT ACTIVE USERS ======
                ' Count users where IsActive flag is true (1)
                Dim cmdActive As New SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 1", con)
                lblActiveUsers.Text = cmdActive.ExecuteScalar().ToString()

                ' ====== COUNT BLOCKED USERS ======
                ' Count users where IsActive flag is false (0)
                Dim cmdBlocked As New SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 0", con)
                lblBlockedUsers.Text = cmdBlocked.ExecuteScalar().ToString()

                ' ====== COUNT ADMIN USERS ======
                ' Count users with UserType set to 'Admin'
                Dim cmdAdmin As New SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'Admin'", con)
                lblAdminUsers.Text = cmdAdmin.ExecuteScalar().ToString()

            Catch ex As Exception
                ' If any database error occurs, show error message to user
                ShowMessage("Error loading user statistics: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' ====================================================================================================
    ' LOAD USERS - MAIN DATA GRID POPULATION
    ' ====================================================================================================
    ' Builds a dynamic SQL query based on current filter settings and populates the GridView
    ' This method handles all the filtering logic and data binding
    ' ====================================================================================================
    Private Sub LoadUsers()
        ' Get database connection string
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

        ' Build SQL query with current filter criteria
        Dim query As String = BuildUserQuery()

        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' Create command with the dynamic query
                Dim cmd As New SqlCommand(query, con)

                ' Add parameters based on current filter selections
                AddSearchParameters(cmd)

                ' Execute query and fill DataTable
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Bind data to GridView control
                gvUsers.DataSource = dt
                gvUsers.DataBind()

            Catch ex As Exception
                ' Handle any database errors
                ShowMessage("Error loading users: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' ====================================================================================================
    ' BUILD USER QUERY - DYNAMIC SQL CONSTRUCTION
    ' ====================================================================================================
    ' Constructs a SQL query string based on current filter settings
    ' Adds WHERE clauses dynamically depending on what filters are active
    ' ====================================================================================================
    Private Function BuildUserQuery() As String
        ' Base query selecting all necessary user fields
        Dim query As String = "SELECT UserID, FirstName, LastName, Username, Email, Phone, UserType, IsActive, CreatedDate FROM Users WHERE 1=1"

        ' ====== TEXT SEARCH FILTER ======
        ' If user entered search text, add LIKE clause for multiple fields
        If Not String.IsNullOrEmpty(txtSearchUser.Text.Trim()) Then
            query &= " AND (FirstName LIKE @SearchTerm OR LastName LIKE @SearchTerm OR Username LIKE @SearchTerm OR Email LIKE @SearchTerm)"
        End If

        ' ====== USER TYPE FILTER ======
        ' If specific user type selected (not "All"), add filter
        If ddlUserType.SelectedValue <> "All" Then
            query &= " AND UserType = @UserType"
        End If

        ' ====== STATUS FILTER ======
        ' If specific status selected (not "All"), add IsActive filter
        If ddlStatus.SelectedValue <> "All" Then
            query &= " AND IsActive = @IsActive"
        End If

        ' ====== DATE RANGE FILTER ======
        ' Add date filtering based on dropdown selection
        Select Case ddlDateFilter.SelectedValue
            Case "Today"
                ' Users registered today only
                query &= " AND CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)"
            Case "Week"
                ' Users registered in the last 7 days
                query &= " AND CreatedDate >= DATEADD(WEEK, -1, GETDATE())"
            Case "Month"
                ' Users registered in the last 30 days
                query &= " AND CreatedDate >= DATEADD(MONTH, -1, GETDATE())"
        End Select

        ' ====== SORTING ======
        ' Always sort by most recent registrations first
        query &= " ORDER BY CreatedDate DESC"

        Return query
    End Function

    ' ====================================================================================================
    ' ADD SEARCH PARAMETERS - SQL PARAMETER BINDING
    ' ====================================================================================================
    ' Adds parameters to the SQL command to prevent SQL injection attacks
    ' Only adds parameters that are actually being used in the query
    ' ====================================================================================================
    Private Sub AddSearchParameters(cmd As SqlCommand)

        ' ====== SEARCH TERM PARAMETER ======
        ' Add wildcard search parameter if search text was entered
        If Not String.IsNullOrEmpty(txtSearchUser.Text.Trim()) Then
            cmd.Parameters.Add("@SearchTerm", SqlDbType.NVarChar).Value = "%" & txtSearchUser.Text.Trim() & "%"
        End If

        ' ====== USER TYPE PARAMETER ======
        ' Add user type parameter if specific type selected
        If ddlUserType.SelectedValue <> "All" Then
            cmd.Parameters.Add("@UserType", SqlDbType.NVarChar).Value = ddlUserType.SelectedValue
        End If

        ' ====== STATUS PARAMETER ======
        ' Add boolean status parameter if specific status selected
        If ddlStatus.SelectedValue <> "All" Then
            cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = Convert.ToBoolean(ddlStatus.SelectedValue)
        End If
    End Sub

    ' ====================================================================================================
    ' SEARCH BUTTON CLICK EVENT
    ' ====================================================================================================
    ' Triggered when user clicks the "Search" button
    ' Reloads both the user list and statistics with current filter settings
    ' ====================================================================================================
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        LoadUsers()           ' Refresh user list with filters
        LoadUserStatistics()  ' Refresh statistics (filtered counts)
    End Sub

    ' ====================================================================================================
    ' CLEAR BUTTON CLICK EVENT
    ' ====================================================================================================
    ' Triggered when user clicks the "Clear" button
    ' Resets all filter controls to their default values and reloads data
    ' ====================================================================================================
    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ' Reset all filter controls to default state
        txtSearchUser.Text = ""                    ' Clear search text
        ddlUserType.SelectedValue = "All"          ' Reset to "All Users"
        ddlStatus.SelectedValue = "All"            ' Reset to "All Status"
        ddlDateFilter.SelectedValue = "All"        ' Reset to "All Time"

        ' Reload data without any filters
        LoadUsers()
        LoadUserStatistics()
    End Sub

    ' ====================================================================================================
    ' REGISTER ADMIN BUTTON CLICK EVENT
    ' ====================================================================================================
    ' Navigates to the admin registration page when button is clicked
    ' ====================================================================================================
    Protected Sub btnRegisterAdmin_Click(sender As Object, e As EventArgs) Handles btnRegisterAdmin.Click
        Response.Redirect("RegisterAdmin.aspx")
    End Sub

    ' ====================================================================================================
    ' GRIDVIEW PAGE CHANGING EVENT
    ' ====================================================================================================
    ' Handles pagination when user clicks on page numbers
    ' Maintains current filter settings while changing pages
    ' ====================================================================================================
    Protected Sub gvUsers_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvUsers.PageIndexChanging
        gvUsers.PageIndex = e.NewPageIndex  ' Set new page index
        LoadUsers()                         ' Reload data for new page
    End Sub

    ' ====================================================================================================
    ' PAGE SIZE DROPDOWN CHANGE EVENT
    ' ====================================================================================================
    ' Triggered when user changes the "Show X entries" dropdown
    ' Updates GridView page size and resets to first page
    ' ====================================================================================================
    Protected Sub ddlPageSize_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPageSize.SelectedIndexChanged
        gvUsers.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue)  ' Set new page size
        gvUsers.PageIndex = 0                                          ' Reset to first page
        LoadUsers()                                                    ' Reload data
    End Sub

    ' ====================================================================================================
    ' GRIDVIEW ROW COMMAND EVENT
    ' ====================================================================================================
    ' Handles clicks on action buttons within the GridView (Toggle Status, Upgrade Role)
    ' Routes the action to appropriate handler method based on CommandName
    ' ====================================================================================================
    Protected Sub gvUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvUsers.RowCommand
        Select Case e.CommandName
            Case "ToggleStatus"
                ' Handle Block/Unblock button clicks
                ToggleUserStatus(e.CommandArgument.ToString())
            Case "UpgradeRole"
                ' Handle Make Admin/Make Client button clicks
                UpgradeUserRole(e.CommandArgument.ToString())
        End Select
    End Sub

    ' ====================================================================================================
    ' TOGGLE USER STATUS - BLOCK/UNBLOCK FUNCTIONALITY
    ' ====================================================================================================
    ' Switches user status between Active (1) and Blocked (0)
    ' Receives CommandArgument containing "UserID,CurrentStatus" format
    ' ====================================================================================================
    Private Sub ToggleUserStatus(commandArg As String)
        ' ====== PARSE COMMAND ARGUMENT ======
        ' CommandArgument format: "UserID,IsActive" (e.g., "5,True")
        Dim args() As String = commandArg.Split(","c)
        Dim userId As Integer = Convert.ToInt32(args(0))      ' Extract User ID
        Dim currentStatus As Boolean = Convert.ToBoolean(args(1))  ' Extract current status
        Dim newStatus As Boolean = Not currentStatus         ' Toggle the status

        ' Get database connection
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' ====== UPDATE USER STATUS ======
                ' SQL command to update IsActive field for specific user
                Dim cmd As New SqlCommand("UPDATE Users SET IsActive = @IsActive WHERE UserID = @UserID", con)
                cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = newStatus
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId

                ' Execute the update command
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                ' ====== PROVIDE USER FEEDBACK ======
                If rowsAffected > 0 Then
                    ' Success: Show confirmation message and refresh data
                    Dim statusText As String = IIf(newStatus, "activated", "blocked").ToString()
                    ShowMessage("User has been " & statusText & " successfully.", "alert-success")
                    LoadUsers()           ' Refresh user list
                    LoadUserStatistics()  ' Refresh statistics
                Else
                    ' Failure: No rows were updated
                    ShowMessage("Failed to update user status.", "alert-danger")
                End If

            Catch ex As Exception
                ' Handle database errors
                ShowMessage("Error updating user status: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' ====================================================================================================
    ' UPGRADE USER ROLE - ADMIN/CLIENT ROLE SWITCHING
    ' ====================================================================================================
    ' Switches user role between "Client" and "Admin"
    ' Includes security check to prevent admins from changing their own role
    ' ====================================================================================================
    Private Sub UpgradeUserRole(commandArg As String)
        ' ====== PARSE COMMAND ARGUMENT ======
        ' CommandArgument format: "UserID,UserType" (e.g., "5,Client")
        Dim args() As String = commandArg.Split(","c)
        Dim userId As Integer = Convert.ToInt32(args(0))      ' Extract User ID
        Dim currentRole As String = args(1)                   ' Extract current role
        Dim newRole As String = IIf(currentRole = "Client", "Admin", "Client").ToString()  ' Toggle role

        ' ====== SECURITY CHECK ======
        ' Prevent admins from changing their own role (would lock them out)
        If userId = Convert.ToInt32(Session("UserID")) Then
            ShowMessage("You cannot change your own role.", "alert-warning")
            Return  ' Exit method without making changes
        End If

        ' Get database connection
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' ====== UPDATE USER ROLE ======
                ' SQL command to update UserType field for specific user
                Dim cmd As New SqlCommand("UPDATE Users SET UserType = @UserType WHERE UserID = @UserID", con)
                cmd.Parameters.Add("@UserType", SqlDbType.NVarChar).Value = newRole
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId

                ' Execute the update command
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                ' ====== PROVIDE USER FEEDBACK ======
                If rowsAffected > 0 Then
                    ' Success: Show confirmation and refresh data
                    ShowMessage("User role has been updated to " & newRole & " successfully.", "alert-success")
                    LoadUsers()           ' Refresh user list
                    LoadUserStatistics()  ' Refresh statistics (admin count changed)
                Else
                    ' Failure: No rows were updated
                    ShowMessage("Failed to update user role.", "alert-danger")
                End If

            Catch ex As Exception
                ' Handle database errors
                ShowMessage("Error updating user role: " & ex.Message, "alert-danger")
            End Try
        End Using
    End Sub

    ' ====================================================================================================
    ' SHOW MESSAGE - USER NOTIFICATION SYSTEM
    ' ====================================================================================================
    ' Displays feedback messages to users in a floating alert panel
    ' Supports different message types (success, error, warning) with appropriate styling
    ' ====================================================================================================
    Private Sub ShowMessage(message As String, cssClass As String)
        ' ====== SET MESSAGE CONTENT ======
        lblMessage.Text = message  ' Set the message text

        ' ====== SET MESSAGE STYLING ======
        ' Combine base CSS classes with specific alert type class
        pnlMessage.CssClass = "position-fixed alert alert-dismissible fade show " & cssClass

        ' ====== SHOW MESSAGE PANEL ======
        pnlMessage.Visible = True  ' Make the message panel visible

        ' ====== AUTO-HIDE MESSAGE ======
        ' JavaScript to automatically hide the message after 5 seconds
        ' This improves user experience by not requiring manual dismissal
        ClientScript.RegisterStartupScript(Me.GetType(), "AutoHideMessage",
            "setTimeout(function(){ document.querySelector('.alert').style.display = 'none'; }, 5000);", True)
    End Sub

End Class