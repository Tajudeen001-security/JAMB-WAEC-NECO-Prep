# Setup Guide – JAMB WAEC NECO Prep

## 1. Clone & Generate Platform Folders

```bash
git clone https://github.com/Tajudeen001-security/JAMB-WAEC-NECO-Prep.git
cd JAMB-WAEC-NECO-Prep

# Generate the android/ (and ios/) folders if they are missing
flutter create . --project-name jamb_waec_neco_prep --org com.examprep
```

This command keeps your existing `lib/` and `pubspec.yaml` while adding the necessary platform code. It is also required to replace the default Dart bird app icon.

## 2. ALOC API Token

The token is already configured in `lib/config/api_config.dart`:

```dart
const String alocAccessToken = 'aloc_ih5iT2FsxLR7AzUw7KRaW4L0wwLdQdMFiI8EuNKS';
```

You can replace it with your own free token from https://questions.aloc.com.ng if you prefer.

Without a valid token the app still runs using the expanded offline practice bank.

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

## 5. Fix the App Icon (remove the Dart logo)

After running `flutter create .`:

1. Convert `assets/logo.svg` to PNG sizes (48, 72, 96, 144, 192).
2. Replace the files in:
   - `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

Or add the `flutter_launcher_icons` package for automatic generation.

## 6. Display Name vs Package Name

- Package name (`pubspec.yaml` → `name: jamb_waec_neco_prep`) uses underscores because Dart requires snake_case.
- The name users see on the home screen can be changed in `android/app/src/main/AndroidManifest.xml` (`android:label`) to something like "JAMB WAEC NECO Prep".

## 7. GitHub Actions (Automatic APK)

The workflow `.github/workflows/build-apk.yml` builds a release APK on every push to `main`.

1. Enable Actions in the repository settings if needed.
2. After a push, go to the **Actions** tab → select the latest workflow run → download the **app-release** artifact.

> Note: Commit the generated `android/` folder so the CI has everything it needs.

## Recommended Next Steps

- Commit the generated `android/` folder after `flutter create .`
- Replace the default launcher icons
- Customize colors / branding in `lib/utils/constants.dart`
- Optionally add more offline JSON question packs later

Happy studying!
