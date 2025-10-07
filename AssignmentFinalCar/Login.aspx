<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/PublicMaster.Master" CodeBehind="Login.aspx.vb" Inherits="AssignmentFinalCar.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            background: white;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header i {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 15px;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            margin-bottom: 15px;
            background-color: #007bff !important;
            border-color: #007bff !important;
            transition: none !important;
            opacity: 1 !important;
        }

        .btn-login:hover,
        .btn-login:focus,
        .btn-login:active,
        .btn-login:disabled {
            background-color: #007bff !important;
            border-color: #007bff !important;
            opacity: 1 !important;
            transform: none !important;
            box-shadow: none !important;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }

        .alert {
            margin-bottom: 20px;
        }

        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: block;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="login-container">
            <div class="login-header">
                <i class="fas fa-user-circle"></i>
                <h2>Welcome Back</h2>
                <p class="text-muted">Sign in to your account</p>
            </div>

            <!-- Panel to show login error or success messages -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger">
                <asp:Label ID="lblMessage" runat="server" />
            </asp:Panel>

            <!-- Username field with required validator -->
            <div class="form-floating">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                <label for="txtUsername">Username</label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                    ControlToValidate="txtUsername" 
                    runat="server" 
                    ErrorMessage="Username is required" 
                    ValidationGroup="LoginGroup"
                    CssClass="validation-error"
                    Display="Dynamic" />
            </div>

            <!-- Password field with required validator -->
            <div class="form-floating">
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password" />
                <label for="txtPassword">Password</label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                    ControlToValidate="txtPassword" 
                    runat="server" 
                    ErrorMessage="Password is required" 
                    ValidationGroup="LoginGroup"
                    CssClass="validation-error"
                    Display="Dynamic" />
            </div>

            <!-- Login Button: triggers server-side login -->
            <asp:Button ID="btnLogin" runat="server" 
                Text="Sign In" 
                CssClass="btn btn-primary btn-login" 
                OnClick="btnLogin_Click" 
                ValidationGroup="LoginGroup" />

            <!-- Register Redirect Button -->
            <div class="register-link">
                <hr />
                <p class="mb-0">Don't have an account?
                    <asp:Button ID="btnRegister" runat="server" 
                        Text="Create one here" 
                        CssClass="btn btn-link text-decoration-none p-0" 
                        OnClick="btnRegister_Click" 
                        CausesValidation="false" />
                </p>
            </div>
        </div>
    </div>
</asp:Content>