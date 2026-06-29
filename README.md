# 🩸 BloodLink

BloodLink is a Blood Bank Management System being developed as a university DBMS project. The project aims to streamline blood donation, inventory management, request handling, and transportation through a secure and scalable system.

This project follows a **Database-First** development approach, where the database schema is designed and implemented before backend development.

---

## 📌 Features (Planned)

- 👤 User Management (SuperAdmin, Admin, Staff)
- 🩸 Donor Management
- 💉 Blood Donation Tracking
- 🧪 Screening & Test Records
- 🏥 Hospital Request Management
- 📦 Blood Inventory Management
- 🚚 Transportation Tracking
- 💰 Payment Management
- 📊 Reports & Analytics
- 🔒 Role-Based Access Control (RBAC)

---

## 🛠 Tech Stack

### Backend
- Python
- Django
- Django REST Framework

### Database
- PostgreSQL

### Frontend
- Flutter (In Development)

### Version Control
- Git
- GitHub

---

## 📂 Project Structure

```text
BloodLink/
│
├── backend/
│   ├── bloodlink/
│   ├── users/
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

## 🚀 Development Status

### ✅ Completed

- Database Design (ERD)
- Relational Mapping
- PostgreSQL Database
- SQL Schema
- Django Project Setup
- Users App Initialization
- Django ↔ PostgreSQL Connection
- Environment Variable Configuration (.env)

### 🚧 In Progress

- User Module
- Django Models
- REST APIs

### 📅 Planned

- Authentication & Authorization
- Donor Module
- Donation Module
- Inventory Module
- Request Management
- Transport Module
- Payment Module
- Flutter Integration
- Deployment

---

## ⚙️ Setup

### Clone Repository

```bash
git clone https://github.com/Zarif-451/BloodLink.git
cd BloodLink
```

### Create Environment

```bash
conda create -n bloodlink python=3.13
conda activate bloodlink
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Create Environment Variables

Create a `.env` file inside the `backend` directory.

```env
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

### Run Server

```bash
cd backend
python manage.py runserver
```

---

## 📖 Development Approach

This project follows a **Database-First Architecture**.

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

## 👨‍💻 Author

**Muhammad Zarif Rahman**

- CSE Undergraduate, CUET
- Python • Django • Machine Learning • Cybersecurity

---

## 📄 License

This project is developed for educational purposes.
