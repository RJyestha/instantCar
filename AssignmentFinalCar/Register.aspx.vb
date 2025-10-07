Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Text.RegularExpressions
Imports System.Security.Cryptography
Imports System.Text
Public Class WebForm3
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None

        ' Redirect user if already logged in
        If Session("Username") IsNot Nothing Then
            Response.Redirect("Default.aspx")
        End If

        ' Hide message panel and set DOB range only on first load
        If Not IsPostBack Then
            pnlMessage.Visible = False

            ' Set DOB validator range
            valDobRange.MinimumValue = "1900-01-01"
            valDobRange.MaximumValue = DateTime.Now.AddYears(-18).ToString("yyyy-MM-dd")
        End If
    End Sub

    ' Button click event when user clicks Register
    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegister.Click
        If Not Page.IsValid Then Exit Sub

        ' Collect user input
        Dim firstName As String = txtFirstName.Text.Trim()
        Dim lastName As String = txtLastName.Text.Trim()
        Dim username As String = txtUsername.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim password As String = txtPassword.Text
        Dim confirmPassword As String = txtConfirmPassword.Text
        Dim dateOfBirth As String = txtDateOfBirth.Text
        Dim gender As String = rblGender.SelectedValue
        Dim address As String = txtAddress.Text.Trim()

        ' Server-side password validation
        If Not IsValidPassword(password) Then
            ShowMessage("Invalid password format.", "alert-danger")
            Exit Sub
        End If

        If password <> confirmPassword Then
            ShowMessage("Passwords do not match.", "alert-danger")
            Exit Sub
        End If

        ' Check if username or email already exists
        If CheckUsernameExists(username) Then
            ShowMessage("Username already exists.", "alert-danger")
            Exit Sub
        End If

        If CheckEmailExists(email) Then
            ShowMessage("Email already registered.", "alert-danger")
            Exit Sub
        End If

        ' Insert new user into database
        Try
            Dim connStr = ConfigurationManager.ConnectionStrings("ConnStr").ToString()
            Using con As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("INSERT INTO Users (FirstName, LastName, Username, Email, Phone, Password, DateOfBirth, Gender, Address, UserType) 
                                           VALUES (@FirstName, @LastName, @Username, @Email, @Phone, @Password, @DateOfBirth, @Gender, @Address, @UserType)", con)

                cmd.Parameters.AddWithValue("@FirstName", firstName)
                cmd.Parameters.AddWithValue("@LastName", lastName)
                cmd.Parameters.AddWithValue("@Username", username)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Parameters.AddWithValue("@Password", HashPassword(password))
                cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(dateOfBirth))
                cmd.Parameters.AddWithValue("@Gender", gender)
                cmd.Parameters.AddWithValue("@Address", address)
                cmd.Parameters.AddWithValue("@UserType", "Client")

                con.Open()
                Dim result = cmd.ExecuteNonQuery()
                con.Close()

                If result > 0 Then
                    ShowMessage("Registration successful!", "alert-success")
                    ClientScript.RegisterStartupScript(Me.GetType(), "redirect", "setTimeout(function(){ window.location.href='Login.aspx'; }, 3000);", True)
                Else
                    ShowMessage("Registration failed. Please try again.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Check if username already exists
    Private Function CheckUsernameExists(username As String) As Boolean
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString()
        Using con As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Username=@Username", con)
            cmd.Parameters.AddWithValue("@Username", username)
            con.Open()
            Dim count = Convert.ToInt32(cmd.ExecuteScalar())
            Return count > 0
        End Using
    End Function

    ' Check if email already exists
    Private Function CheckEmailExists(email As String) As Boolean
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString()
        Using con As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@Email", con)
            cmd.Parameters.AddWithValue("@Email", email)
            con.Open()
            Dim count = Convert.ToInt32(cmd.ExecuteScalar())
            Return count > 0
        End Using
    End Function

    ' Validate password with regex: at least one uppercase, one lowercase, one digit, and 8+ characters
    Private Function IsValidPassword(password As String) As Boolean
        If password.Length < 8 Then Return False
        Dim hasUpper = Regex.IsMatch(password, "[A-Z]")
        Dim hasLower = Regex.IsMatch(password, "[a-z]")
        Dim hasDigit = Regex.IsMatch(password, "\d")
        Return hasUpper And hasLower And hasDigit
    End Function

    ' Hash the password using SHA256
    Private Function HashPassword(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim sb As New StringBuilder()
            For Each b In bytes
                sb.Append(b.ToString("x2"))
            Next
            Return sb.ToString()
        End Using
    End Function

    ' Display a message in the panel
    Private Sub ShowMessage(msg As String, cssClass As String)
        pnlMessage.Visible = True
        pnlMessage.CssClass = "alert " & cssClass
        lblMessage.Text = msg
    End Sub

End Class