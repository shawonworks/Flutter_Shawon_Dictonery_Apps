# Lexicon — Dictionary App

Flutter + GetX implementation of the "Annotated Paper" design spec.
Fully offline: no auth, no backend, local JSON dataset + SharedPreferences.

## Setup

This is a `lib/` + `assets/` source tree only — platform folders are not
generated. From this directory:

```bash
flutter create . --project-name lexicon --org com.lexicon
flutter pub get
flutter run
```

`flutter create .` will scaffold `android/`, `ios/`, etc. around the
existing `lib/`, `pubspec.yaml`, and `assets/` without touching them.

## Structure

```
lib/
  constant/        ConstColor, ConstString — static tokens (matches your template)
  core/theme/       AppColors (reactive light/dark), AppTypography, spacing/radius/motion tokens,
                    ThemeController, TextScaleController
  core/bindings/    InitialBinding — repositories + app-wide controllers, put once
  data/             models, local JSON datasource, repositories (swap seam for a future API)
  routes/           AppRoutes, appRouteFile (GetPage table)
  widget/           shared design-system widgets (global — reused across 3+ screens)
                    + your original CustomText / CustomElevatedButton / CustomTextFormField / AppImage
  modules/          one folder per screen: controllers/ (GetX) + views/, bindings/ where needed
```

## Notes

- `GlobalAppBar` was rebuilt as the single app bar used on every screen —
  transparent over `bg/paper` at rest, raises to `bg/paper-raised` + hairline
  border on scroll (pass `raised: true` from a ScrollController listener).
- `ConstColor` keeps the compile-time `const` fields your `CustomTextFormField`
  / `CustomElevatedButton` require (they use `const BorderSide(...)` internally).
  Everything else in the app pulls dynamic light/dark colors from `AppColors`.
- Dictionary data lives in `assets/data/dictionary_seed.json` (40 curated
  entries) — matches `WordEntry.fromJson` exactly, so swapping in a real API
  later only touches `LocalDictionaryRepository`.
- `withAlpha()` used everywhere instead of `withOpacity()`.
