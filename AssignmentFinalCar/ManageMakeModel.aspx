<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="ManageMakeModel.aspx.vb" Inherits="AssignmentFinalCar.WebForm13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Main container styling for the management sections */
        .management-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* Header styling for each section */
        .section-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            margin: -30px -30px 20px -30px;
            font-size: 1.25rem;
            font-weight: 600;
        }

        /* Form section styling with blue left border */
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid #007bff;
        }

        /* Action buttons styling */
        .btn-action {
            margin: 0 5px;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.9rem;
        }

        /* Table container with rounded corners and shadow */
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* Table header styling */
        .table thead th {
            background: #007bff;
            color: white;
            border: none;
            font-weight: 600;
            padding: 15px 10px;
        }

        /* Table row hover effect */
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }

        /* Table cell styling */
        .table tbody td {
            padding: 12px 10px;
            vertical-align: middle;
        }

        /* Search section styling with light blue background */
        .search-section {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* Alert messages styling */
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* Form controls styling */
        .form-control, .form-select {
            border-radius: 6px;
            border: 2px solid #e9ecef;
            padding: 10px 15px;
        }

        /* Form controls focus effect */
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        /* Button styling */
        .btn {
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 500;
        }

        /* Tab navigation styling */
        .nav-tabs .nav-link {
            border-radius: 8px 8px 0 0;
            margin-right: 5px;
            font-weight: 500;
            background-color: #e9ecef;
            color: #495057;
            border: 2px solid #dee2e6;
            transition: all 0.3s ease;
        }

        /* Tab hover effect */
        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
            color: #007bff;
            border-color: #007bff;
        }

        /* Active tab styling */
        .nav-tabs .nav-link.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        /* Active tab hover effect */
        .nav-tabs .nav-link.active:hover {
            background-color: #0056b3;
            color: white;
            border-color: #0056b3;
        }

        /* Tab content area styling */
        .tab-content {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 0 8px 8px 8px;
            padding: 30px;
        }

        /* Status badge base styling */
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        /* Active status badge (green) */
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        /* Inactive status badge (red) */
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        /* Custom styling for deactivate button to show red color instead of disappearing */
        .btn-deactivate {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
        }

        .btn-deactivate:hover {
            background-color: #c82333;
            border-color: #bd2130;
            color: white;
        }

        /* Custom styling for activate button to show green color */
        .btn-activate {
            background-color: #28a745;
            border-color: #28a745;
            color: white;
        }

        .btn-activate:hover {
            background-color: #218838;
            border-color: #1e7e34;
            color: white;
        }
    </style>
</asp:Content>

<%-- Main content section of the page --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                <div class="management-container">
                    <%-- Page title with icon --%>
                    <div class="section-header">
                        <i class="fas fa-car-side"></i> Manage Car Makes & Models
                    </div>

                    <%-- Message panel for displaying success/error messages --%>
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert">
                        <asp:Label ID="lblMessage" runat="server" />
                    </asp:Panel>

                    <%-- Tab navigation for switching between Makes and Models management --%>
                    <ul class="nav nav-tabs" id="manageTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="makes-tab" data-bs-toggle="tab" data-bs-target="#makes" type="button" role="tab">
                                <i class="fas fa-industry"></i> Manage Makes
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="models-tab" data-bs-toggle="tab" data-bs-target="#models" type="button" role="tab">
                                <i class="fas fa-car"></i> Manage Models
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="manageTabsContent">
                        <%-- MAKES TAB: Contains all functionality for managing car makes --%>
                        <div class="tab-pane fade show active" id="makes" role="tabpanel">
                            
                            <%-- Form for adding/editing car makes --%>
                            <div class="form-section">
                                <h5><i class="fas fa-plus-circle"></i> Add/Edit Car Make</h5>
                                <div class="row">
                                    <%-- Make Name input (required field) --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Make Name *</asp:Label>
                                        <asp:TextBox ID="txtMakeName" runat="server" CssClass="form-control" placeholder="Enter make name" />
                                        <%-- Validation control to ensure make name is entered --%>
                                        <asp:RequiredFieldValidator ID="rfvMakeName" runat="server" 
                                            ControlToValidate="txtMakeName" 
                                            ErrorMessage="Make name is required" 
                                            ValidationGroup="MakeGroup" 
                                            ForeColor="Red" />
                                    </div>
                                    <%-- Country input (optional field) --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Country</asp:Label>
                                        <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" placeholder="Enter country" />
                                    </div>
                                    <%-- Description input (optional field) --%>
                                    <div class="col-md-4">
                                        <asp:Label runat="server" CssClass="form-label">Description</asp:Label>
                                        <asp:TextBox ID="txtMakeDescription" runat="server" CssClass="form-control" placeholder="Enter description" />
                                    </div>
                                    <%-- Action buttons for make operations --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">&nbsp;</asp:Label>
                                        <div>
                                            <%-- Add button (visible by default) --%>
                                            <asp:Button ID="btnAddMake" runat="server" Text="Add Make" 
                                                CssClass="btn btn-success btn-action" 
                                                OnClick="btnAddMake_Click" 
                                                ValidationGroup="MakeGroup" />
                                            <%-- Update button (visible only during edit mode) --%>
                                            <asp:Button ID="btnUpdateMake" runat="server" Text="Update" 
                                                CssClass="btn btn-warning btn-action" 
                                                OnClick="btnUpdateMake_Click" 
                                                ValidationGroup="MakeGroup" 
                                                Visible="false" />
                                            <%-- Cancel button (visible only during edit mode) --%>
                                            <asp:Button ID="btnCancelMake" runat="server" Text="Cancel" 
                                                CssClass="btn btn-secondary btn-action" 
                                                OnClick="btnCancelMake_Click" 
                                                Visible="false" 
                                                CausesValidation="false" />
                                        </div>
                                    </div>
                                </div>
                                <%-- Hidden field to store the ID of make being edited --%>
                                <asp:HiddenField ID="hfSelectedMakeID" runat="server" />
                            </div>

                            <%-- Search section for filtering makes --%>
                            <div class="search-section">
                                <div class="row align-items-end">
                                    <div class="col-md-4">
                                        <asp:Label runat="server" CssClass="form-label">Search Makes</asp:Label>
                                        <asp:TextBox ID="txtSearchMake" runat="server" CssClass="form-control" placeholder="Search by make name or country" />
                                    </div>
                                    <div class="col-md-2">
                                        <%-- Search button to filter results --%>
                                        <asp:Button ID="btnSearchMake" runat="server" Text="Search" 
                                            CssClass="btn btn-primary" 
                                            OnClick="btnSearchMake_Click" 
                                            CausesValidation="false" />
                                        <%-- Reset button to clear search and show all makes --%>
                                        <asp:Button ID="btnResetMake" runat="server" Text="Reset" 
                                            CssClass="btn btn-outline-secondary" 
                                            OnClick="btnResetMake_Click" 
                                            CausesValidation="false" />
                                    </div>
                                </div>
                            </div>

                            <%-- GridView to display all makes in tabular format --%>
                            <div class="table-responsive">
                                <asp:GridView ID="gvMakes" runat="server" 
                                    CssClass="table table-striped table-hover" 
                                    AutoGenerateColumns="false" 
                                    AllowPaging="true" 
                                    PageSize="10" 
                                    OnPageIndexChanging="gvMakes_PageIndexChanging"
                                    OnRowCommand="gvMakes_RowCommand"
                                    EmptyDataText="No makes found">
                                    <Columns>
                                        <%-- Hidden ID column for internal use --%>
                                        <asp:BoundField DataField="MakeID" HeaderText="ID" Visible="false" />
                                        <%-- Make name column --%>
                                        <asp:BoundField DataField="MakeName" HeaderText="Make Name" />
                                        <%-- Country column --%>
                                        <asp:BoundField DataField="Country" HeaderText="Country" />
                                        <%-- Description column --%>
                                        <asp:BoundField DataField="Description" HeaderText="Description" />
                                        <%-- Status column with conditional formatting --%>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <%-- Show status badge with color based on active/inactive state --%>
                                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-badge status-active", "status-badge status-inactive") %>'>
                                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Inactive") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%-- Created date column with formatting --%>
                                        <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" DataFormatString="{0:dd/MM/yyyy}" />
                                        <%-- Actions column with Edit and Toggle Status buttons --%>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <%-- Edit button to load make data into form --%>
                                                <asp:Button ID="btnEdit" runat="server" Text="Edit" 
                                                    CssClass="btn btn-sm btn-outline-primary btn-action" 
                                                    CommandName="EditMake" 
                                                    CommandArgument='<%# Eval("MakeID") %>' 
                                                    CausesValidation="false" />
                                                <%-- Toggle button with solid colors instead of outline styles --%>
                                                <asp:Button ID="btnToggleStatus" runat="server" 
                                                    Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Deactivate", "Activate") %>'
                                                    CssClass='<%# If(Convert.ToBoolean(Eval("IsActive")), "btn btn-sm btn-deactivate btn-action", "btn btn-sm btn-activate btn-action") %>'
                                                    CommandName="ToggleStatus" 
                                                    CommandArgument='<%# Eval("MakeID") %>' 
                                                    CausesValidation="false"
                                                    OnClientClick="return confirm('Are you sure you want to change the status of this make?');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                        </div>

                        <%-- MODELS TAB: Contains all functionality for managing car models --%>
                        <div class="tab-pane fade" id="models" role="tabpanel">
                            
                            <%-- Form for adding/editing car models --%>
                            <div class="form-section">
                                <h5><i class="fas fa-plus-circle"></i> Add/Edit Car Model</h5>
                                <div class="row">
                                    <%-- Make selection dropdown (required) --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Select Make *</asp:Label>
                                        <asp:DropDownList ID="ddlMake" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="" Text="-- Select Make --" />
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvMake" runat="server" 
                                            ControlToValidate="ddlMake" 
                                            ErrorMessage="Please select a make" 
                                            ValidationGroup="ModelGroup" 
                                            ForeColor="Red" />
                                    </div>
                                    <%-- Model name input (required) --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Model Name *</asp:Label>
                                        <asp:TextBox ID="txtModelName" runat="server" CssClass="form-control" placeholder="Enter model name" />
                                        <asp:RequiredFieldValidator ID="rfvModelName" runat="server" 
                                            ControlToValidate="txtModelName" 
                                            ErrorMessage="Model name is required" 
                                            ValidationGroup="ModelGroup" 
                                            ForeColor="Red" />
                                    </div>
                                    <%-- Year input (optional, numeric) --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">Year</asp:Label>
                                        <asp:TextBox ID="txtYear" runat="server" CssClass="form-control" placeholder="YYYY" TextMode="Number" />
                                    </div>
                                    <%-- Fuel type dropdown (optional) --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">Fuel Type</asp:Label>
                                        <asp:DropDownList ID="ddlFuelType" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="" Text="-- Select --" />
                                            <asp:ListItem Value="Petrol" Text="Petrol" />
                                            <asp:ListItem Value="Diesel" Text="Diesel" />
                                            <asp:ListItem Value="Electric" Text="Electric" />
                                            <asp:ListItem Value="Hybrid" Text="Hybrid" />
                                        </asp:DropDownList>
                                    </div>
                                    <%-- Transmission dropdown (optional) --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">Transmission</asp:Label>
                                        <asp:DropDownList ID="ddlTransmission" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="" Text="-- Select --" />
                                            <asp:ListItem Value="Manual" Text="Manual" />
                                            <asp:ListItem Value="Automatic" Text="Automatic" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <%-- Second row of model form --%>
                                <div class="row mt-3">
                                    <%-- Seating capacity input (optional, numeric) --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">Seating Capacity</asp:Label>
                                        <asp:TextBox ID="txtSeatingCapacity" runat="server" CssClass="form-control" placeholder="e.g. 5" TextMode="Number" min="1" max="50" />
                                    </div>
                                    <%-- Description input (optional) --%>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" CssClass="form-label">Description</asp:Label>
                                        <asp:TextBox ID="txtModelDescription" runat="server" CssClass="form-control" placeholder="Enter model description" />
                                    </div>
                                    <%-- Action buttons for model management --%>
                                    <div class="col-md-4">
                                        <asp:Label runat="server" CssClass="form-label">&nbsp;</asp:Label>
                                        <div>
                                            <%-- Add button (default visible) --%>
                                            <asp:Button ID="btnAddModel" runat="server" Text="Add Model" 
                                                CssClass="btn btn-success btn-action" 
                                                OnClick="btnAddModel_Click" 
                                                ValidationGroup="ModelGroup" />
                                            <%-- Update button (visible only in edit mode) --%>
                                            <asp:Button ID="btnUpdateModel" runat="server" Text="Update" 
                                                CssClass="btn btn-warning btn-action" 
                                                OnClick="btnUpdateModel_Click" 
                                                ValidationGroup="ModelGroup" 
                                                Visible="false" />
                                            <%-- Cancel button (visible only in edit mode) --%>
                                            <asp:Button ID="btnCancelModel" runat="server" Text="Cancel" 
                                                CssClass="btn btn-secondary btn-action" 
                                                OnClick="btnCancelModel_Click" 
                                                Visible="false" 
                                                CausesValidation="false" />
                                        </div>
                                    </div>
                                </div>
                                <%-- Hidden field to store model ID during editing --%>
                                <asp:HiddenField ID="hfSelectedModelID" runat="server" />
                            </div>

                            <%-- Search section for filtering models --%>
                            <div class="search-section">
                                <div class="row align-items-end">
                                    <%-- Filter by make dropdown --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Search by Make</asp:Label>
                                        <asp:DropDownList ID="ddlSearchMake" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="" Text="-- All Makes --" />
                                        </asp:DropDownList>
                                    </div>
                                    <%-- Filter by model name textbox --%>
                                    <div class="col-md-3">
                                        <asp:Label runat="server" CssClass="form-label">Search Models</asp:Label>
                                        <asp:TextBox ID="txtSearchModel" runat="server" CssClass="form-control" placeholder="Search by model name" />
                                    </div>
                                    <%-- Filter by fuel type dropdown --%>
                                    <div class="col-md-2">
                                        <asp:Label runat="server" CssClass="form-label">Fuel Type</asp:Label>
                                        <asp:DropDownList ID="ddlSearchFuel" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="" Text="-- All --" />
                                            <asp:ListItem Value="Petrol" Text="Petrol" />
                                            <asp:ListItem Value="Diesel" Text="Diesel" />
                                            <asp:ListItem Value="Electric" Text="Electric" />
                                            <asp:ListItem Value="Hybrid" Text="Hybrid" />
                                        </asp:DropDownList>
                                    </div>
                                    <%-- Search and reset buttons --%>
                                    <div class="col-md-2">
                                        <asp:Button ID="btnSearchModel" runat="server" Text="Search" 
                                            CssClass="btn btn-primary" 
                                            OnClick="btnSearchModel_Click" 
                                            CausesValidation="false" />
                                        <asp:Button ID="btnResetModel" runat="server" Text="Reset" 
                                            CssClass="btn btn-outline-secondary" 
                                            OnClick="btnResetModel_Click" 
                                            CausesValidation="false" />
                                    </div>
                                </div>
                            </div>

                            <%-- GridView to display all models in tabular format --%>
                            <div class="table-responsive">
                                <asp:GridView ID="gvModels" runat="server" 
                                    CssClass="table table-striped table-hover" 
                                    AutoGenerateColumns="false" 
                                    AllowPaging="true" 
                                    PageSize="10" 
                                    OnPageIndexChanging="gvModels_PageIndexChanging"
                                    OnRowCommand="gvModels_RowCommand"
                                    EmptyDataText="No models found">
                                    <Columns>
                                        <%-- Hidden model ID column --%>
                                        <asp:BoundField DataField="ModelID" HeaderText="ID" Visible="false" />
                                        <%-- Make name column (from joined table) --%>
                                        <asp:BoundField DataField="MakeName" HeaderText="Make" />
                                        <%-- Model name column --%>
                                        <asp:BoundField DataField="ModelName" HeaderText="Model" />
                                        <%-- Year column --%>
                                        <asp:BoundField DataField="Year" HeaderText="Year" />
                                        <%-- Fuel type column --%>
                                        <asp:BoundField DataField="FuelType" HeaderText="Fuel" />
                                        <%-- Transmission column --%>
                                        <asp:BoundField DataField="Transmission" HeaderText="Transmission" />
                                        <%-- Seating capacity column --%>
                                        <asp:BoundField DataField="SeatingCapacity" HeaderText="Seats" />
                                        <%-- Status column with conditional formatting --%>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-badge status-active", "status-badge status-inactive") %>'>
                                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Inactive") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%-- Created date column --%>
                                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:dd/MM/yyyy}" />
                                        <%-- Actions column with Edit and Toggle buttons --%>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <%-- Edit button to load model into form --%>
                                                <asp:Button ID="btnEdit" runat="server" Text="Edit" 
                                                    CssClass="btn btn-sm btn-outline-primary btn-action" 
                                                    CommandName="EditModel" 
                                                    CommandArgument='<%# Eval("ModelID") %>' 
                                                    CausesValidation="false" />
                                                <%-- Toggle status button with solid colors instead of outline styles --%>
                                                <asp:Button ID="btnToggleStatus" runat="server" 
                                                    Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Deactivate", "Activate") %>'
                                                    CssClass='<%# If(Convert.ToBoolean(Eval("IsActive")), "btn btn-sm btn-deactivate btn-action", "btn btn-sm btn-activate btn-action") %>'
                                                    CommandName="ToggleStatus" 
                                                    CommandArgument='<%# Eval("ModelID") %>' 
                                                    CausesValidation="false"
                                                    OnClientClick="return confirm('Are you sure you want to change the status of this model?');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- JavaScript for maintaining active tab after postback --%>
    <script>
        // Maintain active tab after postback
        document.addEventListener('DOMContentLoaded', function () {
            // Get the active tab from server-side session variable
            var activeTab = '<%= Session("ActiveTab") %>';
            if (activeTab) {
                // Show the correct tab if specified
                var tabTrigger = new bootstrap.Tab(document.querySelector('#' + activeTab + '-tab'));
                tabTrigger.show();
            }
        });

        // Store active tab on tab change (for future reference if needed)
        document.addEventListener('shown.bs.tab', function (event) {
            // Get the ID of the newly activated tab
            var activeTabId = event.target.id.replace('-tab', '');
            // You can set this in code-behind if needed for server-side processing
        });
    </script>
</asp:Content>