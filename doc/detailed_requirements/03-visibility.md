# Visibility and Membership

Each requirement below cites its source customer requirements.

- **DR-VIS-001** A non-empty cache entry shall make a character eligible for family-name display without checking current-guild membership. [Source: VIS-001, VIS-009]
- **DR-VIS-002** Cached family names shall be used regardless of whether the character is online or offline. [Source: VIS-002, VIS-006]
- **DR-VIS-003** Cache-based eligibility shall apply consistently to chat, guild roster, selected member details, presence notices, and group invitations. [Source: VIS-003]
- **DR-VIS-004** A persistent cache entry shall remain eligible after logout or guild departure. [Source: VIS-006, VIS-007, VIS-010]
- **DR-VIS-005** There shall be no special logout-only visibility exception; every supported display uses the same cache lookup rule. [Source: VIS-005, VIS-011]
- **DR-VIS-006** A later broadcast shall replace the cached value for its sender. [Source: VIS-008, SYNC-017]
- **DR-VIS-007** Changing guilds shall not clear cached family names or prevent their display. [Source: VIS-009]
- **DR-VIS-008** A character outside the current guild may still be formatted when its name has a non-empty cache entry. [Source: VIS-004]
- **DR-VIS-009** A presence notification shall use the cached family name when available, including for a character that has gone offline. [Source: VIS-005, VIS-006]
- **DR-VIS-010** The addon shall not display family names in the character selection screen, friends list, party frames, or raid frames. [Source: SCOPE-004, DISPLAY-015]
- **DR-VIS-011** A character with an empty family name shall be treated as having a known value, not as a character whose value still needs discovery. [Source: NAME-008, SYNC-019, STORE-005]