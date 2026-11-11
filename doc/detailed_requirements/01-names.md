# Configuration and Names

Each requirement below cites its source customer requirements.

## Configuration

- **DR-NAME-001** The family-name setting shall be reachable through the default Escape Menu → Interface → AddOns settings. The addon shall not require a separate configuration interface. [Source: NAME-001, NAME-002]
- **DR-NAME-002** The configured family name shall be shared by all characters on the WoW account. [Source: NAME-003, NAME-004]
- **DR-NAME-003** Editing the family-name setting while logged in as any character shall change the account-wide value used by all characters on that account. [Source: NAME-004]
- **DR-NAME-004** If no account-wide family name has been configured, its effective value shall be the empty string (`""`). [Source: NAME-009]
- **DR-NAME-005** The value announced by a character at login shall be the current account-wide family name, including an empty value. [Source: NAME-005, NAME-009, SYNC-002, SYNC-019]
- **DR-NAME-006** A successfully applied family-name change shall cause the new value to be announced to online guild members immediately. [Source: NAME-006, SYNC-003]
- **DR-NAME-007** The account-wide family name shall be stored on the local computer and read for each character login. [Source: NAME-014]

## Input Rules

- **DR-NAME-008** The setting shall accept an empty family name, and an empty value shall be treated as valid rather than as missing or unknown. [Source: NAME-007, NAME-008, NAME-009, SYNC-019, STORE-005]
- **DR-NAME-009** A non-empty family name shall contain no more than 50 ASCII characters. [Source: NAME-010]
- **DR-NAME-010** Accented characters and non-Latin writing systems shall be rejected. Family-name input shall contain ASCII characters only. [Source: NAME-011, NAME-012]
- **DR-NAME-011** The first character of every non-empty family name shall be an uppercase ASCII letter. [Source: NAME-011]
- **DR-NAME-012** Characters after the first shall retain their entered uppercase or lowercase ASCII letter case, and the display shall preserve that capitalization without further conversion. [Source: NAME-013, DISPLAY-008]
- **DR-NAME-013** Any character other than an ASCII letter shall be invalid. [Source: NAME-011, NAME-012]
- **DR-NAME-014** If input is invalid, the addon shall display an error, shall not save or announce the invalid value, and shall keep the previous valid value, if any. [Source: NAME-015]
- **DR-NAME-015** The family-name Save button shall be disabled when the settings panel opens and whenever the input equals the saved family name. Editing the input to a different value shall enable the button. [Source: NAME-016]
- **DR-NAME-016** After a valid save, the settings input shall show the saved value and the Save button shall be disabled. After a validation error, the input shall retain the attempted value and the Save button shall remain enabled for correction. [Source: NAME-015, NAME-017]
- **DR-NAME-017** After reset confirmation, the addon shall set the account-wide family name to empty, restore the default display pattern, clear the persistent received-name cache, update the settings fields, and immediately announce the empty value to the current guild. [Source: NAME-018, SYNC-003, SYNC-021]