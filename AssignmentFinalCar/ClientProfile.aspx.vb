Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text

Public Class WebForm17
    Inherits System.Web.UI.Page
    ' Connection string from Web.config
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    ' Page_Load runs when the page is loaded. Only runs the data-loading methods if this is not a postback.
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadUserProfile()     ' Load user profile data
            LoadTotalBookings()   ' Load total number of bookings
            LoadRecentActivity()  ' Load recent activity (bookings or updates)
        End If
    End Sub

    ' Loads user profile information from the Users table using the current session UserID
    Private Sub LoadUserProfile()
        Try
            Dim userID As Integer = CInt(Session("UserID"))
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim query As String = "SELECT FirstName, LastName, Username, Email, Phone, DateOfBirth, Gender, Address FROM Users WHERE UserID = @UserID"
                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@UserID", userID)

                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    ' Display data on labels and populate input fields
                    lblProfileName.Text = reader("FirstName") & " " & reader("LastName")
                    lblProfileEmail.Text = reader("Email").ToString()
                    lblProfileUsername.Text = reader("Username").ToString()

                    txtFirstName.Text = reader("FirstName").ToString()
                    txtLastName.Text = reader("LastName").ToString()
                    txtEmail.Text = reader("Email").ToString()
                    txtPhone.Text = reader("Phone").ToString()
                    txtUsername.Text = reader("Username").ToString()
                    txtAddress.Text = reader("Address").ToString()

                    ' Format date if available
                    If Not IsDBNull(reader("DateOfBirth")) Then
                        txtDateOfBirth.Text = CDate(reader("DateOfBirth")).ToString("yyyy-MM-dd")
                    End If
                    ' Set gender dropdown if available
                    If Not IsDBNull(reader("Gender")) Then
                        ddlGender.SelectedValue = reader("Gender").ToString()
                    End If
                End If
                reader.Close()
                lblMemberSince.Text = "2024" ' Static value - can be changed to actual member since date if needed
            End Using
        Catch ex As Exception
            ShowMessage("Error loading profile: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Loads the total number of bookings from Bookings table for the current user
    Private Sub LoadTotalBookings()
        Try
            Dim userID As Integer = CInt(Session("UserID"))
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE UserID = @UserID", con)
                cmd.Parameters.AddWithValue("@UserID", userID)
                lblTotalBookings.Text = cmd.ExecuteScalar().ToString()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading total bookings: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Loads recent booking activity and shows fixed profile update entries for the current user
    Private Sub LoadRecentActivity()
        Try
            Dim userID As Integer = CInt(Session("UserID"))
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim query As String = "SELECT TOP 5 'Booking Created' AS Activity, BookingDate AS ActivityDate " &
                                      "FROM Bookings WHERE UserID = @UserID " &
                                      "UNION ALL " &
                                      "SELECT TOP 3 'Profile Updated' AS Activity, GETDATE() AS ActivityDate " &
                                      "ORDER BY ActivityDate DESC"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@UserID", userID)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Bind results to the Repeater control
                If dt.Rows.Count > 0 Then
                    rptRecentActivity.DataSource = dt
                    rptRecentActivity.DataBind()
                    pnlNoActivity.Visible = False
                Else
                    pnlNoActivity.Visible = True
                End If
            End Using
        Catch ex As Exception
            pnlNoActivity.Visible = True ' If error occurs, hide activity section
        End Try
    End Sub

    ' Triggered when Save button is clicked
    Protected Sub btnSaveProfile_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveProfile.Click
        If Page.IsValid Then ' Ensure all validation controls pass
            If ValidateCurrentPassword(txtCurrentPassword.Text) Then
                UpdateProfile() ' If current password is correct, proceed to update
            Else
                ShowMessage("Current password is incorrect", "alert-danger")
            End If
        End If
    End Sub

    ' Triggered when Cancel button is clicked. Reloads original data.
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        LoadUserProfile()
        ShowMessage("Changes cancelled", "alert-info")
    End Sub

    ' Validates if the input current password matches the one in the database after hashing
    Private Function ValidateCurrentPassword(password As String) As Boolean
        Try
            Dim userID As Integer = CInt(Session("UserID"))
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT Password FROM Users WHERE UserID = @UserID", con)
                cmd.Parameters.AddWithValue("@UserID", userID)
                Dim storedPassword As String = cmd.ExecuteScalar()?.ToString()

                If String.IsNullOrEmpty(storedPassword) Then Return False
                Return storedPassword = HashPassword(password)
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

    ' Custom validator for new password strength
    Protected Sub ValidatePasswordStrength(source As Object, args As ServerValidateEventArgs)
        Dim pwd As String = args.Value

        If pwd.Length = 0 Then
            args.IsValid = True ' No new password entered, allow it
            Return
        End If

        ' Password must meet criteria
        Dim hasUpper As Boolean = Regex.IsMatch(pwd, "[A-Z]")
        Dim hasLower As Boolean = Regex.IsMatch(pwd, "[a-z]")
        Dim hasDigit As Boolean = Regex.IsMatch(pwd, "\d")
        Dim validLength As Boolean = pwd.Length >= 8

        args.IsValid = validLength AndAlso hasUpper AndAlso hasLower AndAlso hasDigit
    End Sub

    ' Updates the user profile fields in the database, including optional password change
    Private Sub UpdateProfile()
        Try
            Dim userID As Integer = CInt(Session("UserID"))
            Using con As New SqlConnection(connStr)
                con.Open()

                ' Base query with conditional password update
                Dim query As String = "UPDATE Users SET FirstName=@FirstName, LastName=@LastName, Email=@Email, Phone=@Phone, DateOfBirth=@DateOfBirth, Gender=@Gender, Address=@Address"
                If Not String.IsNullOrEmpty(txtNewPassword.Text) Then
                    query &= ", Password=@Password"
                End If
                query &= " WHERE UserID=@UserID"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim())
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim())
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue)
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@UserID", userID)

                ' Add date of birth if available
                If Not String.IsNullOrEmpty(txtDateOfBirth.Text) Then
                    cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(txtDateOfBirth.Text))
                Else
                    cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value)
                End If

                ' Add new password if provided
                If Not String.IsNullOrEmpty(txtNewPassword.Text) Then
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtNewPassword.Text))
                End If

                ' Execute the query and confirm update
                If cmd.ExecuteNonQuery() > 0 Then
                    ' Update session values
                    Session("FirstName") = txtFirstName.Text
                    Session("LastName") = txtLastName.Text
                    Session("Email") = txtEmail.Text
                    ShowMessage("Profile updated successfully!", "alert-success")

                    ' Clear password fields
                    txtCurrentPassword.Text = ""
                    txtNewPassword.Text = ""
                    txtConfirmPassword.Text = ""

                    LoadUserProfile()
                Else
                    ShowMessage("Update failed. Try again.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error updating profile: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Hashes a password using SHA256 for secure storage
    Private Function HashPassword(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha256.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim builder As New StringBuilder()
            For Each b In bytes
                builder.Append(b.ToString("x2")) ' Convert to hexadecimal string
            Next
            Return builder.ToString()
        End Using
    End Function

    ' Displays a styled message on the page using Bootstrap classes
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ' Auto-hide after 5 seconds using JavaScript
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ document.getElementById('" & pnlMessage.ClientID & "').style.display='none'; }, 5000);", True)
    End Sub
End Class