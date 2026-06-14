# Student Information Management Application (SIMA)

A mobile application designed to register, manage, and view student records efficiently. The system is built with a modern mobile frontend that communicates securely via a PHP backend API to a MySQL database.

---

## 🚀 Features

* **Interactive User Interface:** Clean, Material Design layout built with Flutter, featuring responsive text fields, structural icons, and explicit buttons.
* **Strict Frontend Validation:** Real-time client-side checks ensuring all fields are filled, alongside regular expression (Regex) pattern matching to enforce valid roll numbers and email addresses.
* **Smart Backend Integrity:** Server-side database validation preventing duplicate record entries for both unique Roll Numbers and Email IDs.

---

## 🛠️ System Architecture & Tech Stack

The application relies on a classic 3-tier decoupling architecture:

* **Frontend:** Flutter (Dart) — Handles client state and asynchronously fetches server data.
* **Backend API:** PHP — Serves as the middle REST API layer, validating database constraints, and outputting JSON objects.
* **Database:** MySQL — The database layer structured with data types (VARCHAR, FLOAT) using the student's Roll Number as the Primary Key.

---

## 📂 Project Repository File Structure

The project relies on these core architectural files:

* `main.dart` — The complete Flutter frontend ecosystem containing stateful form inputs, regex validators and automated snackbar messaging alerts.
* `sima_db.php` — Configures remote server connection configurations, resolves resource requests, and automatically initializes the database (`student_db`) and table (`student_info`) if missing.
* `register_student.php` — Parses incoming frontend `POST` requests, checks for unique duplicate records, writes student data into the table, and reports precise success/error status back to the app.
* `retrieve_data.php` — Executes `SELECT` queries on the MySQL table to convert raw database arrays into JSON structures for application decoding.

---

## ⚙️ Local Installation & Setup

Follow these steps to configure your local server environment and execute the application:

### 1. Prerequisites
* Ensure you have the **Flutter SDK** installed and configured on your machine.
* Install a local PHP/MySQL stack server environment (such as **XAMPP**).

### 2. Backend & Database Setup
1. Start your local server's **Apache** and **MySQL** services.
2. Locate your server's root web directory (usually `htdocs` for XAMPP).
3. Place the backend scripts (`sima_db.php`, `register_student.php`, and `retrieve_data.php`) directly into that root folder.
4. Your server will now naturally host the backend entry point at `http://localhost/`.

### 3. Flutter Client Configuration
1. Open the Flutter project folder inside your preferred code editor (VS Code / Android Studio).
2. Note that the application uses the loopback IP `10.0.2.2` within `main.dart` to communicate directly with your computer's localhost endpoints from within an Android Emulator environment.
3. If you want to run the application on web based emulator then change the URL to `http://localhost/`.
4. Open a terminal inside the project directory and pull down all necessary application dependencies:
```bash
   flutter pub get