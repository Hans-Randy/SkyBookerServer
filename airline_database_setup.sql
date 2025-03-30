-- Drop Tables
DROP TABLE Booking CASCADE CONSTRAINTS;
DROP TABLE Flight CASCADE CONSTRAINTS;
DROP TABLE Aircraft_Seat CASCADE CONSTRAINTS;
DROP TABLE CabinClass CASCADE CONSTRAINTS;
DROP TABLE Aircraft CASCADE CONSTRAINTS;
DROP TABLE Airport CASCADE CONSTRAINTS;
DROP TABLE Passenger CASCADE CONSTRAINTS;
DROP TABLE AuditLog CASCADE CONSTRAINTS;

-- Drop Sequences
DROP SEQUENCE PassengerSeq;
DROP SEQUENCE FlightSeq;
DROP SEQUENCE BookingSeq;
DROP SEQUENCE AirportSeq;
DROP SEQUENCE AircraftSeq;
DROP SEQUENCE AircraftSeatSeq;
DROP SEQUENCE AuditLogSeq;

-- Drop Procedures
DROP PROCEDURE AddPassenger;
DROP PROCEDURE UpdateFlightPrice;
DROP PROCEDURE ListFlightsByAirport;
DROP PROCEDURE GetAvailableSeats;
DROP PROCEDURE AddFlight;
DROP PROCEDURE UpdateFlight;

-- Drop Functions
DROP FUNCTION GetPassengerCount;
DROP FUNCTION GetFlightPrice;
DROP FUNCTION GetOccupiedSeatsCount;
DROP FUNCTION GetNextAvailableSeat;

-- Drop Views
DROP VIEW AircraftView;
DROP VIEW CabinClasseView;
DROP VIEW AirportView;
DROP VIEW AuditLogView;

-- Drop Package
DROP PACKAGE AirlinePackage;

-- Create Tables
CREATE TABLE Passenger (
    PassengerID NUMBER PRIMARY KEY,
    FullName VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    PhoneNumer VARCHAR2(10) NOT NULL,
	PassPortNumber VARCHAR2(10) NOT NULL
);

CREATE TABLE Airport (
    AirportID NUMBER PRIMARY KEY,
    AirportCode VARCHAR2(3) UNIQUE NOT NULL,
    AirportName VARCHAR2(100) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    Country VARCHAR2(50) NOT NULL,
    TimeZone VARCHAR2(50) NOT NULL
);

CREATE TABLE Aircraft (
    AircraftID NUMBER PRIMARY KEY,
    AircraftModel VARCHAR2(50) NOT NULL,
    Manufacturer VARCHAR2(50) NOT NULL,
    Capacity NUMBER NOT NULL,
    YearManufactured NUMBER,
    Status VARCHAR2(20) DEFAULT 'Active'
);

CREATE TABLE CabinClass (
    ClassID NUMBER PRIMARY KEY,
    ClassName VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE Aircraft_Seat (
    SeatID NUMBER PRIMARY KEY,
    AircraftID NUMBER NOT NULL REFERENCES Aircraft(AircraftID),
    ClassID NUMBER NOT NULL REFERENCES CabinClass(ClassID),
    SeatNumber VARCHAR2(5) NOT NULL,
    SeatRow NUMBER NOT NULL,
    SeatColumn CHAR(1) NOT NULL,
    IsAvailable CHAR(1) DEFAULT 'Y', -- New field to indicate seat availability
    CONSTRAINT unique_seat_per_aircraft UNIQUE (AircraftID, SeatNumber)
);

CREATE TABLE Flight (
    FlightID NUMBER PRIMARY KEY,
    FlightNumber VARCHAR2(20) UNIQUE NOT NULL,
    DepartureAirportID NUMBER REFERENCES Airport(AirportID),
    ArrivalAirportID NUMBER REFERENCES Airport(AirportID),
    AircraftID NUMBER REFERENCES Aircraft(AircraftID),
    DepartureDateTime TIMESTAMP NOT NULL,
    ArrivalDateTime TIMESTAMP NOT NULL,
    Price NUMBER(10, 2) NOT NULL
);

CREATE TABLE Booking (
    BookingID NUMBER PRIMARY KEY,
    PassengerID NUMBER REFERENCES Passenger(PassengerID),
    FlightID NUMBER REFERENCES Flight(FlightID),
    SeatID NUMBER REFERENCES Aircraft_Seat(SeatID),
    BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR2(20) DEFAULT 'Confirmed'
);

CREATE TABLE AuditLog (
    AuditID NUMBER PRIMARY KEY,
    TableName VARCHAR2(100),
    ColumnName VARCHAR2(100),
    RecordID NUMBER,
    OldValue VARCHAR2(4000),
    NewValue VARCHAR2(4000),
    ModifiedBy VARCHAR2(100),
    ModifiedAt TIMESTAMP DEFAULT SYSTIMESTAMP
);


-- Insert Values
INSERT INTO Passenger VALUES (1, 'Alice Smith', 'alice.smith@google.com', '1234567890', 'AS123456');
INSERT INTO Passenger VALUES (2, 'Bob Johnson', 'bob.johnson@google.com', '9876543210', 'BJ789012');
INSERT INTO Passenger VALUES (3, 'Charlie Brown', 'charlie.brown@google.com', '4567890123', 'CB345678');
INSERT INTO Passenger VALUES (4, 'Diana Miller', 'diana.miller@google.com', '3210987654', 'DM901234');
INSERT INTO Passenger VALUES (5, 'Ethan Davis', 'ethan.davis@google.com', '6543210987', 'ED567890');
INSERT INTO Passenger VALUES (6, 'Fiona Wilson', 'fiona.wilson@google.com', '7890123456', 'FW123450');
INSERT INTO Passenger VALUES (7, 'George Moore', 'george.moore@google.com', '2345678901', 'GM678901');
INSERT INTO Passenger VALUES (8, 'Hannah Taylor', 'hannah.taylor@google.com', '8765432109', 'HT234567');
INSERT INTO Passenger VALUES (9, 'Isaac Anderson', 'isaac.anderson@google.com', '5678901234', 'IA890123');
INSERT INTO Passenger VALUES (10, 'Julia White', 'julia.white@google.com', '0987654321', 'JW456789');
COMMIT;

INSERT INTO Airport VALUES (1, 'JFK', 'John F. Kennedy International Airport', 'New York', 'USA', 'UTC-5');
INSERT INTO Airport VALUES (2, 'LHR', 'Heathrow Airport', 'London', 'United Kingdom', 'UTC+0');
INSERT INTO Airport VALUES (3, 'CDG', 'Charles de Gaulle Airport', 'Paris', 'France', 'UTC+1');
INSERT INTO Airport VALUES (4, 'DXB', 'Dubai International Airport', 'Dubai', 'UAE', 'UTC+4');
INSERT INTO Airport VALUES (5, 'SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia', 'UTC+10');
INSERT INTO Airport VALUES (6, 'HND', 'Haneda Airport', 'Tokyo', 'Japan', 'UTC+9');
INSERT INTO Airport VALUES (7, 'SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore', 'UTC+8');
INSERT INTO Airport VALUES (8, 'FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany', 'UTC+1');
INSERT INTO Airport VALUES (9, 'IST', 'Istanbul Airport', 'Istanbul', 'Turkey', 'UTC+3');
INSERT INTO Airport VALUES (10, 'LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA', 'UTC-8');
COMMIT;

INSERT INTO Aircraft VALUES (1, 'Boeing 777-300ER', 'Boeing', 368, 2018, 'Active');
INSERT INTO Aircraft VALUES (2, 'Airbus A350-1000', 'Airbus', 351, 2020, 'Active');
INSERT INTO Aircraft VALUES (3, 'Boeing 787-9', 'Boeing', 298, 2019, 'Active');
INSERT INTO Aircraft VALUES (4, 'Airbus A380-800', 'Airbus', 517, 2016, 'Active');
INSERT INTO Aircraft VALUES (5, 'Boeing 737-800', 'Boeing', 189, 2017, 'Maintenance');
INSERT INTO Aircraft VALUES (6, 'Airbus A320neo', 'Airbus', 186, 2021, 'Active');
INSERT INTO Aircraft VALUES (7, 'Boeing 747-8', 'Boeing', 410, 2015, 'Active');
INSERT INTO Aircraft VALUES (8, 'Airbus A330-300', 'Airbus', 287, 2014, 'Active');
INSERT INTO Aircraft VALUES (9, 'Boeing 767-300ER', 'Boeing', 261, 2013, 'Retired');
INSERT INTO Aircraft VALUES (10, 'Airbus A321XLR', 'Airbus', 220, 2023, 'Active');
COMMIT;

INSERT INTO CabinClass VALUES (1, 'Economy');
INSERT INTO CabinClass VALUES (2, 'Business');
COMMIT;

INSERT INTO Aircraft_Seat VALUES (1, 1, 1, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (2, 2, 1, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (3, 3, 1, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (4, 4, 1, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (5, 5, 1, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (6, 6, 2, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (7, 7, 2, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (8, 8, 2, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (9, 9, 2, '1A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (10, 10, 2, '1A', 1, 'A', 'Y');

INSERT INTO Aircraft_Seat VALUES (11, 1, 1, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (12, 2, 1, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (13, 3, 1, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (14, 4, 1, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (15, 5, 1, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (16, 6, 2, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (17, 7, 2, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (18, 8, 2, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (19, 9, 2, '2A', 1, 'A', 'Y');
INSERT INTO Aircraft_Seat VALUES (20, 10, 2, '2A', 1, 'A', 'Y');
COMMIT;

INSERT INTO Flight  VALUES (1, 'UA201', 1, 2, 1, TO_TIMESTAMP('2025-03-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-16 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1500.00);
INSERT INTO Flight  VALUES (2, 'BA302', 2, 3, 2, TO_TIMESTAMP('2025-03-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 400.00);
INSERT INTO Flight  VALUES (3, 'AF403', 3, 4, 3, TO_TIMESTAMP('2025-03-17 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 900.00);
INSERT INTO Flight  VALUES (4, 'EK504', 4, 5, 4, TO_TIMESTAMP('2025-03-18 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-18 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1800.00);
INSERT INTO Flight  VALUES (5, 'QF605', 5, 6, 5, TO_TIMESTAMP('2025-03-19 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-19 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1600.00);
INSERT INTO Flight  VALUES (6, 'JL706', 6, 7, 6, TO_TIMESTAMP('2025-03-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-20 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 700.00);
INSERT INTO Flight  VALUES (7, 'SQ807', 7, 8, 7, TO_TIMESTAMP('2025-03-21 01:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-21 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 800.00);
INSERT INTO Flight  VALUES (8, 'LH908', 8, 9, 8, TO_TIMESTAMP('2025-03-22 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-22 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 500.00);
INSERT INTO Flight  VALUES (9, 'TK109', 9, 10, 9, TO_TIMESTAMP('2025-03-23 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-23 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 600.00);
INSERT INTO Flight  VALUES (10, 'AA110', 10, 1, 10, TO_TIMESTAMP('2025-03-24 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-25 03:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1400.00);
COMMIT;

INSERT INTO Booking VALUES (1, 1, 1, 1, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (2, 2, 2, 9, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (3, 3, 3, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (4, 4, 4, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (5, 5, 5, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (6, 6, 6, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (7, 7, 7, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (8, 8, 8, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (9, 9, 9, NULL, CURRENT_TIMESTAMP, 'Confirmed');
INSERT INTO Booking VALUES (10, 10, 10, NULL, CURRENT_TIMESTAMP, 'Cancelled');
COMMIT;

-- Create Sequences
CREATE SEQUENCE PassengerSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE FlightSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE BookingSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE AirportSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE AircraftSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE AircraftSeatSeq START WITH 11 INCREMENT BY 1;
CREATE SEQUENCE AuditLogSeq START WITH 1 INCREMENT BY 1;

-- Create Indexes
CREATE INDEX idx_Passenger_FullName ON Passenger(FullName);
CREATE INDEX idx_Flight_DepartureAirportID ON Flight(DepartureAirportID);
CREATE INDEX idx_Flight_ArrivalAirportID ON Flight(ArrivalAirportID);
CREATE INDEX idx_Airport_City ON Airport(City);
CREATE INDEX idx_Aircraft_Model ON Aircraft(AircraftModel);
CREATE INDEX idx_Aircraft_Status ON Aircraft(Status);
CREATE INDEX idx_Aircraft_Seat_Aircraft ON Aircraft_Seat(AircraftID);
CREATE INDEX idx_Aircraft_Seat_Class ON Aircraft_Seat(ClassID);
CREATE INDEX idx_AuditLog_TableName ON AuditLog(TableName);

-- Create Triggers
CREATE OR REPLACE TRIGGER trg_AuditLog_Passenger
AFTER INSERT OR UPDATE OR DELETE ON Passenger
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Passenger', NULL, :NEW.PassengerID, NULL, 'New Passenger Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Passenger', NULL, :OLD.PassengerID, 'Passenger Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN

        -- Check if FullName changed
        IF :OLD.FullName <> :NEW.FullName THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Passenger', 'FullName', :OLD.PassengerID, :OLD.FullName, :NEW.FullName, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Email changed
        IF :OLD.Email <> :NEW.Email THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Passenger', 'Email', :OLD.PassengerID, :OLD.Email, :NEW.Email, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if PhoneNumer changed
        IF :OLD.PhoneNumer <> :NEW.PhoneNumer THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Passenger', 'PhoneNumer', :OLD.PassengerID, :OLD.PhoneNumer, :NEW.PhoneNumer, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if PassPortNumber changed
        IF :OLD.PassPortNumber <> :NEW.PassPortNumber THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Passenger', 'PassPortNumber', :OLD.PassengerID, :OLD.PassPortNumber, :NEW.PassPortNumber, v_User, SYSTIMESTAMP);
        END IF;

    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_AuditLog_Booking
AFTER INSERT OR UPDATE OR DELETE ON Booking
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Booking', NULL, :NEW.BookingID, NULL, 'New Booking Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Booking', NULL, :OLD.BookingID, 'Booking Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN

        -- Check if FlightID changed
        IF :OLD.FlightID <> :NEW.FlightID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Booking', 'FlightID', :OLD.BookingID, :OLD.FlightID, :NEW.FlightID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if PassengerID changed
        IF :OLD.PassengerID <> :NEW.PassengerID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Booking', 'PassengerID', :OLD.BookingID, :OLD.PassengerID, :NEW.PassengerID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if SeatID changed
        IF :OLD.SeatID <> :NEW.SeatID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Booking', 'SeatID', :OLD.BookingID, :OLD.SeatID, :NEW.SeatID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Status changed
        IF :OLD.Status <> :NEW.Status THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Booking', 'Status', :OLD.BookingID, :OLD.Status, :NEW.Status, v_User, SYSTIMESTAMP);
        END IF;

    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_AuditLog_Flight
AFTER INSERT OR UPDATE OR DELETE ON Flight
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Flight', NULL, :NEW.FlightID, NULL, 'New Flight Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Flight', NULL, :OLD.FlightID, 'Flight Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN

        -- Check if FlightNumber changed
        IF :OLD.FlightNumber <> :NEW.FlightNumber THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'FlightNumber', :OLD.FlightID, :OLD.FlightNumber, :NEW.FlightNumber, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if DepartureAirportID changed
        IF :OLD.DepartureAirportID <> :NEW.DepartureAirportID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'DepartureAirportID', :OLD.FlightID, :OLD.DepartureAirportID, :NEW.DepartureAirportID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if ArrivalAirportID changed
        IF :OLD.ArrivalAirportID <> :NEW.ArrivalAirportID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'ArrivalAirportID', :OLD.FlightID, :OLD.ArrivalAirportID, :NEW.ArrivalAirportID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if AircraftID changed
        IF :OLD.AircraftID <> :NEW.AircraftID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'AircraftID', :OLD.FlightID, :OLD.AircraftID, :NEW.AircraftID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if DepartureDateTime changed
        IF :OLD.DepartureDateTime <> :NEW.DepartureDateTime THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'DepartureDateTime', :OLD.FlightID, :OLD.DepartureDateTime, :NEW.DepartureDateTime, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if ArrivalDateTime changed
        IF :OLD.ArrivalDateTime <> :NEW.ArrivalDateTime THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'ArrivalDateTime', :OLD.FlightID, :OLD.ArrivalDateTime, :NEW.ArrivalDateTime, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Price changed
        IF :OLD.Price <> :NEW.Price THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Flight', 'Price', :OLD.FlightID, :OLD.Price, :NEW.Price, v_User, SYSTIMESTAMP);
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_AuditLog_Aircraft_Seat
AFTER INSERT OR UPDATE OR DELETE ON Aircraft_Seat
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', NULL, :NEW.SeatID, NULL, 'Air Craft Seat Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', NULL, :OLD.SeatID, 'Air Craft Seat Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN
        -- Check if AircraftID changed
        IF :OLD.AircraftID <> :NEW.AircraftID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'AircraftID', :OLD.SeatID, :OLD.AircraftID, :NEW.AircraftID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if ClassID changed
        IF :OLD.ClassID <> :NEW.ClassID THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'ClassID', :OLD.SeatID, :OLD.ClassID, :NEW.ClassID, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if SeatNumber changed
        IF :OLD.SeatNumber <> :NEW.SeatNumber THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'SeatNumber', :OLD.SeatID, :OLD.SeatNumber, :NEW.SeatNumber, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if SeatRow changed
        IF :OLD.SeatRow <> :NEW.SeatRow THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'SeatRow', :OLD.SeatID, :OLD.SeatRow, :NEW.SeatRow, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if SeatColumn changed
        IF :OLD.SeatColumn <> :NEW.SeatColumn THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'SeatColumn', :OLD.SeatID, :OLD.SeatColumn, :NEW.SeatColumn, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if IsAvailable changed
        IF :OLD.IsAvailable <> :NEW.IsAvailable THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft_Seat', 'IsAvailable', :OLD.SeatID, :OLD.IsAvailable, :NEW.IsAvailable, v_User, SYSTIMESTAMP);
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_AuditLog_Aircraft
AFTER INSERT OR UPDATE OR DELETE ON Aircraft
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', NULL, :NEW.AircraftID, NULL, 'Air Craft Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', NULL, :OLD.AircraftID, 'Air Craft Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN
        -- Check if AircraftModel changed
        IF :OLD.AircraftModel <> :NEW.AircraftModel THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', 'AircraftModel', :OLD.AircraftID, :OLD.AircraftModel, :NEW.AircraftModel, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Manufacturer changed
        IF :OLD.Manufacturer <> :NEW.Manufacturer THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', 'Manufacturer', :OLD.AircraftID, :OLD.Manufacturer, :NEW.Manufacturer, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Capacity changed
        IF :OLD.Capacity <> :NEW.Capacity THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', 'Capacity', :OLD.AircraftID, :OLD.Capacity, :NEW.Capacity, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if YearManufactured changed
        IF :OLD.YearManufactured <> :NEW.YearManufactured THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', 'YearManufactured', :OLD.AircraftID, :OLD.YearManufactured, :NEW.YearManufactured, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Status changed
        IF :OLD.Status <> :NEW.Status THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Aircraft', 'Status', :OLD.AircraftID, :OLD.Status, :NEW.Status, v_User, SYSTIMESTAMP);
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_AuditLog_Airport
AFTER INSERT OR UPDATE OR DELETE ON Airport
FOR EACH ROW
DECLARE
    v_User VARCHAR2(100);
BEGIN
    -- Get the user performing the operation
    SELECT USER INTO v_User FROM DUAL;

    -- Log INSERT operation
    IF INSERTING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Airport', NULL, :NEW.AirportID, NULL, 'Airport Created', v_User, SYSTIMESTAMP);

    -- Log DELETE operation
    ELSIF DELETING THEN
        INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
        VALUES (AuditLogSeq.NEXTVAL, 'Airport', NULL, :OLD.AirportID, 'Airport Removed', NULL, v_User, SYSTIMESTAMP);

    -- Log UPDATE operation for each column
    ELSIF UPDATING THEN
        -- Check if AirportCode changed
        IF :OLD.AirportCode <> :NEW.AirportCode THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Airport', 'AirportCode', :OLD.AirportID, :OLD.AirportCode, :NEW.AirportCode, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if AirportName changed
        IF :OLD.AirportName <> :NEW.AirportName THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Airport', 'AirportName', :OLD.AirportID, :OLD.AirportName, :NEW.AirportName, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if City changed
        IF :OLD.City <> :NEW.City THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Airport', 'City', :OLD.AirportID, :OLD.City, :NEW.City, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if Country changed
        IF :OLD.Country <> :NEW.Country THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Airport', 'Country', :OLD.AirportID, :OLD.Country, :NEW.Country, v_User, SYSTIMESTAMP);
        END IF;

        -- Check if TimeZone changed
        IF :OLD.TimeZone <> :NEW.TimeZone THEN
            INSERT INTO AuditLog (AuditID, TableName, ColumnName, RecordID, OldValue, NewValue, ModifiedBy, ModifiedAt)
            VALUES (AuditLogSeq.NEXTVAL, 'Airport', 'TimeZone', :OLD.AirportID, :OLD.TimeZone, :NEW.TimeZone, v_User, SYSTIMESTAMP);
        END IF;
    END IF;
END;
/

-- Create Procedures
CREATE OR REPLACE PROCEDURE AddPassenger(
    p_FullName IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_PhoneNumber IN VARCHAR2,
	p_PassportNumber IN VARCHAR2
) IS
BEGIN
    INSERT INTO Passenger(PassengerID, FullName, Email, PhoneNumer, PassPortNumber)
    VALUES (PassengerSeq.NEXTVAL, p_FullName, p_Email, p_PhoneNumber, p_PassportNumber);
END;
/

CREATE OR REPLACE PROCEDURE UpdateFlightPrice(
    p_FlightID IN NUMBER,
    p_NewPrice IN NUMBER
) IS
BEGIN
    UPDATE Flight SET Price = p_NewPrice WHERE FlightID = p_FlightID;
END;
/

CREATE OR REPLACE FUNCTION GetNextAvailableSeat (
    p_FlightID NUMBER
) RETURN NUMBER IS
    v_SeatID NUMBER;
BEGIN
    -- Find the first available seat for the given flight
    SELECT ast.SeatID INTO v_SeatID
    FROM Aircraft_Seat ast
    JOIN Aircraft a ON ast.AircraftID = a.AircraftID
    JOIN Flight f ON f.AircraftID = a.AircraftID
    WHERE f.FlightID = p_FlightID
      AND ast.IsAvailable = 'Y'
    FETCH FIRST 1 ROWS ONLY;

    -- Return the available SeatID
    RETURN v_SeatID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No available seats for this flight.');
    WHEN OTHERS THEN
        RAISE;
END GetNextAvailableSeat;
/

CREATE OR REPLACE PROCEDURE ListFlightsByAirport(
    p_AirportID IN NUMBER,
    p_FlightCursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_FlightCursor FOR
        SELECT FlightNumber, DepartureDateTime, ArrivalDateTime, Price
        FROM Flight
        WHERE DepartureAirportID = p_AirportID;
END;
/

-- Create Functions
CREATE OR REPLACE FUNCTION GetPassengerCount RETURN NUMBER IS
    v_Count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_Count FROM Passenger;
    RETURN v_Count;
END;
/

CREATE OR REPLACE FUNCTION GetFlightPrice(p_FlightID IN NUMBER) RETURN NUMBER IS
    v_Price NUMBER;
BEGIN
    SELECT Price INTO v_Price FROM Flight WHERE FlightID = p_FlightID;
    RETURN v_Price;
END;
/

CREATE OR REPLACE FUNCTION GetOccupiedSeatsCount(p_FlightID IN NUMBER) RETURN NUMBER IS
    v_Count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_Count
    FROM Aircraft_Seat s
    JOIN Flight f ON s.AircraftID = f.AircraftID
    WHERE f.FlightID = p_FlightID
    AND s.IsAvailable = 'N';
    
    RETURN v_Count;
END;
/

CREATE OR REPLACE VIEW AircraftView AS 
SELECT AircraftID, AircraftModel
FROM Aircraft
ORDER BY AircraftModel;

CREATE OR REPLACE VIEW CabinClasseView AS
-- Return available cabin classes
SELECT ClassID, ClassName
FROM CabinClass
ORDER BY ClassName;

CREATE OR REPLACE VIEW AuditLogView AS
SELECT 
    AuditID,
    TableName,
    COALESCE(ColumnName, 'N/A') AS ColumnName, -- If NULL, show 'N/A'
    RecordID,
    COALESCE(OldValue, 'N/A') AS OldValue,
    COALESCE(NewValue, 'N/A') AS NewValue,
    ModifiedBy,
    TO_CHAR(ModifiedAt, 'YYYY-MM-DD HH24:MI:SS') AS ModifiedAt
FROM AuditLog
ORDER BY ModifiedAt DESC;

CREATE OR REPLACE PROCEDURE GetAvailableSeats (
    p_FlightID NUMBER, p_Cursor OUT SYS_REFCURSOR
) IS
BEGIN
    -- Return available seats for the selected flight
    OPEN p_Cursor FOR
    SELECT ast.SeatID, ast.SeatNumber, ast.SeatRow, ast.SeatColumn
    FROM Aircraft_Seat ast
    JOIN Aircraft a ON ast.AircraftID = a.AircraftID
    JOIN Flight f ON f.AircraftID = a.AircraftID
    WHERE f.FlightID = p_FlightID
      AND ast.IsAvailable = 'Y'
    ORDER BY ast.SeatRow, ast.SeatColumn;
END;
/

CREATE OR REPLACE VIEW AirportView AS
-- Return all airports for dropdown selection
SELECT AirportID, AirportName || ' (' || AirportCode || ')' AS AirportDisplay
FROM Airport
ORDER BY AirportName;

CREATE OR REPLACE PROCEDURE AddFlight (
    p_FlightNumber VARCHAR2,
    p_DepartureAirportID NUMBER,
    p_ArrivalAirportID NUMBER,
    p_AircraftID NUMBER,
    p_DepartureDateTime TIMESTAMP,
    p_ArrivalDateTime TIMESTAMP,
    p_Price NUMBER
) AS
BEGIN
    INSERT INTO Flight (FlightID, FlightNumber, DepartureAirportID, ArrivalAirportID, AircraftID, DepartureDateTime, ArrivalDateTime, Price)
    VALUES (FlightSeq.NEXTVAL, p_FlightNumber, p_DepartureAirportID, p_ArrivalAirportID, p_AircraftID, p_DepartureDateTime, p_ArrivalDateTime, p_Price); 
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
END;
/

CREATE OR REPLACE PROCEDURE UpdateFlight (
    p_FlightID NUMBER,
    p_FlightNumber VARCHAR2,
    p_DepartureAirportID NUMBER,
    p_ArrivalAirportID NUMBER,
    p_DepartureDateTime TIMESTAMP,
    p_ArrivalDateTime TIMESTAMP,
    p_Price NUMBER
) AS
BEGIN
    UPDATE Flight
    SET FlightNumber = p_FlightNumber,
        DepartureAirportID = p_DepartureAirportID,
        ArrivalAirportID = p_ArrivalAirportID,
        DepartureDateTime = p_DepartureDateTime,
        ArrivalDateTime = p_ArrivalDateTime,
        Price = p_Price
    WHERE FlightID = p_FlightID;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
END;
/

CREATE OR REPLACE PROCEDURE UpdateBooking (
    p_BookingID NUMBER,
    p_NewSeatID NUMBER,
    p_Status VARCHAR2
) AS
    v_OldSeatID NUMBER;
BEGIN
    -- Get the current seat assigned
    SELECT SeatID INTO v_OldSeatID
    FROM Booking
    WHERE BookingID = p_BookingID;

    -- Free the old seat
    UPDATE Aircraft_Seat SET IsAvailable = 'Y' WHERE SeatID = v_OldSeatID;

    -- Assign the new seat and update status
    UPDATE Booking
    SET SeatID = p_NewSeatID,
        Status = p_Status
    WHERE BookingID = p_BookingID;

    -- Mark the new seat as unavailable
    UPDATE Aircraft_Seat SET IsAvailable = 'N' WHERE SeatID = p_NewSeatID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Booking not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Create Package for Procedures and Functions
CREATE OR REPLACE PACKAGE AirlinePackage IS
    g_LastBookingID NUMBER := 0;    

    -- Define a record type
    TYPE FlightRecord IS RECORD (
        FlightID Flight.FlightID%TYPE,
        FlightNumber Flight.FlightNumber%TYPE,
        DepartureAirportID Flight.DepartureAirportID%TYPE,
        DepartureAirport Airport.AirportName%TYPE,  
        DepartureCity Airport.City%TYPE, 
        ArrivalAirportID Flight.ArrivalAirportID%TYPE,
        ArrivalAirport Airport.AirportName%TYPE,    
        ArrivalCity Airport.City%TYPE, 
        DepartureDateTime Flight.DepartureDateTime%TYPE,
        ArrivalDateTime Flight.ArrivalDateTime%TYPE,
        Price Flight.Price%TYPE,
        AircraftID Flight.AircraftID%TYPE,
        AircraftModel Aircraft.AircraftModel%TYPE
    );

    -- Define a strongly-typed REF CURSOR for flight results
    TYPE FlightCursorType IS REF CURSOR RETURN FlightRecord;
    
    PROCEDURE AddPassenger(p_FullName IN VARCHAR2, p_Email IN VARCHAR2, p_PhoneNumber IN VARCHAR2, p_PassportNumber IN VARCHAR2);
    PROCEDURE UpdateFlightPrice(p_FlightID IN NUMBER, p_NewPrice IN NUMBER);
    FUNCTION GetNextAvailableSeat (p_FlightID NUMBER) RETURN NUMBER;
    PROCEDURE AddBooking(p_FlightNumber VARCHAR2, p_DepartureAirportID NUMBER, p_ArrivalAirportID NUMBER, p_AircraftID NUMBER, p_DepartureDateTime TIMESTAMP, p_ArrivalDateTime TIMESTAMP, p_Price NUMBER, p_PassengerID IN NUMBER, p_SeatID IN NUMBER DEFAULT NULL, p_Status IN VARCHAR2 DEFAULT 'Confirmed');
    PROCEDURE AddBooking(p_PassengerID IN NUMBER, p_FlightID IN NUMBER, p_SeatID IN NUMBER DEFAULT NULL, p_Status IN VARCHAR2 DEFAULT 'Confirmed');
    PROCEDURE ListFlightsByAirport(p_AirportID IN NUMBER, p_FlightCursor OUT SYS_REFCURSOR);
    
    -- Overloaded SearchFlights procedures that return REF CURSOR
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ResultCursor OUT FlightCursorType);
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ArrivalAirportID IN NUMBER, p_ResultCursor OUT FlightCursorType);
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_DepartureDateTime IN TIMESTAMP, p_ResultCursor OUT FlightCursorType);
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ArrivalAirportID IN NUMBER, p_DepartureDateTime IN TIMESTAMP, p_ResultCursor OUT FlightCursorType);
    
    FUNCTION GetPassengerCount RETURN NUMBER;
    FUNCTION GetFlightPrice(p_FlightID IN NUMBER) RETURN NUMBER;
    FUNCTION GetOccupiedSeatsCount(p_FlightID IN NUMBER) RETURN NUMBER;

    PROCEDURE GetAvailableSeats (p_FlightID NUMBER, p_Cursor OUT SYS_REFCURSOR); 
    PROCEDURE AddFlight (p_FlightNumber VARCHAR2, p_DepartureAirportID NUMBER, p_ArrivalAirportID NUMBER, p_AircraftID NUMBER, p_DepartureDateTime TIMESTAMP, p_ArrivalDateTime TIMESTAMP, p_Price NUMBER);
    PROCEDURE UpdateFlight (p_FlightID NUMBER, p_FlightNumber VARCHAR2, p_DepartureAirportID NUMBER, p_ArrivalAirportID NUMBER, p_DepartureDateTime TIMESTAMP, p_ArrivalDateTime TIMESTAMP, p_Price NUMBER);
    PROCEDURE UpdateBooking (p_BookingID NUMBER, p_NewSeatID NUMBER, p_Status VARCHAR2);
END AirlinePackage;
/

CREATE OR REPLACE PACKAGE BODY AirlinePackage IS

    PROCEDURE AddPassenger(p_FullName IN VARCHAR2, p_Email IN VARCHAR2, p_PhoneNumber IN VARCHAR2, p_PassportNumber IN VARCHAR2) IS
    BEGIN
        INSERT INTO Passenger(PassengerID, FullName, Email, PhoneNumer, PassPortNumber)
        VALUES (PassengerSeq.NEXTVAL, p_FullName, p_Email, p_PhoneNumber, p_PassportNumber);
    END;

    PROCEDURE UpdateFlightPrice(p_FlightID IN NUMBER, p_NewPrice IN NUMBER) IS
    BEGIN
        UPDATE Flight SET Price = p_NewPrice WHERE FlightID = p_FlightID;
    END;

    FUNCTION GetNextAvailableSeat (p_FlightID NUMBER) RETURN NUMBER 
    IS
        v_SeatID NUMBER;
    BEGIN
        -- Find the first available seat for the given flight
        SELECT ast.SeatID INTO v_SeatID
        FROM Aircraft_Seat ast
        JOIN Aircraft a ON ast.AircraftID = a.AircraftID
        JOIN Flight f ON f.AircraftID = a.AircraftID
        WHERE f.FlightID = p_FlightID
        AND ast.IsAvailable = 'Y'
        FETCH FIRST 1 ROWS ONLY;

        -- Return the available SeatID
        RETURN v_SeatID;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'No available seats for this flight.');
            WHEN OTHERS THEN
                RAISE;
    END GetNextAvailableSeat;

    PROCEDURE AddBooking(p_PassengerID IN NUMBER, p_FlightID IN NUMBER, p_SeatID IN NUMBER DEFAULT NULL, p_Status IN VARCHAR2 DEFAULT 'Confirmed') IS
    BEGIN
        INSERT INTO Booking(BookingID, PassengerID, FlightID, SeatID, BookingDate, Status)
        VALUES (BookingSeq.NEXTVAL, p_PassengerID, p_FlightID, p_SeatID, CURRENT_TIMESTAMP, p_Status);
        g_LastBookingID := BookingSeq.CURRVAL;
        
        -- Update seat availability if a seat is assigned
        IF p_SeatID IS NOT NULL THEN
            UPDATE Aircraft_Seat 
            SET IsAvailable = 'N'
            WHERE SeatID = p_SeatID;
        END IF;
    END;

    PROCEDURE AddBooking(    
        p_FlightNumber VARCHAR2,
        p_DepartureAirportID NUMBER,
        p_ArrivalAirportID NUMBER,
        p_AircraftID NUMBER,
        p_DepartureDateTime TIMESTAMP,
        p_ArrivalDateTime TIMESTAMP,
        p_Price NUMBER,
        p_PassengerID IN NUMBER, 
        p_SeatID IN NUMBER DEFAULT NULL, 
        p_Status IN VARCHAR2 DEFAULT 'Confirmed') IS
    BEGIN
        INSERT INTO Flight (FlightID, FlightNumber, DepartureAirportID, ArrivalAirportID, AircraftID, DepartureDateTime, ArrivalDateTime, Price)
        VALUES (FlightSeq.NEXTVAL, p_FlightNumber, p_DepartureAirportID, p_ArrivalAirportID, p_AircraftID, p_DepartureDateTime, p_ArrivalDateTime, p_Price); 

        INSERT INTO Booking(BookingID, PassengerID, FlightID, SeatID, BookingDate, Status)
        VALUES (BookingSeq.NEXTVAL, p_PassengerID, FlightSeq.CURRVAL, p_SeatID, CURRENT_TIMESTAMP, p_Status);
        g_LastBookingID := BookingSeq.CURRVAL;
        
        -- Update seat availability if a seat is assigned
        IF p_SeatID IS NOT NULL THEN
            UPDATE Aircraft_Seat 
            SET IsAvailable = 'N'
            WHERE SeatID = p_SeatID;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END;

    PROCEDURE ListFlightsByAirport(
        p_AirportID IN NUMBER,
        p_FlightCursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_FlightCursor FOR
            SELECT FlightNumber, DepartureDateTime, ArrivalDateTime, Price
            FROM Flight
            WHERE DepartureAirportID = p_AirportID;
    END;

    -- Search for flights from departure airport only
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ResultCursor OUT FlightCursorType) IS
    BEGIN
        OPEN p_ResultCursor FOR
            SELECT f.FlightID, 
                   f.FlightNumber, 
                   f.DepartureAirportID,
                   dep.AirportName AS DepartureAirport, 
                   dep.City AS DepartureCity,
                   f.ArrivalAirportID,
                   arr.AirportName AS ArrivalAirport,
                   arr.City AS ArrivalCity,
                   f.DepartureDateTime, 
                   f.ArrivalDateTime, 
                   f.Price,
                   f.AircraftID,
                   ac.AircraftModel
            FROM Flight f
            JOIN Airport dep ON f.DepartureAirportID = dep.AirportID
            JOIN Airport arr ON f.ArrivalAirportID = arr.AirportID
            JOIN Aircraft ac ON f.AircraftID = ac.AircraftID
            WHERE f.DepartureAirportID = p_DepartureAirportID
            ORDER BY f.DepartureDateTime;
    END;
    
    -- Search for flights between two airports
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ArrivalAirportID IN NUMBER, p_ResultCursor OUT FlightCursorType) IS
    BEGIN
        OPEN p_ResultCursor FOR
            SELECT f.FlightID, 
                   f.FlightNumber, 
                   f.DepartureAirportID,
                   dep.AirportCode AS DepartureAirport, 
                   dep.City AS DepartureCity,
                   f.ArrivalAirportID,
                   arr.AirportCode AS ArrivalAirport,
                   arr.City AS ArrivalCity,
                   f.DepartureDateTime, 
                   f.ArrivalDateTime, 
                   f.Price,
                   f.AircraftID,
                   ac.AircraftModel
            FROM Flight f
            JOIN Airport dep ON f.DepartureAirportID = dep.AirportID
            JOIN Airport arr ON f.ArrivalAirportID = arr.AirportID
            JOIN Aircraft ac ON f.AircraftID = ac.AircraftID
            WHERE f.DepartureAirportID = p_DepartureAirportID
            AND f.ArrivalAirportID = p_ArrivalAirportID
            ORDER BY f.DepartureDateTime;
    END;
    
    -- Search for flights from departure airport on a specific date
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_DepartureDateTime IN TIMESTAMP, p_ResultCursor OUT FlightCursorType) IS
    BEGIN
        OPEN p_ResultCursor FOR
            SELECT f.FlightID, 
                   f.FlightNumber, 
                   f.DepartureAirportID,
                   dep.AirportCode AS DepartureAirport, 
                   dep.City AS DepartureCity,
                   f.ArrivalAirportID,
                   arr.AirportCode AS ArrivalAirport,
                   arr.City AS ArrivalCity,
                   f.DepartureDateTime, 
                   f.ArrivalDateTime, 
                   f.Price,
                   f.AircraftID,
                   ac.AircraftModel
            FROM Flight f
            JOIN Airport dep ON f.DepartureAirportID = dep.AirportID
            JOIN Airport arr ON f.ArrivalAirportID = arr.AirportID
            JOIN Aircraft ac ON f.AircraftID = ac.AircraftID
            WHERE f.DepartureAirportID = p_DepartureAirportID
            AND TRUNC(f.DepartureDateTime) = TRUNC(p_DepartureDateTime)
            ORDER BY f.DepartureDateTime;
    END;
    
    -- Search for flights between two airports on a specific date
    PROCEDURE SearchFlights(p_DepartureAirportID IN NUMBER, p_ArrivalAirportID IN NUMBER, p_DepartureDateTime IN TIMESTAMP, p_ResultCursor OUT FlightCursorType) IS
    BEGIN
        OPEN p_ResultCursor FOR
            SELECT f.FlightID, 
                   f.FlightNumber, 
                   f.DepartureAirportID,
                   dep.AirportCode AS DepartureAirport, 
                   dep.City AS DepartureCity,
                   f.ArrivalAirportID,
                   arr.AirportCode AS ArrivalAirport,
                   arr.City AS ArrivalCity,
                   f.DepartureDateTime, 
                   f.ArrivalDateTime, 
                   f.Price,
                   f.AircraftID,
                   ac.AircraftModel
            FROM Flight f
            JOIN Airport dep ON f.DepartureAirportID = dep.AirportID
            JOIN Airport arr ON f.ArrivalAirportID = arr.AirportID
            JOIN Aircraft ac ON f.AircraftID = ac.AircraftID
            WHERE f.DepartureAirportID = p_DepartureAirportID
            AND f.ArrivalAirportID = p_ArrivalAirportID
            AND TRUNC(f.DepartureDateTime) = TRUNC(p_DepartureDateTime)
            ORDER BY f.DepartureDateTime;
    END;

    FUNCTION GetPassengerCount RETURN NUMBER IS
        v_Count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_Count FROM Passenger;
        RETURN v_Count;
    END;

    FUNCTION GetFlightPrice(p_FlightID IN NUMBER) RETURN NUMBER IS
        v_Price NUMBER;
    BEGIN
        SELECT Price INTO v_Price FROM Flight WHERE FlightID = p_FlightID;
        RETURN v_Price;
    END;
    
    FUNCTION GetOccupiedSeatsCount(p_FlightID IN NUMBER) RETURN NUMBER IS
        v_Count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_Count
        FROM Aircraft_Seat s
        JOIN Flight f ON s.AircraftID = f.AircraftID
        WHERE f.FlightID = p_FlightID
        AND s.IsAvailable = 'N';
        
        RETURN v_Count;
    END;
    PROCEDURE GetAvailableSeats (p_FlightID NUMBER, p_Cursor OUT SYS_REFCURSOR) IS
    BEGIN
        -- Return available seats for the selected flight
        OPEN p_Cursor FOR
        SELECT ast.SeatID, ast.SeatNumber, ast.SeatRow, ast.SeatColumn
        FROM Aircraft_Seat ast
        JOIN Aircraft a ON ast.AircraftID = a.AircraftID
        JOIN Flight f ON f.AircraftID = a.AircraftID
        WHERE f.FlightID = p_FlightID
        AND ast.IsAvailable = 'Y'
        ORDER BY ast.SeatRow, ast.SeatColumn;
    END;

    PROCEDURE AddFlight (
        p_FlightNumber VARCHAR2,
        p_DepartureAirportID NUMBER,
        p_ArrivalAirportID NUMBER,
        p_AircraftID NUMBER,
        p_DepartureDateTime TIMESTAMP,
        p_ArrivalDateTime TIMESTAMP,
        p_Price NUMBER
    ) AS
    BEGIN
        INSERT INTO Flight (FlightID, FlightNumber, DepartureAirportID, ArrivalAirportID, AircraftID, DepartureDateTime, ArrivalDateTime, Price)
        VALUES (FlightSeq.NEXTVAL, p_FlightNumber, p_DepartureAirportID, p_ArrivalAirportID, p_AircraftID, p_DepartureDateTime, p_ArrivalDateTime, p_Price);
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END;
    PROCEDURE UpdateFlight (
        p_FlightID NUMBER,
        p_FlightNumber VARCHAR2,
        p_DepartureAirportID NUMBER,
        p_ArrivalAirportID NUMBER,
        p_DepartureDateTime TIMESTAMP,
        p_ArrivalDateTime TIMESTAMP,
        p_Price NUMBER
    ) AS
    BEGIN
        UPDATE Flight
        SET FlightNumber = p_FlightNumber,
            DepartureAirportID = p_DepartureAirportID,
            ArrivalAirportID = p_ArrivalAirportID,
            DepartureDateTime = p_DepartureDateTime,
            ArrivalDateTime = p_ArrivalDateTime,
            Price = p_Price
        WHERE FlightID = p_FlightID;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END;
    PROCEDURE UpdateBooking (
        p_BookingID NUMBER,
        p_NewSeatID NUMBER,
        p_Status VARCHAR2
    ) AS
        v_OldSeatID NUMBER;
    BEGIN
        -- Get the current seat assigned
        SELECT SeatID INTO v_OldSeatID
        FROM Booking
        WHERE BookingID = p_BookingID;

        -- Free the old seat
        UPDATE Aircraft_Seat SET IsAvailable = 'Y' WHERE SeatID = v_OldSeatID;

        -- Assign the new seat and update status
        UPDATE Booking
        SET SeatID = p_NewSeatID,
            Status = p_Status
        WHERE BookingID = p_BookingID;

        -- Mark the new seat as unavailable
        UPDATE Aircraft_Seat SET IsAvailable = 'N' WHERE SeatID = p_NewSeatID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Booking not found.');
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END;
END AirlinePackage;
/