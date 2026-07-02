# Create + List snippets

## Parent

Source: PRD.md (CopyFast MVP)

## What to build

Foundation slice. Users can create a text snippet (title + content) and immediately see it appear at the top of the Home screen list.

Covers:
- Local database setup with the `Snippet` entity (id, title, content, created_at, updated_at)
- Create screen: title input, content textarea, save button; both fields required
- Home screen: list of saved snippets ordered newest first, each item showing title and a small content preview
- Floating action button on Home screen opens the Create screen
- App startup under 2 seconds; offline only, no backend

## Acceptance criteria

- [x] Snippet entity persists to a local database (id, title, content, created_at, updated_at)
- [x] Create screen requires both title and content before saving
- [x] Saving a snippet returns to Home screen and the new snippet appears at the top of the list
- [x] Home screen lists all saved snippets, newest first, each showing title + preview
- [x] Floating action button navigates to Create screen
- [x] Works fully offline

## Blocked by

None - can start immediately
