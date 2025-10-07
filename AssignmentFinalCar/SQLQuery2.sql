-- ========================================
-- 2. INSERT CAR MAKES
-- ========================================
-- Using ID range 201-206 for Makes
SET IDENTITY_INSERT Make ON;

INSERT INTO Make (MakeID, MakeName, Country, Description, CreatedBy) VALUES
(201, 'Toyota', 'Japan', 'Reliable and fuel-efficient vehicles', 2),
(202, 'Honda', 'Japan', 'Quality and innovation', 2),
(203, 'Nissan', 'Japan', 'Innovation that excites', 2),
(204, 'Hyundai', 'South Korea', 'New thinking, new possibilities', 2),
(205, 'BMW', 'Germany', 'The ultimate driving machine', 2),
(206, 'Ford', 'USA', 'Built tough', 2);

SET IDENTITY_INSERT Make OFF;

-- ========================================
-- 3. INSERT CAR MODELS 
-- ========================================
-- Using ID range 301-311 for Models
SET IDENTITY_INSERT Model ON;

INSERT INTO Model (ModelID, MakeID, ModelName, Year, FuelType, Transmission, SeatingCapacity, Description, CreatedBy) VALUES
-- Toyota Models (MakeID 201)
(301, 201, 'Corolla', 2022, 'Petrol', 'Automatic', 5, 'Compact sedan with excellent fuel economy', 2),
(302, 201, 'Camry', 2023, 'Hybrid', 'Automatic', 5, 'Mid-size sedan with hybrid technology', 2),
(303, 201, 'RAV4', 2023, 'Petrol', 'Automatic', 5, 'Compact SUV perfect for adventures', 2),

-- Honda Models (MakeID 202)
(304, 202, 'Civic', 2022, 'Petrol', 'Manual', 5, 'Sporty and efficient compact car', 2),
(305, 202, 'CR-V', 2023, 'Petrol', 'Automatic', 5, 'Versatile compact SUV', 2),

-- Nissan Models (MakeID 203)
(306, 203, 'Altima', 2022, 'Petrol', 'Automatic', 5, 'Comfortable mid-size sedan', 2),
(307, 203, 'X-Trail', 2023, 'Petrol', 'Automatic', 7, 'Family-friendly SUV', 2),

-- Hyundai Models (MakeID 204)
(308, 204, 'Elantra', 2022, 'Petrol', 'Automatic', 5, 'Sophisticated compact sedan', 2),
(309, 204, 'Tucson', 2023, 'Petrol', 'Automatic', 5, 'Bold and dynamic SUV', 2),

-- BMW Models (MakeID 205)
(310, 205, '3 Series', 2023, 'Petrol', 'Automatic', 5, 'Luxury sports sedan', 2),

-- Ford Models (MakeID 206)
(311, 206, 'Focus', 2022, 'Petrol', 'Automatic', 5, 'Dynamic compact car', 2);

SET IDENTITY_INSERT Model OFF;

-- ========================================
-- 4. INSERT VEHICLES 
-- ========================================
-- Using ID range 401-411 for Vehicles
SET IDENTITY_INSERT Vehicles ON;

INSERT INTO Vehicles (VehicleID, ModelID, LicensePlate, Color, Mileage, PricePerDay, Status, Features, Location, LastServiceDate, NextServiceDate, CreatedBy) VALUES
-- Toyota Vehicles (ModelID 301, 302, 303)
(401, 301, 'MAU1001', 'White', 15000, 1200.00, 'Available', 'Air conditioning, Bluetooth, GPS', 'Port Louis Airport', '2024-01-15', '2024-07-15', 2),
(402, 301, 'MAU1002', 'Silver', 8500, 1200.00, 'Available', 'Air conditioning, Bluetooth', 'Grand Baie', '2024-02-01', '2024-08-01', 2),
(403, 302, 'MAU1003', 'Black', 12000, 1800.00, 'Available', 'Air conditioning, Bluetooth, GPS, Leather seats', 'Port Louis Airport', '2024-01-20', '2024-07-20', 2),
(404, 303, 'MAU1004', 'Red', 20000, 2200.00, 'Available', 'Air conditioning, Bluetooth, GPS, 4WD', 'Curepipe', '2024-01-10', '2024-07-10', 2),

-- Honda Vehicles (ModelID 304, 305)
(405, 304, 'MAU2001', 'Gray', 10000, 1400.00, 'Available', 'Air conditioning, Bluetooth, Sunroof', 'Rose Hill', '2024-02-10', '2024-08-10', 2),
(406, 305, 'MAU2002', 'White', 16000, 2100.00, 'Rented', 'Air conditioning, Bluetooth, GPS, 4WD', 'Grand Baie', '2024-02-15', '2024-08-15', 2),

-- Nissan Vehicles (ModelID 306, 307)
(407, 306, 'MAU3001', 'Blue', 13000, 1700.00, 'Available', 'Air conditioning, Bluetooth, GPS', 'Vacoas', '2024-01-12', '2024-07-12', 2),
(408, 307, 'MAU3002', 'Black', 22000, 2400.00, 'Available', 'Air conditioning, Bluetooth, GPS, 7 seats', 'Beau Bassin', '2024-01-28', '2024-07-28', 2),

-- Hyundai Vehicles (ModelID 308, 309)
(409, 308, 'MAU4001', 'Silver', 11000, 1500.00, 'Available', 'Air conditioning, Bluetooth, GPS', 'Curepipe', '2024-01-18', '2024-07-18', 2),
(410, 309, 'MAU4002', 'Gray', 17000, 2000.00, 'Available', 'Air conditioning, Bluetooth, GPS, Sunroof', 'Phoenix', '2024-02-03', '2024-08-03', 2),

-- BMW Vehicle (ModelID 310)
(411, 310, 'MAU5001', 'White', 8000, 4500.00, 'Available', 'Air conditioning, Bluetooth, GPS, Leather, Premium sound', 'Port Louis Airport', '2024-02-01', '2024-08-01', 2),

-- Ford Vehicle (ModelID 311)
(412, 311, 'MAU6001', 'Red', 11000, 1300.00, 'Available', 'Air conditioning, Bluetooth, GPS', 'Beau Bassin', '2024-02-21', '2024-08-21', 2);

SET IDENTITY_INSERT Vehicles OFF;

-- =======================================
-- 5. INSERT ADD-ONS
-- ========================================
-- Using ID range 501-505 for Addons
SET IDENTITY_INSERT Addons ON;

INSERT INTO Addons (AddonID, AddonName, Description, PricePerDay, CreatedBy) VALUES
(501, 'GPS Navigation', 'GPS navigation system', 150.00, 2),
(502, 'Baby Seat', 'Safety-certified baby car seat', 100.00, 2),
(503, 'Additional Driver', 'Allow additional person to drive', 200.00, 2),
(504, 'Full Insurance', 'Comprehensive insurance coverage', 300.00, 2),
(505, 'Airport Pickup', 'Pickup from airport', 500.00, 2);

SET IDENTITY_INSERT Addons OFF;

-- ========================================
-- 6. INSERT SAMPLE BOOKINGS 
-- ========================================
-- Using ID range 601-605 for Bookings with your existing User IDs (2, 3, 4)
SET IDENTITY_INSERT Bookings ON;

INSERT INTO Bookings (BookingID, UserID, VehicleID, StartDate, EndDate, PricePerDay, DiscountPercentage, SubTotal, AddonTotal, TotalAmount, DropoffLocation, SpecialRequests, Status, ConfirmedBy) VALUES
-- Active Booking (UserID 3, VehicleID 407)
(601, 3, 407, '2024-08-05', '2024-08-12', 1700.00, 0.00, 11900.00, 450.00, 12350.00, 'Grand Baie Hotel', 'Please deliver to hotel reception', 'Active', 2),

-- Confirmed Bookings
(602, 4, 403, '2024-08-15', '2024-08-25', 1800.00, 10.00, 17820.00, 300.00, 18120.00, 'Curepipe Mall', 'Need GPS', 'Confirmed', 2),
(603, 3, 411, '2024-08-20', '2024-08-30', 4500.00, 0.00, 49500.00, 500.00, 50000.00, 'Le Morne Resort', 'Luxury vacation', 'Confirmed', 2),

-- Completed Bookings
(604, 3, 401, '2024-07-10', '2024-07-17', 1200.00, 0.00, 9600.00, 150.00, 9750.00, 'Port Louis Airport', 'Business trip', 'Completed', 2),
(605, 4, 409, '2024-07-20', '2024-07-27', 1500.00, 5.00, 9975.00, 250.00, 10225.00, 'Grand Baie', 'Family vacation', 'Completed', 2);

SET IDENTITY_INSERT Bookings OFF;

-- ========================================
-- 7. INSERT BOOKING ADD-ONS
-- ========================================
INSERT INTO BookingAddons (BookingID, AddonID, Quantity, PricePerDay) VALUES
-- Booking 601 Add-ons
(601, 501, 1, 150.00), -- GPS
(601, 504, 1, 300.00), -- Full Insurance

-- Booking 602 Add-ons
(602, 501, 1, 150.00), -- GPS
(602, 502, 1, 100.00), -- Baby Seat

-- Booking 603 Add-ons
(603, 505, 1, 500.00), -- Airport Pickup

-- Booking 604 Add-ons
(604, 501, 1, 150.00), -- GPS

-- Booking 605 Add-ons
(605, 501, 1, 150.00), -- GPS
(605, 502, 1, 100.00); -- Baby Seat

-- ========================================
-- 8. INSERT SAMPLE PAYMENTS (Using admin ID 2 as processor)
-- ========================================
INSERT INTO Payments (BookingID, PaymentMethod, PaymentAmount, TransactionID, PaymentStatus, PaymentReference, ProcessedBy, Notes) VALUES
-- Completed payments
(604, 'Card', 9750.00, 'TXN001', 'Completed', 'VISA****1234', 2, 'Payment successful'),
(605, 'Bank Transfer', 10225.00, 'TXN002', 'Completed', 'MCB001', 2, 'Transfer confirmed'),

-- Active booking payments
(601, 'Card', 12350.00, 'TXN003', 'Completed', 'VISA****5678', 2, 'Advance payment'),
(602, 'Online', 9060.00, 'TXN004', 'Completed', 'PAYPAL001', 2, 'Partial payment - 50%');

-- ========================================
-- 9. INSERT SAMPLE REVIEWS (Using admin ID 2 for approval)
-- ========================================
INSERT INTO Reviews (UserID, VehicleID, BookingID, Rating, ReviewTitle, ReviewText, IsApproved, ApprovedBy, ApprovedDate) VALUES
(3, 401, 604, 5, 'Excellent Service!', 'The Toyota Corolla was in perfect condition. Very clean and comfortable. Highly recommended!', 1, 2, '2024-07-25 10:30:00'),
(4, 409, 605, 4, 'Great Family Car', 'The Hyundai Elantra was perfect for our family vacation. Spacious and fuel efficient. Good service overall.', 1, 2, '2024-08-01 09:45:00');

-- ========================================
-- 10. INSERT SAMPLE NEWS (Using admin ID 2)
-- ========================================
INSERT INTO News (Title, Content, Summary, Category, IsPublished, IsFeatured, PublishDate, CreatedBy, ViewCount) VALUES
('New Vehicles Added to Fleet', 'CarInstant is excited to announce new vehicles have been added to our fleet. More options available for our customers!', 'New vehicles added to rental fleet', 'Fleet Updates', 1, 1, '2024-07-30 09:00:00', 2, 156),
('Summer Special Offer', 'Get 10% discount on all bookings made this month. Limited time offer for summer vacation rentals.', 'Summer discount offer available', 'Promotions', 1, 1, '2024-07-28 10:30:00', 2, 203);

-- ========================================
-- 11. INSERT SAMPLE FEEDBACK (Using admin ID 2 for responses)
-- ========================================
INSERT INTO Feedback (UserID, Name, Email, Subject, Message, FeedbackType, Status, Priority, SubmittedDate, RespondedBy, Response, ResponseDate) VALUES
(3, 'John Smith', 'john.smith@email.com', 'Great Experience', 'Had a wonderful experience renting from CarInstant. The process was smooth and the car was excellent.', 'Compliment', 'Resolved', 'Medium', '2024-07-26 10:30:00', 2, 'Thank you for your feedback! We appreciate your business.', '2024-07-26 14:15:00'),
(4, 'Sarah Johnson', 'sarah.j@email.com', 'Suggestion for Mobile App', 'It would be great to have a mobile app for easier booking and management.', 'Suggestion', 'In Progress', 'Medium', '2024-07-28 09:15:00', 2, 'Thank you for the suggestion. We are working on a mobile app.', '2024-07-28 11:30:00');