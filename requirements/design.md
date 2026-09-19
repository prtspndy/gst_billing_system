# GST Billing System — Premium Design System v2.0

> A **top-tier, world-class** design system for a GST Billing application targeting **Android**, **iOS**, and **Web** — designed to rival the best fintech apps in India.

---

## 1. Design Philosophy

| Principle | Description |
|---|---|
| **Clarity First** | Billing apps handle money — every number, label, and action must be instantly readable with zero ambiguity. |
| **Professional Trust** | A clean, structured, premium look that gives shopkeepers confidence in accuracy and makes them proud to use the app. |
| **Speed of Use** | Shopkeepers create bills under time pressure — minimize taps, maximize flow. Target: **invoice in under 60 seconds**. |
| **Delightful Motion** | Subtle, physics-based animations (staggered fade-ins, scale transitions, hero animations) that make the app feel alive without slowing users down. |
| **Responsive & Adaptive** | One codebase that feels native on phones, spacious on tablets, and powerful on web desktops. |
| **Dark Mode First-Class** | Dark theme is not an afterthought — it's a fully polished, high-contrast, eye-comfortable experience. |

---

## 2. Brand Identity

### App Name & Tagline
- **Name**: GST Billing System
- **Tagline**: *"Effortless invoicing, accurate every time."*

### Logo Concept
- A minimal receipt/invoice icon with a ₹ (Rupee) symbol integrated into the design
- Rendered in the primary Indigo (#3F51B5) color inside a rounded 20px square with a subtle drop shadow
- White icon on Indigo background — works on both light and dark surfaces

### App Icon Specification
```
┌─────────────────────┐
│  ╭───────────────╮   │
│  │  ┌─────────┐  │   │  Background: #3F51B5 (Indigo)
│  │  │ ═══════ │  │   │  Icon: White receipt with ₹
│  │  │ ═══ ₹══ │  │   │  Corner Radius: 20px (Android adaptive)
│  │  │ ═══════ │  │   │  Size: 1024×1024 master
│  │  └─────────┘  │   │
│  ╰───────────────╯   │
└─────────────────────┘
```

---

## 3. Color Palette

### 3.1 Light Theme

| Role | Color | Hex | Usage |
|---|---|---|---|
| **Primary** | Indigo | `#3F51B5` | App bar, FABs, primary buttons, active nav, links |
| **Primary Dark** | Deep Indigo | `#303F9F` | Grand total amounts, emphasis headings |
| **Primary Container** | Light Indigo | `#E8EAF6` | Selected cards, active chip bg, avatar bg |
| **On Primary Container** | Navy | `#1A237E` | Text on primary container surfaces |
| **Secondary** | Teal | `#00897B` | Accent buttons, success actions, GST badges |
| **Secondary Dark** | Deep Teal | `#004D40` | Secondary emphasis text on teal surfaces |
| **Secondary Container** | Light Teal | `#E0F2F1` | GST summary card bg, tag backgrounds |
| **Tertiary** | Amber | `#FF8F00` | Warnings, pending status, attention states |
| **Error** | Red | `#D32F2F` | Validation errors, delete actions, unpaid status |
| **Surface** | White | `#FFFFFF` | Cards, sheets, dialogs, inputs |
| **Surface Variant** | Cool Grey | `#F5F7FA` | Screen backgrounds, scaffold |
| **On Surface** | Charcoal | `#1C1B1F` | Primary text, headings |
| **On Surface Variant** | Grey | `#616161` | Secondary text, labels |
| **Outline** | Border Grey | `#E0E0E0` | Card borders, input outlines, dividers |
| **Outline Variant** | Soft Grey | `#EEEEEE` | Subtle separators, section dividers |
| **Success** | Green | `#2E7D32` | Paid status, successful saves, confirmations |
| **Muted Text** | Pale Grey | `#9E9E9E` | Timestamps, helper text, captions |
| **Info** | Light Blue | `#0288D1` | Informational badges, notices |

### 3.2 Dark Theme

| Role | Color | Hex | Usage |
|---|---|---|---|
| **Primary** | Light Indigo | `#9FA8DA` | Primary buttons, active nav, links |
| **Primary Container** | Deep Indigo | `#303F9F` | Active chip bg, selected state |
| **On Primary Container** | White | `#FFFFFF` | Text on primary container |
| **Secondary** | Light Teal | `#80CBC4` | Accent buttons, GST badges |
| **Secondary Container** | Dark Teal | `#00695C` | GST summary bg |
| **Surface** | Dark Grey | `#1E1E1E` | Cards, sheets, app bar |
| **Surface Variant** | Charcoal | `#121212` | Scaffold background |
| **On Surface** | Off-White | `#E6E1E5` | Primary text |
| **Outline** | Dark Border | `#424242` | Card borders, input outlines |
| **Outline Variant** | Subtle Border | `#2C2C2C` | Section dividers |
| **Error** | Light Red | `#EF5350` | Errors, delete actions |
| **Success** | Light Green | `#66BB6A` | Paid status, confirmations |

### 3.3 Semantic / Tax Colors (Both Themes)

```
┌──────────────────────────────────────────────────────┐
│  CGST     →  #1565C0  (Blue 800)     — Blue badge    │
│  SGST     →  #00838F  (Cyan 800)     — Cyan badge    │
│  IGST     →  #6A1B9A  (Purple 800)   — Purple badge  │
│  Taxable  →  #37474F  (Blue Grey 800) — Neutral       │
│  Total    →  #1B5E20  (Green 900)    — Grand total    │
│  Paid     →  #2E7D32  (Green 700)    — Green dot      │
│  Unpaid   →  #D32F2F  (Red 700)     — Red dot         │
│  Partial  →  #FF8F00  (Amber 800)   — Orange dot      │
└──────────────────────────────────────────────────────┘
```

### 3.4 Gradient Definitions

| Name | Start | End | Usage |
|---|---|---|---|
| **Primary Gradient** | `#3F51B5` | `#303F9F` | Welcome banner, hero sections |
| **Stat Card Blue** | `#E8EAF6` | `#C5CAE9` | Today's sales stat bg (light) |
| **Stat Card Teal** | `#E0F2F1` | `#B2DFDB` | Monthly sales stat bg (light) |
| **Dark Primary Gradient** | `#303F9F` | `#1A237E` | Welcome banner (dark theme) |

> **Rule:** Gradients are always subtle (same hue family, low contrast). Never use rainbow or multi-hue gradients.

---

## 4. Typography

### Font Stack
- **Headings**: Google Fonts — **Poppins** (600/700 weight)
- **Body & UI**: Google Fonts — **Inter** (400/500/600 weight)
- **Currency / Numbers**: Google Fonts — **JetBrains Mono** or Inter with tabular figures
- **Fallback**: System sans-serif (Roboto on Android, SF Pro on iOS)

### Type Scale

| Style | Font | Size | Weight | Letter Spacing | Line Height | Usage |
|---|---|---|---|---|---|---|
| **Display Large** | Poppins | 32sp | 700 | -0.25 | 40 | Grand total amount on dashboard |
| **Display Medium** | Poppins | 28sp | 700 | 0 | 36 | Bill grand total |
| **Headline Large** | Poppins | 24sp | 600 | 0 | 32 | Screen titles (AppBar) |
| **Headline Medium** | Poppins | 20sp | 600 | 0.15 | 28 | Section headers, card titles |
| **Title Large** | Poppins | 18sp | 600 | 0 | 26 | Party names, item names |
| **Title Medium** | Inter | 16sp | 500 | 0.15 | 24 | List item primary text |
| **Title Small** | Inter | 14sp | 500 | 0.1 | 20 | Sub-section headers |
| **Body Large** | Inter | 16sp | 400 | 0.5 | 24 | Form inputs, descriptions |
| **Body Medium** | Inter | 14sp | 400 | 0.25 | 20 | Default body text |
| **Body Small** | Inter | 12sp | 400 | 0.4 | 16 | Timestamps, captions, helper text |
| **Label Large** | Inter | 14sp | 600 | 0.1 | 20 | Button labels, tab labels |
| **Label Medium** | Inter | 12sp | 500 | 0.5 | 16 | Chip labels, badges, GSTIN |
| **Label Small** | Inter | 10sp | 500 | 0.5 | 14 | Overline labels, tiny captions |

### Currency Display Rules
- **Grand Total**: Display Large/Medium + Bold + Primary Dark color + `₹` prefix
- **Line item amounts**: Title Medium, right-aligned with tabular figures
- **Tax breakdowns**: Body Medium, colored per tax type (CGST blue, SGST cyan, IGST purple)
- All monetary values use Indian numbering: `₹1,00,000.00`
- Use `₹` symbol prefix, not suffix. No space between ₹ and amount.

---

## 5. Spacing & Layout Grid

### 5.1 Spacing Scale (base 4px)

| Token | Value | CSS/Flutter | Usage |
|---|---|---|---|
| `space-2xs` | 2px | `2` | Hairline gaps |
| `space-xs` | 4px | `4` | Tight gaps between inline elements |
| `space-sm` | 8px | `8` | Icon-to-text gaps, between related items |
| `space-md` | 12px | `12` | Between form fields vertically |
| `space-base` | 16px | `16` | Standard card padding, screen horizontal padding |
| `space-lg` | 20px | `20` | Section spacing, card internal sections |
| `space-xl` | 24px | `24` | Screen padding (horizontal on tablet/web) |
| `space-2xl` | 32px | `32` | Major section separation |
| `space-3xl` | 48px | `48` | Screen top/bottom breathing room, empty states |
| `space-4xl` | 64px | `64` | Hero section padding |

### 5.2 Layout Grid / Breakpoints

| Platform | Breakpoint | Max Content Width | Columns | Gutter | Margin |
|---|---|---|---|---|---|
| **Mobile** | < 600px | Full width | 1 | 16px | 16px |
| **Tablet** | 600–1024px | 720px centered | 2 | 20px | 24px |
| **Desktop** | 1024–1440px | 1000px centered | 2–3 | 24px | 24px |
| **Wide Desktop** | > 1440px | 1200px centered | 3–4 | 24px | auto |

### 5.3 Responsive Behavior

| Component | Mobile | Tablet | Web Desktop |
|---|---|---|---|
| **Navigation** | Bottom NavigationBar (5 tabs) | NavigationRail (collapsed) | NavigationRail (expanded with labels) |
| **Dashboard Stats** | 2×2 grid | 2×2 grid | 4×1 row |
| **Quick Actions** | 3 buttons in a row | 4 buttons in a row | 4 buttons in a row |
| **Bill List** | Card list (vertical) | Card list (wider cards) | Table-like list with columns |
| **Forms** | Single column | Single column (max 600px) | Two columns (max 800px) |
| **Dialogs** | Full-width bottom sheet | Centered dialog (420px) | Centered dialog (420px) |

---

## 6. Corner Radius System

| Element | Radius | Token |
|---|---|---|
| **Cards** | 16px | `radius-lg` |
| **Filled Buttons** | 12px | `radius-md` |
| **Input Fields** | 10px | `radius-base` |
| **Chips / Tags / Badges** | 20px | `radius-full` |
| **Dialogs** | 20px | `radius-xl` |
| **Bottom Sheets** | 20px top-only | `radius-xl` |
| **FAB** | 16px | `radius-lg` |
| **Avatars** | 50% | circular |
| **Stat Cards** | 16px | `radius-lg` |
| **Search Bar** | 12px | `radius-md` |
| **Snackbar** | 12px | `radius-md` |

---

## 7. Elevation & Shadow System

| Level | Blur | Offset | Opacity | Usage |
|---|---|---|---|---|
| **Level 0** | 0 | (0, 0) | 0 | Flat surfaces, scaffold background |
| **Level 1** | 4px | (0, 1) | 0.04 | Cards, list tiles at rest |
| **Level 2** | 8px | (0, 2) | 0.06 | Hovered/focused cards, search bar |
| **Level 3** | 12px | (0, 4) | 0.08 | Bottom nav bar, navigation rail |
| **Level 4** | 16px | (0, 6) | 0.10 | FAB, floating elements |
| **Level 5** | 24px | (0, 8) | 0.12 | Dialogs, bottom sheets |

> **Dark theme:** Shadows are replaced by subtle 1px borders (`outline` color) and very slight elevation tint overlays. No visible drop shadows on dark surfaces.

---

## 8. Component Library

### 8.1 Buttons

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  [████ FILLED PRIMARY ████]    Main actions:                │
│  Background: Primary (#3F51B5)   Save, Create Bill, Sign In │
│  Text: White, Label Large, 600                              │
│  Corner: 12px                                               │
│  Height: 48px (mobile) / 44px (web)                        │
│  Padding: 24px horizontal, 14px vertical                    │
│  Shadow: Level 0 (flat)                                     │
│  Hover: darken 8% + Level 1 shadow                         │
│  Press: darken 12%, scale(0.98)                             │
│                                                             │
│  [████ FILLED SECONDARY ████]  Accent actions:              │
│  Background: Secondary (#00897B) Create for Customer        │
│                                                             │
│  [──── OUTLINED ────]          Secondary actions:            │
│  Border: 1.5px Primary           Cancel, Select, Google btn │
│  Text: Primary, Label Large                                 │
│                                                             │
│  [     TEXT BUTTON    ]        Tertiary actions:             │
│  Text: Primary, Label Large     Skip, Reset, View All       │
│  Background: transparent                                    │
│  Hover: primary @ 8% opacity bg                            │
│                                                             │
│  [🔴 DESTRUCTIVE 🔴]          Danger actions:               │
│  Background: Error (#D32F2F)    Delete, Sign Out             │
│  Text: White                                                │
│                                                             │
│  ( + ) FAB Extended                                         │
│  Background: Primary            Create Bill (Dashboard)     │
│  Icon + Label: White                                        │
│  Corner: 16px                                               │
│  Height: 56px                                               │
│  Shadow: Level 4                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 Cards

#### Standard List Card (Party / Item / Bill)
```
┌──────────────────────────────────────────────┐
│                                              │
│  ┌────┐  Title Text                    ₹ ▸  │
│  │ AV │  Subtitle line 1                    │
│  │    │  ┌──────┐ ┌─────────┐              │
│  └────┘  │Badge1│ │ Badge 2 │              │
│          └──────┘ └─────────┘              │
│                                              │
└──────────────────────────────────────────────┘
```
- Background: `surface` color
- Corner radius: 16px
- Border: 1px `outline` color
- Elevation: Level 1 (4px blur)
- Internal padding: 16px
- Leading: CircleAvatar (48×48, primary container bg, initials in primary color)
- Content: Title (Title Medium, bold) + Subtitle (Body Small, muted) + Badges row
- Trailing: Amount (Title Medium, primary dark) or chevron
- Tap: Ripple effect with primary @ 8%
- Press: Scale to 0.98, elevation to Level 0
- Spacing between cards: 12px

#### Dashboard Stat Card
```
┌─────────────────────────┐
│  📊 Label               │
│                         │
│  ₹45,230               │    ← Display Large, bold
│  5 bills today  ▲ +12% │    ← Body Small + green chip
│                         │
└─────────────────────────┘
```
- Background: Subtle gradient (primary container → slightly darker shade)
- Corner radius: 16px
- Internal padding: 16px
- Shadow: Level 1
- Icon: 36×36 in a 40×40 rounded(10px) container with colored bg
- Value: Display Large if space allows, otherwise Headline Medium
- Sub-label: Body Small, muted text
- Dark theme: Dark surface with 1px border, icon with 15% opacity tint bg

#### GST Summary Card
```
┌──────────────────────────────────────────────┐
│  GST SUMMARY               ┌──────────────┐ │
│                             │ Intra-State  │ │
│                             │ (CGST+SGST)  │ │
│                             └──────────────┘ │
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│  Taxable Subtotal              ₹10,000.00   │
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│  CGST (9%)              ●      ₹900.00      │  ← Blue dot
│  SGST (9%)              ●      ₹900.00      │  ← Cyan dot
│  Total Tax                     ₹1,800.00     │
│  ═══════════════════════════════════════════ │
│  GRAND TOTAL                  ₹11,800.00     │  ← Primary Dark, Display Medium
│  (Eleven Thousand Eight Hundred Rupees Only) │  ← Italic, muted
└──────────────────────────────────────────────┘
```
- Background: `secondaryContainer` with 35% opacity (light), `surface` (dark)
- Border: Secondary @ 30% opacity (light), `outline` (dark)
- Corner radius: 16px
- Section dividers: Dashed line (outline variant)
- Grand Total row: Thick solid divider above, Primary Dark color, Display Medium font
- Amount in words: Body Small, italic, muted

### 8.3 Input Fields

```
┌──────────────────────────────────────────────┐
│                                              │
│  Party Name *                                │  ← Floating label (primary when focused)
│  ┌────────────────────────────────────────┐  │
│  │  👤  Enter party name                  │  │  ← Prefix icon + hint
│  └────────────────────────────────────────┘  │
│                                              │
│  Mobile Number *                             │
│  ┌────────────────────────────────────────┐  │
│  │  📱  +91 __________                    │  │  ← Prefix icon + prefix text
│  └────────────────────────────────────────┘  │
│                                              │
│  GSTIN (Optional)                            │
│  ┌────────────────────────────────────────┐  │
│  │  🏷️  24AAAAA0000A1Z5                   │  │
│  └────────────────────────────────────────┘  │
│  ⓘ 15-character alphanumeric code           │  ← Helper text (muted)
│                                              │
│  State *                                     │
│  ┌────────────────────────────────────────┐  │
│  │  🗺️  Select State                 ▾    │  │  ← Dropdown with icon
│  └────────────────────────────────────────┘  │
│  ⚠️ Determines CGST/SGST vs IGST            │  ← Important helper (warning color)
│                                              │
└──────────────────────────────────────────────┘
```

**Input Field Specification:**
- Style: `OutlineInputBorder` with rounded corners
- Corner radius: 10px
- Border: 1px `outline` color (default), 1.5px `primary` (focused), 1px `error` (error)
- Fill: `surface` color (white in light, dark grey in dark)
- Content padding: 16px horizontal, 14px vertical
- Label: floats above on focus, `primary` color when focused
- Prefix icons: 20px, `onSurfaceVariant` color
- Helper text: Body Small, muted
- Error text: Body Small, error color, with ⚠ icon prefix
- Required fields: Label ends with ` *` (asterisk in error color)
- Focus: Smooth border color animation (200ms ease)

### 8.4 Chips & Badges

```
  Status Badges:
  ┌──────────┐  ┌──────────┐  ┌───────────┐
  │ ● Paid   │  │ ● Unpaid │  │ ● Partial │
  └──────────┘  └──────────┘  └───────────┘
   #2E7D32 bg    #D32F2F bg     #FF8F00 bg
   @12% alpha    @12% alpha     @12% alpha

  Tax Type Chips:
  ┌────────────┐  ┌───────────┐
  │ CGST+SGST  │  │   IGST    │
  └────────────┘  └───────────┘
   #1565C0 bg      #6A1B9A bg
   @12% alpha      @12% alpha

  GST Slab Filter Chips:
  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
  │  0%  │ │  5%  │ │ 12%  │ │ 18%  │ │ 28%  │
  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘
  Selected: Teal filled, white text
  Unselected: Outline, onSurface text
```

**Badge Specification:**
- Corner radius: 20px (fully rounded)
- Padding: 6px horizontal, 2px vertical
- Font: Label Medium (12sp, 500 weight)
- Dot indicator: 6px circle before text
- Background: Semantic color @ 12% opacity
- Text: Semantic color @ 100%

### 8.5 Bottom Sheets

```
  ╭──────────────────────────────────────╮
  │           ━━━━━                      │  ← Drag handle (4×40px, outline color)
  │                                      │
  │  Select Party              [× Close] │  ← Headline Medium
  │                                      │
  │  🔍 Search parties...               │  ← Search bar
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │
  │                                      │
  │  ┌──┐ Raj Electronics           ▸   │
  │  │RE│ 📱 9876543210 • Maharashtra    │
  │  └──┘                               │
  │                                      │
  │  ┌──┐ Priya Traders            ▸   │
  │  │PT│ 📱 9988776655 • Delhi          │
  │  └──┘                               │
  │                                      │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │
  │  [+ Add New Party]                   │  ← Text Button at bottom
  │                                      │
  ╰──────────────────────────────────────╯
```

**Bottom Sheet Specification:**
- Corner radius: 20px (top-left, top-right only)
- Background: `surface` color
- Drag handle: Centered, 4px height, 40px width, outline color
- Max height: 85% of screen height
- Shadow: Level 5
- Scrim: Black @ 40% opacity
- Enter animation: Slide up + fade in (300ms, decelerating curve)
- Exit animation: Slide down + fade out (200ms, accelerating curve)

### 8.6 Dialogs

```
  ╭──────────────────────────────────────╮
  │                                      │
  │  🗑️                                  │  ← Icon (40×40, in error container circle)
  │                                      │
  │  Delete Party?                       │  ← Headline Medium
  │                                      │
  │  This will permanently delete        │  ← Body Medium, onSurfaceVariant
  │  "Raj Electronics" and cannot        │
  │  be undone.                          │
  │                                      │
  │  Existing bills for this party       │  ← Body Small, muted
  │  will NOT be affected.               │
  │                                      │
  │         [Cancel]  [████ Delete ████]  │  ← TextButton + Filled Danger Button
  │                                      │
  ╰──────────────────────────────────────╯
```

**Dialog Specification:**
- Corner radius: 20px
- Background: `surface` color
- Padding: 24px
- Max width: 420px
- Icon: 40×40 in a colored container circle at top
- Title: Headline Medium, centered or left-aligned
- Body: Body Medium, `onSurfaceVariant`
- Actions: Right-aligned, Cancel (TextButton) + Action (FilledButton)
- Shadow: Level 5
- Scrim: Black @ 50%
- Enter: Scale from 0.9 → 1.0 + fade in (200ms)

### 8.7 Snackbar / Toast

```
  ┌────────────────────────────────────────────┐
  │  ✅  Party added successfully    [UNDO]    │
  └────────────────────────────────────────────┘
```

- Corner radius: 12px
- Background: `inverseSurface` (dark in light theme, light in dark theme)
- Text: `inverseOnSurface`, Body Medium
- Action: `inversePrimary` color, Label Large
- Position: Bottom, 16px above bottom nav
- Duration: 4 seconds
- Animation: Slide up from bottom + fade in

### 8.8 Navigation Components

#### Bottom Navigation Bar (Mobile)
```
┌──────────────────────────────────────────────┐
│  🏠       👥       📦      📄      ⚙️       │
│ Dashboard Parties  Products Invoices Settings │
└──────────────────────────────────────────────┘
```
- Background: `surface` color
- Height: 80px (with safe area)
- Indicator: `primaryContainer` color, 64×32px rounded pill
- Selected icon: Filled variant, `primary` color
- Unselected icon: Outlined variant, `onSurfaceVariant` @ 60%
- Selected label: 12sp, `primary`, bold
- Unselected label: 12sp, `onSurfaceVariant` @ 60%
- Elevation: Level 3 (subtle top shadow)
- Dark theme: Dark surface background, no shadow, 1px top border

#### Navigation Rail (Tablet / Web)
```
┌────────────┐
│   ┌────┐   │
│   │Logo│   │  ← App logo (40×40)
│   └────┘   │
│  GST Bill  │  ← App name (Label Small)
│            │
│  ─ ─ ─ ─  │
│            │
│  🏠 Dash   │  ← Active: primary color + indicator pill
│  👥 Party  │  ← Inactive: muted
│  📦 Items  │
│  📄 Bills  │
│            │
│  ─ ─ ─ ─  │
│            │
│  ⚙️ Setup  │  ← Bottom-aligned
│            │
└────────────┘
```
- Width: 80px (collapsed) / 240px (expanded on wide screens)
- Background: `surface` color
- Divider: 1px vertical `outline` color on the right edge
- Active indicator: `primaryContainer` pill behind icon (64×32px)
- Labels: Always visible (`NavigationRailLabelType.all`)

---

## 9. Screen Designs

### 9.1 Splash / Loading Screen

```
┌──────────────────────────────────────────┐
│                                          │
│                                          │
│                                          │
│           ┌────────────┐                 │
│           │            │                 │
│           │   📋 ₹     │                 │  ← Logo icon (animated scale-in)
│           │            │                 │
│           └────────────┘                 │
│                                          │
│       GST Billing System                 │  ← Fade in after 300ms
│  Effortless invoicing, accurate          │  ← Fade in after 500ms
│          every time.                     │
│                                          │
│          ◌ Loading...                    │  ← CircularProgressIndicator (primary)
│                                          │
│                                          │
└──────────────────────────────────────────┘
```
- Background: Subtle radial gradient from `surface` center to `surfaceVariant` edges
- Logo: Scale from 0.5 → 1.0 with bounce curve (500ms)
- Text: Staggered fade-in

### 9.2 Login Screen

```
┌──────────────────────────────────────────┐
│                                          │
│                                          │
│           ┌────────────┐                 │
│           │   📋 ₹     │                 │  ← Logo (animated)
│           └────────────┘                 │
│                                          │
│       GST Billing System                 │  ← Headline Large, Primary Dark
│  Effortless invoicing, accurate          │  ← Body Medium, muted
│          every time.                     │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │                                  │    │
│  │  📧 Email Address                │    │  ← TextFormField
│  │  ┌────────────────────────────┐  │    │
│  │  │ shopkeeper@example.com     │  │    │
│  │  └────────────────────────────┘  │    │
│  │                                  │    │
│  │  🔒 Password                     │    │
│  │  ┌────────────────────────────┐  │    │
│  │  │ ••••••••            👁     │  │    │
│  │  └────────────────────────────┘  │    │
│  │                                  │    │
│  │  [████████ SIGN IN ████████]     │    │  ← Primary filled, full width
│  │                                  │    │
│  │  ── ── ── ── OR ── ── ── ──     │    │  ← Divider with text
│  │                                  │    │
│  │  [G  Sign in with Google    ]    │    │  ← Outlined button, Google icon
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│    Don't have an account? Register       │  ← Body Small + TextButton
│                                          │
└──────────────────────────────────────────┘
```

**Key Design Details:**
- Background: Soft gradient from `surfaceVariant` to white
- Logo container: 64×64px, 20px radius, primary background, white icon, Level 2 shadow
- Form card: `surface`, 16px radius, 1px outline border, 20px internal padding
- Sign In button: Full width, 48px height, primary bg, white text
- Google button: Full width, outlined, 44px height
- Divider: Row with `─── OR ───` pattern, muted text
- Max content width: 420px (centered)
- Dark theme: Remove gradient bg, use surfaceVariant scaffold

### 9.3 Register Screen

```
┌──────────────────────────────────────────┐
│  ←  Create Account                       │  ← Surface AppBar (no primary bg)
├──────────────────────────────────────────┤
│                                          │
│  Get Started with GST Billing            │  ← Headline Medium, Primary Dark
│  Create your account to manage           │  ← Body Medium, muted
│  invoices securely                       │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  📧 Email Address *              │    │
│  │  ┌────────────────────────────┐  │    │
│  │  │ shopkeeper@example.com     │  │    │
│  │  └────────────────────────────┘  │    │
│  │                                  │    │
│  │  🔒 Password *                   │    │
│  │  ┌────────────────────────────┐  │    │
│  │  │ ••••••••            👁     │  │    │
│  │  └────────────────────────────┘  │    │
│  │  ⓘ Min 8 characters             │    │
│  │                                  │    │
│  │  🔒 Confirm Password *           │    │
│  │  ┌────────────────────────────┐  │    │
│  │  │ ••••••••                   │  │    │
│  │  └────────────────────────────┘  │    │
│  │                                  │    │
│  │  [████████ REGISTER ████████]    │    │
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│    Already have an account? Sign In      │
│                                          │
└──────────────────────────────────────────┘
```

### 9.4 Dashboard Screen

```
┌──────────────────────────────────────────┐
│                                          │  ← No traditional AppBar!
│  ┌──────────────────────────────────┐    │
│  │  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │    │  ← Gradient banner (Primary → PrimaryDark)
│  │                                  │    │
│  │  Welcome Back! 👋                │    │  ← Body Medium, white @ 90%
│  │  Apex Electronics               │    │  ← Headline Medium, white, bold
│  │  GSTIN: 24AAAAA0000A1Z5         │    │  ← Label Small, white @ 70%
│  │                                  │    │
│  │           [📄 New Bill]          │    │  ← White outlined button on gradient
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────┐  ┌──────────┐             │  ← 2×2 Stat Grid
│  │ 📊       │  │ 📅       │             │
│  │ Today    │  │ Month    │             │
│  │ ₹12,450  │  │ ₹3,45,200│             │
│  │ 5 bills  │  │ 48 bills │             │
│  └──────────┘  └──────────┘             │
│  ┌──────────┐  ┌──────────┐             │
│  │ 🏦       │  │ 📊       │             │
│  │ Tax Today│  │ Tax Month│             │
│  │ ₹2,241   │  │ ₹62,136  │             │
│  └──────────┘  └──────────┘             │
│                                          │
│  Quick Actions                           │  ← Title Small, bold
│  ┌────────┐ ┌────────┐ ┌────────┐       │
│  │ 👥     │ │ 📦     │ │ 📜     │       │  ← 3 action cards
│  │Parties │ │Products│ │History │       │
│  │12 Saved│ │8 Items │ │All Bills│       │
│  └────────┘ └────────┘ └────────┘       │
│                                          │
│  Recent Invoices           [View All →]  │  ← Title Small + TextButton
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│  ┌──┐ INV-0005 • Raj Elec    ₹11,800   │
│  │05│ 19 Sep 2026      ●Paid  CGST+SGST│
│  └──┘                                    │
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│  ┌──┐ INV-0004 • Priya Trd   ₹5,450   │
│  │04│ 19 Sep 2026      ●Paid  IGST     │
│  └──┘                                    │
│                                          │
│                           ( + Create )   │  ← FAB Extended
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │  ← Bottom Nav
└──────────────────────────────────────────┘
```

**Dashboard Design Details:**
- **No traditional colored AppBar** — instead, an inline gradient welcome banner card
- Welcome banner: Linear gradient `primary` → `primaryDark`, 16px radius, Level 2 shadow
- Stat cards: 16px radius, subtle gradient bg, animated counter on load
- Quick actions: InkWell cards with icon, title, subtitle — teal/indigo/amber accents
- Recent invoices: Clean card list with invoice number avatar, amounts right-aligned
- FAB: Extended (`+ Create Bill`), primary, bottom-right positioned
- Pull-to-refresh enabled with `RefreshIndicator`
- Staggered animation: Cards fade-slide in sequentially (100ms delay each)

### 9.5 Party List Screen

```
┌──────────────────────────────────────────┐
│  ←  Parties (Customers)                  │  ← Surface AppBar
├──────────────────────────────────────────┤
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  🔍 Search by name, mobile...    │    │  ← Search bar with shadow
│  └──────────────────────────────────┘    │
│                                          │
│  12 Customers                            │  ← Label Medium, muted, count header
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  ┌──┐  Raj Electronics      ▸   │    │
│  │  │RE│  📱 9876543210            │    │
│  │  └──┘  ┌──────────┐ ┌────────┐ │    │
│  │        │Maharashtra│ │GSTIN ✓ │ │    │  ← State badge + GSTIN indicator
│  │        └──────────┘ └────────┘ │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  ┌──┐  Priya Traders        ▸   │    │
│  │  │PT│  📱 9988776655            │    │
│  │  └──┘  ┌──────┐                 │    │
│  │        │Delhi │                 │    │
│  │        └──────┘                 │    │
│  └──────────────────────────────────┘    │
│                                          │
│                           ( + Add Party )│  ← FAB Extended
│                                          │
├──────────────────────────────────────────┤
│  🏠      👥      📦      📄      ⚙️     │
└──────────────────────────────────────────┘
```

### 9.6 Create Bill Screen (Core Workflow)

```
┌──────────────────────────────────────────┐
│  ←  Create GST Invoice                   │  ← Surface AppBar
├──────────────────────────────────────────┤
│                                          │
│  ┌──────────────────────────────────┐    │  ← Invoice header card
│  │  INV-202609-0006    19 Sep 2026  │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ① Customer / Bill To                    │  ← Step indicator with circle number
│  ┌──────────────────────────────────┐    │
│  │  [👥 Select Party]  [+ Quick Add]│    │  ← Before selection
│  └──────────────────────────────────┘    │
│  ┌──────────────────────────────────┐    │
│  │  Raj Electronics     [Change]    │    │  ← After selection
│  │  Maharashtra • ┌────────────┐    │    │
│  │  9876543210    │Intra-State │    │    │  ← Tax type badge
│  │                │(CGST+SGST) │    │    │
│  │                └────────────┘    │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ② Bill Items (2)         [+ Add Item]   │  ← Step 2 with count badge
│  ┌──────────────────────────────────┐    │
│  │  LED TV 42"              ✕       │    │  ← BillItemTile
│  │  Rate: ₹25,000   Qty: [- 1 +]   │    │
│  │  GST: 18%  │  Tax: ₹4,500       │    │
│  │  ──────────────────────────      │    │
│  │  Line Total:         ₹29,500     │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  GST SUMMARY                      │    │  ← GstSummaryCard (component)
│  │  Subtotal          ₹25,897.00    │    │
│  │  CGST               ₹2,330.73    │    │
│  │  SGST               ₹2,330.73    │    │
│  │  ═════════════════════════════   │    │
│  │  GRAND TOTAL       ₹30,558.46    │    │  ← Prominent, primary dark
│  │  (Thirty Thousand Five Hundred   │    │
│  │   Fifty Eight Rupees & 46 Paise) │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ③ Payment & Notes                       │
│  ┌──────────────────────────────────┐    │
│  │  Status: [●Paid] [Unpaid] [Part] │    │  ← ChoiceChips
│  │  Notes: ________________          │    │  ← Optional TextField
│  └──────────────────────────────────┘    │
│                                          │
│  [███ SAVE & GENERATE INVOICE ███]       │  ← Full width, 48px, primary
│                                          │
└──────────────────────────────────────────┘
```

### 9.7 Bill Detail Screen

```
┌──────────────────────────────────────────┐
│  ←  INV-202609-0005     📄 🖨️ 📤       │  ← PDF, Print, Share actions
├──────────────────────────────────────────┤
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  Invoice INV-202609-0005         │    │
│  │  Date: 19 Sep 2026              │    │
│  │  Status: ┌──────┐               │    │
│  │          │●Paid │               │    │
│  │          └──────┘               │    │
│  │  Tax Type: ┌────────────┐       │    │
│  │            │Intra-State │       │    │
│  │            │(CGST+SGST) │       │    │
│  │            └────────────┘       │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Bill To:                                │
│  ┌──────────────────────────────────┐    │
│  │  ┌──┐  Raj Electronics          │    │
│  │  │RE│  GSTIN: 27AABCR1234F1Z5   │    │
│  │  └──┘  Shop 12, Market Road     │    │
│  │        Mumbai, Maharashtra      │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Items (2)                               │
│  ┌──────────────────────────────────┐    │
│  │  1. LED TV 42"                   │    │  ← BillItemTile (read-only mode)
│  │     Rate: ₹25,000 × 1           │    │
│  │     GST 18% → ₹29,500           │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │  ← GstSummaryCard
│  │  GST SUMMARY                      │    │
│  │  GRAND TOTAL       ₹30,558.46    │    │
│  └──────────────────────────────────┘    │
│                                          │
│  [████ 📤  SHARE AS PDF ████]            │  ← Secondary filled button
│                                          │
└──────────────────────────────────────────┘
```

### 9.8 Settings / Business Profile Screen

```
┌──────────────────────────────────────────┐
│  ←  Settings                     [Save]  │
├──────────────────────────────────────────┤
│                                          │
│  Shop / Business Details                 │  ← Section header
│  ┌──────────────────────────────────┐    │
│  │  This info appears on your       │    │
│  │  generated invoices.             │    │
│  │                                  │    │
│  │  🏪 Shop Name *                  │    │
│  │  📍 Address *                    │    │
│  │  🗺️ State *                      │    │
│  │  🏷️ GSTIN *                      │    │
│  │  📱 Phone                        │    │
│  │  📧 Email                        │    │
│  │  📋 Terms & Conditions           │    │
│  └──────────────────────────────────┘    │
│                                          │
│  [████ SAVE BUSINESS PROFILE ████]       │
│                                          │
│  App Appearance                          │  ← Section header
│  ┌──────────────────────────────────┐    │
│  │  🎨 Theme Mode                   │    │
│  │  Choose your preferred appearance│    │
│  │                                  │    │
│  │  ┌────────┬────────┬────────┐    │    │
│  │  │☀ Light │🌙 Dark │⚙ Auto │    │    │  ← SegmentedButton
│  │  └────────┴────────┴────────┘    │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Account                                 │  ← Section header
│  ┌──────────────────────────────────┐    │
│  │  Signed in as: user@email.com    │    │
│  │                                  │    │
│  │  [🚪 Sign Out]                   │    │  ← Outlined danger button
│  └──────────────────────────────────┘    │
│                                          │
│  App Version 1.0.0                       │  ← Label Small, centered, muted
│                                          │
└──────────────────────────────────────────┘
```

---

## 10. Micro-Interactions & Animation Guide

### 10.1 Screen Transitions

| Transition | Animation | Duration | Curve |
|---|---|---|---|
| **Tab switch** (bottom nav) | Fade crossfade | 200ms | `easeInOut` |
| **Push navigation** | Slide left + fade | 300ms | `fastOutSlowIn` |
| **Bottom sheet** | Slide up + fade | 300ms | `decelerate` |
| **Dialog** | Scale 0.9→1.0 + fade | 200ms | `easeOut` |
| **FAB appear** | Scale 0→1 + bounce | 400ms | `elasticOut` |

### 10.2 Widget-Level Animations

| Element | Animation | Trigger | Duration |
|---|---|---|---|
| **Dashboard stat cards** | Staggered fade-slide up | Screen load | 100ms stagger, 400ms each |
| **List items** | Fade-slide from right | Data loaded | 50ms stagger, 300ms each |
| **Stat values (₹)** | Count-up animation | Screen load | 800ms, `decelerate` |
| **Status badge** | Scale-in bounce | Created | 300ms, `elasticOut` |
| **Search clear** | Fade-out + slide | Clear pressed | 200ms, `easeIn` |
| **Card tap** | Scale to 0.98 | Press down | 100ms, `easeIn` |
| **Card release** | Scale back to 1.0 | Release | 200ms, `easeOut` |
| **Delete swipe** | Slide-out + collapse | Confirmed | 300ms, `fastOutSlowIn` |
| **Empty state** | Fade-in + float icon | No data | 500ms, `easeOut` |
| **Theme toggle** | Smooth color blend | Mode changed | 300ms, built-in |

### 10.3 Loading States

| State | Visual |
|---|---|
| **Initial screen load** | Shimmer placeholders matching card layouts |
| **Button loading** | Button text replaced by small `CircularProgressIndicator` (white, 20×20, 2dp stroke) |
| **Pull to refresh** | `RefreshIndicator` with primary color spinner |
| **Data saving** | Button disabled + loading indicator + muted overlay |
| **PDF generating** | Full-screen semi-transparent overlay with progress ring |

---

## 11. Empty States

Every list/data screen must have a polished empty state:

```
┌──────────────────────────────────────────┐
│                                          │
│                                          │
│         ┌────────────────┐               │
│         │     ◯          │               │  ← 64px icon in a circle
│         │   📄           │               │     bg: primaryContainer @ 50%
│         │                │               │     icon: primary color
│         └────────────────┘               │
│                                          │
│       No invoices created yet            │  ← Title Large, onSurface
│                                          │
│     Create your first GST invoice        │  ← Body Medium, muted
│      to see it appear here.              │
│                                          │
│        [████ Create Bill ████]           │  ← Primary button (optional)
│                                          │
│                                          │
└──────────────────────────────────────────┘
```

**Empty State Specification:**
- Vertically centered in available space
- Horizontal padding: 32px each side
- Icon container: 96×96px circle, `primaryContainer` @ 50%, 64px icon in `primary`
- Title: Title Large, 600 weight, `onSurface`, centered
- Description: Body Medium, `onSurfaceVariant`, centered, max 2 lines
- Button: Optional, only when primary action available
- Animation: Fade-in + slight float-up (300ms)

---

## 12. AppBar Strategy

### Modern Surface AppBar (Preferred for Inner Screens)
Instead of the old-school colored AppBar, use a **surface-colored AppBar** that blends with the content:

```
Light Theme AppBar:
┌──────────────────────────────────────────┐
│  ←  Parties (Customers)         🔍  +   │  ← Surface bg, onSurface text
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  ← Subtle bottom border
└──────────────────────────────────────────┘

Dark Theme AppBar:
┌──────────────────────────────────────────┐
│  ←  Parties (Customers)         🔍  +   │  ← Dark surface bg, light text
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  ← Subtle bottom border
└──────────────────────────────────────────┘
```

**AppBar Specification:**
- Background: `surface` color (blends with page — NOT primary colored)
- Foreground/Text: `onSurface` color
- Elevation: 0 (flat)
- Bottom border: 1px `outlineVariant` color
- Back arrow: `onSurface` color
- Actions: IconButtons with `onSurfaceVariant` color
- Title: Headline Medium (Poppins, 20sp, 600 weight)

> **Exception:** The Dashboard screen has NO AppBar — it uses an inline gradient welcome banner instead.

---

## 13. Accessibility Guidelines

| Requirement | Standard | Implementation |
|---|---|---|
| **Min touch target** | 48×48dp | All interactive elements ≥ 48dp |
| **Color contrast** | WCAG AA (4.5:1) | All text passes AA contrast ratio |
| **Focus states** | Visible ring | 2px primary outline on keyboard focus |
| **Screen reader** | Full semantics | `Semantics` widget on all interactive elements |
| **Font scaling** | Up to 200% | No text overflow at `textScaleFactor: 2.0` |
| **Motion** | Reducible | Respect `MediaQuery.disableAnimations` |
| **Label** | Always provided | Every icon button has `tooltip` |

---

## 14. Platform-Specific Adaptations

| Feature | Android | iOS | Web |
|---|---|---|---|
| **App bar style** | Surface Material AppBar | CupertinoNavigationBar feel | Surface AppBar with breadcrumbs |
| **Date picker** | Material `showDatePicker` | `CupertinoDatePicker` in bottom sheet | Material `showDatePicker` |
| **Scrollbar** | Auto hide | Thin always-visible | Always-visible scrollbar |
| **Haptic feedback** | `HapticFeedback.lightImpact` on key actions | Same | None |
| **FAB position** | Bottom-right, above nav bar | Bottom-right, above nav bar | Bottom-right, 24px from edges |
| **Back navigation** | System back + AppBar back | AppBar back + swipe gesture | AppBar back + browser back |
| **Keyboard** | Standard | Standard | Shortcut hints (Ctrl+N = New Bill) |

---

## 15. Design Tokens Summary (for Flutter `ThemeData`)

```dart
// Usage in code:
final colorScheme = Theme.of(context).colorScheme;
final textTheme = Theme.of(context).textTheme;

// ALWAYS use theme tokens, NEVER hardcode colors:
// ✅ colorScheme.primary
// ✅ colorScheme.surface
// ✅ textTheme.headlineMedium
// ❌ Color(0xFF3F51B5)
// ❌ Colors.white
// ❌ TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
```

### Required ThemeData Configuration

```
ThemeData:
├── useMaterial3: true
├── colorScheme: (as defined in Section 3)
├── scaffoldBackgroundColor: surfaceVariant
├── textTheme: (Poppins for display/headline, Inter for body/label)
├── appBarTheme: (surface bg, 0 elevation, onSurface text)
├── cardTheme: (0 elevation, 16px radius, outline border)
├── inputDecorationTheme: (10px radius, outline border, filled)
├── navigationBarTheme: (surface bg, primaryContainer indicator)
├── elevatedButtonTheme: (0 elevation, 12px radius)
├── outlinedButtonTheme: (1.5px border, 12px radius)
├── textButtonTheme: (primary color)
├── chipTheme: (20px radius, secondary colors)
├── dialogTheme: (20px radius, surface bg)
├── bottomSheetTheme: (20px top radius)
├── snackBarTheme: (12px radius, inverseSurface bg)
├── dividerTheme: (outlineVariant color, 1px)
├── floatingActionButtonTheme: (16px radius, primary bg)
└── pageTransitionsTheme: (platform-adaptive)
```

---

## 16. File Structure for Design Implementation

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart          ← ThemeData (light + dark)
│   │   ├── app_colors.dart         ← Extended semantic colors (tax, status)
│   │   ├── app_typography.dart     ← TextTheme with Poppins + Inter
│   │   ├── app_spacing.dart        ← Spacing tokens (space_xs, space_md, etc.)
│   │   ├── app_shadows.dart        ← Shadow definitions (Level 0-5)
│   │   ├── app_radius.dart         ← Corner radius tokens
│   │   └── theme_controller.dart   ← GetX controller for theme mode
│   ├── extensions/
│   │   └── theme_extensions.dart   ← BuildContext extensions for easy access
│   └── ...
├── widgets/
│   ├── common/
│   │   ├── app_card.dart           ← Standardized card wrapper
│   │   ├── app_button.dart         ← Primary, Secondary, Danger button variants
│   │   ├── status_badge.dart       ← Paid/Unpaid/Partial badge
│   │   ├── tax_type_chip.dart      ← CGST+SGST / IGST chip
│   │   ├── section_header.dart     ← Titled section with optional action
│   │   ├── shimmer_loading.dart    ← Shimmer placeholder widgets
│   │   └── animated_counter.dart   ← Count-up animation for currency
│   ├── search_field.dart
│   ├── empty_state.dart
│   ├── gst_summary_card.dart
│   └── bill_item_tile.dart
└── ...
```

---

> **Design System Version**: 2.0
> **Last Updated**: September 2026
> **Target**: Top 1% fintech-grade UI/UX for Indian GST billing
