# Chat and Roster Display

Each requirement below cites its source customer requirements.

## Name Formatting

- **DR-DISPLAY-001** When a family name is eligible and non-empty, the default label shall be `[FamilyName] CharacterName`, preserving the family name's stored capitalization. [Source: DISPLAY-001, DISPLAY-008]
- **DR-DISPLAY-002** The user shall be able to configure a custom display pattern. A valid pattern shall contain both the literal `{family}` and `{character}` placeholders and may contain arbitrary text around and between them. [Source: DISPLAY-002, DISPLAY-003, DISPLAY-004]
- **DR-DISPLAY-003** A valid custom pattern shall replace `{family}` with the family name exactly as stored and `{character}` with the original Blizzard character name. [Source: DISPLAY-003, DISPLAY-008, COMPAT-004]
- **DR-DISPLAY-004** If the family name is empty, unknown, or unavailable, the displayed label shall be exactly the original Blizzard character name, without the default or custom pattern. [Source: DISPLAY-006, DISPLAY-007, SYNC-012]
- **DR-DISPLAY-005** While a value is absent from the local cache, the original Blizzard character name shall remain displayable; the display shall not wait for or request a broadcast. [Source: SYNC-009, SYNC-012, DISPLAY-006, DISPLAY-007]
- **DR-DISPLAY-006** The family and character portions of a combined label shall use the color the default Blizzard UI would have used for the character name without the addon. The addon shall not modify the label color. [Source: DISPLAY-005]
- **DR-DISPLAY-007** The family-name feature shall change the displayed speaker label only; it shall not alter the chat message text. [Source: SCOPE-003, DISPLAY-009, COMPAT-003]
- **DR-DISPLAY-008** A custom pattern shall be invalid if it omits either required placeholder. When an invalid pattern is submitted, the addon shall show an error, shall not save it, shall retain the previous valid pattern and attempted input, and shall leave the pattern Save button enabled. [Source: DISPLAY-002, DISPLAY-003, DISPLAY-018, DISPLAY-021]
- **DR-DISPLAY-009** The addon shall replace every exact occurrence of `{family}` with the family name exactly as stored and every exact occurrence of `{character}` with the original Blizzard character name. All other pattern characters, including braces that do not form either exact placeholder, shall be retained literally. [Source: DISPLAY-003, DISPLAY-004, DISPLAY-008]

## Chat

- **DR-DISPLAY-010** In supported chat messages, the addon shall apply the family-name label whenever a non-empty cache entry exists for the author, regardless of guild membership or online state. [Source: SCOPE-002, VIS-001, VIS-002, DISPLAY-009, DISPLAY-011, DISPLAY-012]
- **DR-DISPLAY-011** The chat transformation shall apply to player-authored messages shown in the default Blizzard chat UI, in any supported channel, when the author is identifiable. Dedicated whisper-window routing shall continue to resolve to the original Blizzard character identity. [Source: DISPLAY-009, DISPLAY-010, DISPLAY-011, DISPLAY-012, DISPLAY-017]
- **DR-DISPLAY-012** For an author with no cache entry or an empty cached family name, the addon shall leave the original Blizzard character name as the displayed label. [Source: DISPLAY-006, DISPLAY-007]
- **DR-DISPLAY-013** Once a chat message has been displayed, the addon shall not change that message retroactively. A discovered or changed family name shall affect only subsequently displayed messages. [Source: DISPLAY-016, SYNC-017, SYNC-018]

## Guild Roster and Notifications

- **DR-DISPLAY-014** The guild roster shall show a formatted label for each member whose non-empty family name exists in the cache, regardless of online status. [Source: VIS-001, VIS-002, DISPLAY-013]
- **DR-DISPLAY-015** A roster member with an empty or unknown family name shall retain the original Blizzard character name. [Source: DISPLAY-006, DISPLAY-007, DISPLAY-013]
- **DR-DISPLAY-016** When the guild window opens, the addon shall populate roster labels using family-name values currently available in local memory. It shall not update roster labels while the window remains open. A newly received or changed family name shall be reflected the next time the window opens. [Source: SYNC-017, SYNC-018, DISPLAY-013, DISPLAY-019]
- **DR-DISPLAY-017** Guild login and logout notifications shall use the cached family name when non-empty and otherwise use the original character name. [Source: VIS-005, VIS-006, VIS-007]
- **DR-DISPLAY-018** In the standard group-invitation popup, the inviter label shall use the configured display pattern when a non-empty cache entry exists, regardless of guild membership or online state. The addon shall change only popup text; it shall not alter popup data or accept/decline callbacks, which shall continue to refer to the original inviter. Otherwise, the original character name shall remain displayed. [Source: DISPLAY-020, VIS-001, VIS-002]
- **DR-DISPLAY-019** The pattern Save button shall be disabled when the input matches the stored pattern, enabled when the input differs, disabled after a successful save, and remain enabled with the attempted text after a validation error. [Source: DISPLAY-021]
- **DR-DISPLAY-020** The settings panel shall display help text stating that both `{family}` and `{character}` are required in the pattern. [Source: DISPLAY-003, DISPLAY-018, DISPLAY-022]
- **DR-DISPLAY-021** When a roster entry is selected, the guild-member detail pane shall display the configured formatted name when a non-empty cache entry exists, regardless of online status. It shall leave notes and original member identity data unchanged. If the family name is empty or unknown, the pane shall show the original character name. [Source: DISPLAY-023, VIS-001, VIS-002]
- **DR-DISPLAY-022** If the family name equals the displayed character name ignoring case, the addon shall display only the original character name; other characters with the same family name shall continue using the configured pattern. [Source: DISPLAY-024]