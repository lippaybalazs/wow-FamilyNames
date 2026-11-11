# Family Names

A World of Warcraft addon that adds a family name to character labels in chat and the guild interface.

## Features

- One family name and display pattern shared by all characters on the WoW account.
- Family names are limited to 50 ASCII letters. Non-empty names must start with an uppercase letter; empty names are allowed.
- The active character broadcasts the account's family name when logging in, when the value changes, when joining a guild, and every five minutes while in a guild.
- Broadcasts use guild addon messages and do not appear as visible chat.
- Received values are saved locally in a persistent cache keyed by Blizzard character name. New broadcasts replace only that character's cached value.
- Cached names can appear in chat, the guild roster and member details, presence notices, and group-invitation labels, even if the character is offline or no longer in the guild.
- If a character has no cached value, Blizzard's original name remains visible until a broadcast arrives.
- If a character's name matches the family name (case-insensitive), it is displayed only once. Other characters continue to use the configured pattern.

## Install

Copy the addon folder into the WoW client's `Interface/AddOns` directory so the files are located at:

```text
Interface/AddOns/FamilyNames/FamilyNames.toc
```

Enable **Family Names** from the AddOns list at character selection. The addon targets the WoW 7.3.5 client and Lua 5.1.

## Configure

Open **Escape → Interface → AddOns → Family Names** to set the account-wide family name and display pattern. A pattern must include both `{family}` and `{character}`. For example:

```text
[{family}] {character}
```

An empty family name is valid and disables family-name formatting for that value. Saving a changed name updates the local setting and broadcasts it immediately when the character is in a guild.

## Broadcast And Cache Behavior

The currently logged-in character announces the shared account setting. Other addon users in the same guild store the announcement under its sender character name. They load that cache on later sessions, so previously received names are available without waiting for another broadcast. The cache has no fixed capacity or time-based expiry; it is cleared by **Reset Local Data**.

When a character first appears to a receiver, its name may remain unformatted until the character logs in, changes its family name, joins a guild, or reaches its next five-minute broadcast.

## Reset Local Data

Use the **Reset Local Data** button in the settings panel and confirm. This clears the account-wide family name, the persistent received-name cache, and the custom display pattern. The name becomes empty and the pattern returns to its default.

SavedVariables are stored in the WoW client's `WTF/Account/<account>/SavedVariables/FamilyNames.lua` file. Close the game before deleting this file manually.

## Development

The repository includes a Makefile target for copying the addon into the configured WoW client directory. Set `WOW_PATH` in `.env`, then run:

```sh
make load
```

Lua files can be checked with Lua 5.1:

```sh
luac5.1 -p NameRules.lua Core.lua Options.lua Display.lua
```

See [the manual test plan](doc/manual_test_plan.md) for in-game verification steps.
