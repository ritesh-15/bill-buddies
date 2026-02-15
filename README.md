# 📱 BillBuddies — Modern Split Manager (SwiftUI)

BillBuddies is a modern split manager application built using **SwiftUI** with a strong focus on **scalable architecture, clean code practices, and production-ready app foundations**.

Instead of only building feature screens, this project demonstrates how to structure a SwiftUI app with scalable routing, dependency injection, modular design systems, and clean architecture patterns.

> Split bills, not friendships 💸🤝

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