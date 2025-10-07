Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI.WebControls
Public Class WebForm8
    Inherits System.Web.UI.Page

    ' Connection string from Web.config
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    ' Number of vehicles to show per page
    Private Const PageSize As Integer = 12

    ' Tracks the current page number using ViewState
    Private Property CurrentPage As Integer
        Get
            If ViewState("CurrentPage") Is Nothing Then
                Return 1
            End If
            Return CInt(ViewState("CurrentPage"))
        End Get
        Set(value As Integer)
            ViewState("CurrentPage") = value
        End Set
    End Property

    ' Page load event to check session and initialize data
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Redirect non-admin users to login
        If Session("Username") Is Nothing Or Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' Load filters and vehicle data on initial load
        If Not IsPostBack Then
            LoadMakes()
            LoadVehicles()
        End If
    End Sub

    ' Load active makes into dropdown filter
    Private Sub LoadMakes()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim query As String = "SELECT MakeID, MakeName FROM Make WHERE IsActive = 1 ORDER BY MakeName"
                Dim cmd As New SqlCommand(query, con)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ddlMakeFilter.DataSource = dt
                ddlMakeFilter.DataBind()
                ddlMakeFilter.Items.Insert(0, New ListItem("All Makes", "0"))
            End Using
        Catch ex As Exception
            ShowMessage("Error loading makes: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load vehicle list based on filters
    Private Sub LoadVehicles()
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                Dim query As String = BuildVehicleQuery()
                Dim cmd As New SqlCommand(query, con)
                AddSearchParameters(cmd)

                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Handle results and bind to Repeater with pagination
                If dt.Rows.Count > 0 Then
                    Dim pagedData As DataTable = ApplyPagination(dt)
                    rptVehicles.DataSource = pagedData
                    rptVehicles.DataBind()

                    BuildPagination(dt.Rows.Count)
                    pnlNoVehicles.Visible = False
                    pnlPagination.Visible = True
                Else
                    rptVehicles.DataSource = Nothing
                    rptVehicles.DataBind()
                    pnlNoVehicles.Visible = True
                    pnlPagination.Visible = False
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error loading vehicles: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Builds SQL query dynamically based on filters
    Private Function BuildVehicleQuery() As String
        Dim query As String = "SELECT v.VehicleID, v.LicensePlate, v.Color, v.Mileage, v.PricePerDay, " &
                             "v.Status, v.Features, v.Location, " &
                             "m.MakeName, mo.ModelName, mo.Year, mo.FuelType, mo.Transmission, mo.SeatingCapacity " &
                             "FROM Vehicles v " &
                             "INNER JOIN Model mo ON v.ModelID = mo.ModelID " &
                             "INNER JOIN Make m ON mo.MakeID = m.MakeID " &
                             "WHERE v.IsActive = 1"

        ' Append filters
        If Not String.IsNullOrEmpty(txtSearchVehicle.Text.Trim()) Then
            query &= " AND (m.MakeName LIKE @Search OR mo.ModelName LIKE @Search OR v.Color LIKE @Search)"
        End If

        If ddlStatusFilter.SelectedValue <> "All" AndAlso Not String.IsNullOrEmpty(ddlStatusFilter.SelectedValue) Then
            query &= " AND v.Status = @Status"
        End If

        If ddlMakeFilter.SelectedValue <> "0" AndAlso Not String.IsNullOrEmpty(ddlMakeFilter.SelectedValue) Then
            query &= " AND m.MakeID = @MakeID"
        End If

        If Not String.IsNullOrEmpty(txtMinPrice.Text.Trim()) AndAlso IsNumeric(txtMinPrice.Text.Trim()) Then
            query &= " AND v.PricePerDay >= @MinPrice"
        End If

        If Not String.IsNullOrEmpty(txtMaxPrice.Text.Trim()) AndAlso IsNumeric(txtMaxPrice.Text.Trim()) Then
            query &= " AND v.PricePerDay <= @MaxPrice"
        End If

        query &= " ORDER BY m.MakeName, mo.ModelName, v.VehicleID"

        Return query
    End Function

    ' Add SQL parameters based on user input
    Private Sub AddSearchParameters(cmd As SqlCommand)
        cmd.Parameters.Clear()

        If Not String.IsNullOrEmpty(txtSearchVehicle.Text.Trim()) Then
            cmd.Parameters.AddWithValue("@Search", "%" & txtSearchVehicle.Text.Trim() & "%")
        End If

        If ddlStatusFilter.SelectedValue <> "All" Then
            cmd.Parameters.AddWithValue("@Status", ddlStatusFilter.SelectedValue)
        End If

        If ddlMakeFilter.SelectedValue <> "0" Then
            cmd.Parameters.AddWithValue("@MakeID", CInt(ddlMakeFilter.SelectedValue))
        End If

        If Not String.IsNullOrEmpty(txtMinPrice.Text.Trim()) Then
            cmd.Parameters.AddWithValue("@MinPrice", CDec(txtMinPrice.Text.Trim()))
        End If

        If Not String.IsNullOrEmpty(txtMaxPrice.Text.Trim()) Then
            cmd.Parameters.AddWithValue("@MaxPrice", CDec(txtMaxPrice.Text.Trim()))
        End If
    End Sub

    ' Handles pagination logic by slicing the datatable
    Private Function ApplyPagination(dt As DataTable) As DataTable
        Dim startIndex As Integer = (CurrentPage - 1) * PageSize
        Dim endIndex As Integer = Math.Min(startIndex + PageSize - 1, dt.Rows.Count - 1)

        If startIndex >= dt.Rows.Count Then
            CurrentPage = 1
            startIndex = 0
            endIndex = Math.Min(PageSize - 1, dt.Rows.Count - 1)
        End If

        If endIndex < startIndex Then
            endIndex = startIndex
        End If

        Dim pagedData As DataTable = dt.Clone()

        If startIndex < dt.Rows.Count Then
            For i As Integer = startIndex To endIndex
                pagedData.ImportRow(dt.Rows(i))
            Next
        End If

        Return pagedData
    End Function

    ' Builds pagination buttons
    Private Sub BuildPagination(totalRecords As Integer)
        Dim totalPages As Integer = Math.Ceiling(totalRecords / PageSize)

        If totalPages <= 1 Then
            pnlPagination.Visible = False
            Return
        End If

        Dim paginationData As New List(Of Object)

        If CurrentPage > 1 Then
            paginationData.Add(New With {.PageNumber = "Previous", .ActualPage = CurrentPage - 1, .IsCurrentPage = False})
        End If

        Dim startPage As Integer = Math.Max(1, CurrentPage - 2)
        Dim endPage As Integer = Math.Min(totalPages, CurrentPage + 2)

        For i As Integer = startPage To endPage
            paginationData.Add(New With {.PageNumber = i.ToString(), .ActualPage = i, .IsCurrentPage = (i = CurrentPage)})
        Next

        If CurrentPage < totalPages Then
            paginationData.Add(New With {.PageNumber = "Next", .ActualPage = CurrentPage + 1, .IsCurrentPage = False})
        End If

        rptPagination.DataSource = paginationData
        rptPagination.DataBind()
        pnlPagination.Visible = True
    End Sub

    ' Handles the Search button click
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Try
            CurrentPage = 1
            LoadVehicles()

            Dim totalVehicles As Integer = GetTotalVehicleCount()
            If totalVehicles > 0 Then
                ShowMessage($"Found {totalVehicles} vehicle(s) matching your criteria.", "alert-success")
            Else
                ShowMessage("No vehicles found matching your search criteria.", "alert-info")
            End If
        Catch ex As Exception
            ShowMessage("Error performing search: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Handles Clear button click to reset filters
    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        Try
            txtSearchVehicle.Text = ""
            ddlStatusFilter.SelectedValue = "All"
            ddlMakeFilter.SelectedValue = "0"
            txtMinPrice.Text = ""
            txtMaxPrice.Text = ""

            CurrentPage = 1
            LoadVehicles()

            ShowMessage("Search filters cleared successfully.", "alert-success")
        Catch ex As Exception
            ShowMessage("Error clearing filters: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Gets the total vehicle count matching current filters
    Private Function GetTotalVehicleCount() As Integer
        Try
            Using con As New SqlConnection(connStr)
                con.Open()

                Dim query As String = BuildVehicleQuery().Replace("SELECT v.VehicleID, v.LicensePlate, v.Color, v.Mileage, v.PricePerDay, v.Status, v.Features, v.Location, m.MakeName, mo.ModelName, mo.Year, mo.FuelType, mo.Transmission, mo.SeatingCapacity FROM", "SELECT COUNT(*) FROM")
                Dim orderByIndex As Integer = query.LastIndexOf("ORDER BY")
                If orderByIndex > 0 Then
                    query = query.Substring(0, orderByIndex)
                End If

                Dim cmd As New SqlCommand(query, con)
                AddSearchParameters(cmd)

                Return CInt(cmd.ExecuteScalar())
            End Using
        Catch ex As Exception
            Return 0
        End Try
    End Function

    ' Redirect to Add Vehicle page
    Protected Sub btnAddNewVehicle_Click(sender As Object, e As EventArgs) Handles btnAddVehicles.Click, btnAddFirstVehicle.Click
        Response.Redirect("AddVehicles.aspx")
    End Sub

    ' Toggle vehicle availability status
    Protected Sub btnToggleStatus_Command(sender As Object, e As CommandEventArgs)
        Try
            Dim args As String() = e.CommandArgument.ToString().Split(","c)
            Dim vehicleID As Integer = CInt(args(0))
            Dim currentStatus As String = args(1)
            Dim newStatus As String = ""

            Select Case currentStatus.ToUpper()
                Case "AVAILABLE" : newStatus = "Maintenance"
                Case "MAINTENANCE", "RENTED" : newStatus = "Available"
                Case Else : newStatus = "Available"
            End Select

            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("UPDATE Vehicles SET Status = @Status WHERE VehicleID = @VehicleID", con)
                cmd.Parameters.AddWithValue("@Status", newStatus)
                cmd.Parameters.AddWithValue("@VehicleID", vehicleID)

                If cmd.ExecuteNonQuery() > 0 Then
                    ShowMessage($"Vehicle status updated to '{newStatus}' successfully!", "alert-success")
                    LoadVehicles()
                Else
                    ShowMessage("Failed to update vehicle status.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error updating vehicle status: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Delete a vehicle (soft delete)
    Protected Sub btnDelete_Command(sender As Object, e As CommandEventArgs)
        Try
            Dim vehicleID As Integer = CInt(e.CommandArgument)

            Using con As New SqlConnection(connStr)
                con.Open()

                ' Check for related bookings
                Dim checkCmd As New SqlCommand("SELECT COUNT(*) FROM Bookings WHERE VehicleID = @VehicleID", con)
                checkCmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                Dim bookingCount As Integer = CInt(checkCmd.ExecuteScalar())

                If bookingCount > 0 Then
                    ShowMessage("Cannot delete vehicle. It has existing bookings. Consider setting it to inactive instead.", "alert-warning")
                    Return
                End If

                ' Soft delete
                Dim cmd As New SqlCommand("UPDATE Vehicles SET IsActive = 0 WHERE VehicleID = @VehicleID", con)
                cmd.Parameters.AddWithValue("@VehicleID", vehicleID)

                If cmd.ExecuteNonQuery() > 0 Then
                    ShowMessage("Vehicle deleted successfully!", "alert-success")
                    LoadVehicles()
                Else
                    ShowMessage("Failed to delete vehicle.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error deleting vehicle: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Handles pagination link clicks
    Protected Sub lnkPage_Command(sender As Object, e As CommandEventArgs)
        Try
            Dim pageNum As String = e.CommandArgument.ToString()

            Select Case pageNum.ToLower()
                Case "previous" : If CurrentPage > 1 Then CurrentPage -= 1
                Case "next" : CurrentPage += 1
                Case Else : If IsNumeric(pageNum) Then CurrentPage = CInt(pageNum)
            End Select

            LoadVehicles()
        Catch ex As Exception
            ShowMessage("Error navigating pages: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Returns image path for vehicle, falling back to default if not found
    Protected Function GetVehicleImagePath(vehicleID As Object) As String
        If vehicleID IsNot Nothing AndAlso Not IsDBNull(vehicleID) Then
            Try
                Using con As New SqlConnection(connStr)
                    con.Open()
                    Dim cmd As New SqlCommand("SELECT TOP 1 ImagePath FROM VehicleImages WHERE VehicleID = @VehicleID AND IsActive = 1 ORDER BY DisplayOrder", con)
                    cmd.Parameters.AddWithValue("@VehicleID", vehicleID)
                    Dim imagePath As Object = cmd.ExecuteScalar()

                    If imagePath IsNot Nothing AndAlso Not IsDBNull(imagePath) Then
                        Dim path As String = imagePath.ToString()
                        If path.StartsWith("~/") Then path = path.Substring(2)
                        Return path
                    End If
                End Using

                Return "images/vehicles/" & vehicleID.ToString() & ".jpg"
            Catch ex As Exception
                Return "images/no-vehicle-image.jpg"
            End Try
        End If
        Return "images/no-vehicle-image.jpg"
    End Function

    ' Returns CSS class for vehicle status
    Protected Function GetStatusClass(status As Object) As String
        If status IsNot Nothing Then
            Select Case status.ToString().ToLower()
                Case "available" : Return "status-available"
                Case "rented" : Return "status-rented"
                Case "maintenance" : Return "status-maintenance"
            End Select
        End If
        Return "status-rented"
    End Function

    ' Returns button text based on current status
    Protected Function GetToggleButtonText(status As Object) As String
        If status IsNot Nothing Then
            Select Case status.ToString().ToUpper()
                Case "AVAILABLE" : Return "Set Maintenance"
                Case "MAINTENANCE", "RENTED" : Return "Set Available"
            End Select
        End If
        Return "Set Available"
    End Function

    ' Returns CSS class for toggle button
    Protected Function GetToggleButtonClass(status As Object) As String
        If status IsNot Nothing Then
            Select Case status.ToString().ToUpper()
                Case "AVAILABLE" : Return "btn btn-warning btn-sm"
                Case "MAINTENANCE", "RENTED" : Return "btn btn-success btn-sm"
            End Select
        End If
        Return "btn btn-success btn-sm"
    End Function

    ' Shows alert messages on the page
    Private Sub ShowMessage(message As String, cssClass As String)
        Try
            lblMessage.Text = message
            pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
            pnlMessage.Visible = True

            ' Auto-hide message after 5 seconds using JS
            ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
                "setTimeout(function(){ " &
                "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
                "if(msgPanel) { " &
                "msgPanel.style.opacity = '0'; " &
                "setTimeout(function(){ msgPanel.style.display = 'none'; }, 300); " &
                "} " &
                "}, 5000);", True)
        Catch ex As Exception
            ' Ignore display errors
        End Try
    End Sub

End Class