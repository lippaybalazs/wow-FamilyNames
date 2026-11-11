# Display

## Format

- **DISPLAY-001** The default display format shall be `[FAMILYNAME] CharacterName`.
- **DISPLAY-002** Users shall be able to customize the display format.
- **DISPLAY-003** A custom display pattern shall include both `{family}` and `{character}` placeholders.
- **DISPLAY-004** A custom display pattern may place arbitrary text around and between the placeholders.
- **DISPLAY-005** Family and character names shall use the same color the default Blizzard UI would use for the character name without this addon. The addon shall not modify that color.
- **DISPLAY-006** An empty or unavailable family name shall result in the original character name being displayed without additional formatting.
- **DISPLAY-007** If a family name is unknown and a request is unsuccessful, the original character name shall still be displayed normally.
- **DISPLAY-008** Family names shall be displayed in uppercase, independently of their stored capitalization.

## Display Locations

- **DISPLAY-009** Family names shall be displayed in all relevant chat messages, regardless of channel.
- **DISPLAY-010** Family names shall be displayed in guild chat and guild login/logout notifications.
- **DISPLAY-011** Family names shall be displayed in party and raid chat messages when the author is an online member of the current guild.
- **DISPLAY-012** Family names shall be displayed in Say, Yell, Whisper, and other relevant chat channels when the author is an online member of the current guild.
- **DISPLAY-013** Family names shall be displayed in guild roster entries for online members of the current guild.
- **DISPLAY-014** The default Blizzard chat UI and guild roster shall be the primary compatibility targets.
- **DISPLAY-015** The character selection screen, friends list, party frames, and raid frames are outside the display scope.
- **DISPLAY-016** Once a chat message has been displayed, the addon shall not change it retroactively. A later discovery or family-name change shall affect only messages displayed afterward.
- **DISPLAY-017** In the default Blizzard chat UI, family-name formatting shall apply to player-authored messages in any channel when the author is identifiable. Messages without an identifiable player author shall remain unchanged.
- **DISPLAY-018** If a custom display pattern omits either `{family}` or `{character}`, the addon shall show an error and shall not save the invalid pattern. The previously saved valid pattern, if any, shall remain in effect.
- **DISPLAY-019** When the guild window opens, the addon shall populate the roster using family-name values currently available in local memory. It shall not refresh family names while the guild window remains open. A name change or newly received value shall appear the next time the guild window is opened.