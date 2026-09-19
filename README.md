# 🧾 GST Billing System

[![Flutter Version](https://img.shields.io/badge/Flutter-3.12%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-M3%20Glassmorphism-7B1FA2)](https://m3.material.io/)
[![Platform Support](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-4CAF50)]()
[![Tests](https://img.shields.io/badge/Tests-42%20Passing-success)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

> **Fast, Reliable & GST-Compliant Invoicing for Small & Medium Enterprises.**

A modern, full-featured cross-platform GST billing and invoicing application built with **Flutter**, **Provider**, **SQLite**, and **Firebase Authentication**. Designed with a premium **Material 3 Glassmorphism** aesthetic, responsive layouts for mobile, tablet, and desktop, and full support for **Light**, **Dark (Midnight Slate)**, and **System** themes.

---

## 📑 Table of Contents

- [Key Features](#-key-features)
- [Design & User Experience](#-design--user-experience)
- [Project Architecture & Directory Structure](#-project-architecture--directory-structure)
- [Project Constants & Configurations](#-project-constants--configurations)
- [GST Calculation Engine](#-gst-calculation-engine)
- [Database Schema (SQLite)](#-database-schema-sqlite)
- [Routes & Navigation](#-routes--navigation)
- [Getting Started & Installation](#-getting-started--installation)
- [Testing & Quality Assurance](#-testing--quality-assurance)
- [Dependencies](#-dependencies)
- [Contributing & License](#-contributing--license)

---

## ✨ Key Features

### 🏢 1. Business Profile & Shop Setup
- **Onboarding Setup Wizard**: Dedicated step-by-step setup screen for first-time business onboarding.
- **Dedicated Business Profile Screen**: Manage Shop Name, Contact Number, Business Email, State, GSTIN, and custom Invoice Terms & Conditions.
- **Quick App Bar Navigation**: Tap anywhere on the Dashboard/Home App Bar to instantly access and update your Business Profile / Shop Setup.
- **Invoice Header Integration**: Saved business details automatically populate the header and legal footer of every generated GST invoice.

### 👥 2. Customer / Party Management
- Complete CRUD operations for customers/parties.
- Tracks Name, Mobile Number, Address, State, GSTIN, and Email.
- Real-time search by customer name, phone number, or GSTIN.
- Customer detail view with complete billing history and outstanding balances.
- Reusable customer picker modal during invoice creation.

### 📦 3. Products & Items Catalog
- Reusable product catalog preventing manual data re-entry.
- Item Name, HSN/SAC Code, Unit Price, Standard GST Slabs (0%, 5%, 12%, 18%, 28%), and **Custom GST Rate** input support (e.g. 0.25%, 3%, 7.5%).
- Fast search and filtering by item name or HSN code.
- Quick product selection dialog when composing invoices.

### 🧾 4. GST-Compliant Invoice Creation
- Create comprehensive GST invoices in under 60 seconds.
- Multi-item line support with quantity, unit rate, and dynamic GST slab.
- Automatic tax determination:
  - **Intra-State (Same State)**: Splits tax evenly into **CGST** (50%) + **SGST** (50%).
  - **Inter-State (Different State)**: Applies full tax to **IGST** (100%).
- Real-time calculations for Taxable Amount, Total CGST, Total SGST, Total IGST, and Grand Total.
- Payment Status tracking: `Paid`, `Unpaid`, and `Partial`.

### 📊 5. Executive Dashboard & Analytics
- Today's Sales & bill count.
- Monthly revenue & bill volume.
- Daily & monthly CGST, SGST, and IGST tax collection breakdown.
- Quick Action shortcuts to Parties, Products, and Invoices.
- Recent Invoices list with one-tap detail view.

### 📄 6. PDF Generation & Printing
- Generates professional, GST-compliant PDF invoices.
- In-app PDF preview, direct printer output, and system share sheet.
- Formatted with shop header, GSTIN tags, itemized tax tables, and custom terms.

---

## 🎨 Design & User Experience

| Feature | Description |
|---|---|
| **Material 3 + Glassmorphism** | Translucent frosted-glass app bars and Floating Action Buttons (`BackdropFilter` blur sigma 14). |
| **Theme-Aware** | Seamless switching between **Light**, **Dark (Midnight Slate `#0B0E14`)**, and **System** themes. |
| **Responsive Layout** | Mobile bottom navigation bar + adaptive wide-screen `NavigationRail` for tablets, web, and desktop. |
| **Floating Action Buttons (FABs)** | Screen-aware extended FABs: Dashboard (→ *New Bill*), Parties (→ *Add Party*), Products (→ *Add Product*), Invoices (→ *Create Invoice*). |
| **Static Brand Splash Screen** | Minimal, clean splash screen featuring the official app logo and "GST Billing System" branding with zero animations. |

---

## 🏗 Project Architecture & Directory Structure

The project follows a clean, modular architecture separating UI, business logic, providers, and data access services:

```text
gst_billing_system/
├── android/                        # Native Android configuration
├── assets/
│   ├── animation/                  # Animation assets
│   └── logo/
│       └── app_logo.png            # Official App Logo
├── lib/
│   ├── app.dart                    # App root widget with GetMaterialApp
│   ├── main.dart                   # Application entrypoint & initialization
│   ├── core/
│   │   ├── middleware/             # Route guards & auth middleware
│   │   ├── routes/                 # AppRoutes & AppPages (GetX navigation)
│   │   └── theme/                  # AppTheme, AppColors, AppMidnightColors, AppShadows
│   ├── models/
│   │   ├── bill.dart               # Bill & BillItem domain models
│   │   ├── business_profile.dart   # Business profile model
│   │   ├── item.dart               # Item/Product domain model
│   │   └── party.dart              # Customer/Party domain model
│   ├── providers/
│   │   ├── bill_provider.dart      # Provider for invoice state & dashboard stats
│   │   ├── business_profile_provider.dart # Business profile state
│   │   ├── item_provider.dart      # Product catalog state
│   │   └── party_provider.dart     # Customer state
│   ├── screens/
│   │   ├── auth/                   # LoginScreen & RegisterScreen (Firebase Auth)
│   │   ├── bill/                   # BillListScreen, CreateBillScreen, BillDetailScreen
│   │   ├── dashboard/              # DashboardScreen
│   │   ├── home_shell.dart         # Responsive navigation shell (Rail/BottomBar + FABs)
│   │   ├── item/                   # ItemListScreen & ItemFormScreen
│   │   ├── party/                  # PartyListScreen, PartyFormScreen, PartyDetailScreen
│   │   ├── settings/               # BusinessProfileScreen (Dedicated profile & theme settings)
│   │   ├── setup/                  # ShopSetupScreen (Initial onboarding setup)
│   │   └── splash/                 # SplashScreen (Static official logo + branding)
│   ├── services/
│   │   ├── auth_service.dart       # Firebase Authentication service
│   │   ├── database_service.dart   # SQLite database manager (CRUD operations)
│   │   └── pdf_service.dart        # PDF generation, preview & print service
│   ├── utils/
│   │   ├── constants.dart          # Project constants (GST slabs, states, currencies, dates)
│   │   ├── gst_calculator.dart     # Pure GST tax calculation utility
│   │   └── validators.dart         # Form validation rules (GSTIN, phone, email)
│   └── widgets/
│       ├── common/                 # GlassAppBar, GlassFloatingActionButton, GlassAlertDialog, SectionHeader
│       └── ...                     # Reusable UI widgets (SearchField, StatusBadge, EmptyState)
├── requirements/                   # Requirements specification & Design guidelines
├── test/                           # Comprehensive test suite (42 unit & widget tests)
└── pubspec.yaml                    # Package manifest & dependencies
```

---

## ⚙️ Project Constants & Configurations

All core application constants are centralized in [`lib/utils/constants.dart`](file:///d:/Flutter%20Projects/gst_billing_system/lib/utils/constants.dart):

### 1. General App Constants (`AppConstants`)
```dart
static const String appName = 'GST Billing';
static const String appTagline = 'Fast, Reliable & GST-Compliant Invoicing';
static const String appLogo = 'assets/logo/app_logo.png';
```

### 2. Standard Indian GST Slabs
Standard GST rates applicable under Indian GST laws:
```dart
static const List<double> gstSlabs = [0.0, 5.0, 12.0, 18.0, 28.0];
```

### 3. States & Union Territories
Complete list of all 28 Indian States and 8 Union Territories for place-of-supply tax determination:
- **States**: Andhra Pradesh, Arunachal Pradesh, Assam, Bihar, Chhattisgarh, Goa, Gujarat, Haryana, Himachal Pradesh, Jharkhand, Karnataka, Kerala, Madhya Pradesh, Maharashtra, Manipur, Meghalaya, Mizoram, Nagaland, Odisha, Punjab, Rajasthan, Sikkim, Tamil Nadu, Telangana, Tripura, Uttar Pradesh, Uttarakhand, West Bengal.
- **Union Territories**: Andaman and Nicobar Islands, Chandigarh, Dadra and Nagar Haveli and Daman and Diu, Delhi, Jammu and Kashmir, Ladakh, Lakshadweep, Puducherry.

### 4. Currency & Date Formats
- **Currency**: Indian Rupee (`en_IN`, symbol: `₹`, format: `#,##,##0.00`).
- **Date Formats**:
  - `invoiceDateFormat`: `dd MMM yyyy` (e.g., `19 Sep 2026`)
  - `invoiceDateTimeFormat`: `dd MMM yyyy, hh:mm a` (e.g., `19 Sep 2026, 11:30 AM`)
  - `monthYearFormat`: `MMMM yyyy` (e.g., `September 2026`)

### 5. Color Palette & Tax Semantics
- **Brand Colors**: Primary Indigo (`#3F51B5`), Secondary Teal (`#00897B`).
- **Midnight Slate Dark Theme**: Scaffold Background (`#0B0E14`), Surface (`#141923`), Border (`#232B3E`), Card Container (`#1E2638`).
- **Tax Tagging Colors**:
  - **CGST**: `#1565C0` (Blue)
  - **SGST**: `#00838F` (Cyan)
  - **IGST**: `#6A1B9A` (Purple)
  - **Paid**: `#2E7D32` (Green)
  - **Unpaid**: `#D32F2F` (Red)
  - **Partial**: `#FF8F00` (Amber)

---

## 🧮 GST Calculation Engine

Tax calculations are implemented in [`lib/utils/gst_calculator.dart`](file:///d:/Flutter%20Projects/gst_billing_system/lib/utils/gst_calculator.dart) adhering to Indian GST compliance rules:

$$\text{Taxable Amount} = \text{Rate} \times \text{Quantity}$$

$$\text{Total Tax} = \text{Taxable Amount} \times \left(\frac{\text{GST \%}}{100}\right)$$

### Tax Classification Rules:
- **Intra-State Transaction** ($\text{Seller State} = \text{Buyer State}$):
  $$\text{CGST} = \frac{\text{Total Tax}}{2}, \quad \text{SGST} = \frac{\text{Total Tax}}{2}, \quad \text{IGST} = 0$$
- **Inter-State Transaction** ($\text{Seller State} \neq \text{Buyer State}$):
  $$\text{IGST} = \text{Total Tax}, \quad \text{CGST} = 0, \quad \text{SGST} = 0$$

$$\text{Grand Total} = \text{Total Taxable Amount} + \text{Total Tax}$$

---

## 🗄 Database Schema (SQLite)

Local offline persistence is managed by [`lib/services/database_service.dart`](file:///d:/Flutter%20Projects/gst_billing_system/lib/services/database_service.dart) via `sqflite`:

```sql
-- Business / Shop Profile
CREATE TABLE business_profile (
  id TEXT PRIMARY KEY,
  shop_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  state TEXT NOT NULL,
  gstin TEXT,
  address TEXT NOT NULL,
  terms_conditions TEXT
);

-- Customers / Parties
CREATE TABLE parties (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  mobile TEXT NOT NULL,
  address TEXT NOT NULL,
  state TEXT NOT NULL,
  gstin TEXT,
  email TEXT,
  created_at INTEGER NOT NULL
);

-- Products / Items Catalog
CREATE TABLE items (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  hsn_code TEXT,
  unit_price REAL NOT NULL,
  gst_percent REAL NOT NULL,
  created_at INTEGER NOT NULL
);

-- GST Invoices / Bills
CREATE TABLE bills (
  id TEXT PRIMARY KEY,
  invoice_no TEXT NOT NULL UNIQUE,
  party_id TEXT NOT NULL,
  party_name TEXT NOT NULL,
  party_state TEXT NOT NULL,
  party_gstin TEXT,
  date INTEGER NOT NULL,
  subtotal REAL NOT NULL,
  total_cgst REAL NOT NULL,
  total_sgst REAL NOT NULL,
  total_igst REAL NOT NULL,
  grand_total REAL NOT NULL,
  payment_status TEXT NOT NULL,
  notes TEXT,
  is_inter_state INTEGER NOT NULL
);

-- Invoice Line Items
CREATE TABLE bill_items (
  id TEXT PRIMARY KEY,
  bill_id TEXT NOT NULL,
  item_id TEXT,
  name TEXT NOT NULL,
  hsn_code TEXT,
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL,
  gst_percent REAL NOT NULL,
  taxable_amount REAL NOT NULL,
  cgst REAL NOT NULL,
  sgst REAL NOT NULL,
  igst REAL NOT NULL,
  total REAL NOT NULL,
  FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE
);
```

---

## 🗺 Routes & Navigation

Navigation is defined in [`lib/core/routes/app_routes.dart`](file:///d:/Flutter%20Projects/gst_billing_system/lib/core/routes/app_routes.dart) and managed with GetX:

| Route Name | Path | Description | Middleware |
|---|---|---|---|
| `AppRoutes.splash` | `/` | Static official logo splash screen | None |
| `AppRoutes.login` | `/login` | Firebase Email/Password & Google login | None |
| `AppRoutes.register` | `/register` | Account registration | None |
| `AppRoutes.shopSetup` | `/shop-setup` | First-time business setup wizard | `AuthMiddleware` |
| `AppRoutes.home` | `/home` | Main Home Shell (Dashboard, Parties, Products, Invoices, Profile) | `AuthMiddleware` |
| `AppRoutes.parties` | `/parties` | Parties listing | `AuthMiddleware` |
| `AppRoutes.partyForm` | `/party-form` | Add/Edit party form | `AuthMiddleware` |
| `AppRoutes.items` | `/items` | Products listing | `AuthMiddleware` |
| `AppRoutes.itemForm` | `/item-form` | Add/Edit product form | `AuthMiddleware` |
| `AppRoutes.bills` | `/bills` | Invoice history list | `AuthMiddleware` |
| `AppRoutes.createBill` | `/create-bill` | Invoice creation workflow | `AuthMiddleware` |
| `AppRoutes.settings` | `/settings` | Dedicated Business Profile screen | `AuthMiddleware` |

---

## 🚀 Getting Started & Installation

### Prerequisites
- **Flutter SDK**: `>= 3.12.2`
- **Dart SDK**: `>= 3.12.2`
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Project** (Optional for local testing; required for live auth)

### Setup Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/gst_billing_system.git
   cd gst_billing_system
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (if deploying with live backend):
   - Place `google-services.json` in `android/app/`.
   - Place `GoogleService-Info.plist` in `ios/Runner/`.

4. **Run the Application**:
   ```bash
   # Run on connected device or emulator
   flutter run

   # Run on Chrome / Web
   flutter run -d chrome

   # Run on Windows desktop
   flutter run -d windows
   ```

---

## 🧪 Testing & Quality Assurance

The codebase is backed by a 100% passing test suite covering unit tests, validator rules, widget interactions, and responsive layouts:

```bash
# Run static analysis
flutter analyze

# Run all test suites
flutter test
```

### Test Coverage Highlights:
- **`auth_validators_test.dart`**: Email, password, and form validation tests.
- **`gst_calculator_test.dart`**: Intra-state vs. inter-state tax split validation.
- **`splash_screen_test.dart`**: Verifies static logo, title, and absence of animations.
- **`business_profile_screen_test.dart`**: Header card, required/optional fields, and dark theme tests.
- **`home_shell_fab_test.dart`**: Verifies dynamic Glassmorphic FABs on Dashboard, Parties, Products, and Invoices across mobile, tablet, and dark mode.
- **`glass_fab_test.dart`**: Tests glassmorphic styling, blur filters, and tap handlers.
- **`glass_dialog_test.dart`**: Tests frosted dialog styling and actions.
- **`shop_setup_screen_test.dart`**: Tests onboarding fields and validation.
- **`widget_test.dart`**: Narrow screen responsiveness and theme tests.

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `provider` | `^6.1.2` | State management |
| `get` | `^4.7.3` | Routing & theme controller |
| `sqflite` | `^2.4.1` | Local SQLite database |
| `firebase_auth` | `^6.7.0` | Authentication |
| `firebase_core` | `^4.15.0` | Firebase initialization |
| `google_sign_in` | `^7.2.0` | Google Single Sign-On |
| `pdf` | `^3.11.2` | PDF document layout & drawing |
| `printing` | `^5.13.3` | Direct printing & sharing |
| `flutter_animate` | `^4.5.2` | Fluid transitions & motion |
| `google_fonts` | `^6.2.1` | Typography |
| `intl` | `^0.19.0` | Currency & date formatting |
| `shared_preferences` | `^2.3.2` | Key-value settings storage |

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.
