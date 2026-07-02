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

````md
# Chapter 9 — POST API

## 🎯 Purpose

A **POST API** receives data from the client, validates it, creates a new record in the database, and returns an appropriate HTTP response.

Unlike **GET**, which only retrieves data, **POST** creates a new resource in the database.

---

## Files

```
donors/views.py
```

---

## Endpoint

```http
POST /api/donors/
```

---

## Code

```python
from rest_framework import status

class DonorListAPIView(APIView):

    def post(self, request):

        serializer = DonorSerializer(
            data=request.data
        )

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
```

---

## Flow

```text
Flutter / Browser
        │
HTTP POST Request
        │
request.data
        │
DonorSerializer(data=request.data)
        │
serializer.is_valid()
      /           \
   False         True
     │             │
serializer.errors  serializer.save()
     │             │
400 Bad Request  Django ORM
                    │
                PostgreSQL
                    │
             serializer.data
                    │
             HTTP 201 Created
                    │
             Browser / Flutter
```

---

## Request Example

```json
{
    "national_ID": "12345678901234567",
    "full_name": "Test Donor",
    "date_of_birth": "2002-01-01",
    "gender": "Male",
    "blood_group": "A+",
    "street": "Road 1",
    "area": "Agrabad",
    "city": "Chattogram",
    "user": "USR001"
}
```

---

## Success Response

**HTTP 201 Created**

```json
{
    "national_ID": "12345678901234567",
    "full_name": "Test Donor",
    "date_of_birth": "2002-01-01",
    "gender": "Male",
    "blood_group": "A+",
    "street": "Road 1",
    "area": "Agrabad",
    "city": "Chattogram",
    "user": "USR001"
}
```

---

## Error Response

**HTTP 400 Bad Request**

```json
{
    "blood_group": [
        "\"ABC\" is not a valid choice."
    ]
}
```

---

## Internal Working

1. Client sends JSON data.
2. Data is received through `request.data`.
3. `DonorSerializer(data=request.data)` accepts the incoming data.
4. `serializer.is_valid()` validates:
   - Required fields
   - Data types
   - Choices
   - Validators
5. If validation succeeds:
   - `serializer.save()` creates a new `Donor`.
   - Django ORM inserts the record into PostgreSQL.
6. The API returns:
   - The created donor
   - **HTTP 201 Created**
7. If validation fails:
   - `serializer.errors`
   - **HTTP 400 Bad Request**

---

## Important Concepts

### `request.data`

Contains the JSON sent by the client.

```python
serializer = DonorSerializer(
    data=request.data
)
```

---

### `serializer.is_valid()`

Validates incoming data before saving it.

Returns:

```python
True
```

or

```python
False
```

---

### `serializer.save()`

Creates a new database record using the validated data.

Internally, it is similar to:

```python
Donor.objects.create(...)
```

---

### `serializer.errors`

Contains validation errors if validation fails.

Example:

```json
{
    "blood_group": [
        "\"ABC\" is not a valid choice."
    ]
}
```

---

## HTTP Status Codes

| Status Code | Meaning |
|--------------|---------|
| **201 Created** | Resource created successfully |
| **400 Bad Request** | Validation failed |

---

## GET vs POST

| GET | POST |
|------|------|
| Reads existing data | Creates new data |
| Does not modify the database | Inserts a new record |
| Returns **200 OK** | Returns **201 Created** |

---

## Common Mistakes

- Forgetting `data=request.data`
- Calling `serializer.save()` before `serializer.is_valid()`
- Forgetting to return `serializer.errors`
- Returning **200 OK** instead of **201 Created**
- Sending an invalid Foreign Key (`user`)
- Missing required fields

---

## Chapter Summary

After completing this chapter, you can:

- Receive JSON from the client.
- Validate incoming data.
- Create new database records.
- Return proper HTTP responses.
- Build working POST APIs using Django REST Framework.

This completes the **Create (C)** operation of CRUD.

```text
CRUD Progress

````


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
| POST API | ✅ |
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
