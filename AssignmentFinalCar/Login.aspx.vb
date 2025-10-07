Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text

Public Class WebForm2
    Inherits System.Web.UI.Page

    ' Executes when the page loads
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' If already logged in, redirect based on user type
        If Session("Username") IsNot Nothing Then
            If Session("UserType") = "Admin" Then
                Response.Redirect("AdminDashboard.aspx")
            Else
                Response.Redirect("ClientHome.aspx")
            End If
        End If

        ' Hide error panel on first load
        If Not IsPostBack Then
            pnlMessage.Visible = False
        End If
    End Sub

    ' Handles login button click
    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogin.Click
        ' Ensure all validators are passed before processing
        If Page.IsValid Then
            Dim username As String = txtUsername.Text.Trim()
            Dim password As String = txtPassword.Text.Trim()

            ' Check credentials
            Dim userInfo As UserInfo = ValidateUser(username, password)

            If userInfo IsNot Nothing Then
                ' Store user info in session
                Session("Username") = userInfo.Username
                Session("UserType") = userInfo.UserType
                Session("UserID") = userInfo.UserID
                Session("FirstName") = userInfo.FirstName
                Session("LastName") = userInfo.LastName
                Session("Email") = userInfo.Email
                Session("LoginTime") = DateTime.Now

                ' Redirect user based on role
                If userInfo.UserType = "Admin" Then
                    ShowMessage("Login successful! Redirecting to Admin Dashboard...", "alert-success")
                    ClientScript.RegisterStartupScript(Me.GetType(), "redirect", "setTimeout(function(){ window.location.href='AdminDashboard.aspx'; }, 2000);", True)
                Else
                    ShowMessage("Login successful! Redirecting to Home...", "alert-success")
                    ClientScript.RegisterStartupScript(Me.GetType(), "redirect", "setTimeout(function(){ window.location.href='ClientHome.aspx'; }, 2000);", True)
                End If
            Else
                ' Show error message
                ShowMessage("Invalid username or password. Please try again.", "alert-danger")
            End If
        End If
    End Sub

    ' Redirects to registration page
    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegister.Click
        Response.Redirect("Register.aspx")
    End Sub

    ' Validates credentials against database
    Private Function ValidateUser(ByVal username As String, ByVal password As String) As UserInfo
        Dim connStr As String = GetConnectionString()
        Dim con As New SqlConnection(connStr)
        Dim cmd As New SqlCommand
        Dim reader As SqlDataReader = Nothing
        Dim userInfo As UserInfo = Nothing

        Try
            con.Open()
            cmd.CommandText = "SELECT UserID, FirstName, LastName, Username, Email, Password, UserType FROM Users WHERE Username = @Username"
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar).Value = username
            cmd.Connection = con

            reader = cmd.ExecuteReader()

            If reader.Read() Then
                Dim storedPassword As String = reader("Password").ToString()
                Dim hashedInputPassword As String = HashPassword(password)

                ' Match the hashed password
                If storedPassword = hashedInputPassword Then
                    userInfo = New UserInfo With {
                        .UserID = Convert.ToInt32(reader("UserID")),
                        .FirstName = reader("FirstName").ToString(),
                        .LastName = reader("LastName").ToString(),
                        .Username = reader("Username").ToString(),
                        .Email = reader("Email").ToString(),
                        .UserType = reader("UserType").ToString()
                    }
                End If
            End If
        Catch ex As Exception
            ' Error handling can be improved (e.g., logging)
        Finally
            If reader IsNot Nothing Then reader.Close()
            If con.State = ConnectionState.Open Then con.Close()
        End Try

        Return userInfo
    End Function

    ' Fetches connection string from web.config
    Private Function GetConnectionString() As String
        Dim connectionString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("ConnStr")
        If connectionString Is Nothing Then
            Throw New Exception("Connection string 'ConnStr' not found in web.config")
        End If
        Return connectionString.ConnectionString
    End Function

    ' Hashes password using SHA256
    Private Function HashPassword(password As String) As String
        Using sha256Hash As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim builder As New StringBuilder()
            For i As Integer = 0 To bytes.Length - 1
                builder.Append(bytes(i).ToString("x2"))
            Next
            Return builder.ToString()
        End Using
    End Function

    ' Displays a message in the UI
    Private Sub ShowMessage(ByVal message As String, ByVal cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "alert " & cssClass
        pnlMessage.Visible = True
    End Sub

    ' Data class to hold user details
    Public Class UserInfo
        Public Property UserID As Integer
        Public Property FirstName As String
        Public Property LastName As String
        Public Property Username As String
        Public Property Email As String
        Public Property UserType As String
    End Class

End Class