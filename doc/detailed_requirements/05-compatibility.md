# Compatibility and Identity

Each requirement below cites its source customer requirements.

- **DR-COMPAT-001** The default Blizzard chat UI and default guild roster shall be the primary supported surfaces for family-name display. [Source: DISPLAY-014, COMPAT-001]
- **DR-COMPAT-002** The addon shall preserve the original Blizzard character identity when changing its visible label. Targeting, whispering, inviting, context menus, inspection, and commands such as `/target CharacterName` shall continue to refer to the original character. [Source: COMPAT-003, COMPAT-004]
- **DR-COMPAT-003** Displaying a family name shall not prevent the normal character interaction associated with the original Blizzard name. The exact interaction behavior for each supported UI surface shall be verified against the default Blizzard UI. [Source: COMPAT-001, COMPAT-003, COMPAT-004]
- **DR-COMPAT-004** Compatibility with third-party chat and UI addons shall be best-effort; no specific third-party addon shall be a required compatibility target. [Source: COMPAT-002]
- **DR-COMPAT-005** The addon shall support WoW client version 7.3.5. [Source: COMPAT-005]
- **DR-COMPAT-006** Cross-realm behavior is outside the required scope. Within the supported scope, the addon shall consistently associate synchronization records and visible names with the same guild character. [Source: SCOPE-001, SYNC-006, SYNC-017, VIS-001, COMPAT-006]
- **DR-COMPAT-007** The feature shall not rename the character in game data or alter the original Blizzard name used for non-display operations. [Source: COMPAT-003, COMPAT-004]