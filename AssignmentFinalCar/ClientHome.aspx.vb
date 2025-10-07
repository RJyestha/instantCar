Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Public Class WebForm14
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Only load data if the page is not posting back
        If Not IsPostBack Then
            LoadDashboardData()
            LoadLatestNews()
        End If
    End Sub

    ' Load user-specific dashboard data (bookings, cart, spending)
    Private Sub LoadDashboardData()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                Dim userID As Integer = CInt(Session("UserID"))

                ' 1. Total bookings
                Dim cmdTotalBookings As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE UserID = @UserID", con)
                cmdTotalBookings.Parameters.AddWithValue("@UserID", userID)
                lblTotalBookings.Text = cmdTotalBookings.ExecuteScalar().ToString()

                ' 2. Active bookings (Pending, Confirmed, Active)
                Dim cmdActiveBookings As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE UserID = @UserID AND Status IN ('Pending', 'Confirmed', 'Active')", con)
                cmdActiveBookings.Parameters.AddWithValue("@UserID", userID)
                lblActiveBookings.Text = cmdActiveBookings.ExecuteScalar().ToString()

                ' 3. Cart item count (optional table)
                Try
                    Dim cmdCartItems As New SqlCommand("SELECT COUNT(*) FROM Cart WHERE UserID = @UserID", con)
                    cmdCartItems.Parameters.AddWithValue("@UserID", userID)
                    Dim cartCount As Integer = CInt(cmdCartItems.ExecuteScalar())
                    lblCartItems.Text = cartCount.ToString()
                    lblCartCount.Text = cartCount.ToString()
                Catch ex As Exception
                    lblCartItems.Text = "0"
                    lblCartCount.Text = "0"
                End Try

                ' 4. Total amount spent (Completed bookings)
                Dim cmdTotalSpent As New SqlCommand("SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE UserID = @UserID AND Status = 'Completed'", con)
                cmdTotalSpent.Parameters.AddWithValue("@UserID", userID)
                Dim totalSpent As Decimal = CDec(cmdTotalSpent.ExecuteScalar())
                lblTotalSpent.Text = "Rs " & totalSpent.ToString("#,##0")

            End Using
        Catch ex As Exception
            ' Show error message on page
            ShowMessage("Error loading dashboard data: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load latest news for display in repeater
    Private Sub LoadLatestNews()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                ' Get latest 5 published news items
                Dim cmd As New SqlCommand("
                    SELECT TOP 5 
                        ISNULL(Title, 'No Title') AS Title, 
                        ISNULL(Content, 'No Content') AS Content, 
                        CreatedDate 
                    FROM News 
                    WHERE IsActive = 1 AND IsPublished = 1 
                    ORDER BY CreatedDate DESC", con)

                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                If dt.Rows.Count > 0 Then
                    rptLatestNews.DataSource = dt
                    rptLatestNews.DataBind()
                    pnlNoNews.Visible = False
                Else
                    pnlNoNews.Visible = True
                End If
            End Using
        Catch ex As Exception
            pnlNoNews.Visible = True
            ShowMessage("Error loading news: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Helper to truncate news content text
    Protected Function TruncateText(text As Object, maxLength As Integer) As String
        If text Is Nothing OrElse IsDBNull(text) Then Return ""

        Dim textString As String = text.ToString()
        If textString.Length <= maxLength Then Return textString

        Return textString.Substring(0, maxLength) & "..."
    End Function

    ' Display alert message on the page
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ' Hide message after 5 seconds using JavaScript
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ " &
            "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
            "if(msgPanel) msgPanel.style.display = 'none'; " &
            "}, 5000);", True)
    End Sub
End Class