# JAMB-WAEC-NECO-Prep

**Android CBT Practice App for Nigerian Students**  
**by JagX & JRILICENSE**

Prepare for **JAMB (UTME)**, **WAEC (WASSCE)**, **NECO** and **Post-UTME** with thousands of past questions, realistic timed CBT interface, progress tracking, and full JAMB-style mock exams.

## Features

- **Multi-Exam Support**: JAMB/UTME, WAEC/WASSCE, NECO, Post-UTME
- **Subject Coverage**: English, Mathematics, Physics, Chemistry, Biology, Economics, Government, Literature, Geography, Commerce, Accounting, CRK, IRK, Civic Education, History, Current Affairs, Insurance (17+ subjects)
- **JAMB Mock Mode (Real Style)**:
  - English Language is **compulsory** (always selected)
  - You pick exactly **3 more subjects**
  - Timed 2-hour exam
  - Score scaled out of **400** like the real UTME
- **Year Filtering**: Practice by specific years (via ALOC API)
- **CBT Mode**: Exam-like interface with timer, question navigator, flagging
- **Offline Practice Bank**: Expanded high-quality original questions so the app always works without internet
- **Thousands of real past questions via ALOC API** (token already configured)
- **My Scores / History**: View all past results with percentage, time taken, and date
- **Review with Workings**: After every test you can expand each question to see the correct answer and full explanation/solution
- **Modern UI** with custom **JX** logo branding

## Why the app icon shows the Dart logo

Flutter projects show the default blue Dart bird icon until you generate the Android/iOS platform folders and set a custom launcher icon.

**Fix it:**
1. Run once:
   ```bash
   flutter create . --project-name jamb_waec_neco_prep --org com.examprep
   ```
2. Add `flutter_launcher_icons` (optional) or replace the icons inside `android/app/src/main/res/mipmap-*/` with your own PNG icons (use the `assets/logo.svg` as base).
3. Rebuild the APK.

## Why the package name has underscores (`jamb_waec_neco_prep`)

Dart/Flutter package names **must** be valid Dart identifiers. They use `snake_case` (lowercase + underscores). Hyphens or spaces are not allowed in the `name:` field of `pubspec.yaml`.  
The **display name** that users see on the phone is set separately (in AndroidManifest / iOS Info.plist) and can be "JAMB WAEC NECO Prep" without underscores.

## Powered by ALOC Past Questions API

This app uses the free [ALOC Questions API](https://questions.aloc.com.ng/) which provides access to 6,000+ past questions spanning multiple years (including Post-UTME).

The Access Token is already placed in `lib/config/api_config.dart`. You can replace it with your own free token if needed.

## Getting Started

### Prerequisites
- Flutter SDK (3.16+)
- Android Studio / VS Code with Flutter extensions

### Setup

1. Clone the repo:
```bash
git clone https://github.com/Tajudeen001-security/JAMB-WAEC-NECO-Prep.git
cd JAMB-WAEC-NECO-Prep
```

2. Generate platform folders (required for building APK and fixing the icon):
```bash
flutter create . --project-name jamb_waec_neco_prep --org com.examprep
```

3. Install & run:
```bash
flutter pub get
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```

## GitHub Actions Workflow

`.github/workflows/build-apk.yml` automatically builds a release APK on every push to `main`. Download the artifact from the Actions tab.

> Tip: Commit the generated `android/` folder so CI can build successfully.

## Project Structure

```
lib/
├── main.dart
├── config/api_config.dart          ← ALOC token here
├── data/sample_questions.dart      ← Expanded offline bank
├── models/question.dart
├── services/
│   ├── aloc_api_service.dart
│   └── progress_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── subject_screen.dart
│   ├── setup_screen.dart
│   ├── quiz_screen.dart
│   ├── result_screen.dart          ← Shows score + full workings/explanations
│   ├── jamb_mock_setup_screen.dart ← Pick 4 subjects (English fixed)
│   ├── jamb_mock_quiz_screen.dart  ← Full multi-subject timed mock
│   └── scores_screen.dart          ← View all past scores
└── utils/constants.dart
assets/
└── logo.svg
```

## Exam Types

- `utme` → JAMB
- `wassce` → WAEC
- `neco` → NECO
- `post-utme` → Post-UTME

## Disclaimer

Past questions from the ALOC API are for educational practice only. The offline bank contains original practice questions. Always cross-check with official materials. Not affiliated with JAMB, WAEC, or NECO.

## License

MIT License – feel free to fork and improve for Nigerian students.

---

**by JagX & JRILICENSE** • Built with ❤️ for Nigerian students
