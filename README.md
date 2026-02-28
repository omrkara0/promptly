# 🚀 Promptly - AI Prompt Optimizer

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white)

Promptly is an elegant, highly responsive Flutter application designed to transform your basic thoughts and raw inputs into **perfectly engineered, high-quality AI prompts** in seconds. Powered by Google's Gemini API, Promptly ensures you get the best possible results from any LLM (ChatGPT, Claude, Gemini, etc.).

## ✨ Features

*   **🧠 AI-Powered Enhancement:** Uses `gemini-3-flash` to instantly turn simple sentences into detailed, structured, and highly effective prompts.
*   **🎭 Tone Selection:** Customize the style of your generated prompt. Choose from:
    *   📝 **Detailed:** For comprehensive and strictly structured outputs.
    *   📏 **Concise:** For short, direct, and to-the-point outputs.
    *   💡 **Creative:** For out-of-the-box, imaginative, and storytelling-focused outputs.
*   **🌍 Universal Output (English First):** No matter what language you type in (e.g., Turkish, Spanish, French), Promptly's AI engine meticulously translates and optimizes your prompt entirely in **English** for maximum compatibility with all global LLMs.
*   **🇹🇷 / 🇬🇧 Bilingual UI:** The app interface seamlessly switches between English and Turkish with a single tap.
*   **🕰️ Local History:** All your generated prompts are securely saved locally using **Hive** database. Never lose a brilliant idea! Swipe-to-delete support included.
*   **🎨 Premium UI / UX:** Features a modern, sleek Dark Mode design inspired by glassmorphism, with dynamic animations and pill-shaped aesthetics.
*   **📤 Direct Actions:** 1-Click copy to clipboard or send directly to ChatGPT / Gemini apps via URL launchers.

## 📸 Screenshots
<img width="1080" height="2424" alt="Screenshot_1772305312" src="https://github.com/user-attachments/assets/2291768f-6b1f-4fae-b72d-6b2385399e1d" />

<img width="1080" height="2424" alt="Screenshot_1772305473" src="https://github.com/user-attachments/assets/9a9ef9dd-3e2d-4ef4-92ff-1cb83ec26222" />

<img width="1080" height="2424" alt="Screenshot_1772305476" src="https://github.com/user-attachments/assets/dcbff9ac-f54b-4239-9dbb-7c71ef0abac6" />

## 🛠️ Tech Stack & Architecture

*   **Framework:** Flutter (Dart)
*   **State Management:** Provider
*   **Local Storage/Database:** Hive (NoSQL)
*   **AI Engine:** Google Generative AI (Gemini)
*   **Architecture:** Clean Code principles with separated logic (Services, Providers, Models, Screens).

## 🚀 Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yourusername/promptly.git
```
2. Install dependencies:
```bash
flutter pub get
```
3. Add your Gemini API Key:
Create a `.env` file in the root directory and add your key:
```env
GEMINI_API_KEY=your_api_key_here
```
4. Run the app:
```bash
flutter run
```

## 🔒 Security Note
The `.env` file containing the API key is strictly ignored via `.gitignore` to prevent secret leaks. Please supply your own key to test the application locally.
