<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/AdminMaster.Master" CodeBehind="AddVehicles.aspx.vb" Inherits="AssignmentFinalCar.WebForm7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .form-container {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
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
        
        .form-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border-left: 4px solid #007bff;
        }
        
        .section-title {
            color: #007bff;
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 1.2rem;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.3);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .error-text {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: block;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .feature-checkbox {
            display: flex;
            align-items: center;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }
        
        .feature-checkbox:hover {
            background: #e9ecef;
        }
        
        .feature-checkbox input[type="checkbox"] {
            margin-right: 10px;
            transform: scale(1.2);
        }
        
        .image-upload-area {
            border: 2px dashed #007bff;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            background: #f8f9ff;
            transition: all 0.3s ease;
        }
        
        .image-upload-area:hover {
            background: #e7f3ff;
        }
        
        .required-field {
            color: #dc3545;
        }
        
        .btn-group-custom {
            gap: 15px;
            flex-wrap: wrap;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <!-- Header Section -->
        <div class="header-section">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="header-title"> Add New Vehicle</h1>
                    <p class="mb-0 opacity-75">Add a new vehicle to your rental fleet</p>
                </div>
                <asp:Button ID="btnBackToList" runat="server" 
                    Text="← Back to Vehicle List" 
                    CssClass="btn btn-secondary" 
                    OnClick="btnBackToList_Click" />
            </div>
        </div>

        <!-- Vehicle Basic Information -->
        <div class="form-section">
            <h4 class="section-title"> Basic Information</h4>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Make <span class="required-field">*</span></label>
                    <asp:DropDownList ID="ddlMake" runat="server" 
                        CssClass="form-select" 
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlMake_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:Label ID="lblMakeError" runat="server" CssClass="error-text" Visible="false" />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Model <span class="required-field">*</span></label>
                    <asp:DropDownList ID="ddlModel" runat="server" CssClass="form-select">
                        <asp:ListItem Value="0" Text="Select Model" />
                    </asp:DropDownList>
                    <asp:Label ID="lblModelError" runat="server" CssClass="error-text" Visible="false" />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Color <span class="required-field">*</span></label>
                    <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" placeholder="Enter vehicle color" />
                    <asp:Label ID="lblColorError" runat="server" CssClass="error-text" Visible="false" />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">License Plate <span class="required-field">*</span></label>
                    <asp:TextBox ID="txtLicensePlate" runat="server" CssClass="form-control" placeholder="Enter license plate" />
                    <asp:Label ID="lblLicensePlateError" runat="server" CssClass="error-text" Visible="false" />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Mileage (km)</label>
                    <asp:TextBox ID="txtMileage" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter current mileage" />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Price Per Day (Rs) <span class="required-field">*</span></label>
                    <asp:TextBox ID="txtPricePerDay" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter daily rental price" />
                    <asp:Label ID="lblPriceError" runat="server" CssClass="error-text" Visible="false" />
                </div>
            </div>
        </div>

        <!-- Vehicle Status & Location -->
        <div class="form-section">
            <h4 class="section-title"> Status & Location</h4>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Value="Available" Text="Available" Selected="true" />
                        <asp:ListItem Value="Maintenance" Text="Maintenance" />
                        <asp:ListItem Value="Inactive" Text="Inactive" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Location</label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="Current location of vehicle" />
                </div>
            </div>
        </div>

        <!-- Features Section -->
        <div class="form-section">
            <h4 class="section-title">⭐ Features</h4>
            <div class="features-grid">
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkAirConditioning" runat="server" Text="Air Conditioning" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkBluetooth" runat="server" Text="Bluetooth" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkGPS" runat="server" Text="GPS Navigation" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chk4WD" runat="server" Text="4WD / AWD" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkLeatherSeats" runat="server" Text="Leather Seats" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkSunroof" runat="server" Text="Sunroof" />
                </div>
                <div class="feature-checkbox">
                    <asp:CheckBox ID="chkPremiumSound" runat="server" Text="Premium Sound System" />
                </div>
            </div>
            <div class="mt-3">
                <label class="form-label fw-semibold">Additional Features</label>
                <asp:TextBox ID="txtCustomFeatures" runat="server" CssClass="form-control" 
                    placeholder="Enter any additional features (comma separated)" />
            </div>
        </div>

        <!-- Image Upload Section -->
        <div class="form-section">
            <h4 class="section-title">📸 Vehicle Image</h4>
            <div class="image-upload-area">
                <i class="fas fa-cloud-upload-alt fa-3x text-primary mb-3"></i>
                <h5>Upload Vehicle Image</h5>
                <p class="text-muted">Select an image file (JPG, PNG, GIF) - Max 2MB</p>
                <asp:FileUpload ID="fuVehicleImage" runat="server" CssClass="form-control mt-3" accept="image/*" />
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="form-section">
            <div class="d-flex justify-content-center btn-group-custom">
                <asp:Button ID="btnSave" runat="server" 
                    Text=" Save Vehicle" 
                    CssClass="btn btn-primary btn-lg" 
                    OnClick="btnSave_Click" />
                <asp:Button ID="btnSaveAndAddAnother" runat="server" 
                    Text=" Save & Add Another" 
                    CssClass="btn btn-success btn-lg" 
                    OnClick="btnSaveAndAddAnother_Click" />
                <asp:Button ID="btnCancel" runat="server" 
                    Text=" Cancel" 
                    CssClass="btn btn-secondary btn-lg" 
                    OnClick="btnCancel_Click" 
                    OnClientClick="return confirm('Are you sure you want to cancel? Any unsaved changes will be lost.');" />
            </div>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" 
            CssClass="position-fixed alert alert-dismissible fade show" 
            style="top: 100px; right: 20px; z-index: 1050; border-radius: 15px; min-width: 300px;">
            <asp:Label ID="lblMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>
    </div>

    <!-- Bootstrap JS for alert dismissal -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>