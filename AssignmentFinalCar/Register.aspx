<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/PublicMaster.Master" CodeBehind="Register.aspx.vb" Inherits="AssignmentFinalCar.WebForm3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <style>
        .register-container {
            max-width: 600px;
            margin: 30px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            background: white;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header i {
            font-size: 3rem;
            color: #0094ff;
            margin-bottom: 15px;
        }
        
        .form-floating {
            margin-bottom: 20px;
        }
        
        .btn-register {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            margin-bottom: 15px;
            background-color: #0094ff !important;
            border-color: #0094ff !important;
            transition: none !important;
            opacity: 1 !important;
        }
        .btn-register:hover,
        .btn-register:focus,
        .btn-register:active,
        .btn-register:disabled {
            background-color: #0094ff !important;
            border-color: #0094ff !important;
            opacity: 1 !important;
            transform: none !important;
            box-shadow: none !important;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .alert {
            margin-bottom: 20px;
        }
        
        .password-requirements {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
        }

        .section-header {
            font-size: 1.1rem;
            font-weight: 600;
            color: #495057;
            margin: 25px 0 15px 0;
            padding-bottom: 5px;
            border-bottom: 2px solid #e9ecef;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #0094ff;
            box-shadow: 0 0 0 0.2rem rgba(0, 148, 255, 0.25);
        }

        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 8px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .radio-option input[type="radio"] {
            margin: 0;
            transform: scale(1.2);
        }

        @keyframes flipOut {
            0% {
                transform: rotateY(0deg);
                opacity: 1;
            }
            100% {
                transform: rotateY(90deg);
                opacity: 0;
            }
        }

        .flip-animation {
            animation: flipOut 0.6s ease-in-out forwards;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="register-container">
            <div class="register-header">
                <i class="fas fa-user-plus"></i>
                <h2>Create Account</h2>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert">
                <asp:Label ID="lblMessage" runat="server" />
            </asp:Panel>

            <!-- Personal Information Section -->
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtFirstName">First Name *</asp:Label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter your first name" />
                        <asp:RequiredFieldValidator ControlToValidate="txtFirstName" runat="server" ForeColor="Red" Display="Dynamic"
                            ErrorMessage="First Name is required" />
                        <asp:RegularExpressionValidator ControlToValidate="txtFirstName" runat="server" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^[a-zA-Z\s\-']+$" ErrorMessage="Only letters allowed" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtLastName">Last Name *</asp:Label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter your last name" />
                        <asp:RequiredFieldValidator ControlToValidate="txtLastName" runat="server" Display="Dynamic" ForeColor="Red"
                            ErrorMessage="Last Name is required" />
                        <asp:RegularExpressionValidator ControlToValidate="txtLastName" runat="server" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^[a-zA-Z\s\-']+$" ErrorMessage="Only letters allowed"/>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtDateOfBirth">Date of Birth *</asp:Label>
                        <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" CssClass="form-control" />
                        <asp:RequiredFieldValidator ControlToValidate="txtDateOfBirth" runat="server" ErrorMessage="DOB is required"
                            Display="Dynamic" ForeColor="Red" />
                        <asp:RangeValidator ID="valDobRange" ControlToValidate="txtDateOfBirth" runat="server" Display="Dynamic" ForeColor="Red"
                            Type="Date" ErrorMessage="Must be 18 years or older" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label">Gender *</asp:Label>
                        <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-group">
                            <asp:ListItem Value="Male" Text="Male" />
                            <asp:ListItem Value="Female" Text="Female" />
                            <asp:ListItem Value="Other" Text="Other" />
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ControlToValidate="rblGender" InitialValue="" runat="server"
                            ErrorMessage="Gender is required" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>

            <!-- Contact Information Section -->
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtEmail">Email Address *</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control"
                    placeholder="Enter your email address" />
                <asp:RequiredFieldValidator ControlToValidate="txtEmail" runat="server" Display="Dynamic" ForeColor="Red"
                    ErrorMessage="Email is required" />
                <asp:RegularExpressionValidator ControlToValidate="txtEmail" runat="server" Display="Dynamic" ForeColor="Red"
                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" ErrorMessage="Invalid email format" />
            </div>

            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtPhone">Phone Number *</asp:Label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter your phone number" />
                <asp:RequiredFieldValidator ControlToValidate="txtPhone" runat="server" Display="Dynamic" ForeColor="Red"
                    ErrorMessage="Phone number is required" />
                <asp:RegularExpressionValidator ControlToValidate="txtPhone" runat="server" Display="Dynamic" ForeColor="Red"
                    ValidationExpression="^\d{8,15}$" ErrorMessage="8–15 digit number only" />
            </div>

            <!-- Address -->
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtAddress">Address *</asp:Label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter your address" />
                <asp:RequiredFieldValidator ControlToValidate="txtAddress" runat="server" Display="Dynamic" ForeColor="Red"
                    ErrorMessage="Address is required" />
            </div>

            <!-- Account Information -->
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtUsername">Username *</asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />
                <asp:RequiredFieldValidator ControlToValidate="txtUsername" runat="server" Display="Dynamic" ForeColor="Red"
                    ErrorMessage="Username is required" />
                <asp:RegularExpressionValidator ControlToValidate="txtUsername" runat="server" Display="Dynamic" ForeColor="Red"
                    ValidationExpression="^[a-zA-Z0-9_]+$" ErrorMessage="Letters, numbers & underscore only" />
            </div>

            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtPassword">Password *</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create a password" />
                <asp:RequiredFieldValidator ControlToValidate="txtPassword" runat="server" Display="Dynamic" ForeColor="Red"
                    ErrorMessage="Password is required" />
                <asp:RegularExpressionValidator ControlToValidate="txtPassword" runat="server" Display="Dynamic" ForeColor="Red"
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"
                    ErrorMessage="Must contain 8+ chars, upper, lower & number" />
                <div class="password-requirements">Password must contain: 8+ characters, uppercase, lowercase, and number</div>
            </div>

            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtConfirmPassword">Confirm Password *</asp:Label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"
                    placeholder="Confirm your password" />
                <asp:CompareValidator ControlToValidate="txtConfirmPassword" runat="server" Display="Dynamic"
                    ControlToCompare="txtPassword" Operator="Equal" ForeColor="Red"
                    ErrorMessage="Passwords must match" />
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-primary btn-register" OnClick="btnRegister_Click" />

            <div class="login-link">
                <hr />
                <p class="mb-0">Already have an account? <a href="Login.aspx" class="text-decoration-none">Sign in here</a></p>
            </div>
        </div>
    </div>
</asp:Content>