# BloodLink RBAC Permission Matrix (Final)

| Action | SuperAdmin | Admin | Staff |
|--------|:----------:|:-----:|:-----:|
| **Authentication** ||||
| Login | ✅ | ✅ | ✅ |
| View Own Profile | ✅ | ✅ | ✅ |
| Update Own Profile | ✅ | ✅ | ✅ |
| **Branch Management** ||||
| Create Branch | ✅ | ❌ | ❌ |
| Update Branch | ✅ | ❌ | ❌ |
| Delete Branch | ✅ | ❌ | ❌ |
| **Admin Management** ||||
| Create Admin | ✅ | ❌ | ❌ |
| Update Admin | ✅ | ❌ | ❌ |
| Delete Admin | ✅ | ❌ | ❌ |
| **Staff Management** ||||
| Create Staff | ✅ | ✅ *(Own Branch)* | ❌ |
| Update Staff | ✅ | ✅ *(Own Branch)* | ❌ |
| Delete Staff | ✅ | ✅ *(Own Branch)* | ❌ |
| **Donor Management** ||||
| Register Donor | ✅ | ✅ | ✅ |
| View Donor | ✅ | ✅ | ✅ |
| Update Donor | ✅ | ✅ | ✅ |
| **Donation Management** ||||
| Record Donation | ✅ | ✅ | ✅ |
| Update Donation | ✅ | ✅ | ✅ |
| **Screening Management** ||||
| Record Screening | ✅ | ✅ | ✅ |
| Update Screening | ✅ | ✅ | ✅ |
| **Blood Inventory** ||||
| Add Blood Unit | ✅ | ✅ | ✅ |
| Update Blood Inventory | ✅ | ✅ | ✅ |
| Remove / Discard Blood Unit | ✅ | ✅ | ✅ |
| **Blood Requests** ||||
| Submit Blood Request *(Patient/Hospital – No Login Required)* | Public | Public | Public |
| View Blood Requests | ✅ | ✅ | ✅ |
| Review / Verify Request | ✅ | ✅ | ✅ |
| Approve / Reject Blood Request | ✅ | ✅ | ✅ |
| **Transport** ||||
| View Transport | ✅ | ✅ | ✅ |
| Create Transport | ✅ | ✅ | ✅ |
| Update Transport Status | ✅ | ✅ | ✅ |
| **Payments** ||||
| View Payments | ✅ | ✅ | ✅ |
| Record Payment | ✅ | ✅ | ✅ |
| Update Payment | ✅ | ✅ | ✅ |
| **Reports** ||||
| Generate Weekly Report | ✅ | ✅ *(Own Branch)* | ❌ |
| View Weekly Reports | ✅ | ✅ *(Own Branch)* | ❌ |
| View Nationwide Reports | ✅ | ❌ | ❌ |
| **System** ||||
| Change User Roles | ✅ | ❌ | ❌ |

---

# Role Summary

## SuperAdmin

- One SuperAdmin for the entire system.
- Manages all branches.
- Creates and manages Admins.
- Can manage Staff in any branch.
- Has full access to every module.
- Can generate and view reports for every branch.

## Admin

- One Admin per branch.
- Manages only their own branch.
- Recruits and manages Staff.
- Oversees branch operations.
- Generates and views weekly reports for their own branch.

## Staff

- Handles day-to-day operational tasks.
- Registers donors.
- Records donations and screenings.
- Updates blood inventory.
- Reviews and approves/rejects blood requests.
- Creates transport records and updates transport status.
- Records and updates payments.
- Cannot manage branches, Admins, user roles, or reports.

## Public Requesters

- Patients and hospitals do **not** need to log in.
- They can submit blood requests directly.
- Their requests are processed by BloodLink staff.
