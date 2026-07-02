# Delete text

## Parent

Source: PRD.md (CopyFast MVP)

## What to build

The Delete action on the Detail screen removes the snippet from local storage, after a confirmation dialog ("Delete this text?" with Cancel / Delete).

## Acceptance criteria

- [ ] Delete action on Detail screen shows a confirmation dialog before deleting
- [ ] Confirmation dialog reads "Delete this text?" with Cancel and Delete options
- [ ] Cancel dismisses the dialog with no changes
- [ ] Confirming delete removes the snippet from the local database and returns to Home screen
- [ ] Deleted snippet no longer appears in the Home list

## Blocked by

- #3 Detail screen
