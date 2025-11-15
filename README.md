# RAFEEQ

RAFEEQ - Student housing, services, wallet, and student-to-student market platform.

## Description

RAFEEQ is a comprehensive Flutter application designed for students, providing:
- **Student Housing**: Find and list housing options near the university
- **Services**: Access various student services
- **Wallet**: Digital wallet functionality for transactions
- **Student Market**: Buy and sell products between students
- **Chat**: Communication features for users
- **Multi-language Support**: English and Arabic (RTL support)

## Features

- 🏠 Housing listings and management
- 💼 Service provider features
- 💰 Digital wallet with card management
- 🛒 Student-to-student marketplace
- 💬 In-app messaging
- 🌐 Multi-language support (English/Arabic)
- 🎨 Modern Material Design UI
- 🌓 Dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd rafeeq
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For Android
flutter run

# For iOS
flutter run
```

## Project Structure

```
lib/
├── core/           # Core functionality (providers, theme, utils)
├── features/        # Feature modules (market, chat)
├── screens/         # App screens
└── main.dart        # App entry point
```

## Technologies Used

- Flutter
- Provider (State Management)
- Firebase (Optional - currently disabled)
- SharedPreferences (Local storage)
- Material Design 3

## License

This project is private and proprietary.

## Team Collaboration

This project uses Git and GitHub for version control. For detailed collaboration instructions, see [CONTRIBUTING.md](CONTRIBUTING.md).

### Quick Start for Team Members

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/rafeeq.git
   cd rafeeq
   flutter pub get
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make changes, commit, and push:**
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request on GitHub** for code review

### Branch Protection

- The `main` branch is protected
- All changes must go through Pull Requests
- Code review required before merging

## Contact

For more information, visit: https://rafeeq.asu.edu.jo
