# Manual Test Plan

This plan is for an in-game check of FamilyNames on the required WoW 7.3.5 client. Lua syntax, validator, persistent-cache behavior, and mocked UI behavior have been checked outside the client; the Blizzard UI integration still needs hands-on verification.

## Test Setup

1. Install the current addon build on two clients or accounts, **A** and **B**, whose characters are online members of the same guild. Both characters should have the addon enabled.
2. Keep a third character, **C**, available to verify that names are formatted based on the local cache rather than current guild membership.
3. Use a second character on account A to verify that the configured family name and display pattern remain account-wide and that each character broadcasts under its own name.
4. Open the default Blizzard chat window and guild roster. Record the original name and color shown for B before testing formatting.
5. In each case, record **Pass**, **Fail**, or **Not testable**, plus the client, character, and any visible error text.

The saved account-wide setting and persistent character-name cache are in `FamilyNamesDB` in the client's `WTF/Account/<account>/SavedVariables/FamilyNames.lua`. The `familyNameCache` table maps character names to their latest received family names.

## Test Cases

### MT-01: Initial Settings

1. Open **Escape → Interface → AddOns → Family Names**.
2. Check the family-name and display-pattern fields.

**Expected:** The name defaults to empty when no value has been saved. The default pattern is `[{family}] {character}`. There is no separate configuration window.

### MT-02: Name Validation

Save each value through the Family Names settings panel and check the result.

| Input | Expected |
| --- | --- |
| `MaryJane` | Saved |
| `Mcdonald` | Saved; exact capitalization retained |
| `mcdonald` | Error; not saved; first letter must be uppercase |
| Empty | Saved as a known empty value |
| 50 ASCII letters | Saved |
| 51 ASCII letters | Error; not saved |
| `Mary Jane`, `A1`, `A.B`, `Anne-Marie`, `O'Neil` | Error; not saved |
| `José`, `李`, `王🙂` | Error; not saved |

After one invalid submission, reopen the panel and verify the last saved valid value remains. Verify an invalid name was not announced to B.

**Save button checks:** It starts disabled, enables after the input differs from the saved value, and disables again after a valid save. After an invalid save, it remains enabled and the attempted text remains in the field.

### MT-03: Account-Wide Setting and Character Cache

1. On character A1, save a valid family name.
2. Log in as character A2 on the same WoW account and open the settings panel.
3. Confirm A2 sees the same account-wide setting. Change the name on A2, then return to A1.
4. Restart the client and confirm the account-wide setting remains. Check the cache on another guild member for separate A1 and A2 entries after both have broadcast.

**Expected:** Both characters use the same locally saved family name and display pattern. A save on either changes the shared account setting. Each logged-in character broadcasts that value under its own Blizzard character name, and receivers persist each sender as a separate cache entry.

### MT-04: Guild Addon Messaging Is Not Visible Chat

1. Set a valid family name on B.
2. Log in or reload A while A and B are online in the same guild. Wait up to five minutes for B's periodic broadcast if it was not just changed or logged in.
3. Watch all visible chat frames during login and name discovery.

**Expected:** A stores B's broadcast under B's character name and uses it for subsequent eligible displays. There are no requests or replies; broadcasts are addon messages and never visible chat text.

### MT-05: Cached Names After Logout or Guild Departure

1. With B online in A's guild, wait until A has cached B's non-empty family name.
2. Log B out and inspect B's offline roster row and logout notification.
3. Log B back in, then have B leave A's guild while staying online. Have B whisper A or send a Say message nearby.
4. Inspect the cached name in the chat message and any group invitation from B.

**Expected:** A continues to format B from its persistent cache while B is offline or no longer in A's guild. A later broadcast from B updates only B's cached value. No current-guild or online check suppresses a cached name.

### MT-06: Chat Formatting, Color, and History

With B online in A's guild and its non-empty family name known, have B send a message in each available relevant channel: Guild, Say, Yell, Whisper, Party, Raid, and a custom channel.

**Expected:** The speaker label uses the saved pattern and preserves the exact capitalization of the saved family name; the message body is unchanged. The label keeps the color Blizzard would normally use for B. If A sees a message before learning B's family name, that existing line stays unchanged after discovery; only later messages use the formatted label. Empty or unavailable family names leave the original name unformatted.

### MT-07: Custom Display Pattern

1. Save a pattern such as `{family} / {character} / {family}` and have B send a new chat message.
2. Try saving `{family}` and then `{character}` as separate invalid patterns.
3. Reopen the settings panel after each invalid submission.

**Expected:** The panel explains that both `{family}` and `{character}` are required. The Save button starts disabled, enables after editing, and disables after a valid save. Every exact marker occurrence is substituted; other pattern text is preserved. Each invalid pattern produces an error, is not saved, keeps the attempted text, and leaves Save enabled; the last valid pattern remains active.

### MT-08: Guild Login and Logout Notifications

1. Ensure A already knows B's non-empty family name.
2. Have B log out, then log back in while A remains online.

**Expected:** The logout notice uses B's cached family name followed by “has gone offline.” The login notice uses the cached family name when available. B's cache entry remains available for other supported displays while offline.

### MT-09: Guild Roster Snapshot

1. Open A's guild window and note B's displayed roster name.
2. While the window remains open, change B's family name or let A receive a new value for B.
3. Observe B's row, close the guild window, and open it again.

**Expected:** B's roster name does not update while the window remains open. On the next opening, the roster uses the family-name value then available in A's local memory. If the value is empty or unknown, the original name is shown.

### MT-10: Original Character Interactions

With B shown under a family-formatted label in chat or the guild roster:

1. Use `/target CharacterName` with B's original Blizzard character name.
2. Use the chat context menu to whisper, invite, and inspect B where those actions are available.
3. Use the guild-roster context menu on B.

**Expected:** Actions still target or identify the original character. Family formatting changes the visible label only.

### MT-11: Periodic Cache Refresh

1. Let A cache B's family name, then change B's family name while A is online.
2. Verify A receives the update immediately. Restart A before B next logs in and confirm the cached value is still available.
3. Leave both online and observe B send another broadcast after five minutes.

**Expected:** A overwrites only B's cache value on the immediate update and persists it across sessions. The periodic broadcast repeats B's current value every five minutes. No request or retry traffic is sent.

### MT-12: Group Invitation Popup

1. With A and B online in the same guild and A knowing B's non-empty family name, have B invite A to a group.
2. Verify the inviter text in A's standard group-invitation popup.
3. Accept the invitation. Repeat and decline it.
4. Repeat with an inviter who has left the guild but remains in A's cache, then with an unknown/empty cache entry.

**Expected:** A cached inviter's popup label uses the configured family-name pattern even after leaving the guild. The invite is still accepted or declined for B, the original inviter. Unknown or empty cache entries show the original character name.

### MT-13: Reset Local Data

1. Save a non-empty family name and a custom display pattern. Let A learn at least one other guild member's name.
2. Open **Escape → Interface → AddOns → Family Names** and select **Reset Local Data**.
3. Cancel the confirmation and verify nothing changed.
4. Select **Reset Local Data** again and confirm.
5. Reopen the panel, then check visible chat and the settings fields.

**Expected:** Cancel leaves all values unchanged. Confirm resets the account-wide name to empty and the pattern to `[{family}] {character}`, clears the persistent character cache, and shows the defaults. A immediately broadcasts the empty value through addon messaging, not visible chat. Later broadcasts repopulate the cache.

### MT-14: Selected Guild-Member Details

1. Ensure A knows B's non-empty family name and B is online in A's guild.
2. Open the guild roster and select B.
3. Inspect the small member details pane, including the displayed name and notes.
4. Repeat with an empty/unknown cache entry and with B offline but cached.

**Expected:** The pane shows B's formatted family name whenever the cached value is non-empty, including when B is offline. Notes and interactions remain unchanged. Empty or missing entries show the original character name.

### MT-15: Guild Login and Logout Notices

1. Ensure A has learned B's non-empty family name and both characters are in the same guild.
2. Log B in while watching A's default chat window, then log B out.
3. Repeat with B's family name empty or not yet known.

**Expected:** The localized `has come online` and `has gone offline` notices show B's configured display pattern when A knows a non-empty family name. Empty or unknown names remain unformatted. No extra visible addon communication appears.

### MT-16: Family Name Matches Character Name

1. Set the account-wide family name to match the main character's name, then ensure another client has cached it.
2. Observe the main character in chat and the guild roster.
3. Log in to an alt on the same account and observe that character in chat and the guild roster.

**Expected:** The main character displays once without the family-name pattern. The alt displays using the configured pattern with the shared family name. Case differences alone do not cause duplicate display.

## Results

| Case | Result | Notes |
| --- | --- | --- |
| MT-01 |  |  |
| MT-02 |  |  |
| MT-03 |  |  |
| MT-04 |  |  |
| MT-05 |  |  |
| MT-06 |  |  |
| MT-07 |  |  |
| MT-08 |  |  |
| MT-09 |  |  |
| MT-10 |  |  |
| MT-11 |  |  |
| MT-12 |  |  |
| MT-13 |  |  |
| MT-14 |  |  |
| MT-15 |  |  |
| MT-16 |  |  |