# DARSHAN UNIVERSITY
## Department of Computer Engineering
### Practical Project Task: GST Billing System

---

## 1. Project Overview & Objective

The **GST Billing System** is a mobile (Android, iOS) and web-enabled Flutter application designed for small and medium retail shopkeepers. It simplifies billing workflows, maintains customer parties, manages reusable inventory items, automatically calculates applicable Goods and Services Tax (GST), ensures sequential invoice numbering, prevents illegal tampering with saved bills, and produces professional, GST-compliant PDF invoices that can be shared or printed.

The application also integrates **Firebase Authentication** (with Email/Password and Google Sign-In support), adopting the architecture patterns from the reference authentication module.

---

## 2. Technology Stack

| Layer | Component | Notes |
|---|---|---|
| **Framework** | Flutter (Dart 3.12, Flutter 3.44) | Multiplatform (Android, iOS, Web) |
| **Design System** | Material 3 (Indigo `#3F51B5` & Teal `#00897B`) | Based on `design.md` specifications |
| **Authentication** | Firebase Authentication (`firebase_auth`, `google_sign_in`) | Email/Password & Google Sign-In |
| **State Management** | Provider (`provider: ^6.1.2`) | Service & ChangeNotifier architecture |
| **Persistence** | SQLite (`sqflite`) + `shared_preferences` | Dual storage engine for Mobile & Web |
| **PDF Generation** | `pdf: ^3.11.2`, `printing: ^5.13.3` | Professional vector PDF layout & printing |
| **Formatting** | `intl: ^0.19.0` | Indian currency (₹) & dates |
| **ID Generation** | `uuid: ^4.5.1` | RFC-4122 unique identifiers |

---

## 3. Core Modules & Implementation Details

### 3.1 Party (Customer) Management Module
- **Add & Edit Party**: Name, Mobile (10-digit validation), Address, State (Dropdown with 36 Indian States & UTs), GSTIN (15-character regex validation), Email.
- **Searchable List**: Live real-time search across party name, mobile, state, and GSTIN.
- **Party Details & History**: View party contact information and see every bill generated for this specific party.
- **Quick-Create / Selection Mode**: Parties can be created directly from the bill creation workflow with instant selection.

### 3.2 Item / Product Management Module
- **Add & Edit Item**: Product Name, HSN/SAC code (optional 2 to 8 digit classification), Unit Price (₹), GST Percentage slab.
- **GST Rate Slabs**: Quick-tap choice chips for standard Indian slabs (`0%`, `5%`, `12%`, `18%`, `28%`).
- **Inventory Reusability**: Items are stored in master inventory and quickly added to invoices with customizable quantity and rate overrides.

### 3.3 GST Bill Creation & Auto-Calculation Engine
- **Sequential Invoice Numbering**: Automated `INV-YYYYMM-NNNN` sequential counter based on the current calendar month and database sequence.
- **Intra-State Supply (CGST + SGST)**:
  - If `Party State == Business State`:
  $$\text{Taxable Amount} = \text{Rate} \times \text{Quantity}$$
  $$\text{CGST} = \left(\frac{\text{GST}\%}{2}\right) \times \text{Taxable Amount}$$
  $$\text{SGST} = \left(\frac{\text{GST}\%}{2}\right) \times \text{Taxable Amount}$$
  $$\text{IGST} = 0$$
- **Inter-State Supply (IGST)**:
  - If `Party State \neq Business State`:
  $$\text{IGST} = \text{GST}\% \times \text{Taxable Amount}$$
  $$\text{CGST} = 0, \quad \text{SGST} = 0$$
- **Line Total & Grand Total**:
  $$\text{Line Total} = \text{Taxable Amount} + \text{Tax Applied}$$
  $$\text{Grand Total} = \sum \text{Line Totals}$$
- **Immutability Guarantee**: Invoices are read-only once created, conforming to GST legal standards.

### 3.4 PDF Invoice Generation & Sharing
- Generates A4 PDF tax invoices with:
  - Header: Business name, address, state, GSTIN, phone, email
  - Metadata: Invoice No, Invoice Date, Place of Supply, Supply Type badge
  - Bill-To Customer details: Name, Address, State, Mobile, GSTIN
  - Itemized Table: S.No, Description, HSN, Qty, Rate, Taxable, GST%, CGST/SGST/IGST, Line Total
  - Amount in Words: Converted to Indian numbering English words (e.g. *"Thirty Thousand Five Hundred Fifty-Eight Rupees and Forty-Six Paise Only"*)
  - Terms & Conditions and Authorized Signatory
- Native Print dialog and Share sheet (WhatsApp, Email, Drive).

### 3.5 Dashboard & Sales Analytics
- Real-time sales and tax metrics:
  - Today's Total Sales & Bill Count
  - This Month's Total Sales & Bill Count
  - Total Tax Collected Today (CGST/SGST/IGST)
  - Total Tax Collected This Month
- Quick action shortcuts to Parties, Items, and Invoices.
- Recent 5 bills with status chips and tap-to-view navigation.

---

## 4. Verification & Testing

The application includes automated unit test suites covering the core financial calculations and validation logic:

```bash
flutter test test/gst_calculator_test.dart test/auth_validators_test.dart
```

### Test Results Summary:
1. **Intra-State GST**: Passed — Verified equal split into CGST (9%) and SGST (9%) for Gujarat-to-Gujarat supply.
2. **Inter-State GST**: Passed — Verified full IGST (18%) application and 0 CGST/SGST for Gujarat-to-Maharashtra supply.
3. **Multiple Items & Rounding**: Passed — Verified subtotal ₹25,897.00 + tax ₹4,661.46 = grand total ₹30,558.46.
4. **Number to Words Conversion**: Passed — Verified rupee and paise breakdown in Indian format.
5. **Validators**: Passed — Mobile (10 digits), GSTIN (15-char alphanumeric), positive prices.
6. **AuthService Validators**: Passed — Email regex, password length (>=6 chars), confirm password matching.

---

## 5. Sample Invoices Deliverables

Generated sample bills included in `sample_invoices/`:
1. `Sample_Invoice_01_IntraState.pdf` (Intra-state supply with CGST + SGST breakdown)
2. `Sample_Invoice_02_InterState_IGST.pdf` (Inter-state supply with IGST single tax)
3. `Sample_Invoice_03_MultiSlab.pdf` (Multiple product categories with 5%, 12%, and 18% GST slabs)
