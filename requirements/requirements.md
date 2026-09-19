# GST Billing System — Requirements

## 1. Project Overview

### Project Name
GST Billing System

### Project Type
Mobile / Web Application

### Objective

Design and develop a GST Billing System that allows a shopkeeper to:

- Manage customers/parties
- Manage reusable items/products
- Create GST-compliant invoices
- Automatically calculate GST
- Generate invoice numbers
- Save bill history
- Generate downloadable/printable PDF invoices
- Share generated invoices

The application should reflect real-world billing workflows used by small and medium retail businesses.

---

# 2. Problem Statement

Manual billing or spreadsheet-based billing is time-consuming and error-prone, especially when calculating GST across multiple items.

The application must allow a shopkeeper to:

1. Maintain a customer/party list.
2. Maintain a reusable product/item list.
3. Create itemized GST bills.
4. Automatically calculate GST.
5. Automatically calculate invoice totals.
6. Save generated bills.
7. View bill history.
8. Search/filter bills.
9. Generate PDF invoices.
10. Share or download PDF invoices.

---

# 3. Core Functional Requirements

## 3.1 Party / Customer Management

The system must provide a Party Management module.

### Add Party

The user must be able to add a new party/customer with:

- Name — Required
- Mobile Number — Required
- Address — Required
- State — Required
- GSTIN — Optional
- Email — Optional

### Party Operations

The system must support:

- Add party
- Edit party
- Delete party
- View party details
- Search parties
- View a party's bill history

### Party List

The party list must:

- Display all saved parties
- Support searching
- Allow opening a party's details
- Allow viewing bills associated with that party

---

# 4. Item / Product Management

The system must provide reusable item/product management.

## 4.1 Add Item

Each item must contain:

- Item Name — Required
- HSN/SAC Code — Optional
- Unit Price — Required
- GST % — Required

## 4.2 Item Operations

The system must support:

- Add item
- Edit item
- Delete item
- View item list
- Search items

## 4.3 Reusable Items

Saved items must be reusable while creating bills.

The user should not need to manually re-enter the same product information for every invoice.

---

# 5. GST Bill Creation

The system must provide an invoice/bill creation workflow.

## 5.1 Select Party

When creating a bill, the user must be able to:

- Select an existing party
- Quickly add a new party

## 5.2 Add Items

A bill must support:

- One or more items
- Item selection
- Quantity
- Item rate
- GST percentage

## 5.3 Per-Item Calculation

For each bill item:

```text
Taxable Amount = Rate × Quantity