# 🧾 GST Billing System

A professional **GST Billing System** built with **Flutter** for managing business profiles, customers/parties, products, GST invoices, bill history, and PDF invoices.

The application is designed around the billing workflow specified in the **Darshan University GST Billing System practical task**, with automatic GST calculation for intra-state and inter-state transactions.

---

## 📱 Overview

GST Billing System helps small and medium-sized businesses manage their daily billing workflow digitally.

The application provides:

* Business / Shop profile management
* Customer / Party management
* Product / Item management
* GST-compliant invoice creation
* Automatic CGST, SGST and IGST calculation
* Sequential invoice numbers
* Bill history
* Dashboard sales statistics
* Professional PDF invoice generation
* PDF preview, printing and sharing
* Email/password and Google authentication
* Light, Dark and System themes
* Responsive Flutter UI

---

## ✨ Features

### 🏪 Business Profile

Manage the shop/business information used on invoices.

* Shop name
* Business address
* Mobile number
* Email
* State
* GSTIN
* Invoice terms and conditions

Business information is automatically used while generating invoices.

---

### 👥 Party / Customer Management

Manage customers using a reusable party list.

**Available operations:**

* Add party
* Edit party
* Delete party
* Search parties
* View party details
* View party bill history
* Select an existing party while creating a bill
* Quickly create a new party during billing

**Party information:**

* Name
* Mobile number
* Address
* State
* GSTIN
* Email

---

### 📦 Product / Item Management

Maintain a reusable product catalog.

Each item can contain:

* Item name
* HSN/SAC code
* Unit price
* GST percentage

Supported standard GST slabs include:

```text
0%
5%
12%
18%
28%
```

The application also supports entering a **custom GST percentage**.

This allows products to be reused while creating multiple invoices.

---

### 🧾 GST Invoice Creation

Create invoices by selecting a party and adding one or more products.

For every bill item, the application calculates:

```text
Taxable Amount = Rate × Quantity
```

The GST calculation follows the state-based logic specified in the project requirements.

#### Same-State Transaction

When the business and customer are in the same state:

```text
GST
 ├── CGST = GST / 2
 └── SGST = GST / 2
```

Example:

```text
GST Rate = 18%

CGST = 9%
SGST = 9%
```

#### Inter-State Transaction

When the business and customer are in different states:

```text
IGST = Full GST Rate
CGST = 0
SGST = 0
```

Example:

```text
GST Rate = 18%

IGST = 18%
```

#### Invoice Totals

```text
Subtotal    = Sum of taxable amounts
Total Tax   = CGST + SGST + IGST
Grand Total = Subtotal + Total Tax
```

---

## 🔢 Invoice Numbering

The application automatically generates sequential invoice numbers.

The implemented format is:

```text
INV-YYYYMM-NNNN
```

Example:

```text
INV-202609-0001
INV-202609-0002
INV-202609-0003
```

Invoice numbers are generated automatically when creating bills.

---

## 🔒 Bill Immutability

Once a bill is generated and saved, it is treated as a finalized invoice.

Saved bills are not directly edited.

For corrections, a new bill/appropriate correction workflow can be used, following the requirement that generated bills should not be editable.

---

## 💳 Payment Status

Bills support payment status tracking:

```text
Paid
Unpaid
Partial
```

The payment status can be displayed in bill lists and bill details.

---

## 📊 Dashboard

The dashboard provides an overview of billing activity.

### Today's Statistics

* Total sales
* Number of bills
* GST collected
* CGST
* SGST
* IGST

### Monthly Statistics

* Total sales
* Number of bills
* GST collected
* CGST
* SGST
* IGST

### Quick Actions

The dashboard provides shortcuts for:

* Create New Bill
* Manage Parties
* Manage Items
* View Invoices

A recent invoice section is also available for quick access to recent bills.

---

## 📄 PDF Invoice

The application generates professional PDF invoices using Flutter PDF libraries.

Generated invoices contain information such as:

### Business Information

* Business/shop name
* Address
* State
* GSTIN
* Phone
* Email

### Invoice Information

* Invoice number
* Invoice date
* Place of supply
* Supply type

### Customer Information

* Party name
* Address
* State
* Mobile
* GSTIN

### Item Details

* Serial number
* Item description
* HSN/SAC
* Quantity
* Rate
* Taxable amount
* GST %
* CGST
* SGST
* IGST
* Line total

### Summary

* Subtotal
* Total tax
* Grand total
* Amount in words
* Terms & conditions

The project task specifically requires downloadable/printable PDF invoices and sharing support.

---

## 📤 PDF Sharing & Printing

Generated invoices can be:

* Previewed
* Printed
* Shared
* Saved/downloaded depending on the platform

The project uses the Flutter `printing` package for printing and sharing workflows.

---

# 🔐 Authentication

The project includes Firebase Authentication.

Supported authentication flows include:

### Email & Password

* Register
* Login
* Logout
* Authentication state handling

### Google Sign-In

Google authentication is also configured through Firebase.

Authentication-related implementation can be found in:

```text
lib/services/auth_service.dart
lib/controllers/auth_controller.dart
lib/screens/auth/
```

Firebase configuration is provided through:

```text
lib/firebase_options.dart
android/app/google-services.json
```

---

# 🎨 UI / UX

The application uses **Material 3** with a modern glass-style visual design.

### Theme Modes

Supported theme modes:

```text
Light
Dark
System
```

The dark theme uses a Midnight Slate style.

### Responsive Layout

The interface adapts to different screen sizes including:

* Mobile
* Tablet
* Desktop
* Web

Navigation changes according to available screen width.

---

# 🧱 Project Architecture

The project follows a modular Flutter structure separating:

* Screens
* Controllers
* Providers
* Models
* Services
* Routes
* Theme
* Reusable widgets
* Utilities

```text
gst_billing_system/
│
├── android/
├── ios/
├── macos/
├── web/
├── windows/
├── linux/
│
├── assets/
│   └── logo/
│       └── app_logo.png
│
├── docs/
│   └── Project_Report.md
│
├── lib/
│   ├── app.dart
│   ├── main.dart
│   ├── firebase_options.dart
│   │
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── bill_controller.dart
│   │   ├── business_profile_controller.dart
│   │   ├── item_controller.dart
│   │   └── party_controller.dart
│   │
│   ├── core/
│   │   ├── bindings/
│   │   ├── middleware/
│   │   ├── routes/
│   │   └── theme/
│   │
│   ├── models/
│   │   ├── bill.dart
│   │   ├── bill_item.dart
│   │   ├── business_profile.dart
│   │   ├── item.dart
│   │   └── party.dart
│   │
│   ├── providers/
│   │   ├── bill_provider.dart
│   │   ├── business_profile_provider.dart
│   │   ├── item_provider.dart
│   │   └── party_provider.dart
│   │
│   ├── screens/
│   │   ├── auth/
│   │   ├── bill/
│   │   ├── dashboard/
│   │   ├── item/
│   │   ├── party/
│   │   ├── settings/
│   │   ├── setup/
│   │   └── splash/
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── database_service.dart
│   │   ├── gst_calculator.dart
│   │   └── pdf_service.dart
│   │
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── number_to_words.dart
│   │   └── validators.dart
│   │
│   └── widgets/
│       ├── common/
│       ├── bill_item_tile.dart
│       ├── empty_state.dart
│       ├── gst_summary_card.dart
│       └── search_field.dart
│
├── test/
│
├── pubspec.yaml
└── README.md
```

---

# 🗃 Data Models

The application uses models representing the main billing entities.

### Business Profile

```text
BusinessProfile
```

Contains shop/business information.

### Party

```text
Party
```

Contains customer information.

### Item

```text
Item
```

Contains reusable product information.

### Bill

```text
Bill
```

Contains invoice-level information.

### BillItem

```text
BillItem
```

Contains the item snapshot and calculated tax values used in an invoice.

The project task defines the core entities as Party, Item, Bill and BillItem.

---

# 💾 Local Database

The application uses SQLite for local persistence.

Database implementation:

```text
lib/services/database_service.dart
```

SQLite is used to persist billing-related application data locally.

The project also uses:

```text
shared_preferences
```

for lightweight local preferences/settings.

---

# 🧮 GST Calculation Service

GST calculations are separated into a dedicated service:

```text
lib/services/gst_calculator.dart
```

The calculation flow is:

```text
Product Rate
     ↓
Quantity
     ↓
Taxable Amount
     ↓
GST Rate
     ↓
Compare Business State & Party State
     ↓
 ┌───────────────┬───────────────┐
 │ Same State    │ Different     │
 │               │ State         │
 ↓               ↓
CGST + SGST      IGST
     ↓               ↓
     └───────┬───────┘
             ↓
       Line Total
             ↓
       Grand Total
```

---

# 🧪 Testing

The repository contains tests covering different parts of the application.

Test files include:

```text
test/gst_calculator_test.dart
test/auth_validators_test.dart
test/item_form_custom_gst_test.dart
test/live_persistent_data_test.dart
test/shop_setup_screen_test.dart
test/business_profile_screen_test.dart
test/glass_dialog_test.dart
test/glass_fab_test.dart
test/home_shell_fab_test.dart
test/splash_screen_test.dart
test/widget_test.dart
```

Run all tests with:

```bash
flutter test
```

Run a specific test:

```bash
flutter test test/gst_calculator_test.dart
```

---

# 🛠 Technology Stack

| Technology         | Usage                                          |
| ------------------ | ---------------------------------------------- |
| Flutter            | Application framework                          |
| Dart               | Programming language                           |
| Material 3         | UI design system                               |
| Provider           | Application state/data providers               |
| GetX               | Routing, controllers and dependency management |
| SQLite / sqflite   | Local database                                 |
| Firebase Core      | Firebase integration                           |
| Firebase Auth      | Authentication                                 |
| Google Sign-In     | Google authentication                          |
| PDF                | PDF invoice generation                         |
| Printing           | PDF preview, printing and sharing              |
| Shared Preferences | Local preferences                              |
| Path Provider      | Application storage paths                      |
| UUID               | Unique identifiers                             |
| Intl               | Currency/date formatting                       |
| Google Fonts       | Typography                                     |
| Flutter Animate    | UI animation support                           |
| Shimmer            | Loading states                                 |
| Lottie             | Animation support                              |

---

# 📦 Main Dependencies

Important dependencies from `pubspec.yaml` include:

```yaml
provider: ^6.1.2
intl: ^0.19.0
pdf: ^3.11.2
printing: ^5.13.3
shared_preferences: ^2.3.2
sqflite: ^2.4.1
path_provider: ^2.1.5
path: ^1.9.0
uuid: ^4.5.1
firebase_core: ^4.15.0
firebase_auth: ^6.7.0
google_sign_in: ^7.2.0
get: ^4.7.3
google_fonts: ^6.2.1
flutter_animate: ^4.5.2
shimmer: ^3.0.0
lottie: ^3.6.1
```

---

# 🚀 Getting Started

## 1. Clone the Repository

```bash
git clone https://github.com/valaprashant97/gst_billing_system.git
```

Navigate to the project:

```bash
cd gst_billing_system
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Configure Firebase

The project contains Firebase configuration files.

Before running the application on a new Firebase project/environment, make sure the Firebase configuration matches your Firebase project.

Required configuration may include:

```text
android/app/google-services.json
lib/firebase_options.dart
```

Enable the required authentication providers in Firebase Console.

---

## 4. Run the Application

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

For a specific platform:

```bash
flutter run -d android
```

or:

```bash
flutter run -d chrome
```

---

# 📱 Build Android APK

For a release APK:

```bash
flutter build apk --release
```

The generated APK can be found under:

```text
build/app/outputs/flutter-apk/release/
```

---

# 🖥 Build for Web

```bash
flutter build web
```

---

# 🍎 Build for iOS

On macOS with Xcode configured:

```bash
flutter build ios
```

---

# 🧪 Project Requirements

According to the project task, the final application should support:

* Party/customer management
* Reusable item/product management
* GST invoice creation
* Automatic GST calculation
* CGST + SGST for same-state transactions
* IGST for inter-state transactions
* Sequential invoice numbers
* Invoice date
* Bill history
* Dashboard
* Search/filter functionality
* PDF invoice generation
* PDF sharing/printing
* Sample PDF invoices
* Project documentation

These requirements are based on the provided Darshan University task specification.

---

# 📄 Project Documentation

Additional project documentation is available at:

```text
docs/Project_Report.md
```

The report contains information about:

* Project overview
* Technology stack
* Core modules
* GST calculation
* PDF invoice generation
* Dashboard
* Testing
* Sample invoice deliverables

---

# 📂 Important Directories

| Directory          | Purpose                  |
| ------------------ | ------------------------ |
| `lib/screens/`     | Application screens      |
| `lib/models/`      | Data models              |
| `lib/services/`    | Business/data services   |
| `lib/providers/`   | State/data providers     |
| `lib/controllers/` | Controllers              |
| `lib/core/routes/` | Navigation routes        |
| `lib/core/theme/`  | Theme configuration      |
| `lib/widgets/`     | Reusable UI components   |
| `lib/utils/`       | Utilities and validation |
| `assets/logo/`     | Application logo         |
| `docs/`            | Project documentation    |
| `test/`            | Automated tests          |

---

# 🔄 Billing Workflow

```text
Login / Register
       ↓
Shop Setup
       ↓
Dashboard
       ↓
Add Party
       ↓
Add Product
       ↓
Create New Bill
       ↓
Select Party
       ↓
Add Items
       ↓
Enter Quantity
       ↓
Automatic GST Calculation
       ↓
Review Invoice
       ↓
Save Bill
       ↓
Generate PDF
       ↓
Preview / Print / Share
```

---

# 🧾 GST Example

### Same-State Example

```text
Business State : Gujarat
Customer State : Gujarat

Taxable Amount : ₹10,000
GST Rate       : 18%

CGST : ₹900
SGST : ₹900

Total Tax : ₹1,800
Grand Total: ₹11,800
```

### Inter-State Example

```text
Business State : Gujarat
Customer State : Maharashtra

Taxable Amount : ₹10,000
GST Rate       : 18%

IGST : ₹1,800
CGST : ₹0
SGST : ₹0

Total Tax : ₹1,800
Grand Total: ₹11,800
```

The underlying calculation rules follow the task specification.

---

# 🎯 Project Objective

The primary objective of this project is to replace manual or spreadsheet-based billing workflows with a structured digital billing application that can:

1. Manage customers.
2. Manage reusable products.
3. Create GST invoices.
4. Automatically calculate applicable GST.
5. Maintain billing history.
6. Generate professional PDF invoices.
7. Allow invoices to be printed or shared.

These objectives correspond to the requirements provided for the practical project.

---

# 📋 Submission Deliverables

The project task specifies the following submission items:

* Working application
* Source code
* At least 3 sample bills generated as PDF
* Short project report
* Screenshots/documentation
* GitHub repository or zipped project

The required deliverables are defined in the provided task document.

---

# 👨‍💻 Author

**Prashant Valapara**

GitHub:

```text
https://github.com/valaprashant97
```

Repository:

```text
https://github.com/valaprashant97/gst_billing_system
```

---

## ⭐ GST Billing System

**A simple and professional digital billing solution for GST-based invoicing.**

```text
Manage Parties → Manage Products → Create GST Bill
                         ↓
                  Auto GST Calculation
                         ↓
                  Generate PDF Invoice
                         ↓
                  Print / Share / Save
```
