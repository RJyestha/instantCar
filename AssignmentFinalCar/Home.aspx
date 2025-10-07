<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/PublicMaster.Master" CodeBehind="Home.aspx.vb" Inherits="AssignmentFinalCar.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
        /* ==================== ANIMATION KEYFRAMES ==================== */
        /* Fade in from bottom animation */
        @keyframes fadeInUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        /* Slide in from left animation */
        @keyframes slideInLeft {
            from { 
                opacity: 0; 
                transform: translateX(-50px); 
            }
            to { 
                opacity: 1; 
                transform: translateX(0); 
            }
        }
        
        /* Slide in from right animation */
        @keyframes slideInRight {
            from { 
                opacity: 0; 
                transform: translateX(50px); 
            }
            to { 
                opacity: 1; 
                transform: translateX(0); 
            }
        }
        
        /* Floating effect animation */
        @keyframes float {
            0%, 100% { 
                transform: translateY(0px); 
            }
            50% { 
                transform: translateY(-10px); 
            }
        }
        
        /* Glowing effect animation */
        @keyframes glow {
            0%, 100% { 
                box-shadow: 0 0 20px rgba(0,123,255,0.3); 
            }
            50% { 
                box-shadow: 0 0 30px rgba(0,123,255,0.6); 
            }
        }

        /* ==================== HERO SECTION STYLING ==================== */
        /* Main hero banner section */
        .hero-section {
            position: relative;
            color: white;
            padding: 200px 0;
            text-align: center;
            overflow: hidden;
            min-height: 600px;
        } 
        
        /* Background image for hero section */
        .hero-bg-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }
        
        /* Dark overlay on hero image */
        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 2;
        }
        
        /* Hero content container */
        .hero-content {
           position: relative; 
           z-index: 3;
           animation: fadeInUp 1s ease-out;
        }
        
        /* Main hero title styling */
        .hero-title {
           font-size: 4rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            animation: slideInLeft 1s ease-out 0.3s both;
        }
        
        /* Hero subtitle styling */
        .hero-subtitle {
           font-size: 1.5rem;
           margin-bottom: 30px;
           animation: slideInRight 1s ease-out 0.5s both;
        }
        
        /* Hero buttons container */
        .hero-buttons {
            animation: fadeInUp 1s ease-out 0.7s both;
        }

        /* ==================== SEARCH CARD STYLING ==================== */
        /* Main search form card */
        .search-card {
            background: rgba(255,255,255,0.98);
            border-radius: 20px;
            padding: 40px;
            margin-top: -80px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            position: relative;
            z-index: 3;
            backdrop-filter: blur(10px);
            animation: glow 3s ease-in-out infinite;
        }
        
        /* Search card border effect */
        .search-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #007bff, #6c757d, #007bff);
            border-radius: 22px;
            z-index: -1;
            opacity: 0.7;
        }

        /* ==================== FEATURE SECTION STYLING ==================== */
        /* Feature icons styling */
        .feature-icon {
            font-size: 4rem;
            color: #007bff;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
            transition: all 0.3s ease;
        }
        
        /* Feature box container */
        .feature-box {
            padding: 30px;
            border-radius: 15px;
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out;
        }
        
        /* Feature box hover effects */
        .feature-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,123,255,0.2);
        }
        
        .feature-box:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
            color: #0056b3;
        }

        /* ==================== VEHICLE CARD STYLING ==================== */
        /* Vehicle display cards */
        .vehicle-card {
            transition: all 0.4s ease;
            border: none;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
            position: relative;
            animation: fadeInUp 0.8s ease-out;
        }
        
        /* Vehicle card hover effects */
        .vehicle-card:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0,123,255,0.2);
        }

        /* Vehicle image sizing */
        .vehicle-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }

        /* Featured vehicle image sizing */
        .featured-vehicle-image {
            height: 250px;
            width: 100%;
            object-fit: cover;
        }

        /* ==================== NEWS CARD STYLING ==================== */
        /* News article cards */
        .news-card {
            height: 100%;
            border: none;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out;
        }
        
        /* News card hover effects */
        .news-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        /* News image styling */
        .news-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        /* News image hover effect */
        .news-card:hover .news-image {
            transform: scale(1.05);
        }

        /* ==================== FEEDBACK SECTION STYLING ==================== */
        /* Customer feedback section background */
        .feedback-section {
            background: linear-gradient(135deg, #007bff 0%, #6c757d 100%);
            padding: 80px 0;
            color: white;
        }
        
        /* Individual feedback cards */
        .feedback-card {
            background: rgba(255,255,255,0.95);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out;
            color: #3e2723;
            border-left: 4px solid #007bff;
        }
        
        /* Feedback card hover effects */
        .feedback-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
        }
        
        /* Feedback text styling */
        .feedback-text {
            font-style: italic;
            margin-bottom: 15px;
            line-height: 1.6;
        }
        
        /* Feedback author styling */
        .feedback-author {
            font-weight: bold;
            color: #007bff;
            text-align: right;
        }
        
        /* Star rating styling */
        .feedback-rating {
            color: #007bff;
            margin-bottom: 10px;
        }

        /* ==================== BUTTON STYLING ==================== */
        /* Animated button effects */
        .btn-animated {
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .btn-animated:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        /* ==================== SECTION TITLE STYLING ==================== */
        /* Section heading styling */
        .section-title {
            position: relative;
            margin-bottom: 50px;
            animation: fadeInUp 0.8s ease-out;
        }
        
        /* Decorative line under section titles */
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #007bff, #6c757d);
            border-radius: 2px;
        }

        /* ==================== SCROLL ANIMATIONS ==================== */
        /* Elements that animate when scrolled into view */
        .animate-on-scroll {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease;
        }
        
        .animate-on-scroll.animated {
            opacity: 1;
            transform: translateY(0);
        }

        /* ==================== RESPONSIVE DESIGN ==================== */
        /* Mobile and tablet adjustments */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .search-card {
                padding: 20px;
                margin-top: -40px;
            }
            
            .feature-icon {
                font-size: 3rem;
            }
            
            .feedback-card {
                padding: 20px;
            }
        }
    </style>
</asp:Content>

<%-- Main content section - contains all page content --%>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- ==================== HERO BANNER SECTION ==================== --%>
    <section class="hero-section">
        <%-- Background image for hero section --%>
        <asp:Image ID="imgHeroBackground" runat="server" 
                   ImageUrl="~/image/homepic1.jpg" 
                   CssClass="hero-bg-image"
                   AlternateText="CarInstant Hero Image" />
        
        <%-- Dark overlay for better text readability --%>
        <div class="hero-overlay"></div>
        
        <%-- Hero content container --%>
        <div class="container">
            <div class="hero-content">
                <%-- Main page title --%>
                <h1 class="hero-title">Welcome to CarInstant</h1>
                
                <%-- Page subtitle --%>
                <p class="hero-subtitle">Your trusted car rental service in Mauritius</p>
                
                <%-- Call-to-action buttons --%>
                <div class="hero-buttons">
                    <%-- Register button with navigation --%>
                    <asp:HyperLink ID="lnkRegister" runat="server" 
                                   NavigateUrl="~/Register.aspx" 
                                   CssClass="btn btn-light btn-lg btn-animated me-3">
                        <i class="fas fa-user-plus me-2"></i>Register
                    </asp:HyperLink>
                    
                    <%-- Browse vehicles button --%>
                    <asp:HyperLink ID="lnkBrowseVehicles" runat="server" 
                                   NavigateUrl="~/Vehicles.aspx" 
                                   CssClass="btn btn-outline-light btn-lg btn-animated">
                        <i class="fas fa-car me-2"></i>Browse Vehicles
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </section>

    <%-- ==================== VEHICLE SEARCH SECTION ==================== --%>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <%-- Search form card --%>
                <div class="search-card animate-on-scroll">
                    <%-- Search form title --%>
                    <h3 class="text-center mb-4 text-dark">
                        <i class="fas fa-search me-2"></i>Find Your Perfect Vehicle
                    </h3>
                    
                    <%-- Search form fields --%>
                    <div class="row g-3">
                        <%-- Pickup location dropdown --%>
                        <div class="col-md-3">
                            <asp:Label ID="lblLocation" runat="server" 
                                       Text="Pickup Location" 
                                       CssClass="form-label">
                                <i class="fas fa-map-marker-alt text-primary me-1"></i>Pickup Location
                            </asp:Label>
                            
                            <asp:DropDownList ID="ddlLocation" runat="server" 
                                              CssClass="form-select">
                                <asp:ListItem Value="">Select Location</asp:ListItem>
                                <asp:ListItem Value="Port Louis">Port Louis</asp:ListItem>
                                <asp:ListItem Value="Curepipe">Curepipe</asp:ListItem>
                                <asp:ListItem Value="Quatre Bornes">Quatre Bornes</asp:ListItem>
                                <asp:ListItem Value="Rose Hill">Rose Hill</asp:ListItem>
                                <asp:ListItem Value="Airport">Airport</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                        <%-- Pickup date field --%>
                        <div class="col-md-3">
                            <asp:Label ID="lblPickupDate" runat="server" 
                                       Text="Pickup Date" 
                                       CssClass="form-label">
                                <i class="fas fa-calendar-alt text-primary me-1"></i>Pickup Date
                            </asp:Label>
                            
                            <asp:TextBox ID="txtPickupDate" runat="server" 
                                         CssClass="form-control" 
                                         TextMode="Date">
                            </asp:TextBox>
                        </div>
                        
                        <%-- Return date field --%>
                        <div class="col-md-3">
                            <asp:Label ID="lblReturnDate" runat="server" 
                                       Text="Return Date" 
                                       CssClass="form-label">
                                <i class="fas fa-calendar-check text-primary me-1"></i>Return Date
                            </asp:Label>
                            
                            <asp:TextBox ID="txtReturnDate" runat="server" 
                                         CssClass="form-control" 
                                         TextMode="Date">
                            </asp:TextBox>
                        </div>
                        
                        <%-- Search button --%>
                        <div class="col-md-3">
                            <asp:Label ID="lblSearch" runat="server" 
                                       Text="&nbsp;" 
                                       CssClass="form-label">
                            </asp:Label>
                            
                            <asp:Button ID="btnSearch" runat="server" 
                                        Text="Search Vehicles" 
                                        CssClass="btn btn-primary w-100 btn-animated" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%-- ==================== SEARCH RESULTS SECTION ==================== --%>
    <%-- Panel that shows/hides search results --%>
    <asp:Panel ID="pnlSearchResults" runat="server" 
               Visible="false" 
               CssClass="container mt-4">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <hr />
                
                <%-- Search results header --%>
                <h5><i class="fas fa-car-side me-2"></i>Search Results</h5>
                
                <%-- Search results message --%>
                <asp:Label ID="lblSearchMessage" runat="server" 
                           CssClass="mb-3 d-block">
                </asp:Label>
                
                <%-- Search results repeater control --%>
                <asp:Repeater ID="rptSearchResults" runat="server">
                    <HeaderTemplate>
                        <div class="row">
                    </HeaderTemplate>
                    
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4 mb-3">
                            <div class="card vehicle-card">
                                <div class="position-relative">
                                    <%-- Vehicle image --%>
                                    <asp:Image ID="imgSearchVehicle" runat="server" 
                                               ImageUrl='<%# GetImageUrl(Eval("ImagePath")) %>' 
                                               CssClass="card-img-top vehicle-image" 
                                               AlternateText='<%# GetSafeString(Eval("MakeName"), "") & " " & GetSafeString(Eval("ModelName"), "") %>' />
                                    
                                    <%-- Availability badge --%>
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <span class="badge bg-success">Available</span>
                                    </div>
                                </div>
                                
                                <div class="card-body">
                                    <%-- Vehicle name --%>
                                    <h6 class="card-title">
                                        <%# GetSafeString(Eval("MakeName"), "Unknown") %> 
                                        <%# GetSafeString(Eval("ModelName"), "Model") %>
                                    </h6>
                                    
                                    <%-- Vehicle specifications --%>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <i class="fas fa-users"></i> <%# GetSafeInteger(Eval("SeatingCapacity"), 5) %> Seats |
                                            <i class="fas fa-cog"></i> <%# GetSafeString(Eval("Transmission"), "Manual") %>
                                        </small>
                                    </p>
                                    
                                    <%-- Price and action button --%>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong class="text-primary"><%# FormatPrice(Eval("PricePerDay")) %>/day</strong>
                                        
                                        <asp:HyperLink ID="lnkViewDetails" runat="server" 
                                                       NavigateUrl="~/Vehicles.aspx" 
                                                       CssClass="btn btn-outline-primary btn-sm btn-animated">
                                            View Details
                                        </asp:HyperLink>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
                
                <%-- View all vehicles button --%>
                <div class="text-center mt-3">
                    <asp:HyperLink ID="lnkViewAllVehicles" runat="server" 
                                   NavigateUrl="~/Vehicles.aspx" 
                                   CssClass="btn btn-primary btn-animated">
                        View All Vehicles
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </asp:Panel>

    <%-- ==================== FEATURES SECTION ==================== --%>
    <section class="py-5 mt-5">
        <div class="container">
            <%-- Features section title --%>
            <h2 class="text-center section-title">Why CarInstant?</h2>
            
            <div class="row">
                <%-- Feature 1: Fleet --%>
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-box animate-on-scroll">
                        <div class="feature-icon">
                            <i class="fas fa-car"></i>
                        </div>
                        <h4>Fleet</h4>
                        <p class="text-muted">Choose from our extensive collection of well-maintained vehicles from top brands.</p>
                    </div>
                </div>
                
                <%-- Feature 2: Insurance --%>
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-box animate-on-scroll">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h4>Fully Insured</h4>
                        <p class="text-muted">All our vehicles come with comprehensive insurance coverage for your peace of mind.</p>
                    </div>
                </div>
                
                <%-- Feature 3: Support --%>
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-box animate-on-scroll">
                        <div class="feature-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h4>24/7 Support</h4>
                        <p class="text-muted">Our customer support team is available round the clock to assist you.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- ==================== CUSTOMER FEEDBACK SECTION ==================== --%>
    <section class="feedback-section">
        <div class="container">
            <%-- Feedback section title --%>
            <h2 class="text-center mb-5" style="color: #f5f5dc;">Customer Feedback</h2>
            <p class="text-center mb-5" style="color: #f5f5dc;">Below are some successful reviews of our valued customers:</p>
            
            <div class="row">
                <%-- Customer feedback repeater --%>
                <asp:Repeater ID="rptFeedback" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 mb-4">
                            <div class="feedback-card animate-on-scroll">
                                <%-- Star rating display --%>
                                <div class="feedback-rating">
                                    <%# GenerateStars(Eval("Rating")) %>
                                </div>
                                
                                <%-- Customer review text --%>
                                <p class="feedback-text"><%# GetSafeString(Eval("Review"), "") %></p>
                                
                                <%-- Customer name --%>
                                <div class="feedback-author">- <%# GetSafeString(Eval("Author"), "Anonymous") %></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <%-- ==================== FEATURED VEHICLES SECTION ==================== --%>
    <section class="py-5">
        <div class="container">
            <%-- Featured vehicles title --%>
            <h2 class="text-center section-title">Featured Vehicles</h2>
            
            <div class="row">
                <%-- Featured vehicles repeater --%>
                <asp:Repeater ID="rptFeaturedVehicles" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card vehicle-card animate-on-scroll">
                                <div class="position-relative">
                                    <%-- Featured vehicle image --%>
                                    <asp:Image ID="imgFeaturedVehicle" runat="server" 
                                               ImageUrl='<%# GetImageUrl(Eval("ImagePath")) %>' 
                                               CssClass="card-img-top featured-vehicle-image" 
                                               AlternateText='<%# GetSafeString(Eval("MakeName"), "") & " " & GetSafeString(Eval("ModelName"), "") %>' />
                                    
                                    <%-- Vehicle status badge --%>
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <%# GetStatusBadge(Eval("Status")) %>
                                    </div>
                                </div>
                                
                                <div class="card-body">
                                    <%-- Vehicle title --%>
                                    <h5 class="card-title">
                                        <%# GetSafeString(Eval("MakeName"), "Unknown") %> 
                                        <%# GetSafeString(Eval("ModelName"), "Model") %>
                                    </h5>
                                    
                                    <%-- Vehicle specifications --%>
                                    <div class="mb-3">
                                        <small class="text-muted">
                                            <i class="fas fa-users me-1"></i> <%# GetSafeInteger(Eval("SeatingCapacity"), 5) %> Seats |
                                            <i class="fas fa-cog me-1"></i> <%# GetSafeString(Eval("Transmission"), "Manual") %> |
                                            <i class="fas fa-gas-pump me-1"></i> <%# GetSafeString(Eval("FuelType"), "Petrol") %>
                                        </small>
                                    </div>
                                    
                                    <%-- Price and action button --%>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong class="text-primary fs-5"><%# FormatPrice(Eval("PricePerDay")) %></strong>
                                            <small class="text-muted">/day</small>
                                        </div>
                                        
                                        <asp:HyperLink ID="lnkViewVehicleDetails" runat="server" 
                                                       NavigateUrl="~/Vehicles.aspx" 
                                                       CssClass="btn btn-primary btn-sm btn-animated">
                                            <i class="fas fa-eye me-1"></i>View Details
                                        </asp:HyperLink>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <%-- View all vehicles button --%>
            <div class="text-center mt-4">
                <asp:HyperLink ID="lnkViewAllFeaturedVehicles" runat="server" 
                               NavigateUrl="~/Vehicles.aspx" 
                               CssClass="btn btn-outline-primary btn-lg btn-animated">
                    <i class="fas fa-car-side me-2"></i>View All Vehicles
                </asp:HyperLink>
            </div>
        </div>
    </section>

   <%-- ==================== LATEST NEWS SECTION ==================== --%>
<section class="py-5 bg-light">
    <div class="container">
        <h2 class="text-center section-title">Latest News</h2>
        <div class="row">
            <%-- The Repeater control will bind to a data source from the code-behind file --%>
            <asp:Repeater ID="rptLatestNews" runat="server">
                <ItemTemplate>
                    <%-- This div represents a single news article card --%>
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card news-card animate-on-scroll">
                            <div class="position-relative overflow-hidden">
                                <%-- Image for the news article --%>
                                <asp:Image ID="imgNews" runat="server" 
                                           ImageUrl='<%# Eval("ImagePath") %>' 
                                           CssClass="card-img-top news-image" 
                                           AlternateText='<%# Eval("Title") %>' />
                            </div>
                            <div class="card-body d-flex flex-column">
                                <div class="mb-2">
                                    <%-- Optional category badge, visible only if the category exists --%>
                                    <asp:Label ID="lblCategory" runat="server" 
                                               Text='<%# Eval("Category") %>' 
                                               CssClass="badge bg-primary mb-2" 
                                               Visible='<%# Not String.IsNullOrEmpty(Eval("Category").ToString()) %>' />
                                </div>
                                <%-- News article title --%>
                                <h5 class="card-title"><%# Eval("Title") %></h5>
                                <%-- Summary of the news article --%>
                                <p class="card-text flex-grow-1"><%# Eval("Summary") %></p>
                                <div class="mt-auto pt-3 border-top">
                                    <%-- Publish date of the news article --%>
                                    <small class="text-muted">
                                        <i class="fas fa-calendar me-1"></i> 
                                        <%# Eval("PublishDate", "{0:dd MMM yyyy}") %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</section>

    <!-- ==================== JAVASCRIPT SECTION ==================== -->
    <script type="text/javascript">
        // Animate elements on scroll
        function animateOnScroll() {
            const elements = document.querySelectorAll('.animate-on-scroll');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animated');
                    }
                });
            }, { threshold: 0.1 });

            elements.forEach(element => {
                observer.observe(element);
            });
        }

        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function () {
            animateOnScroll();
        });
    </script>
</asp:Content>