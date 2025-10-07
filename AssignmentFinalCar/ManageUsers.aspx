<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="ManageUsers.aspx.vb" Inherits="AssignmentFinalCar.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        /* 
        ====== MAIN CONTAINER STYLING ======
        Styles for the main user management container with rounded corners and shadow
        */
        .user-management-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        /* 
        ====== FILTER SECTION STYLING ======
        Styles for the search and filter controls section
        */
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        /* 
        ====== USER STATISTICS CARD ======
        Gradient background styling for the statistics display section
        */
        .user-stats {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        /* Individual statistic item alignment */
        .stat-item {
            text-align: center;
        }
        
        /* Large number display for statistics */
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
        }
        
        /* 
        ====== USER TABLE STYLING ======
        Styles for the main user data grid/table
        */
        .user-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        /* Hover effect for table rows */
        .user-row {
            transition: background-color 0.3s ease;
        }
        
        .user-row:hover {
            background-color: #f8f9fa;
        }
        
        /* 
        ====== STATUS BADGE STYLING ======
        Styles for active/blocked status indicators
        */
        .status-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        /* Green badge for active users */
        .status-active {
            background-color: #28a745;
            color: white;
        }
        
        /* Red badge for blocked users */
        .status-blocked {
            background-color: #dc3545;
            color: white;
        }
        
        /* 
        ====== ACTION BUTTONS STYLING ======
        Compact styling for action buttons in the table
        */
        .action-buttons .btn {
            margin: 2px;
            padding: 4px 8px;
            font-size: 0.8rem;
        }
        
        /* 
        ====== USER TYPE INDICATORS ======
        Different colors for client vs admin user types
        */
        .user-type-client {
            color: #007bff;
            font-weight: 500;
        }
        
        .user-type-admin {
            color: #dc3545;
            font-weight: 500;
        }
        
        /* 
        ====== SEARCH INPUT STYLING ======
        Custom styling for search input with icon
        */
        .search-container {
            position: relative;
        }
        
        .search-container i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .search-input {
            padding-left: 45px;
        }

        /* 
        ====== REGISTER ADMIN BUTTON STYLING ======
        Premium gradient button with hover effects for registering new admins
        */
        .register-admin-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        /* Hover effect with elevation and color change */
        .register-admin-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            background: linear-gradient(135deg, #218838 0%, #1dc785 100%);
            color: white;
        }

        /* Animated shine effect on hover */
        .register-admin-btn:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .register-admin-btn:hover:before {
            left: 100%;
        }

        .register-admin-btn i {
            margin-right: 8px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        
        <%-- 
        ====== PAGE HEADER SECTION ======
        Contains the page title and main action button for registering new admins
        --%>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-users-cog"></i> Manage Users</h2>
            <div>
                <%-- Button to navigate to admin registration page --%>
                <asp:Button ID="btnRegisterAdmin" runat="server" Text="+ Register New Admin" 
                    CssClass="btn register-admin-btn" OnClick="btnRegisterAdmin_Click" />
            </div>
        </div>

        <%-- 
        ====== USER STATISTICS DASHBOARD ======
        Displays key metrics about users in the system (Total, Active, Blocked, Admin)
        These labels are populated from the code-behind using database queries
        --%>
        <div class="row mb-4">
            <div class="col-12">
                <div class="user-stats">
                    <div class="row">
                        <!-- Total Users Count -->
                        <div class="col-md-3 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
                            </div>
                            <div>Total Users</div>
                        </div>
                        <!-- Active Users Count -->
                        <div class="col-md-3 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblActiveUsers" runat="server" Text="0" />
                            </div>
                            <div>Active Users</div>
                        </div>
                        <!-- Blocked Users Count -->
                        <div class="col-md-3 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblBlockedUsers" runat="server" Text="0" />
                            </div>
                            <div>Blocked Users</div>
                        </div>
                        <!-- Admin Users Count -->
                        <div class="col-md-3 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblAdminUsers" runat="server" Text="0" />
                            </div>
                            <div>Admin Users</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 
        ====== SEARCH AND FILTER SECTION ======
        Provides multiple filtering options for finding specific users
        --%>
        <div class="filter-section">
            <div class="row">
                <!-- Search by text input -->
                <div class="col-md-4">
                    <asp:Label runat="server" CssClass="form-label">Search Users:</asp:Label>
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <%-- Text search across name, username, and email fields --%>
                        <asp:TextBox ID="txtSearchUser" runat="server" CssClass="form-control search-input" 
                            placeholder="Search by name, username, or email..." />
                    </div>
                </div>
                
                <!-- Filter by user type -->
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">User Type:</asp:Label>
                    <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-select">
                        <asp:ListItem Value="All" Text="All Users" />
                        <asp:ListItem Value="Client" Text="Clients" />
                        <asp:ListItem Value="Admin" Text="Admins" />
                    </asp:DropDownList>
                </div>
                
                <!-- Filter by active status -->
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">Status:</asp:Label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Value="All" Text="All Status" />
                        <asp:ListItem Value="1" Text="Active" />
                        <asp:ListItem Value="0" Text="Blocked" />
                    </asp:DropDownList>
                </div>
                
                <!-- Filter by registration date -->
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">Registration Date:</asp:Label>
                    <asp:DropDownList ID="ddlDateFilter" runat="server" CssClass="form-select">
                        <asp:ListItem Value="All" Text="All Time" />
                        <asp:ListItem Value="Today" Text="Today" />
                        <asp:ListItem Value="Week" Text="This Week" />
                        <asp:ListItem Value="Month" Text="This Month" />
                    </asp:DropDownList>
                </div>
                
                <!-- Action buttons for search and clear -->
                <div class="col-md-2 d-flex align-items-end">
                    <%-- Apply current filter settings --%>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" 
                        CssClass="btn btn-primary me-2" OnClick="btnSearch_Click" />
                    <%-- Reset all filters to default --%>
                    <asp:Button ID="btnClear" runat="server" Text="Clear" 
                        CssClass="btn btn-outline-secondary" OnClick="btnClear_Click" />
                </div>
            </div>
        </div>

        <%-- 
        ====== MAIN USER DATA TABLE ======
        GridView control that displays all user information with management actions
        --%>
        <div class="user-management-container">
            
            <%-- Table header with pagination controls --%>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>User List</h5>
                <div>
                    <asp:Label runat="server">Show: </asp:Label>
                    <%-- Page size selector for controlling number of records per page --%>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-select d-inline-block" 
                        style="width: auto;" AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                        <asp:ListItem Value="10" Text="10" />
                        <asp:ListItem Value="25" Text="25" />
                        <asp:ListItem Value="50" Text="50" />
                        <asp:ListItem Value="100" Text="100" />
                    </asp:DropDownList>
                    <asp:Label runat="server"> entries</asp:Label>
                </div>
            </div>

            <%-- 
            ====== MAIN DATA GRID ======
            GridView with custom columns for displaying and managing user data
            --%>
            <div class="table-responsive">
                <asp:GridView ID="gvUsers" runat="server" CssClass="table table-hover user-table" 
                    AutoGenerateColumns="false" GridLines="None" AllowPaging="true" PageSize="10"
                    OnPageIndexChanging="gvUsers_PageIndexChanging" OnRowCommand="gvUsers_RowCommand">
                    <HeaderStyle CssClass="table-dark" />
                    <Columns>
                        
                        <%-- User ID Column --%>
                        <asp:BoundField DataField="UserID" HeaderText="ID" ItemStyle-Width="50px" />
                        
                        <%-- User Information Column (combines multiple fields) --%>
                        <asp:TemplateField HeaderText="User Information">
                            <ItemTemplate>
                                <div>
                                    <%-- Full name display --%>
                                    <strong><%# Eval("FirstName") %> <%# Eval("LastName") %></strong><br>
                                    <small class="text-muted">
                                        <%-- Username with icon --%>
                                        <i class="fas fa-user"></i> <%# Eval("Username") %><br>
                                        <%-- Email with icon --%>
                                        <i class="fas fa-envelope"></i> <%# Eval("Email") %><br>
                                        <%-- Phone with icon --%>
                                        <i class="fas fa-phone"></i> <%# Eval("Phone") %>
                                    </small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- User Type Column (Admin/Client with different styling) --%>
                        <asp:TemplateField HeaderText="User Type">
                            <ItemTemplate>
                                <%-- Conditional CSS class based on user type --%>
                                <span class='<%# IIf(Eval("UserType") = "Admin", "user-type-admin", "user-type-client") %>'>
                                    <%-- Conditional icon based on user type --%>
                                    <i class='<%# IIf(Eval("UserType") = "Admin", "fas fa-shield-alt", "fas fa-user") %>'></i>
                                    <%# Eval("UserType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Status Column (Active/Blocked badge) --%>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%-- Conditional badge styling based on active status --%>
                                <span class='status-badge <%# IIf(Eval("IsActive"), "status-active", "status-blocked") %>'>
                                    <%# IIf(Eval("IsActive"), "Active", "Blocked") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Registration Date Column --%>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Registered" 
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="100px" />
                        
                        <%-- Action Buttons Column --%>
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    
                                    <%-- Toggle Status Button (Block/Unblock) --%>
                                    <asp:Button ID="btnToggleStatus" runat="server" 
                                        Text='<%# IIf(Eval("IsActive"), "Block", "Unblock") %>'
                                        CssClass='<%# "btn btn-sm " & IIf(Eval("IsActive"), "btn-warning", "btn-success") %>'
                                        CommandName="ToggleStatus" 
                                        CommandArgument='<%# Eval("UserID") & "," & Eval("IsActive") %>'
                                        OnClientClick="return confirm('Are you sure you want to change this user status?');" />
                                    
                                    <%-- Role Change Button (Make Admin/Make Client) --%>
                                    <asp:Button ID="btnUpgradeRole" runat="server" 
                                        Text='<%# IIf(Eval("UserType") = "Client", "Make Admin", "Make Client") %>'
                                        CssClass='<%# IIf(Eval("UserType") = "Client", "btn btn-success btn-sm", "btn btn-secondary btn-sm") %>'
                                        CommandName="UpgradeRole" 
                                        CommandArgument='<%# Eval("UserID") & "," & Eval("UserType") %>'
                                        OnClientClick="return confirm('Are you sure you want to change this user role?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <%-- Pagination styling --%>
                    <PagerStyle CssClass="pagination-container" />
                    
                    <%-- Empty data template when no users found --%>
                    <EmptyDataTemplate>
                        <div class="text-center py-4">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <h5>No users found</h5>
                            <p class="text-muted">Try adjusting your search criteria.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <%-- 
        ====== SUCCESS/ERROR MESSAGE PANEL ======
        Floating alert panel for displaying operation results
        --%>
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" 
            CssClass="position-fixed alert alert-dismissible fade show" 
            style="top: 100px; right: 20px; z-index: 1050;">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>
    </div>
</asp:Content>