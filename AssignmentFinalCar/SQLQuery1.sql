-- 1. Users table 
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    UserType NVARCHAR(20) DEFAULT 'Client',
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);
-- 2. Make Table (Car manufacturers)
CREATE TABLE Make (
    MakeID INT IDENTITY(1,1) PRIMARY KEY,
    MakeName NVARCHAR(50) UNIQUE NOT NULL,
    Country NVARCHAR(50),
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID)
);

-- 3. Model Table (Car models)
CREATE TABLE Model (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    MakeID INT NOT NULL FOREIGN KEY REFERENCES Make(MakeID),
    ModelName NVARCHAR(50) NOT NULL,
    Year INT,
    FuelType NVARCHAR(20) CHECK (FuelType IN ('Petrol', 'Diesel', 'Electric', 'Hybrid')),
    Transmission NVARCHAR(20) CHECK (Transmission IN ('Manual', 'Automatic')),
    SeatingCapacity INT,
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID),
    UNIQUE(MakeID, ModelName, Year)
);

-- 4. Vehicles Table (Individual cars available for rent)
CREATE TABLE Vehicles (
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    ModelID INT NOT NULL FOREIGN KEY REFERENCES Model(ModelID),
    LicensePlate NVARCHAR(20) UNIQUE NOT NULL,
    Color NVARCHAR(30),
    Mileage INT DEFAULT 0,
    PricePerDay DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'Rented', 'Maintenance', 'Inactive')),
    Features NVARCHAR(500), -- JSON string for additional features
    Location NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastServiceDate DATE,
    NextServiceDate DATE,
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID)
);

-- 5. Vehicle Images Table
CREATE TABLE VehicleImages (
    ImageID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleID INT NOT NULL FOREIGN KEY REFERENCES Vehicles(VehicleID),
    ImagePath NVARCHAR(255) NOT NULL,
    ImageType NVARCHAR(20) DEFAULT 'Gallery' CHECK (ImageType IN ('Primary', 'Gallery', 'Interior', 'Exterior')),
    Description NVARCHAR(255),
    DisplayOrder INT DEFAULT 1,
    IsActive BIT DEFAULT 1,
    UploadedDate DATETIME DEFAULT GETDATE(),
    UploadedBy INT FOREIGN KEY REFERENCES Users(UserID)
);

-- 6. Add-ons Table (Additional services like GPS, Baby seat)
CREATE TABLE Addons (
    AddonID INT IDENTITY(1,1) PRIMARY KEY,
    AddonName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255),
    PricePerDay DECIMAL(10,2) NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID)
);

-- 7. Bookings Table (Rental bookings)
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    VehicleID INT NOT NULL FOREIGN KEY REFERENCES Vehicles(VehicleID),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalDays AS (DATEDIFF(day, StartDate, EndDate) + 1),
    PricePerDay DECIMAL(10,2) NOT NULL,
    DiscountPercentage DECIMAL(5,2) DEFAULT 0,
    SubTotal DECIMAL(10,2),
    AddonTotal DECIMAL(10,2) DEFAULT 0,
    TotalAmount DECIMAL(10,2),
    DeliveryTime TIME,
    DropoffLocation NVARCHAR(255),
    SpecialRequests NVARCHAR(500),
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Active', 'Completed', 'Cancelled')),
    BookingDate DATETIME DEFAULT GETDATE(),
    ConfirmedDate DATETIME,
    ConfirmedBy INT FOREIGN KEY REFERENCES Users(UserID),
    CancelledDate DATETIME,
    CancelledBy INT FOREIGN KEY REFERENCES Users(UserID),
    CancellationReason NVARCHAR(255)
);

-- 8. Booking Addons (Many-to-many relationship between bookings and addons)
CREATE TABLE BookingAddons (
    BookingAddonID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(BookingID),
    AddonID INT NOT NULL FOREIGN KEY REFERENCES Addons(AddonID),
    Quantity INT DEFAULT 1,
    PricePerDay DECIMAL(10,2) NOT NULL,
    TotalPrice AS (Quantity * PricePerDay),
    UNIQUE(BookingID, AddonID)
);

-- 9. Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(BookingID),
    PaymentMethod NVARCHAR(20) CHECK (PaymentMethod IN ('Cash', 'Card', 'Bank Transfer', 'Online')),
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    TransactionID NVARCHAR(100),
    PaymentStatus NVARCHAR(20) DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    PaymentReference NVARCHAR(100),
    ProcessedBy INT FOREIGN KEY REFERENCES Users(UserID),
    Notes NVARCHAR(255)
);

-- 10. Reviews Table (Customer reviews for vehicles)
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    VehicleID INT NOT NULL FOREIGN KEY REFERENCES Vehicles(VehicleID),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewTitle NVARCHAR(100),
    ReviewText NVARCHAR(1000),
    IsApproved BIT DEFAULT 0,
    ReviewDate DATETIME DEFAULT GETDATE(),
    ApprovedBy INT FOREIGN KEY REFERENCES Users(UserID),
    ApprovedDate DATETIME,
    IsActive BIT DEFAULT 1
);

-- 11. Feedback Table (General feedback from users)
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Can be NULL for anonymous feedback
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Subject NVARCHAR(200),
    Message NVARCHAR(1000) NOT NULL,
    FeedbackType NVARCHAR(20) DEFAULT 'General' CHECK (FeedbackType IN ('General', 'Complaint', 'Suggestion', 'Compliment')),
    Status NVARCHAR(20) DEFAULT 'New' CHECK (Status IN ('New', 'In Progress', 'Resolved', 'Closed')),
    Priority NVARCHAR(10) DEFAULT 'Medium' CHECK (Priority IN ('Low', 'Medium', 'High')),
    SubmittedDate DATETIME DEFAULT GETDATE(),
    RespondedBy INT FOREIGN KEY REFERENCES Users(UserID),
    Response NVARCHAR(1000),
    ResponseDate DATETIME,
    IsActive BIT DEFAULT 1
);

-- 12. News Table (News and announcements)
CREATE TABLE News (
    NewsID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Summary NVARCHAR(500),
    ImagePath NVARCHAR(255),
    Category NVARCHAR(50) DEFAULT 'General',
    IsPublished BIT DEFAULT 0,
    IsFeatured BIT DEFAULT 0,
    PublishDate DATETIME,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    LastModifiedDate DATETIME,
    LastModifiedBy INT FOREIGN KEY REFERENCES Users(UserID),
    ViewCount INT DEFAULT 0,
    IsActive BIT DEFAULT 1
);


-- Create Indexes for better performance
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Role ON Users(UserRole);
CREATE INDEX IX_Vehicles_Status ON Vehicles(Status);
CREATE INDEX IX_Vehicles_Model ON Vehicles(ModelID);
CREATE INDEX IX_Bookings_User ON Bookings(UserID);
CREATE INDEX IX_Bookings_Vehicle ON Bookings(VehicleID);
CREATE INDEX IX_Bookings_Dates ON Bookings(StartDate, EndDate);
CREATE INDEX IX_Bookings_Status ON Bookings(Status);
CREATE INDEX IX_Reviews_Vehicle ON Reviews(VehicleID);
CREATE INDEX IX_News_Published ON News(IsPublished, PublishDate);