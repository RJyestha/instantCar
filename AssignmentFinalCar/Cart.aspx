<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="Cart.aspx.vb" Inherits="AssignmentFinalCar.WebForm15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        .cart-header {
           background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
           color: white;
           border-radius: 15px;
           padding: 30px;
           margin-bottom: 30px;
        }
        
        .cart-item {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .vehicle-image {
            height: 120px; 
            width: 100%; 
            object-fit: cover;
            border-radius: 8px;
        }
        
        .cart-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .price-summary {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 0 8px 8px 0;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .discount-badge {
            background: #d4edda;
            color: #155724;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: bold;
        }
        
        .cart-summary {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 25px;
            margin-top: 30px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Header -->
        <div class="cart-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-2">
                        <i class="fas fa-shopping-cart me-2"></i>Shopping Cart
                    </h2>
                    <p class="mb-0">Review your selected vehicles and rental details</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="text-center">
                        <h4 class="mb-0">
                            <asp:Label ID="lblCartCount" runat="server" Text="0" />
                        </h4>
                        <small>Items in Cart</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Empty Cart Panel -->
        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
            <div class="empty-cart">
                <i class="fas fa-shopping-cart fa-4x mb-4 text-muted"></i>
                <h3>Your cart is empty</h3>
                <p class="mb-4">Start browsing our vehicles to add them to your cart</p>
                <asp:HyperLink ID="lnkBrowseVehicles" runat="server" 
                    NavigateUrl="~/SearchVehicles.aspx" 
                    CssClass="btn btn-primary btn-lg">
                    <i class="fas fa-search me-2"></i>Browse Vehicles
                </asp:HyperLink>
            </div>
        </asp:Panel>

        <!-- Cart Items Panel -->
        <asp:Panel ID="pnlCartItems" runat="server" Visible="false">
            <!-- Cart Items Repeater -->
            <asp:Repeater ID="rptCartItems" runat="server">
                <ItemTemplate>
                    <div class="card cart-item">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <%# Eval("VehicleName") %>
                            </h5>
                            <asp:LinkButton ID="btnRemove" runat="server" 
                                CommandName="Remove"
                                CommandArgument='<%# Container.ItemIndex %>'
                                OnCommand="RemoveItem_Command"
                                CssClass="btn btn-outline-danger btn-sm"
                                OnClientClick="return confirm('Remove this item from cart?');">
                                <i class="fas fa-trash me-1"></i>Remove
                            </asp:LinkButton>
                        </div>
                        
                        <div class="card-body">
                            <div class="row">
                                <!-- Vehicle Image -->
                                <div class="col-md-3">
                                    <img src='<%# GetVehicleImage(Eval("VehicleID")) %>' 
                                         alt='<%# Eval("VehicleName") %>' 
                                         class="vehicle-image"
                                         onerror="this.src='images/no-vehicle-image.jpg';" />
                                </div>
                                
                                <!-- Rental Details -->
                                <div class="col-md-6">
                                    <div class="cart-details">
                                        <div class="row">
                                            <div class="col-6">
                                                <strong><i class="fas fa-calendar-alt me-1"></i>Rental Period:</strong><br>
                                                <small><%# Eval("StartDate", "{0:dd MMM yyyy}") %> to <%# Eval("EndDate", "{0:dd MMM yyyy}") %></small><br>
                                                <small class="text-muted"><%# CalculateDays(Eval("StartDate"), Eval("EndDate")) %> day(s)</small>
                                            </div>
                                            <div class="col-6">
                                                <strong><i class="fas fa-dollar-sign me-1"></i>Daily Rate:</strong><br>
                                                <small>Rs <%# Eval("PricePerDay", "{0:N0}") %> per day</small>
                                                <%# GetDiscountInfo(Container.DataItem) %>
                                            </div>
                                        </div>
                                        
                                        <!-- Add-ons if any -->
                                        <%# IIf(HasAddons(Container.DataItem),
                                                        "<div class='mt-2'><strong><i class='fas fa-plus-circle me-1'></i>Add-ons:</strong><br><small class='text-muted'>" &
                                                        GetAddonsList(Container.DataItem) & "</small></div>", "") %>
                                    </div>
                                </div>
                                
                                <!-- Price Summary -->
                                <div class="col-md-3">
                                    <div class="price-summary">
                                        <div class="text-center">
                                            <h4 class="text-primary mb-1">Rs <%# GetItemTotalWithAddons(Container.DataItem) %></h4>
                                            <small class="text-muted">Total Amount</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Cart Summary -->
            <div class="cart-summary">
                <div class="row">
                    <div class="col-md-8">
                        <h4><i class="fas fa-calculator me-2"></i>Cart Summary</h4>
                        
                        <!-- Discount Info Panel -->
                        <asp:Panel ID="pnlDiscountSummary" runat="server" Visible="false">
                            <div class="alert alert-success mt-3">
                                <i class="fas fa-tags me-2"></i>
                                <strong>You're saving Rs <asp:Label ID="lblTotalSavings" runat="server" Text="0" />!</strong>
                                <small class="d-block mt-1">Discounts applied based on rental duration</small>
                            </div>
                        </asp:Panel>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="text-end">
                            <div class="mb-2">
                                <span class="text-muted">Subtotal: </span>
                                <strong>Rs <asp:Label ID="lblSubtotal" runat="server" Text="0" /></strong>
                            </div>
                            <div class="mb-2">
                                <span class="text-muted">Add-ons: </span>
                                <strong>Rs <asp:Label ID="lblAddonsTotal" runat="server" Text="0" /></strong>
                            </div>
                            <hr>
                            <div class="mb-3">
                                <span class="h5">Grand Total: </span>
                                <span class="h4 text-primary">Rs <asp:Label ID="lblGrandTotal" runat="server" Text="0" /></span>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnClearCart" runat="server" 
                                    Text="Clear Cart" 
                                    CssClass="btn btn-outline-danger"
                                    OnClick="btnClearCart_Click"
                                    OnClientClick="return confirm('Are you sure you want to clear all items from cart?');" />
                                    
                                <asp:HyperLink ID="lnkContinueShopping" runat="server" 
                                    NavigateUrl="~/SearchVehicles.aspx" 
                                    CssClass="btn btn-outline-primary">
                                    <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                                </asp:HyperLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <!-- Success/Error Messages -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>
</asp:Content>