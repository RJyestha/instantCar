<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="ClientHome.aspx.vb" Inherits="AssignmentFinalCar.WebForm14" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        .dashboard-stats {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 50%, #1e3a8a 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255,255,255,0.15);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .quick-actions {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .action-btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .news-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .news-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #4a90e2;
        }
        
        .news-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h2 class="mb-3">
                <i class="fas fa-home me-2 text-primary"></i>Welcome to CarInstant
            </h2>
            <p class="lead mb-0">Your trusted car rental service in Mauritius</p>
        </div>

        <!-- Dashboard Statistics -->
        <div class="dashboard-stats">
            <h2 class="mb-4">
                <i class="fas fa-tachometer-alt me-2"></i>Your Dashboard Overview
            </h2>
            <div class="row">
                <!-- Total Bookings -->
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalBookings" runat="server" Text="0" />
                        </div>
                        <div>Total Bookings</div>
                    </div>
                </div>

                <!-- Active Bookings -->
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblActiveBookings" runat="server" Text="0" />
                        </div>
                        <div>Active Bookings</div>
                    </div>
                </div>

                <!-- Items in Cart -->
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblCartItems" runat="server" Text="0" />
                        </div>
                        <div>Items in Cart</div>
                    </div>
                </div>

                <!-- Total Spent -->
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalSpent" runat="server" Text="Rs 0" />
                        </div>
                        <div>Total Spent</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Quick Actions -->
            <div class="col-md-6">
                <div class="quick-actions">
                    <h4 class="mb-3">
                        <i class="fas fa-bolt text-warning me-2"></i>Quick Actions
                    </h4>
                    <asp:HyperLink ID="lnkSearchVehicles" runat="server"
                        NavigateUrl="~/SearchVehicles.aspx"
                        CssClass="action-btn btn btn-primary">
                        <i class="fas fa-search me-2"></i>Search Vehicles
                    </asp:HyperLink>

                    <asp:HyperLink ID="lnkViewCart" runat="server"
                        NavigateUrl="~/Cart.aspx"
                        CssClass="action-btn btn btn-success">
                        <i class="fas fa-shopping-cart me-2"></i>View Cart (
                        <asp:Label ID="lblCartCount" runat="server" Text="0" />)
                    </asp:HyperLink>

                    <asp:HyperLink ID="lnkMyBookings" runat="server"
                        NavigateUrl="~/MyBookings.aspx"
                        CssClass="action-btn btn btn-info">
                        <i class="fas fa-calendar-alt me-2"></i>My Bookings
                    </asp:HyperLink>

                    <asp:HyperLink ID="lnkProfile" runat="server"
                        NavigateUrl="~/ClientProfile.aspx"
                        CssClass="action-btn btn btn-secondary">
                        <i class="fas fa-user-edit me-2"></i>Edit Profile
                    </asp:HyperLink>
                </div>
            </div>

            <!-- Latest News -->
            <div class="col-md-6">
                <div class="news-section">
                    <h4 class="mb-3">
                        <i class="fas fa-newspaper text-info me-2"></i>Latest News & Updates
                    </h4>
                    <asp:Repeater ID="rptLatestNews" runat="server">
                        <ItemTemplate>
                            <div class="news-card">
                                <h6 class="fw-bold text-primary mb-2"><%# Eval("Title") %></h6>
                                <p class="mb-2"><%# TruncateText(Eval("Content"), 100) %></p>
                                <small class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>
                                    <%# Eval("CreatedDate", "{0:dd MMM yyyy}") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- Show if no news available -->
                    <asp:Panel ID="pnlNoNews" runat="server" Visible="false" CssClass="text-center text-muted py-3">
                        <i class="fas fa-info-circle me-2"></i>No news available
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Message Panel -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>
</asp:Content>