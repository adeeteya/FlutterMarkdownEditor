# Repository Guidelines

## Project Structure & Module Organization
Core Flutter code lives in `lib/`, with `main.dart` bootstrapping `home.dart`, shared widgets under `lib/widgets/`, and localization delegates in `lib/l10n/`. Platform shells and installers live in `android/`, `ios/`, `macos/`, `windows/`, `linux/`, and `web/`, while release automation sits in `fastlane/` and `scripts/windows-setup.iss`. Store collateral sits under `screenshots/`, and all dependencies plus asset declarations are centralized in `pubspec.yaml`.

## Build, Test, and Development Commands
Run `flutter pub get` after dependency edits, then `flutter analyze` to apply the lints declared in `analysis_options.yaml`. Use `flutter run -d <device_id>` for iterative testing (for example, `flutter run -d windows`). CI-quality builds should use `flutter build apk --release`, `flutter build windows --release`, or the matching platform command before attaching artifacts. `fastlane beta` (defined in `Fastfile`) automates store uploads once credentials are configured.

## Coding Style & Naming Conventions
Follow Dart's two-space indentation, keep files snake_case (for example, `device_preference_notifier.dart`), classes and typedefs PascalCase, and methods or fields camelCase. Prefer `const` widgets and literals, add trailing commas to multi-line params, and always declare explicit return types per the analyzer rules. Imports must be package-scoped (`package:markdown_editor/...`); avoid relative lib imports. Run `dart format .` before sending a PR.

## Testing Guidelines
Place widget and unit specs under `test/`, mirroring the `lib/` structure (`lib/widgets/foo.dart` -> `test/widgets/foo_test.dart`). Name files with the `_test.dart` suffix and group cases with `testWidgets` or `test` blocks. Execute `flutter test --coverage` locally; target >=80% coverage on new modules and capture golden diffs for UI-heavy changes. Failing tests or analyzer findings block merges.

## Commit & Pull Request Guidelines
Commits follow the short, emoji-style convention seen in `git log` (for example, `:art: update README translations`), and should describe what changed plus why in <=72 characters. Reference issues using `#id` when applicable. Every PR must fill out `pull_request_template.md`, confirm multi-platform impact, link screenshots for UI tweaks, update the README feature matrix when adding functionality, and mention any localization or Fastlane config updates. Keep branches rebased and use descriptive titles so automation can pick the right release lane.

## Localization & Configuration
Strings are managed via `lib/l10n` with settings in `l10n.yaml`; run `flutter gen-l10n` when ARB files change. Secrets such as `google_service_account.json` stay encrypted; never commit new keys. Platform-specific icon or installer adjustments belong in their respective OS folders to keep Fastlane lanes deterministic.
