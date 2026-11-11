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
- **NAME-010** A non-empty family name shall have a maximum length of 50 characters.
- **NAME-011** A non-empty family name shall start with an uppercase ASCII letter (`A-Z`) and contain only ASCII letters (`A-Z`, `a-z`).
- **NAME-012** Accented characters and non-Latin writing systems are not supported.
- **NAME-013** The addon shall preserve the capitalization entered after the required uppercase first letter and shall display it without further case conversion.
- **NAME-014** The account-wide family name shall be stored on the local computer and read on each character login.
- **NAME-015** If a submitted family name is invalid, the addon shall show an error and shall not save or announce the invalid value. The previously saved valid value, if any, shall remain in effect.
- **NAME-016** The family-name Save button shall be disabled when the settings panel opens and whenever the input matches the saved value. Editing the input to a different value shall enable the button.
- **NAME-017** After a valid family name is saved, the input shall display the saved value and the Save button shall be disabled. If saving fails validation, the error shall be shown, the edited input shall be retained, and the Save button shall remain enabled.
- **NAME-018** The settings panel shall provide a reset button that, after confirmation, clears the saved family name, received character cache, and custom display pattern, then restores the empty-name and default-pattern values.