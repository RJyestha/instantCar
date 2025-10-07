<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="VehicleDetails.aspx.vb" Inherits="AssignmentFinalCar.WebForm18" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .vehicle-detail-container {
        background: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        overflow: hidden;
        margin-bottom: 30px;
    }
    
    .vehicle-image {
        height: 400px;
        object-fit: cover;
        width: 100%;
    }
    
    .price-section {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        color: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    
    .booking-form {
        background: #f8f9fa;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    
    .feature-list {
        list-style: none;
        padding: 0;
    }
    
    .feature-list li {
        padding: 8px 0;
        border-bottom: 1px solid #eee;
    }
    
    .feature-list li:last-child {
        border-bottom: none;
    }
    
    .addon-item {
        background: white;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 10px;
        transition: all 0.3s ease;
    }
    
    .addon-item:hover {
        border-color: #007bff;
    }
    
    .addon-item.selected {
        border-color: #007bff;
        background: #e3f2fd;
    }
    
    .price-breakdown {
        background: white;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
    }
    
    .total-price {
        font-size: 1.5rem;
        font-weight: bold;
        color: #007bff;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row">
            <!-- Vehicle Details -->
            <div class="col-md-8">
                <div class="vehicle-detail-container">
                    <!-- Vehicle Images -->
                    <asp:Image ID="imgVehicle" runat="server" CssClass="vehicle-image" />
                    
                    <!-- Vehicle Information -->
                    <div class="p-4">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h2 class="text-primary mb-2">
                                    <asp:Label ID="lblVehicleName" runat="server" />
                                </h2>
                                <p class="text-muted">
                                    <i class="fas fa-id-card me-2"></i>License: <asp:Label ID="lblLicensePlate" runat="server" />
                                </p>
                            </div>
                            <div class="text-end">
                                <span class="badge bg-success fs-6">
                                    <asp:Label ID="lblStatus" runat="server" />
                                </span>
                            </div>
                        </div>
                        
                        <!-- Vehicle Specifications -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5>Specifications</h5>
                                <ul class="feature-list">
                                    <li><i class="fas fa-calendar me-2"></i>Year: <asp:Label ID="lblYear" runat="server" /></li>
                                    <li><i class="fas fa-gas-pump me-2"></i>Fuel Type: <asp:Label ID="lblFuelType" runat="server" /></li>
                                    <li><i class="fas fa-cogs me-2"></i>Transmission: <asp:Label ID="lblTransmission" runat="server" /></li>
                                    <li><i class="fas fa-users me-2"></i>Seating: <asp:Label ID="lblSeating" runat="server" /> persons</li>
                                    <li><i class="fas fa-palette me-2"></i>Color: <asp:Label ID="lblColor" runat="server" /></li>
                                    <li><i class="fas fa-tachometer-alt me-2"></i>Mileage: <asp:Label ID="lblMileage" runat="server" /> km</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h5>Features</h5>
                                <asp:Panel ID="pnlFeatures" runat="server">
                                    <!-- Features will be loaded dynamically -->
                                </asp:Panel>
                            </div>
                        </div>
                        
                        <!-- Description -->
                        <asp:Panel ID="pnlDescription" runat="server" Visible="false">
                            <h5>Description</h5>
                            <p><asp:Label ID="lblDescription" runat="server" /></p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
            
            <!-- Booking Section -->
            <div class="col-md-4">
                <!-- Price Section -->
                <div class="price-section">
                    <div class="text-center">
                        <h3 class="mb-2">Rs <asp:Label ID="lblPricePerDay" runat="server" />/day</h3>
                        <p class="mb-0">Base rental price</p>
                    </div>
                </div>
                
                <!-- Booking Form -->
                <div class="booking-form">
                    <h5 class="mb-3"><i class="fas fa-calendar-check me-2"></i>Book This Vehicle</h5>
                    
                    <div class="mb-3">
                        <label class="form-label">Start Date *</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="DateChanged" />
                        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate" 
                            ErrorMessage="Start date is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">End Date *</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="DateChanged" />
                        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="txtEndDate" 
                            ErrorMessage="End date is required" CssClass="text-danger small" Display="Dynamic" />
                        <asp:CompareValidator ID="cvEndDate" runat="server" ControlToValidate="txtEndDate" 
                            ControlToCompare="txtStartDate" Operator="GreaterThan" Type="Date"
                            ErrorMessage="End date must be after start date" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Delivery Time</label>
                        <asp:TextBox ID="txtDeliveryTime" runat="server" TextMode="Time" CssClass="form-control" />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Drop-off Location *</label>
                        <asp:TextBox ID="txtDropoffLocation" runat="server" CssClass="form-control" 
                            placeholder="Enter drop-off location" />
                        <asp:RequiredFieldValidator ID="rfvDropoff" runat="server" ControlToValidate="txtDropoffLocation" 
                            ErrorMessage="Drop-off location is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Special Requests</label>
                        <asp:TextBox ID="txtSpecialRequests" runat="server" TextMode="MultiLine" Rows="3" 
                            CssClass="form-control" placeholder="Any special requirements..." />
                    </div>
                </div>
                
                <!-- Add-ons Section -->
                <div class="booking-form">
                    <h5 class="mb-3"><i class="fas fa-plus-circle me-2"></i>Add-ons (Optional)</h5>
                    <asp:Repeater ID="rptAddons" runat="server">
                        <ItemTemplate>
                            <div class="addon-item">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkAddon" runat="server" CssClass="form-check-input" 
                                        AutoPostBack="true" OnCheckedChanged="AddonChanged" />
                                    <asp:HiddenField ID="hdnAddonID" runat="server" Value='<%# Eval("AddonID") %>' />
                                    <asp:HiddenField ID="hdnAddonPrice" runat="server" Value='<%# Eval("PricePerDay") %>' />
                                    <label class="form-check-label fw-bold">
                                        <%# Eval("AddonName") %>
                                    </label>
                                </div>
                                <small class="text-muted"><%# Eval("Description") %></small>
                                <div class="text-primary fw-bold">+Rs <%# Eval("PricePerDay", "{0:N0}") %>/day</div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <!-- Price Breakdown -->
                <div class="price-breakdown">
                    <h5 class="mb-3">Price Breakdown</h5>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Rental Days:</span>
                        <span><asp:Label ID="lblRentalDays" runat="server" Text="0" /> day(s)</span>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Base Price:</span>
                        <span>Rs <asp:Label ID="lblSubTotal" runat="server" Text="0" /></span>
                    </div>
                    
                    <asp:Panel ID="pnlDiscount" runat="server" Visible="false">
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span>Discount (<asp:Label ID="lblDiscountPercent" runat="server" />%):</span>
                            <span>-Rs <asp:Label ID="lblDiscountAmount" runat="server" Text="0" /></span>
                        </div>
                    </asp:Panel>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Add-ons:</span>
                        <span>Rs <asp:Label ID="lblAddonTotal" runat="server" Text="0" /></span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-3">
                        <strong>Total Amount:</strong>
                        <strong class="total-price">Rs <asp:Label ID="lblTotalAmount" runat="server" Text="0" /></strong>
                    </div>
                    
                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" 
                        CssClass="btn btn-warning w-100 mb-2" OnClick="btnAddToCart_Click" />
                    
                    <asp:Button ID="btnBookNow" runat="server" Text="Book Now" 
                        CssClass="btn btn-primary w-100" OnClick="btnBookNow_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        // Set minimum date to today
        document.addEventListener('DOMContentLoaded', function() {
            var today = new Date().toISOString().split('T')[0];
            var startDate = document.getElementById('<%= txtStartDate.ClientID %>');
            var endDate = document.getElementById('<%= txtEndDate.ClientID %>');
            
            if (startDate) startDate.setAttribute('min', today);
            if (endDate) endDate.setAttribute('min', today);
        });

        // Auto-hide messages
        setTimeout(function() {
            var messagePanel = document.getElementById('<%= pnlMessage.ClientID %>');
            if (messagePanel && messagePanel.style.display !== 'none') {
                messagePanel.style.display = 'none';
            }
        }, 5000);
    </script>
</asp:Content>
