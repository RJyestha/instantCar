<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="ManageVehicles.aspx.vb" Inherits="AssignmentFinalCar.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
      <style>
        .vehicle-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 25px;
            overflow: hidden;
        }
        
        .vehicle-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }
        
        .vehicle-image {
            height: 220px;
            object-fit: cover;
            width: 100%;
        }
        
        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-available {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }
        
        .status-rented {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }
        
        .status-maintenance {
            background: linear-gradient(135deg, #ffc107, #f39c12);
            color: #333;
            box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3);
        }
        
        .filter-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        
        .header-section {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.2);
        }
        
        .header-title {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .add-vehicle-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .add-vehicle-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
            background: linear-gradient(135deg, #218838, #1e7e34);
            color: white;
        }
        
        .action-buttons .btn {
            margin: 3px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
            padding: 6px 15px;
            transition: all 0.2s ease;
        }
        
        .action-buttons .btn:hover {
            transform: translateY(-1px);
        }
        
        .vehicle-details {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .price-display {
            font-size: 1.3rem;
            font-weight: 700;
            background: linear-gradient(135deg, #007bff, #0056b3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .search-controls .form-control,
        .search-controls .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            transition: border-color 0.3s ease;
        }
        
        .search-controls .form-control:focus,
        .search-controls .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .search-btn {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            border-radius: 10px;
            padding: 10px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        
        .clear-btn {
            background: #6c757d;
            border: none;
            border-radius: 10px;
            padding: 10px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .clear-btn:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .card-body {
            padding: 20px;
        }
        
        .card-title {
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }
        
        .no-vehicles-alert {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border: none;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            font-size: 3rem;
        }
        
        .pagination .page-link {
            border-radius: 10px;
            margin: 0 2px;
            border: none;
            color: #007bff;
            font-weight: 500;
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <!-- Header Section -->
        <div class="header-section">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="header-title">
                         Vehicle Management
                    </h1>
                    <p class="mb-0 opacity-75">Manage your car rental fleet efficiently</p>
                </div>
                <asp:Button ID="btnAddVehicles" runat="server" 
                    Text=" Add New Vehicle" 
                    CssClass="add-vehicle-btn" 
                    OnClick="btnAddNewVehicle_Click" />
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h5 class="mb-4"> Search & Filter Vehicles</h5>
            <div class="search-controls">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Search by Make/Model:</label>
                        <asp:TextBox ID="txtSearchVehicle" runat="server" 
                            CssClass="form-control" 
                            placeholder="Enter make or model..." />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold">Status:</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select">
                            <asp:ListItem Value="All" Text="All Status" />
                            <asp:ListItem Value="Available" Text="Available" />
                            <asp:ListItem Value="Rented" Text="Rented" />
                            <asp:ListItem Value="Maintenance" Text="Maintenance" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold">Make:</label>
                        <asp:DropDownList ID="ddlMakeFilter" runat="server" 
                            CssClass="form-select" 
                            DataTextField="MakeName" 
                            DataValueField="MakeID">
                            <asp:ListItem Value="0" Text="All Makes" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Price Range (Rs):</label>
                        <div class="d-flex">
                            <asp:TextBox ID="txtMinPrice" runat="server" 
                                CssClass="form-control me-2" 
                                placeholder="Min" 
                                TextMode="Number" />
                            <asp:TextBox ID="txtMaxPrice" runat="server" 
                                CssClass="form-control" 
                                placeholder="Max" 
                                TextMode="Number" />
                        </div>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnSearch" runat="server" 
                            Text="Search" 
                            CssClass="search-btn me-2" 
                            OnClick="btnSearch_Click" />
                        <asp:Button ID="btnClear" runat="server" 
                            Text="Clear" 
                            CssClass="clear-btn" 
                            OnClick="btnClear_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Vehicles Grid -->
        <div class="row" id="vehiclesContainer">
            <asp:Repeater ID="rptVehicles" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card vehicle-card h-100">
                            <div class="position-relative">
                                <img src='<%# GetVehicleImagePath(Eval("VehicleID")) %>' 
                                     class="vehicle-image" 
                                     alt='<%# Eval("MakeName") & " " & Eval("ModelName") %>'
                                     onerror="this.src='images/no-vehicle-image.jpg';" />
                                <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title"><%# Eval("MakeName") %> <%# Eval("ModelName") %></h6>
                                <div class="vehicle-details flex-grow-1">
                                    <div class="row g-1">
                                        <div class="col-6">
                                            <small>📅 <%# Eval("Year") %></small>
                                        </div>
                                        <div class="col-6">
                                            <small>🎨 <%# Eval("Color") %></small>
                                        </div>
                                        <div class="col-6">
                                            <small>⚙️ <%# Eval("Transmission") %></small>
                                        </div>
                                        <div class="col-6">
                                            <small>👥 <%# Eval("SeatingCapacity") %> seats</small>
                                        </div>
                                        <div class="col-12">
                                            <small>⛽ <%# Eval("FuelType") %></small>
                                        </div>
                                    </div>
                                </div>
                                <div class="price-display mt-3 mb-3">
                                    Rs <%# Eval("PricePerDay", "{0:N0}") %>/day
                                </div>
                                <div class="action-buttons mt-auto">
                                    <asp:Button ID="btnToggleStatus" runat="server" 
                                        Text='<%# GetToggleButtonText(Eval("Status")) %>'
                                        CssClass='<%# GetToggleButtonClass(Eval("Status")) %>'
                                        CommandArgument='<%# Eval("VehicleID") & "," & Eval("Status") %>'
                                        OnCommand="btnToggleStatus_Command"
                                        OnClientClick="return confirm('Are you sure you want to change this vehicle status?');" />
                                    <asp:Button ID="btnDelete" runat="server" 
                                        Text="Delete" 
                                        CssClass="btn btn-danger btn-sm" 
                                        CommandArgument='<%# Eval("VehicleID") %>'
                                        OnCommand="btnDelete_Command"
                                        OnClientClick="return confirm('Are you sure you want to delete this vehicle? This action cannot be undone.');" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- No Vehicles Message -->
        <asp:Panel ID="pnlNoVehicles" runat="server" Visible="false">
            <div class="no-vehicles-alert">
                
                <h4 class="text-primary mt-3">No vehicles found</h4>
                <p class="text-muted mb-4">Try adjusting your search criteria or add a new vehicle to get started.</p>
                <asp:Button ID="btnAddFirstVehicle" runat="server" 
                    Text="➕ Add Your First Vehicle" 
                    CssClass="add-vehicle-btn" 
                    OnClick="btnAddNewVehicle_Click" />
            </div>
        </asp:Panel>

        <!-- Pagination -->
        <asp:Panel ID="pnlPagination" runat="server" CssClass="d-flex justify-content-center mt-5">
            <nav>
                <ul class="pagination pagination-lg">
                    <asp:Repeater ID="rptPagination" runat="server">
                        <ItemTemplate>
                            <li class='page-item <%# IIf(Eval("IsCurrentPage"), "active", "") %>'>
                                <asp:LinkButton ID="lnkPage" runat="server" 
                                    CssClass="page-link" 
                                    Text='<%# Eval("PageNumber") %>'
                                    CommandArgument='<%# Eval("PageNumber") %>'
                                    OnCommand="lnkPage_Command" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </nav>
        </asp:Panel>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" 
            CssClass="position-fixed alert alert-dismissible fade show" 
            style="top: 100px; right: 20px; z-index: 1050; border-radius: 15px;">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>
    </div>
</asp:Content>