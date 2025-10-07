<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/ClientMaster.Master" CodeBehind="ClientFeedback.aspx.vb" Inherits="AssignmentFinalCar.WebForm20" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        .feedback-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #4a90e2;
            box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        }
        
        .feedback-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .feedback-type-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 4px solid #4a90e2;
        }
        
        .validation-summary {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .success-message {
            background: #d1edff;
            border: 1px solid #b8daff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            color: #004085;
        }
        
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            color: #721c24;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Header Section -->
        <div class="feedback-header">
            <h2 class="mb-3">
                <i class="fas fa-comment-dots me-2 text-primary"></i>Share Your Feedback
            </h2>
            <p class="lead mb-0">We value your opinion and strive to improve our services</p>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false">
            <div class="alert alert-dismissible fade show" role="alert">
                <asp:Label ID="lblMessage" runat="server" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </asp:Panel>

        <!-- Feedback Form -->
        <div class="feedback-container">
            <!-- Validation Summary -->
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                CssClass="validation-summary" 
                HeaderText="Please correct the following errors:" 
                DisplayMode="BulletList" />

            <div class="row">
                    <div class="col-md-6">
                        <!-- Name Field -->
                        <div class="form-group">
                            <asp:Label ID="lblName" runat="server" Text="Your Name *" CssClass="form-label" />
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your full name" />
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" 
                                ControlToValidate="txtName" 
                                ErrorMessage="Name is required" 
                                Text="*" 
                                CssClass="text-danger" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <!-- Email Field -->
                        <div class="form-group">
                            <asp:Label ID="lblEmail" runat="server" Text="Email Address *" CssClass="form-label" />
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your email address" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                ControlToValidate="txtEmail" 
                                ErrorMessage="Email is required" 
                                Text="*" 
                                CssClass="text-danger" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                ControlToValidate="txtEmail" 
                                ErrorMessage="Please enter a valid email address" 
                                Text="*" 
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                CssClass="text-danger" />
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <!-- Feedback Type -->
                        <div class="form-group">
                            <asp:Label ID="lblFeedbackType" runat="server" Text="Feedback Type *" CssClass="form-label" />
                            <asp:DropDownList ID="ddlFeedbackType" runat="server" CssClass="form-control">
                                <asp:ListItem Text="-- Select Feedback Type --" Value="" />
                                <asp:ListItem Text="General" Value="General" />
                                <asp:ListItem Text="Complaint" Value="Complaint" />
                                <asp:ListItem Text="Suggestion" Value="Suggestion" />
                                <asp:ListItem Text="Compliment" Value="Compliment" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvFeedbackType" runat="server" 
                                ControlToValidate="ddlFeedbackType" 
                                ErrorMessage="Please select a feedback type" 
                                Text="*" 
                                CssClass="text-danger" 
                                InitialValue="" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <!-- Priority -->
                        <div class="form-group">
                            <asp:Label ID="lblPriority" runat="server" Text="Priority" CssClass="form-label" />
                            <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Low" Value="Low" />
                                <asp:ListItem Text="Medium" Value="Medium" Selected="True" />
                                <asp:ListItem Text="High" Value="High" />
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>

                <!-- Subject Field -->
                <div class="form-group">
                    <asp:Label ID="lblSubject" runat="server" Text="Subject *" CssClass="form-label" />
                    <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Brief subject of your feedback" />
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server" 
                        ControlToValidate="txtSubject" 
                        ErrorMessage="Subject is required" 
                        Text="*" 
                        CssClass="text-danger" />
                </div>

                <!-- Message Field -->
                <div class="form-group">
                    <asp:Label ID="Label1" runat="server" Text="Your Message *" CssClass="form-label" />
                    <asp:TextBox ID="txtMessage" runat="server" 
                        CssClass="form-control" 
                        TextMode="MultiLine" 
                        Rows="6" 
                        placeholder="Please share your detailed feedback here..." />
                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server" 
                        ControlToValidate="txtMessage" 
                        ErrorMessage="Message is required" 
                        Text="*" 
                        CssClass="text-danger" />
                    <small class="form-text text-muted">Minimum 10 characters required</small>
                </div>

                <!-- Submit Button -->
                <div class="form-group text-center">
                    <asp:Button ID="btnSubmit" runat="server" 
                        Text="Submit Feedback" 
                        CssClass="btn btn-primary btn-submit me-3" 
                        OnClick="btnSubmit_Click" />
                    <asp:Button ID="btnClear" runat="server" 
                        Text="Clear Form" 
                        CssClass="btn btn-outline-secondary" 
                        OnClick="btnClear_Click" 
                        CausesValidation="false" />
                </div>
        </div>

        <!-- Feedback Types Information -->
        <div class="row">
            <div class="col-md-12">
                <h4 class="mb-3">
                    <i class="fas fa-info-circle text-info me-2"></i>Feedback Types Guide
                </h4>
            </div>
            <div class="col-md-6">
                <div class="feedback-type-card">
                    <h6><i class="fas fa-comment me-2 text-primary"></i>General</h6>
                    <p class="mb-0">General feedback about our services, website, or overall experience.</p>
                </div>
                <div class="feedback-type-card">
                    <h6><i class="fas fa-lightbulb me-2 text-warning"></i>Suggestion</h6>
                    <p class="mb-0">Ideas to improve our services or suggestions for new features.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="feedback-type-card">
                    <h6><i class="fas fa-exclamation-triangle me-2 text-danger"></i>Complaint</h6>
                    <p class="mb-0">Issues or problems you encountered with our services.</p>
                </div>
                <div class="feedback-type-card">
                    <h6><i class="fas fa-thumbs-up me-2 text-success"></i>Compliment</h6>
                    <p class="mb-0">Positive feedback about our services or staff members.</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
