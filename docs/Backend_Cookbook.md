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

# Chapter 14 — JWT Authentication (Part 3)

---

# JWT Utility

## 🎯 Purpose

The Login API verifies the user's credentials.

After successful verification, the server must generate a JWT that the client can use for future requests.

Instead of writing JWT logic inside the View, we place it inside a utility module.

This keeps the code organized and reusable.

---

# File

```
authentication/jwt_utils.py
```

---

# Required Libraries

```python
import jwt

from datetime import datetime
from datetime import timedelta
from django.conf import settings
```

---

# Why PyJWT?

PyJWT is a Python library used for creating and verifying JSON Web Tokens.

Instead of manually encrypting and signing data,

PyJWT provides secure implementations of the JWT standard.

---

# generate_access_token()

## Complete Code

```python
def generate_access_token(user):

    payload = {

        "user_ID": user.user_ID,

        "role": user.role,

        "exp": datetime.utcnow() + timedelta(minutes=15)

    }

    token = jwt.encode(

        payload,

        settings.SECRET_KEY,

        algorithm="HS256"

    )

    return token
```

---

# Understanding the Payload

The payload stores information about the logged-in user.

```python
payload = {

    "user_ID": user.user_ID,

    "role": user.role,

    "exp": datetime.utcnow() + timedelta(minutes=15)

}
```

---

## user_ID

Stores

```
USR003
```

Later,

our authentication class will use this value to retrieve the correct User from PostgreSQL.

---

## role

Stores

```
Admin
```

This will later help implement

Role-Based Access Control (RBAC).

Instead of querying the database repeatedly,

the token already contains the user's role.

---

## exp

```
Expiration Time
```

Example

Current Time

```
10:00 AM
```

Token Lifetime

```
15 Minutes
```

Expires

```
10:15 AM
```

After expiration,

the token becomes invalid.

The user must log in again.

---

# Why Expiration?

Imagine a user loses their laptop.

If tokens never expired,

anyone with the token could access BloodLink forever.

Expiration limits the lifetime of stolen tokens.

---

# Creating the JWT

```python
token = jwt.encode(

    payload,

    settings.SECRET_KEY,

    algorithm="HS256"

)
```

---

## What Happens Internally?

```
Payload

↓

SECRET_KEY

↓

HS256

↓

JWT
```

The SECRET_KEY signs the token.

Anyone modifying the payload will invalidate the signature.

---

# Example Generated JWT

```
eyJhbGcOiJIUzI1NiIsInR5cCI6IkpXVCJ9

.

eyJ1c2VyX0lEIiOiJVNSMDAzIiwicm9sZSI6IkFkbWluIiwiZXhwIjoxNzgwMDAwMDB9

.

Q9kL0vYw...
```

Although it looks random,

it contains:

```
Header

Payload

Signature
```

---

# verify_access_token()

## Purpose

Generate Access Token

↓

Client Stores Token

↓

Future Request

↓

Verify Token

---

## Complete Code

```python
def verify_access_token(token):

    try:

        payload = jwt.decode(

            token,

            settings.SECRET_KEY,

            algorithms=["HS256"]

        )

        return payload

    except jwt.ExpiredSignatureError:

        return None

    except jwt.InvalidTokenError:

        return None
```

---

# Internal Working

```
JWT

↓

jwt.decode()

↓

Valid?

───────────────

│             │

No           Yes

│             │

None      Payload
```

---

# Successful Decode

Returns

```python
{

    "user_ID":"USR003",

    "role":"Admin",

    "exp":1780000000

}
```

Notice

We no longer have a string.

We now have a Python dictionary.

---

# Expired Token

If

```
Current Time

>

Expiration Time
```

PyJWT raises

```python
jwt.ExpiredSignatureError
```

We return

```python
None
```

The request is rejected.

---

# Invalid Token

Suppose someone sends

```
Bearer 123
```

PyJWT raises

```python
jwt.InvalidTokenError
```

Again,

we return

```python
None
```

---

# Authentication Class

## Purpose

Every protected request sends

```
Authorization

Bearer <JWT>
```

The Authentication Class performs four tasks.

```
Read Header

↓

Extract Token

↓

Verify JWT

↓

Load User
```

---

# File

```
authentication/authentication.py
```

---

# Required Imports

```python
from rest_framework.authentication import BaseAuthentication

from rest_framework.exceptions import AuthenticationFailed

from users.models import User

from .jwt_utils import verify_access_token
```

---

# Complete Authentication Class

```python
class JWTAuthentication(BaseAuthentication):

    def authenticate(self, request):

        auth_header = request.headers.get(

            "Authorization"

        )

        if not auth_header:

            return None

        parts = auth_header.split()

        if len(parts) != 2 or parts[0] != "Bearer":

            raise AuthenticationFailed(

                "Invalid Authorization header."

            )

        token = parts[1]

        payload = verify_access_token(token)

        if payload is None:

            raise AuthenticationFailed(

                "Invalid or expired token."

            )

        try:

            user = User.objects.get(

                user_ID=payload["user_ID"]

            )

        except User.DoesNotExist:

            raise AuthenticationFailed(

                "User not found."

            )

        return (

            user,

            token

        )
```

---

# Internal Authentication Flow

```
Request

│

Authorization Header

│

JWTAuthentication

│

Read Header

│

Bearer?

│

Verify Token

│

Payload

│

User.objects.get()

│

request.user

│

APIView
```

---

# Why Return (user, token)?

DRF expects

```python
(user, auth)
```

The framework automatically performs

```python
request.user = user

request.auth = token
```

This is why every protected API can simply write

```python
request.user
```

without querying the database again.

---

# Profile API

```python
class ProfileAPIView(APIView):

    authentication_classes = [

        JWTAuthentication

    ]

    def get(self, request):

        return Response({

            "user_ID": request.user.user_ID,

            "full_name": request.user.full_name,

            "email": request.user.email,

            "role": request.user.role,

            "status": request.user.status,

        })
```

---

# Authentication Flow

```
POST Login

↓

Email

↓

Password

↓

check_password()

↓

JWT Generated

↓

Flutter Stores JWT

↓

────────────────────────

↓

Future Request

↓

Authorization Header

↓

JWTAuthentication

↓

Verify JWT

↓

User Loaded

↓

request.user

↓

APIView
```

---

# Common Mistakes We Encountered

### 1. Plain-text Passwords

Wrong

```
Password = 456
```

Correct

```
pbkdf2_sha256...
```

---

### 2. Missing urlpatterns

Authentication URLs were not registered.

---

### 3. Typo

Wrong

```python
user = user.objects.get(...)
```

Correct

```python
user = User.objects.get(...)
```

---

### 4. Mixing Authentication Systems

We accidentally used

```
rest_framework_simplejwt.authentication.JWTAuthentication
```

while also using our own

```
authentication.authentication.JWTAuthentication
```

The project should use **one** authentication system consistently.

---

# Chapter Summary

After this chapter you understand

- JWT generation
- JWT verification
- JWT payload
- JWT expiration
- JWT signature
- Custom authentication class
- Authorization header
- `request.user`
- Protected APIs
- How Django REST Framework authenticates requests internally

# Chapter 15 — API Testing with Postman

## 🎯 Purpose

Building an API is only half of backend development.

Every API must be tested before it is used by Flutter or any frontend application.

Postman acts as a client that sends HTTP requests to the backend exactly like Flutter would.

This allows us to verify that our APIs work correctly before integrating the frontend.

---

# Why Postman?

Without Postman

```
Backend

↓

Flutter

↓

Test
```

Every backend change requires rebuilding or rerunning the frontend.

---

With Postman

```
Backend

↓

Postman

↓

Immediate Testing
```

No frontend is required.

---

# Advantages

✔ Test APIs independently.

✔ Send custom HTTP requests.

✔ Send JSON data.

✔ Send JWT Authentication headers.

✔ Debug APIs quickly.

✔ Verify status codes.

✔ Save requests into collections.

---

# Installing Postman

Official Website

```
https://www.postman.com/
```

After installation,

create a workspace for the project.

---

# Creating a Collection

Collections organize API requests.

Example

```
BloodLink API

│

├── Authentication

│      ├── Login

│      └── Profile

│

├── Users

├── Donors

├── Donations

├── Inventory

├── Requests

├── Transport

└── Payments
```

As the project grows,

all APIs remain organized.

---

# Understanding an HTTP Request

Every HTTP request consists of several parts.

```
Method

URL

Headers

Body
```

---

Example

```
POST

http://127.0.0.1:8000/api/authentication/login/
```

Headers

```
Content-Type:

application/json
```

Body

```json
{
    "email":"martin@bloodlink.com",

    "password":"456"
}
```

---

# Testing Login API

## Endpoint

```
POST

/api/authentication/login/
```

---

## Body

```json
{
    "email":"martin@bloodlink.com",

    "password":"456"
}
```

---

## Expected Response

Status

```
200 OK
```

Response

```json
{
    "access":"eyJhbGcOiJIUzI1NiIs..."
}
```

The JWT is now ready to be used.

---

# Saving the JWT

Copy

```
access
```

Example

```
eyJhbGcOiJIUzI1NiIs...
```

The client (Flutter)

would normally save this token

inside secure local storage.

During development,

we manually copy it into Postman.

---

# Testing Protected APIs

Example

```
GET

/api/authentication/profile/
```

---

# Authorization Header

Headers

```
Authorization

Bearer eyJhbGcOiJIUzI1NiIs...
```

Notice

```
Bearer

(space)

Token
```

The space is mandatory.

---

# Internal Flow

```
Postman

│

Authorization Header

│

JWTAuthentication

│

verify_access_token()

│

User.objects.get()

│

request.user

│

APIView

│

Response

│

Postman
```

---

# Authentication Test Cases

During development,

three important test cases were performed.

---

## Test Case 1

### No Authorization Header

Request

```
GET

/api/authentication/profile/
```

Headers

```
None
```

Expected Result

```
403 Forbidden
```

Meaning

The API correctly rejected anonymous users.

---

## Test Case 2

### Invalid JWT

Headers

```
Authorization

Bearer 123
```

Expected Result

```
403 Forbidden
```

Response

```json
{
    "detail":"Invalid or expired token."
}
```

Meaning

Our authentication system correctly rejected an invalid token.

---

## Test Case 3

### Valid JWT

Headers

```
Authorization

Bearer eyJhbGcOi...
```

Expected Result

```
200 OK
```

Response

```json
{
    "user_ID":"USR003",

    "full_name":"Martin",

    "email":"martin@bloodlink.com",

    "role":"Admin",

    "status":"Active"
}
```

Meaning

The token was verified successfully,

and

```python
request.user
```

was populated correctly.

---

# HTTP Status Codes

| Status | Meaning |
|---------|----------|
| 200 OK | Request successful |
| 201 Created | Resource created |
| 204 No Content | Resource deleted |
| 400 Bad Request | Validation failed |
| 401 Unauthorized | Authentication failed |
| 403 Forbidden | Access denied |
| 404 Not Found | Resource not found |
| 500 Internal Server Error | Server-side bug |

---

# Debugging Journey

While implementing authentication,

several issues were encountered.

---

## Problem 1

Passwords stored as plain text.

Solution

```
make_password()
```

---

## Problem 2

Missing

```
urlpatterns
```

inside

```
authentication/urls.py
```

---

## Problem 3

Typo

Wrong

```python
user = user.objects.get(...)
```

Correct

```python
user = User.objects.get(...)
```

---

## Problem 4

Mixing

```
Simple JWT
```

and

```
Custom JWT
```

inside

```
settings.py
```

Only one authentication system should be active.

---

# API Testing Workflow

```
Postman

↓

HTTP Request

↓

URL Routing

↓

APIView

↓

Authentication

↓

Serializer

↓

ORM

↓

PostgreSQL

↓

ORM

↓

Serializer

↓

HTTP Response

↓

Postman
```

---

# Common Mistakes

### Wrong HTTP Method

Using

```
GET
```

instead of

```
POST
```

---

### Wrong Endpoint

```
/login
```

instead of

```
/api/authentication/login/
```

---

### Missing JSON

Forgetting

```
Content-Type

application/json
```

---

### Missing Authorization Header

```
Authorization

Bearer ...
```

---

### Expired JWT

After expiration,

the user must log in again.

---

### Invalid Bearer Format

Wrong

```
BearereyJ...
```

Correct

```
Bearer eyJ...
```

Notice the space.

---

# Real BloodLink Testing Flow

```
Start Django Server

↓

Open Postman

↓

Login

↓

Receive JWT

↓

Copy JWT

↓

Open Protected API

↓

Add Authorization Header

↓

Send Request

↓

Receive Response

↓

Repeat
```

---

# Chapter Summary

After completing this chapter,

you can

- Install Postman.
- Create collections.
- Test APIs independently.
- Send JSON requests.
- Send JWT authentication headers.
- Verify protected APIs.
- Debug backend APIs.
- Interpret HTTP status codes.
- Test authentication using different scenarios.

---

# ✅ What I Learned

- Postman simulates a real frontend client.
- Every API should be tested before frontend integration.
- JWTs are sent through the `Authorization` header.
- Protected APIs can be verified independently.
- Systematic testing makes backend debugging significantly easier.

---

# 🎉 Backend Progress

```
Database                  ✅

ORM                       ✅

Models                    ✅

Migrations                ✅

Django Admin              ✅

Serializer                ✅

APIView                   ✅

URL Routing               ✅

CRUD APIs                 ✅

Password Hashing          ✅

Custom JWT Authentication ✅

Postman Testing           ✅

────────────────────────────

Role-Based Access Control ⏳

Auto ID Generation        ⏳

Business Logic            ⏳

Flutter Integration       ⏳
```

---

# Next Chapter

```
Chapter 16

Role-Based Access Control (RBAC)
```

In the next chapter, the authentication system will be extended to control **what each type of user is allowed to do**.

Instead of simply identifying users, BloodLink will enforce permissions based on their roles:

- **SuperAdmin**
- **Admin**
- **Staff**

This will complete the **Authorization** phase of the backend.

# Chapter 16 — Role-Based Access Control (RBAC)

## 🎯 Purpose

Authentication answers:

> **Who are you?**

Authorization answers:

> **What are you allowed to do?**

After a user logs in successfully, BloodLink must determine which operations that user is permitted to perform.

This is achieved using **Role-Based Access Control (RBAC).**

---

# Why RBAC?

Imagine every authenticated user could:

- Delete branches
- Promote themselves to SuperAdmin
- Approve payments
- Generate nationwide reports

Authentication alone cannot prevent this.

RBAC restricts actions according to the user's role.

---

# BloodLink Roles

```
SuperAdmin
        │
        ├── Full System Access
        │
Admin
        │
        ├── Own Branch Management
        │
Staff
        │
        └── Daily Operations
```

---

# Responsibilities

## SuperAdmin

- Manage branches
- Manage admins
- Manage staff
- Manage all operations
- Generate reports
- View nationwide reports

---

## Admin

- Manage own branch
- Manage staff
- Manage donors
- Manage donations
- Manage inventory
- Manage requests
- Manage transport
- Manage payments
- Generate reports

---

## Staff

- Register donors
- Record donations
- Record screenings
- Update inventory
- Review requests
- Approve or reject requests
- Record transport
- Record payments

Staff cannot manage:

- Branches
- Admins
- User roles
- Reports

---

# Authentication vs Authorization

```
JWT Authentication

↓

request.user

↓

RBAC

↓

Permission Granted?

↓

APIView
```

Authentication identifies the user.

RBAC decides whether that user may continue.

---

# Files

```
users/

├── permissions.py
```

---

# Internal Flow

```
HTTP Request

↓

JWT Authentication

↓

request.user

↓

Permission Class

↓

Allowed?

───────────────

│             │

No           Yes

│             │

403        APIView
```

---

# Advantages

✔ Centralized permission logic

✔ Easy to maintain

✔ Reusable across every app

✔ Prevents unauthorized operations

---

# Common Mistakes

- Mixing authentication with authorization.
- Writing role checks inside every API.
- Forgetting to protect sensitive APIs.

---

# Chapter Summary

After this chapter you understand:

- Authentication vs Authorization
- RBAC
- User roles
- Permission checking

# Chapter 17 — Custom Permission Classes

## 🎯 Purpose

Instead of checking user roles inside every API View, Django REST Framework allows reusable permission classes.

Each permission class represents one business capability.

---

# File

```
users/permissions.py
```

---

# Example

```python
from rest_framework.permissions import BasePermission


class CanManageInventory(BasePermission):

    def has_permission(self, request, view):

        return request.user.role in [

            "SuperAdmin",

            "Admin",

            "Staff"

        ]
```

---

# Permission Flow

```
Request

↓

JWT Authentication

↓

request.user

↓

Permission Class

↓

True?

───────────────

│             │

False        True

│             │

403        Continue
```

---

# Using Permissions

```python
class InventoryListAPIView(

    generics.ListCreateAPIView

):

    permission_classes = [

        CanManageInventory

    ]
```

---

# Permission Classes Created

```text
IsSuperAdmin

CanManageBranches

CanManageAdmins

CanManageStaff

CanManageDonors

CanManageDonations

CanManageScreenings

CanManageInventory

CanManageBloodRequests

CanManageTransport

CanManagePayments

CanGenerateReports

CanViewNationwideReports
```

---

# Why Separate Classes?

Instead of

```python
if request.user.role == "Admin":
```

inside every API,

we write reusable permission classes once.

Every module simply imports them.

---

# Advantages

✔ Cleaner code

✔ Easy to reuse

✔ Easy to modify

✔ Business rules remain centralized

---

# Common Mistakes

- Writing role checks inside views.
- Forgetting to assign `permission_classes`.
- Creating duplicate permission classes.

---

# Chapter Summary

After this chapter you understand:

- `BasePermission`
- `has_permission()`
- `permission_classes`
- Reusable authorization

# Chapter 18 — Generic Views

## 🎯 Purpose

APIView gives complete control but often requires writing repetitive CRUD code.

Generic Views eliminate this boilerplate.

---

# Why Generic Views?

Instead of manually writing

- GET
- POST
- PUT
- PATCH
- DELETE

for every model,

DRF already provides them.

---

# Common Generic Views

```python
ListCreateAPIView

RetrieveUpdateDestroyAPIView
```

---

# Example

```python
class PaymentListAPIView(

    generics.ListCreateAPIView

):

    permission_classes = [

        CanManagePayments

    ]

    queryset = Payment.objects.all()

    serializer_class = PaymentSerializer
```

---

```python
class PaymentRetrieveUpdateDestroyAPIView(

    generics.RetrieveUpdateDestroyAPIView

):

    permission_classes = [

        CanManagePayments

    ]

    queryset = Payment.objects.all()

    serializer_class = PaymentSerializer

    lookup_field = "payment_ID"

    lookup_url_kwarg = "payment_ID"
```

---

# Internal Flow

```
HTTP Request

↓

Generic View

↓

Serializer

↓

ORM

↓

PostgreSQL

↓

Response
```

---

# Why lookup_field?

Our project uses custom primary keys.

Example

```
payment_ID

transport_ID

inventory_ID

allocation_ID
```

Therefore we specify

```python
lookup_field = "payment_ID"
```

instead of Django's default `pk`.

---

# Advantages

✔ Less code

✔ Easier maintenance

✔ Cleaner CRUD

✔ Consistent APIs

---

# Common Mistakes

- Forgetting `queryset`
- Forgetting `serializer_class`
- Forgetting `lookup_field`
- Forgetting `permission_classes`

---

# Chapter Summary

After this chapter you understand:

- Generic Views
- ListCreateAPIView
- RetrieveUpdateDestroyAPIView
- lookup_field
- lookup_url_kwarg

# Chapter 19 — Automatic ID Generation

## 🎯 Purpose

Instead of manually assigning IDs,

BloodLink automatically generates unique IDs for every new record.

Examples

```
USR0001

DON0001

REQ0001

INV0001

PAY0001
```

This keeps IDs

- Unique
- Readable
- Consistent

throughout the system.

---

# Why Auto ID Generation?

Without automatic generation,

every API request would require

```json
{
    "user_ID":"USR0007"
}
```

The client would have to guess the next available ID.

This is error-prone and could easily produce duplicate IDs.

Instead,

the backend generates IDs automatically.

---

# Files

```
utils/

├── __init__.py

└── id_generator.py
```

---

# Complete Code

```python
from django.db.models import Max


def generate_next_ID(

    model,

    id_field,

    prefix

):

    result = model.objects.aggregate(

        Max(id_field)

    )

    largest_ID = result[

        id_field + "__max"

    ]

    if largest_ID is None:

        return prefix + "0001"


    number = largest_ID[

        len(prefix):

    ]

    number = int(number)

    number += 1

    number = f"{number:04d}"

    return prefix + number
```

---

# Internal Working

Suppose the Users table contains

```
USR0001

USR0002

USR0003
```

The function performs

```
Users Table

↓

aggregate(Max)

↓

USR0003

↓

Extract

0003

↓

Integer

3

↓

+1

↓

4

↓

Format

0004

↓

USR0004
```

The generated ID is then returned.

---

# Understanding aggregate()

```python
result = model.objects.aggregate(

    Max(id_field)

)
```

Django asks PostgreSQL

```
What is the largest value
of this column?
```

Equivalent SQL

```sql
SELECT MAX(user_ID)

FROM Users;
```

Example

```python
{

    "user_ID__max":"USR0007"

}
```

---

# Why "__max"?

The returned dictionary contains

```
field_name

+

__max
```

Example

```python
result["user_ID__max"]
```

returns

```
USR0007
```

---

# Extracting the Number

The prefix

```
USR
```

must be removed.

```python
number = largest_ID[

    len(prefix):

]
```

Example

```
USR0007

↓

0007
```

---

# Incrementing

Convert

```
0007
```

to

```python
7
```

Add one

```python
8
```

Then format

```python
0008
```

using

```python
f"{number:04d}"
```

Finally

```
USR0008
```

is returned.

---

# Using the Generator

Example

```python
def create(

    self,

    validated_data

):

    validated_data["user_ID"] = generate_next_ID(

        User,

        "user_ID",

        "USR"

    )

    return User.objects.create(

        **validated_data

    )
```

The serializer automatically assigns the next ID before creating the object.

---

# Internal Flow

```
POST Request

↓

Serializer

↓

generate_next_ID()

↓

Find Largest ID

↓

Increment

↓

Assign New ID

↓

serializer.save()

↓

PostgreSQL
```

---

# Why Serializer?

The serializer controls object creation.

By generating IDs inside

```python
create()
```

every new object automatically receives a valid ID.

Views remain clean,

and no client can manually choose IDs.

---

# Common Mistakes

### Inconsistent ID Format

Wrong

```
USR001

USR002

USR0003
```

Correct

```
USR0001

USR0002

USR0003
```

The generator compares string values,

so every ID must use the same number of digits.

---

### Forgetting read_only_fields

Clients should never send

```json
{
    "user_ID":"USR9999"
}
```

The ID should be generated by the backend.

---

### Generating IDs Inside Views

Wrong

```
APIView

↓

Generate ID
```

Correct

```
Serializer

↓

Generate ID
```

The serializer is responsible for object creation.

---

# Chapter Summary

After this chapter you understand

- Automatic ID generation
- `aggregate()`
- `Max()`
- Why `__max` exists
- Prefix extraction
- String formatting
- Why serializers generate IDs
- Why IDs should be read-only
- How reusable ID generation works across every module

# 📈 Current Progress

| Chapter | Status |
|----------|--------|
| Database | ✅ |
| ORM (Object Relational Mapper) | ✅ |
| Models | ✅ |
| Migrations | ✅ |
| Django Admin | ✅ |
| Serializer | ✅ |
| APIView | ✅ |
| URL Routing | ✅ |
| GET API (Read) | ✅ |
| POST API (Create) | ✅ |
| PUT API (Full Update) | ✅ |
| PATCH API (Partial Update) | ✅ |
| DELETE API | ✅ |
| Password Hashing | ✅ |
| Custom JWT Authentication | ✅ |
| API Testing with Postman | ✅ |
| Role-Based Access Control (RBAC) | ✅ |
| Custom Permissions | ✅ |
| Generic Views | ✅ |
| Auto ID Generation | ✅ |
| Business Logic Implementation | ⏳ |
| Exception Handling | ⏳ |
| Flutter Integration | ⏳ |
| Production Deployment | ⏳ |


# 📌 Learning Philosophy

Before writing code, always understand:

1. **Why is it needed?**
2. **What problem does it solve?**
3. **How does it work internally?**
4. **Then write the implementation.**
