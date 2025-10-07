Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Text.RegularExpressions
Imports System.Security.Cryptography
Imports System.Text
Public Class WebForm10
    Inherits System.Web.UI.Page

    ' Page Load Event - Runs when the page is first loaded
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security Check: Ensure only logged-in admins can access this page
        If Session("Username") Is Nothing Or Session("UserType") <> "Admin" Then
            Response.Redirect("Login.aspx") ' Redirect to login if not authorized
        End If

        ' Initialize page on first load (not on postback)
        If Not IsPostBack Then
            ClearValidationErrors() ' Clear any error messages
            pnlMessage.Visible = False ' Hide success/error message panel
        End If
    End Sub

    ' Register Button Click Event - Handles form submission
    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegister.Click
        ' Clear any previous validation errors
        ClearValidationErrors()

        ' Get values from form controls and trim whitespace
        Dim firstName As String = txtFirstName.Text.Trim()
        Dim lastName As String = txtLastName.Text.Trim()
        Dim username As String = txtUsername.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim password As String = txtPassword.Text
        Dim confirmPassword As String = txtConfirmPassword.Text
        Dim dateOfBirth As String = txtDateOfBirth.Text
        Dim gender As String = ddlGender.SelectedValue
        Dim address As String = txtAddress.Text.Trim()

        ' Validate all form fields before proceeding
        If Not ValidateAllFields(firstName, lastName, username, email, phone, password, confirmPassword, dateOfBirth, gender, address) Then
            Return ' Stop execution if validation fails
        End If

        ' Check if username already exists in database
        If CheckUsernameExists(username) Then
            lblUsernameError.Text = "Username already exists. Please choose a different username."
            lblUsernameError.Visible = True
            Return ' Stop execution if username exists
        End If

        ' Check if email already exists in database
        If CheckEmailExists(email) Then
            lblEmailError.Text = "Email address is already registered. Please use a different email."
            lblEmailError.Visible = True
            Return ' Stop execution if email exists
        End If

        ' Insert new admin user into database
        Try
            ' Get database connection string from web.config
            Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

            ' Use 'Using' statement to ensure proper disposal of database resources
            Using con As New SqlConnection(connStr)
                con.Open() ' Open database connection

                ' Create SQL command to insert new admin user
                Dim cmd As New SqlCommand("INSERT INTO Users (FirstName, LastName, Username, Email, Phone, Password, DateOfBirth, Gender, Address, UserType, IsActive) VALUES (@FirstName, @LastName, @Username, @Email, @Phone, @Password, @DateOfBirth, @Gender, @Address, @UserType, @IsActive)", con)

                ' Add parameters to prevent SQL injection attacks
                cmd.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = firstName
                cmd.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = lastName
                cmd.Parameters.Add("@Username", SqlDbType.NVarChar).Value = username
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = email
                cmd.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = phone
                cmd.Parameters.Add("@Password", SqlDbType.NVarChar).Value = HashPassword(password) ' Hash password for security
                cmd.Parameters.Add("@DateOfBirth", SqlDbType.Date).Value = DateTime.Parse(dateOfBirth)
                cmd.Parameters.Add("@Gender", SqlDbType.NVarChar).Value = gender
                cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = address
                cmd.Parameters.Add("@UserType", SqlDbType.NVarChar).Value = "Admin" ' Set user type as Admin
                cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = True ' Set account as active

                ' Execute the insert command
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                ' Check if insertion was successful
                If rowsAffected > 0 Then
                    ' Show success message
                    ShowMessage("Admin account created successfully! Username: " & username, "alert-success")
                    ClearForm() ' Clear all form fields

                    ' Redirect to manage users page after 3 seconds using JavaScript
                    ClientScript.RegisterStartupScript(Me.GetType(), "redirect",
                        "setTimeout(function(){ window.location.href='ManageUsers.aspx'; }, 3000);", True)
                Else
                    ' Show error message if insertion failed
                    ShowMessage("Failed to create admin account. Please try again.", "alert-danger")
                End If
            End Using

        Catch ex As Exception
            ' Handle any database errors
            ShowMessage("An error occurred while creating the admin account: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Cancel Button Click Event - Returns to Manage Users page
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        Response.Redirect("ManageUsers.aspx")
    End Sub

    ' Comprehensive validation function for all form fields
    Private Function ValidateAllFields(firstName As String, lastName As String, username As String, email As String, phone As String, password As String, confirmPassword As String, dateOfBirth As String, gender As String, address As String) As Boolean
        Dim isValid As Boolean = True ' Track overall validation status

        ' Validate First Name
        If String.IsNullOrEmpty(firstName) Then
            lblFirstNameError.Text = "First name is required"
            lblFirstNameError.Visible = True
            isValid = False
        ElseIf firstName.Length < 2 Then
            lblFirstNameError.Text = "First name must be at least 2 characters"
            lblFirstNameError.Visible = True
            isValid = False
        ElseIf Not IsValidName(firstName) Then
            lblFirstNameError.Text = "First name can only contain letters and spaces"
            lblFirstNameError.Visible = True
            isValid = False
        End If

        ' Validate Last Name
        If String.IsNullOrEmpty(lastName) Then
            lblLastNameError.Text = "Last name is required"
            lblLastNameError.Visible = True
            isValid = False
        ElseIf lastName.Length < 2 Then
            lblLastNameError.Text = "Last name must be at least 2 characters"
            lblLastNameError.Visible = True
            isValid = False
        ElseIf Not IsValidName(lastName) Then
            lblLastNameError.Text = "Last name can only contain letters and spaces"
            lblLastNameError.Visible = True
            isValid = False
        End If

        ' Validate Username
        If String.IsNullOrEmpty(username) Then
            lblUsernameError.Text = "Username is required"
            lblUsernameError.Visible = True
            isValid = False
        ElseIf username.Length < 4 Or username.Length > 20 Then
            lblUsernameError.Text = "Username must be between 4-20 characters"
            lblUsernameError.Visible = True
            isValid = False
        ElseIf Not IsValidUsername(username) Then
            lblUsernameError.Text = "Username can only contain letters, numbers, and underscores"
            lblUsernameError.Visible = True
            isValid = False
        End If

        ' Validate Email
        If String.IsNullOrEmpty(email) Then
            lblEmailError.Text = "Email is required"
            lblEmailError.Visible = True
            isValid = False
        ElseIf Not IsValidEmail(email) Then
            lblEmailError.Text = "Please enter a valid email address"
            lblEmailError.Visible = True
            isValid = False
        End If

        ' Validate Phone Number
        If String.IsNullOrEmpty(phone) Then
            lblPhoneError.Text = "Phone number is required"
            lblPhoneError.Visible = True
            isValid = False
        ElseIf Not IsValidPhone(phone) Then
            lblPhoneError.Text = "Please enter a valid phone number (8-15 digits)"
            lblPhoneError.Visible = True
            isValid = False
        End If

        ' Validate Password
        If String.IsNullOrEmpty(password) Then
            lblPasswordError.Text = "Password is required"
            lblPasswordError.Visible = True
            isValid = False
        ElseIf Not IsValidPassword(password) Then
            lblPasswordError.Text = "Password must be 8+ characters with uppercase, lowercase, and number"
            lblPasswordError.Visible = True
            isValid = False
        End If

        ' Validate Confirm Password
        If String.IsNullOrEmpty(confirmPassword) Then
            lblConfirmPasswordError.Text = "Please confirm your password"
            lblConfirmPasswordError.Visible = True
            isValid = False
        ElseIf password <> confirmPassword Then
            lblConfirmPasswordError.Text = "Passwords do not match"
            lblConfirmPasswordError.Visible = True
            isValid = False
        End If

        ' Validate Date of Birth
        If String.IsNullOrEmpty(dateOfBirth) Then
            lblDateOfBirthError.Text = "Date of birth is required"
            lblDateOfBirthError.Visible = True
            isValid = False
        Else
            Dim birthDate As DateTime
            If DateTime.TryParse(dateOfBirth, birthDate) Then
                ' Calculate age
                Dim age As Integer = DateTime.Now.Year - birthDate.Year
                If birthDate > DateTime.Now.AddYears(-age) Then age -= 1

                ' Check age requirements for admin
                If age < 18 Then
                    lblDateOfBirthError.Text = "Admin must be at least 18 years old"
                    lblDateOfBirthError.Visible = True
                    isValid = False
                ElseIf age > 120 Then
                    lblDateOfBirthError.Text = "Please enter a valid date of birth"
                    lblDateOfBirthError.Visible = True
                    isValid = False
                End If
            Else
                lblDateOfBirthError.Text = "Please enter a valid date"
                lblDateOfBirthError.Visible = True
                isValid = False
            End If
        End If

        ' Validate Gender Selection
        If String.IsNullOrEmpty(gender) Then
            lblGenderError.Text = "Please select gender"
            lblGenderError.Visible = True
            isValid = False
        End If

        ' Validate Address
        If String.IsNullOrEmpty(address) Then
            lblAddressError.Text = "Address is required"
            lblAddressError.Visible = True
            isValid = False
        ElseIf address.Length < 5 Then
            lblAddressError.Text = "Address must be at least 5 characters"
            lblAddressError.Visible = True
            isValid = False
        End If

        Return isValid ' Return overall validation result
    End Function

    ' Check if username already exists in database
    Private Function CheckUsernameExists(ByVal username As String) As Boolean
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()
                ' Query to count users with the same username
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @Username", con)
                cmd.Parameters.Add("@Username", SqlDbType.NVarChar).Value = username
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0 ' Return true if username exists
            Catch ex As Exception
                Return False ' Return false on error
            End Try
        End Using
    End Function

    ' Check if email already exists in database
    Private Function CheckEmailExists(ByVal email As String) As Boolean
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString
        Using con As New SqlConnection(connStr)
            Try
                con.Open()
                ' Query to count users with the same email
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Email = @Email", con)
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = email
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return count > 0 ' Return true if email exists
            Catch ex As Exception
                Return False ' Return false on error
            End Try
        End Using
    End Function

    ' Validation helper methods using Regular Expressions

    ' Validate name fields (allows letters, spaces, hyphens, apostrophes)
    Private Function IsValidName(name As String) As Boolean
        Dim namePattern As String = "^[a-zA-Z\s\-']+$"
        Return Regex.IsMatch(name, namePattern)
    End Function

    ' Validate username (allows letters, numbers, underscores only)
    Private Function IsValidUsername(username As String) As Boolean
        Dim usernamePattern As String = "^[a-zA-Z0-9_]+$"
        Return Regex.IsMatch(username, usernamePattern)
    End Function

    ' Validate email format using regex pattern
    Private Function IsValidEmail(email As String) As Boolean
        Dim emailPattern As String = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        Return Regex.IsMatch(email, emailPattern)
    End Function

    ' Validate phone number (8-15 digits after removing non-digit characters)
    Private Function IsValidPhone(phone As String) As Boolean
        Dim cleanPhone As String = Regex.Replace(phone, "[^\d]", "") ' Remove non-digits
        Return cleanPhone.Length >= 8 And cleanPhone.Length <= 15
    End Function

    ' Validate password strength (minimum 8 chars with uppercase, lowercase, and digit)
    Private Function IsValidPassword(password As String) As Boolean
        If password.Length < 8 Then Return False ' Check minimum length
        Dim hasUpper As Boolean = Regex.IsMatch(password, "[A-Z]") ' Check for uppercase
        Dim hasLower As Boolean = Regex.IsMatch(password, "[a-z]") ' Check for lowercase
        Dim hasDigit As Boolean = Regex.IsMatch(password, "\d") ' Check for digit
        Return hasUpper And hasLower And hasDigit ' All conditions must be met
    End Function

    ' Hash password using SHA256 for secure storage
    Private Function HashPassword(password As String) As String
        Using sha256Hash As SHA256 = SHA256.Create()
            ' Convert password to bytes and compute hash
            Dim bytes As Byte() = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim builder As New StringBuilder()
            ' Convert hash bytes to hexadecimal string
            For i As Integer = 0 To bytes.Length - 1
                builder.Append(bytes(i).ToString("x2"))
            Next
            Return builder.ToString() ' Return hashed password
        End Using
    End Function

    ' Clear all form fields after successful registration
    Private Sub ClearForm()
        txtFirstName.Text = ""
        txtLastName.Text = ""
        txtUsername.Text = ""
        txtEmail.Text = ""
        txtPhone.Text = ""
        txtPassword.Text = ""
        txtConfirmPassword.Text = ""
        txtDateOfBirth.Text = ""
        ddlGender.SelectedIndex = 0 ' Reset to first option
        txtAddress.Text = ""
        ClearValidationErrors() ' Clear error messages
    End Sub

    ' Display success or error messages to user
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message ' Set message text
        pnlMessage.CssClass = "alert " & cssClass ' Set CSS class for styling
        pnlMessage.Visible = True ' Make message panel visible
    End Sub

    ' Hide all validation error labels
    Private Sub ClearValidationErrors()
        lblFirstNameError.Visible = False
        lblLastNameError.Visible = False
        lblUsernameError.Visible = False
        lblEmailError.Visible = False
        lblPhoneError.Visible = False
        lblPasswordError.Visible = False
        lblConfirmPasswordError.Visible = False
        lblDateOfBirthError.Visible = False
        lblGenderError.Visible = False
        lblAddressError.Visible = False
    End Sub

End Class