Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Text
Imports System.IO
Imports System.Web.UI.HtmlControls
Public Class WebForm5
    Inherits System.Web.UI.Page

    ' Constant that defines how many records to show per page
    Private Const PAGE_SIZE As Integer = 9 ' 3x3 layout grid

    ' Tracks the current page number using ViewState (preserved across postbacks)
    Private Property CurrentPage As Integer
        Get
            If ViewState("CurrentPage") Is Nothing Then
                ViewState("CurrentPage") = 1 ' Default to page 1
            End If
            Return CInt(ViewState("CurrentPage"))
        End Get
        Set(value As Integer)
            ViewState("CurrentPage") = value
        End Set
    End Property

    ' Executes when the page loads
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then ' Run only on first load
            LoadMakes()    ' Populate car makes dropdown
            LoadModels()   ' Populate models based on selected make
            LoadVehicles() ' Load list of available vehicles
        End If
    End Sub

    ' Loads available makes into the ddlMake dropdown
    Private Sub LoadMakes()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()
                Dim query As String = "SELECT DISTINCT MakeID, MakeName FROM Make WHERE IsActive = 1 ORDER BY MakeName"
                Using cmd As New SqlCommand(query, con)
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        ddlMake.Items.Clear()
                        ddlMake.Items.Add(New ListItem("All Makes", "")) ' Default option

                        ' Add each make from the result
                        For Each row As DataRow In dt.Rows
                            ddlMake.Items.Add(New ListItem(row("MakeName").ToString(), row("MakeID").ToString()))
                        Next
                    End Using
                End Using
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error loading makes: " & ex.Message)
            End Try
        End Using
    End Sub

    ' Loads available models into ddlModel depending on selected make
    Private Sub LoadModels()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()
                Dim query As String = "SELECT DISTINCT ModelID, ModelName FROM Model WHERE IsActive = 1"

                ' Add filter if make is selected
                If ddlMake.SelectedValue <> "" Then
                    query &= " AND MakeID = @MakeID"
                End If

                query &= " ORDER BY ModelName"

                Using cmd As New SqlCommand(query, con)
                    If ddlMake.SelectedValue <> "" Then
                        cmd.Parameters.Add("@MakeID", SqlDbType.Int).Value = ddlMake.SelectedValue
                    End If

                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        Dim selectedValue As String = ddlModel.SelectedValue
                        ddlModel.Items.Clear()
                        ddlModel.Items.Add(New ListItem("All Models", ""))

                        For Each row As DataRow In dt.Rows
                            ddlModel.Items.Add(New ListItem(row("ModelName").ToString(), row("ModelID").ToString()))
                        Next

                        ' Keep user selection if still valid
                        If ddlModel.Items.FindByValue(selectedValue) IsNot Nothing Then
                            ddlModel.SelectedValue = selectedValue
                        End If
                    End Using
                End Using
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error loading models: " & ex.Message)
            End Try
        End Using
    End Sub

    ' Loads vehicles from database and binds to Repeater with filters and sorting
    Private Sub LoadVehicles()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ToString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()

                ' Base SQL query to select vehicles and their related data
                Dim query As String = "SELECT v.VehicleID, v.Color, v.PricePerDay, v.Status, " &
                                     "mo.ModelName, mo.Year, mo.SeatingCapacity, mo.Transmission, mo.FuelType, " &
                                     "ma.MakeName, v.CreatedDate, " &
                                     "ISNULL(vi.ImagePath, '~/image/default-car.jpg') as ImagePath " &
                                     "FROM Vehicles v " &
                                     "INNER JOIN Model mo ON v.ModelID = mo.ModelID " &
                                     "INNER JOIN Make ma ON mo.MakeID = ma.MakeID " &
                                     "LEFT JOIN VehicleImages vi ON v.VehicleID = vi.VehicleID AND vi.ImageType = 'Primary' " &
                                     "WHERE v.IsActive = 1 AND v.Status = 'Available'"

                Using cmd As New SqlCommand()
                    cmd.Connection = con

                    ' Apply filters based on user selections
                    If ddlMake.SelectedValue <> "" Then
                        query &= " AND ma.MakeID = @MakeID"
                        cmd.Parameters.Add("@MakeID", SqlDbType.Int).Value = ddlMake.SelectedValue
                    End If

                    If ddlModel.SelectedValue <> "" Then
                        query &= " AND mo.ModelID = @ModelID"
                        cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = ddlModel.SelectedValue
                    End If

                    If ddlFuelType.SelectedValue <> "" Then
                        query &= " AND mo.FuelType = @FuelType"
                        cmd.Parameters.Add("@FuelType", SqlDbType.NVarChar, 20).Value = ddlFuelType.SelectedValue
                    End If

                    If ddlTransmission.SelectedValue <> "" Then
                        query &= " AND mo.Transmission = @Transmission"
                        cmd.Parameters.Add("@Transmission", SqlDbType.NVarChar, 20).Value = ddlTransmission.SelectedValue
                    End If

                    If ddlSeats.SelectedValue <> "" Then
                        Dim seats As Integer = CInt(ddlSeats.SelectedValue)
                        If seats = 8 Then
                            query &= " AND mo.SeatingCapacity >= @SeatingCapacity"
                        Else
                            query &= " AND mo.SeatingCapacity = @SeatingCapacity"
                        End If
                        cmd.Parameters.Add("@SeatingCapacity", SqlDbType.Int).Value = seats
                    End If

                    If txtMinPrice.Text <> "" AndAlso IsNumeric(txtMinPrice.Text) Then
                        query &= " AND v.PricePerDay >= @MinPrice"
                        cmd.Parameters.Add("@MinPrice", SqlDbType.Decimal).Value = CDec(txtMinPrice.Text)
                    End If

                    If txtMaxPrice.Text <> "" AndAlso IsNumeric(txtMaxPrice.Text) Then
                        query &= " AND v.PricePerDay <= @MaxPrice"
                        cmd.Parameters.Add("@MaxPrice", SqlDbType.Decimal).Value = CDec(txtMaxPrice.Text)
                    End If

                    ' Apply sorting options
                    Select Case ddlSort.SelectedValue
                        Case "PriceAsc"
                            query &= " ORDER BY v.PricePerDay ASC"
                        Case "PriceDesc"
                            query &= " ORDER BY v.PricePerDay DESC"
                        Case "MakeAsc"
                            query &= " ORDER BY ma.MakeName ASC, mo.ModelName ASC"
                        Case "MakeDesc"
                            query &= " ORDER BY ma.MakeName DESC, mo.ModelName DESC"
                        Case "ModelAsc"
                            query &= " ORDER BY mo.ModelName ASC"
                        Case "Newest"
                            query &= " ORDER BY v.CreatedDate DESC"
                        Case Else
                            query &= " ORDER BY v.PricePerDay ASC"
                    End Select

                    cmd.CommandText = query

                    ' Execute the query
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        Dim totalRecords As Integer = dt.Rows.Count
                        Dim totalPages As Integer = Math.Ceiling(totalRecords / PAGE_SIZE)

                        ' Update result count label
                        lblResultsCount.Text = totalRecords & " vehicle(s) available"

                        If totalRecords > 0 Then
                            ' Paginate the data
                            Dim pagedData As DataTable = GetPagedData(dt, CurrentPage, PAGE_SIZE)
                            rptVehicles.DataSource = pagedData
                            rptVehicles.DataBind()

                            pnlNoResults.Visible = False
                            BuildPagination(totalPages)
                        Else
                            ' No vehicles found
                            rptVehicles.DataSource = Nothing
                            rptVehicles.DataBind()
                            pnlNoResults.Visible = True
                            pnlPagination.Visible = False
                        End If

                        UpdateActiveFilters()
                    End Using
                End Using
            Catch ex As Exception
                lblResultsCount.Text = "Error loading vehicles"
                pnlNoResults.Visible = True
                pnlPagination.Visible = False
                System.Diagnostics.Debug.WriteLine("Error loading vehicles: " & ex.Message)
            End Try
        End Using
    End Sub

    ' Returns a smaller set of rows for pagination
    Private Function GetPagedData(dt As DataTable, pageNumber As Integer, pageSize As Integer) As DataTable
        Dim pagedData As DataTable = dt.Clone()
        Dim startIndex As Integer = (pageNumber - 1) * pageSize
        Dim endIndex As Integer = Math.Min(startIndex + pageSize - 1, dt.Rows.Count - 1)

        For i As Integer = startIndex To endIndex
            If i < dt.Rows.Count Then
                pagedData.ImportRow(dt.Rows(i))
            End If
        Next

        Return pagedData
    End Function

    ' Dynamically creates pagination controls
    Private Sub BuildPagination(totalPages As Integer)
        phPagination.Controls.Clear()

        If totalPages <= 1 Then
            pnlPagination.Visible = False
            Return
        End If

        pnlPagination.Visible = True

        ' Add Previous button
        If CurrentPage > 1 Then
            Dim prevLi As New HtmlGenericControl("li")
            prevLi.Attributes.Add("class", "page-item")

            Dim prevLink As New LinkButton()
            prevLink.Text = "« Previous"
            prevLink.CssClass = "page-link"
            prevLink.CommandArgument = (CurrentPage - 1).ToString()
            AddHandler prevLink.Command, AddressOf PageLink_Command

            prevLi.Controls.Add(prevLink)
            phPagination.Controls.Add(prevLi)
        End If

        ' Add numbered page links
        Dim startPage As Integer = Math.Max(1, CurrentPage - 2)
        Dim endPage As Integer = Math.Min(totalPages, CurrentPage + 2)

        If startPage > 1 Then
            Dim firstLi As New HtmlGenericControl("li")
            firstLi.Attributes.Add("class", "page-item")
            Dim firstLink As New LinkButton()
            firstLink.Text = "1"
            firstLink.CssClass = "page-link"
            firstLink.CommandArgument = "1"
            AddHandler firstLink.Command, AddressOf PageLink_Command
            firstLi.Controls.Add(firstLink)
            phPagination.Controls.Add(firstLi)

            If startPage > 2 Then
                Dim dotsLi As New HtmlGenericControl("li")
                dotsLi.Attributes.Add("class", "page-item disabled")
                Dim dotsSpan As New HtmlGenericControl("span")
                dotsSpan.Attributes.Add("class", "page-link")
                dotsSpan.InnerText = "..."
                dotsLi.Controls.Add(dotsSpan)
                phPagination.Controls.Add(dotsLi)
            End If
        End If

        ' Add page range
        For i As Integer = startPage To endPage
            Dim pageLi As New HtmlGenericControl("li")
            pageLi.Attributes.Add("class", "page-item" & If(i = CurrentPage, " active", ""))

            Dim pageLink As New LinkButton()
            pageLink.Text = i.ToString()
            pageLink.CssClass = "page-link"
            pageLink.CommandArgument = i.ToString()
            AddHandler pageLink.Command, AddressOf PageLink_Command

            pageLi.Controls.Add(pageLink)
            phPagination.Controls.Add(pageLi)
        Next

        ' Add final page and "Next"
        If endPage < totalPages Then
            If endPage < totalPages - 1 Then
                Dim dotsLi As New HtmlGenericControl("li")
                dotsLi.Attributes.Add("class", "page-item disabled")
                Dim dotsSpan As New HtmlGenericControl("span")
                dotsSpan.Attributes.Add("class", "page-link")
                dotsSpan.InnerText = "..."
                dotsLi.Controls.Add(dotsSpan)
                phPagination.Controls.Add(dotsLi)
            End If

            Dim lastLi As New HtmlGenericControl("li")
            lastLi.Attributes.Add("class", "page-item")
            Dim lastLink As New LinkButton()
            lastLink.Text = totalPages.ToString()
            lastLink.CssClass = "page-link"
            lastLink.CommandArgument = totalPages.ToString()
            AddHandler lastLink.Command, AddressOf PageLink_Command
            lastLi.Controls.Add(lastLink)
            phPagination.Controls.Add(lastLi)
        End If

        ' Add Next button
        If CurrentPage < totalPages Then
            Dim nextLi As New HtmlGenericControl("li")
            nextLi.Attributes.Add("class", "page-item")

            Dim nextLink As New LinkButton()
            nextLink.Text = "Next »"
            nextLink.CssClass = "page-link"
            nextLink.CommandArgument = (CurrentPage + 1).ToString()
            AddHandler nextLink.Command, AddressOf PageLink_Command

            nextLi.Controls.Add(nextLink)
            phPagination.Controls.Add(nextLi)
        End If
    End Sub

    ' Updates the UI to show selected filters as tags/badges
    Private Sub UpdateActiveFilters()
        Dim filters As New List(Of String)

        If ddlMake.SelectedValue <> "" Then filters.Add("Make: " & ddlMake.SelectedItem.Text)
        If ddlModel.SelectedValue <> "" Then filters.Add("Model: " & ddlModel.SelectedItem.Text)
        If ddlFuelType.SelectedValue <> "" Then filters.Add("Fuel: " & ddlFuelType.SelectedItem.Text)
        If ddlTransmission.SelectedValue <> "" Then filters.Add("Transmission: " & ddlTransmission.SelectedItem.Text)
        If ddlSeats.SelectedValue <> "" Then filters.Add("Seats: " & ddlSeats.SelectedItem.Text)
        If txtMinPrice.Text <> "" Then filters.Add("Min Price: Rs " & txtMinPrice.Text)
        If txtMaxPrice.Text <> "" Then filters.Add("Max Price: Rs " & txtMaxPrice.Text)

        If filters.Count > 0 Then
            Dim filterHtml As String = ""
            For Each filter As String In filters
                filterHtml &= "<span class='filter-badge'>" & filter & "</span>"
            Next
            litActiveFilters.Text = filterHtml
            pnlActiveFilters.Visible = True
        Else
            pnlActiveFilters.Visible = False
        End If
    End Sub

    ' ========== EVENT HANDLERS ==========

    ' Fired when a filter is changed (dropdown)
    Protected Sub FilterChanged(sender As Object, e As EventArgs)
        If TypeOf sender Is DropDownList Then
            Dim ddl As DropDownList = DirectCast(sender, DropDownList)
            If ddl.ID = "ddlMake" Then
                LoadModels()
            End If
        End If
        CurrentPage = 1
        LoadVehicles()
    End Sub

    ' Called when sort option is changed
    Protected Sub SortChanged(sender As Object, e As EventArgs)
        CurrentPage = 1
        LoadVehicles()
    End Sub

    ' Triggered when Filter button is clicked
    Protected Sub btnFilter_Click(sender As Object, e As EventArgs)
        CurrentPage = 1
        LoadVehicles()
    End Sub

    ' Clear filters and reload everything
    Protected Sub btnClearFilters_Click(sender As Object, e As EventArgs)
        ddlMake.SelectedIndex = 0
        ddlModel.SelectedIndex = 0
        ddlFuelType.SelectedIndex = 0
        ddlTransmission.SelectedIndex = 0
        ddlSeats.SelectedIndex = 0
        txtMinPrice.Text = ""
        txtMaxPrice.Text = ""
        ddlSort.SelectedIndex = 0
        CurrentPage = 1

        LoadModels()
        LoadVehicles()
    End Sub

    ' Called when Book Now button is clicked
    Protected Sub BookNow_Command(sender As Object, e As CommandEventArgs)
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx?returnUrl=" & Server.UrlEncode("VehicleDetails.aspx?id=" & e.CommandArgument.ToString() & "&book=true"))
        Else
            Response.Redirect("VehicleDetails.aspx?id=" & e.CommandArgument.ToString() & "&book=true")
        End If
    End Sub

    ' Fired when a page number is clicked in pagination
    Protected Sub PageLink_Command(sender As Object, e As CommandEventArgs)
        CurrentPage = CInt(e.CommandArgument)
        LoadVehicles()
    End Sub

    ' ========== HELPER METHODS ==========

    ' Get image path for display
    Public Function GetImagePath(imagePath As Object) As String
        If imagePath Is Nothing OrElse imagePath Is DBNull.Value Then
            Return ResolveUrl("~/image/default-car.jpg")
        End If

        Dim path As String = imagePath.ToString()
        If String.IsNullOrEmpty(path) Then Return ResolveUrl("~/image/default-car.jpg")
        If path.StartsWith("~/") Then Return ResolveUrl(path)
        If path.StartsWith("/") Then Return ResolveUrl("~" & path)

        Return ResolveUrl("~/image/" & path)
    End Function

    ' Helper: safe string value
    Public Shared Function SafeString(value As Object, defaultValue As String) As String
        If value Is Nothing OrElse value Is DBNull.Value Then Return defaultValue
        Return value.ToString()
    End Function

    ' Helper: safe integer conversion
    Public Shared Function SafeInt(value As Object, defaultValue As Integer) As Integer
        If value Is Nothing OrElse value Is DBNull.Value Then Return defaultValue
        Dim result As Integer
        If Integer.TryParse(value.ToString(), result) Then
            Return result
        Else
            Return defaultValue
        End If
    End Function

End Class