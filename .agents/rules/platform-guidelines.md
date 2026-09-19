# Platform Guidelines

This document defines the platform-specific rules for the Flutter application.

## 1. Platforms

The application must be designed and maintained for:

- Android
- iOS
- Web
- 
All platform-specific implementation must follow these guidelines.

## 2. Firebase Authentication

| Method | Android | iOS | Web |
|---|---|---|---|---|---|
| Email + Password | ✅ | ✅ | ✅
| Google Sign-In | ✅ | ✅ | ✅

**Notes:**
- Email + Password authentication is supported on **all platforms**.
- Google Sign-In is supported only on **Android, iOS, and Web**.
## 3. Technology

**Stack:**
- Flutter
- Dart
- GetX
- Middleware
- Bindings
- Controllers
- Routes
- SharedPreferences
- API

**Database by Platform:**

| Platform | Database |
|---|---|
| Android | SQLite |
| iOS | SQLite |
| Web | IndexedDB |

**Notes:**
- Use SQLite on Android,and iOS.
- Use IndexedDB on Web.