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