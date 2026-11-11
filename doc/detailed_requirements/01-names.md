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
- **DR-NAME-009** A non-empty family name shall contain no more than 50 Unicode code points after NFC normalization. [Source: NAME-010]
- **DR-NAME-010** Family names shall support accented characters and non-Latin writing systems, including Chinese. Input shall be normalized to NFC before validation and storage. [Source: NAME-010, NAME-012]
- **DR-NAME-011** Input shall not be required to be uppercase. [Source: NAME-013]
- **DR-NAME-012** A displayed family name shall be uppercase regardless of the capitalization stored in the local setting or received from another character. [Source: NAME-013, DISPLAY-008, SYNC-017]
- **DR-NAME-013** A family name shall consist of Unicode letters and combining marks attached to letters. It may contain single internal spaces, hyphens (`-`), straight apostrophes (`'`), or right curly apostrophes (`’`) between letter sequences. A name shall not begin or end with a separator or contain adjacent separators. Numbers, other punctuation, symbols, and control or formatting characters shall be invalid. [Source: NAME-011, NAME-012]
- **DR-NAME-014** If input is invalid, the addon shall display an error, shall not save or announce the invalid value, and shall keep the previous valid value, if any. [Source: NAME-015]