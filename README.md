# 🩸 BloodLink

BloodLink is a Blood Bank Management System developed as a university DBMS project. It aims to streamline blood donation, donor management, blood inventory, request handling, transportation, payment management, and reporting through a secure and scalable system.

The project follows a **Database-First Development Approach**, where the database schema is designed and implemented before backend development begins.

---

# 📌 Features

- 👤 User Management (SuperAdmin, Admin, Staff)
- 🩸 Donor Management
- 💉 Blood Donation Tracking
- 🧪 Screening & Test Records
- 🏥 Blood Request Management
- 📦 Blood Inventory Management
- 🚚 Transportation Tracking
- 💰 Payment Management
- 📊 Report Generation
- 🔒 Role-Based Access Control (RBAC)

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
│   ├── users/
│   ├── donors/
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
- Transports
- Payments
- Reports

---

# 🚀 Development Status

## ✅ Completed

- Database Design (ERD)
- Relational Mapping
- PostgreSQL Database Design
- SQL Schema
- Database Constraints
- Django Project Setup
- Django ↔ PostgreSQL Connection
- Environment Variable Configuration (.env)
- Django App Structure
- Django Models
- Initial Database Migrations
- Database-First Integration (`migrate --fake-initial`)
- Django Admin Configuration
- Donor CRUD API
  - ✅ GET (List)
  - ✅ GET (Detail)
  - ✅ POST
  - ✅ PUT
  - ✅ PATCH
  - ✅ DELETE

---

## 🚧 In Progress

- CRUD APIs for Remaining Modules
- REST API Development
- Authentication & Authorization

---

## 📅 Planned

- JWT Authentication
- Role-Based Access Control (RBAC)
- Business Logic Implementation
- Flutter Backend Integration
- Testing & Validation
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
python manage.py migrate
```

> **Database-First Note**
>
> Since the PostgreSQL schema already existed before Django, the initial migration was applied using:

```bash
python manage.py migrate --fake-initial
```

## Run Development Server

```bash
cd backend
python manage.py runserver
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
REST APIs
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
| Donor CRUD APIs | ✅ Completed |
| Remaining Module APIs | 🚧 In Progress |
| Authentication (JWT) | ⏳ Planned |
| Role-Based Access Control | ⏳ Planned |
| Flutter Integration | ⏳ Planned |
| Deployment | ⏳ Planned |

---

# 📚 Documentation

Project documentation is maintained in:

```text
docs/
└── Backend_Cookbook.md
```

The Backend Cookbook documents the concepts learned while building BloodLink, including:

- Django ORM
- Models
- Migrations
- Django Admin
- Serializers
- APIViews
- URL Routing
- Complete CRUD Operations
- Backend Architecture
- Development Workflow

---

# 👨‍💻 Author

**Muhammad Zarif Rahman**

CSE Undergraduate, CUET

Python • Django • Machine Learning • Cybersecurity

---

# 📄 License

This project is developed for educational purposes.
