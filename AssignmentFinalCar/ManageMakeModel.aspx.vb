Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI.WebControls
Public Class WebForm13
    Inherits System.Web.UI.Page

    ' Page Load event - runs when the page first loads
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security check: Ensure user is logged in and has admin privileges
        If Session("Username") Is Nothing OrElse Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx")
        End If

        ' Only run initialization code on first page load (not on postbacks)
        If Not IsPostBack Then
            LoadMakes()           ' Load all car makes into the grid
            LoadModels()          ' Load all car models into the grid
            PopulateMakeDropDowns() ' Fill dropdown lists with available makes
            pnlMessage.Visible = False ' Hide any message panels initially
        End If
    End Sub

#Region "Make Management"
    ' This region contains all functions related to managing car makes

    ' Event handler for adding a new car make
    Protected Sub btnAddMake_Click(sender As Object, e As EventArgs) Handles btnAddMake.Click
        Try
            ' Get input values from form controls
            Dim makeName As String = txtMakeName.Text.Trim()
            Dim country As String = txtCountry.Text.Trim()
            Dim description As String = txtMakeDescription.Text.Trim()

            ' Validation: Check if make name is provided
            If String.IsNullOrEmpty(makeName) Then
                ShowMessage("Make name is required.", "alert-danger")
                Return
            End If

            ' Check if a make with this name already exists in database
            If CheckMakeExists(makeName) Then
                ShowMessage("A make with this name already exists.", "alert-danger")
                Return
            End If

            ' Database operation: Insert the new make
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' SQL INSERT command with parameters to prevent SQL injection
                Dim cmd As New SqlCommand("INSERT INTO Make (MakeName, Country, Description, CreatedBy, CreatedDate, IsActive) VALUES (@MakeName, @Country, @Description, @CreatedBy, @CreatedDate, @IsActive)", con)

                ' Add parameters with proper null handling
                cmd.Parameters.AddWithValue("@MakeName", makeName)
                cmd.Parameters.AddWithValue("@Country", If(String.IsNullOrEmpty(country), DBNull.Value, country))
                cmd.Parameters.AddWithValue("@Description", If(String.IsNullOrEmpty(description), DBNull.Value, description))
                cmd.Parameters.AddWithValue("@CreatedBy", Session("UserID"))
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
                cmd.Parameters.AddWithValue("@IsActive", True)

                ' Execute the command and check if successful
                Dim result As Integer = cmd.ExecuteNonQuery()

                If result > 0 Then
                    ' Success: Show message and refresh data
                    ShowMessage("Make added successfully!", "alert-success")
                    ClearMakeForm()           ' Clear the input form
                    LoadMakes()               ' Refresh the makes grid
                    PopulateMakeDropDowns()   ' Update dropdown lists
                Else
                    ShowMessage("Failed to add make. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ' Error handling: Show any database or system errors
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Event handler for updating an existing car make
    Protected Sub btnUpdateMake_Click(sender As Object, e As EventArgs) Handles btnUpdateMake.Click
        Try
            ' Get the ID of the make being updated (stored in hidden field)
            Dim makeID As Integer = Convert.ToInt32(hfSelectedMakeID.Value)
            Dim makeName As String = txtMakeName.Text.Trim()
            Dim country As String = txtCountry.Text.Trim()
            Dim description As String = txtMakeDescription.Text.Trim()

            ' Validation: Ensure make name is provided
            If String.IsNullOrEmpty(makeName) Then
                ShowMessage("Make name is required.", "alert-danger")
                Return
            End If

            ' Check if make name conflicts with other existing makes (excluding current one)
            If CheckMakeExistsForUpdate(makeName, makeID) Then
                ShowMessage("A make with this name already exists.", "alert-danger")
                Return
            End If

            ' Database operation: Update the existing make
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' SQL UPDATE command with parameters
                Dim cmd As New SqlCommand("UPDATE Make SET MakeName = @MakeName, Country = @Country, Description = @Description WHERE MakeID = @MakeID", con)

                cmd.Parameters.AddWithValue("@MakeID", makeID)
                cmd.Parameters.AddWithValue("@MakeName", makeName)
                cmd.Parameters.AddWithValue("@Country", If(String.IsNullOrEmpty(country), DBNull.Value, country))
                cmd.Parameters.AddWithValue("@Description", If(String.IsNullOrEmpty(description), DBNull.Value, description))

                Dim result As Integer = cmd.ExecuteNonQuery()

                If result > 0 Then
                    ' Success: Show message and refresh data
                    ShowMessage("Make updated successfully!", "alert-success")
                    ClearMakeForm()
                    LoadMakes()
                    PopulateMakeDropDowns()
                Else
                    ShowMessage("Failed to update make. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Cancel button - clears the form and resets to add mode
    Protected Sub btnCancelMake_Click(sender As Object, e As EventArgs) Handles btnCancelMake.Click
        ClearMakeForm()
    End Sub

    ' Search button - filters the makes grid based on search criteria
    Protected Sub btnSearchMake_Click(sender As Object, e As EventArgs) Handles btnSearchMake.Click
        LoadMakes()
    End Sub

    ' Reset search - clears search box and shows all makes
    Protected Sub btnResetMake_Click(sender As Object, e As EventArgs) Handles btnResetMake.Click
        txtSearchMake.Text = ""
        LoadMakes()
    End Sub

    ' Handle pagination in the makes grid view
    Protected Sub gvMakes_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvMakes.PageIndexChanging
        gvMakes.PageIndex = e.NewPageIndex
        LoadMakes()
    End Sub

    ' Handle button clicks within the grid (Edit and Toggle Status buttons)
    Protected Sub gvMakes_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMakes.RowCommand
        Try
            ' Get the MakeID from the button that was clicked
            Dim makeID As Integer = Convert.ToInt32(e.CommandArgument)

            ' Determine which action to take based on the command name
            If e.CommandName = "EditMake" Then
                LoadMakeForEdit(makeID)    ' Load make data into form for editing
            ElseIf e.CommandName = "ToggleStatus" Then
                ToggleMakeStatus(makeID)   ' Activate/deactivate the make
            End If

        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load a specific make's data into the form for editing
    Private Sub LoadMakeForEdit(makeID As Integer)
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Query to get make details by ID
                Dim cmd As New SqlCommand("SELECT * FROM Make WHERE MakeID = @MakeID", con)
                cmd.Parameters.AddWithValue("@MakeID", makeID)

                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    ' Populate form fields with database values
                    hfSelectedMakeID.Value = reader("MakeID").ToString()
                    txtMakeName.Text = reader("MakeName").ToString()
                    txtCountry.Text = If(IsDBNull(reader("Country")), "", reader("Country").ToString())
                    txtMakeDescription.Text = If(IsDBNull(reader("Description")), "", reader("Description").ToString())

                    ' Switch to edit mode by changing button visibility
                    btnAddMake.Visible = False
                    btnUpdateMake.Visible = True
                    btnCancelMake.Visible = True
                End If
                reader.Close()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading make: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Toggle the active/inactive status of a make
    Private Sub ToggleMakeStatus(makeID As Integer)
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' SQL command that flips the IsActive status (1 becomes 0, 0 becomes 1)
                Dim cmd As New SqlCommand("UPDATE Make SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE MakeID = @MakeID", con)
                cmd.Parameters.AddWithValue("@MakeID", makeID)

                Dim result As Integer = cmd.ExecuteNonQuery()
                If result > 0 Then
                    ShowMessage("Make status updated successfully!", "alert-success")
                    LoadMakes() ' Refresh the grid to show updated status
                Else
                    ShowMessage("Failed to update make status.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load all makes from database and bind to grid view
    Private Sub LoadMakes()
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Base query to select make information
                Dim query As String = "SELECT MakeID, MakeName, Country, Description, IsActive, CreatedDate FROM Make WHERE 1=1"

                ' Add search filter if search text is provided
                If Not String.IsNullOrEmpty(txtSearchMake.Text.Trim()) Then
                    query &= " AND (MakeName LIKE @SearchTerm OR Country LIKE @SearchTerm)"
                End If

                query &= " ORDER BY MakeName" ' Sort results alphabetically

                Dim cmd As New SqlCommand(query, con)
                ' Add search parameter if needed
                If Not String.IsNullOrEmpty(txtSearchMake.Text.Trim()) Then
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" & txtSearchMake.Text.Trim() & "%")
                End If

                ' Fill DataTable and bind to GridView
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                gvMakes.DataSource = dt
                gvMakes.DataBind()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading makes: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Clear all input fields in the make form and reset to add mode
    Private Sub ClearMakeForm()
        txtMakeName.Text = ""
        txtCountry.Text = ""
        txtMakeDescription.Text = ""
        hfSelectedMakeID.Value = ""

        ' Reset button visibility to add mode
        btnAddMake.Visible = True
        btnUpdateMake.Visible = False
        btnCancelMake.Visible = False
    End Sub

    ' Check if a make with the given name already exists
    Private Function CheckMakeExists(makeName As String) As Boolean
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Count how many makes have this name
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Make WHERE MakeName = @MakeName", con)
                cmd.Parameters.AddWithValue("@MakeName", makeName)

                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0 ' Return true if any exist
            End Using
        Catch ex As Exception
            Return False ' If error occurs, assume it doesn't exist
        End Try
    End Function

    ' Check if a make name exists for other records (used during updates)
    Private Function CheckMakeExistsForUpdate(makeName As String, makeID As Integer) As Boolean
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Count makes with this name, excluding the current make being updated
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Make WHERE MakeName = @MakeName AND MakeID <> @MakeID", con)
                cmd.Parameters.AddWithValue("@MakeName", makeName)
                cmd.Parameters.AddWithValue("@MakeID", makeID)

                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

#End Region

#Region "Model Management"
    ' This region contains all functions related to managing car models

    ' Event handler for adding a new car model
    Protected Sub btnAddModel_Click(sender As Object, e As EventArgs) Handles btnAddModel.Click
        Try
            ' Get input values from form controls
            Dim makeID As Integer = Convert.ToInt32(ddlMake.SelectedValue)
            Dim modelName As String = txtModelName.Text.Trim()
            Dim year As String = txtYear.Text.Trim()
            Dim fuelType As String = ddlFuelType.SelectedValue
            Dim transmission As String = ddlTransmission.SelectedValue
            Dim seatingCapacity As String = txtSeatingCapacity.Text.Trim()
            Dim description As String = txtModelDescription.Text.Trim()

            ' Validation: Ensure a make is selected
            If makeID = 0 Then
                ShowMessage("Please select a make.", "alert-danger")
                Return
            End If

            ' Validation: Ensure model name is provided
            If String.IsNullOrEmpty(modelName) Then
                ShowMessage("Model name is required.", "alert-danger")
                Return
            End If

            ' Validate year if provided (must be between 1900 and 2 years in future)
            If Not String.IsNullOrEmpty(year) Then
                Dim yearValue As Integer
                If Not Integer.TryParse(year, yearValue) OrElse yearValue < 1900 OrElse yearValue > DateTime.Now.Year + 2 Then
                    ShowMessage("Please enter a valid year.", "alert-danger")
                    Return
                End If
            End If

            ' Check if model already exists for this make and year combination
            If CheckModelExists(makeID, modelName, If(String.IsNullOrEmpty(year), Nothing, Convert.ToInt32(year))) Then
                ShowMessage("A model with this name and year already exists for the selected make.", "alert-danger")
                Return
            End If

            ' Database operation: Insert the new model
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("INSERT INTO Model (MakeID, ModelName, Year, FuelType, Transmission, SeatingCapacity, Description, CreatedBy, CreatedDate, IsActive) VALUES (@MakeID, @ModelName, @Year, @FuelType, @Transmission, @SeatingCapacity, @Description, @CreatedBy, @CreatedDate, @IsActive)", con)

                ' Add parameters with proper null handling and type conversion
                cmd.Parameters.AddWithValue("@MakeID", makeID)
                cmd.Parameters.AddWithValue("@ModelName", modelName)
                cmd.Parameters.AddWithValue("@Year", If(String.IsNullOrEmpty(year), DBNull.Value, Convert.ToInt32(year)))
                cmd.Parameters.AddWithValue("@FuelType", If(String.IsNullOrEmpty(fuelType), DBNull.Value, fuelType))
                cmd.Parameters.AddWithValue("@Transmission", If(String.IsNullOrEmpty(transmission), DBNull.Value, transmission))
                cmd.Parameters.AddWithValue("@SeatingCapacity", If(String.IsNullOrEmpty(seatingCapacity), DBNull.Value, Convert.ToInt32(seatingCapacity)))
                cmd.Parameters.AddWithValue("@Description", If(String.IsNullOrEmpty(description), DBNull.Value, description))
                cmd.Parameters.AddWithValue("@CreatedBy", Session("UserID"))
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
                cmd.Parameters.AddWithValue("@IsActive", True)

                Dim result As Integer = cmd.ExecuteNonQuery()

                If result > 0 Then
                    ' Success: Show message, clear form, refresh data, and switch to models tab
                    ShowMessage("Model added successfully!", "alert-success")
                    ClearModelForm()
                    LoadModels()
                    Session("ActiveTab") = "models" ' Remember which tab to show
                Else
                    ShowMessage("Failed to add model. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Event handler for updating an existing car model
    Protected Sub btnUpdateModel_Click(sender As Object, e As EventArgs) Handles btnUpdateModel.Click
        Try
            ' Get values from form (including hidden field with model ID)
            Dim modelID As Integer = Convert.ToInt32(hfSelectedModelID.Value)
            Dim makeID As Integer = Convert.ToInt32(ddlMake.SelectedValue)
            Dim modelName As String = txtModelName.Text.Trim()
            Dim year As String = txtYear.Text.Trim()
            Dim fuelType As String = ddlFuelType.SelectedValue
            Dim transmission As String = ddlTransmission.SelectedValue
            Dim seatingCapacity As String = txtSeatingCapacity.Text.Trim()
            Dim description As String = txtModelDescription.Text.Trim()

            ' Validation checks (same as add operation)
            If makeID = 0 Then
                ShowMessage("Please select a make.", "alert-danger")
                Return
            End If

            If String.IsNullOrEmpty(modelName) Then
                ShowMessage("Model name is required.", "alert-danger")
                Return
            End If

            ' Validate year range
            If Not String.IsNullOrEmpty(year) Then
                Dim yearValue As Integer
                If Not Integer.TryParse(year, yearValue) OrElse yearValue < 1900 OrElse yearValue > DateTime.Now.Year + 2 Then
                    ShowMessage("Please enter a valid year.", "alert-danger")
                    Return
                End If
            End If

            ' Check for conflicts with other models (excluding current one)
            If CheckModelExistsForUpdate(makeID, modelName, If(String.IsNullOrEmpty(year), Nothing, Convert.ToInt32(year)), modelID) Then
                ShowMessage("A model with this name and year already exists for the selected make.", "alert-danger")
                Return
            End If

            ' Database operation: Update the existing model
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("UPDATE Model SET MakeID = @MakeID, ModelName = @ModelName, Year = @Year, FuelType = @FuelType, Transmission = @Transmission, SeatingCapacity = @SeatingCapacity, Description = @Description WHERE ModelID = @ModelID", con)

                cmd.Parameters.AddWithValue("@ModelID", modelID)
                cmd.Parameters.AddWithValue("@MakeID", makeID)
                cmd.Parameters.AddWithValue("@ModelName", modelName)
                cmd.Parameters.AddWithValue("@Year", If(String.IsNullOrEmpty(year), DBNull.Value, Convert.ToInt32(year)))
                cmd.Parameters.AddWithValue("@FuelType", If(String.IsNullOrEmpty(fuelType), DBNull.Value, fuelType))
                cmd.Parameters.AddWithValue("@Transmission", If(String.IsNullOrEmpty(transmission), DBNull.Value, transmission))
                cmd.Parameters.AddWithValue("@SeatingCapacity", If(String.IsNullOrEmpty(seatingCapacity), DBNull.Value, Convert.ToInt32(seatingCapacity)))
                cmd.Parameters.AddWithValue("@Description", If(String.IsNullOrEmpty(description), DBNull.Value, description))

                Dim result As Integer = cmd.ExecuteNonQuery()

                If result > 0 Then
                    ShowMessage("Model updated successfully!", "alert-success")
                    ClearModelForm()
                    LoadModels()
                    Session("ActiveTab") = "models"
                Else
                    ShowMessage("Failed to update model. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Cancel button for model form
    Protected Sub btnCancelModel_Click(sender As Object, e As EventArgs) Handles btnCancelModel.Click
        ClearModelForm()
        Session("ActiveTab") = "models"
    End Sub

    ' Search models based on criteria
    Protected Sub btnSearchModel_Click(sender As Object, e As EventArgs) Handles btnSearchModel.Click
        LoadModels()
        Session("ActiveTab") = "models"
    End Sub

    ' Reset model search filters
    Protected Sub btnResetModel_Click(sender As Object, e As EventArgs) Handles btnResetModel.Click
        ddlSearchMake.SelectedIndex = 0
        txtSearchModel.Text = ""
        ddlSearchFuel.SelectedIndex = 0
        LoadModels()
        Session("ActiveTab") = "models"
    End Sub

    ' Handle pagination in models grid
    Protected Sub gvModels_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvModels.PageIndexChanging
        gvModels.PageIndex = e.NewPageIndex
        LoadModels()
        Session("ActiveTab") = "models"
    End Sub

    ' Handle button clicks in models grid (Edit and Toggle Status)
    Protected Sub gvModels_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvModels.RowCommand
        Try
            Dim modelID As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditModel" Then
                LoadModelForEdit(modelID)
                Session("ActiveTab") = "models"
            ElseIf e.CommandName = "ToggleStatus" Then
                ToggleModelStatus(modelID)
                Session("ActiveTab") = "models"
            End If

        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load a specific model's data into the form for editing
    Private Sub LoadModelForEdit(modelID As Integer)
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("SELECT * FROM Model WHERE ModelID = @ModelID", con)
                cmd.Parameters.AddWithValue("@ModelID", modelID)

                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    ' Populate form fields with database values
                    hfSelectedModelID.Value = reader("ModelID").ToString()
                    ddlMake.SelectedValue = reader("MakeID").ToString()
                    txtModelName.Text = reader("ModelName").ToString()
                    txtYear.Text = If(IsDBNull(reader("Year")), "", reader("Year").ToString())
                    ddlFuelType.SelectedValue = If(IsDBNull(reader("FuelType")), "", reader("FuelType").ToString())
                    ddlTransmission.SelectedValue = If(IsDBNull(reader("Transmission")), "", reader("Transmission").ToString())
                    txtSeatingCapacity.Text = If(IsDBNull(reader("SeatingCapacity")), "", reader("SeatingCapacity").ToString())
                    txtModelDescription.Text = If(IsDBNull(reader("Description")), "", reader("Description").ToString())

                    ' Switch to edit mode
                    btnAddModel.Visible = False
                    btnUpdateModel.Visible = True
                    btnCancelModel.Visible = True
                End If
                reader.Close()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading model: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Toggle active/inactive status of a model
    Private Sub ToggleModelStatus(modelID As Integer)
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                Dim cmd As New SqlCommand("UPDATE Model SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE ModelID = @ModelID", con)
                cmd.Parameters.AddWithValue("@ModelID", modelID)

                Dim result As Integer = cmd.ExecuteNonQuery()
                If result > 0 Then
                    ShowMessage("Model status updated successfully!", "alert-success")
                    LoadModels()
                Else
                    ShowMessage("Failed to update model status.", "alert-danger")
                End If
            End Using
        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Load all models with optional filtering and bind to grid
    Private Sub LoadModels()
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Join Models table with Makes table to get make names
                Dim query As String = "SELECT m.ModelID, mk.MakeName, m.ModelName, m.Year, m.FuelType, m.Transmission, m.SeatingCapacity, m.Description, m.IsActive, m.CreatedDate " &
                                    "FROM Model m INNER JOIN Make mk ON m.MakeID = mk.MakeID WHERE 1=1"

                ' Add search filters based on user input
                If Not String.IsNullOrEmpty(ddlSearchMake.SelectedValue) Then
                    query &= " AND m.MakeID = @MakeID"
                End If

                If Not String.IsNullOrEmpty(txtSearchModel.Text.Trim()) Then
                    query &= " AND m.ModelName LIKE @ModelName"
                End If

                If Not String.IsNullOrEmpty(ddlSearchFuel.SelectedValue) Then
                    query &= " AND m.FuelType = @FuelType"
                End If

                query &= " ORDER BY mk.MakeName, m.ModelName"

                Dim cmd As New SqlCommand(query, con)

                ' Add parameters based on what filters are active
                If Not String.IsNullOrEmpty(ddlSearchMake.SelectedValue) Then
                    cmd.Parameters.AddWithValue("@MakeID", ddlSearchMake.SelectedValue)
                End If

                If Not String.IsNullOrEmpty(txtSearchModel.Text.Trim()) Then
                    cmd.Parameters.AddWithValue("@ModelName", "%" & txtSearchModel.Text.Trim() & "%")
                End If

                If Not String.IsNullOrEmpty(ddlSearchFuel.SelectedValue) Then
                    cmd.Parameters.AddWithValue("@FuelType", ddlSearchFuel.SelectedValue)
                End If

                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                gvModels.DataSource = dt
                gvModels.DataBind()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading models: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Clear model form and reset to add mode
    Private Sub ClearModelForm()
        ddlMake.SelectedIndex = 0
        txtModelName.Text = ""
        txtYear.Text = ""
        ddlFuelType.SelectedIndex = 0
        ddlTransmission.SelectedIndex = 0
        txtSeatingCapacity.Text = ""
        txtModelDescription.Text = ""
        hfSelectedModelID.Value = ""

        ' Reset button visibility
        btnAddModel.Visible = True
        btnUpdateModel.Visible = False
        btnCancelModel.Visible = False
    End Sub

    ' Check if a model with given specifications already exists
    Private Function CheckModelExists(makeID As Integer, modelName As String, year As Integer?) As Boolean
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Build query to check for duplicate models
                Dim query As String = "SELECT COUNT(*) FROM Model WHERE MakeID = @MakeID AND ModelName = @ModelName"

                ' Handle year comparison (including null values)
                If year.HasValue Then
                    query &= " AND Year = @Year"
                Else
                    query &= " AND Year IS NULL"
                End If

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@MakeID", makeID)
                cmd.Parameters.AddWithValue("@ModelName", modelName)

                If year.HasValue Then
                    cmd.Parameters.AddWithValue("@Year", year.Value)
                End If

                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

    ' Check if model exists for update (excluding current model)
    Private Function CheckModelExistsForUpdate(makeID As Integer, modelName As String, year As Integer?, modelID As Integer) As Boolean
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Similar to above but excludes the current model being updated
                Dim query As String = "SELECT COUNT(*) FROM Model WHERE MakeID = @MakeID AND ModelName = @ModelName AND ModelID <> @ModelID"

                If year.HasValue Then
                    query &= " AND Year = @Year"
                Else
                    query &= " AND Year IS NULL"
                End If

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@MakeID", makeID)
                cmd.Parameters.AddWithValue("@ModelName", modelName)
                cmd.Parameters.AddWithValue("@ModelID", modelID)

                If year.HasValue Then
                    cmd.Parameters.AddWithValue("@Year", year.Value)
                End If

                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

#End Region

    ' Populate dropdown lists with active car makes
    Private Sub PopulateMakeDropDowns()
        Try
            Dim connStr As String = GetConnectionString()
            Using con As New SqlConnection(connStr)
                con.Open()
                ' Get only active makes, sorted alphabetically
                Dim cmd As New SqlCommand("SELECT MakeID, MakeName FROM Make WHERE IsActive = 1 ORDER BY MakeName", con)
                Dim reader As SqlDataReader = cmd.ExecuteReader()

                ' Clear existing items and add default options
                ddlMake.Items.Clear()
                ddlMake.Items.Add(New ListItem("-- Select Make --", ""))

                ddlSearchMake.Items.Clear()
                ddlSearchMake.Items.Add(New ListItem("-- All Makes --", ""))

                ' Add each make to both dropdown lists
                While reader.Read()
                    Dim makeID As String = reader("MakeID").ToString()
                    Dim makeName As String = reader("MakeName").ToString()

                    ddlMake.Items.Add(New ListItem(makeName, makeID))
                    ddlSearchMake.Items.Add(New ListItem(makeName, makeID))
                End While

                reader.Close()
            End Using
        Catch ex As Exception
            ShowMessage("Error loading makes: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Display success or error messages to the user
    Private Sub ShowMessage(message As String, alertType As String)
        lblMessage.Text = message                    ' Set the message text
        pnlMessage.CssClass = "alert " & alertType  ' Set the CSS class for styling (success/danger)
        pnlMessage.Visible = True                   ' Make the message panel visible
    End Sub

    ' Get database connection string from web.config file
    Private Function GetConnectionString() As String
        ' Retrieve connection string from configuration file
        Return ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
    End Function
End Class