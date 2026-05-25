-- CREATE TABLE Statements

CREATE TABLE Users (
user_ID SERIAL PRIMARY KEY,
full_name VARCHAR(100),
email VARCHAR(100) UNIQUE,
password VARCHAR(100),
role VARCHAR(50),
status VARCHAR(50)
);



CREATE TABLE Users_phone (
user_ID INT,
phone VARCHAR(20),

PRIMARY KEY (user_ID, phone),

FOREIGN KEY (user_ID)
REFERENCES Users(user_ID)
);



CREATE TABLE Donors (
national_ID VARCHAR(20) PRIMARY KEY,
user_ID INT,
full_name VARCHAR(100),
date_of_birth DATE,
gender VARCHAR(20),
blood_group VARCHAR(10),
street VARCHAR(100),
area VARCHAR(100),
city VARCHAR(100),
postal_code VARCHAR(100),

FOREIGN KEY (user_ID)
REFERENCES Users (user_ID)
);



CREATE TABLE Donors_phone (
national_ID VARCHAR(20),
phone VARCHAR(20),

PRIMARY KEY (national_ID, phone),

FOREIGN KEY (national_ID)
REFERENCES Donors(national_ID)
);



CREATE TABLE Donations (
donation_ID SERIAL PRIMARY KEY,
national_ID VARCHAR(20),
units_donated INT,
donation_date DATE,
eligible_next_date DATE,

FOREIGN KEY (national_ID)
REFERENCES Donors (national_ID)
);



CREATE TABLE Screenings (
screening_result_ID SERIAL PRIMARY KEY,
donation_ID INT,
hb_level DECIMAL(4,2),
bp VARCHAR(20),
hepatitis_b BOOLEAN,
hepatitis_c BOOLEAN,
hiv BOOLEAN,
malaria BOOLEAN,

FOREIGN KEY (donation_ID)
REFERENCES Donations(donation_ID)
);




CREATE TABLE Branches (
branch_ID SERIAL PRIMARY KEY,
user_ID INT,
branch_name VARCHAR(50),
district VARCHAR(50),
street VARCHAR(50),
area VARCHAR(50),
city VARCHAR(50),
postal_code VARCHAR(50),

FOREIGN KEY (user_ID)
REFERENCES Users(user_ID)
);

ALTER TABLE Branches
ADD COLUMN branch_status VARCHAR(50);



CREATE TABLE Branches_phone (
branch_ID INT,
phone VARCHAR(20),

PRIMARY KEY (branch_ID, phone),

FOREIGN KEY (branch_ID)
REFERENCES Branches (branch_ID)
);



CREATE TABLE Blood_Inventory (
inventory_ID SERIAL PRIMARY KEY,
branch_ID INT,
blood_group VARCHAR(10),
unit_number INT,
collection_date DATE,
expiry_date DATE,
quantity INT,
status VARCHAR(50),

FOREIGN KEY (branch_ID)
REFERENCES Branches (branch_ID)
);



CREATE TABLE Requesters (
requester_ID SERIAL PRIMARY KEY,
requester_type VARCHAR(50),
name VARCHAR(100),
street VARCHAR(100),
area VARCHAR(100),
city VARCHAR(100),
postal_code VARCHAR(20)
);



CREATE TABLE Requests (
request_ID SERIAL PRIMARY KEY,
requester_ID INT,
blood_group VARCHAR(10),
quantity INT,
urgency VARCHAR(20),
request_date DATE,
status VARCHAR(50),

FOREIGN KEY (requester_ID)
REFERENCES Requesters(requester_ID)
);



CREATE TABLE Requesters_phone (
requester_ID INT,
phone VARCHAR(20),

PRIMARY KEY (requester_ID, phone),

FOREIGN KEY (requester_ID)
REFERENCES Requesters(requester_ID)
);



CREATE TABLE Reports (
report_ID SERIAL PRIMARY KEY,
user_ID INT,
generated_on DATE,
report_data TEXT,

FOREIGN KEY (user_ID)
REFERENCES Users(user_ID)
);



CREATE TABLE Transports (
transport_ID SERIAL PRIMARY KEY,
branch_ID INT,
source_branch VARCHAR(100),
destination_type VARCHAR(50),
destination_name VARCHAR(100),
transport_date DATE,
status VARCHAR(50),

FOREIGN KEY (branch_ID)
REFERENCES Branches(branch_ID)
);



CREATE TABLE Allocations (
allocation_ID SERIAL PRIMARY KEY,
transport_ID INT,
allocated_quantity INT,
allocation_date DATE,
allocation_status VARCHAR(50),

FOREIGN KEY (transport_ID)
REFERENCES Transports(transport_ID)
);



CREATE TABLE Payments (
payment_ID SERIAL PRIMARY KEY,
allocation_ID INT,
amount DECIMAL(10,2),
payment_date DATE,
payment_status VARCHAR(50),

FOREIGN KEY (allocation_ID)
REFERENCES Allocations(allocation_ID)
);



CREATE TABLE Inventory_Allocations (
inventory_ID INT,
allocation_ID INT,

PRIMARY KEY (inventory_ID, allocation_ID),

FOREIGN KEY (inventory_ID)
REFERENCES Blood_Inventory(inventory_ID),

FOREIGN KEY (allocation_ID)
REFERENCES Allocations(allocation_ID)
);



CREATE TABLE Inventory_Requests (
inventory_ID INT,
request_ID INT,

PRIMARY KEY (inventory_ID, request_ID),

FOREIGN KEY (inventory_ID)
REFERENCES Blood_Inventory(inventory_ID),

FOREIGN KEY (request_ID)
REFERENCES Requests(request_ID)
);



-- ALTERATIONS


-- ALTERATIONS: Enums


CREATE TYPE gender_enum AS ENUM (
'Male', 'Female'
);

CREATE TYPE blood_group_enum AS ENUM (
'A+', 'A-',
'B+', 'B-',
'AB+', 'AB-',
'O+', 'O-'
);

CREATE TYPE role_enum AS ENUM (
'Superadmin', 'Admin', 'Staff'
);

CREATE TYPE requester_type_enum AS ENUM (
'Hospital', 'Individual', 'Blood Bank'
);

CREATE TYPE urgency_enum AS ENUM (
'Normal', 'Urgent', 'Critical'
);

CREATE TYPE destination_type_enum AS ENUM (
'Hospital', 'Branch'
);



-- ALTERATIONS: TABLES

-- ALTERATIONS: Users

ALTER TABLE Users
ALTER COLUMN role TYPE role_enum
USING role::role_enum;



-- ALTERATIONS: Donors

ALTER TABLE Donors
ALTER COLUMN gender TYPE gender_enum
USING gender::gender_enum;

ALTER TABLE Donors
ALTER COLUMN blood_group TYPE blood_group_enum
USING blood_group::blood_group_enum;



-- ALTERATIONS: Screenings

ALTER TABLE Screenings
ADD COLUMN tested_on TIMESTAMP;

ALTER TABLE Screenings
ADD COLUMN tested_by VARCHAR(100);

ALTER TABLE Screenings
ADD COLUMN result VARCHAR(20);



-- ALTERATIONS: Blood_Inventory

ALTER TABLE Blood_Inventory
ALTER COLUMN blood_group TYPE blood_group_enum
USING blood_group::blood_group_enum;



-- ALTERATIONS: Requesters

ALTER TABLE Requesters
ALTER COLUMN requester_type TYPE requester_type_enum
USING requester_type::requester_type_enum;



-- ALTERATIONS: Requests

ALTER TABLE Requests
ALTER COLUMN blood_group TYPE blood_group_enum
USING blood_group::blood_group_enum;

ALTER TABLE Requests
ALTER COLUMN urgency TYPE urgency_enum
USING urgency::urgency_enum;



-- ALTERATIONS: Transports

ALTER TABLE Transports
ADD COLUMN dispatched_time TIMESTAMP;

ALTER TABLE Transports
ADD COLUMN received_time TIMESTAMP;

ALTER TABLE Transports
ALTER COLUMN destination_type TYPE destination_type_enum
USING destination_type::destination_type_enum;



-- ALTERATIONS: Payments

ALTER TABLE Payments
ADD COLUMN payment_reason VARCHAR(30);



-- JOIN QUERIES

-- Users and Users-phone Records

SELECT *
FROM Users u
JOIN Users_phone phone
ON u.user_ID = phone.user_ID;



-- Users and Donors Records

SELECT *
FROM Users u
JOIN Donors donor
ON u.user_ID = donor.user_ID;



-- Donors and Donors_phone Records

SELECT *
FROM Donors donor
JOIN Donors_phone phone
ON donor.national_ID = phone.national_ID;



-- Donors and Donations Records

SELECT *
FROM Donors donor
JOIN Donations donation
ON donor.national_ID = donation.national_ID;



-- Donations and Screenings Records

SELECT *
FROM Donations donation
JOIN Screenings screening
ON donation.donation_ID = screening.donation_ID;



-- Users and Branches Records

SELECT *
FROM Users u
JOIN Branches branch
ON u.user_ID = branch.user_ID;



-- Branches and Branches_phone Records

SELECT *
FROM Branches branch
JOIN Branches_phone phone
ON branch.branch_ID = phone.branch_ID;



-- Branches and Blood_Inventory Records

SELECT *
FROM Branches branch
JOIN Blood_Inventory inventory
ON branch.branch_ID = inventory.branch_ID;



-- Requesters and Requests Records

SELECT *
FROM Requesters requester
JOIN Requests request
ON requester.requester_ID = request.requester_ID;



-- Requesters and Requesters_phone Records

SELECT *
FROM Requesters requester
JOIN Requesters_phone phone
ON requester.requester_ID = phone.requester_ID;



-- Users and Reports Records

SELECT *
FROM Users u
JOIN Reports report
ON u.user_ID = report.user_ID;



-- Branches and Transports Records

SELECT *
FROM Branches branch
JOIN Transports transport
ON branch.branch_ID = transport.branch_ID;



-- Transports and Allocations Records

SELECT *
FROM Transports transport
JOIN Allocations allocation
ON transport.transport_ID = allocation.transport_ID;



-- Allocations and Payments Records

SELECT *
FROM Allocations allocation
JOIN Payments payment
ON allocation.allocation_ID = payment.allocation_ID;




-- Blood_Inventory and Inventory_Allocations Records

SELECT *
FROM Blood_Inventory inventory
JOIN Inventory_Allocations inventory_allocation
ON inventory.inventory_ID = inventory_allocation.inventory_ID;



-- Allocations and Inventory_Allocations Records

SELECT *
FROM Allocations allocation
JOIN Inventory_Allocations inventory_allocation
ON allocation.allocation_ID = inventory_allocation.allocation_ID;



-- Blood_Inventory and Inventory_Requests Records

SELECT *
FROM Blood_Inventory inventory
JOIN Inventory_Requests inventory_request
ON inventory.inventory_ID = inventory_request.inventory_ID;



-- Requests and Inventory_Requests Records

SELECT *
FROM Requests request
JOIN Inventory_Requests inventory_request
ON request.request_ID = inventory_request.request_ID;
