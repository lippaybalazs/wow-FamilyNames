# Detailed Requirements (Draft)

This folder is a draft decomposition of the customer requirements in [Customer Requirements](../customer_requirements/README.md). It is intended to make implementation and verification possible without selecting internal code structures, APIs, or algorithms.

## Status and Traceability

- Every detailed requirement has a unique `DR-*` ID and cites its source customer requirement IDs.
- The detailed requirements are a behavior-focused decomposition of the customer requirements; they do not prescribe internal code structure.

## Requirement Groups

- [Configuration and Names](01-names.md): `DR-NAME-*`
- [Synchronization and Discovery](02-synchronization.md): `DR-SYNC-*`
- [Visibility and Membership](03-visibility.md): `DR-VIS-*`
- [Chat and Roster Display](04-display.md): `DR-DISPLAY-*`
- [Compatibility and Identity](05-compatibility.md): `DR-COMPAT-*`

## Code-Level Decisions

Implementation may choose the internal mechanisms, provided observable behavior meets these requirements. Examples include the addon communication prefix and payload encoding, event/API integration, internal data structures, timers, and how the standard Blizzard UI is hooked. The five-minute broadcast interval is specified in SYNC-006.

## Manual Verification

Use the [Manual Test Plan](../manual_test_plan.md) for the in-game 7.3.5 checks.