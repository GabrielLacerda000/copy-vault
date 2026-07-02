# CopyVault

A minimal, offline Android app for storing reusable text snippets and copying them to the clipboard in as few taps as possible.

## Why

You end up retyping — or hunting through notes and old messages for — the same pieces of text over and over: a LinkedIn URL, an email address, a professional bio, a frequently used message, a code snippet. CopyVault centralizes that reusable text so retrieving and copying it is instant, with no searching through unrelated notes.

It is not a note-taking app. It's a fast-access text storage system built around one action: copy.

## Features

- **Create** a snippet with a title and content
- **List** all snippets, newest first
- **Search** in real time as you type, across title and content, no submit button
- **Copy** any snippet's content to the clipboard in one tap
- **Edit** an existing snippet
- **Delete** a snippet, with a confirmation dialog

Everything is stored locally on the device — offline-only, no accounts, no cloud sync.

## How to use

- **Home** — a search bar at the top filters the list live as you type. Each snippet shows its title, a content preview, and a copy button; tapping the copy button copies it immediately ("Copied successfully"). Tapping the card itself opens the full detail. The floating action button creates a new snippet.
- **Create** — enter a title and content (both required) and save.
- **Detail** — view the full snippet text, with Copy, Edit, and Delete actions in the app bar.
- **Edit** — same form as Create, pre-filled with the snippet's current title and content.
- **Delete** — asks for confirmation ("Delete this text?" / Cancel / Delete) before removing the snippet.

Copying a snippet always takes at most two taps: one from the home list, or one from the detail screen.

## Getting started

```
flutter pub get   # install dependencies
flutter run       # run on a connected Android device/emulator
```

The app is Android-only and offline-first — no backend, no network access, and no accounts to set up.

## Testing

```
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
flutter analyze                       # lint
```

## Tech stack

- [Flutter](https://flutter.dev)
- [sqflite](https://pub.dev/packages/sqflite) for local storage
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) for state management

## Project structure

```
lib/
  data/         # sqflite database helper
  models/       # Snippet entity
  repositories/ # data access layer
  providers/    # Riverpod providers/notifiers
  screens/      # Home, Create, Detail, Edit
  widgets/      # shared widgets (e.g. snippet card)
  theme/        # colors and theme
  utils/        # clipboard helper
```

See `PRD.md` for the full product spec, `PRODUCT.md` for product principles, and `DESIGN.md` for the design system.
