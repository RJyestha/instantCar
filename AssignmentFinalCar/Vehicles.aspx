<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/PublicMaster.Master" CodeBehind="Vehicles.aspx.vb" Inherits="AssignmentFinalCar.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        /* ==================== FILTER SECTION STYLES ==================== */
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        /* ==================== VEHICLE CARD STYLES ==================== */
        .vehicle-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 100%;
            border-radius: 15px;
            overflow: hidden;
        }
        
        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .vehicle-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
            border-radius: 0;
        }
        
        .price-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,123,255,0.9);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.85rem;
        }
        
        .vehicle-features {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: #6c757d;
            flex-wrap: wrap;
            gap: 5px;
        }
        
        .vehicle-features span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        /* ==================== PAGINATION STYLES ==================== */
        .pagination-wrapper {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
        
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 2px;
            border: 1px solid #dee2e6;
            color: #007bff;
            padding: 8px 12px;
        }
        
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
        }
        
        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: #0056b3;
        }
        
        /* ==================== HEADER STYLES ==================== */
       .search-results-header {
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          padding: 20px;
          border-radius: 10px;
          margin-bottom: 30px;
          box-shadow: 0 5px 20px rgba(0,0,0,0.1);
       }
        
        /* ==================== FILTER BADGE STYLES ==================== */
        .filter-badge {
            background-color: #007bff;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            display: inline-block;
        }
        
        .clear-filters {
            color: #dc3545;
            text-decoration: none;
            font-weight: 500;
        }
        
        .clear-filters:hover {
            color: #c82333;
            text-decoration: underline;
        }
        
        /* ==================== NO RESULTS STYLES ==================== */
        .no-results-card {
            border: 2px dashed #dee2e6;
            border-radius: 15px;
            background-color: #f8f9fa;
        }
        
        /* ==================== RESPONSIVE STYLES ==================== */
        @media (max-width: 768px) {
            .filter-section {
                padding: 15px;
            }
            
            .vehicle-features {
                font-size: 0.8rem;
                justify-content: center;
                text-align: center;
            }
            
            .search-results-header {
                text-align: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlContainer" runat="server" CssClass="container mt-4">
        <!-- Page Header -->
        <asp:Panel CssClass="search-results-header" runat="server">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <asp:Label runat="server" CssClass="h1 mb-2 d-block">
                        <i class="fas fa-car me-2"></i>Our Vehicle Fleet
                    </asp:Label>
                    <asp:Label runat="server" CssClass="mb-0 d-block">
                        Choose from our wide selection of quality vehicles for your perfect trip
                    </asp:Label>
                </div>
                <div class="col-md-4 text-end">
                    <asp:Label ID="lblResultsCount" runat="server" CssClass="fs-5" Text="0 vehicles available" />
                </div>
            </div>
        </asp:Panel>

        <!-- Filter Section -->
        <asp:Panel ID="pnlFilters" runat="server" CssClass="filter-section">
            <div class="row g-3">
                <!-- Make Dropdown -->
                <div class="col-md-3">
                    <asp:Label AssociatedControlID="ddlMake" runat="server" CssClass="form-label">
                        <i class="fas fa-industry me-1 text-primary"></i>Make
                    </asp:Label>
                    <asp:DropDownList ID="ddlMake" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="">All Makes</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Model Dropdown -->
                <div class="col-md-3">
                    <asp:Label AssociatedControlID="ddlModel" runat="server" CssClass="form-label">
                        <i class="fas fa-car me-1 text-primary"></i>Model
                    </asp:Label>
                    <asp:DropDownList ID="ddlModel" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="">All Models</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Fuel Type -->
                <div class="col-md-2">
                    <asp:Label AssociatedControlID="ddlFuelType" runat="server" CssClass="form-label">
                        <i class="fas fa-gas-pump me-1 text-primary"></i>Fuel Type
                    </asp:Label>
                    <asp:DropDownList ID="ddlFuelType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="">All Types</asp:ListItem>
                        <asp:ListItem Value="Petrol">Petrol</asp:ListItem>
                        <asp:ListItem Value="Diesel">Diesel</asp:ListItem>
                        <asp:ListItem Value="Electric">Electric</asp:ListItem>
                        <asp:ListItem Value="Hybrid">Hybrid</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Transmission -->
                <div class="col-md-2">
                    <asp:Label AssociatedControlID="ddlTransmission" runat="server" CssClass="form-label">
                        <i class="fas fa-cog me-1 text-primary"></i>Transmission
                    </asp:Label>
                    <asp:DropDownList ID="ddlTransmission" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="">All Types</asp:ListItem>
                        <asp:ListItem Value="Manual">Manual</asp:ListItem>
                        <asp:ListItem Value="Automatic">Automatic</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Seats -->
                <div class="col-md-2">
                    <asp:Label AssociatedControlID="ddlSeats" runat="server" CssClass="form-label">
                        <i class="fas fa-users me-1 text-primary"></i>Seats
                    </asp:Label>
                    <asp:DropDownList ID="ddlSeats" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="">All Seats</asp:ListItem>
                        <asp:ListItem Value="2">2 Seats</asp:ListItem>
                        <asp:ListItem Value="4">4 Seats</asp:ListItem>
                        <asp:ListItem Value="5">5 Seats</asp:ListItem>
                        <asp:ListItem Value="7">7 Seats</asp:ListItem>
                        <asp:ListItem Value="8">8+ Seats</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- Price Range + Sort + Buttons -->
            <div class="row mt-3">
                <div class="col-md-4">
                    <asp:Label CssClass="form-label" runat="server">
                        <i class="fas fa-rupee-sign me-1 text-primary"></i>Price Range (Rs per day)
                    </asp:Label>
                    <div class="row g-2">
                        <div class="col-6">
                            <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control" placeholder="Min" TextMode="Number" />
                        </div>
                        <div class="col-6">
                            <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control" placeholder="Max" TextMode="Number" />
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <asp:Label AssociatedControlID="ddlSort" runat="server" CssClass="form-label">
                        <i class="fas fa-sort me-1 text-primary"></i>Sort by
                    </asp:Label>
                    <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="SortChanged">
                        <asp:ListItem Value="PriceAsc">Price: Low to High</asp:ListItem>
                        <asp:ListItem Value="PriceDesc">Price: High to Low</asp:ListItem>
                        <asp:ListItem Value="MakeAsc">Make A-Z</asp:ListItem>
                        <asp:ListItem Value="MakeDesc">Make Z-A</asp:ListItem>
                        <asp:ListItem Value="ModelAsc">Model A-Z</asp:ListItem>
                        <asp:ListItem Value="Newest">Newest First</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label CssClass="form-label" runat="server">&nbsp;</asp:Label>
                    <div class="d-flex gap-2">
                        <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn btn-primary" OnClick="btnFilter_Click" />
                        <asp:Button ID="btnClearFilters" runat="server" Text="Clear All" CssClass="btn btn-outline-secondary" OnClick="btnClearFilters_Click" />
                    </div>
                </div>
            </div>

            <!-- Active Filters Display -->
            <asp:Panel ID="pnlActiveFilters" runat="server" CssClass="mt-3" Visible="false">
                <div class="d-flex align-items-center flex-wrap">
                    <asp:Label runat="server" CssClass="me-2"><strong>Active Filters:</strong></asp:Label>
                    <asp:Literal ID="litActiveFilters" runat="server" />
                    <asp:LinkButton ID="lnkClearFilters" runat="server" CssClass="clear-filters ms-2" OnClick="btnClearFilters_Click" Text="Clear All" />
                </div>
            </asp:Panel>
        </asp:Panel>

        <!--  Vehicle Repeater Grid -->
        <div class="row">
            <asp:Repeater ID="rptVehicles" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card vehicle-card">
                            <div class="position-relative">
                                <img src='<%# GetImagePath(Eval("ImagePath")) %>' class="vehicle-image" alt="Vehicle Image" onerror="this.src='~/image/default-car.jpg';" />
                                <span class="price-badge">Rs <%# Eval("PricePerDay", "{0:N0}") %>/day</span>
                            </div>
                            <div class="card-body">
                                <asp:Label runat="server" CssClass="card-title h5 mb-2">
                                    <%# Eval("MakeName") %> <%# Eval("ModelName") %>
                                </asp:Label>
                                <asp:Label runat="server" CssClass="card-text text-muted mb-3">
                                    <%# Eval("Year") %> • <%# Eval("Color") %>
                                </asp:Label>

                                <div class="vehicle-features mb-3">
                                    <span><i class="fas fa-users text-primary"></i> <%# Eval("SeatingCapacity") %> Seats</span>
                                    <span><i class="fas fa-cog text-primary"></i> <%# Eval("Transmission") %></span>
                                    <span><i class="fas fa-gas-pump text-primary"></i> <%# Eval("FuelType") %></span>
                                </div>

                                <hr class="my-3" />

                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-primary fw-bold">
                                        <span class="fs-5">Rs <%# Eval("PricePerDay", "{0:N2}") %></span>
                                        <small class="text-muted">/day</small>
                                    </div>
                                    <asp:LinkButton ID="lnkBookNow" runat="server" CommandArgument='<%# Eval("VehicleID") %>' OnCommand="BookNow_Command" CssClass="btn btn-primary">Book Now</asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- No Results Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" CssClass="text-center py-5" Visible="false">
            <div class="card no-results-card">
                <div class="card-body py-5">
                    <i class="fas fa-search fs-1 text-muted mb-3"></i>
                    <h4>No vehicles found</h4>
                    <p class="text-muted mb-4">We couldn't find any vehicles matching your criteria.<br />Try adjusting your search filters to find more vehicles.</p>
                    <asp:Button ID="btnClearFiltersNoResults" runat="server" Text="Clear All Filters" CssClass="btn btn-primary" OnClick="btnClearFilters_Click" />
                </div>
            </div>
        </asp:Panel>

        <!-- Pagination Panel -->
        <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination-wrapper" Visible="false">
            <nav aria-label="Vehicle pagination">
                <ul class="pagination">
                    <asp:PlaceHolder ID="phPagination" runat="server" />
                </ul>
            </nav>
        </asp:Panel>

    </asp:Panel>
</asp:Content>