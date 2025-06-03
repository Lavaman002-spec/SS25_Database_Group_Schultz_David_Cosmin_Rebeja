-- PostgreSQL compatible schema for ski_vacation_db

--
-- Drop tables in reverse dependency order
--
DROP TABLE IF EXISTS "Grant_Access";
DROP TABLE IF EXISTS "SkiPass";
DROP TABLE IF EXISTS "Payment";
DROP TABLE IF EXISTS "Reservation";
DROP TABLE IF EXISTS "Customer";
DROP TABLE IF EXISTS "Resort";
DROP TABLE IF EXISTS "Vacation_Package";


--
-- Table structure for table "Customer" (Independent)
--
CREATE TABLE "Customer" (
  "Customer_ID" SERIAL NOT NULL,
  "Name" varchar(128) NOT NULL,
  "Email" varchar(128) NOT NULL,
  "DOB" date NOT NULL,
  PRIMARY KEY ("Customer_ID"),
  UNIQUE ("Email")
);

--
-- Table structure for table "Resort" (Independent)
--
CREATE TABLE "Resort" (
  "Resort_ID" SERIAL NOT NULL,
  "Name" varchar(128) DEFAULT NULL,
  "Location" varchar(128) DEFAULT NULL,
  "Difficulty_lvl" varchar(64) DEFAULT NULL,
  PRIMARY KEY ("Resort_ID")
);

--
-- Table structure for table "Vacation_Package" (Independent)
--
CREATE TABLE "Vacation_Package" (
  "Package_ID" SERIAL NOT NULL,
  "Name" varchar(100) NOT NULL,
  "Price" decimal(10,2) NOT NULL,
  "Room_Type" varchar(50) DEFAULT NULL,
  "SkiPassType" varchar(50) DEFAULT NULL,
  PRIMARY KEY ("Package_ID")
);

--
-- Table structure for table "Reservation" (References Customer, Vacation_Package)
--
CREATE TABLE "Reservation" (
  "Reservation_ID" SERIAL NOT NULL,
  "Booking_Date" date DEFAULT NULL,
  "Start_Date" date DEFAULT NULL,
  "End_Date" date DEFAULT NULL,
  "Customer_ID" int DEFAULT NULL,
  "Package_ID" int DEFAULT NULL,
  PRIMARY KEY ("Reservation_ID"),
  CONSTRAINT "Reservation_ibfk_1" FOREIGN KEY ("Customer_ID") REFERENCES "Customer" ("Customer_ID"),
  CONSTRAINT "Reservation_ibfk_2" FOREIGN KEY ("Package_ID") REFERENCES "Vacation_Package" ("Package_ID")
);

--
-- Table structure for table "SkiPass" (References Reservation)
--
CREATE TABLE "SkiPass" (
  "SkiPass_ID" SERIAL NOT NULL,
  "Type" varchar(64) DEFAULT NULL,
  "Valid_From" date DEFAULT NULL,
  "Valid_To" date DEFAULT NULL,
  "Reservation_ID" int DEFAULT NULL,
  PRIMARY KEY ("SkiPass_ID"),
  CONSTRAINT "SkiPass_ibfk_1" FOREIGN KEY ("Reservation_ID") REFERENCES "Reservation" ("Reservation_ID")
);

--
-- Table structure for table "Payment" (References Reservation)
--
CREATE TABLE "Payment" (
  "Payment_ID" SERIAL NOT NULL,
  "Reservation_ID" int DEFAULT NULL,
  "Amount" decimal(10,2) DEFAULT NULL,
  "Payment_Date" date DEFAULT NULL,
  PRIMARY KEY ("Payment_ID"),
  UNIQUE ("Reservation_ID"), -- Unique constraint on Reservation_ID, not an index per se
  CONSTRAINT "Payment_ibfk_1" FOREIGN KEY ("Reservation_ID") REFERENCES "Reservation" ("Reservation_ID")
);

--
-- Table structure for table "Grant_Access" (References SkiPass, Resort)
--
CREATE TABLE "Grant_Access" (
  "SkiPass_ID" int NOT NULL,
  "Resort_ID" int NOT NULL,
  PRIMARY KEY ("SkiPass_ID","Resort_ID"),
  CONSTRAINT "Grant_Access_ibfk_1" FOREIGN KEY ("SkiPass_ID") REFERENCES "SkiPass" ("SkiPass_ID"),
  CONSTRAINT "Grant_Access_ibfk_2" FOREIGN KEY ("Resort_ID") REFERENCES "Resort" ("Resort_ID")
);


-- Dumping data for tables would go here if your dump contained INSERT statements.
-- Since the provided dump only has schema, these sections are left as comments.

CREATE TABLE skipass_scans (
    time TIMESTAMPTZ NOT NULL, -- The time of the scan. TIMESTAMPTZ is recommended for time-series.
    skipass_id INT NOT NULL,  -- Corresponds to SkiPass_ID from your migrated schema.
    resort_id INT NOT NULL    -- Corresponds to Resort_ID from your migrated schema.
    -- You might want to add other columns later, like a "direction" (entry/exit) or "gate_id"
);

SELECT create_hypertable('skipass_scans', 'time');