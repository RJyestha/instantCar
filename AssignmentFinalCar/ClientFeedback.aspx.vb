Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration

Public Class WebForm20
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check if user is logged in and is a client (handled by master page)
        If Not IsPostBack Then
            LoadUserInfo()
        End If
    End Sub

    Private Sub LoadUserInfo()
        ' Pre-populate user information if available
        Try
            If Session("UserID") IsNot Nothing Then
                Using con As New SqlConnection(connStr)
                    con.Open()
                    Dim cmd As New SqlCommand("SELECT FirstName, LastName, Email FROM Users WHERE UserID = @UserID", con)
                    cmd.Parameters.AddWithValue("@UserID", CInt(Session("UserID")))

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtName.Text = reader("FirstName").ToString() & " " & reader("LastName").ToString()
                            txtEmail.Text = reader("Email").ToString()
                        End If
                    End Using
                End Using
            End If
        Catch ex As Exception
            ' If error loading user info, user can still manually enter details
            ShowMessage("Note: Please verify your contact information below.", "alert-info")
        End Try
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmit.Click
        If Page.IsValid Then
            Try
                ' Additional validation
                If txtMessage.Text.Trim().Length < 10 Then
                    ShowMessage("Message must be at least 10 characters long.", "alert-danger")
                    Return
                End If

                Using con As New SqlConnection(connStr)
                    con.Open()

                    ' Insert feedback into database
                    Dim cmd As New SqlCommand("INSERT INTO Feedback (UserID, Name, Email, Subject, Message, FeedbackType, Priority, Status, SubmittedDate, IsActive) " &
                                            "VALUES (@UserID, @Name, @Email, @Subject, @Message, @FeedbackType, @Priority, @Status, @SubmittedDate, @IsActive)", con)

                    ' Parameters
                    If Session("UserID") IsNot Nothing Then
                        cmd.Parameters.AddWithValue("@UserID", CInt(Session("UserID")))
                    Else
                        cmd.Parameters.AddWithValue("@UserID", DBNull.Value)
                    End If

                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim())
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
                    cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim())
                    cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim())
                    cmd.Parameters.AddWithValue("@FeedbackType", ddlFeedbackType.SelectedValue)
                    cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue)
                    cmd.Parameters.AddWithValue("@Status", "New")
                    cmd.Parameters.AddWithValue("@SubmittedDate", DateTime.Now)
                    cmd.Parameters.AddWithValue("@IsActive", True)

                    ' Execute the command
                    Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                    If rowsAffected > 0 Then
                        ShowMessage("Thank you for your feedback! We have received your message and will respond as soon as possible.", "alert-success")
                        ClearForm()

                        ' Optional: Send email notification to admin (you can implement this later)
                        ' SendNotificationEmail()
                    Else
                        ShowMessage("There was a problem submitting your feedback. Please try again.", "alert-danger")
                    End If
                End Using

            Catch ex As Exception
                ShowMessage("Error: " & ex.Message, "alert-danger")
                ' Log the error for debugging
                System.Diagnostics.Debug.WriteLine("Feedback Error: " & ex.ToString())
            End Try
        End If
    End Sub

    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClear.Click
        ClearForm()
        ShowMessage("Form cleared successfully.", "alert-info")
    End Sub

    Private Sub ClearForm()
        ' Clear all form fields except name and email (keep user info)
        txtSubject.Text = ""
        txtMessage.Text = ""
        ddlFeedbackType.SelectedIndex = 0
        ddlPriority.SelectedValue = "Medium"

        ' Only clear name and email if not logged in
        If Session("UserID") Is Nothing Then
            txtName.Text = ""
            txtEmail.Text = ""
        End If
    End Sub

    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = cssClass
        pnlMessage.Visible = True

        ' Auto-hide success messages after 5 seconds
        If cssClass.Contains("success") OrElse cssClass.Contains("info") Then
            ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
                "setTimeout(function(){ " &
                "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
                "if(msgPanel) msgPanel.style.display = 'none'; " &
                "}, 5000);", True)
        End If
    End Sub

    ' Optional: Method to send email notification to admin
    Private Sub SendNotificationEmail()
        Try


        Catch ex As Exception
            ' Log email error but don't show to user
            System.Diagnostics.Debug.WriteLine("Email notification error: " & ex.ToString())
        End Try
    End Sub

End Class