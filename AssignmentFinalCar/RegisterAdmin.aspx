<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="RegisterAdmin.aspx.vb" Inherits="AssignmentFinalCar.WebForm10" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        /* Main container for the registration form */
        .register-container {
            max-width: 700px;
            margin: 30px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            background: white;
        }
        
        /* Header section with title and icon */
        .register-header {
            text-align: center;
            margin-bottom: 30px;
            color: #dc3545;
        }
        
        .register-header i {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        /* Form group styling for input sections */
        .form-group {
            margin-bottom: 20px;
        }
        
        /* Labels for form inputs */
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
            display: block;
        }
        
        /* Input fields and dropdown styling */
        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        /* Focus state for input fields */
        .form-control:focus, .form-select:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        /* Error message styling */
        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: block;
        }
        
        /* Register button styling */
        .btn-register {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            margin-bottom: 15px;
        }
        
        /* Back link styling */
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        /* Section headers for form organization */
        .section-header {
            font-size: 1.1rem;
            font-weight: 600;
            color: #495057;
            margin: 25px 0 15px 0;
            padding-bottom: 5px;
            border-bottom: 2px solid #e9ecef;
        }
        
        /* Admin privileges information box */
        .admin-privileges {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        /* Individual privilege items */
        .privilege-item {
            margin-bottom: 8px;
        }
        
        .privilege-item i {
            color: #856404;
            margin-right: 8px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="register-container">
            <%-- Page Header with Icon and Title --%>
            <div class="register-header">
                <i class="fas fa-user-shield"></i>
                <h2>Register New Admin</h2>
                <p class="text-muted">Create a new administrator account</p>
            </div>
            
            <%-- Message Panel for Success/Error Messages --%>
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert mb-4">
                <asp:Label ID="lblMessage" runat="server" />
            </asp:Panel>

            <%-- Admin Privileges Information Section --%>
            <div class="admin-privileges">
                <h6><i class="fas fa-info-circle"></i> Admin Privileges</h6>
                <div class="privilege-item">
                    <i class="fas fa-check"></i> Full access to vehicle management
                </div>
                <div class="privilege-item">
                    <i class="fas fa-check"></i> User management and role upgrades
                </div>
                <div class="privilege-item">
                    <i class="fas fa-check"></i> Booking approval and management
                </div>
                <div class="privilege-item">
                    <i class="fas fa-check"></i> System reports and analytics
                </div>
                <div class="privilege-item">
                    <i class="fas fa-check"></i> News and announcements management
                </div>
            </div>

            <%-- Personal Information Section --%>
            <div class="section-header">
                <i class="fas fa-user"></i> Personal Information
            </div>
            
            <%-- First Name and Last Name Row --%>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtFirstName">First Name *</asp:Label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter first name" />
                        <asp:Label ID="lblFirstNameError" runat="server" CssClass="validation-error" Visible="false" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtLastName">Last Name *</asp:Label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter last name" />
                        <asp:Label ID="lblLastNameError" runat="server" CssClass="validation-error" Visible="false" />
                    </div>
                </div>
            </div>

            <%-- Date of Birth and Gender Row --%>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtDateOfBirth">Date of Birth *</asp:Label>
                        <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" CssClass="form-control" />
                        <asp:Label ID="lblDateOfBirthError" runat="server" CssClass="validation-error" Visible="false" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label">Gender *</asp:Label>
                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="Select Gender" />
                            <asp:ListItem Value="Male" Text="Male" />
                            <asp:ListItem Value="Female" Text="Female" />
                            <asp:ListItem Value="Other" Text="Other" />
                        </asp:DropDownList>
                        <asp:Label ID="lblGenderError" runat="server" CssClass="validation-error" Visible="false" />
                    </div>
                </div>
            </div>

            <%-- Contact Information Section --%>
            <div class="section-header">
                <i class="fas fa-address-book"></i> Contact Information
            </div>
            
            <%-- Email Address Field --%>
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtEmail">Email Address *</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="Enter email address" />
                <asp:Label ID="lblEmailError" runat="server" CssClass="validation-error" Visible="false" />
            </div>
            
            <%-- Phone Number Field --%>
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtPhone">Phone Number *</asp:Label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number" />
                <asp:Label ID="lblPhoneError" runat="server" CssClass="validation-error" Visible="false" />
            </div>

            <%-- Address Field --%>
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtAddress">Address *</asp:Label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter address" />
                <asp:Label ID="lblAddressError" runat="server" CssClass="validation-error" Visible="false" />
            </div>

            <%-- Account Information Section --%>
            <div class="section-header">
                <i class="fas fa-key"></i> Account Credentials
            </div>
            
            <%-- Username Field --%>
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtUsername">Username *</asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />
                <asp:Label ID="lblUsernameError" runat="server" CssClass="validation-error" Visible="false" />
                <small class="form-text text-muted">Username must be 4-20 characters long and contain only letters, numbers, and underscores.</small>
            </div>
            
            <%-- Password and Confirm Password Row --%>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtPassword">Password *</asp:Label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create a strong password" />
                        <asp:Label ID="lblPasswordError" runat="server" CssClass="validation-error" Visible="false" />
                        <small class="form-text text-muted">Password must be 8+ characters with uppercase, lowercase, and number.</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtConfirmPassword">Confirm Password *</asp:Label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm your password" />
                        <asp:Label ID="lblConfirmPasswordError" runat="server" CssClass="validation-error" Visible="false" />
                    </div>
                </div>
            </div>

            <%-- Action Buttons Section --%>
            <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                <%-- Cancel Button - Returns to Manage Users Page --%>
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                    CssClass="btn btn-outline-secondary" OnClick="btnCancel_Click" />
                <%-- Register Button - Submits the Form --%>
                <asp:Button ID="btnRegister" runat="server" Text="Register Admin" 
                    CssClass="btn btn-danger btn-register" style="width: auto; padding: 12px 30px;" 
                    OnClick="btnRegister_Click" />
            </div>
            
            <%-- Back Link to Manage Users --%>
            <div class="back-link">
                <hr>
                <p class="mb-0">
                    <asp:HyperLink ID="lnkBackToUsers" runat="server" NavigateUrl="~/ManageUsers.aspx" 
                        CssClass="text-decoration-none">
                        <i class="fas fa-arrow-left"></i> Back to Manage Users
                    </asp:HyperLink>
                </p>
            </div>
        </div>
    </div>
</asp:Content>