<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="MyBookings.aspx.vb" Inherits="AssignmentFinalCar.WebForm16" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        .bookings-header {
            background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .booking-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.85rem;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-completed {
            background: #e2e3e5;
            color: #383d41;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .booking-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .timeline {
            position: relative;
            padding: 10px 0;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 30px;
            margin-bottom: 10px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: 8px;
            top: 8px;
            width: 8px;
            height: 8px;
            background: #007bff;
            border-radius: 50%;
        }
        
        .timeline-item::after {
            content: '';
            position: absolute;
            left: 11px;
            top: 16px;
            width: 2px;
            height: calc(100% + 10px);
            background: #dee2e6;
        }
        
        .timeline-item:last-child::after {
            display: none;
        }
        
        .empty-bookings {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .booking-summary {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 0 8px 8px 0;
        }

        .vehicle-image {
            height: 150px; 
            width: 100%; 
            object-fit: cover;
            border-radius: 8px;
        }

        .search-input {
            position: relative;
        }

        .search-input i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            z-index: 2;
        }

        .search-input input {
            padding-left: 40px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Header -->
        <div class="bookings-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-2">
                        <i class="fas fa-calendar-check me-2"></i>My Bookings
                    </h2>
                    <p class="mb-0">Manage and track your vehicle reservations</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex justify-content-end gap-3">
                        <div class="text-center">
                            <h4 class="mb-0"><asp:Label ID="lblTotalBookings" runat="server" Text="0" /></h4>
                            <small>Total</small>
                        </div>
                        <div class="text-center">
                            <h4 class="mb-0"><asp:Label ID="lblActiveBookings" runat="server" Text="0" /></h4>
                            <small>Active</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Filter Section -->
        <div class="filter-section">
            <div class="row align-items-end">
                <div class="col-md-3">
                    <label class="form-label">Search Bookings</label>
                    <div class="search-input">
                        <i class="fas fa-search"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                            placeholder="Search by car make, model, or license plate..." />
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Status</label>
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                        <asp:ListItem Value="" Text="All Status" />
                        <asp:ListItem Value="Pending" Text="Pending" />
                        <asp:ListItem Value="Confirmed" Text="Confirmed" />
                        <asp:ListItem Value="Active" Text="Active" />
                        <asp:ListItem Value="Completed" Text="Completed" />
                        <asp:ListItem Value="Cancelled" Text="Cancelled" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label">From Date</label>
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>
                <div class="col-md-2">
                    <label class="form-label">To Date</label>
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>
                <div class="col-md-3">
                    <div class="d-flex gap-2">
                        <asp:Button ID="btnApplyFilter" runat="server" Text="Search" CssClass="btn btn-primary flex-fill" OnClick="btnApplyFilter_Click" />
                        <asp:Button ID="btnClearFilter" runat="server" Text="Clear" CssClass="btn btn-outline-secondary" OnClick="btnClearFilter_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Bookings List -->
        <asp:ListView ID="lvBookings" runat="server">
            <LayoutTemplate>
                <div class="row">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div class="col-12">
                    <div class="card booking-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">Booking #<%# Eval("BookingID") %></h5>
                                <small class="text-muted">Booked on <%# Eval("BookingDate", "{0:dd MMM yyyy HH:mm}") %></small>
                            </div>
                            <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                <i class='<%# GetBookingStatusIcon(Eval("Status")) %> me-1'></i>
                                <%# Eval("Status") %>
                            </span>
                        </div>
                        
                        <div class="card-body">
                            <div class="row">
                                <!-- Vehicle Image - FIXED to show database images -->
                                <div class="col-md-3">
                                    <img src='<%# GetVehicleImagePath(Eval("VehicleID")) %>' 
                                         alt='<%# Eval("MakeName") & " " & Eval("ModelName") %>' 
                                         class="vehicle-image"
                                         onerror="this.src='image/no-vehicle-image.jpg'; console.log('Image failed to load:', this.src);" />
                                </div>
                                
                                <!-- Booking Details -->
                                <div class="col-md-6">
                                    <h5 class="text-primary">
                                        <i class="fas fa-car me-2"></i>
                                        <%# Eval("MakeName") %> <%# Eval("ModelName") %>
                                    </h5>
                                    <p class="text-muted mb-2">
                                        <span class="badge bg-light text-dark"><%# Eval("Year") %></span>
                                        <span class="badge bg-light text-dark"><%# Eval("LicensePlate") %></span>
                                        <span class="badge bg-light text-dark"><%# Eval("FuelType") %></span>
                                        <span class="badge bg-light text-dark"><%# Eval("Transmission") %></span>
                                    </p>
                                    
                                    <div class="booking-details">
                                        <div class="row">
                                            <div class="col-6">
                                                <strong><i class="fas fa-calendar-alt me-1"></i>Rental Period:</strong><br>
                                                <small><%# Eval("StartDate", "{0:dd MMM yyyy}") %> to <%# Eval("EndDate", "{0:dd MMM yyyy}") %></small><br>
                                                <small class="text-muted"><%# CalculateDays(Eval("StartDate"), Eval("EndDate")) %> day(s)</small>
                                            </div>
                                            <div class="col-6">
                                                <strong><i class="fas fa-map-marker-alt me-1"></i>Drop-off Location:</strong><br>
                                                <small><%# If(String.IsNullOrEmpty(Eval("DropoffLocation").ToString()), "Not specified", Eval("DropoffLocation")) %></small>
                                            </div>
                                        </div>
                                        
                                        <%# GetFormattedDeliveryTime(Eval("DeliveryTime")) %>
                                    </div>
                                    
                                    <!-- Special Requests -->
                                    <%# If(Not String.IsNullOrEmpty(Eval("SpecialRequests").ToString()),
                                                                            "<div class='mt-2'><strong><i class='fas fa-info-circle me-1'></i>Special Requests:</strong><br><small class='text-muted'>" &
                                                                            Eval("SpecialRequests") & "</small></div>", "") %>
                                </div>
                                
                                <!-- Price and Actions -->
                                <div class="col-md-3">
                                    <div class="booking-summary">
                                        <div class="text-center">
                                            <h4 class="text-primary mb-1">Rs <%# Eval("TotalAmount", "{0:N0}") %></h4>
                                            <small class="text-muted">Total Amount</small>
                                            
                                            <%# If(CDec(Eval("DiscountPercentage")) > 0,
                                                                                    "<div class='mt-1'><span class='badge bg-success'>Save " &
                                                                                    Eval("DiscountPercentage") & "%</span></div>", "") %>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons - ONLY CANCEL BUTTON -->
                                    <div class="action-buttons mt-3">
                                        <!-- Cancel Button (only for Pending/Confirmed status) -->
                                        <asp:LinkButton ID="lnkCancel" runat="server" 
                                            CommandArgument='<%# Eval("BookingID") %>'
                                            OnCommand="CancelBooking_Command"
                                            CssClass="btn btn-outline-danger btn-sm w-100"
                                            Visible='<%# CanCancelBooking(Eval("Status"), Eval("StartDate")) %>'
                                            OnClientClick="return confirm('Are you sure you want to cancel this booking?');">
                                            <i class="fas fa-times me-1"></i>Cancel Booking
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Booking Timeline -->
                            <div class="row mt-3">
                                <div class="col-12">
                                    <h6 class="mb-2"><i class="fas fa-history me-2"></i>Booking Timeline</h6>
                                    <div class="timeline">
                                        <div class="timeline-item">
                                            <strong>Booking Created:</strong> <%# Eval("BookingDate", "{0:dd MMM yyyy HH:mm}") %>
                                        </div>
                                        <%# GetFormattedConfirmedDate(Eval("ConfirmedDate")) %>
                                        <%# GetFormattedCancelledDate(Eval("CancelledDate"), Eval("CancellationReason")) %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <EmptyDataTemplate>
                <div class="empty-bookings">
                    <i class="fas fa-calendar-times fa-3x mb-3 text-muted"></i>
                    <h4>No bookings found</h4>
                    <p>You haven't made any bookings yet or no bookings match your search criteria.</p>
                    <asp:HyperLink ID="lnkBrowseVehicles" runat="server" 
                        NavigateUrl="~/SearchVehicles.aspx" 
                        CssClass="btn btn-primary btn-lg">
                        <i class="fas fa-search me-2"></i>Browse Vehicles
                    </asp:HyperLink>
                </div>
            </EmptyDataTemplate>
        </asp:ListView>

        <!-- Pagination -->
        <div class="d-flex justify-content-center mt-4">
            <asp:DataPager ID="dpBookings" runat="server" PagedControlID="lvBookings" PageSize="5">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="true" ShowLastPageButton="true" 
                        FirstPageText="First" LastPageText="Last" NextPageText="Next" PreviousPageText="Previous" 
                        ButtonCssClass="btn btn-outline-primary me-1" />
                </Fields>
            </asp:DataPager>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>
</asp:Content>
                