# Project Architecture & File/Folder Structure Guidelines

Use a clean, scalable, logical, predictable, and maintainable Flutter project structure.

## Core Rules

- Organize files by feature or responsibility.
- Keep related files together.
- Separate UI, state management, business logic, data access, services, models, middleware, routing, and configuration.
- Keep each file focused on a single responsibility.
- Avoid unnecessarily large files.
- Avoid deeply nested folders unless there is a clear benefit.
- Use consistent and meaningful file and folder names.
- Follow standard Dart and Flutter naming conventions.
- Create reusable components in appropriate shared/common folders.
- Keep API, Firebase, database, and storage logic separate from UI code.
- Keep models and data classes separate from business logic.
- Avoid duplicate files and duplicate implementations.
- Do not create unnecessary folders or files.
- Reuse existing files, widgets, services, repositories, and utilities whenever possible.
- Before creating a new file, check whether an existing file can be reused or extended.
- Do not create a new abstraction unless it provides a clear practical benefit.
- Keep configuration and environment-related files separate from application logic.
- Do not reorganize the entire project unnecessarily when adding a feature.
- Place new feature files in the appropriate architectural layer.
- Maintain the same architecture consistently throughout the project.
