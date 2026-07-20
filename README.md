# 🩸 BloodLink

BloodLink is a **Blood Bank Management System** developed as a
university **DBMS project**. It streamlines blood donation, donor
management, blood inventory, request handling, transportation, payment
management, reporting, and secure user management through a scalable
backend.

The project follows a **Database-First Development Approach**, where the
PostgreSQL database schema is designed and implemented before backend
development begins.

------------------------------------------------------------------------

# 📌 Features

-   👤 User Management (SuperAdmin, Admin, Staff)
-   🆔 Automatic ID Generation
-   🔐 Password Hashing
-   🔑 Custom JWT Authentication
-   🛡️ Role-Based Access Control (RBAC)
-   🔒 Custom Permission Classes
-   ⚡ Generic Views (DRF)
-   🧠 Business Logic Layer
-   🩸 Donor Management
-   💉 Blood Donation Tracking
-   🧪 Screening Management
-   📦 Automatic Inventory Status Management
-   🏥 Blood Request Management
-   👥 Requester Management
-   📋 FIFO Blood Allocation
-   🚚 Transportation Tracking
-   💰 Automatic Payment Generation
-   ⚙️ Configurable Pricing (settings.py)
-   📊 Report & Dashboard Module (In Development)

------------------------------------------------------------------------

# 🛠 Tech Stack

## Backend

-   Python
-   Django
-   Django REST Framework

## Database

-   PostgreSQL

## Frontend

-   Flutter *(In Development)*

## API Testing

-   Postman

## Version Control

-   Git
-   GitHub

------------------------------------------------------------------------

# 📂 Project Structure

``` text
BloodLink/
│
├── backend/
│   ├── bloodlink/
│   ├── authentication/
│   ├── users/
│   ├── donors/
│   ├── requesters/
│   ├── requests/
│   ├── donations/
│   ├── screenings/
│   ├── inventory/
│   ├── branches/
│   ├── transport/
│   ├── payments/
│   ├── reports/
│   ├── utils/
│   └── manage.py
│
├── database/
├── docs/
├── frontend/
└── README.md
```

------------------------------------------------------------------------

# 🗄 Database Modules

-   Users
-   User Phone
-   Donors
-   Donor Phone
-   Requesters
-   Requester Phone
-   Requests
-   Donations
-   Screenings
-   Blood Inventory
-   Allocations
-   Branches
-   Branch Phone
-   Transport
-   Payments
-   Reports

------------------------------------------------------------------------

# 🚀 Development Status

## ✅ Completed

### Database

-   Database Design (ERD)
-   Relational Mapping
-   PostgreSQL Database Design
-   SQL Schema
-   Database Constraints

### Django Setup

-   Django Project Setup
-   Django ↔ PostgreSQL Connection
-   Environment Variables
-   Django Models
-   Initial Migrations
-   Database-First Integration (`migrate --fake-initial`)
-   Django Admin Configuration

### Django REST Framework

-   Serializer Implementation
-   APIViews
-   Generic Views
-   URL Routing

### CRUD REST APIs

-   ✅ Users
-   ✅ User Phone
-   ✅ Donors
-   ✅ Donor Phone
-   ✅ Requesters
-   ✅ Requester Phone
-   ✅ Requests
-   ✅ Branches
-   ✅ Branch Phone
-   ✅ Donations
-   ✅ Screenings
-   ✅ Blood Inventory
-   ✅ Allocations
-   ✅ Transport
-   ✅ Payments
-   ✅ Reports

### Security & Authentication

-   ✅ Password Hashing
-   ✅ Custom JWT Authentication
-   ✅ Login API
-   ✅ Profile API
-   ✅ Protected APIs
-   ✅ API Testing with Postman

### Authorization

-   ✅ Role-Based Access Control (RBAC)
-   ✅ Custom Permission Classes

### Business Logic

-   ✅ Business Logic Layer
-   ✅ Automatic Inventory Status Updates
-   ✅ FIFO Blood Allocation
-   ✅ Partial & Fulfilled Requests
-   ✅ Automatic Payment Generation
-   ✅ Configurable Pricing

### Utilities

-   ✅ Automatic ID Generation

------------------------------------------------------------------------

## 🚧 In Progress

-   Reports & Dashboard
-   Complete API Testing
-   Exception Handling

------------------------------------------------------------------------

## 📅 Planned

-   Flutter Integration
-   Stripe Integration
-   Production Deployment

------------------------------------------------------------------------

# ⚙️ Setup

## Clone Repository

``` bash
git clone https://github.com/Zarif-451/BloodLink.git
cd BloodLink
```

## Create Environment

``` bash
conda create -n bloodlink python=3.13
conda activate bloodlink
```

## Install Dependencies

``` bash
pip install -r requirements.txt
```

## Configure Environment Variables

``` env
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

## Apply Migrations

``` bash
python manage.py migrate --fake-initial
```

## Run Server

``` bash
cd backend
python manage.py runserver
```

------------------------------------------------------------------------

# 🔐 Authentication & Authorization Workflow

``` text
Login
 │
 ▼
Email + Password
 │
 ▼
check_password()
 │
 ▼
Generate JWT
 │
 ▼
Client Stores Token
 │
 ▼
Protected API
 │
 ▼
JWT Authentication
 │
 ▼
request.user
 │
 ▼
RBAC Permission
 │
 ├── Granted → APIView
 └── Denied  → 403 Forbidden
```

------------------------------------------------------------------------

# 📖 Development Workflow

``` text
ERD
 ↓
Relational Mapping
 ↓
PostgreSQL Database
 ↓
Django Models
 ↓
Database Migrations
 ↓
Django Admin
 ↓
REST APIs
 ↓
Password Hashing
 ↓
JWT Authentication
 ↓
RBAC
 ↓
Custom Permissions
 ↓
Generic Views
 ↓
Automatic ID Generation
 ↓
Business Logic Layer
 ↓
Inventory Management Logic
 ↓
Blood Allocation System
 ↓
Transport & Payment System
 ↓
Reports & Dashboard
 ↓
Flutter Integration
 ↓
Stripe Integration
```

------------------------------------------------------------------------

# 📊 Current Progress

  Component                    Status
  ---------------------------- ----------------
  Database Design              ✅ Completed
  PostgreSQL Database          ✅ Completed
  Django Models                ✅ Completed
  Database Migrations          ✅ Completed
  Django Admin                 ✅ Completed
  Django REST Framework        ✅ Completed
  Serializer                   ✅ Completed
  APIViews                     ✅ Completed
  Generic Views                ✅ Completed
  CRUD REST APIs               ✅ Completed
  Password Hashing             ✅ Completed
  Custom JWT Authentication    ✅ Completed
  Protected APIs               ✅ Completed
  API Testing (Postman)        🚧 In Progress
  RBAC                         ✅ Completed
  Custom Permission Classes    ✅ Completed
  Automatic ID Generation      ✅ Completed
  Business Logic Layer         ✅ Completed
  Inventory Management Logic   ✅ Completed
  Blood Allocation System      ✅ Completed
  Transport & Payment System   ✅ Completed
  Reports & Dashboard          🚧 In Progress
  Exception Handling           🚧 In Progress
  Flutter Integration          ⏳ Planned
  Stripe Integration           ⏳ Planned
  Production Deployment        ⏳ Planned

------------------------------------------------------------------------

# 📚 Documentation

Documentation is available in:

``` text
docs/
├── Backend_Cookbook.md
├── Chapter_20_Business_Logic_Layer.md
├── Chapter_21_Inventory_Management_Logic.md
├── Chapter_22_Blood_Allocation_System.md
└── Chapter_23_Transport_and_Payment_System.md
```

Topics covered include:

-   Database-First Development
-   Django ORM
-   Models & Migrations
-   Serializers
-   APIViews
-   Generic Views
-   CRUD APIs
-   Password Hashing
-   JWT Authentication
-   RBAC
-   Custom Permissions
-   Automatic ID Generation
-   Business Logic Layer
-   Inventory Management
-   FIFO Blood Allocation
-   Transport System
-   Automatic Payment System
-   Best Practices & Learning Notes

------------------------------------------------------------------------

# 👨‍💻 Author

**Muhammad Zarif Rahman**

CSE Undergraduate, CUET

**Python • Django • Machine Learning • Cybersecurity**

------------------------------------------------------------------------

# 📄 License

This project is developed for educational purposes.
