# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

CopyVault (package name `copy_vault`): a minimal, offline-only Android Flutter app for storing reusable text snippets and copying them to the clipboard in as few taps as possible. Full product spec is in `PRD.md` — read it before implementing any feature, especially the **Excluded Features** and **Main Product Principle** sections, since scope creep is explicitly against the product philosophy (no categories, tags, cloud sync, auth, themes, etc.).

Planned MVP work is broken into vertical-slice issues in `issues/01`–`06` (dependency order: `01-create-and-list-snippets` is the foundation; `02` copy, `03` detail, `06` search depend on it; `04` edit and `05` delete depend on `03`).

The codebase is currently just the default `flutter create` scaffold — `lib/main.dart` has no real implementation yet.

## Commands

```
flutter pub get              # install dependencies
flutter run                  # run on connected device/emulator
flutter test                 # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter analyze              # lint (rules from analysis_options.yaml -> package flutter_lints)
flutter build apk            # build release APK (Android-only target per PRD)
```

## Architecture constraints from the PRD

- **Offline-first, no backend, no accounts.** Everything must work with local storage only (no network calls).
- **Data model**: a single `Snippet` entity — `id`, `title`, `content`, `created_at`, `updated_at`. No other entities are in scope for MVP.
- **Screens**: Home (search bar + list + FAB), Create, Detail, Edit. Edit reuses the Create layout pre-filled.
- **Primary interaction is copy**: any snippet must be copyable in at most 2 taps. Don't add navigation/friction in front of the copy action.
- **Search** is real-time (filter-as-you-type over title + content), no submit button.
- **Delete** requires a confirm dialog ("Delete this text?" / Cancel / Delete).
- List is always ordered newest-first.

## Code
- use sqflite
- using riverpod for state management
