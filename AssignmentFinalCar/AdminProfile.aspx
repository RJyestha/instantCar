<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="AdminProfile.aspx.vb" Inherits="AssignmentFinalCar.WebForm19" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        /* Admin Profile Header Styling */
        .admin-profile-header {
            background: linear-gradient(135deg, #1e3a8a, #1e40af);
            color: #fff;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(30, 58, 138, 0.3);
            margin-bottom: 30px;
        }
        
        /* Main Profile Container */
        .profile-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        /* Admin Avatar Circle */
        .admin-avatar {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #2563eb); 
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3.5rem;
            margin: 0 auto 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        /* Form Section Styling */
        .form-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 4px solid #dc3545;
        }
        
        /* Section Title Styling */
        .section-title {
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        /* Form Control Focus Effects */
        .form-control:focus, .form-select:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        /* Custom Button Styles */
        .btn-admin-save {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            color: white;
            padding: 12px 35px;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        
        .btn-admin-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
            color: white;
        }
        
        /* Statistics Cards */
        .admin-stats-card {
            background: linear-gradient(135deg, #28a745, #20c997); 
            color: #fff;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            transition: transform 0.3s ease;
            margin-bottom: 20px;
        }
        
        .admin-stats-card:hover {
            transform: translateY(-2px);
        }
        
        /* Statistics Number Display */
        .stats-number {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        /* Admin Badge */
        .admin-badge {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
        }
        
        /* Password Strength Indicator */
        .password-strength {
            margin-top: 10px;
        }
        
        .strength-bar {
            height: 6px;
            border-radius: 3px;
            transition: all 0.3s ease;
        }
        
        /* Password Strength Levels */
        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #ffc107; width: 50%; }
        .strength-good { background: #17a2b8; width: 75%; }
        .strength-strong { background: #28a745; width: 100%; }

        /* Activity Timeline Styles */
        .activity-timeline {
            position: relative;
            padding-left: 30px;
        }

        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 20px;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -22px;
            top: 20px;
            width: 12px;
            height: 12px;
            background: #dc3545;
            border-radius: 50%;
            border: 3px solid white;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Admin Profile Header Section - Displays admin basic information -->
        <div class="admin-profile-header">
            <div class="row align-items-center">
                <!-- Admin Avatar Column -->
                <div class="col-md-3 text-center">
                    <div class="admin-avatar">
                        <i class="fas fa-user-shield"></i>
                    </div>
                </div>
                
                <!-- Admin Information Display -->
                <div class="col-md-6">
                    <h2 class="mb-2">
                        <asp:Label ID="lblAdminName" runat="server" />
                        <span class="admin-badge ms-2">ADMIN</span>
                    </h2>
                    <p class="mb-1">
                        <i class="fas fa-envelope me-2"></i>
                        <asp:Label ID="lblAdminEmail" runat="server" />
                    </p>
                    <p class="mb-1">
                        <i class="fas fa-user-tag me-2"></i>
                        <asp:Label ID="lblAdminUsername" runat="server" />
                    </p>
                    <p class="mb-0">
                        <i class="fas fa-shield-alt me-2"></i>
                        Administrator since <asp:Label ID="lblAdminSince" runat="server" />
                    </p>
                </div>
                
                <!-- Admin Actions Counter -->
                <div class="col-md-3">
                    <div class="admin-stats-card">
                        <div class="stats-number">
                            <asp:Label ID="lblTotalActions" runat="server" Text="0" />
                        </div>
                        <div>Admin Actions</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Main Profile Form Column -->
            <div class="col-lg-8">
                <div class="profile-container">
                    <!-- Profile Form Header -->
                    <h4 class="section-title">
                        <i class="fas fa-user-cog me-2"></i>Administrator Information
                    </h4>
                    
                    <!-- ASP.NET Validation Summary - Shows all validation errors -->
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                        CssClass="alert alert-danger mb-3" 
                        HeaderText="Please correct the following errors:"
                        DisplayMode="BulletList" 
                        ShowSummary="true" 
                        EnableClientScript="true" />
                    
                    <!-- Personal Information Section -->
                    <div class="form-section">
                        <h6 class="text-muted mb-3">Personal Details</h6>
                        <div class="row">
                            <!-- First Name Field with Validation -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">First Name *</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                                <!-- Required Field Validator for First Name -->
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                                    ControlToValidate="txtFirstName"
                                    ErrorMessage="First name is required"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                                <!-- Regular Expression Validator for First Name -->
                                <asp:RegularExpressionValidator ID="revFirstName" runat="server"
                                    ControlToValidate="txtFirstName"
                                    ValidationExpression="^[a-zA-Z\s]{2,50}$"
                                    ErrorMessage="First name must be 2-50 characters and contain only letters"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                            </div>
                            
                            <!-- Last Name Field with Validation -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Last Name *</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                                <!-- Required Field Validator for Last Name -->
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                                    ControlToValidate="txtLastName"
                                    ErrorMessage="Last name is required"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                                <!-- Regular Expression Validator for Last Name -->
                                <asp:RegularExpressionValidator ID="revLastName" runat="server"
                                    ControlToValidate="txtLastName"
                                    ValidationExpression="^[a-zA-Z\s]{2,50}$"
                                    ErrorMessage="Last name must be 2-50 characters and contain only letters"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Email Field with Validation -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
                                <!-- Required Field Validator for Email -->
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Email address is required"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                                <!-- Regular Expression Validator for Email Format -->
                                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                    ErrorMessage="Please enter a valid email address"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                                <!-- Custom Validator for Email Uniqueness -->
                                <asp:CustomValidator ID="cvEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    OnServerValidate="ValidateUniqueEmail"
                                    ErrorMessage="This email is already in use"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                            </div>
                            
                            <!-- Phone Field with Validation -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Phone Number *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                                <!-- Required Field Validator for Phone -->
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ErrorMessage="Phone number is required"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                                <!-- Regular Expression Validator for Phone Format -->
                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ValidationExpression="^[\d\s\-\+\(\)]{8,15}$"
                                    ErrorMessage="Please enter a valid phone number (8-15 digits)"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Date of Birth Field -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Date of Birth</label>
                                <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" CssClass="form-control" />
                                <!-- Range Validator for Date of Birth -->
                                <asp:RangeValidator ID="rvDateOfBirth" runat="server"
                                    ControlToValidate="txtDateOfBirth"
                                    Type="Date"
                                    MinimumValue="1900-01-01"
                                    MaximumValue="2010-12-31"
                                    ErrorMessage="Please enter a valid birth date (1900-2010)"
                                    Text="*"
                                    CssClass="text-danger"
                                    Display="Dynamic" />
                            </div>
                            
                            <!-- Gender Dropdown -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Gender</label>
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="Select Gender" />
                                    <asp:ListItem Value="Male" Text="Male" />
                                    <asp:ListItem Value="Female" Text="Female" />
                                    <asp:ListItem Value="Other" Text="Other" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <!-- Address Field with Validation -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Address *</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            <!-- Required Field Validator for Address -->
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                                ControlToValidate="txtAddress"
                                ErrorMessage="Address is required"
                                Text="*"
                                CssClass="text-danger"
                                Display="Dynamic" />
                        </div>
                    </div>
                    
                    <!-- Account Security Section -->
                    <h4 class="section-title">
                        <i class="fas fa-lock me-2"></i>Account Security
                    </h4>
                    
                    <div class="form-section">
                        <h6 class="text-muted mb-3">Login Credentials</h6>
                        
                        <!-- Username Field (Read-only) -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true" />
                            <small class="text-muted">Admin username cannot be changed</small>
                        </div>
                        
                        <!-- Current Password Field with Validation -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Current Password (required to save changes) *</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <!-- Required Field Validator for Current Password -->
                            <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server"
                                ControlToValidate="txtCurrentPassword"
                                ErrorMessage="Current password is required to save changes"
                                Text="*"
                                CssClass="text-danger"
                                Display="Dynamic" />
                            <!-- Custom Validator for Current Password Verification -->
                            <asp:CustomValidator ID="cvCurrentPassword" runat="server"
                                ControlToValidate="txtCurrentPassword"
                                OnServerValidate="ValidateCurrentPassword"
                                ErrorMessage="Current password is incorrect"
                                Text="*"
                                CssClass="text-danger"
                                Display="Dynamic" />
                        </div>
                        
                        <!-- New Password Field with Validation -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">New Password (leave blank to keep current)</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <!-- Regular Expression Validator for Password Strength -->
                            <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                                ControlToValidate="txtNewPassword"
                                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$"
                                ErrorMessage="Password must be at least 8 characters with uppercase, lowercase, and number"
                                Text="*"
                                CssClass="text-danger"
                                Display="Dynamic" />
                        </div>
                        
                        <!-- Confirm Password Field with Validation -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <!-- Compare Validator for Password Confirmation -->
                            <asp:CompareValidator ID="cvConfirmPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtNewPassword"
                                ErrorMessage="Password confirmation does not match"
                                Text="*"
                                CssClass="text-danger"
                                Display="Dynamic" />
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="text-center">
                        <asp:Button ID="btnSaveProfile" runat="server" 
                            Text="Update Admin Profile" 
                            CssClass="btn btn-admin-save me-3" 
                            OnClick="btnSaveProfile_Click" />
                        <asp:Button ID="btnCancel" runat="server" 
                            Text="Cancel Changes" 
                            CssClass="btn btn-outline-secondary" 
                            OnClick="btnCancel_Click" 
                            CausesValidation="false" />
                    </div>
                </div>
            </div>
            
            <!-- System Statistics Sidebar -->
            <div class="col-lg-4">
                <!-- System Statistics Card -->
                <div class="profile-container">
                    <h5 class="section-title">
                        <i class="fas fa-chart-line me-2"></i>System Statistics
                    </h5>
                    
                    <!-- Statistics Grid -->
                    <div class="row text-center">
                        <!-- Total Users Stat -->
                        <div class="col-6 mb-3">
                            <div class="admin-stats-card">
                                <div class="stats-number">
                                    <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
                                </div>
                                <small>Total Users</small>
                            </div>
                        </div>
                        
                        <!-- Total Vehicles Stat -->
                        <div class="col-6 mb-3">
                            <div class="admin-stats-card">
                                <div class="stats-number">
                                    <asp:Label ID="lblTotalVehicles" runat="server" Text="0" />
                                </div>
                                <small>Total Vehicles</small>
                            </div>
                        </div>
                        
                        <!-- Active Bookings Stat -->
                        <div class="col-6 mb-3">
                            <div class="admin-stats-card">
                                <div class="stats-number">
                                    <asp:Label ID="lblActiveBookings" runat="server" Text="0" />
                                </div>
                                <small>Active Bookings</small>
                            </div>
                        </div>
                        
                        <!-- Pending Approvals Stat -->
                        <div class="col-6 mb-3">
                            <div class="admin-stats-card">
                                <div class="stats-number">
                                    <asp:Label ID="lblPendingApprovals" runat="server" Text="0" />
                                </div>
                                <small>Pending Approvals</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Admin Activity Card -->
                <div class="profile-container">
                    <h5 class="section-title">
                        <i class="fas fa-history me-2"></i>Recent Admin Activity
                    </h5>
                    
                    <!-- Activity Timeline -->
                    <div class="activity-timeline">
                        <!-- Repeater for Admin Activities -->
                        <asp:Repeater ID="rptAdminActivity" runat="server">
                            <ItemTemplate>
                                <div class="timeline-item">
                                    <div class="fw-bold text-primary"><%# Eval("Action") %></div>
                                    <small class="text-muted"><%# Eval("Description") %></small><br>
                                    <small class="text-info"><%# Eval("ActionDate", "{0:dd MMM yyyy HH:mm}") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <!-- No Activity Panel -->
                        <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" CssClass="text-center text-muted py-3">
                            <i class="fas fa-info-circle me-2"></i>No recent admin activity
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages Panel -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>

    <script>
        // Auto-hide success/error message after 5 seconds
        setTimeout(function() {
            const messagePanel = document.getElementById('<%= pnlMessage.ClientID %>');
            if (messagePanel && messagePanel.style.display !== 'none') {
                messagePanel.style.display = 'none';
            }
        }, 5000);
    </script>
</asp:Content>