<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="ManageBookings.aspx.vb" Inherits="AssignmentFinalCar.WebForm11" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        /* Main container styling for booking sections */
        .booking-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        /* Statistics section with gradient background */
        .booking-stats {
           background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
           color: white;
           padding: 20px;
           border-radius: 10px;
           margin-bottom: 20px;
        }
        
        /* Individual statistic item styling */
        .stat-item {
            text-align: center;
        }
        
        /* Large numbers in statistics */
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
        }
        
        /* Page header with gradient background */
        .page-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        /* Status badge colors for different booking statuses */
        .status-pending {
            background-color: #ffc107;  /* Yellow for pending */
            color: #000;
        }
        
        .status-confirmed {
            background-color: #28a745;  /* Green for confirmed */
            color: white;
        }
        
        .status-active {
            background-color: #007bff;  /* Blue for active */
            color: white;
        }
        
        .status-completed {
            background-color: #6c757d;  /* Gray for completed */
            color: white;
        }
        
        .status-cancelled {
            background-color: #dc3545;  /* Red for cancelled */
            color: white;
        }
        
        /* General status badge styling */
        .status-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        /* Action buttons in grid rows */
        .action-buttons .btn {
            margin: 2px;
            padding: 4px 8px;
            font-size: 0.8rem;
        }
        
        /* Filter section styling */
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
    </style>
</asp:Content>

<%-- Main content section --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        
        <%-- Page Header Section --%>
        <div class="page-header">
            <h2><i class="fas fa-calendar-check"></i> Manage Bookings</h2>
        </div>

        <%-- Booking Statistics Dashboard --%>
        <div class="row mb-4">
            <div class="col-12">
                <div class="booking-stats">
                    <div class="row">
                        <%-- Total Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblTotalBookings" runat="server" Text="0" />
                            </div>
                            <div>Total Bookings</div>
                        </div>
                        
                        <%-- Pending Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblPendingBookings" runat="server" Text="0" />
                            </div>
                            <div>Pending</div>
                        </div>
                        
                        <%-- Confirmed Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblConfirmedBookings" runat="server" Text="0" />
                            </div>
                            <div>Confirmed</div>
                        </div>
                        
                        <%-- Active Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblActiveBookings" runat="server" Text="0" />
                            </div>
                            <div>Active</div>
                        </div>
                        
                        <%-- Completed Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblCompletedBookings" runat="server" Text="0" />
                            </div>
                            <div>Completed</div>
                        </div>
                        
                        <%-- Cancelled Bookings Counter --%>
                        <div class="col-md-2 stat-item">
                            <div class="stat-number">
                                <asp:Label ID="lblCancelledBookings" runat="server" Text="0" />
                            </div>
                            <div>Cancelled</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Search and Filter Section --%>
        <div class="filter-section">
            <div class="row">
                <%-- Search Text Box --%>
                <div class="col-md-3">
                    <asp:Label runat="server" CssClass="form-label">Search:</asp:Label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                        placeholder="Search by booking ID, customer name..." />
                </div>
                
                <%-- Status Filter Dropdown --%>
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">Status:</asp:Label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Value="All" Text="All Status" />
                        <asp:ListItem Value="Pending" Text="Pending" />
                        <asp:ListItem Value="Confirmed" Text="Confirmed" />
                        <asp:ListItem Value="Active" Text="Active" />
                        <asp:ListItem Value="Completed" Text="Completed" />
                        <asp:ListItem Value="Cancelled" Text="Cancelled" />
                    </asp:DropDownList>
                </div>
                
                <%-- Date From Filter --%>
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">Date From:</asp:Label>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                
                <%-- Date To Filter --%>
                <div class="col-md-2">
                    <asp:Label runat="server" CssClass="form-label">Date To:</asp:Label>
                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                
                <%-- Search and Clear Buttons --%>
                <div class="col-md-3 d-flex align-items-end">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" 
                        CssClass="btn btn-primary me-2" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" 
                        CssClass="btn btn-outline-secondary" OnClick="btnClear_Click" />
                </div>
            </div>
        </div>

        <%-- Main Bookings Table Container --%>
        <div class="booking-container">
            <%-- Table Header with Page Size Selector --%>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Booking List</h5>
                <div>
                    <asp:Label runat="server">Show: </asp:Label>
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-select d-inline-block" 
                        style="width: auto;" AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                        <asp:ListItem Value="10" Text="10" />
                        <asp:ListItem Value="25" Text="25" />
                        <asp:ListItem Value="50" Text="50" />
                    </asp:DropDownList>
                    <asp:Label runat="server"> entries</asp:Label>
                </div>
            </div>

            <%-- Responsive Table Container --%>
            <div class="table-responsive">
                <%-- Main GridView for displaying bookings --%>
                <asp:GridView ID="gvBookings" runat="server" CssClass="table table-hover" 
                    AutoGenerateColumns="false" GridLines="None" AllowPaging="true" PageSize="10"
                    OnPageIndexChanging="gvBookings_PageIndexChanging" OnRowCommand="gvBookings_RowCommand">
                    <HeaderStyle CssClass="table-dark" />
                    <Columns>
                        <%-- Booking ID Column --%>
                        <asp:BoundField DataField="BookingID" HeaderText="Booking ID" ItemStyle-Width="80px" />
                        
                        <%-- Customer Information Column (Template for custom layout) --%>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <div>
                                    <strong><%# Eval("CustomerName") %></strong><br>
                                    <small class="text-muted"><%# Eval("Email") %></small><br>
                                    <small class="text-muted"><%# Eval("Phone") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Vehicle Information Column --%>
                        <asp:TemplateField HeaderText="Vehicle">
                            <ItemTemplate>
                                <div>
                                    <strong><%# Eval("VehicleName") %></strong><br>
                                    <small class="text-muted"><%# Eval("LicensePlate") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Booking Period Column --%>
                        <asp:TemplateField HeaderText="Booking Period">
                            <ItemTemplate>
                                <div>
                                    <strong>From:</strong> <%# Eval("StartDate", "{0:dd/MM/yyyy}") %><br>
                                    <strong>To:</strong> <%# Eval("EndDate", "{0:dd/MM/yyyy}") %><br>
                                    <small class="text-muted"><%# Eval("TotalDays") %> days</small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Total Amount Column --%>
                        <asp:TemplateField HeaderText="Amount">
                            <ItemTemplate>
                                <strong>Rs. <%# Eval("TotalAmount", "{0:N2}") %></strong>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Status Column with colored badges --%>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- Booking Date Column --%>
                        <asp:BoundField DataField="BookingDate" HeaderText="Booked On" 
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="100px" />
                        
                        <%-- Action Buttons Column --%>
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="200px">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <%-- Confirm Button (visible only for pending bookings) --%>
                                    <asp:Button ID="btnConfirm" runat="server" Text="Confirm" 
                                        CssClass="btn btn-success btn-sm" 
                                        CommandName="ConfirmBooking" CommandArgument='<%# Eval("BookingID") %>'
                                        Visible='<%# Eval("Status").ToString() = "Pending" %>'
                                        OnClientClick="return confirm('Are you sure you want to confirm this booking?');" />
                                    
                                    <%-- Cancel Button (visible for pending and confirmed bookings) --%>
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                        CssClass="btn btn-danger btn-sm" 
                                        CommandName="CancelBooking" CommandArgument='<%# Eval("BookingID") %>'
                                        Visible='<%# Eval("Status").ToString() = "Pending" Or Eval("Status").ToString() = "Confirmed" %>'
                                        OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                                    
                                    <%-- Complete Button (visible only for active bookings) --%>
                                    <asp:Button ID="btnComplete" runat="server" Text="Complete" 
                                        CssClass="btn btn-secondary btn-sm" 
                                        CommandName="CompleteBooking" CommandArgument='<%# Eval("BookingID") %>'
                                        Visible='<%# Eval("Status").ToString() = "Active" %>'
                                        OnClientClick="return confirm('Are you sure you want to mark this booking as completed?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <%-- Template shown when no data is found --%>
                    <EmptyDataTemplate>
                        <div class="text-center py-4">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <h5>No bookings found</h5>
                            <p class="text-muted">Try adjusting your search criteria.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <%-- Modal for Booking Details (for future enhancement) --%>
        <div class="modal fade" id="bookingDetailsModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Booking Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Panel ID="pnlBookingDetails" runat="server">
                            <!-- Booking details will be loaded here -->
                        </asp:Panel>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- Success/Error Message Panel --%>
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" 
            CssClass="position-fixed alert alert-dismissible fade show" 
            style="top: 100px; right: 20px; z-index: 1050;">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>
    </div>
</asp:Content>