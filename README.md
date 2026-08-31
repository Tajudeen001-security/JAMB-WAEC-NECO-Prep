# JAMB-WAEC-NECO-Prep

**Android CBT Practice App for Nigerian Students**  
**by JagX & JRILICENSE**

Prepare for **JAMB (UTME)**, **WAEC (WASSCE)**, **NECO** and **Post-UTME** with thousands of past questions, realistic timed CBT interface, and progress tracking.

## Features

- **Multi-Exam Support**: JAMB/UTME, WAEC/WASSCE, NECO, Post-UTME
- **Subject Coverage**: English, Mathematics, Physics, Chemistry, Biology, Economics, Government, Literature, and more (17+ subjects)
- **Year Filtering**: Practice by specific years (where available via API)
- **CBT Mode**: Exam-like interface with timer, question navigator, flagging
- **100+ Offline Practice Questions**: Built-in high-quality sample bank so the app works even without internet or API token
- **Thousands more via ALOC API**: Real past questions when you add a free token
- **Progress Tracking**: Local history of scores
- **Modern UI** with custom **JX** logo branding

## Logo & Branding

- App logo: `assets/logo.svg` (JX monogram on Nigerian green)
- Credits appear on the home screen: **by JagX & JRILICENSE**

## Powered by ALOC Past Questions API

This app uses the free [ALOC Questions API](https://questions.aloc.com.ng/) which provides access to 6,000+ past questions spanning multiple years (including Post-UTME).

> **Note**: You need a free Access Token from https://questions.aloc.com.ng (sign up → dashboard). Place it in `lib/config/api_config.dart`.

## Getting Started

### Prerequisites
- Flutter SDK (3.16+)
- Android Studio / VS Code with Flutter extensions
- Free ALOC Access Token (optional but recommended)

### Setup

1. Clone the repo:
```bash
git clone https://github.com/Tajudeen001-security/JAMB-WAEC-NECO-Prep.git
cd JAMB-WAEC-NECO-Prep
```

2. Generate platform folders:
```bash
flutter create . --project-name jamb_waec_neco_prep --org com.examprep
```

3. (Optional) Get free API token from [questions.aloc.com.ng](https://questions.aloc.com.ng) and update:
```dart
// lib/config/api_config.dart
const String alocAccessToken = 'YOUR_ALOC_TOKEN_HERE';
```

4. Install & run:
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

## Project Structure

```
lib/
├── main.dart
├── config/api_config.dart
├── data/sample_questions.dart   ← 100+ offline questions
├── models/question.dart
├── services/
│   ├── aloc_api_service.dart
│   └── progress_service.dart
├── screens/
│   ├── home_screen.dart         ← Logo + "by JagX & JRILICENSE"
│   ├── subject_screen.dart
│   ├── setup_screen.dart
│   ├── quiz_screen.dart
│   └── result_screen.dart
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
