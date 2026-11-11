# Customer Requirements

This folder contains the agreed customer-facing requirements for the FamilyNames addon. Requirements use stable IDs so they can be referenced in implementation notes, tests, and future discussions.

The derived, reviewable specification is in [Detailed Requirements](../detailed_requirements/README.md). It traces each detailed requirement back to this folder.

## Requirement Groups

- [Scope](00-scope.md): purpose and supported boundaries (`SCOPE-*`)
- [Family Name Management](01-family-name-management.md): configuration and name rules (`NAME-*`)
- [Synchronization and Discovery](02-synchronization.md): guild announcements and requests (`SYNC-*`)
- [Visibility and Guild Membership](03-visibility.md): eligibility and online status (`VIS-*`)
- [Display](04-display.md): formatting and supported display locations (`DISPLAY-*`)
- [Persistence and Storage](05-storage.md): in-memory behavior (`STORE-*`)
- [Compatibility](06-compatibility.md): Blizzard UI and original functionality (`COMPAT-*`)

## Conventions

- Each requirement has a unique, prefixed ID.
- Requirements use “shall” for mandatory behavior.