Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Public Class WebForm1
    Inherits System.Web.UI.Page

    ' Page Load Event - Called when page first loads
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            ' Only load data on first page visit, not on postbacks
            If Not Page.IsPostBack Then
                InitializePageData()
            End If
        Catch ex As Exception
            HandleError("Page Load Error", ex)
        End Try
    End Sub

    ' Initialize all page data when page first loads
    Private Sub InitializePageData()
        SetDateValidation()      ' Set minimum dates for date pickers
        LoadFeaturedVehicles()   ' Load featured cars section
        LoadLatestNews()         ' Load news section
        LoadCustomerFeedback()   ' Load customer reviews
    End Sub

    ' Set minimum dates for pickup and return date controls
    Private Sub SetDateValidation()
        ' Prevent users from selecting past dates
        txtPickupDate.Attributes.Add("min", DateTime.Now.ToString("yyyy-MM-dd"))
        txtReturnDate.Attributes.Add("min", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"))
    End Sub

    ' Load featured vehicles from database to display on homepage
    Private Sub LoadFeaturedVehicles()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString

            Using connection As New SqlConnection(connectionString)
                ' SQL query to get top 6 available vehicles with all details
                Dim sqlQuery As String = BuildFeaturedVehiclesQuery()

                Using command As New SqlCommand(sqlQuery, connection)
                    connection.Open()

                    Using adapter As New SqlDataAdapter(command)
                        Dim vehicleData As New DataTable()
                        adapter.Fill(vehicleData)

                        ' Bind data to repeater control for display
                        rptFeaturedVehicles.DataSource = vehicleData
                        rptFeaturedVehicles.DataBind()
                    End Using
                End Using
            End Using

        Catch ex As Exception
            ' If database fails, show sample data instead of breaking page
            HandleDatabaseError("Featured Vehicles", ex)
            LoadSampleVehicleData()
        End Try
    End Sub

    ' Build SQL query for featured vehicles
    Private Function BuildFeaturedVehiclesQuery() As String
        Return "SELECT TOP 6 v.VehicleID, mo.ModelName, v.Color, v.PricePerDay, " &
               "ISNULL(mo.SeatingCapacity, 5) as SeatingCapacity, " &
               "ISNULL(mo.Transmission, 'Manual') as Transmission, " &
               "ISNULL(mo.FuelType, 'Petrol') as FuelType, " &
               "ma.MakeName, v.Status, v.Location, " &
               "ISNULL(vi.ImagePath, '~/image/default-car.jpg') as ImagePath " &
               "FROM Vehicles v " &
               "INNER JOIN Model mo ON v.ModelID = mo.ModelID " &
               "INNER JOIN Make ma ON mo.MakeID = ma.MakeID " &
               "LEFT JOIN VehicleImages vi ON v.VehicleID = vi.VehicleID AND vi.ImageType = 'Primary' " &
               "WHERE v.IsActive = 1 AND v.Status = 'Available' " &
               "ORDER BY v.CreatedDate DESC"
    End Function

    ' Create sample vehicle data if database connection fails
    Private Sub LoadSampleVehicleData()
        Dim sampleData As New DataTable()

        ' Create table structure
        CreateVehicleDataTable(sampleData)

        ' Add sample vehicle records
        sampleData.Rows.Add(1, "Toyota", "Corolla", 1500, 5, "Manual", "Petrol", "Available", "~/image/toyota1-car.jpg")
        sampleData.Rows.Add(2, "Honda", "Civic", 1800, 5, "Automatic", "Petrol", "Available", "~/image/honda1-car.jpg")
        sampleData.Rows.Add(3, "Nissan", "Sentra", 1600, 5, "Manual", "Petrol", "Available", "~/image/nissan1-car.jpg")

        ' Bind sample data to display
        rptFeaturedVehicles.DataSource = sampleData
        rptFeaturedVehicles.DataBind()
    End Sub

    ' Create data table structure for vehicle data
    Private Sub CreateVehicleDataTable(ByRef dataTable As DataTable)
        dataTable.Columns.Add("VehicleID", GetType(Integer))
        dataTable.Columns.Add("MakeName", GetType(String))
        dataTable.Columns.Add("ModelName", GetType(String))
        dataTable.Columns.Add("PricePerDay", GetType(Decimal))
        dataTable.Columns.Add("SeatingCapacity", GetType(Integer))
        dataTable.Columns.Add("Transmission", GetType(String))
        dataTable.Columns.Add("FuelType", GetType(String))
        dataTable.Columns.Add("Status", GetType(String))
        dataTable.Columns.Add("ImagePath", GetType(String))
    End Sub

    ' Load latest news articles from database
    Private Sub LoadLatestNews()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString

            Using connection As New SqlConnection(connectionString)
                ' Get top 3 published news articles
                Dim sqlQuery As String = BuildNewsQuery()

                Using command As New SqlCommand(sqlQuery, connection)
                    connection.Open()

                    Using adapter As New SqlDataAdapter(command)
                        Dim newsData As New DataTable()
                        adapter.Fill(newsData)

                        ' Process image paths to ensure they work correctly
                        ProcessNewsImagePaths(newsData)

                        ' Bind news data to repeater
                        rptLatestNews.DataSource = newsData
                        rptLatestNews.DataBind()
                    End Using
                End Using
            End Using

        Catch ex As Exception
            ' Show sample news if database fails
            HandleDatabaseError("Latest News", ex)
            LoadSampleNewsData()
        End Try
    End Sub

    ' Build SQL query for latest news
    Private Function BuildNewsQuery() As String
        Return "SELECT TOP 2 NewsID, Title, Summary, " &
               "CASE " &
               "   WHEN ImagePath IS NOT NULL AND ImagePath != '' THEN ImagePath " &
               "   ELSE '~/image/default-news.jpg' " &
               "END as ImagePath, " &
               "PublishDate, Category " &
               "FROM News " &
               "WHERE IsActive = 1 AND IsPublished = 1 " &
               "ORDER BY PublishDate DESC"
    End Function

    ' Fix image paths to work with web application
    Private Sub ProcessNewsImagePaths(ByRef newsData As DataTable)
        For Each row As DataRow In newsData.Rows
            Dim imagePath As String = GetSafeString(row("ImagePath"))

            ' Add ~/ prefix if not already present
            If Not String.IsNullOrEmpty(imagePath) AndAlso
               Not imagePath.StartsWith("~/") AndAlso
               Not imagePath.StartsWith("http") Then
                imagePath = "~/image/" & imagePath
            End If

            row("ImagePath") = imagePath
        Next
    End Sub

    ' Create sample news data when database is unavailable
    Private Sub LoadSampleNewsData()
        Dim sampleNews As New DataTable()

        ' Create news table structure
        CreateNewsDataTable(sampleNews)

        ' Add sample news articles
        sampleNews.Rows.Add(1, "Summer Special Offer",
                    "Get 10% discount on all bookings made this month. Limited time offer for summer vacation rentals.",
                    "~/image/news 1.jpg", DateTime.Parse("2024-07-28"), "Promotions")

        sampleNews.Rows.Add(2, "New Vehicles Added to Fleet",
                    "CarInstant is excited to announce new vehicles have been added to our fleet. More options available for our customers!",
                    "~/image/news 2.jpg", DateTime.Parse("2024-07-30"), "Fleet Updates")



        rptLatestNews.DataSource = sampleNews
        rptLatestNews.DataBind()
    End Sub

    ' Create data table structure for news data
    Private Sub CreateNewsDataTable(ByRef dataTable As DataTable)
        dataTable.Columns.Add("NewsID", GetType(Integer))
        dataTable.Columns.Add("Title", GetType(String))
        dataTable.Columns.Add("Summary", GetType(String))
        dataTable.Columns.Add("ImagePath", GetType(String))
        dataTable.Columns.Add("PublishDate", GetType(DateTime))
        dataTable.Columns.Add("Category", GetType(String))
    End Sub

    ' Load customer feedback/reviews for display
    Private Sub LoadCustomerFeedback()
        Dim feedbackData As New DataTable()

        ' Create feedback table structure
        CreateFeedbackDataTable(feedbackData)

        ' Add sample customer reviews
        feedbackData.Rows.Add("John Doe", "Excellent service! The car was clean and the pickup process was smooth.", 5)
        feedbackData.Rows.Add("Jane Smith", "Had a great experience. Will definitely rent from CarInstant again.", 4)
        feedbackData.Rows.Add("Peter Jones", "The staff was very helpful and the price was unbeatable.", 5)

        ' Bind feedback data to repeater
        rptFeedback.DataSource = feedbackData
        rptFeedback.DataBind()
    End Sub

    ' Create data table structure for feedback data
    Private Sub CreateFeedbackDataTable(ByRef dataTable As DataTable)
        dataTable.Columns.Add("Author", GetType(String))
        dataTable.Columns.Add("Review", GetType(String))
        dataTable.Columns.Add("Rating", GetType(Integer))
    End Sub

    ' Handle search button click event
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Try
            ' Validate user input before searching
            If ValidateSearchInput() Then
                PerformVehicleSearch()
            End If
        Catch ex As Exception
            HandleError("Search Error", ex)
            ShowUserMessage("An error occurred while searching. Please try again.")
        End Try
    End Sub

    ' Validate search form inputs
    Private Function ValidateSearchInput() As Boolean
        Dim validationErrors As New List(Of String)

        ' Check if location is selected
        If String.IsNullOrEmpty(ddlLocation.SelectedValue) Then
            validationErrors.Add("Please select a pickup location.")
        End If

        ' Validate pickup date
        ValidatePickupDate(validationErrors)

        ' Validate return date
        ValidateReturnDate(validationErrors)

        ' Show errors if any exist
        If validationErrors.Count > 0 Then
            ShowUserMessage(String.Join(" ", validationErrors))
            Return False
        End If

        Return True
    End Function

    ' Validate pickup date input
    Private Sub ValidatePickupDate(ByRef errors As List(Of String))
        If String.IsNullOrEmpty(txtPickupDate.Text) Then
            errors.Add("Please select a pickup date.")
            Return
        End If

        Dim pickupDate As DateTime
        If Not DateTime.TryParse(txtPickupDate.Text, pickupDate) Then
            errors.Add("Please enter a valid pickup date.")
        ElseIf pickupDate < DateTime.Now.Date Then
            errors.Add("Pickup date cannot be in the past.")
        End If
    End Sub

    ' Validate return date input
    Private Sub ValidateReturnDate(ByRef errors As List(Of String))
        If String.IsNullOrEmpty(txtReturnDate.Text) Then
            errors.Add("Please select a return date.")
            Return
        End If

        Dim returnDate As DateTime
        Dim pickupDate As DateTime

        If Not DateTime.TryParse(txtReturnDate.Text, returnDate) Then
            errors.Add("Please enter a valid return date.")
        ElseIf DateTime.TryParse(txtPickupDate.Text, pickupDate) AndAlso returnDate <= pickupDate Then
            errors.Add("Return date must be after pickup date.")
        End If
    End Sub

    ' Search for available vehicles based on user criteria
    Private Sub PerformVehicleSearch()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString

            Using connection As New SqlConnection(connectionString)
                ' Build search query with availability check
                Dim searchQuery As String = BuildSearchQuery()

                Using command As New SqlCommand(searchQuery, connection)
                    ' Add search parameters
                    AddSearchParameters(command)

                    connection.Open()

                    Using adapter As New SqlDataAdapter(command)
                        Dim searchResults As New DataTable()
                        adapter.Fill(searchResults)

                        ' Display search results
                        DisplaySearchResults(searchResults)
                    End Using
                End Using
            End Using

        Catch ex As Exception
            ' Show sample results if database search fails
            HandleDatabaseError("Vehicle Search", ex)
            ShowSampleSearchResults()
        End Try
    End Sub

    ' Build SQL query for vehicle search
    Private Function BuildSearchQuery() As String
        Return "SELECT v.VehicleID, mo.ModelName, v.Color, v.PricePerDay, " &
               "ISNULL(mo.SeatingCapacity, 5) as SeatingCapacity, " &
               "ISNULL(mo.Transmission, 'Manual') as Transmission, " &
               "ISNULL(mo.FuelType, 'Petrol') as FuelType, " &
               "ma.MakeName, v.Status, v.Location, " &
               "ISNULL(vi.ImagePath, '~/image/default-car.jpg') as ImagePath " &
               "FROM Vehicles v " &
               "INNER JOIN Model mo ON v.ModelID = mo.ModelID " &
               "INNER JOIN Make ma ON mo.MakeID = ma.MakeID " &
               "LEFT JOIN VehicleImages vi ON v.VehicleID = vi.VehicleID AND vi.ImageType = 'Primary' " &
               "WHERE v.IsActive = 1 AND v.Status = 'Available' " &
               "AND v.Location = @Location " &
               "AND v.VehicleID NOT IN (" &
               "    SELECT DISTINCT VehicleID FROM Bookings " &
               "    WHERE Status IN ('Confirmed', 'Active') " &
               "    AND ((@PickupDate BETWEEN StartDate AND EndDate) " &
               "    OR (@ReturnDate BETWEEN StartDate AND EndDate) " &
               "    OR (StartDate BETWEEN @PickupDate AND @ReturnDate))" &
               ") " &
               "ORDER BY v.PricePerDay"
    End Function

    ' Add parameters to search query
    Private Sub AddSearchParameters(ByRef command As SqlCommand)
        command.Parameters.AddWithValue("@Location", ddlLocation.SelectedValue)
        command.Parameters.AddWithValue("@PickupDate", DateTime.Parse(txtPickupDate.Text))
        command.Parameters.AddWithValue("@ReturnDate", DateTime.Parse(txtReturnDate.Text))
    End Sub

    ' Display search results to user
    Private Sub DisplaySearchResults(ByVal searchResults As DataTable)
        If searchResults.Rows.Count > 0 Then
            ' Show available vehicles
            rptSearchResults.DataSource = searchResults
            rptSearchResults.DataBind()
            pnlSearchResults.Visible = True
            lblSearchMessage.Text = $"Found {searchResults.Rows.Count} available vehicle(s) for your search criteria."
            lblSearchMessage.CssClass = "text-success"
        Else
            ' No vehicles found
            rptSearchResults.DataSource = Nothing
            rptSearchResults.DataBind()
            pnlSearchResults.Visible = True
            lblSearchMessage.Text = "No vehicles available for the selected dates and location. Please try different dates or locations."
            lblSearchMessage.CssClass = "text-warning"
        End If
    End Sub

    ' Show sample search results when database is unavailable
    Private Sub ShowSampleSearchResults()
        Dim sampleResults As New DataTable()
        CreateVehicleDataTable(sampleResults)

        sampleResults.Rows.Add(1, "Toyota", "Yaris", 1400, 5, "Manual", "~/image/toyota1.jpg")
        sampleResults.Rows.Add(2, "Honda", "City", 1700, 5, "Automatic", "~/image/honda1.jpg")

        rptSearchResults.DataSource = sampleResults
        rptSearchResults.DataBind()
        pnlSearchResults.Visible = True
        lblSearchMessage.Text = "Sample results shown (database connection issue)."
        lblSearchMessage.CssClass = "text-info"
    End Sub

    ' === HELPER METHODS FOR DATA BINDING ===

    ' Get safe image URL with fallback
    Protected Function GetImageUrl(imagePath As Object) As String
        Dim path As String = GetSafeString(imagePath)

        If String.IsNullOrEmpty(path) Then
            Return ResolveUrl("~/image/default-car.jpg")
        End If

        Return ResolveUrl(path)
    End Function

    ' Get safe news image URL with fallback
    Protected Function GetNewsImageUrl(imagePath As Object) As String
        Dim path As String = GetSafeString(imagePath)

        If String.IsNullOrEmpty(path) Then
            Return ResolveUrl("~/image/default-news.jpg")
        End If

        Return ResolveUrl(path)
    End Function

    ' Format price with currency symbol
    Protected Function FormatPrice(price As Object) As String
        If price Is Nothing OrElse price Is DBNull.Value Then
            Return "Rs 0.00"
        End If

        Dim decimalPrice As Decimal
        If Decimal.TryParse(price.ToString(), decimalPrice) Then
            Return String.Format("Rs {0:N2}", decimalPrice)
        End If

        Return "Rs 0.00"
    End Function

    ' Generate status badge HTML based on vehicle status
    Protected Function GetStatusBadge(status As Object) As String
        Dim statusText As String = GetSafeString(status).ToLower()

        Select Case statusText
            Case "available"
                Return "<span class='badge bg-success'>Available</span>"
            Case "rented"
                Return "<span class='badge bg-danger'>Rented</span>"
            Case "maintenance"
                Return "<span class='badge bg-warning'>Maintenance</span>"
            Case Else
                Return "<span class='badge bg-secondary'>Unknown</span>"
        End Select
    End Function

    ' Generate star rating HTML
    Protected Function GenerateStars(rating As Object) As String
        Dim ratingValue As Integer = GetSafeInteger(rating, 0)
        Dim starsHtml As String = ""

        ' Generate 5 stars, filled or empty based on rating
        For i As Integer = 1 To 5
            If i <= ratingValue Then
                starsHtml &= "<i class='fas fa-star text-warning'></i>"
            Else
                starsHtml &= "<i class='far fa-star text-warning'></i>"
            End If
        Next

        Return starsHtml
    End Function

    ' Format date for display
    Protected Function FormatPublishDate(dateValue As Object) As String
        If dateValue Is Nothing OrElse dateValue Is DBNull.Value Then
            Return "No Date"
        End If

        Try
            Dim publishDate As DateTime = CType(dateValue, DateTime)
            Return publishDate.ToString("dd MMM yyyy")
        Catch
            Return "Invalid Date"
        End Try
    End Function

    ' === UTILITY METHODS ===

    ' Safely get string value from database field
    Protected Function GetSafeString(value As Object, Optional defaultValue As String = "") As String
        If value Is Nothing OrElse value Is DBNull.Value Then
            Return defaultValue
        End If

        Dim stringValue As String = value.ToString().Trim()
        Return If(String.IsNullOrEmpty(stringValue), defaultValue, stringValue)
    End Function

    ' Safely get integer value from database field
    Protected Function GetSafeInteger(value As Object, Optional defaultValue As Integer = 0) As Integer
        If value Is Nothing OrElse value Is DBNull.Value Then
            Return defaultValue
        End If

        Dim intValue As Integer
        Return If(Integer.TryParse(value.ToString(), intValue), intValue, defaultValue)
    End Function

    ' Show message to user using JavaScript alert
    Private Sub ShowUserMessage(message As String)
        Dim safeMessage As String = message.Replace("'", "\'")
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage",
            $"alert('{safeMessage}');", True)
    End Sub

    ' Handle and log errors
    Private Sub HandleError(operation As String, ex As Exception)
        System.Diagnostics.Debug.WriteLine($"{operation} Error: {ex.Message}")
    End Sub

    ' Handle database-specific errors
    Private Sub HandleDatabaseError(operation As String, ex As Exception)
        System.Diagnostics.Debug.WriteLine($"Database Error in {operation}: {ex.Message}")
    End Sub

End Class