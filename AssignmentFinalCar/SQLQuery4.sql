-- ========================================
-- INSERT VEHICLE IMAGES - ALL YOUR IMAGES
-- ========================================

INSERT INTO VehicleImages (VehicleID, ImagePath, ImageType, Description, DisplayOrder, UploadedBy) VALUES

-- Toyota Vehicles (VehicleID 401, 402, 403, 404)
-- Toyota Corolla (VehicleID 401 - White)
(401, '~/image/toyota corolla1.jpg', 'Primary', 'White Toyota Corolla - Main Image', 1, 2),
(401, '~/image/toyota 1.jpg', 'Gallery', 'Toyota Corolla - Additional View', 2, 2),

-- Toyota Corolla (VehicleID 402 - Silver) 
(402, '~/image/toyota 2.jpg', 'Primary', 'Silver Toyota Corolla - Main Image', 1, 2),
(402, '~/image/toyota 3.jpg', 'Gallery', 'Toyota Corolla - Side View', 2, 2),

-- Toyota Camry (VehicleID 403 - Black)
(403, '~/image/homepic1.jpg', 'Primary', 'Black Toyota Camry - Main Image', 1, 2),

-- Toyota RAV4 (VehicleID 404 - Red) - Using one of the Toyota images
(404, '~/image/toyota 1.jpg', 'Primary', 'Red Toyota RAV4 - Main Image', 1, 2),

-- Honda Vehicles (VehicleID 405, 406)
-- Honda Civic (VehicleID 405 - Gray)
(405, '~/image/honda 1.jpg', 'Primary', 'Gray Honda Civic - Main Image', 1, 2),
(405, '~/image/honda 2.jpg', 'Gallery', 'Honda Civic - Additional View', 2, 2),

-- Honda CR-V (VehicleID 406 - White)
(406, '~/image/honda 2.jpg', 'Primary', 'White Honda CR-V - Main Image', 1, 2),

-- Nissan Vehicles (VehicleID 407, 408)
-- Nissan Altima (VehicleID 407 - Blue)
(407, '~/image/nissan 1.jpg', 'Primary', 'Blue Nissan Altima - Main Image', 1, 2),
(407, '~/image/nissan 2.jpg', 'Gallery', 'Nissan Altima - Side View', 2, 2),

-- Nissan X-Trail (VehicleID 408 - Black)
(408, '~/image/nissan 3.jpg', 'Primary', 'Black Nissan X-Trail - Main Image', 1, 2),
(408, '~/image/nissan 2.jpg', 'Gallery', 'Nissan X-Trail - Additional View', 2, 2),

-- Hyundai Vehicles (VehicleID 409, 410)
-- Hyundai Elantra (VehicleID 409 - Silver)
(409, '~/image/hyundai 1.jpg', 'Primary', 'Silver Hyundai Elantra - Main Image', 1, 2),
(409, '~/image/hyundai 2.jpg', 'Gallery', 'Hyundai Elantra - Interior View', 2, 2),

-- Hyundai Tucson (VehicleID 410 - Gray)
(410, '~/image/hyundai 2.jpg', 'Primary', 'Gray Hyundai Tucson - Main Image', 1, 2),

-- BMW Vehicle (VehicleID 411)
-- BMW 3 Series (VehicleID 411 - White)
(411, '~/image/bmw 1.jpg', 'Primary', 'White BMW 3 Series - Main Image', 1, 2),
(411, '~/image/bmw 2.jpg', 'Interior', 'BMW 3 Series - Luxury Interior', 2, 2),

-- Ford Vehicle (VehicleID 412)
-- Ford Focus (VehicleID 412 - Red)
(412, '~/image/ford 1.jpg', 'Primary', 'Red Ford Focus - Main Image', 1, 2);