# GST Billing System — Design System

> A professional, clean, and modern design system for a GST Billing application targeting **Android**, **iOS**, and **Web**.

---

## 1. Design Philosophy

| Principle | Description |
|---|---|
| **Clarity First** | Billing apps handle numbers and money — every element must be instantly readable. |
| **Professional Trust** | A clean, structured look that gives shopkeepers confidence in accuracy. |
| **Speed of Use** | Shopkeepers create bills under time pressure — minimize taps, maximize flow. |
| **Responsive** | One codebase that feels native on phones and spacious on web/tablets. |

---

## 2. Brand Identity

### App Name & Tagline
- **Name**: GST Billing System
- **Tagline**: *"Effortless invoicing, accurate every time."*

### Logo Concept
- A minimal invoice/receipt icon combined with the ₹ (Rupee) symbol
- Rendered in the primary Indigo color on a white background

---

## 3. Color Palette

### Light Theme

| Role | Color | Hex | Usage |
|---|---|---|---|
| **Primary** | Indigo | `#3F51B5` | App bar, FABs, primary buttons, active nav |
| **Primary Container** | Light Indigo | `#E8EAF6` | Selected cards, active chip backgrounds |
| **Secondary** | Teal | `#00897B` | Accent buttons, success states, GST badges |
| **Secondary Container** | Light Teal | `#E0F2F1` | GST summary cards, tag backgrounds |
| **Tertiary** | Amber | `#FF8F00` | Warnings, pending payment status |
| **Error** | Red | `#D32F2F` | Validation errors, delete actions |
| **Surface** | White | `#FFFFFF` | Cards, sheets, dialogs |
| **Surface Variant** | Cool Grey | `#F5F5F5` | Screen backgrounds, dividers |
| **On Surface** | Charcoal | `#1C1B1F` | Primary text |
| **On Surface Variant** | Grey | `#757575` | Secondary text, hints, labels |
| **Outline** | Border Grey | `#E0E0E0` | Card borders, input outlines |
| **Success** | Green | `#2E7D32` | Paid status, successful saves |

### Dark Theme

| Role | Color | Hex |
|---|---|---|
| **Primary** | Light Indigo | `#9FA8DA` |
| **Primary Container** | Deep Indigo | `#303F9F` |
| **Secondary** | Light Teal | `#80CBC4` |
| **Surface** | Dark Grey | `#1E1E1E` |
| **Surface Variant** | Charcoal | `#2C2C2C` |
| **On Surface** | Off-White | `#E6E1E5` |
| **Outline** | Dark Border | `#424242` |

### Semantic Colors

```
┌──────────────────────────────────────────────┐
│  CGST     →  #1565C0  (Blue 800)             │
│  SGST     →  #00838F  (Cyan 800)             │
│  IGST     →  #6A1B9A  (Purple 800)           │
│  Taxable  →  #37474F  (Blue Grey 800)        │
│  Total    →  #1B5E20  (Green 900)            │
│  Paid     →  #2E7D32  (Green 700)            │
│  Unpaid   →  #D32F2F  (Red 700)              │
│  Partial  →  #FF8F00  (Amber 800)            │
└──────────────────────────────────────────────┘
```

---

## 4. Typography

Using **Google Fonts — Poppins** for headings and **Roboto** (Material default) for body text.

| Style | Font | Size | Weight | Line Height | Usage |
|---|---|---|---|---|---|
| Display Large | Poppins | 32sp | 700 | 40 | Dashboard total amount |
| Headline Large | Poppins | 24sp | 600 | 32 | Screen titles |
| Headline Medium | Poppins | 20sp | 600 | 28 | Section headers |
| Title Large | Poppins | 18sp | 600 | 26 | Card titles, party names |
| Title Medium | Roboto | 16sp | 500 | 24 | List item primary text |
| Body Large | Roboto | 16sp | 400 | 24 | Form inputs, descriptions |
| Body Medium | Roboto | 14sp | 400 | 20 | Default body text |
| Body Small | Roboto | 12sp | 400 | 16 | Timestamps, captions |
| Label Large | Roboto | 14sp | 500 | 20 | Button labels, tabs |
| Label Medium | Roboto | 12sp | 500 | 16 | Chip labels, badges |
| Label Small | Roboto | 10sp | 500 | 14 | Overline labels |

### Currency Display
- **Grand Total**: Display Large, Bold, Primary color, with ₹ prefix
- **Line amounts**: Title Medium, monospaced alignment for table columns
- All monetary values formatted with Indian numbering: `₹1,00,000.00`

---

## 5. Spacing & Layout Grid

### Spacing Scale (multiples of 4)

| Token | Value | Usage |
|---|---|---|
| `xs` | 4px | Tight gaps between inline elements |
| `sm` | 8px | Between related elements, icon-to-text gaps |
| `md` | 12px | Between form fields vertically |
| `base` | 16px | Standard padding inside cards and screens |
| `lg` | 20px | Section spacing |
| `xl` | 24px | Screen padding (horizontal) |
| `2xl` | 32px | Major section separation |
| `3xl` | 48px | Screen top/bottom breathing room |

### Layout Grid

| Platform | Max Content Width | Columns | Gutter |
|---|---|---|---|
| Mobile (< 600px) | Full width | 1 | 16px |
| Tablet (600–1024px) | 600px centered | 2 | 24px |
| Web Desktop (> 1024px) | 1200px centered | 3–4 | 24px |

---

## 6. Corner Radius

| Element | Radius |
|---|---|
| Cards | 12px |
| Buttons | 12px (filled) / 20px (FAB) |
| Input fields | 8px |
| Dialogs & Bottom Sheets | 16px (top corners) |
| Chips / Tags | 20px (fully rounded) |
| Avatar / Logo | 50% (circular) |

---

## 7. Elevation & Shadows

| Level | Shadow | Usage |
|---|---|---|
| Level 0 | None | Flat surfaces, backgrounds |
| Level 1 | 1dp blur | Cards, list tiles |
| Level 2 | 3dp blur | Floating cards, app bar |
| Level 3 | 6dp blur | FAB, bottom sheet |
| Level 4 | 8dp blur | Dialogs |

---

## 8. Component Library

### 8.1 Buttons

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  [████ FILLED PRIMARY ████]    Main actions:                │
│  Background: Primary            Save, Create Bill, Add      │
│  Text: OnPrimary                                            │
│  Corner: 12px                                               │
│  Height: 48px                                               │
│  Padding: 24px horizontal                                   │
│                                                             │
│  [──── OUTLINED ────]          Secondary actions:            │
│  Border: Primary                Cancel, View Details         │
│  Text: Primary                                              │
│                                                             │
│  [     TEXT BUTTON    ]        Tertiary actions:             │
│  Text: Primary                  Skip, Reset, Show More      │
│                                                             │
│  [🔴 DESTRUCTIVE 🔴]          Danger actions:               │
│  Background: Error              Delete Party, Delete Item    │
│  Text: OnError                                              │
│                                                             │
│  ( + )  FAB                    Quick-create:                 │
│  Background: Primary            New Bill, New Party          │
│  Icon: OnPrimary                                            │
│  Size: 56px                                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 Cards

#### Standard List Card
```
┌──────────────────────────────────────────┐
│  ┌──┐                                    │
│  │AV│  Title Text (Title Medium)     ▸   │
│  │  │  Subtitle (Body Small, grey)       │
│  └──┘  ₹ Amount (Title Medium, green)    │
│──────────────────────────────────────────│
```
- 12px corner radius
- 1dp elevation
- 16px internal padding
- Leading: CircleAvatar with initials (Primary Container background)
- Trailing: Chevron or amount

#### Dashboard Stat Card
```
┌─────────────────────┐
│  📊                  │
│  Label (Label Sm)    │
│  ₹45,230            │
│  (Display Large)     │
│  +12% ↑ (green)     │
└─────────────────────┘
```
- Gradient background (subtle Primary → Primary Container)
- 12px radius, 2dp elevation
- Icon at top-left, value centered

#### GST Summary Card
```
┌──────────────────────────────────────────┐
│  GST SUMMARY                             │
│  ─────────────────────────────────────── │
│  Subtotal                    ₹10,000.00  │
│  CGST (9%)                      ₹900.00  │
│  SGST (9%)                      ₹900.00  │
│  ─────────────────────────────────────── │
│  Grand Total                ₹11,800.00   │
│  (Eleven Thousand Eight Hundred Only)    │
└──────────────────────────────────────────┘
```
- Secondary Container background
- Dashed divider between sections
- Grand Total in Headline Medium, bold, Primary color
- Amount in words in Body Small, italic

### 8.3 Input Fields

```
┌──────────────────────────────────────────┐
│  Party Name *                            │
│  ┌──────────────────────────────────┐    │
│  │  Enter party name                │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Mobile Number *                         │
│  ┌──────────────────────────────────┐    │
│  │  📱  +91 ___________             │    │
│  └──────────────────────────────────┘    │
│                                          │
│  State *                                 │
│  ┌──────────────────────────────────┐    │
│  │  Select State              ▾     │    │
│  └──────────────────────────────────┘    │
│                                          │
│  GSTIN (Optional)                        │
│  ┌──────────────────────────────────┐    │
│  │  22AAAAA0000A1Z5                 │    │
│  └──────────────────────────────────┘    │
│  ⓘ 15-character alphanumeric code       │
└──────────────────────────────────────────┘
```

- Style: `OutlinedInputDecoration`
- 8px corner radius
- Label floats above on focus
- Required fields marked with `*` in label (red asterisk)
- Helper text below in Body Small, grey
- Error text in Body Small, Error color
- Prefix icons for phone, email fields

### 8.4 Chips & Badges

```
  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │ GST 18%  │  │ ● Paid   │  │ IGST     │
  └──────────┘  └──────────┘  └──────────┘
   Teal bg       Green bg      Purple bg
```

- FilterChip for GST slab selection (0%, 5%, 12%, 18%, 28%)
- Status badge with colored dot (Paid = green, Unpaid = red, Partial = amber)
- Tax type chip with semantic color

### 8.5 Bottom Sheets

```
  ╭──────────────────────────────────────╮
  │  ═══                                 │  ← Drag handle
  │                                      │
  │  Select Party                        │
  │  🔍 Search parties...               │
  │  ─────────────────────────────────── │
  │  ┌──┐ Raj Electronics          ▸    │
  │  │RE│ Mumbai, Maharashtra           │
  │  └──┘                               │
  │  ┌──┐ Priya Traders           ▸    │
  │  │PT│ Delhi                         │
  │  └──┘                               │
  │  ─────────────────────────────────── │
  │  [+ Add New Party]                   │
  ╰──────────────────────────────────────╯
```

- 16px top corner radius
- Drag handle indicator
- Search bar at top
- Scrollable list
- Action button at bottom

### 8.6 Dialogs

```
  ╭──────────────────────────────────────╮
  │                                      │
  │  ⚠️  Delete Party?                   │
  │                                      │
  │  This will permanently delete        │
  │  "Raj Electronics" and cannot        │
  │  be undone.                          │
  │                                      │
  │  Bills created for this party        │
  │  will NOT be affected.               │
  │                                      │
  │         [Cancel]  [🔴 Delete]        │
  ╰──────────────────────────────────────╯
```

- 16px corner radius
- Icon/emoji at top for context
- Clear, descriptive body text
- Cancel (text) + Action (filled) buttons, right-aligned

---

## 9. Navigation Architecture

### Mobile (Android / iOS)

```
┌──────────────────────────────────────────┐
│  ≡  GST Billing System              🔔  │  ← App Bar
├──────────────────────────────────────────┤
│                                          │
│              Screen Content              │
│                                          │
├──────────────────────────────────────────┤
│  🏠       👥       📦      📄      ⚙️   │  ← Bottom Nav
│ Dashboard Parties  Items   Bills  Settings│
└──────────────────────────────────────────┘
```

**Bottom Navigation Bar** with 5 destinations:
1. **Dashboard** — Home icon — Sales overview
2. **Parties** — People icon — Customer management
3. **Items** — Inventory icon — Product management
4. **Bills** — Receipt icon — Bill history
5. **Settings** — Gear icon — Business profile

**FAB overlay**: On Dashboard and Bills screens, a floating "+" button for quick bill creation.

### Web / Tablet

```
┌──────────────────────────────────────────────────────────┐
│  📋 GST Billing System                         ⚙️  👤   │
├────────────┬─────────────────────────────────────────────┤
│            │                                             │
│  🏠 Dashboard  │         Screen Content                  │
│  👥 Parties    │         (max-width: 1200px, centered)   │
│  📦 Items      │                                         │
│  📄 Bills      │                                         │
│            │                                             │
│ ─────────  │                                             │
│  ⚙️ Settings  │                                          │
│            │                                             │
├────────────┴─────────────────────────────────────────────┤
```

**Navigation Rail / Side Drawer** on screens wider than 768px.

---

## 10. Screen Designs

### 10.1 Dashboard Screen

```
┌──────────────────────────────────────────┐
│  ≡  Dashboard                        🔔  │
├──────────────────────────────────────────┤
│                                          │
│  Good Morning! 👋                        │
│  Here's your business overview           │
│                                          │
│  ┌─────────────┐  ┌─────────────┐       │
│  │ Today Sales  │  │ This Month  │       │
│  │ ₹12,450     │  │ ₹3,45,200   │       │
│  │ 5 bills     │  │ 48 bills    │       │
│  └─────────────┘  └─────────────┘       │
│                                          │
│  ┌─────────────┐  ┌─────────────┐       │
│  │ Tax Today   │  │ Tax Month   │       │
│  │ ₹2,241     │  │ ₹62,136     │       │
│  └─────────────┘  └─────────────┘       │
│                                          │
│  Quick Actions                           │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐           │
│  │ +📄│ │ +👥│ │ +📦│ │ 📊 │           │
│  │Bill│ │Prty│ │Item│ │Hist│           │
│  └────┘ └────┘ └────┘ └────┘           │
│                                          │
│  Recent Bills                            │
│  ───────────────────────────────────     │
│  INV-202609-0005  Raj Electronics        │
│  Today 2:30 PM         ₹11,800  ● Paid  │
│  ───────────────────────────────────     │
│  INV-202609-0004  Priya Traders          │
│  Today 11:00 AM        ₹5,450   ● Paid  │
│  ───────────────────────────────────     │
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │
└──────────────────────────────────────────┘
                                    (  +  )  ← FAB
```

### 10.2 Party List Screen

```
┌──────────────────────────────────────────┐
│  ←  Parties                          🔍  │
├──────────────────────────────────────────┤
│  ┌──────────────────────────────────┐    │
│  │  🔍 Search parties...            │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──┐ Raj Electronics            ▸      │
│  │RE│ 9876543210                         │
│  └──┘ Mumbai, Maharashtra                │
│  ───────────────────────────────────     │
│  ┌──┐ Priya Traders             ▸      │
│  │PT│ 9988776655                         │
│  └──┘ New Delhi, Delhi                   │
│  ───────────────────────────────────     │
│  ┌──┐ Kumar & Sons              ▸      │
│  │KS│ 8877665544                         │
│  └──┘ Chennai, Tamil Nadu                │
│  ───────────────────────────────────     │
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │
└──────────────────────────────────────────┘
                                    (  +  )  ← FAB: Add Party
```

### 10.3 Party Form Screen (Add / Edit)

```
┌──────────────────────────────────────────┐
│  ←  Add Party                    [Save]  │
├──────────────────────────────────────────┤
│                                          │
│  Party Name *                            │
│  ┌──────────────────────────────────┐    │
│  │  Enter party name                │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Mobile Number *                         │
│  ┌──────────────────────────────────┐    │
│  │  📱  Enter 10-digit number       │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Address *                               │
│  ┌──────────────────────────────────┐    │
│  │                                  │    │
│  │  Enter full address              │    │
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│  State *                                 │
│  ┌──────────────────────────────────┐    │
│  │  Select State              ▾     │    │
│  └──────────────────────────────────┘    │
│                                          │
│  GSTIN (Optional)                        │
│  ┌──────────────────────────────────┐    │
│  │  e.g. 22AAAAA0000A1Z5           │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Email (Optional)                        │
│  ┌──────────────────────────────────┐    │
│  │  📧  Enter email address         │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │        💾  Save Party             │    │
│  └──────────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

### 10.4 Party Detail Screen

```
┌──────────────────────────────────────────┐
│  ←  Raj Electronics          ✏️  🗑️     │
├──────────────────────────────────────────┤
│                                          │
│           ┌────────┐                     │
│           │   RE   │                     │
│           └────────┘                     │
│        Raj Electronics                   │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  📱  9876543210                   │    │
│  │  📧  raj@electronics.com          │    │
│  │  📍  Shop 12, Market Road         │    │
│  │      Mumbai, Maharashtra          │    │
│  │  🏷️  GSTIN: 27AABCR1234F1Z5      │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Bill History (12 bills)                 │
│  ───────────────────────────────────     │
│  INV-202609-0005    ₹11,800  ● Paid     │
│  19 Sep 2026                             │
│  ───────────────────────────────────     │
│  INV-202608-0042    ₹24,500  ● Paid     │
│  15 Aug 2026                             │
│  ───────────────────────────────────     │
│  INV-202608-0038    ₹7,200   ● Paid     │
│  10 Aug 2026                             │
│  ───────────────────────────────────     │
│                                          │
└──────────────────────────────────────────┘
```

### 10.5 Item List Screen

```
┌──────────────────────────────────────────┐
│  ←  Items                            🔍  │
├──────────────────────────────────────────┤
│  ┌──────────────────────────────────┐    │
│  │  🔍 Search items...              │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  LED TV 42"                       │    │
│  │  HSN: 8528  │  ₹25,000  │ 18% GST│    │
│  │                        [✏️] [🗑️] │    │
│  └──────────────────────────────────┘    │
│  ┌──────────────────────────────────┐    │
│  │  USB Cable Type-C                 │    │
│  │  HSN: 8544  │  ₹299     │ 18% GST│    │
│  │                        [✏️] [🗑️] │    │
│  └──────────────────────────────────┘    │
│  ┌──────────────────────────────────┐    │
│  │  Laptop Stand                     │    │
│  │  HSN: 8473  │  ₹1,500   │ 12% GST│    │
│  │                        [✏️] [🗑️] │    │
│  └──────────────────────────────────┘    │
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │
└──────────────────────────────────────────┘
                                    (  +  )  ← FAB: Add Item
```

### 10.6 Item Form Screen

```
┌──────────────────────────────────────────┐
│  ←  Add Item                     [Save]  │
├──────────────────────────────────────────┤
│                                          │
│  Item Name *                             │
│  ┌──────────────────────────────────┐    │
│  │  Enter item/product name         │    │
│  └──────────────────────────────────┘    │
│                                          │
│  HSN/SAC Code (Optional)                 │
│  ┌──────────────────────────────────┐    │
│  │  e.g. 8528                       │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Unit Price (₹) *                        │
│  ┌──────────────────────────────────┐    │
│  │  ₹  0.00                         │    │
│  └──────────────────────────────────┘    │
│                                          │
│  GST Rate *                              │
│  ┌──────┐┌──────┐┌──────┐┌──────┐┌────┐ │
│  │  0%  ││  5%  ││ 12%  ││ 18%  ││28% │ │
│  └──────┘└──────┘└──────┘└──────┘└────┘ │
│  ↑ Choice chips — tap to select          │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │        💾  Save Item              │    │
│  └──────────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

### 10.7 Create Bill Screen

```
┌──────────────────────────────────────────┐
│  ←  Create Bill                          │
├──────────────────────────────────────────┤
│                                          │
│  STEP 1 — Select Party                   │
│  ┌──────────────────────────────────┐    │
│  │  👥  Tap to select party    ▸    │    │
│  └──────────────────────────────────┘    │
│  or [+ Quick Add Party]                  │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  STEP 2 — Add Items                      │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  LED TV 42"              ✕       │    │
│  │  Rate: ₹25,000   Qty: [  1  ]   │    │
│  │  GST: 18%                         │    │
│  │  ────────────────────────────    │    │
│  │  Taxable:  ₹25,000               │    │
│  │  CGST 9%:  ₹2,250                │    │
│  │  SGST 9%:  ₹2,250                │    │
│  │  Total:    ₹29,500               │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  USB Cable Type-C        ✕       │    │
│  │  Rate: ₹299      Qty: [  3  ]   │    │
│  │  GST: 18%                         │    │
│  │  ────────────────────────────    │    │
│  │  Taxable:  ₹897                   │    │
│  │  CGST 9%:  ₹80.73                │    │
│  │  SGST 9%:  ₹80.73                │    │
│  │  Total:    ₹1,058.46             │    │
│  └──────────────────────────────────┘    │
│                                          │
│  [+ Add Item]                            │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  GST SUMMARY                      │    │
│  │  ───────────────────────────     │    │
│  │  Subtotal          ₹25,897.00    │    │
│  │  Total CGST         ₹2,330.73    │    │
│  │  Total SGST         ₹2,330.73    │    │
│  │  ───────────────────────────     │    │
│  │  GRAND TOTAL       ₹30,558.46    │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │     📄  Generate Bill             │    │
│  └──────────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

### 10.8 Bill Detail Screen (Read-Only)

```
┌──────────────────────────────────────────┐
│  ←  INV-202609-0005       [📤] [📥]     │
│                           Share Download │
├──────────────────────────────────────────┤
│                                          │
│  Invoice No: INV-202609-0005             │
│  Date: 19 Sep 2026                       │
│  Status: ● Paid                          │
│                                          │
│  Bill To:                                │
│  ┌──────────────────────────────────┐    │
│  │  Raj Electronics                  │    │
│  │  GSTIN: 27AABCR1234F1Z5          │    │
│  │  Shop 12, Market Road            │    │
│  │  Mumbai, Maharashtra             │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Items                                   │
│  ┌──────────────────────────────────┐    │
│  │ # │ Item    │Qty│ Rate  │ Total  │    │
│  │───│─────────│───│───────│────────│    │
│  │ 1 │LED TV   │ 1 │25,000 │29,500  │    │
│  │ 2 │USB Cbl  │ 3 │  299  │1,058.46│    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  Subtotal          ₹25,897.00    │    │
│  │  CGST               ₹2,330.73    │    │
│  │  SGST               ₹2,330.73    │    │
│  │  ═══════════════════════════     │    │
│  │  Grand Total       ₹30,558.46    │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │     📤  Share as PDF              │    │
│  └──────────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

### 10.9 Bill History Screen

```
┌──────────────────────────────────────────┐
│  ←  Bill History                     🔍  │
├──────────────────────────────────────────┤
│  ┌──────────────────────────────────┐    │
│  │  🔍 Search by party name...      │    │
│  └──────────────────────────────────┘    │
│  ┌──────────┐ ┌──────────┐              │
│  │ From Date│ │ To Date  │  [Filter]    │
│  └──────────┘ └──────────┘              │
│                                          │
│  September 2026                          │
│  ───────────────────────────────────     │
│  ┌──────────────────────────────────┐    │
│  │  INV-202609-0005                  │    │
│  │  Raj Electronics     ₹30,558.46  │    │
│  │  19 Sep, 2:30 PM        ● Paid   │    │
│  └──────────────────────────────────┘    │
│  ┌──────────────────────────────────┐    │
│  │  INV-202609-0004                  │    │
│  │  Priya Traders       ₹5,450.00   │    │
│  │  19 Sep, 11:00 AM       ● Paid   │    │
│  └──────────────────────────────────┘    │
│                                          │
│  August 2026                             │
│  ───────────────────────────────────     │
│  ┌──────────────────────────────────┐    │
│  │  INV-202608-0042                  │    │
│  │  Raj Electronics     ₹24,500.00  │    │
│  │  15 Aug, 4:15 PM        ● Paid   │    │
│  └──────────────────────────────────┘    │
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │
└──────────────────────────────────────────┘
```

### 10.10 Business Profile / Settings Screen

```
┌──────────────────────────────────────────┐
│  ←  Business Profile             [Save]  │
├──────────────────────────────────────────┤
│                                          │
│  This info appears on your invoices.     │
│                                          │
│  Shop / Business Name *                  │
│  ┌──────────────────────────────────┐    │
│  │  Your Shop Name                   │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Business Address *                      │
│  ┌──────────────────────────────────┐    │
│  │                                  │    │
│  │  Full address for invoice header │    │
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│  State *                                 │
│  ┌──────────────────────────────────┐    │
│  │  Select State              ▾     │    │
│  └──────────────────────────────────┘    │
│  ⓘ Used to determine CGST/SGST vs IGST │
│                                          │
│  GSTIN *                                 │
│  ┌──────────────────────────────────┐    │
│  │  Your 15-character GSTIN         │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Phone Number                            │
│  ┌──────────────────────────────────┐    │
│  │  📱  Business phone              │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Email                                   │
│  ┌──────────────────────────────────┐    │
│  │  📧  Business email              │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │        💾  Save Profile           │    │
│  └──────────────────────────────────┘    │
│                                          │
└──────────────────────────────────────────┘
```

---

## 11. Empty States

Each list screen has a tailored empty state when no data exists:

```
┌──────────────────────────────────────────┐
│                                          │
│              📋                           │
│                                          │
│        No parties added yet              │
│                                          │
│   Add your first customer to get         │
│   started with billing.                  │
│                                          │
│        [+ Add Party]                     │
│                                          │
└──────────────────────────────────────────┘
```

| Screen | Icon | Title | Description |
|---|---|---|---|
| Parties | 👥 | No parties added yet | Add your first customer to get started with billing. |
| Items | 📦 | No items added yet | Add products to quickly add them to bills. |
| Bills | 📄 | No bills created yet | Create your first GST invoice. |
| Party Bills | 📋 | No bills for this party | Create a bill for this party to see it here. |

---

## 12. Loading & Feedback Patterns

| Pattern | Usage |
|---|---|
| **Skeleton shimmer** | List screens while loading initial data |
| **CircularProgressIndicator** | Inside buttons during async operations |
| **SnackBar (success)** | "Party saved successfully", "Bill created" |
| **SnackBar (error)** | Validation failures, save errors |
| **Pull-to-refresh** | Party list, item list, bill history |
| **Confirmation dialog** | Before delete operations |

---

## 13. Micro-Animations

| Animation | Where | Duration |
|---|---|---|
| **Page transitions** | Screen navigation | 300ms, `CupertinoPageRoute` on iOS |
| **FAB scale** | Appear/disappear on scroll | 200ms |
| **Card press** | List items on tap | 100ms scale down to 0.98 |
| **Quantity counter** | +/- buttons on bill items | 150ms number roll |
| **Bottom sheet slide** | Party/Item selector | 250ms slide up |
| **Success checkmark** | After bill creation | 600ms animated check ✓ |

---

## 14. PDF Invoice Layout

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   YOUR SHOP NAME                          TAX INVOICE       │
│   Shop Address Line 1                                       │
│   City, State - Pincode                                     │
│   GSTIN: 27AABCR1234F1Z5                                   │
│   Phone: 9876543210 | Email: shop@email.com                 │
│                                                             │
│   ═══════════════════════════════════════════════════════   │
│                                                             │
│   Invoice No: INV-202609-0005          Date: 19-Sep-2026   │
│                                                             │
│   Bill To:                                                  │
│   Raj Electronics                                           │
│   GSTIN: 27AABCR1234F1Z5                                   │
│   Shop 12, Market Road, Mumbai, Maharashtra                 │
│                                                             │
│   ───────────────────────────────────────────────────────   │
│   # │ Item         │ HSN  │Qty│ Rate    │Taxable  │GST%│   │
│   ──│──────────────│──────│───│─────────│─────────│────│   │
│   1 │ LED TV 42"   │ 8528 │ 1 │25,000.00│25,000.00│ 18 │   │
│   2 │ USB Cable    │ 8544 │ 3 │   299.00│   897.00│ 18 │   │
│   ───────────────────────────────────────────────────────   │
│                                                             │
│   # │ CGST Amt │ SGST Amt │ IGST Amt │ Line Total          │
│   ──│──────────│──────────│──────────│───────────           │
│   1 │ 2,250.00 │ 2,250.00 │     0.00 │ 29,500.00           │
│   2 │    80.73 │    80.73 │     0.00 │  1,058.46           │
│   ───────────────────────────────────────────────────────   │
│                                                             │
│                              Subtotal:      ₹25,897.00     │
│                              Total CGST:     ₹2,330.73     │
│                              Total SGST:     ₹2,330.73     │
│                              ─────────────────────────     │
│                              Grand Total:   ₹30,558.46     │
│                                                             │
│   Amount in words: Thirty Thousand Five Hundred             │
│   Fifty-Eight Rupees and Forty-Six Paise Only               │
│                                                             │
│   ───────────────────────────────────────────────────────   │
│   Terms & Conditions:                                       │
│   1. Goods once sold will not be taken back.                │
│   2. Subject to local jurisdiction.                         │
│                                                             │
│                              Authorized Signatory           │
│                              ____________________           │
│                                                             │
│   Generated by GST Billing System                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 15. Accessibility

| Guideline | Implementation |
|---|---|
| **Touch targets** | Minimum 48×48dp for all interactive elements |
| **Color contrast** | WCAG AA (4.5:1 for text, 3:1 for large text) |
| **Semantic labels** | All icons and buttons have `Semantics` / `tooltip` |
| **Font scaling** | Respects system font size preferences |
| **Screen reader** | All images and icons have `semanticLabel` |
| **Focus order** | Logical tab order for web/keyboard navigation |

---

## 16. Responsive Breakpoints Summary

| Breakpoint | Layout | Navigation |
|---|---|---|
| < 600px | Single column, full-width cards | Bottom Nav Bar |
| 600–1024px | Two-column grid for dashboard, centered forms | Bottom Nav Bar |
| > 1024px | Side drawer + main content (max 1200px) | Navigation Rail / Drawer |

---

*This design system ensures a consistent, professional, and accessible experience across Android, iOS, and Web.*
