<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="SearchVehicles.aspx.vb" Inherits="AssignmentFinalCar.WebForm12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        .search-container {
           background: linear-gradient(135deg, #007BFF 0%, #66B2FF 100%);
           color: white;
           border-radius: 15px;
           padding: 30px;
           margin-bottom: 30px;
         }
        
        .search-form {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 25px;
            backdrop-filter: blur(10px);
        }
        
        .form-control, .form-select {
            border: 2px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.9);
            border-radius: 8px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #ffc107;
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
        }
        
        .vehicle-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .price-badge {
           position: absolute;
           top: 15px;
           right: 15px;
           background: #007BFF; /* Bootstrap blue */
           color: white;
           padding: 8px 12px;
           border-radius: 20px;
           font-weight: bold;
           z-index: 2;
         }
        
        .vehicle-features {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 10px 0;
        }
        
        .feature-badge {
            background: #e9ecef;
            color: #495057;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
        }
        
        .no-results {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .vehicle-image {
            height: 200px;
            object-fit: cover;
            width: 100%;
            transition: transform 0.3s ease;
        }

        .vehicle-card:hover .vehicle-image {
            transform: scale(1.05);
        }

        .image-placeholder {
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 1.2rem;
        }

        .results-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-buttons .btn {
            flex: 1;
            min-width: 100px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Search Container -->
        <div class="search-container">
            <h2 class="mb-4">
                <i class="fas fa-search me-2"></i>Advanced Vehicle Search
            </h2>
            
            <div class="search-form">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Make</label>
                        <asp:DropDownList ID="ddlMake" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlMake_SelectedIndexChanged">
                            <asp:ListItem Value="" Text="-- Select Make --" />
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Model</label>
                        <asp:DropDownList ID="ddlModel" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Select Model --" />
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Fuel Type</label>
                        <asp:DropDownList ID="ddlFuelType" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Any Fuel Type --" />
                            <asp:ListItem Value="Petrol" Text="Petrol" />
                            <asp:ListItem Value="Diesel" Text="Diesel" />
                            <asp:ListItem Value="Electric" Text="Electric" />
                            <asp:ListItem Value="Hybrid" Text="Hybrid" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Min Price (Rs/day)</label>
                        <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Max Price (Rs/day)</label>
                        <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control" TextMode="Number" placeholder="10000" />
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Transmission</label>
                        <asp:DropDownList ID="ddlTransmission" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Any --" />
                            <asp:ListItem Value="Manual" Text="Manual" />
                            <asp:ListItem Value="Automatic" Text="Automatic" />
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Seating Capacity</label>
                        <asp:DropDownList ID="ddlSeating" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Any --" />
                            <asp:ListItem Value="2" Text="2 Seats" />
                            <asp:ListItem Value="4" Text="4 Seats" />
                            <asp:ListItem Value="5" Text="5 Seats" />
                            <asp:ListItem Value="7" Text="7+ Seats" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Search by Vehicle Name</label>
                        <asp:TextBox ID="txtSearchName" runat="server" CssClass="form-control" placeholder="Enter make or model name..." />
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Sort By</label>
                        <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-select">
                            <asp:ListItem Value="PriceAsc" Text="Price: Low to High" />
                            <asp:ListItem Value="PriceDesc" Text="Price: High to Low" />
                            <asp:ListItem Value="MakeAsc" Text="Make A-Z" />
                            <asp:ListItem Value="ModelAsc" Text="Model A-Z" />
                            <asp:ListItem Value="Newest" Text="Newest First" />
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-3 d-flex align-items-end">
                        <asp:Button ID="btnSearch" runat="server" Text="Search Vehicles" CssClass="btn btn-warning btn-lg w-100" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Section -->
        <div class="results-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">
                <asp:Label ID="lblResultsCount" runat="server" Text="Search Results" />
            </h4>
            <asp:Button ID="btnClearFilters" runat="server" Text="Clear All Filters" CssClass="btn btn-outline-secondary" OnClick="btnClearFilters_Click" />
        </div>

        <!-- Vehicle Results with Pagination -->
        <asp:ListView ID="lvVehicles" runat="server">
            <LayoutTemplate>
                <div class="row">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div class="col-md-6 col-lg-4">
                    <div class="card vehicle-card position-relative">
                        <div class="price-badge">
                            Rs <%# Eval("PricePerDay", "{0:N0}") %>/day
                        </div>
                        
                        <!-- Simple image display with proper error handling -->
                        <img src='<%# GetVehicleImagePath(Eval("ImagePath")) %>' 
                             class="card-img-top vehicle-image" 
                             alt='<%# Eval("MakeName") & " " & Eval("ModelName") %>' 
                             onerror="this.src='images/no-vehicle-image.jpg'; this.onerror=null;" />
                        
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("MakeName") %> <%# Eval("ModelName") %></h5>
                            <p class="text-muted mb-2">
                                <i class="fas fa-calendar me-1"></i>Year: <%# Eval("Year") %> | 
                                <i class="fas fa-id-card me-1"></i>License: <%# Eval("LicensePlate") %>
                            </p>
                            
                            <!-- Vehicle Description from Database -->
                            <%# If(Eval("Description") IsNot Nothing AndAlso Not IsDBNull(Eval("Description")) AndAlso Not String.IsNullOrEmpty(Eval("Description").ToString()),
                                                        "<p class='text-muted small mb-2'><i class='fas fa-info-circle me-1'></i>" & Eval("Description") & "</p>", "") %>
                            
                            <div class="vehicle-features">
                                <span class="feature-badge">
                                    <i class="fas fa-gas-pump me-1"></i><%# Eval("FuelType") %>
                                </span>
                                <span class="feature-badge">
                                    <i class="fas fa-cogs me-1"></i><%# Eval("Transmission") %>
                                </span>
                                <span class="feature-badge">
                                    <i class="fas fa-users me-1"></i><%# Eval("SeatingCapacity") %> Seats
                                </span>
                                <%# If(Eval("Color") IsNot Nothing AndAlso Not IsDBNull(Eval("Color")) AndAlso Not String.IsNullOrEmpty(Eval("Color").ToString()),
                                                            "<span class='feature-badge'><i class='fas fa-palette me-1'></i>" & Eval("Color") & "</span>", "") %>
                            </div>
                            
                            <div class="action-buttons mt-3">
                                <asp:LinkButton ID="lnkBook" runat="server" 
                                    CommandArgument='<%# Eval("VehicleID") %>'
                                    OnCommand="BookNow_Command"
                                    CssClass="btn btn-primary btn-sm">
                                    <i class="fas fa-calendar-check me-1"></i>Book Now
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="lnkAddToCart" runat="server" 
                                    CommandArgument='<%# Eval("VehicleID") %>'
                                    OnCommand="AddToCart_Command"
                                    CssClass="btn btn-warning btn-sm">
                                    <i class="fas fa-cart-plus me-1"></i>Add to Cart
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <EmptyDataTemplate>
                <div class="no-results">
                    <i class="fas fa-search fa-3x mb-3 text-muted"></i>
                    <h4>No vehicles found</h4>
                    <p>Try adjusting your search criteria or clear all filters to see more results.</p>
                    <asp:Button ID="btnShowAll" runat="server" Text="Show All Vehicles" 
                        CssClass="btn btn-primary" OnClick="btnClearFilters_Click" />
                </div>
            </EmptyDataTemplate>
        </asp:ListView>

        <!-- Pagination -->
        <div class="pagination-container">
            <asp:DataPager ID="dpVehicles" runat="server" PagedControlID="lvVehicles" PageSize="12">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="true" ShowLastPageButton="true" 
                        FirstPageText="&laquo; First" LastPageText="Last &raquo;" NextPageText="Next &rsaquo;" PreviousPageText="&lsaquo; Previous" 
                        ButtonCssClass="btn btn-outline-primary me-1" />
                    <asp:NumericPagerField ButtonType="Button" NumericButtonCssClass="btn btn-outline-secondary me-1" 
                        CurrentPageLabelCssClass="btn btn-primary me-1" />
                </Fields>
            </asp:DataPager>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="position-fixed" style="top: 100px; right: 20px; z-index: 1050; max-width: 400px;">
        <div class="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        // Auto-hide messages after 5 seconds
        setTimeout(function() {
            var messagePanel = document.getElementById('<%= pnlMessage.ClientID %>');
            if (messagePanel && messagePanel.style.display !== 'none') {
                messagePanel.style.display = 'none';
            }
        }, 5000);
    </script>
</asp:Content>