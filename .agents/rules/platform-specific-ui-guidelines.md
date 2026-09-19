# Platform-Specific UI Guidelines

Design the UI according to the conventions and interaction patterns of each platform while keeping the **same functionality, purpose, data, and user flow**.

- **Android:** Use a modern Android-app style UI with mobile-first layouts, app bars, bottom navigation where appropriate, touch-friendly controls, Android-style dialogs, sheets, and navigation patterns.
- **iOS:** Use an iOS-style UI with clean spacing, native-feeling navigation, appropriate navigation bars, sheets, gestures, controls, and touch interactions.
- **Web:** Use a professional website-style UI with responsive layouts, wider content areas, web navigation, hover states, mouse interactions, keyboard navigation, and appropriate desktop/web components.
- **Windows:** Use a modern Windows desktop-style UI with sidebar/navigation rail, desktop layouts, mouse/keyboard interactions, hover/focus states, resizable windows, and efficient use of large screens.
- **macOS:** Use a polished macOS-style desktop UI with spacious layouts, sidebar navigation, desktop window behavior, mouse/trackpad interactions, keyboard shortcuts, and macOS-friendly controls.
- **Desktop:** Use available screen space effectively and avoid mobile-style layouts unless the window becomes narrow.
- **Tablet:** Use an adaptive layout between mobile and desktop, taking advantage of the larger screen.

### Consistency Rule

Platform-specific UI should **look and feel native to the platform**, but:

- Functionality must remain the same.
- Features must remain the same.
- Data and business logic must remain the same.
- Navigation purpose and user flow must remain consistent.
- Do not create completely different products for different platforms.
- Reuse the same controllers, services, repositories, models, and business logic.
- Only adapt **UI, layout, navigation presentation, controls, spacing, and interaction patterns** when required by the platform.

**Core Rule:** Same product and functionality — platform-appropriate UI and experience.