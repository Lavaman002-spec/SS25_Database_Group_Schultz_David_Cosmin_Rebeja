USE ski_vacation_db;

-- Customers
INSERT INTO Customer (Name, Email, DOB) VALUES
('Alice Smith', 'alice@example.com', '1990-04-15'),
('Bob Johnson', 'bob@example.com', '1985-06-22'),
('Charlie Brown', 'charlie@example.com', '1992-09-30'),
('Diana Prince', 'diana@example.com', '1988-01-10'),
('Ethan Wright', 'ethan@example.com', '1995-12-05'),
('Fiona Grey', 'fiona@example.com', '1991-07-18'),
('George Black', 'george@example.com', '1984-03-25'),
('Hannah Lee', 'hannah@example.com', '1993-11-02'),
('Ian Blue', 'ian@example.com', '1996-02-14'),
('Julia Green', 'julia@example.com', '1989-08-07');

-- Vacation Packages
INSERT INTO Vacation_Package (Name, Price, Room_Type, SkiPassType) VALUES
('Standard Ski', 450.00, 'Double', 'Basic'),
('Deluxe Winter', 700.00, 'Suite', 'All-Access'),
('Family Fun', 600.00, 'Family', 'Regular'),
('Solo Escape', 400.00, 'Single', 'Basic'),
('Luxury Chill', 850.00, 'Suite', 'VIP'),
('Budget Blitz', 300.00, 'Single', 'Basic'),
('Couples Retreat', 650.00, 'Double', 'Regular'),
('Adventurer', 500.00, 'Double', 'Extended'),
('Snow Pro', 750.00, 'Suite', 'All-Access'),
('Beginner Boost', 350.00, 'Single', 'Beginner');

-- Reservations
INSERT INTO Reservation (Booking_Date, Start_Date, End_Date, Customer_ID, Package_ID) VALUES
('2025-01-05', '2025-02-10', '2025-02-15', 1, 1),
('2025-01-12', '2025-02-20', '2025-02-25', 2, 2),
('2025-01-15', '2025-03-01', '2025-03-05', 3, 3),
('2025-01-20', '2025-03-10', '2025-03-15', 4, 4),
('2025-01-22', '2025-03-18', '2025-03-20', 5, 5),
('2025-01-25', '2025-03-25', '2025-03-30', 6, 6),
('2025-01-27', '2025-04-01', '2025-04-05', 7, 7),
('2025-01-30', '2025-04-10', '2025-04-15', 8, 8),
('2025-02-02', '2025-04-20', '2025-04-25', 9, 9),
('2025-02-05', '2025-04-28', '2025-05-03', 10, 10);

-- SkiPasses
INSERT INTO SkiPass (Type, Valid_From, Valid_To, Reservation_ID) VALUES
('Basic', '2025-02-10', '2025-02-15', 1),
('All-Access', '2025-02-20', '2025-02-25', 2),
('Regular', '2025-03-01', '2025-03-05', 3),
('Basic', '2025-03-10', '2025-03-15', 4),
('VIP', '2025-03-18', '2025-03-20', 5),
('Basic', '2025-03-25', '2025-03-30', 6),
('Regular', '2025-04-01', '2025-04-05', 7),
('Extended', '2025-04-10', '2025-04-15', 8),
('All-Access', '2025-04-20', '2025-04-25', 9),
('Beginner', '2025-04-28', '2025-05-03', 10);

-- Resorts
INSERT INTO Resort (Name, Location, Difficulty_lvl) VALUES
('Alpine Ridge', 'Austria', 'Intermediate'),
('Snowy Peak', 'Switzerland', 'Advanced'),
('Glacier Bay', 'France', 'Beginner'),
('Frost Valley', 'Germany', 'Intermediate'),
('Chill Point', 'Italy', 'Advanced'),
('Blizzard Heights', 'Austria', 'Expert'),
('Crystal Slopes', 'Slovenia', 'Beginner'),
('Icy Trails', 'Germany', 'Intermediate'),
('Windy Summit', 'France', 'Advanced'),
('Frozen Pines', 'Austria', 'Beginner');

-- Grant_Access
INSERT INTO Grant_Access (SkiPass_ID, Resort_ID) VALUES
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 3), (3, 4),
(4, 4), (4, 5),
(5, 5), (5, 6),
(6, 6), (6, 7),
(7, 7), (7, 8),
(8, 8), (8, 9),
(9, 9), (9, 10),
(10, 10), (10, 1);

-- Payments
INSERT INTO Payment (Reservation_ID, Amount, Payment_Date) VALUES
(1, 450.00, '2025-01-06'),
(2, 700.00, '2025-01-13'),
(3, 600.00, '2025-01-16'),
(4, 400.00, '2025-01-21'),
(5, 850.00, '2025-01-23'),
(6, 300.00, '2025-01-26'),
(7, 650.00, '2025-01-28'),
(8, 500.00, '2025-01-31'),
(9, 750.00, '2025-02-03'),
(10, 350.00, '2025-02-06');