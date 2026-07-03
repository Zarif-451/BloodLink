# 🩸 BloodLink

BloodLink is a **Blood Bank Management System** developed as a university **DBMS project**. It streamlines blood donation, donor management, blood inventory, request handling, transportation, payment management, reporting, and secure user management through a scalable backend.

The project follows a **Database-First Development Approach**, where the PostgreSQL database schema is designed and implemented before backend development begins.

---

# 📌 Features

- 👤 User Management (SuperAdmin, Admin, Staff)
- 🔐 Password Hashing
- 🔑 Custom JWT Authentication
- 🩸 Donor Management
- 💉 Blood Donation Tracking
- 🏥 Blood Request Management
- 👥 Requester Management
- 🏢 Branch Management
- 📦 Blood Inventory Management
- 🚚 Transportation Tracking
- 💰 Payment Management
- 📊 Report Generation
- 🔒 Role-Based Access Control (RBAC) *(In Progress)*

---

# 🛠 Tech Stack

## Backend
- Python
- Django
- Django REST Framework

## Database
- PostgreSQL

## Frontend
- Flutter *(In Development)*

## API Testing
- Postman

## Version Control
- Git
- GitHub

---

# 📂 Project Structure

```text
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
│   ├── payment/
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

---

# 🗄 Database Modules

- Users
- User Phone
- Donors
- Donor Phone
- Requesters
- Requester Phone
- Requests
- Donations
- Screenings
- Blood Inventory
- Allocations
- Branches
- Branch Phone
- Transport
- Payments
- Reports

---

# 🚀 Development Status

## ✅ Completed

### Database
- Database Design (ERD)
- Relational Mapping
- PostgreSQL Database Design
- SQL Schema
- Database Constraints

### Django Setup
- Django Project Setup
- Django ↔ PostgreSQL Connection
- Environment Variable Configuration (.env)
- Django App Structure
- Django Models
- Initial Database Migrations
- Database-First Integration (`migrate --fake-initial`)
- Django Admin Configuration

### Django REST Framework
- Django REST Framework Setup
- Serializer Implementation
- APIView Implementation
- URL Routing

### CRUD REST APIs
- ✅ Users
- ✅ Donors
- ✅ Requesters
- ✅ Requests
- ✅ Branches
- ✅ Blood Inventory
- ✅ Donations

### Security & Authentication
- ✅ Password Hashing (`make_password`, `check_password`)
- ✅ Custom JWT Authentication
- ✅ Login API
- ✅ Profile API
- ✅ Protected Endpoints
- ✅ Postman API Testing

---

## 🚧 In Progress

- Role-Based Access Control (RBAC)
- Business Logic Implementation
- Auto ID Generation (USR001, DON001, ...)

---

## 📅 Planned

- Screening Workflow
- Blood Allocation Workflow
- Transportation Workflow
- Payment Workflow
- Flutter Backend Integration
- Deployment

---

# ⚙️ Setup

## Clone Repository

```bash
git clone https://github.com/Zarif-451/BloodLink.git
cd BloodLink
```

## Create Environment

```bash
conda create -n bloodlink python=3.13
conda activate bloodlink
```

## Install Dependencies

```bash
pip install -r requirements.txt
```

## Create Environment Variables

Create a `.env` file inside the `backend` directory.

```env
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

## Apply Migrations

```bash
python manage.py migrate --fake-initial
```

## Run Development Server

```bash
cd backend
python manage.py runserver
```

---

# 🔐 Authentication Workflow

```text
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
APIView
```

---

# 📖 Development Workflow

```text
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
Business Logic
 ↓
Flutter Frontend
```

---

# 📊 Current Progress

| Component | Status |
|-----------|--------|
| Database Design | ✅ Completed |
| PostgreSQL Database | ✅ Completed |
| Django Models | ✅ Completed |
| Database Migrations | ✅ Completed |
| Django Admin | ✅ Completed |
| Django REST Framework Setup | ✅ Completed |
| User CRUD API | ✅ Completed |
| Donor CRUD API | ✅ Completed |
| Requester CRUD API | ✅ Completed |
| Request CRUD API | ✅ Completed |
| Branch CRUD API | ✅ Completed |
| Blood Inventory CRUD API | ✅ Completed |
| Donation CRUD API | ✅ Completed |
| Password Hashing | ✅ Completed |
| Custom JWT Authentication | ✅ Completed |
| Protected APIs | ✅ Completed |
| API Testing (Postman) | ✅ Completed |
| Role-Based Access Control | 🚧 In Progress |
| Auto ID Generation | 🚧 In Progress |
| Business Logic | 🚧 In Progress |
| Flutter Integration | ⏳ Planned |
| Deployment | ⏳ Planned |

---

# 📚 Documentation

Project documentation is maintained in:

```text
docs/
└── Backend_Cookbook.md
```

The **Backend Cookbook** documents:

- Backend Architecture
- Database-First Development
- Django ORM
- Models
- Database Migrations
- Django Admin
- Serializers
- APIViews
- URL Routing
- CRUD Operations
- Password Hashing
- Custom JWT Authentication
- API Testing with Postman
- Learning Notes & Best Practices

---

# 👨‍💻 Author

**Muhammad Zarif Rahman**

CSE Undergraduate, CUET

Python • Django • Machine Learning • Cybersecurity

---

# 📄 License

This project is developed for educational purposes.
