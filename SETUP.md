# Setup Guide – JAMB WAEC NECO Prep

## 1. Clone & Generate Platform Folders

```bash
git clone https://github.com/Tajudeen001-security/JAMB-WAEC-NECO-Prep.git
cd JAMB-WAEC-NECO-Prep

# Generate the android/ (and ios/) folders if they are missing
flutter create . --project-name jamb_waec_neco_prep --org com.examprep
```

This command keeps your existing `lib/` and `pubspec.yaml` while adding the necessary platform code.

## 2. Get Free ALOC API Token

1. Go to https://questions.aloc.com.ng
2. Create a free account
3. Copy your **AccessToken** from the dashboard
4. Open `lib/config/api_config.dart` and replace:

```dart
const String alocAccessToken = 'YOUR_ALOC_TOKEN_HERE';
```

With your real token.

> Without a token the app still runs using 10 high-quality sample questions so you can test the UI and CBT flow.

## 3. Install & Run

```bash
flutter pub get
flutter run
```

## 4. Build Release APK Locally

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## 5. GitHub Actions (Automatic APK)

The workflow `.github/workflows/build-apk.yml` builds a release APK on every push to `main`.

1. Enable Actions in the repository settings if needed.
2. After a push, go to the **Actions** tab → select the latest workflow run → download the **app-release** artifact.

> Note: The first run after adding the workflow may need the platform folders. Run `flutter create .` once and commit the generated `android/` folder so the CI has everything it needs.

## Recommended Next Steps

- Commit the generated `android/` folder after `flutter create .`
- Add your ALOC token (or use environment variables / secrets for CI)
- Customize colors / branding in `lib/utils/constants.dart`
- Add more subjects or offline JSON question packs later

Happy studying!
