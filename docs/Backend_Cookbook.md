# 📘 BloodLink Backend Cookbook

> A personal backend handbook created while building **BloodLink**.
>
> Development Approach:
>
> **Learn → Build → Document → Repeat**

---

# 🏗️ Backend Architecture

```
                 Browser / Flutter
                        │
                  HTTP Request
                        │
                        ▼
             Project URL (bloodlink/urls.py)
                        │
                        ▼
               App URL (donors/urls.py)
                        │
                        ▼
                 APIView (views.py)
                        │
                        ▼
              Donor.objects.all()
                        │
                        ▼
                 Django ORM
                        │
                        ▼
                  PostgreSQL
                        │
                        ▼
                 Django ORM
                        │
                        ▼
                 Python Objects
                        │
                        ▼
                 DonorSerializer
                        │
                        ▼
                      JSON
                        │
                        ▼
               HTTP Response (200 OK)
                        │
                        ▼
                 Browser / Flutter
```

---

# Chapter 1 — Database

## 🎯 Purpose

The database permanently stores all application data.

BloodLink stores:

- Users
- Donors
- Donations
- Blood Inventory
- Requests
- Branches
- Transport
- Payments
- Reports

---

## Technologies

- PostgreSQL
- pgAdmin

---

## Development Workflow

```
ERD
    ↓
Relational Mapping
    ↓
PostgreSQL Database
```

---

## Project Files

```
database/
│
├── bloodlink_schema.sql
├── BloodLink_ERD.png
└── BloodLink_Relational_Mapping.pdf
```

---

## Common Mistakes

- Wrong Primary Key
- Missing Foreign Keys
- Missing Constraints
- Poor normalization

---

# Chapter 2 — ORM (Object Relational Mapper)

## 🎯 Purpose

The ORM converts Python code into SQL.

Instead of writing SQL manually:

```sql
SELECT *
FROM Donors;
```

We write:

```python
Donor.objects.all()
```

---

## Flow

```
Python
    │
ORM
    │
SQL
    │
PostgreSQL
```

---

## Frequently Used Methods

```python
Donor.objects.all()

Donor.objects.get(...)

Donor.objects.filter(...)

Donor.objects.create(...)
```

---

## Files

```
*/models.py
```

---

## Common Mistakes

- Writing raw SQL unnecessarily.
- Forgetting the ORM already provides the query.

---

# Chapter 3 — Models

## 🎯 Purpose

Models represent database tables as Python classes.

---

## Files

```
users/models.py

donors/models.py

requests/models.py

donations/models.py

inventory/models.py

branches/models.py

transport/models.py

payment/models.py
```

---

## Example

```python
class Donor(models.Model):

    national_ID = models.CharField(...)

    full_name = models.CharField(...)
```

---

## Flow

```
Model
    │
ORM
    │
PostgreSQL
```

---

## Common Mistakes

- Wrong field type
- Wrong ForeignKey
- Missing constraints

---

# Chapter 4 — Migrations

## 🎯 Purpose

Synchronize Django Models with PostgreSQL.

---

## Files

```
*/migrations/
```

---

## Commands

Generate migrations

```bash
python manage.py makemigrations
```

Apply migrations

```bash
python manage.py migrate
```

Database-first approach

```bash
python manage.py migrate --fake-initial
```

---

## Flow

```
Models
    │
makemigrations
    │
Migration Files
    │
migrate
    │
Database Updated
```

---

## Common Mistakes

- Running migrate before makemigrations
- Editing migration files manually

---

# Chapter 5 — Django Admin

## 🎯 Purpose

Provides an administration panel to manage database records.

---

## Files

```
*/admin.py
```

---

## Example

```python
from django.contrib import admin
from .models import Donor

admin.site.register(Donor)
```

---

## Commands

Create Superuser

```bash
python manage.py createsuperuser
```

Run Server

```bash
python manage.py runserver
```

Admin URL

```
http://127.0.0.1:8000/admin/
```

---

## Flow

```
Superuser
      │
Django Admin
      │
Models
      │
Database
```

---

## Common Mistakes

- Forgetting to register models
- Trying to register models with composite primary keys

---

# Chapter 6 — Serializer

## 🎯 Purpose

Converts

```
Python Objects ⇄ JSON
```

Also validates incoming data.

---

## Files

```
donors/serializers.py
```

---

## Code

```python
from rest_framework import serializers
from .models import Donor


class DonorSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donor
        fields = "__all__"
```

---

## Flow

```
Python Objects
        │
Serializer
        │
JSON
```

---

## Common Mistakes

- Forgetting `many=True`
- Wrong model
- Missing serializer

---

# Chapter 7 — APIView

## 🎯 Purpose

Receives HTTP requests.

Coordinates:

- Models
- ORM
- Serializer
- Response

---

## Files

```
donors/views.py
```

---

## Code

```python
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Donor
from .serializers import DonorSerializer


class DonorListAPIView(APIView):

    def get(self, request):

        donors = Donor.objects.all()

        serializer = DonorSerializer(
            donors,
            many=True
        )

        return Response(serializer.data)
```

---

## Flow

```
GET Request
      │
APIView
      │
ORM
      │
Serializer
      │
Response
```

---

## Common Mistakes

- Returning Python objects directly
- Forgetting the serializer
- Forgetting Response()

---

# Chapter 8 — URL Routing

## 🎯 Purpose

Maps URLs to API Views.

---

## Files

Project URLs

```
bloodlink/urls.py
```

App URLs

```
donors/urls.py
```

---

## Project URL

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),

    path(
        "api/donors/",
        include("donors.urls")
    ),
]
```

---

## App URL

```python
from django.urls import path

from .views import DonorListAPIView

urlpatterns = [

    path(
        "",
        DonorListAPIView.as_view(),
        name="donor-list"
    ),

]
```

---

## Flow

```
Browser
      │
Project URLs
      │
App URLs
      │
APIView
```

---

## Common Mistakes

- Forgetting include()
- Wrong URL
- Missing `.as_view()`

---

# 🎉 First Working REST API

Endpoint

```
GET /api/donors/
```

Browser

```
http://127.0.0.1:8000/api/donors/
```

Current Response

```json
[]
```

Meaning:

- URL Routing ✅
- APIView ✅
- Serializer ✅
- ORM ✅
- PostgreSQL ✅

The table is simply empty.

---

# 📈 Current Progress

| Chapter | Status |
|----------|--------|
| Database | ✅ |
| ORM | ✅ |
| Models | ✅ |
| Migrations | ✅ |
| Django Admin | ✅ |
| Serializer | ✅ |
| APIView | ✅ |
| URL Routing | ✅ |
| First GET API | ✅ |
| POST API | ⏳ |
| PUT | ⏳ |
| PATCH | ⏳ |
| DELETE | ⏳ |
| Authentication | ⏳ |
| JWT | ⏳ |
| RBAC | ⏳ |
| Flutter Integration | ⏳ |

---

# 📌 Learning Philosophy

Before writing code, always understand:

1. **Why is it needed?**
2. **What problem does it solve?**
3. **How does it work internally?**
4. **Then write the implementation.**

Following this approach makes it easier to remember concepts and apply them to new modules.
