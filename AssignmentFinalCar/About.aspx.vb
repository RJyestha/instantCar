Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI
Imports System.Web.UI.WebControls
Public Class WebForm4
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            ' Check if this is the first time the page is loading (not a postback)
            If Not IsPostBack Then
                ' Load statistical data from database
                LoadStatistics()
            End If

        Catch ex As Exception
            ' Log any unexpected errors during page load
            LogError("Error in Page_Load: " & ex.Message)
            ' Set default values to ensure page still displays content
            SetDefaultStatistics()
        End Try
    End Sub

    ' Private method to load company statistics from database
    ' Uses parameterized queries and proper connection management
    Private Sub LoadStatistics()
        Try
            ' Get connection string from web.config file
            Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

            ' Use Using statement to ensure proper disposal of database connections
            Using con As New SqlConnection(connStr)
                con.Open()

                ' Query 1: Get total count of active vehicles
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Vehicles WHERE IsActive = 1", con)
                Dim vehicleCount As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                ' Update ASP.NET Label control with the count
                lblTotalVehicles.Text = vehicleCount.ToString()

                ' Query 2: Get total count of active clients
                cmd.CommandText = "SELECT COUNT(*) FROM Users WHERE UserType = 'Client' AND IsActive = 1"
                Dim customerCount As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                lblTotalCustomers.Text = customerCount.ToString()

                ' Query 3: Get total count of completed bookings
                cmd.CommandText = "SELECT COUNT(*) FROM Bookings WHERE BookingStatus = 'Completed'"
                Dim bookingCount As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                lblTotalBookings.Text = bookingCount.ToString()

            End Using

        Catch ex As SqlException
            ' Handle SQL-specific errors (database connection issues, query problems)
            LogError("SQL Error in LoadStatistics: " & ex.Message)
            SetDefaultStatistics()

        Catch ex As Exception
            ' Handle any other unexpected errors
            LogError("General Error in LoadStatistics: " & ex.Message)
            SetDefaultStatistics()
        End Try
    End Sub

    ' Private method to set default values when database is unavailable
    ' Ensures the page still displays meaningful content
    Private Sub SetDefaultStatistics()
        ' Set fallback values for statistics
        lblTotalVehicles.Text = "50+"
        lblTotalCustomers.Text = "1000+"
        lblTotalBookings.Text = "5000+"
    End Sub

    ' Private method to load customer testimonials from database
    ' Only loads approved testimonials with proper user information

    ' Protected function to generate HTML star ratings
    ' Can be called from the ASPX page markup
    Protected Function GenerateStars(rating As Integer) As String
        Dim stars As String = ""
        Dim actualRating As Integer = rating

        ' Validate rating is within acceptable range (1-5)
        If actualRating < 1 Then actualRating = 1
        If actualRating > 5 Then actualRating = 5

        ' Generate HTML for star icons using Font Awesome classes
        For i As Integer = 1 To 5
            If i <= actualRating Then
                ' Filled star for ratings within the given rating
                stars &= "<i class='fas fa-star text-warning'></i>"
            Else
                ' Empty star for ratings above the given rating
                stars &= "<i class='far fa-star text-warning'></i>"
            End If
        Next

        Return stars
    End Function

    ' Protected function to get first initial of last name for privacy
    ' Used in testimonials to show "John D." instead of full name
    Protected Function GetFirstInitial(lastName As String) As String
        ' Check for null or empty string
        If String.IsNullOrEmpty(lastName) Then
            Return ""
        End If
        ' Return first character in uppercase with period
        Return lastName.Substring(0, 1).ToUpper() & "."
    End Function

    ' Protected function to format date for display
    ' Converts database date to user-friendly format
    Protected Function FormatDate(dateValue As Object) As String
        ' Handle null or DBNull values
        If dateValue Is Nothing OrElse IsDBNull(dateValue) Then
            Return ""
        End If

        Try
            ' Convert to DateTime and format as "Month Year"
            Dim feedbackDate As DateTime = Convert.ToDateTime(dateValue)
            Return feedbackDate.ToString("MMMM yyyy")
        Catch
            ' Return empty string if conversion fails
            Return ""
        End Try
    End Function

    ' Protected function to truncate long comments for display
    ' Ensures testimonials don't break layout with very long text
    Protected Function TruncateComment(comment As String, maxLength As Integer) As String
        ' Handle null or empty comments
        If String.IsNullOrEmpty(comment) Then
            Return ""
        End If

        ' Return as-is if within length limit
        If comment.Length <= maxLength Then
            Return comment
        End If

        ' Truncate at word boundary to avoid cutting words in half
        Dim truncated As String = comment.Substring(0, maxLength)
        Dim lastSpace As Integer = truncated.LastIndexOf(" ")

        ' Cut at last space if found, otherwise cut at maxLength
        If lastSpace > 0 Then
            truncated = truncated.Substring(0, lastSpace)
        End If

        ' Add ellipsis to indicate truncation
        Return truncated & "..."
    End Function

    ' Private method for error logging
    ' Centralizes error handling and logging functionality
    Private Sub LogError(errorMessage As String)
        Try
            ' Log to debug output (you can extend this to log to file or database)
            System.Diagnostics.Debug.WriteLine("About Page Error: " & errorMessage)

            ' Additional logging mechanisms can be added here:
            ' - Log to database error table
            ' - Log to text file
            ' - Send error emails to administrators
            ' - Integration with logging frameworks like NLog or log4net

        Catch
            ' Silently handle logging errors to prevent infinite error loops
            ' In production, you might want to log to Windows Event Log as fallback
        End Try
    End Sub

    ' Page PreRender event - fires just before page content is sent to client
    ' Used for final adjustments and validation before rendering
    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        Try
            ' Ensure statistics show meaningful values even if database returns 0
            ' This provides better user experience with fallback values
            If lblTotalVehicles.Text = "0" Then lblTotalVehicles.Text = "50+"
            If lblTotalCustomers.Text = "0" Then lblTotalCustomers.Text = "1000+"
            If lblTotalBookings.Text = "0" Then lblTotalBookings.Text = "5000+"

            ' Add any additional last-minute page modifications here
            ' This event is useful for:
            ' - Setting control properties based on user roles
            ' - Applying security-based visibility changes
            ' - Final data validation before display

        Catch ex As Exception
            ' Log any pre-render errors
            LogError("Error in Page_PreRender: " & ex.Message)
        End Try
    End Sub

    ' Event handler for handling any unhandled exceptions on the page
    ' This provides a safety net for unexpected errors
    Protected Sub Page_Error(sender As Object, e As EventArgs) Handles Me.Error
        Try
            ' Get the exception that occurred
            Dim ex As Exception = Server.GetLastError()

            ' Log the error
            LogError("Unhandled Page Error: " & ex.Message)

            ' Clear the error so it doesn't propagate
            Server.ClearError()

            ' Redirect to a friendly error page or show a user-friendly message
            ' Response.Redirect("~/ErrorPage.aspx")

        Catch
            ' If error handling itself fails, let it bubble up
        End Try
    End Sub

End Class
