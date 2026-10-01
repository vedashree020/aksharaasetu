# AksharaSetu

### AI-Powered Vernacular Learning and Translation Platform

AksharaSetu is an offline-first Android application designed to support **mother-tongue-based primary education** by helping teachers deliver learning content in tribal languages.

The project focuses on making Hindi-based educational content more accessible through translation and vernacular learning support for languages such as **Santali, Ho, and Mundari**.

## 🎯 Problem Statement

Many primary-school teachers in tribal areas use Hindi-medium curriculum materials while students are more comfortable learning in their mother tongue.

AksharaSetu aims to bridge this language gap by providing teachers with tools to work with educational content in both **Hindi and tribal languages**.

## 🚀 Main Features

* **Hindi ↔ Tribal Language Translation**

  * Translate educational content between Hindi and supported tribal languages.

* **Lesson Translation Workspace**

  * Teachers can work with curriculum lessons and translated content.

* **Vernacular Learning Content**

  * Support learning material in the student's familiar language.

* **Worksheets**

  * Provide educational worksheets based on lesson content.

* **Audio / Pronunciation Support**

  * Support audio-based learning and pronunciation assistance.

* **Teacher & Admin**

  * Teacher interface for educational activities.
  * Admin interface for monitoring participating schools.

## 🏗️ Technology Stack

### Frontend

* Flutter
* Dart
* Material Design

### Backend

* Python
* FastAPI

### AI / Language Technologies

* IndicTrans2
* AI4Bharat
* Adivaani / NLP technologies

### Local Storage

* SQLite

## 📱 Platform

* Android
* Designed with offline-first usage in mind
* Target environment includes low-resource Android tablets

## 📂 Project Structure

```text
aksharaasetu/
│
├── android/              # Android application configuration
├── assets/               # Images and other application assets
├── backend/              # FastAPI backend
├── lib/                  # Flutter/Dart application source
│   ├── screens/          # Application screens
│   ├── widgets/          # Reusable UI components
│   └── ...
├── test/                 # Flutter tests
├── pubspec.yaml          # Flutter dependencies
├── pubspec.lock          # Locked dependency versions
├── .gitignore            # Git ignored files
└── README.md             # Project documentation
```

## ⚙️ Getting Started

### Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Android Studio / Android SDK
* VS Code or another Flutter-compatible IDE
* Python 3.x for the backend

### Check Flutter Installation

```bash
flutter doctor
```

### Run the Flutter Application

Clone the repository:

```bash
git clone <your-repository-url>
```

Enter the project:

```bash
cd aksharaasetu
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 🔧 Backend

The backend code is located inside:

```text
backend/
```

Backend dependencies and setup instructions will be maintained inside the backend directory as the implementation develops.

## 🌐 Language Support

The project is designed around mother-tongue-based learning and can support languages including:

| Language | Direction |
| -------- | --------- |
| Hindi    | ↔         |
| Santali  | ↔         |
| Ho       | ↔         |
| Mundari  | ↔         |

Language availability depends on the implemented translation models and APIs.

## 🔒 Offline-First Approach

AksharaSetu is designed for environments where reliable internet connectivity may not always be available.

The application architecture aims to minimize device resource usage by keeping frequently required educational content available locally while using backend/AI services when required.

## 🎓 Intended Users

### Teachers

Teachers can use AksharaSetu to:

* Access curriculum content
* Translate lessons
* Use vernacular learning material
* Work with worksheets
* Access audio/pronunciation support

### Administrators

Administrators can monitor participating schools and related project activity.

## 🏆 Project Context

AksharaSetu is being developed as a prototype for **Smart India Hackathon 2026** under the relevant vernacular and mother-tongue-based education problem statement.

## 📌 Project Status

🚧 **Currently under development**

The application, backend services, language models, and offline capabilities are being developed and tested incrementally.

## 👩‍💻 Development

Built using Flutter, Dart, Python, and AI/NLP technologies with a focus on accessible vernacular education.

## 📄 License

This project is currently under development. Licensing information will be added when the project is finalized.

````

### What you should do now

1. Open `C:\AksharSetu`
2. Open `README.md`
3. **Delete the existing Flutter README completely**
4. Paste the README above
5. Save with **Ctrl + S**
6. Run:

```powershell
git status
````

Then we can do the **first Git commit** safely.
