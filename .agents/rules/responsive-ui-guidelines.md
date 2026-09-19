# Platform-Specific Responsive UI Guidelines

Make the entire UI **responsive, adaptive, and platform-appropriate** across **Android, iOS, Web, macOS, Windows, mobile, tablet, laptop, desktop, and large/ultra-wide screens**.

- **Android:** Use modern Android-style mobile UI, touch-friendly controls, appropriate app bars, navigation, dialogs, sheets, and gestures.
- **iOS:** Use iOS-style navigation, spacing, controls, sheets, gestures, and touch interactions.
- **Web:** Use a professional website-style UI with responsive layouts, wider content areas, hover states, mouse interactions, keyboard navigation, and web-appropriate navigation.
- **Windows:** Use a modern desktop UI with sidebar/navigation, resizable layouts, hover/focus states, mouse and keyboard interactions, and efficient large-screen space usage.
- **macOS:** Use a polished macOS-style desktop UI with spacious layouts, sidebar navigation, window resizing, mouse/trackpad interactions, and keyboard shortcuts.
- **Tablet:** Use an adaptive layout between mobile and desktop, utilizing the available screen space effectively.
- **Desktop:** Prefer desktop layouts and avoid mobile-style layouts unless the window becomes narrow.

### Responsive Behavior

- Dynamically adapt **text size, line height, spacing, margin, padding, icon size, button size, card dimensions, and other UI properties** based on available space.
- Adapt columns, rows, navigation, forms, cards, dialogs, tables, charts, and content density according to screen/window size.
- Use flexible, intrinsic, relative, and content-aware sizing instead of unnecessary fixed dimensions.
- Support portrait, landscape, window resizing, keyboard/IME, touch, mouse, and keyboard input where applicable.
- Prevent overflow, clipping, overlapping, broken alignment, and unusable controls.
- Preserve existing branding, functionality, data, navigation purpose, and user flow.
- Reuse shared components, controllers, services, repositories, and business logic.
- Avoid duplicated screens, magic numbers, device-specific hacks, and unnecessary abstractions.
- Test small, medium, large, and unusual/intermediate screen sizes on each supported platform.

### Core Rule

**Same product, same functionality, and same purpose — but the UI, layout, controls, and interactions should naturally adapt to each platform and available screen space.**