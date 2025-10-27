# practical_social_media

A demo **social media-style application** built using **Clean Architecture** and **BLoC (
flutter_bloc)** for state management.  
This project demonstrates Firebase Authentication, Firestore integration, Pagination, Post
Filtering, and Logout functionality — all structured with scalable repository and service layers.

## How to run application

flutter clean
flutter pub get
flutter run

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
    - `AuthCubit`: Handles Signup, Login, and Logout logic
    - `PostCubit`: Handles fetching, adding, and filtering posts

## 📦 Packages Used

- **flutter_bloc** : For state management and handling business logic
- **firebase_core** : For initializing Firebase in the Flutter project
- **firebase_auth** : For Firebase authentication (login/signup)
- **cloud_firestore** : For storing and fetching posts and user data in Firestore
- **get** : For routing and dependency management
- **flutter_overlay_loader** : For showing loading overlays during network operations
- **loading_indicator** : For displaying custom loading animations
- **fluttertoast** : For showing toast messages for success or error feedback
- **pull_to_refresh** : For pull-down refresh feature on posts list
- **intl** : For date and time formatting (e.g., post timestamps)