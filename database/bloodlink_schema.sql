CREATE TABLE Users (

    user_ID VARCHAR(20) PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    password VARCHAR(255) NOT NULL,

    role VARCHAR(15) NOT NULL
        CHECK (role IN ('SuperAdmin', 'Admin', 'Staff')),

    status VARCHAR(15) NOT NULL DEFAULT 'Active'
        CHECK (status IN ('Active', 'Inactive', 'Suspended'))

);



CREATE TABLE Requesters (

    requester_ID VARCHAR(20) PRIMARY KEY,

    requester_type VARCHAR(15) NOT NULL
        CHECK (requester_type IN ('Hospital', 'Individual')),

    name VARCHAR(100) NOT NULL,

    street VARCHAR(100) NOT NULL,

    area VARCHAR(100) NOT NULL,

    city VARCHAR(100) NOT NULL

);



CREATE TABLE Branches (

    branch_ID VARCHAR(20) PRIMARY KEY,

    branch_name VARCHAR(100) NOT NULL,

    district VARCHAR(100) NOT NULL,

    street VARCHAR(100) NOT NULL,

    area VARCHAR(100) NOT NULL,

    city VARCHAR(100) NOT NULL,

    branch_status VARCHAR(15) NOT NULL DEFAULT 'Active'
        CHECK (branch_status IN ('Active', 'Inactive')),

    user_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_branch_user
        FOREIGN KEY (user_ID)
        REFERENCES Users(user_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Donors (

    national_ID VARCHAR(17) PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    date_of_birth DATE NOT NULL,

    gender VARCHAR(10) NOT NULL
        CHECK (gender IN ('Male', 'Female')),

    blood_group VARCHAR(3) NOT NULL
        CHECK (blood_group IN
        ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),

    street VARCHAR(100) NOT NULL,

    area VARCHAR(100) NOT NULL,

    city VARCHAR(100) NOT NULL,

    user_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_donor_user
        FOREIGN KEY (user_ID)
        REFERENCES Users(user_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Requests (

    request_ID VARCHAR(20) PRIMARY KEY,

    blood_group VARCHAR(3) NOT NULL
        CHECK (blood_group IN
        ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),

    quantity INT NOT NULL
        CHECK (quantity > 0),

    urgency VARCHAR(10) NOT NULL
        CHECK (urgency IN ('Low', 'Medium', 'High', 'Critical')),

    request_date DATE NOT NULL,

    status VARCHAR(15) NOT NULL DEFAULT 'Pending'
        CHECK (status IN
        ('Pending', 'Rejected', 'Fulfilled')),

    requester_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_request_requester
        FOREIGN KEY (requester_ID)
        REFERENCES Requesters(requester_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Blood_Inventory (

    inventory_ID VARCHAR(20) PRIMARY KEY,

    blood_group VARCHAR(3) NOT NULL
        CHECK (blood_group IN
        ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),

    collection_date DATE NOT NULL,

    status VARCHAR(15) NOT NULL DEFAULT 'Available'
        CHECK (status IN ('Available', 'Unavailable')),

    branch_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_inventory_branch
        FOREIGN KEY (branch_ID)
        REFERENCES Branches(branch_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Donations (

    donation_ID VARCHAR(20) PRIMARY KEY,

    units_donated INT NOT NULL
        CHECK (units_donated > 0),

    donation_date DATE NOT NULL,

    national_ID VARCHAR(17) NOT NULL,

    CONSTRAINT fk_donation_donor
        FOREIGN KEY (national_ID)
        REFERENCES Donors(national_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Screenings (

    screening_result_ID VARCHAR(20) PRIMARY KEY,

    hb_level DECIMAL(4,2) NOT NULL
        CHECK (hb_level >= 0),

    bp VARCHAR(10) NOT NULL,

    hepatitis_b BOOLEAN NOT NULL,

    hepatitis_c BOOLEAN NOT NULL,

    hiv BOOLEAN NOT NULL,

    malaria BOOLEAN NOT NULL,

    tested_on DATE NOT NULL,

    tested_by VARCHAR(100) NOT NULL,

    result VARCHAR(15) NOT NULL
        CHECK (result IN ('Eligible', 'Ineligible')),

    donation_ID VARCHAR(20) UNIQUE NOT NULL,

    CONSTRAINT fk_screening_donation
        FOREIGN KEY (donation_ID)
        REFERENCES Donations(donation_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Transports (

    transport_ID VARCHAR(20) PRIMARY KEY,

    destination_type VARCHAR(15) NOT NULL
        CHECK (destination_type IN ('Hospital', 'Branch')),

    destination_name VARCHAR(100) NOT NULL,

    transport_date DATE NOT NULL,

    status VARCHAR(15) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'In Transit', 'Delivered', 'Cancelled')),

    branch_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_transport_branch
        FOREIGN KEY (branch_ID)
        REFERENCES Branches(branch_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Allocations (

    allocation_ID VARCHAR(20) PRIMARY KEY,

    allocated_quantity INT NOT NULL
        CHECK (allocated_quantity > 0),

    allocation_date DATE NOT NULL,

    allocation_status VARCHAR(15) NOT NULL DEFAULT 'Pending'
        CHECK (allocation_status IN
        ('Pending', 'Allocated', 'Cancelled')),

    transport_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_allocation_transport
        FOREIGN KEY (transport_ID)
        REFERENCES Transports(transport_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Payments (

    payment_ID VARCHAR(20) PRIMARY KEY,

    payment_amount DECIMAL(10,2) NOT NULL
        CHECK (payment_amount >= 0),

    payment_date DATE NOT NULL,

    payment_method VARCHAR(20) NOT NULL
        CHECK (payment_method IN
        ('Cash', 'Card', 'Mobile Banking', 'Bank Transfer')),

    payment_status VARCHAR(15) NOT NULL DEFAULT 'Pending'
        CHECK (payment_status IN
        ('Pending', 'Completed', 'Failed')),

    allocation_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_payment_allocation
        FOREIGN KEY (allocation_ID)
        REFERENCES Allocations(allocation_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Reports (

    report_ID VARCHAR(20) PRIMARY KEY,

    generated_on DATE NOT NULL,

    report_data TEXT NOT NULL,

    user_ID VARCHAR(20) NOT NULL,

    CONSTRAINT fk_report_user
        FOREIGN KEY (user_ID)
        REFERENCES Users(user_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE User_phone (

    user_ID VARCHAR(20) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    PRIMARY KEY (user_ID, phone),

    CONSTRAINT fk_user_phone
        FOREIGN KEY (user_ID)
        REFERENCES Users(user_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);



CREATE TABLE Donor_phone (

    national_ID VARCHAR(17) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    PRIMARY KEY (national_ID, phone),

    CONSTRAINT fk_donor_phone
        FOREIGN KEY (national_ID)
        REFERENCES Donors(national_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);



CREATE TABLE Requester_phone (

    requester_ID VARCHAR(20) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    PRIMARY KEY (requester_ID, phone),

    CONSTRAINT fk_requester_phone
        FOREIGN KEY (requester_ID)
        REFERENCES Requesters(requester_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);



CREATE TABLE Branch_phone (

    branch_ID VARCHAR(20) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    PRIMARY KEY (branch_ID, phone),

    CONSTRAINT fk_branch_phone
        FOREIGN KEY (branch_ID)
        REFERENCES Branches(branch_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);



CREATE TABLE Allocate (

    allocation_ID VARCHAR(20) NOT NULL,

    inventory_ID VARCHAR(20) NOT NULL,

    PRIMARY KEY (allocation_ID, inventory_ID),

    CONSTRAINT fk_allocate_allocation
        FOREIGN KEY (allocation_ID)
        REFERENCES Allocations(allocation_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_allocate_inventory
        FOREIGN KEY (inventory_ID)
        REFERENCES Blood_Inventory(inventory_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);



CREATE TABLE Fulfill (

    request_ID VARCHAR(20) NOT NULL,

    inventory_ID VARCHAR(20) NOT NULL,

    PRIMARY KEY (request_ID, inventory_ID),

    CONSTRAINT fk_fulfill_request
        FOREIGN KEY (request_ID)
        REFERENCES Requests(request_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_fulfill_inventory
        FOREIGN KEY (inventory_ID)
        REFERENCES Blood_Inventory(inventory_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);




DROP TABLE IF EXISTS Fulfill;

ALTER TABLE Blood_Inventory
ADD COLUMN request_ID VARCHAR(20);

ALTER TABLE Blood_Inventory
ADD CONSTRAINT fk_inventory_request
FOREIGN KEY (request_ID)
REFERENCES Requests(request_ID);



DROP TABLE IF EXISTS Allocate;

ALTER TABLE Blood_Inventory
ADD COLUMN allocation_ID VARCHAR(20);

ALTER TABLE Blood_Inventory
ADD CONSTRAINT fk_inventory_allocation
FOREIGN KEY (allocation_ID)
REFERENCES Allocations(allocation_ID);