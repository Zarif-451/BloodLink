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
-   🩸 Donor Management
-   💉 Blood Donation Tracking
-   🧪 Screening Management
-   🏥 Blood Request Management
-   👥 Requester Management
-   🏢 Branch Management
-   📦 Blood Inventory Management
-   📋 Blood Allocation Management
-   🚚 Transportation Tracking
-   💰 Payment Management
-   📊 Report Management

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
│   ├── inventory/
│   ├── branches/
│   ├── transport/
│   ├── payments/
│   ├── utils/
│   └── manage.py
│
├── database/
│   ├── bloodlink_schema.sql
│   ├── BloodLink_ERD.png
│   └── BloodLink_Relational_Mapping.pdf
│
├── docs/
│   └── Backend_Cookbook.md
│
├── frontend/
│
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
-   Environment Variable Configuration (.env)
-   Django App Structure
-   Django Models
-   Initial Database Migrations
-   Database-First Integration (`migrate --fake-initial`)
-   Django Admin Configuration

### Django REST Framework

-   Django REST Framework Setup
-   Serializer Implementation
-   APIView Implementation
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
-   ✅ Blood Inventory
-   ✅ Allocations
-   ✅ Donations
-   ✅ Screenings
-   ✅ Transport
-   ✅ Payments
-   ✅ Reports

### Security & Authentication

-   ✅ Password Hashing (`make_password`, `check_password`)
-   ✅ Custom JWT Authentication
-   ✅ Login API
-   ✅ Profile API
-   ✅ Protected Endpoints
-   ✅ API Testing with Postman

### Authorization

-   ✅ Role-Based Access Control (RBAC)
-   ✅ Custom Permission Classes

### Utilities

-   ✅ Automatic ID Generation

------------------------------------------------------------------------

## 🚧 In Progress

-   Business Logic Implementation
-   Complete API Testing
-   Exception Handling

------------------------------------------------------------------------

## 📅 Planned

-   Flutter Backend Integration
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

## Create Environment Variables

Create a `.env` file inside the `backend` directory.

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

## Run Development Server

``` bash
cd backend
python manage.py runserver
```

------------------------------------------------------------------------

# 🔐 Authentication & Authorization Workflow

``` text
Login
  │
Email + Password
  │
check_password()
  │
Generate JWT
  │
Client Stores Token
  │
────────────────────────────
  │
Protected API
  │
Authorization: Bearer <JWT>
  │
JWTAuthentication
  │
request.user
  │
Permission Class (RBAC)
  │
Permission Granted?
 ┌──────────────┐
 │ Yes      No  │
 ▼          ▼
APIView   403 Forbidden
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
REST APIs (CRUD)
 ↓
Password Hashing
 ↓
Custom JWT Authentication
 ↓
Role-Based Access Control
 ↓
Custom Permission Classes
 ↓
Generic Views
 ↓
Automatic ID Generation
 ↓
Business Logic
 ↓
Flutter Frontend
```

------------------------------------------------------------------------

# 📊 Current Progress

  Component                          Status
  ---------------------------------- ----------------
  Database Design                    ✅ Completed
  PostgreSQL Database                ✅ Completed
  Django Models                      ✅ Completed
  Database Migrations                ✅ Completed
  Django Admin                       ✅ Completed
  Django REST Framework Setup        ✅ Completed
  Serializer Implementation          ✅ Completed
  APIView Implementation             ✅ Completed
  Generic Views                      ✅ Completed
  User CRUD API                      ✅ Completed
  User Phone CRUD API                ✅ Completed
  Donor CRUD API                     ✅ Completed
  Donor Phone CRUD API               ✅ Completed
  Requester CRUD API                 ✅ Completed
  Requester Phone CRUD API           ✅ Completed
  Request CRUD API                   ✅ Completed
  Branch CRUD API                    ✅ Completed
  Branch Phone CRUD API              ✅ Completed
  Blood Inventory CRUD API           ✅ Completed
  Allocation CRUD API                ✅ Completed
  Donation CRUD API                  ✅ Completed
  Screening CRUD API                 ✅ Completed
  Transport CRUD API                 ✅ Completed
  Payment CRUD API                   ✅ Completed
  Report CRUD API                    ✅ Completed
  Password Hashing                   ✅ Completed
  Custom JWT Authentication          ✅ Completed
  Protected APIs                     ✅ Completed
  API Testing (Postman)              🚧 In Progress
  Role-Based Access Control (RBAC)   ✅ Completed
  Custom Permission Classes          ✅ Completed
  Generic Views                      ✅ Completed
  Automatic ID Generation            ✅ Completed
  Business Logic                     🚧 In Progress
  Exception Handling                 🚧 In Progress
  Flutter Integration                ⏳ Planned
  Production Deployment              ⏳ Planned

------------------------------------------------------------------------

# 📚 Documentation

Project documentation is maintained in:

``` text
docs/
└── Backend_Cookbook.md
```

The **Backend Cookbook** documents:

-   Backend Architecture
-   Database-First Development
-   Django ORM
-   Models
-   Database Migrations
-   Django Admin
-   Serializers
-   APIViews
-   Generic Views
-   URL Routing
-   CRUD Operations
-   Password Hashing
-   Automatic ID Generation
-   Custom JWT Authentication
-   API Testing with Postman
-   Role-Based Access Control (RBAC)
-   Custom Permission Classes
-   Learning Notes & Best Practices

------------------------------------------------------------------------

# 👨‍💻 Author

**Muhammad Zarif Rahman**

CSE Undergraduate, CUET

**Python • Django • Machine Learning • Cybersecurity**

------------------------------------------------------------------------

# 📄 License

This project is developed for educational purposes.
