# Synchronization and Discovery

## Guild Synchronization

- **SYNC-001** Family names shall be shared exclusively between members of the same guild.
- **SYNC-002** A character shall announce its current family name when it logs in.
- **SYNC-003** A family-name change shall be announced immediately to online guild members.
- **SYNC-004** Each receiver shall persist an unlimited local cache mapping Blizzard character names to their latest received family names, including empty values.
- **SYNC-005** The configured family name shall remain account-wide and local. The character currently logged in shall broadcast that value under its own character name; other characters on the account shall broadcast it when they log in.
- **SYNC-006** A logged-in character shall broadcast its current family name to its current guild every five minutes.
- **SYNC-007** When a character joins a guild while online, it shall immediately broadcast its current family name to that guild.
- **SYNC-008** Synchronization shall be one-way broadcast only. Receiving a family-name broadcast shall not trigger a response.

## Cache Lookup and Broadcast Timing

- **SYNC-009** Chat and roster display shall look up the Blizzard character name in the local cache. If no value exists, the original Blizzard name shall remain displayed until a broadcast is received.
- **SYNC-010** A character shall send its first broadcast when it logs in and repeat broadcasts every five minutes while logged in.
- **SYNC-011** Saving a changed family name shall trigger an immediate broadcast without waiting for the periodic interval.
- **SYNC-012** Missing cache values shall not start an on-demand request.
- **SYNC-013** The addon shall not retry requests because it shall not send family-name requests.
- **SYNC-014** The five-minute broadcast shall be the only periodic synchronization mechanism.
- **SYNC-015** A later broadcast from a character shall replace that character's cached value.
- **SYNC-016** Login shall load the persisted cache; it shall not clear previously received values.

## Update Semantics

- **SYNC-017** A newly received family name shall overwrite the previously known value; timestamps and version comparisons are not required.
- **SYNC-018** When a character changes its family name, it shall broadcast the new value directly to online members of its current guild.
- **SYNC-019** An empty family name shall be broadcast and stored as a valid known value.
- **SYNC-020** Family-name broadcasts shall use WoW addon messaging routed to the current guild and shall not be sent as visible chat messages.
- **SYNC-021** When local data is reset, the addon shall clear the persistent character cache, retain an empty account-wide family name, and not request or fetch other values immediately. Later broadcasts shall repopulate the cache.