# BloodLink — Flutter app

Mobile and desktop client for the BloodLink blood-bank management system. Staff manage donors, inventory, and requests; admins get reports and settings; superadmins oversee branches system-wide. Public users can request blood without logging in.

All data is **mocked locally** — there is no Django API connection yet. Login and forms use simulated validation only.

---

## Before you run

| Requirement | Notes |
|-------------|--------|
| **Flutter SDK** | Stable channel; Dart `^3.10.8` (see `pubspec.yaml`) |
| **Device / emulator** | Any platform in `.metadata` (Android, iOS, Web, Windows, Linux, macOS) |
| **Working directory** | Commands below assume you are in `frontend/` (not the repo root) |

First-time setup:

```bash
cd frontend
flutter pub get
flutter doctor    # optional — verify toolchain
```

---

## Run the app

```bash
flutter run
```

Pick a connected device when prompted, or target one explicitly:

```bash
flutter run -d chrome
flutter run -d windows
```

Other useful commands:

```bash
flutter analyze    # static analysis
flutter test       # widget + unit tests
```

---

## Access & credentials

There are two ways to use BloodLink: **staff app login** (email + password) and **public access** (no account — request ID + phone for tracking).

---

### App login (Staff, Admin, Superadmin)

The login screen pre-fills `staff@cuet.edu.bd` / `password`. Use any password with **at least 6 characters** for all demo accounts.

| Email | Password | Role | Name (mock) | Lands on |
|-------|----------|------|-------------|----------|
| `staff@cuet.edu.bd` | `password` | Staff | Fatima Rahman | `/staff` |
| `admin@cuet.edu.bd` | `password` | Admin | Karim Ahmed | `/admin` |
| `super@cuet.edu.bd` | `password` | Superadmin | System Admin | `/superadmin` |

**How to sign in**

1. Cold start → splash → (onboarding on first launch) → **Login**
2. Enter email + password → **Sign in**
3. Router sends you to the shell for your role

**Login rules (mock)**

| Input | Result |
|-------|--------|
| Unknown email | “Invalid email or password.” |
| Password fewer than 6 characters | “Invalid email or password.” |
| Suspended account | “Account suspended…” banner |
| Valid credentials | Role home (see table above) |

**Other login screen actions**

| Action | Where it goes |
|--------|----------------|
| Forgot password | Mock reset form (no email sent) |
| Toggle theme | Light / dark (app bar icon) |
| Need blood? Request Blood | `/public/request` — no login |
| Track an existing request | `/public/track` — no login |
| Contact blood bank | `tel:01700000001` |

**Forgot password** — mock only; submitting shows a success message, no email is sent.

---

### Public access (no login, no account)

Hospitals and requesters **do not get app accounts**. They use the public flows from the login screen or direct URLs.

| Method | Entry | What you need |
|--------|-------|----------------|
| **Submit a request** | Login → **Need blood? Request Blood** or `/public/request` | Organization name, phone(s), blood group, units, urgency |
| **Track a request** | Login → **Track an existing request** or `/public/track` | Request ID + phone used when submitting |
| **View status (direct link)** | `/public/track/:id` | Usually after submit or track gate (e.g. `/public/track/1042`) |
| **Pay (mock)** | From status screen when payment is due | `/public/payment/:paymentId` |

After submitting, you receive a **Request ID** like `BL-2042`. Save it with your phone number — that is how you track status.

**Demo track accounts (seed data)**

Use these on **Track an existing request** (ID + phone must match):

| Request ID | Phone | Requester | Status | Extra |
|------------|-------|-----------|--------|--------|
| `BL-1042` | `01710000001` | Square Hospital | Pending | Under review |
| `BL-1041` | `01710000002` | DMCH Emergency | Approved | **Pay Now** available |
| `BL-1038` | `01710000003` | United Hospital | Allocated | Timeline in progress |

Request ID accepts `BL-1042` or `1042`. Wrong ID or phone → “No request found — check ID and phone number.”

---

### Who does not log in

| User type | Access |
|-----------|--------|
| **Donors** | No app — registered by staff under Donors |
| **Public requesters** | Request + track only (ID + phone) |
| **Staff / Admin / Superadmin** | Email + password on login screen |

---

## First launch & sign out

**Cold start**

```
Splash → Onboarding (first launch only, 3 slides) → Login → role home
```

Onboarding is stored in local preferences. To see it again, clear app data or reinstall.

**Sign out**

- Staff / Admin: app bar **⋮** → Sign out, or **More** tab → Sign out.
- Superadmin: drawer → Sign out.

---

## Roles & navigation

### Staff

Bottom navigation (5 tabs):

| Tab | What you can do |
|-----|-----------------|
| **Dashboard** | Branch stats, quick actions, pending screenings list |
| **Donors** | Search, register, view/edit profile, donation history |
| **Inventory** | Branch stock list, filters, unit detail, status updates |
| **Requests** | Open queue, filters, approve/reject, allocate blood |
| **More** | Record donation, transports, theme toggle, sign out |

**Staff workflows that work today**

1. **Register a donor** — Donors tab → **Register** (or Dashboard → Register donor).
2. **Record a donation** — Dashboard → Record donation, or donor detail → Record donation (only if eligible).
3. **Screen donated blood** — After recording, complete the screening form (Pass/Fail + disease tests).
4. **Add to inventory** — On screening **Pass**, confirm unit details → unit appears under Inventory.
5. **Pull to refresh** on Dashboard or list screens to reload mock counts.
6. **Review blood requests** — Requests tab → tap request → Approve or Reject.
7. **Allocate blood** — On approved request → Allocate → pick local units; if short, pick another branch and create transport.
8. **Manage transports** — More → Transports → mark in transit / delivered (updates linked request status).

**Staff demo requests (seed data)**

| ID | Status | Good for testing |
|----|--------|------------------|
| BL-1042 | Pending | Approve → allocate (A+, 2 units) |
| BL-1041 | Approved | Allocate (O−, 4 units — needs Chattogram stock) |
| BL-1038 | Allocated | View allocation + linked transport |

Donation routes (full-screen, no bottom tab bar): select donor → record → screening → optional add inventory.

Request / transport routes (full-screen): request detail → allocate wizard; transports list → detail / create.

---

### Admin

Bottom navigation (4 tabs): Dashboard, Operations, Reports, Settings.

| Tab | What you can do |
|-----|-----------------|
| **Dashboard** | Branch stats, quick actions into Staff flows |
| **Operations** | Hub to Donors, donations, inventory, requests, transports (same Staff screens) |
| **Reports** | Placeholder — Phase 5.3 |
| **Settings** | Placeholder — Phase 5.2 |

Admins open Staff feature screens via **Operations** (or tappable stats / quick actions on Dashboard). Same widgets as Staff — no separate admin copies.

When you are on a Staff route (`/staff/donors`, `/staff/requests`, etc.):

- A banner at the top says **Admin — branch operations mode** with **Admin home**
- App bar **⋮** includes **Admin dashboard** to jump back to `/admin`

You do **not** get the Staff bottom nav when entering from Operations — use **back** or the banner / overflow link to return to the admin shell. Direct URLs to `/staff` or `/staff/more` redirect to `/admin`.

**Admin workflows that work today**

1. **Dashboard** — pending requests + stock counts; tap a card or quick-action chip to open the matching Staff flow.
2. **Operations → Donors** — same register / search / edit flows as Staff.
3. **Operations → Record donation** — select donor → record → screening → inventory (full supply chain).
4. **Operations → Requests** — approve BL-1042 (pending), allocate BL-1041 (approved, O− × 4 — try inter-branch from Chattogram).
5. **Operations → Transports** — list, create, mark in transit / delivered.

**Demo:** `admin@cuet.edu.bd` / `password` → **Operations** → pick any branch operation above.

Reports and Settings tabs are placeholders (Phase 5.2–5.3).

---

### Superadmin

**Drawer** (hamburger): Dashboard, **Operations**, Branches, Users, Inventory, Requests, Reports, Transports.

| Item | What you can do |
|------|-----------------|
| **Dashboard** | System-wide KPIs (branches, open requests, total stock, active transports); critical-request banner |
| **Operations** | Hub → system drawer screens + push to Staff requests/transports |
| **Other drawer items** | Placeholders for Phase 6.2–6.3 (branches, users, cross-branch inventory, etc.) |

App bar title: **BloodLink System**.

Superadmin opens Staff **fulfillment** screens via push (same UI as Staff/Admin). Staff bottom-nav tabs redirect to `/superadmin`. When on a shared Staff flow, use the **Superadmin — shared Staff flow** banner or **⋮ → System dashboard** to return.

**Demo:** `super@cuet.edu.bd` / `password` → tap **Open requests** on dashboard or Drawer → **Operations** → All requests.

Donor registration remains staff-managed at branch level — no superadmin donor workflow.

---

### Public (no login)

| Screen | Route |
|--------|-------|
| Request blood | `/public/request` — 2-step wizard |
| Request submitted | `/public/request/success` |
| Track request | `/public/track` — enter ID + phone |
| Request status | `/public/track/:id` — timeline |
| Payment (mock) | `/public/payment/:paymentId` |

From login: **Need blood? Request Blood** or **Track an existing request**. See [Public access](#public-access-no-login-no-account) above for demo ID + phone pairs.

**Quick reference — demo track**

| Request ID | Phone |
|------------|-------|
| BL-1042 | 01710000001 |
| BL-1041 | 01710000002 |
| BL-1038 | 01710000003 |

---

### Donors (people, not a role)

**Donors do not log into this app.** Staff register and manage them under **Donors**.

---

## UI & theme

- **Theme:** Crimson Clinical — light and dark.
- **Toggle theme:** Login app bar, shell **⋮** menu (Staff, Admin, Superadmin), or Staff **More** tab.
- **Debug builds only:** **⋮** → Theme lab at `/dev/theme`.

---

## Project layout

```
lib/
├── app.dart           # Bootstrap, providers, router
├── core/              # theme, router, shells, shared widgets
├── data/              # models, repository interfaces, mocks
├── features/          # auth, staff, admin, superadmin, public
└── theme_preview/     # debug theme lab
```

Specs: `.cursor/frontend/` · Internal build notes: `.cursor/implementation_progress/frontend/`

---

## Troubleshooting

| Issue | Try |
|-------|-----|
| Stuck on splash spinner | Wait ~1s; mock init is async. Hot restart if needed. |
| Onboarding skipped | Normal on second launch — flag is persisted. |
| Dashboard stats empty briefly | Stats load async; pull to refresh. |
| Admin stuck on Staff screen | Tap **Admin home** in the banner, or **⋮** → Admin dashboard. |
| Wrong role after login | Sign out; use the email for the role you want (see [credentials](#app-login-staff-admin-superadmin)). |
| `flutter pub get` fails | Check Flutter/Dart version matches `pubspec.yaml`. |
| Android build: Kotlin path errors (D: vs C: drive) | In `android/gradle.properties`: `kotlin.incremental=false` and `kotlin.compiler.execution.strategy=in-process`, then `flutter clean` and rebuild. |

Flutter docs: [docs.flutter.dev](https://docs.flutter.dev/)
