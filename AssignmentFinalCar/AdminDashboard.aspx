<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="AdminDashboard.aspx.vb" Inherits="AssignmentFinalCar.WebForm6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
   <style>
    .dashboard-card {
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
        margin-bottom: 20px;
    }

    .dashboard-card:hover {
        transform: translateY(-5px);
    }

    .card-icon {
        font-size: 3rem;
        opacity: 0.85;
    }

    /* All cards use shades of blue now */
    .stat-card,
    .user-card,
    .vehicle-card,
    .booking-card {
        background: linear-gradient(135deg, #3a8dde 0%, #5271ff 100%);
        color: white;
    }

    .recent-activity {
        max-height: 400px;
        overflow-y: auto;
    }

    .activity-item {
        border-left: 3px solid #4d94ff;
        margin-bottom: 15px;
        padding-left: 15px;
    }

    .quick-action-btn {
        margin: 5px;
        min-width: 150px;
        color: white;
        border: none;
        background: linear-gradient(135deg, #007cf0 0%, #00dfd8 100%);
        transition: all 0.3s ease;
    }

    .quick-action-btn:hover {
        background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%);
        transform: scale(1.05);
    }

    .btn-outline-primary {
        border: 2px solid #007bff;
        color: #007bff;
        background-color: transparent;
    }

    .btn-outline-primary:hover {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        color: white;
        border: none;
    }

    .progress-bar.bg-success {
        background: linear-gradient(90deg, #36d1dc 0%, #5b86e5 100%) !important;
    }

    .progress-bar.bg-info {
        background: linear-gradient(90deg, #3a7bd5 0%, #00d2ff 100%) !important;
    }

    .notification-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #007bff;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 0.7rem;
    }

    .alert-warning {
        background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
        color: #003366;
    }

    .alert-info {
        background: linear-gradient(135deg, #d4fc79 0%, #96e6a1 100%);
        color: #003366;
    }

    .alert-danger {
        background: linear-gradient(135deg, #ff758c 0%, #ff7eb3 100%);
        color: #fff;
    }

    .alert-link {
        font-weight: bold;
        color: #fff;
    }

    .btn-close {
        background-color: white;
    }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <!-- Dashboard Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card dashboard-card stat-card">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">
                                    <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
                                </h3>
                                <p class="card-text">Total Users</p>
                            </div>
                            <div>
                                <i class="fas fa-users card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card dashboard-card vehicle-card">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">
                                    <asp:Label ID="lblTotalVehicles" runat="server" Text="0" />
                                </h3>
                                <p class="card-text">Total Vehicles</p>
                            </div>
                            <div>
                                <i class="fas fa-car card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card dashboard-card booking-card">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">
                                    <asp:Label ID="lblActiveBookings" runat="server" Text="0" />
                                </h3>
                                <p class="card-text">Active Bookings</p>
                            </div>
                            <div>
                                <i class="fas fa-calendar-check card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card dashboard-card user-card">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="card-title mb-0">Rs.
                                    <asp:Label ID="lblMonthlyRevenue" runat="server" Text="0" />
                                </h3>
                                <p class="card-text">Monthly Revenue</p>
                            </div>
                            <div>
                                <i class="fas fa-rupee-sign card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header">
                        <h5 class="card-title mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body text-center">
                        <asp:Button ID="btnAddVehicles" runat="server" Text="AddVehicles" CssClass="btn btn-primary quick-action-btn" OnClick="btnAddVehicle_Click" />
                        <asp:Button ID="btnRegisterAdmin" runat="server" Text="Register Admin" CssClass="btn btn-success quick-action-btn" OnClick="btnRegisterAdmin_Click" />
                        <asp:Button ID="btnManageUsers" runat="server" Text="Manage Users" CssClass="btn btn-info quick-action-btn" OnClick="btnManageUsers_Click" />
                        <asp:Button ID="btnManageBookings" runat="server" Text="Manage Bookings" CssClass="btn btn-secondary quick-action-btn" OnClick="btnManageBookings_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Recent Activity -->
            <div class="col-md-6">
                <div class="card dashboard-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0"><i class="fas fa-history"></i> Recent Activity</h5>
                        <span class="notification-badge">
                            <asp:Label ID="lblActivityCount" runat="server" Text="0" />
                        </span>
                    </div>
                    <div class="card-body recent-activity">
                        <asp:Repeater ID="rptRecentActivity" runat="server">
                            <ItemTemplate>
                                <div class="activity-item">
                                    <strong><%# Eval("ActivityType") %></strong><br />
                                    <small class="text-muted"><%# Eval("Description") %></small><br />
                                    <small class="text-info"><%# Eval("ActivityDate", "{0:dd/MM/yyyy HH:mm}") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <!-- System Overview -->
            <div class="col-md-6">
                <div class="card dashboard-card">
                    <div class="card-header">
                        <h5 class="card-title mb-0"><i class="fas fa-chart-pie"></i> System Overview</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6">
                                <div class="text-center">
                                    <h6>Available Vehicles</h6>
                                    <div class="progress mb-2">
                                        <div class="progress-bar bg-success" role="progressbar" id="progressAvailable" runat="server"></div>
                                    </div>
                                    <small><asp:Label ID="lblAvailableVehicles" runat="server" Text="0" /> available</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="text-center">
                                    <h6>Active Clients</h6>
                                    <div class="progress mb-2">
                                        <div class="progress-bar bg-info" role="progressbar" id="progressClients" runat="server"></div>
                                    </div>
                                    <small><asp:Label ID="lblActiveClients" runat="server" Text="0" /> active</small>
                                </div>
                            </div>
                        </div>
                        
                        <hr />
                        
                        <div class="row">
                            <div class="col-12">
                                <h6>Recent Registrations</h6>
                                <asp:GridView ID="gvRecentUsers" runat="server" CssClass="table table-sm table-striped" 
                                    AutoGenerateColumns="false" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="FirstName" HeaderText="Name" />
                                        <asp:BoundField DataField="Email" HeaderText="Email" />
                                        <asp:BoundField DataField="UserType" HeaderText="Type" />
                                        <asp:BoundField DataField="RegistrationDate" HeaderText="Registered" DataFormatString="{0:dd/MM}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Actions -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0"><i class="fas fa-exclamation-triangle"></i> Pending Actions</h5>
                        <asp:Button ID="btnRefreshData" runat="server" Text="Refresh" CssClass="btn btn-sm btn-outline-primary" OnClick="btnRefreshData_Click" />
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="alert alert-warning">
                                    <strong>Pending Bookings:</strong>
                                    <asp:Label ID="lblPendingBookings" runat="server" Text="0" />
                                    <a href="ManageBookings.aspx" class="alert-link">View All</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-info">
                                    <strong>New User Registrations:</strong>
                                    <asp:Label ID="lblNewRegistrations" runat="server" Text="0" />
                                    <a href="ManageUsers.aspx" class="alert-link">View All</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="alert alert-danger">
                                    <strong>Maintenance Due:</strong>
                                    <asp:Label ID="lblMaintenanceDue" runat="server" Text="0" />
                                    <a href="ManageVehicles.aspx" class="alert-link">View All</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mt-3">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>
    </div>
</asp:Content>