# Light & Dark Mode Guidelines

Implement production-ready **Light Mode, Dark Mode, and System Mode** across **Android, iOS, Web, macOS, and Windows**.

- Preserve the existing UI, branding, layout, navigation, functionality, and user flow.
- Make all screens and components fully theme-aware.
- Avoid unnecessary hardcoded colors; use centralized theme values.
- Ensure proper contrast, readability, accessibility, and visual hierarchy.
- Theme backgrounds, surfaces, cards, text, icons, buttons, inputs, borders, dividers, navigation, dialogs, bottom sheets, switches, checkboxes, progress indicators, charts, images, and UI states.
- System Mode must follow the operating system theme on every supported platform.
- Persist the selected theme using the existing persistence architecture.
- Apply theme changes instantly without restarting the app.
- Reuse existing components and follow the existing **GetX architecture**.
- Do not create duplicate screens, unnecessary packages, files, or abstractions.
- Test Light, Dark, and System modes across mobile, tablet, web, and desktop layouts.

**Core Rule:** Add theming without redesigning or changing the existing product.