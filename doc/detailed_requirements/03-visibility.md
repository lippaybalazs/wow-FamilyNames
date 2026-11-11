# Visibility and Membership

Each requirement below cites its source customer requirements.

- **DR-VIS-001** Before applying a family-name display, the addon shall verify that the speaker or roster entry is a member of the local character's current guild. A cached value alone shall not establish eligibility. [Source: VIS-001, VIS-009]
- **DR-VIS-002** In ordinary displays, a family name shall be used only while its character is currently online and belongs to the current guild. The character's logout notification is the sole exception. [Source: SCOPE-002, VIS-002, VIS-003, VIS-011]
- **DR-VIS-003** The current-membership and online checks shall be applied consistently to chat and guild-roster display. [Source: VIS-003, DISPLAY-009, DISPLAY-013]
- **DR-VIS-004** A family name retained in memory after logout shall not be used in any display while that character is offline, except in the logout notification generated for that character. [Source: VIS-006, VIS-007, VIS-010, VIS-011, STORE-003]
- **DR-VIS-005** While a character is offline, its ordinary display name shall remain the original Blizzard character name, even if a family name is cached. The logout notification may use the family name known immediately before logout. [Source: VIS-005, VIS-006, VIS-007]
- **DR-VIS-006** When a character comes online again, its new announcement shall replace the locally known value for that character. [Source: VIS-008, SYNC-017]
- **DR-VIS-007** A value retained from a previous guild shall not be displayed unless the character is verified as a member of the local character's current guild. [Source: VIS-009]
- **DR-VIS-008** Characters outside the local character's guild, including friends outside that guild, shall retain their original Blizzard display name. [Source: VIS-001, VIS-004]
- **DR-VIS-009** A guild logout notification shall display the family name known immediately before the member went offline, when non-empty and available, in the member's display label followed by `has gone offline`. After generating that notification, the addon shall ignore the offline character and shall not use its cached family name for other displays or requests. [Source: VIS-005, VIS-006, VIS-007, VIS-010, VIS-011, STORE-003]
- **DR-VIS-010** The addon shall not display family names in the character selection screen, friends list, party frames, or raid frames. [Source: SCOPE-004, DISPLAY-015]
- **DR-VIS-011** A character with an empty family name shall be treated as having a known value, not as a character whose value still needs discovery. [Source: NAME-008, SYNC-019, STORE-005]