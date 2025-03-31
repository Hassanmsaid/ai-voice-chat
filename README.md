# ai_chat_app

AI Flutter Chat App

# 🚀 AI Chat App Setup Guide

## 📌 Prerequisites
Ensure you have the following installed before proceeding:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart) (included with Flutter)
- Android Studio / VS Code (with Flutter & Dart plugins)
- A device or emulator (Android/iOS)

---

## 📥 Installation

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/Hassanmsaid/ai-voice-chat.git
cd ai_chat_app
```

### 2️⃣ Install Dependencies
```sh
flutter pub get
```

### 3️⃣ Run the App
For **Android/iOS**:
```sh
flutter run
```

---

## 🔧 Configuration

In order to run the app smoothly environment variables, create a `.env` file in the root directory of the project to be able to use Hugging Face API:
```sh
touch .env
```
Add your API keys:
```
HUGGINGFACE_API_KEY=your_api_key_here
```
Then, include `.env` in `.gitignore` to keep it secure:
```
.env
```

---

## 🛠️ Common Issues & Fixes

1️⃣ **Flutter Not Found?**  
Ensure Flutter is added to your system path:
```sh
flutter doctor
```

2️⃣ **Dependencies Not Found?**  
Run:
```sh
flutter clean && flutter pub get
```

3️⃣ **App Crashes on iOS?**  
Run:
```sh
cd ios
pod install
cd ..
flutter run
```

---


