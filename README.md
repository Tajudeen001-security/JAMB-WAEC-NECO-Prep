# JAMB-WAEC-NECO-Prep

**Android CBT Practice App for Nigerian Students**

Prepare for **JAMB (UTME)**, **WAEC (WASSCE)**, and **NECO** with thousands of past questions, realistic timed CBT interface, and progress tracking.

## Features

- **Multi-Exam Support**: JAMB/UTME, WAEC/WASSCE, NECO
- **Subject Coverage**: English, Mathematics, Physics, Chemistry, Biology, Economics, Government, Literature, and more (17+ subjects)
- **Year Filtering**: Practice by specific years (where available via API)
- **CBT Mode**: Exam-like interface with timer, question navigator, flagging
- **Practice Modes**:
  - Quick Practice (random questions)
  - Full Mock Exam (timed, scored like real exam)
  - Study Mode (immediate feedback + explanations when available)
- **Progress Tracking**: Local history of scores and weak areas
- **Offline-Friendly**: Caches questions after first fetch
- **Modern UI**: Material Design 3 with clean, student-friendly interface

## Powered by ALOC Past Questions API

This app uses the free [ALOC Questions API](https://questions.aloc.com.ng/) which provides access to 6,000+ past questions spanning multiple years.

> **Note**: You need a free Access Token from https://questions.aloc.com.ng (sign up → dashboard). Place it in `lib/config/api_config.dart`.

## Getting Started

### Prerequisites
- Flutter SDK (3.16+)
- Android Studio / VS Code with Flutter extensions
- Free ALOC Access Token

### Setup

1. Clone the repo:
```bash
git clone https://github.com/Tajudeen001-security/JAMB-WAEC-NECO-Prep.git
cd JAMB-WAEC-NECO-Prep
```

2. Get your free API token from [questions.aloc.com.ng](https://questions.aloc.com.ng) and update:
```dart
// lib/config/api_config.dart
const String alocAccessToken = 'YOUR_ALOC_TOKEN_HERE';
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run on device/emulator:
```bash
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```
The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## GitHub Actions Workflow

A workflow is included under `.github/workflows/build-apk.yml` that automatically builds a release APK on every push to `main`. You can download the artifact from the Actions tab.

To enable:
1. Go to repo Settings → Actions → General → allow workflows
2. Push any change to trigger the build

## Project Structure

```
lib/
├── main.dart
├── config/
│   └── api_config.dart
├── models/
│   └── question.dart
├── services/
│   ├── aloc_api_service.dart
│   └── progress_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── subject_screen.dart
│   ├── setup_screen.dart
│   ├── quiz_screen.dart
│   └── result_screen.dart
├── widgets/
│   ├── question_card.dart
│   ├── option_tile.dart
│   └── timer_widget.dart
└── utils/
    └── constants.dart
```

## Supported Subjects (ALOC)

english, mathematics, commerce, accounting, biology, physics, chemistry, englishlit, government, crk, geography, economics, irk, civiledu, insurance, currentaffairs, history

## Exam Types

- `utme` → JAMB
- `wassce` → WAEC
- `neco` → NECO (limited coverage)
- `post-utme` → Post-UTME (limited)

## Roadmap / Future Improvements

- [ ] Offline question bank download
- [ ] Detailed explanations & AI tutor
- [ ] Leaderboard / community challenges
- [ ] Syllabus topic mapping
- [ ] Dark mode & accessibility improvements
- [ ] iOS support

## Disclaimer

Past questions are sourced from the public ALOC API. This app is for educational practice only. Always cross-check with official materials. Not affiliated with JAMB, WAEC, or NECO.

## License

MIT License – feel free to fork and improve for Nigerian students.

---

Built with ❤️ for Nigerian students preparing for national exams.
