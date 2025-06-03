# 📝 Blogsy – A Flutter-Powered Blog Application

**Blogsy** is a beautifully crafted blog application built with **Flutter**, leveraging **Supabase** for backend services, **Hive** for local storage, and **BLoC** for scalable state management. It offers a clean, tabbed UI for browsing, creating, deleting, and bookmarking blogs. Blogsy is designed with clean architecture principles, ensuring a modular, maintainable, and testable codebase.

---

## 🔐 Key Features

- 📝 **Create & Manage Blogs** – Add and delete your own blog posts  
- 📖 **View Blogs** – Explore trending blogs and filter by topic with a tabbed UI  
- 🔖 **Local Bookmarks** – Save blogs offline using Hive  
- 🔐 **Authentication** – Sign up, log in, and log out using Supabase Auth  
- ⚙️ **Shared Preferences** – Session management and persistent login  
- 💡 **Clean Architecture** – Modular folder structure and scalable logic using BLoC pattern  
- 📱 **Responsive UI** – Beautiful Flutter UI with topic-based navigation  

---

## 🏗️ System Architecture

```
lib/
├── core/              # Constants, shared widgets, helpers
├── data/              # Data sources and repositories
│   ├── datasources/   # Supabase and Hive integration
│   ├── models/        # Blog models and serialization
│   └── repositories/  # Concrete implementations
├── domain/            # Entities and abstract repositories
│   ├── entities/      # Core business models
│   └── repositories/  # Interfaces for data access
├── application/       # BLoCs, Cubits, UseCases
├── presentation/      # UI widgets and pages
└── main.dart          # App entry point
```

---

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter SDK (3.x recommended)
- Dart SDK
- Supabase project with Auth and Tables configured
- Hive (used automatically within the app)
- Android/iOS emulator or device

---

## 🔧 Setup Instructions

1. **Clone the Repository**
```bash
git clone https://github.com/yourusername/blogsy.git
cd blogsy
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Run the App**
```bash
flutter run
```

4. **(Optional) Run on specific device**
```bash
flutter devices
flutter run -d <device_id>
```

---

## 📦 Technologies Used

| Layer             | Technologies                               |
|------------------|--------------------------------------------|
| State Management | flutter_bloc, equatable                    |
| Backend          | Supabase (Auth + Realtime Database)        |
| Local Storage    | Hive, Hive Flutter                         |
| Persistence      | shared_preferences                         |
| Dependency Inj.  | get_it                                     |
| UI/UX            | Flutter, TabBar, Custom Widgets            |

---

## 📸 Screenshots

![Home Screen](screenshots/home.png)  
![Create Blog](screenshots/create_blog.png)  
![Bookmarks](screenshots/bookmarks.png)

> 📁 Add screenshots to a `/screenshots` folder and update filenames if needed.

---

## ✨ App Features In Detail

### 🔐 Authentication
- Sign up, log in, and log out using Supabase Auth
- Sessions persisted with `shared_preferences`

### 📝 Blog Management
- Create blogs with title, content, and topic
- Delete only your own blogs
- See all blogs or filter by topic using tabs

### 🔖 Bookmark System
- Store favorite blogs offline using Hive
- No internet required to view bookmarks

---

## 📚 Future Improvements

- Blog editing functionality
- Search and sort blogs by date or title
- Rich text editor for blog creation
- Profile management and avatars
- Unit & widget testing integration

---

## 📄 License

This project is licensed under the MIT License.  
Feel free to contribute, fork, or report issues!

---

## 🙌 Acknowledgements

- [Supabase](https://supabase.io)
- [Hive](https://docs.hivedb.dev)
- [Flutter Bloc](https://bloclibrary.dev)
- [GetIt](https://pub.dev/packages/get_it)

---

> 🚀 *Blogsy is built to be clean, fast, and developer-friendly. A perfect foundation for your next blogging platform or Flutter portfolio project.*
