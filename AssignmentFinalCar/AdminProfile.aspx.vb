Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text
Imports System.Text.RegularExpressions

Public Class WebForm19
    Inherits System.Web.UI.Page

    ' Connection string retrieved from web.config for database operations
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    ''' <summary>
    ''' Page Load Event - Executes when the page is first loaded or on postback
    ''' Handles security checks and initial data loading
    ''' </summary>
    ''' <param name="sender">The source of the event</param>
    ''' <param name="e">Event arguments</param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security Check: Verify user is logged in and has admin privileges
        If Session("UserID") Is Nothing OrElse Session("UserType") <> "Admin" Then
            ' Redirect unauthorized users to login page
            Response.Redirect("Login.aspx")
            Return
        End If

        ' Only load data on initial page load, not on postbacks (form submissions)
        If Not IsPostBack Then
            LoadAdminProfile()        ' Load admin personal information
            LoadSystemStatistics()   ' Load system statistics
            LoadAdminActivity()      ' Load recent admin activities
        End If
    End Sub

    ''' <summary>
    ''' Loads the current admin's profile information from the database
    ''' Populates all form fields and header display labels
    ''' </summary>
    Private Sub LoadAdminProfile()
        Try
            ' Get current admin's ID from session
            Dim adminID As Integer = CInt(Session("UserID"))

            ' Create database connection
            Using con As New SqlConnection(connStr)
                con.Open()

                ' SQL query to retrieve admin profile data
                Dim query As String = "SELECT FirstName, LastName, Username, Email, Phone, " &
                                    "DateOfBirth, Gender, Address, CreatedDate " &
                                    "FROM Users WHERE UserID = @UserID AND UserType = 'Admin'"

                ' Create and configure SQL command
                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@UserID", adminID)

                ' Execute query and read results
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    ' Populate header information labels
                    lblAdminName.Text = reader("FirstName").ToString() & " " & reader("LastName").ToString()
                    lblAdminEmail.Text = reader("Email").ToString()
                    lblAdminUsername.Text = reader("Username").ToString()

                    ' Populate form input fields
                    txtFirstName.Text = reader("FirstName").ToString()
                    txtLastName.Text = reader("LastName").ToString()
                    txtEmail.Text = reader("Email").ToString()
                    txtPhone.Text = reader("Phone").ToString()
                    txtUsername.Text = reader("Username").ToString()
                    txtAddress.Text = reader("Address").ToString()

                    ' Handle optional date field (check for null values)
                    If Not IsDBNull(reader("DateOfBirth")) Then
                        txtDateOfBirth.Text = CDate(reader("DateOfBirth")).ToString("yyyy-MM-dd")
                    End If

                    ' Handle optional gender field
                    If Not IsDBNull(reader("Gender")) Then
                        ddlGender.SelectedValue = reader("Gender").ToString()
                    End If

                    ' Set admin since date for display
                    If Not IsDBNull(reader("CreatedDate")) Then
                        lblAdminSince.Text = CDate(reader("CreatedDate")).ToString("yyyy")
                    Else
                        lblAdminSince.Text = "2024" ' Default fallback year
                    End If
                End If
                reader.Close()
            End Using

        Catch ex As Exception
            ' Handle any errors during profile loading
            ShowMessage("Error loading admin profile: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ''' <summary>
    ''' Loads system statistics from the database for dashboard display
    ''' Calculates totals for users, vehicles, bookings, and admin actions
    ''' </summary>
    Private Sub LoadSystemStatistics()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                ' Get total active users count
                Dim userCmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 1", con)
                lblTotalUsers.Text = userCmd.ExecuteScalar().ToString()

                ' Get total active vehicles count
                Dim vehicleCmd As New SqlCommand("SELECT COUNT(*) FROM Vehicles WHERE IsActive = 1", con)
                lblTotalVehicles.Text = vehicleCmd.ExecuteScalar().ToString()

                ' Get active bookings count (confirmed or active status)
                Dim bookingCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status IN ('Active', 'Confirmed')", con)
                lblActiveBookings.Text = bookingCmd.ExecuteScalar().ToString()

                ' Get pending approvals count
                Dim pendingCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Pending'", con)
                lblPendingApprovals.Text = pendingCmd.ExecuteScalar().ToString()

                ' Get total admin actions count for current admin
                Dim adminID As Integer = CInt(Session("UserID"))
                Dim actionsCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE ConfirmedBy = @AdminID OR CancelledBy = @AdminID", con)
                actionsCmd.Parameters.AddWithValue("@AdminID", adminID)
                lblTotalActions.Text = actionsCmd.ExecuteScalar().ToString()
            End Using

        Catch ex As Exception
            ' Handle any errors during statistics loading
            ShowMessage("Error loading system statistics: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ''' <summary>
    ''' Loads recent admin activities for the activity timeline
    ''' Combines data from multiple tables to show comprehensive admin actions
    ''' </summary>
    Private Sub LoadAdminActivity()
        Try
            Dim adminID As Integer = CInt(Session("UserID"))

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Complex query to get recent admin activities from multiple sources
                Dim query As String = "SELECT TOP 5 'Vehicle Added' as Action, " &
                                    "'Added new vehicle: ' + COALESCE(M.MakeName, 'Unknown') + ' ' + COALESCE(Mo.ModelName, 'Model') as Description, " &
                                    "V.CreatedDate as ActionDate " &
                                    "FROM Vehicles V " &
                                    "LEFT JOIN Model Mo ON V.ModelID = Mo.ModelID " &
                                    "LEFT JOIN Make M ON Mo.MakeID = M.MakeID " &
                                    "WHERE V.CreatedBy = @AdminID " &
                                    "UNION ALL " &
                                    "SELECT TOP 3 'Booking Confirmed' as Action, " &
                                    "'Confirmed booking for ' + U.FirstName + ' ' + U.LastName as Description, " &
                                    "B.ConfirmedDate as ActionDate " &
                                    "FROM Bookings B " &
                                    "INNER JOIN Users U ON B.UserID = U.UserID " &
                                    "WHERE B.ConfirmedBy = @AdminID AND B.ConfirmedDate IS NOT NULL " &
                                    "UNION ALL " &
                                    "SELECT TOP 2 'Admin Registered' as Action, " &
                                    "'Registered new admin: ' + U.FirstName + ' ' + U.LastName as Description, " &
                                    "U.CreatedDate as ActionDate " &
                                    "FROM Users U " &
                                    "WHERE U.UserType = 'Admin' AND U.UserID <> @AdminID " &
                                    "ORDER BY ActionDate DESC"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@AdminID", adminID)

                ' Fill DataTable with results
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Bind data to repeater or show no activity message
                If dt.Rows.Count > 0 Then
                    rptAdminActivity.DataSource = dt
                    rptAdminActivity.DataBind()
                    pnlNoActivity.Visible = False
                Else
                    pnlNoActivity.Visible = True
                End If
            End Using

        Catch ex As Exception
            ' Handle errors gracefully by showing no activity panel
            pnlNoActivity.Visible = True
        End Try
    End Sub

    ''' <summary>
    ''' Save Profile Button Click Event Handler
    ''' Validates form data and updates admin profile if validation passes
    ''' </summary>
    ''' <param name="sender">The button that was clicked</param>
    ''' <param name="e">Event arguments</param>
    Protected Sub btnSaveProfile_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveProfile.Click
        ' Check if page validation is valid (all ASP.NET validators pass)
        If Page.IsValid Then
            UpdateAdminProfile() ' Update the profile in database
        End If
    End Sub

    ''' <summary>
    ''' Cancel Button Click Event Handler
    ''' Reloads original data and clears any validation messages
    ''' </summary>
    ''' <param name="sender">The button that was clicked</param>
    ''' <param name="e">Event arguments</param>
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        LoadAdminProfile() ' Reload original data from database
        ShowMessage("Changes cancelled", "alert-info")
    End Sub

    ''' <summary>
    ''' Custom Validator for Email Uniqueness
    ''' Checks if the entered email is already in use by another user
    ''' </summary>
    ''' <param name="source">The validator control</param>
    ''' <param name="args">Validation arguments containing the value to validate</param>
    Protected Sub ValidateUniqueEmail(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Try
            Dim adminID As Integer = CInt(Session("UserID"))
            Dim email As String = args.Value.Trim()

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Check if email exists for other users (excluding current admin)
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserID <> @UserID", con)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@UserID", adminID)

                ' Set validation result
                args.IsValid = (CInt(cmd.ExecuteScalar()) = 0)
            End Using

        Catch ex As Exception
            ' If error occurs, assume email is valid to prevent blocking legitimate updates
            args.IsValid = True
        End Try
    End Sub

    ''' <summary>
    ''' Custom Validator for Current Password Verification
    ''' Verifies that the entered current password matches the stored password
    ''' </summary>
    ''' <param name="source">The validator control</param>
    ''' <param name="args">Validation arguments containing the password to validate</param>
    Protected Sub ValidateCurrentPassword(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Try
            Dim adminID As Integer = CInt(Session("UserID"))
            Dim currentPassword As String = args.Value

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Get stored password hash from database
                Dim cmd As New SqlCommand("SELECT Password FROM Users WHERE UserID = @UserID AND UserType = 'Admin'", con)
                cmd.Parameters.AddWithValue("@UserID", adminID)

                Dim storedPassword As String = cmd.ExecuteScalar()?.ToString()

                ' Validate password by comparing hashes
                If Not String.IsNullOrEmpty(storedPassword) Then
                    Dim hashedInputPassword As String = HashPassword(currentPassword)
                    args.IsValid = (storedPassword = hashedInputPassword)
                Else
                    args.IsValid = False
                End If
            End Using

        Catch ex As Exception
            ' If error occurs, mark as invalid for security
            args.IsValid = False
        End Try
    End Sub

    ''' <summary>
    ''' Updates the admin profile information in the database
    ''' Handles both personal information and optional password updates
    ''' </summary>
    Private Sub UpdateAdminProfile()
        Try
            Dim adminID As Integer = CInt(Session("UserID"))

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Build base update query for personal information
                Dim query As String = "UPDATE Users SET FirstName = @FirstName, LastName = @LastName, " &
                                    "Email = @Email, Phone = @Phone, DateOfBirth = @DateOfBirth, " &
                                    "Gender = @Gender, Address = @Address"

                ' Add password update if new password is provided
                If Not String.IsNullOrEmpty(txtNewPassword.Text.Trim()) Then
                    query &= ", Password = @Password"
                End If

                query &= " WHERE UserID = @UserID AND UserType = 'Admin'"

                ' Create and configure SQL command
                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim())
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim())
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue)
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@UserID", adminID)

                ' Handle optional date of birth field
                If Not String.IsNullOrEmpty(txtDateOfBirth.Text) Then
                    cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(txtDateOfBirth.Text))
                Else
                    cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value)
                End If

                ' Add password parameter if new password provided
                If Not String.IsNullOrEmpty(txtNewPassword.Text.Trim()) Then
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtNewPassword.Text))
                End If

                ' Execute update and check if successful
                If cmd.ExecuteNonQuery() > 0 Then
                    ' Update session variables with new information
                    Session("FirstName") = txtFirstName.Text.Trim()
                    Session("LastName") = txtLastName.Text.Trim()
                    Session("Email") = txtEmail.Text.Trim()

                    ShowMessage("Admin profile updated successfully!", "alert-success")

                    ' Clear password fields for security
                    txtCurrentPassword.Text = ""
                    txtNewPassword.Text = ""
                    txtConfirmPassword.Text = ""

                    ' Reload profile data to reflect changes
                    LoadAdminProfile()
                    LoadSystemStatistics() ' Refresh statistics as well
                Else
                    ShowMessage("Failed to update admin profile. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ' Handle any database or processing errors
            ShowMessage("Error updating admin profile: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ''' <summary>
    ''' Validates email address format using regular expression
    ''' </summary>
    ''' <param name="email">Email address to validate</param>
    ''' <returns>True if email format is valid, False otherwise</returns>
    Private Function IsValidEmail(email As String) As Boolean
        Dim emailPattern As String = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        Return Regex.IsMatch(email, emailPattern)
    End Function

    ''' <summary>
    ''' Validates phone number format and length
    ''' Removes non-digit characters and checks length
    ''' </summary>
    ''' <param name="phone">Phone number to validate</param>
    ''' <returns>True if phone format is valid, False otherwise</returns>
    Private Function IsValidPhone(phone As String) As Boolean
        ' Remove all non-digit characters for validation
        Dim cleanPhone As String = Regex.Replace(phone, "[^\d]", "")
        ' Check if length is within acceptable range (8-15 digits)
        Return cleanPhone.Length >= 8 And cleanPhone.Length <= 15
    End Function

    ''' <summary>
    ''' Validates password strength requirements
    ''' Checks for minimum length, uppercase, lowercase, and digit requirements
    ''' </summary>
    ''' <param name="password">Password to validate</param>
    ''' <returns>True if password meets strength requirements, False otherwise</returns>
    Private Function IsValidPassword(password As String) As Boolean
        ' Check minimum length requirement
        If password.Length < 8 Then Return False

        ' Check for required character types
        Dim hasUpper As Boolean = Regex.IsMatch(password, "[A-Z]")    ' Uppercase letter
        Dim hasLower As Boolean = Regex.IsMatch(password, "[a-z]")    ' Lowercase letter
        Dim hasDigit As Boolean = Regex.IsMatch(password, "\d")       ' Digit

        ' Return true only if all requirements are met
        Return hasUpper And hasLower And hasDigit
    End Function

    ''' <summary>
    ''' Hashes password using SHA256 algorithm for secure storage
    ''' </summary>
    ''' <param name="password">Plain text password to hash</param>
    ''' <returns>SHA256 hash of the password as hexadecimal string</returns>
    Private Function HashPassword(password As String) As String
        ' Use SHA256 hashing algorithm
        Using sha256Hash As SHA256 = SHA256.Create()
            ' Convert password to bytes and compute hash
            Dim bytes As Byte() = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password))

            ' Convert hash bytes to hexadecimal string
            Dim builder As New StringBuilder()
            For i As Integer = 0 To bytes.Length - 1
                builder.Append(bytes(i).ToString("x2"))
            Next
            Return builder.ToString()
        End Using
    End Function

    ''' <summary>
    ''' Displays a message to the user using the message panel
    ''' Automatically hides the message after 5 seconds using JavaScript
    ''' </summary>
    ''' <param name="message">Message text to display</param>
    ''' <param name="cssClass">Bootstrap CSS class for message styling (alert-success, alert-danger, etc.)</param>
    Private Sub ShowMessage(message As String, cssClass As String)
        ' Set message content and styling
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ' Register JavaScript to auto-hide message after 5 seconds
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ " &
            "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
            "if(msgPanel) msgPanel.style.display = 'none'; " &
            "}, 5000);", True)
    End Sub

End Class