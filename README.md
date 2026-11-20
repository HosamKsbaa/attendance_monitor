# Attendance Monitor (Flutter + Firebase + QR Code)

A cross-platform **Flutter** mobile & web application for university/classroom attendance tracking using **Firebase Authentication**, **Cloud Firestore**, and **QR Code** check-ins.

---

## Features

### Teacher Flow (`lib/Teacher/`)
- Create and manage courses (`Add_Course.dart`, `CourseDetailsPage.dart`)
- Create lectures and generate lecture-specific QR codes (`AddLecturePage.dart`, `LectureDetailsPage.dart`)
- View real-time student attendance lists (`StudentListPage.dart`)

### Student Flow (`lib/Student /`)
- Sign in via Google / Firebase Auth (`sign_in.dart`, `UserDataEntryPage.dart`)
- Join lectures and view lecture attendance details (`Student.dart`, `LectureDetailsPage_student.dart`)

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **Backend / Auth:** Firebase Core, Firebase Auth, Firebase UI Auth, Google Sign-In, Firebase App Check
- **Database:** Cloud Firestore
- **State Management:** Provider + SharedPreferences
- **QR Generation:** `qr_flutter`
- **Observability:** Firebase Analytics & Firebase Performance

---

## Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```
2. **Configure Firebase:**
   Ensure `lib/firebase_options.dart` and your platform Firebase configs (`google-services.json` / `GoogleService-Info.plist`) are linked to your Firebase project.
3. **Run the app:**
   ```bash
   flutter run
   ```
