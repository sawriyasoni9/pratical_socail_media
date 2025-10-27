# practical_social_media

A demo **social media-style application** built using **Clean Architecture** and **BLoC (flutter_bloc)** for state management.  
This project demonstrates Firebase Authentication, Firestore integration, Pagination, Post Filtering, and Logout functionality — all structured with scalable repository and service layers.


## 🚀 Features

### 🔐 Authentication
- **User Signup:** Create a new account with Firebase Authentication.
- **User Login:** Sign in securely using FirebaseAuth.
- **Logout:** Sign out users and clear session data.

### 📝 Posts
- **Add New Post:** Users can create and upload text posts to Firestore.
- **List All Posts:** Displays all posts in a paginated Firestore stream.
- **Post Filtering:** Filter posts by “All Posts”, “My Posts”,.
- **Real-time Updates:** Firestore stream keeps the feed always live.

## 🧱 Project Architecture
The app follows **Clean Architecture** principles:

## 🧠 State Management

- **flutter_bloc**
    - `TaskCubit`: Handles load, delete, toggle, filter operations
    - `AddEditTaskCubit`: Handles add and edit logic
---

## 🗃️ Local Storage & Persistence

- **Firebase**
    - Used as SQLite ORM for storing task data
    - Abstracted via `TaskRepository` for clean architecture

- **sqflite**
    - Underlying database engine used by Floor
