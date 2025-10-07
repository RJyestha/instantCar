Public Class Site3
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' Check if user is logged in and is an admin
        If Session("Username") Is Nothing Then
            Response.Redirect("Login.aspx")
        ElseIf Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' Display username in navigation
        If Session("Username") IsNot Nothing Then
            lblUsername.Text = Session("Username").ToString()
            lblWelcomeAdmin.Text = Session("FirstName").ToString() & " " & Session("LastName").ToString()
        End If

        ' You can add code here to count online users
        ' For now, setting a placeholder value
        lblOnlineUsers.Text = "1"
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkLogout.Click
        ' Clear all session variables
        Session.Clear()
        Session.Abandon()

        ' Redirect to login page
        Response.Redirect("Login.aspx")
    End Sub

End Class