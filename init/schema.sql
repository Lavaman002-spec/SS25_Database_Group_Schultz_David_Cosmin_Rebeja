CREATE DATABASE IF NOT EXISTS ski_vacation_db;
USE ski_vacation_db;

DROP TABLE IF EXISTS Grant_Access;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS SkiPass;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Vacation_Package;
DROP TABLE IF EXISTS Resort;
DROP TABLE IF EXISTS Customer;

-- Customer Table
CREATE TABLE Customer (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(128) NOT NULL,
    Email VARCHAR(128) UNIQUE NOT NULL,
    DOB DATE NOT NULL
);

-- Vacation Package
CREATE TABLE Vacation_Package (
    Package_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Room_Type VARCHAR(50),
    SkiPassType VARCHAR(50)
);

-- Reservation
CREATE TABLE Reservation (
    Reservation_ID INT AUTO_INCREMENT PRIMARY KEY,
    Booking_Date DATE,
    Start_Date DATE,
    End_Date DATE,
    Customer_ID INT,
    Package_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Package_ID) REFERENCES Vacation_Package(Package_ID)
);

-- SkiPass
CREATE TABLE SkiPass (
    SkiPass_ID INT AUTO_INCREMENT PRIMARY KEY,
    Type VARCHAR(64),
    Valid_From DATE,
    Valid_To DATE,
    Reservation_ID INT,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID)
);

-- Resort
CREATE TABLE Resort (
    Resort_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(128),
    Location VARCHAR(128),
    Difficulty_lvl VARCHAR(64)
);

-- Grant_Access (Many-to-Many)
CREATE TABLE Grant_Access (
    SkiPass_ID INT,
    Resort_ID INT,
    PRIMARY KEY (SkiPass_ID, Resort_ID),
    FOREIGN KEY (SkiPass_ID) REFERENCES SkiPass(SkiPass_ID),
    FOREIGN KEY (Resort_ID) REFERENCES Resort(Resort_ID)
);

-- Payment
CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Reservation_ID INT UNIQUE,
    Amount DECIMAL(10,2),
    Payment_Date DATE,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID)
);