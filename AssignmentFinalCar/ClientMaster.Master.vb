Public Class Site2
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if user is logged in and is a client
        If Session("Username") Is Nothing Then
            Response.Redirect("Login.aspx")
        ElseIf Session("UserType") <> "Client" Then
            Response.Redirect("Login.aspx")
        End If

        ' Display username in navigation
        If Session("Username") IsNot Nothing Then
            lblUsername.Text = Session("Username").ToString()
            lblWelcomeUser.Text = Session("FirstName").ToString() & " " & Session("LastName").ToString()
        End If

    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkLogout.Click
        ' Clear all session variables
        Session.Clear()
        Session.Abandon()
        ' Redirect to login page
        Response.Redirect("Home.aspx")
    End Sub

End Class