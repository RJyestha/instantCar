<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="ClientProfile.aspx.vb" Inherits="AssignmentFinalCar.WebForm17" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        .profile-header {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #fff;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            margin-bottom: 30px;
        }
        
        .profile-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2a5298, #3b82f6); 
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            margin: 0 auto 20px;
        }
        
        .form-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
        }
        
        .section-title {
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-save {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        
        .btn-save:hover {
            transform: translateY(-4px);
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.4);
            color: white;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #2a5298, #3b82f6); 
            color: #fff;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease;;
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
        }
        
        .password-strength {
            margin-top: 10px;
        }
        
        .strength-bar {
            height: 5px;
            border-radius: 3px;
            transition: all 0.3s ease;
        }
        
        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #ffc107; width: 50%; }
        .strength-good { background: #17a2b8; width: 75%; }
        .strength-strong { background: #28a745; width: 100%; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
                <div class="col-md-6">
                    <h2 class="mb-2">
                        <asp:Label ID="lblProfileName" runat="server" />
                    </h2>
                    <p class="mb-1">
                        <i class="fas fa-envelope me-2"></i>
                        <asp:Label ID="lblProfileEmail" runat="server" />
                    </p>
                    <p class="mb-1">
                        <i class="fas fa-user-tag me-2"></i>
                        <asp:Label ID="lblProfileUsername" runat="server" />
                    </p>
                    <p class="mb-0">
                        <i class="fas fa-calendar-alt me-2"></i>
                        Member since <asp:Label ID="lblMemberSince" runat="server" />
                    </p>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number">
                            <asp:Label ID="lblTotalBookings" runat="server" Text="0" />
                        </div>
                        <div>Total Bookings</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Profile Form -->
            <div class="col-lg-8">
                <div class="profile-container">
                    <h4 class="section-title"><i class="fas fa-user-edit me-2"></i>Personal Information</h4>

                    <asp:ValidationSummary ID="valSummary" runat="server" CssClass="text-danger mb-3" HeaderText="Please correct the following:" />

                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">First Name *</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="reqFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name is required" CssClass="validation-error" Display="Dynamic" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Last Name *</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="reqLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last name is required" CssClass="validation-error" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="validation-error" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmail"
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                    ErrorMessage="Invalid email format" CssClass="validation-error" Display="Dynamic" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone Number *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="reqPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone number is required" CssClass="validation-error" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="regPhone" runat="server" ControlToValidate="txtPhone"
                                    ValidationExpression="^\d{8,15}$"
                                    ErrorMessage="Enter a valid phone number (8-15 digits)" CssClass="validation-error" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date of Birth</label>
                                <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Gender</label>
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="Male" Text="Male" />
                                    <asp:ListItem Value="Female" Text="Female" />
                                    <asp:ListItem Value="Other" Text="Other" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Address *</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            <asp:RequiredFieldValidator ID="reqAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="Address is required" CssClass="validation-error" Display="Dynamic" />
                        </div>
                    </div>

                    <!-- Account Security -->
                    <h4 class="section-title"><i class="fas fa-lock me-2"></i>Account Security</h4>

                    <div class="form-section">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true" />
                            <small class="text-muted">Username cannot be changed</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Current Password (required to save changes)</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="reqCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                                ErrorMessage="Current password is required" CssClass="validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <asp:CustomValidator ID="custPasswordStrength" runat="server"
                                ControlToValidate="txtNewPassword"
                                OnServerValidate="ValidatePasswordStrength"
                                ErrorMessage="Password must be 8+ characters with uppercase, lowercase, and number"
                                CssClass="validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <asp:CompareValidator ID="cmpPasswords" runat="server" ControlToCompare="txtNewPassword"
                                ControlToValidate="txtConfirmPassword" Operator="Equal" Display="Dynamic"
                                ErrorMessage="Passwords do not match" CssClass="validation-error" />
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="text-center">
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn-save me-3" OnClick="btnSaveProfile_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="profile-container">
                <h5 class="section-title"><i class="fas fa-clock me-2"></i>Recent Activity</h5>
                <asp:Repeater ID="rptRecentActivity" runat="server">
                    <ItemTemplate>
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3"><i class="fas fa-circle text-primary" style="font-size: 0.5rem;"></i></div>
                            <div class="flex-grow-1">
                                <div class="fw-bold"><%# Eval("Activity") %></div>
                                <small class="text-muted"><%# Eval("ActivityDate", "{0:dd MMM yyyy HH:mm}") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" CssClass="text-center text-muted py-3">
                    <i class="fas fa-info-circle me-2"></i>No recent activity
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Flash Message -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>
</asp:Content>