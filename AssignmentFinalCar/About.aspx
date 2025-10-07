<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/PublicMaster.Master" CodeBehind="About.aspx.vb" Inherits="AssignmentFinalCar.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- AOS Animation Library -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    
     <%-- Custom CSS styles for the About page --%>
    <style>
        /* Hero Section Styling with Parallax Effect */
        .hero-background-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover; 
            z-index: -2; 
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(30, 144, 255, 0.9) 0%, rgba(0, 89, 179, 0.9) 100%);
            z-index: -1; 
        }

        .about-hero {
            position: relative;
            background-attachment: fixed;
            background-position: center;
            color: white;
            padding: 120px 0;
            margin-bottom: 0;
            text-align: center;
            overflow: hidden;
            min-height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
        
        /* Shimmer animation effect for hero section */
        .about-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            animation: shimmer 3s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        /* Hero text styling with animations */
        .about-hero h1 {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out;
        }
        
        .about-hero p {
            font-size: 1.4rem;
            max-width: 700px;
            margin: 0 auto;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out 0.3s both;
            position: relative;
            z-index: 1;
        }
        
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
        
        /* Floating car icons animation */
        .floating-cars {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            overflow: hidden;
        }
        
        .car-icon {
            position: absolute;
            font-size: 2rem;
            color: rgba(255,255,255,0.1);
            animation: float 6s ease-in-out infinite;
        }
        
        .car-icon:nth-child(1) { top: 20%; left: 10%; animation-delay: 0s; }
        .car-icon:nth-child(2) { top: 60%; right: 15%; animation-delay: 2s; }
        .car-icon:nth-child(3) { top: 80%; left: 30%; animation-delay: 4s; }
        .car-icon:nth-child(4) { top: 30%; right: 25%; animation-delay: 1s; }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }
        
        /* Feature box styling with hover effects */
        .feature-box {
            text-align: center;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0,123,255,0.1);
        }
        
        .feature-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(0,123,255,0.1), transparent);
            transition: left 0.5s;
        }
        
        .feature-box:hover::before {
            left: 100%;
        }
        
        .feature-box:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0,123,255,0.2);
            border-color: #007bff;
        }
        
        .feature-box i {
            font-size: 3.5rem;
            background: linear-gradient(135deg, #007bff, #0056b3);
            -webkit-background-clip:text;
            -webkit-text-fill-color: transparent;
            background-clip:text;
            margin-bottom: 25px;
            transition: transform 0.3s ease;
        }
        
        .feature-box:hover i {
            transform: scale(1.2) rotateY(360deg);
        }
        
        .feature-box h4 {
            color: #2c3e50;
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }
        
        /* Team card styling */
        .team-card {
            text-align: center;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            background: white;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        
        .team-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .team-card:hover::before {
            transform: scaleX(1);
        }
        
        .team-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .team-card img {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 25px;
            border: 5px solid #f8f9fa;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .team-card:hover img {
            border-color: #007bff;
            transform: scale(1.05);
        }
        
        .team-card h5 {
            color: #2c3e50;
            font-weight: 700;
            font-size: 1.4rem;
            margin-bottom: 5px;
        }
        
        /* Statistics section styling */
        .stats-section {
            background: linear-gradient(135deg, #1e90ff, #0059b3);
            padding: 80px 0;
            margin: 80px 0;
            position: relative;
            overflow: hidden;
        }
        
        .stats-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><path d="M0 20L100 0v20z" fill="rgba(255,255,255,0.05)"/></svg>');
            background-size: 100px 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 30px 20px;
            color: white;
        }
        
        .stat-item h3 {
            font-size: 3.5rem;
            font-weight: 800;
            color: white;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            animation: countUp 2s ease-out;
        }
        
        .stat-item p {
            font-size: 1.2rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        @keyframes countUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Contact information styling */
        .contact-info {
            background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 5px solid #007bff;
        }
        
        .contact-info:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .contact-info h5 {
            color: #007bff;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 1.3rem;
        }
        
        .contact-info i {
            color: #007bff;
            margin-right: 15px;
            width: 20px;
        }
        
        /* Story section styling */
        .story-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            position: relative;
        }
        
        .story-content {
            background: white;
            padding: 60px;
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            position: relative;
        }
        
        .story-content::before {
            content: '"';
            position: absolute;
            top: -20px;
            left: 40px;
            font-size: 6rem;
            color: #007bff;
            font-family: serif;
            opacity: 0.3;
        }
        
        /* Testimonial card styling */
        .testimonial-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 30px;
            position: relative;
        }
        
        .testimonial-card::before {
            content: '"';
            position: absolute;
            top: 10px;
            left: 20px;
            font-size: 3rem;
            color: #007bff;
            opacity: 0.3;
            font-family: serif;
        }
        
        .testimonial-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        /* Responsive design for mobile devices */
        @media (max-width: 768px) {
            .about-hero h1 {
                font-size: 2.5rem;
            }
            
            .about-hero p {
                font-size: 1.1rem;
            }
            
            .feature-box, .team-card {
                margin-bottom: 20px;
            }
            
            .story-content {
                padding: 40px 30px;
            }
        }
    </style>
</asp:Content>

<%-- Main content section of the page --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- Hero Section with background image and overlay --%>
    <section class="about-hero">
        <%-- ASP.NET Image control for hero background --%>
        <asp:Image ID="imgHeroBackground" runat="server" 
                   ImageUrl="~/image/aboutpic1.jpg" 
                   CssClass="hero-background-image"
                   AlternateText="CarInstant Hero Background" />
        
        <%-- Overlay div for gradient effect --%>
        <div class="hero-overlay"></div>
        
        <%-- Floating car icons for visual appeal --%>
        <div class="floating-cars">
            <i class="fas fa-car car-icon"></i>
            <i class="fas fa-truck car-icon"></i>
            <i class="fas fa-taxi car-icon"></i>
            <i class="fas fa-bus car-icon"></i>
        </div>
        
        <%-- Container for hero content --%>
        <div class="container">
            <%-- ASP.NET Literal control for dynamic hero title --%>
            <asp:Literal ID="litHeroTitle" runat="server" 
                        Text="<h1>About CarInstant</h1>" />
            
            <%-- ASP.NET Literal control for hero description --%>
            <asp:Literal ID="litHeroDescription" runat="server" 
                        Text="<p>Your trusted car rental partner in Mauritius, providing exceptional service and quality vehicles since 2020.</p>" />
        </div>
    </section>

    <%-- Company Story Section --%>
    <section class="story-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <div class="story-content" data-aos="fade-up">
                        <div class="text-center mb-5">
                            <%-- ASP.NET Literal for section title --%>
                            <asp:Literal ID="litStoryTitle" runat="server" 
                                        Text="<h2 class='display-4 font-weight-bold text-primary'>Our Story</h2>" />
                            
                            <%-- Decorative divider --%>
                            <div style="width: 100px; height: 4px; background: linear-gradient(135deg, #007bff, #0056b3); margin: 20px auto; border-radius: 2px;"></div>
                        </div>
                        
                        <%-- ASP.NET Literal controls for story content --%>
                        <asp:Literal ID="litStoryContent1" runat="server" 
                                    Text="<p class='lead text-center mb-4'>CarInstant was founded with a simple mission: to provide reliable, affordable, and convenient car rental services to residents and visitors of Mauritius. We understand that mobility is essential for both business and leisure, which is why we've built a fleet of well-maintained vehicles to meet every need.</p>" />
                        
                        <asp:Literal ID="litStoryContent2" runat="server" 
                                    Text="<p class='text-center'>From economy cars for daily commuting to luxury vehicles for special occasions, our diverse fleet ensures that every customer finds the perfect vehicle for their journey. Our commitment to customer satisfaction has made us one of the leading car rental services in Mauritius.</p>" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- Services Section --%>
    <div class="container mb-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <%-- ASP.NET Label for services section title --%>
            <asp:Label ID="lblServicesTitle" runat="server" 
                      Text="Our Services" 
                      CssClass="display-4 font-weight-bold text-primary" />
            
            <%-- ASP.NET Label for services subtitle --%>
            <asp:Label ID="lblServicesSubtitle" runat="server" 
                      Text="We offer comprehensive car rental solutions for all your needs" 
                      CssClass="lead text-muted d-block mt-2" />
            
            <div style="width: 100px; height: 4px; background: linear-gradient(135deg, #007bff, #0056b3); margin: 20px auto; border-radius: 2px;"></div>
        </div>
        
        <%-- Services grid using ASP.NET Repeater for better data management --%>
        <div class="row">
            <%-- You could replace this with a Repeater bound to a data source --%>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-box">
                    <i class="fas fa-car"></i>
                    <asp:Label ID="lblService1Title" runat="server" Text="Vehicle Rental" CssClass="h4 d-block" />
                    <asp:Label ID="lblService1Desc" runat="server" 
                              Text="Wide selection of vehicles from economy to luxury cars, all well-maintained and regularly serviced." />
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-box">
                    <i class="fas fa-clock"></i>
                    <asp:Label ID="lblService2Title" runat="server" Text="Flexible Booking" CssClass="h4 d-block" />
                    <asp:Label ID="lblService2Desc" runat="server" 
                              Text="Book vehicles for hours, days, weeks, or months with flexible pickup and drop-off options." />
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-box">
                    <i class="fas fa-headset"></i>
                    <asp:Label ID="lblService3Title" runat="server" Text="24/7 Support" CssClass="h4 d-block" />
                    <asp:Label ID="lblService3Desc" runat="server" 
                              Text="Round-the-clock customer support to assist you whenever you need help during your rental period." />
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="400">
                <div class="feature-box">
                    <i class="fas fa-shield-alt"></i>
                    <asp:Label ID="lblService4Title" runat="server" Text="Full Insurance" CssClass="h4 d-block" />
                    <asp:Label ID="lblService4Desc" runat="server" 
                              Text="Comprehensive insurance coverage included with all rentals for your peace of mind." />
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="500">
                <div class="feature-box">
                    <i class="fas fa-tools"></i>
                    <asp:Label ID="lblService5Title" runat="server" Text="Maintenance" CssClass="h4 d-block" />
                    <asp:Label ID="lblService5Desc" runat="server" 
                              Text="Regular maintenance and safety checks ensure all vehicles are in perfect condition." />
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="600">
                <div class="feature-box">
                    <i class="fas fa-map-marked-alt"></i>
                    <asp:Label ID="lblService6Title" runat="server" Text="GPS & Extras" CssClass="h4 d-block" />
                    <asp:Label ID="lblService6Desc" runat="server" 
                              Text="Additional services including GPS navigation, baby seats, and other accessories available." />
                </div>
            </div>
        </div>
    </div>

    <%-- Statistics Section using ASP.NET Label controls --%>
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <%-- Vehicle Count Statistic --%>
                <div class="col-md-3" data-aos="zoom-in" data-aos-delay="100">
                    <div class="stat-item">
                        <%-- ASP.NET Label control populated from code-behind --%>
                        <h3><asp:Label ID="lblTotalVehicles" runat="server" Text="0" /></h3>
                        <asp:Label ID="lblVehiclesLabel" runat="server" Text="Vehicles in Fleet" />
                    </div>
                </div>
                
                <%-- Customer Count Statistic --%>
                <div class="col-md-3" data-aos="zoom-in" data-aos-delay="200">
                    <div class="stat-item">
                        <h3><asp:Label ID="lblTotalCustomers" runat="server" Text="0" /></h3>
                        <asp:Label ID="lblCustomersLabel" runat="server" Text="Happy Customers" />
                    </div>
                </div>
                
                <%-- Bookings Count Statistic --%>
                <div class="col-md-3" data-aos="zoom-in" data-aos-delay="300">
                    <div class="stat-item">
                        <h3><asp:Label ID="lblTotalBookings" runat="server" Text="0" /></h3>
                        <asp:Label ID="lblBookingsLabel" runat="server" Text="Completed Bookings" />
                    </div>
                </div>
                
                <%-- Rating Statistic (static) --%>
                <div class="col-md-3" data-aos="zoom-in" data-aos-delay="400">
                    <div class="stat-item">
                        <h3><asp:Label ID="lblRating" runat="server" Text="4.8/5" /></h3>
                        <asp:Label ID="lblRatingLabel" runat="server" Text="Customer Rating" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- Team Section using ASP.NET Image and Label controls --%>
    <div class="container mb-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <asp:Label ID="lblTeamTitle" runat="server" 
                      Text="Meet Our Team" 
                      CssClass="display-4 font-weight-bold text-primary" />
            
            <asp:Label ID="lblTeamSubtitle" runat="server" 
                      Text="The dedicated professionals behind CarInstant" 
                      CssClass="lead text-muted d-block mt-2" />
            
            <div style="width: 100px; height: 4px; background: linear-gradient(135deg, #007bff, #0056b3); margin: 20px auto; border-radius: 2px;"></div>
        </div>
        
        <div class="row">
            <%-- Team Member 1 --%>
            <div class="col-md-4" data-aos="fade-right" data-aos-delay="100">
                <div class="team-card">
                    <%-- ASP.NET Image control for team member photo --%>
                    <asp:Image ID="imgTeam1" runat="server" 
                              ImageUrl="~/image/aboutpic2.jpg" 
                              AlternateText="CEO - Raj Patel" 
                              CssClass="img-fluid" />
                    
                    <%-- ASP.NET Label controls for team member information --%>
                    <asp:Label ID="lblTeam1Name" runat="server" 
                              Text="Raj Patel" 
                              CssClass="h5 d-block" />
                    
                    <asp:Label ID="lblTeam1Position" runat="server" 
                              Text="Chief Executive Officer" 
                              CssClass="text-muted d-block" />
                    
                    <asp:Label ID="lblTeam1Description" runat="server" 
                              Text="Leading CarInstant with over 15 years of experience in the automotive industry." />
                </div>
            </div>
            
            <%-- Team Member 2 --%>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="team-card">
                    <asp:Image ID="imgTeam2" runat="server" 
                              ImageUrl="~/image/aboutpic3.jpg" 
                              AlternateText="Operations Manager - Kia ChenKong" 
                              CssClass="img-fluid" />
                    
                    <asp:Label ID="lblTeam2Name" runat="server" 
                              Text="Kia ChenKong" 
                              CssClass="h5 d-block" />
                    
                    <asp:Label ID="lblTeam2Position" runat="server" 
                              Text="Operations Manager" 
                              CssClass="text-muted d-block" />
                    
                    <asp:Label ID="lblTeam2Description" runat="server" 
                              Text="Ensuring smooth operations and exceptional customer service across all locations." />
                </div>
            </div>
            
            <%-- Team Member 3 --%>
            <div class="col-md-4" data-aos="fade-left" data-aos-delay="300">
                <div class="team-card">
                    <asp:Image ID="imgTeam3" runat="server" 
                              ImageUrl="~/image/aboutpic4.jpg" 
                              AlternateText="Fleet Manager - David Chen" 
                              CssClass="img-fluid" />
                    
                    <asp:Label ID="lblTeam3Name" runat="server" 
                              Text="David Chen" 
                              CssClass="h5 d-block" />
                    
                    <asp:Label ID="lblTeam3Position" runat="server" 
                              Text="Fleet Manager" 
                              CssClass="text-muted d-block" />
                    
                    <asp:Label ID="lblTeam3Description" runat="server" 
                              Text="Managing our vehicle fleet and ensuring all cars are in perfect condition." />
                </div>
            </div>
        </div>
    </div>

    <%-- Contact Information Section --%>
    <div class="container mb-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="text-center mb-5" data-aos="fade-up">
                    <asp:Label ID="lblContactTitle" runat="server" 
                              Text="Contact Information" 
                              CssClass="display-4 font-weight-bold text-primary" />
                    
                    <asp:Label ID="lblContactSubtitle" runat="server" 
                              Text="Get in touch with us for any inquiries or support" 
                              CssClass="lead text-muted d-block mt-2" />
                    
                    <div style="width: 100px; height: 4px; background: linear-gradient(135deg, #007bff, #0056b3); margin: 20px auto; border-radius: 2px;"></div>
                </div>
                
                <div class="row">
                    <%-- Location Information --%>
                    <div class="col-md-6" data-aos="fade-right">
                        <div class="contact-info">
                            <asp:Label ID="lblLocationTitle" runat="server" 
                                      Text="Our Location" 
                                      CssClass="h5" />
                            <i class="fas fa-map-marker-alt"></i>
                            
                            <%-- ASP.NET Literal for location address --%>
                            <asp:Literal ID="litLocationAddress" runat="server" 
                                        Text="<p>CarInstant Head Office<br>123 Royal Road<br>Port Louis, Mauritius</p>" />
                        </div>
                    </div>
                    
                    <%-- Contact Details --%>
                    <div class="col-md-6" data-aos="fade-left">
                        <div class="contact-info">
                            <asp:Label ID="lblContactDetailsTitle" runat="server" 
                                      Text="Contact Details" 
                                      CssClass="h5" />
                            <i class="fas fa-phone"></i>
                            
                            <%-- ASP.NET Literal for contact information --%>
                            <asp:Literal ID="litContactDetails" runat="server" 
                                        Text="<p><i class='fas fa-phone'></i> +230 123 4567</p><p><i class='fas fa-envelope'></i> info@carinstant.mu</p><p><i class='fas fa-clock'></i> Mon-Sun: 24/7 Service</p>" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>             
                   
    </asp:Panel>

    <!-- AOS Animation Script -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        // Initialize AOS animations
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true,
            offset: 100
        });

        // Custom scroll animations
        window.addEventListener('scroll', function() {
            const elements = document.querySelectorAll('.scroll-animate');
            elements.forEach(function(element) {
                const elementTop = element.getBoundingClientRect().top;
                const elementBottom = element.getBoundingClientRect().bottom;
                
                if (elementTop < window.innerHeight && elementBottom > 0) {
                    element.classList.add('show');
                }
            });
        });

        // Parallax effect for hero section
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            const hero = document.querySelector('.about-hero');
            const rate = scrolled * -0.5;
            
            if (hero) {
                hero.style.transform = 'translateY(' + rate + 'px)';
            }
        });

        // Counter animation for statistics
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-item h3');
            const speed = 200;

            counters.forEach(counter => {
                const animate = () => {
                    const value = +counter.innerText.replace(/[^0-9]/g, '');
                    const data = +counter.getAttribute('data-target') || value;
                    const time = data / speed;
                    
                    if (value < data) {
                        counter.innerText = Math.ceil(value + time);
                        setTimeout(animate, 1);
                    } else {
                        counter.innerText = data;
                    }
                }
                animate();
            });
        }

        // Trigger counter animation when statistics section is visible
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounters();
                    observer.unobserve(entry.target);
                }
            });
        });

        const statsSection = document.querySelector('.stats-section');
        if (statsSection) {
            observer.observe(statsSection);
        }
    </script>
</asp:Content>
