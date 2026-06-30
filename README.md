# 🩸 BloodLink

BloodLink is a Blood Bank Management System developed as a university DBMS project. It aims to streamline blood donation, donor management, blood inventory, request handling, transportation, and payment management through a secure and scalable system.

The project follows a **Database-First Development Approach**, where the database schema is fully designed and implemented before backend development.

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
│   ├── payments/
│   └── manage.py
│
├── database/
│   ├── bloodlink_schema.sql
│   ├── BloodLink_ERD.png
│   └── BloodLink_Relational_Mapping.pdf
│
├── frontend/
│
└── README.md
```

---

# 🗄 Database Modules

The system currently consists of the following database modules:

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

---

## 🚧 In Progress

- Django Admin Configuration
- REST API Development
- Authentication & Authorization
- CRUD Operations

---

## 📅 Planned

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

## Run Development Server

```bash
cd backend
python manage.py runserver
```

---

# 📖 Development Workflow

This project follows a **Database-First Development Workflow**.

```text
ERD
    ↓
Relational Mapping
    ↓
PostgreSQL Database
    ↓
Django Models
    ↓
REST API
    ↓
Flutter Frontend
```

---

# 🎯 Current Progress

### Database Layer
- ✅ Completed

### Django Models
- ✅ Completed

### Backend Development
- 🚧 In Progress

### Frontend Integration
- ⏳ Pending

---

# 👨‍💻 Author

**Muhammad Zarif Rahman**

CSE Undergraduate, CUET

Python • Django • Machine Learning • Cybersecurity

---

# 📄 License

This project is developed for educational purposes.
