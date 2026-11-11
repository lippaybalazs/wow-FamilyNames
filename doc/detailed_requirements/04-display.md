# Chat and Roster Display

Each requirement below cites its source customer requirements.

## Name Formatting

- **DR-DISPLAY-001** When a family name is eligible and non-empty, the default label shall be `[FAMILYNAME] CharacterName`, with the family name displayed in uppercase. [Source: DISPLAY-001, DISPLAY-008]
- **DR-DISPLAY-002** The user shall be able to configure a custom display pattern. A valid pattern shall contain both the literal `{family}` and `{character}` placeholders and may contain arbitrary text around and between them. [Source: DISPLAY-002, DISPLAY-003, DISPLAY-004]
- **DR-DISPLAY-003** A valid custom pattern shall replace `{family}` with the uppercase family name and `{character}` with the original Blizzard character name. [Source: DISPLAY-003, DISPLAY-008, COMPAT-004]
- **DR-DISPLAY-004** If the family name is empty, unknown, or unavailable, the displayed label shall be exactly the original Blizzard character name, without the default or custom pattern. [Source: DISPLAY-006, DISPLAY-007, SYNC-012]
- **DR-DISPLAY-005** While a value is unknown and a discovery request is pending, the original Blizzard character name shall remain displayable; the display shall not wait for a response. [Source: SYNC-009, SYNC-010, SYNC-012, DISPLAY-006, DISPLAY-007]
- **DR-DISPLAY-006** The family and character portions of a combined label shall use the color the default Blizzard UI would have used for the character name without the addon. The addon shall not modify the label color. [Source: DISPLAY-005]
- **DR-DISPLAY-007** The family-name feature shall change the displayed speaker label only; it shall not alter the chat message text. [Source: SCOPE-003, DISPLAY-009, COMPAT-003]
- **DR-DISPLAY-008** A custom pattern shall be invalid if it omits either required placeholder. When an invalid pattern is submitted, the addon shall show an error, shall not save it, and shall retain the previous valid pattern, if any. [Source: DISPLAY-002, DISPLAY-003, DISPLAY-018]
- **DR-DISPLAY-009** The addon shall replace every exact occurrence of `{family}` with the uppercase family name and every exact occurrence of `{character}` with the original Blizzard character name. All other pattern characters, including braces that do not form either exact placeholder, shall be retained literally. [Source: DISPLAY-003, DISPLAY-004]

## Chat

- **DR-DISPLAY-010** In supported chat messages, the addon shall apply the family-name label only when the author is an online member of the current guild and a non-empty family name is known. [Source: SCOPE-002, VIS-001, VIS-002, DISPLAY-009, DISPLAY-011, DISPLAY-012]
- **DR-DISPLAY-011** The chat transformation shall apply to player-authored messages shown in the default Blizzard chat UI, in any channel, when the author is identifiable. Messages without an identifiable player author shall remain unchanged. [Source: DISPLAY-009, DISPLAY-010, DISPLAY-011, DISPLAY-012, DISPLAY-017]
- **DR-DISPLAY-012** For an author who is not eligible, whose family name is unknown, or whose known family name is empty, the addon shall leave the original Blizzard character name as the displayed label. [Source: DISPLAY-006, DISPLAY-007, VIS-001, VIS-002]
- **DR-DISPLAY-013** Once a chat message has been displayed, the addon shall not change that message retroactively. A discovered or changed family name shall affect only subsequently displayed messages. [Source: DISPLAY-016, SYNC-017, SYNC-018]

## Guild Roster and Notifications

- **DR-DISPLAY-014** The guild roster shall show a formatted label for each online current-guild member whose non-empty family name is known. [Source: VIS-001, VIS-002, DISPLAY-013]
- **DR-DISPLAY-015** An online guild member with an empty or unknown family name shall retain the original Blizzard character name in the roster. [Source: DISPLAY-006, DISPLAY-007, DISPLAY-013, VIS-002]
- **DR-DISPLAY-016** When the guild window opens, the addon shall populate roster labels using family-name values currently available in local memory. It shall not update roster labels while the window remains open. A newly received or changed family name shall be reflected the next time the window opens. [Source: SYNC-017, SYNC-018, DISPLAY-013, DISPLAY-019]
- **DR-DISPLAY-017** A guild login notification shall include the member's family name when available. A logout notification shall display the known family name in the member label followed by `has gone offline`; if no non-empty family name is available, it shall use the original character name. This event is the only display of an offline character's family name. [Source: VIS-005, VIS-006, VIS-007, STORE-003]