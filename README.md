# 📱 BillBuddies — Modern Split Manager (SwiftUI)

BillBuddies is a modern split manager application built using **SwiftUI** with a strong focus on **scalable architecture, clean code practices, and production-ready app foundations**.

Instead of only building feature screens, this project demonstrates how to structure a SwiftUI app with scalable routing, dependency injection, modular design systems, and clean architecture patterns.

> Split bills, not friendships 💸🤝

---

## Screenshots

| Home | Settings | Statistics |
| - | - | - |
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 03 44" src="https://github.com/user-attachments/assets/97edfe52-0316-4561-bf4f-85e5d6e188f0" />| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 43" src="https://github.com/user-attachments/assets/79a9c514-579d-4eba-816c-636a7f7b977e" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 40" src="https://github.com/user-attachments/assets/745244bf-8525-4579-be3c-d165d32405e7" /> |

| Onboarding | SignUp | SignIn |
| - | - | - |
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 02 51" src="https://github.com/user-attachments/assets/27c22fb0-2324-4334-ad63-f6325e7c19ee" />| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 03 26" src="https://github.com/user-attachments/assets/84b79f5a-5ebc-4bf3-956f-085b81708989" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 02 58" src="https://github.com/user-attachments/assets/c8f1b0f6-f45e-4b83-bcb6-6aee02d56245" />|

| Groups | Creating Group | Group Detail |
| - | - | - |
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 19" src="https://github.com/user-attachments/assets/f57b55ec-a298-4081-8728-cfe5143ce9a3" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 14" src="https://github.com/user-attachments/assets/86ba5448-a8e0-4f8d-8ac5-61f4ee2ae5da" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 28" src="https://github.com/user-attachments/assets/5ec7931d-919b-4db4-ad03-76c419507a3a" /> |

| Create Split | Split Details | Splits |
| - | - | - |
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 37" src="https://github.com/user-attachments/assets/2adeeb08-c086-4d53-a762-af959aed65a8" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 32" src="https://github.com/user-attachments/assets/59bb1c9d-3aca-4252-bf34-118effeedc7b" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-15 at 20 04 25" src="https://github.com/user-attachments/assets/3b38ac2e-f9d6-4b12-98b7-defff9dde0d0" /> |


---


## ✨ Features

- 🔐 Onboarding, Sign Up & Sign In flow  
- 👥 Create and manage split groups  
- ➕ Add members to groups  
- 💰 Flexible expense splitting  
- 🧾 Recent split tracking  
- 📂 Organized group listing  
- 🔄 Full CRUD flows across major entities  
- 🧭 Scalable navigation & routing system  
- 🎨 Consistent UI via Design System  

---

## 🎯 Project Goals

This project was built to demonstrate:

- How to structure a large SwiftUI app
- Clean Architecture with MVVM
- Scalable navigation & routing patterns
- Dependency Injection in SwiftUI
- Modular UI design systems
- Production-style networking & logging
- Modern Swift Concurrency usage

Focus was placed on **engineering quality and scalability** over feature quantity.

---

## 🧱 Architecture

The app follows:

**MVVM + Clean Architecture**

This keeps business logic, UI, and data layers clearly separated and easier to scale.

### Layered Structure

<img width="1536" height="1024" alt="architecture" src="https://github.com/user-attachments/assets/a06b4b16-25a4-416b-ad8d-0e708e67a769" />

### Benefits

- Better testability  
- Easier refactoring  
- Feature isolation  
- Clear dependency direction  
- Scalable module growth  

---

## 🧭 Routing System

BillBuddies includes a scalable routing layer designed for complex apps.

Supports:

- Push navigation
- Modal presentation
- Sheets
- Full screen covers
- Nested routing inside tab flows
- Centralized route definitions
- Navigation decoupled from views

---

## 🎨 Design System

A reusable design system ensures visual and structural consistency:

- Typography tokens
- Color palette
- Spacing system
- Reusable UI components
- Shared style modifiers
- Centralized theme control

---

## 🧩 Dependency Injection

Dependency Injection is used across the app to:

- Reduce coupling
- Improve testability
- Enable easier mocking
- Allow service swapping
- Support scalable module design

Dependencies are injected into ViewModels and UseCases instead of being created directly.

---

## 🌐 Networking Layer

Includes a structured networking layer with:

- Request abstraction
- Decodable response mapping
- Error handling
- Async/await support
- Extendable endpoint definitions

Designed to scale as API surface grows.

---

## ⚡ Concurrency

Modern Swift Concurrency is used throughout:

- async / await
- MainActor UI updates
- Structured background work
- Safer async flows

---

## 🪵 Logging

Production-style logging support included:

- Structured logs
- Debug tracing
- Flow tracking
- Easier issue diagnosis

## ⚙️ CI / CD (GitHub Actions)

CI/CD pipelines were configured using **GitHub Actions** to automate:

- Project build on each push / pull request
- Automated test execution
- Continuous validation of code health
- Early failure detection

This ensures safer merges and consistent build verification — similar to production team workflows.

> Note: The pipeline is currently disabled to avoid unnecessary CI usage costs on a personal project, but the workflow configuration is included in the repository for reference and reuse.

---

## 📦 Tech Stack

- SwiftUI
- MVVM
- Clean Architecture
- Swift Concurrency
- Dependency Injection
- Modular Design System
- Custom Routing Layer
- Structured Networking Layer

---

## 🚧 Planned / Future Enhancements

- Offline-first support using SwiftData
- Settlement & balance engine
- Backend-driven calculations
- Sync & conflict resolution demo
- Unit test coverage
- Snapshot tests
- Widget support

(Some backend-heavy features were intentionally scoped out to focus on client architecture and scalable systems.)

---

## 👨‍💻Author

Author: Ritesh Khore

LinkedIn: https://www.linkedin.com/in/ritesh-khore/

## ⭐ Show Your Support
If you like this project, please consider:

- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting features
- 🔀 Contributing code
