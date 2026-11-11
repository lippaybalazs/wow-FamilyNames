# Family Name Management

## Configuration

- **NAME-001** Family names shall be configured through the default WoW Escape Menu under **Interface → AddOns** settings.
- **NAME-002** The addon shall not require a separate configuration interface.
- **NAME-003** The family name shall be account-wide: all characters on the WoW account shall use the same configured family name.
- **NAME-004** Changing the family name on one character shall change the account-wide value used by all characters on that WoW account.
- **NAME-005** A character shall announce its currently configured family name upon login.
- **NAME-006** Changing a family name shall immediately announce the new value to online guild members.

## Name Rules

- **NAME-007** A family name may be empty.
- **NAME-008** An empty family name shall be valid, announced, and treated as a known value, but shall not be displayed.
- **NAME-009** A character with the addon and no configured family name shall use an empty string (`""`) as its default family name.
- **NAME-010** A non-empty family name shall have a maximum length of 50 Unicode code points after NFC normalization.
- **NAME-011** A family name shall consist of Unicode letters, with combining marks permitted only as part of a letter. Single spaces, hyphens (`-`), straight apostrophes (`'`), and right curly apostrophes (`’`) may be used between letter sequences. Names shall not begin or end with a separator or contain adjacent separators. Numbers, other punctuation, symbols, and control or formatting characters shall not be allowed.
- **NAME-012** Accented characters and non-Latin writing systems, including Chinese, shall be supported.
- **NAME-013** Input shall not require uppercase characters. Family names shall be converted to uppercase when displayed.
- **NAME-014** The account-wide family name shall be stored on the local computer and read on each character login.
- **NAME-015** If a submitted family name is invalid, the addon shall show an error and shall not save or announce the invalid value. The previously saved valid value, if any, shall remain in effect.