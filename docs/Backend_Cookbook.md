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

# Chapter 10 — PUT API

## 🎯 Purpose

A **PUT API** replaces an existing resource with new data.

Unlike **POST**, PUT does **not** create a new resource. Instead, it updates an existing one by replacing its entire representation.

---

## Files

```
donors/views.py
```

---

## Endpoint

```http
PUT /api/donors/<national_ID>/
```

---

## Code

```python
def put(self, request, national_ID):

    donor = get_object_or_404(
        Donor,
        national_ID=national_ID
    )

    serializer = DonorSerializer(
        instance=donor,
        data=request.data
    )

    if serializer.is_valid():

        serializer.save()

        return Response(
            serializer.data,
            status=status.HTTP_200_OK
        )

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST
    )
```

---

## Flow

```text
PUT Request
      │
national_ID
      │
get_object_or_404()
      │
 Existing?
  /        \
No          Yes
│            │
404       Serializer
             │
      instance + data
             │
      serializer.is_valid()
        /            \
     False          True
       │              │
   400 Bad       serializer.save()
                     │
                 PostgreSQL
                     │
               HTTP 200 OK
```

---

## HTTP Status Codes

| Status Code | Meaning |
|--------------|---------|
| **200 OK** | Resource updated successfully |
| **400 Bad Request** | Validation failed |
| **404 Not Found** | Resource does not exist |

---

## Important Concepts

### instance=

```python
serializer = DonorSerializer(
    instance=donor,
    data=request.data
)
```

Tells the serializer which object should be updated.

---

### get_object_or_404()

```python
donor = get_object_or_404(
    Donor,
    national_ID=national_ID
)
```

Automatically returns **404 Not Found** if the object does not exist.

---

## PUT vs POST

| POST | PUT |
|------|-----|
| Creates a new object | Replaces an existing object |
| Returns 201 Created | Returns 200 OK |
| No existing instance | Requires existing instance |

---

## Common Mistakes

- Forgetting `instance=`
- Using POST instead of PUT
- Updating a non-existing object
- Returning 201 instead of 200

---

## Chapter Summary

After this chapter you can:

- Update existing database records.
- Retrieve an object using its primary key.
- Return proper REST responses.
- Handle missing resources using `get_object_or_404()`.

---

# Chapter 11 — PATCH API

## 🎯 Purpose

A **PATCH API** updates only the fields supplied by the client.

Unlike PUT, PATCH does **not** require sending the entire resource.

---

## Files

```
donors/views.py
```

---

## Endpoint

```http
PATCH /api/donors/<national_ID>/
```

---

## Code

```python
def patch(self, request, national_ID):

    donor = get_object_or_404(
        Donor,
        national_ID=national_ID
    )

    serializer = DonorSerializer(
        instance=donor,
        data=request.data,
        partial=True
    )

    if serializer.is_valid():

        serializer.save()

        return Response(
            serializer.data,
            status=status.HTTP_200_OK
        )

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST
    )
```

---

## Flow

```text
PATCH Request
       │
national_ID
       │
get_object_or_404()
       │
Serializer
       │
partial=True
       │
Validate supplied fields
       │
serializer.save()
       │
PostgreSQL
       │
HTTP 200 OK
```

---

## Important Concepts

### partial=True

```python
serializer = DonorSerializer(
    instance=donor,
    data=request.data,
    partial=True
)
```

Only validates fields included in the request.

Missing fields are ignored.

---

## Example

Request

```json
{
    "city":"Rajshahi"
}
```

Only the city changes.

Everything else remains unchanged.

---

## PUT vs PATCH

| PUT | PATCH |
|------|--------|
| Complete replacement | Partial update |
| All required fields | Only supplied fields |
| Entire object | Changed fields only |

---

## Common Mistakes

- Forgetting `partial=True`
- Assuming PATCH skips validation
- Using PATCH for complete replacement

---

## Chapter Summary

After this chapter you can:

- Partially update database records.
- Validate only changed fields.
- Use PATCH correctly in REST APIs.

---

# Chapter 12 — DELETE API

## 🎯 Purpose

A **DELETE API** removes an existing resource from the database.

Unlike POST, PUT and PATCH, DELETE does not require a serializer because no incoming data needs validation.

---

## Files

```
donors/views.py
```

---

## Endpoint

```http
DELETE /api/donors/<national_ID>/
```

---

## Code

```python
def delete(self, request, national_ID):

    donor = get_object_or_404(
        Donor,
        national_ID=national_ID
    )

    donor.delete()

    return Response(
        status=status.HTTP_204_NO_CONTENT
    )
```

---

## Flow

```text
DELETE Request
        │
national_ID
        │
get_object_or_404()
        │
 Existing?
 /        \
No        Yes
│           │
404     donor.delete()
             │
        PostgreSQL
             │
     HTTP 204 No Content
```

---

## HTTP Status Codes

| Status Code | Meaning |
|--------------|---------|
| **204 No Content** | Resource deleted successfully |
| **404 Not Found** | Resource not found |

---

## Important Concepts

### delete()

```python
donor.delete()
```

Deletes the object from PostgreSQL.

Unlike POST, PUT and PATCH, no serializer is required.

---

## Why 204?

A successful DELETE returns

```http
204 No Content
```

because the deleted resource no longer exists.

---

## Common Mistakes

- Using serializer unnecessarily.
- Returning deleted data.
- Returning 200 instead of 204.
- Forgetting `get_object_or_404()`.

---

## Chapter Summary

After this chapter you can:

- Delete database records.
- Return correct REST status codes.
- Complete the CRUD cycle using Django REST Framework.

---

# 🎉 CRUD Completed

```
CRUD Progress

Create (POST)    ✅
Read (GET)       ✅
Update (PUT)     ✅
Update (PATCH)   ✅
Delete (DELETE)  ✅
```
# Chapter 13 — Password Hashing

## 🎯 Purpose

Passwords should **never** be stored as plain text inside a database.

Instead, they must be converted into a secure cryptographic hash before being stored.

When a user attempts to log in, Django compares the entered password with the stored hash instead of comparing plain text.

---

# Why is Password Hashing Needed?

Imagine BloodLink stores passwords like this:

| Email | Password |
|--------|----------|
| admin@bloodlink.com | admin123 |
| martin@bloodlink.com | 456 |
| staff@bloodlink.com | password |

Suppose someone gains access to the PostgreSQL database.

They instantly know everyone's password.

Since many people reuse passwords across different websites, this could compromise:

- Gmail
- Facebook
- University Portals
- Banking Apps
- Other online services

This is one of the biggest security risks in software development.

---

# What is Hashing?

Hashing converts data into a fixed-length string.

Example

```
Password

↓

Hash Function

↓

pbkdf2_sha256$1000000$......
```

Unlike encryption,

hashing **cannot be reversed**.

There is no function like

```python
unhash_password()
```

that returns the original password.

Instead, Django hashes the entered password again and compares the hashes.

---

# Plain Text vs Hashed Password

Plain Text

```
Password

↓

123456
```

Stored in PostgreSQL

```
123456
```

Anyone can read it.

---

Hashed Password

```
Password

↓

make_password()

↓

pbkdf2_sha256$1000000$...
```

Stored in PostgreSQL

```
pbkdf2_sha256$1000000$...
```

The original password cannot be seen.

---

# Files

```
users/

├── serializers.py
├── views.py
└── models.py
```

---

# Why Serializer?

Our POST API creates users using

```python
serializer.save()
```

Instead of modifying the View every time,

we modify the Serializer.

This guarantees that **every new user** automatically has a hashed password.

---

# Required Import

```python
from django.contrib.auth.hashers import make_password
```

---

# Complete Serializer Code

```python
from rest_framework import serializers

from django.contrib.auth.hashers import make_password

from .models import User


class UserSerializer(serializers.ModelSerializer):

    class Meta:

        model = User

        fields = "__all__"


    def create(self, validated_data):

        validated_data["password"] = make_password(

            validated_data["password"]

        )

        return User.objects.create(

            **validated_data

        )


    def update(self, instance, validated_data):

        if "password" in validated_data:

            validated_data["password"] = make_password(

                validated_data["password"]

            )

        return super().update(

            instance,

            validated_data

        )
```

---

# Understanding create()

Whenever

```python
serializer.save()
```

is called for a new object,

Django internally executes

```python
create()
```

Our overridden version first hashes the password

before creating the user.

---

Internal Flow

```
POST Request
      │
request.data
      │
Serializer
      │
create()
      │
make_password()
      │
Hashed Password
      │
User.objects.create()
      │
PostgreSQL
```

---

# Why update()?

Suppose an administrator changes a staff member's password.

Without overriding

```python
update()
```

the password would be saved exactly as entered.

Example

```
123456
```

instead of

```
pbkdf2_sha256...
```

By overriding update(),

every password change is automatically hashed.

---

# Logging In

Hashing alone is not enough.

When a user logs in,

we must verify the entered password.

---

# Required Import

```python
from django.contrib.auth.hashers import check_password
```

---

# Login Logic

```python
if not check_password(

    password,

    user.password

):

    return Response(

        {

            "error":"Invalid email or password"

        },

        status=status.HTTP_401_UNAUTHORIZED

    )
```

---

# How check_password() Works

Suppose

Database

```
pbkdf2_sha256$......
```

User enters

```
456
```

Django performs

```
Entered Password

↓

Hash Again

↓

New Hash

↓

Compare

↓

Match?

↓

True / False
```

The original password is **never recovered**.

---

# Internal Authentication Flow

```
Email
Password
      │
Find User
      │
check_password()
      │
───────────────
│             │
False         True
│             │
401        Continue Login
```

---

# Database Example

Before Hashing

| Email | Password |
|--------|----------|
| martin@bloodlink.com | 456 |

---

After Hashing

| Email | Password |
|--------|----------|
| martin@bloodlink.com | pbkdf2_sha256$1000000$...... |

Notice

The actual password is no longer stored.

---

# Advantages

✔ Passwords cannot be read directly.

✔ Database leaks become much less damaging.

✔ Industry-standard security.

✔ Built into Django.

---

# Common Mistakes

### Saving Plain Text Passwords

Wrong

```python
serializer.save()
```

without hashing.

---

### Comparing Passwords Using ==

Wrong

```python
if password == user.password:
```

Correct

```python
check_password(

    password,

    user.password

)
```

---

### Forgetting update()

Changing passwords later would store plain text again.

---

### Hashing Twice

Wrong

```python
make_password(

    make_password(password)

)
```

Never hash an already hashed password.

---

# Real BloodLink Flow

```
Admin Creates Staff

        │

POST /users/

        │

UserSerializer

        │

create()

        │

make_password()

        │

PostgreSQL

        │

──────────────────────────────

        │

Staff Login

        │

Email

Password

        │

LoginAPIView

        │

check_password()

        │

JWT Generated
```

---

# Chapter Summary

After this chapter, you understand

- Why passwords must never be stored as plain text.
- What hashing is.
- Difference between hashing and encryption.
- How Django hashes passwords.
- How `make_password()` works.
- How `check_password()` works.
- Why Serializer is the correct place for hashing.
- Why both `create()` and `update()` are overridden.

---

# ✅ What I Learned

- Passwords should never be stored directly.
- Django automatically provides secure hashing utilities.
- `make_password()` hashes passwords before storage.
- `check_password()` securely verifies passwords.
- Authentication compares hashes, not plain text.
- Hashing is one of the most important security practices in backend development.
---

# Chapter 14 — JWT (JSON Web Token) Authentication

## 🎯 Purpose

Authentication answers one simple question:

> **Who are you?**

Before allowing access to protected resources, the server must verify the identity of the client.

In BloodLink, only:

- SuperAdmin
- Admin
- Staff

are allowed to log into the system.

Normal donors and blood requesters do **not** log in.

---

# Why Authentication?

Imagine BloodLink has no authentication.

Anyone could send

```
POST /api/donations/
```

and create fake donation records.

Anyone could delete inventory.

Anyone could modify blood requests.

Anyone could change reports.

Clearly,

this is unacceptable.

Authentication prevents unauthorized users from accessing protected APIs.

---

# Before Authentication

```
Browser

      │

POST /api/donors/

      │

APIView

      │

Database
```

The server has no idea who sent the request.

---

# After Authentication

```
Browser

      │

Authorization Header

Bearer <JWT>

      │

APIView

      │

Verify JWT

      │

Authenticated User

      │

Database
```

Now every request has an identity.

---

# What is JWT?

JWT stands for

```
JSON Web Token
```

It is a secure token that proves a user has already logged in.

Instead of sending

```
Email

Password
```

on every request,

the client sends

```
JWT
```

---

# Why JWT?

Without JWT

```
Login

↓

Email
Password

↓

Next Request

↓

Email
Password

↓

Next Request

↓

Email
Password

↓

Next Request

↓

Email
Password
```

Credentials travel through the network repeatedly.

---

With JWT

```
Login

↓

Email
Password

↓

JWT

↓

Future Requests

↓

Bearer JWT

↓

Bearer JWT

↓

Bearer JWT
```

The password is never sent again.

---

# Advantages

✔ Faster

✔ Stateless

✔ More secure

✔ Industry Standard

✔ Works well with Flutter

---

# JWT Structure

A JWT consists of three parts.

```
Header

.

Payload

.

Signature
```

Example

```
eyJhbGc...

.

eyJ1c2VyX0lE...

.

xP7T9...
```

These three sections are separated by dots.

---

# Header

The Header stores metadata.

Example

```json
{
    "alg":"HS256",

    "typ":"JWT"
}
```

Meaning

```
Algorithm

↓

HS256

Type

↓

JWT
```

---

# Payload

The Payload stores information about the user.

In BloodLink we store

```json
{
    "user_ID":"USR003",

    "role":"Admin",

    "exp":1780000000
}
```

Notice

We do **NOT** store

```
Password

Email
```

Passwords should never appear inside a JWT.

---

# Signature

The Signature prevents token tampering.

Suppose someone changes

```
role

↓

Staff

to

↓

SuperAdmin
```

The Signature becomes invalid.

The server immediately rejects the token.

---

# Complete JWT Flow

```
User

│

Email

Password

│

Login API

│

check_password()

│

generate_access_token()

│

JWT

│

Flutter / Browser

│

Store Token

│

────────────────────────────

│

Future Request

│

Authorization Header

Bearer <JWT>

│

Verify Token

│

Load User

│

request.user

│

APIView
```

---

# Folder Structure

```
authentication/

│

├── views.py

├── serializers.py

├── jwt_utils.py

├── authentication.py

└── urls.py
```

Each file has a specific responsibility.

---

# Responsibilities

## serializers.py

Validates

```
Email

Password
```

---

## views.py

Handles

```
Login API

Profile API
```

---

## jwt_utils.py

Responsible for

```
Generate JWT

Verify JWT
```

---

## authentication.py

Reads

```
Authorization Header
```

Verifies the JWT.

Loads the corresponding User.

Stores

```python
request.user
```

---

## urls.py

Connects URLs to the Authentication APIs.

---

# Why We Chose Custom JWT

There were two possible approaches.

## Option A

Use Django's built-in authentication system.

Advantages

- Production standard.
- Less custom code.
- Better integration with Django.

Disadvantages

- Harder to understand initially.
- Requires inheriting from Django's authentication models.

---

## Option B (Chosen)

Build our own JWT authentication.

Advantages

- Easier to learn.
- Full control over every step.
- Better understanding of backend authentication.

Disadvantages

- More code.
- Requires writing our own authentication class.

For BloodLink, we intentionally chose **Option B** because the goal of the project is not only to build software, but also to understand how authentication works internally.

---

# Authentication Components

Our authentication system consists of four major parts.

```
Login Serializer

↓

Login API

↓

JWT Utility

↓

JWT Authentication Class
```

Each component has a different responsibility.

# Chapter 14 — JWT Authentication (Part 2)

---

# Login Serializer

## 🎯 Purpose

Before attempting to log in, we must first verify that the client has sent valid data.

The Login Serializer validates the incoming request.

Unlike `UserSerializer`, it does **not** create a database record.

Its only job is to validate:

- Email
- Password

---

## File

```
authentication/serializers.py
```

---

## Code

```python
from rest_framework import serializers


class LoginSerializer(serializers.Serializer):

    email = serializers.EmailField()

    password = serializers.CharField(
        write_only=True
    )
```

---

## Why Serializer Instead of ModelSerializer?

A login request does **not** create a User.

It simply validates incoming data.

Therefore

```python
serializers.Serializer
```

is sufficient.

---

## Internal Flow

```
Client

│

JSON

│

LoginSerializer

│

Valid?

│

───────────────

│             │

No           Yes

│             │

400        Continue Login
```

---

## Example Request

```json
{
    "email":"martin@bloodlink.com",

    "password":"456"
}
```

---

## Common Mistakes

Using

```python
ModelSerializer
```

instead of

```python
Serializer
```

for login.

---

# Login API

## 🎯 Purpose

Receives

```
Email

Password
```

Checks

- Email exists?
- Password correct?

If successful,

returns a JWT.

---

## File

```
authentication/views.py
```

---

## Required Imports

```python
from rest_framework.views import APIView

from rest_framework.response import Response

from rest_framework import status

from django.contrib.auth.hashers import check_password

from users.models import User

from .serializers import LoginSerializer

from .jwt_utils import generate_access_token
```

---

## Complete LoginAPIView

```python
class LoginAPIView(APIView):

    def post(self, request):

        serializer = LoginSerializer(

            data=request.data

        )

        if not serializer.is_valid():

            return Response(

                serializer.errors,

                status=status.HTTP_400_BAD_REQUEST

            )

        email = serializer.validated_data["email"]

        password = serializer.validated_data["password"]


        try:

            user = User.objects.get(

                email=email

            )

        except User.DoesNotExist:

            return Response(

                {

                    "error":"Invalid email or password"

                },

                status=status.HTTP_401_UNAUTHORIZED

            )


        if not check_password(

            password,

            user.password

        ):

            return Response(

                {

                    "error":"Invalid email or password"

                },

                status=status.HTTP_401_UNAUTHORIZED

            )


        access_token = generate_access_token(user)

        return Response(

            {

                "access":access_token

            },

            status=status.HTTP_200_OK

        )
```

---

# Internal Working

Step 1

Receive JSON.

```
request.data
```

↓

```json
{
    "email":"martin@bloodlink.com",

    "password":"456"
}
```

---

Step 2

Validate

```python
serializer.is_valid()
```

If invalid

↓

Return

```
400 Bad Request
```

---

Step 3

Find User

```python
User.objects.get(

    email=email

)
```

Equivalent SQL

```sql
SELECT *

FROM Users

WHERE email='martin@bloodlink.com';
```

---

Step 4

Verify Password

```python
check_password(

    password,

    user.password

)
```

If incorrect

↓

```
401 Unauthorized
```

---

Step 5

Generate JWT

```python
generate_access_token(

    user

)
```

Returns

```
eyJhbGcOi...
```

---

Step 6

Return Response

```json
{
    "access":"eyJhbGcOi..."
}
```

---

# Complete Login Flow

```
Flutter

│

POST Login

│

request.data

│

LoginSerializer

│

serializer.is_valid()

│

User.objects.get()

│

check_password()

│

generate_access_token()

│

JWT

│

HTTP 200 OK
```

---

# HTTP Status Codes

| Status | Meaning |
|---------|----------|
| 200 OK | Login successful |
| 400 Bad Request | Invalid request body |
| 401 Unauthorized | Invalid email or password |

---

# Why Return Same Error?

Notice

Wrong email

↓

```
Invalid email or password
```

Wrong password

↓

```
Invalid email or password
```

Both return exactly the same message.

Why?

If we returned

```
Email does not exist.
```

An attacker could discover which email addresses are registered.

Using the same error message prevents user enumeration.

---

# Common Mistakes

Returning

```
Email not found
```

instead of

```
Invalid email or password
```

---

Comparing passwords using

```python
==
```

instead of

```python
check_password()
```

---

Returning the User object instead of a JWT.

---

Generating a JWT before verifying the password.

---

# Chapter Summary

After this section you understand

- LoginSerializer
- LoginAPIView
- User lookup
- Password verification
- JWT generation
- Proper REST responses
- Why identical login errors improve security

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
| GET API | ✅ |
| POST API | ✅ |
| PUT API | ✅ |
| PATCH API | ✅ |
| DELETE API | ✅ |
| Authentication | ⏳ |
| JWT | ⏳ |
| RBAC | ⏳ |
| Flutter Integration | ⏳ |


# 📌 Learning Philosophy

Before writing code, always understand:

1. **Why is it needed?**
2. **What problem does it solve?**
3. **How does it work internally?**
4. **Then write the implementation.**
