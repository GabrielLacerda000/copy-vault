# Edit text

## Parent

Source: PRD.md (CopyFast MVP)

## What to build

The Edit action on the Detail screen opens an Edit screen pre-filled with the snippet's current title and content, matching the Create screen layout. Saving updates the stored snippet and its `updated_at` timestamp.

## Acceptance criteria

- [ ] Edit action on Detail screen navigates to an Edit screen pre-filled with the current title and content
- [ ] Edit screen has the same required-field validation as Create (title and content required)
- [ ] Saving updates the existing snippet in the local database and bumps `updated_at`
- [ ] After saving, the Detail screen (and Home list) reflect the updated content

## Blocked by

- #3 Detail screen
