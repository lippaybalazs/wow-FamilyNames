# Synchronization and Discovery

Each requirement below cites its source customer requirements. Synchronization uses one-way announcements on login, on setting changes, and at five-minute intervals; there is no request or retry protocol.

## Announcements and Responses

- **DR-SYNC-001** When the local character logs in, the addon shall announce that character's current family name to the current guild, including an empty family name. [Source: NAME-005, NAME-008, SYNC-001, SYNC-002, SYNC-019]
- **DR-SYNC-002** When a family-name change is applied, the addon shall announce the new value to online members of the current guild without waiting for another login or discovery request. [Source: NAME-006, SYNC-001, SYNC-003]
- **DR-SYNC-003** When the local character joins a guild while online, it shall immediately announce its current account-wide value to that guild. [Source: SYNC-001, SYNC-007]
- **DR-SYNC-004** While logged in, the character shall announce its current value every five minutes. [Source: SYNC-006, SYNC-010]
- **DR-SYNC-005** Each received announcement shall be stored under the sending Blizzard character name, independently of other characters on that account. [Source: SYNC-004, SYNC-017]
- **DR-SYNC-006** A received value shall update only the cache entry for the character that sent it. [Source: SYNC-017, SYNC-018]
- **DR-SYNC-007** A receiver shall not forward received values or reply to a broadcast; each character shall announce its own account-wide value. [Source: SYNC-005, SYNC-008, SYNC-018]
- **DR-SYNC-008** Family-name broadcasts shall be limited to the current guild. [Source: SYNC-001, SYNC-020]

## Cache and Fallback Behavior

- **DR-SYNC-009** The addon shall load its persistent character-name cache when initializing. [Source: SYNC-004, SYNC-016, STORE-001, STORE-002]
- **DR-SYNC-010** The persistent cache shall use Blizzard character names as keys and family-name strings as values. It shall not impose a fixed capacity, eviction policy, or time-based expiration. [Source: SYNC-004, STORE-004]
- **DR-SYNC-011** A newer announcement shall overwrite only the cache value for its sender. [Source: SYNC-015, SYNC-017]
- **DR-SYNC-012** If a display lookup finds no cache entry, it shall use the original Blizzard character name and wait for a later broadcast; it shall not request a value. [Source: SYNC-009, SYNC-012]
- **DR-SYNC-013** Login shall preserve previously received cache entries. [Source: SYNC-016]
- **DR-SYNC-014** Saving a changed account-wide name shall cause an immediate broadcast. [Source: SYNC-003, SYNC-011]
- **DR-SYNC-015** Each character shall send its current account-wide value immediately on login and resume periodic broadcasts. [Source: SYNC-002, SYNC-010]

## Received Values

- **DR-SYNC-016** A newly received value shall replace the previously known value for that character, regardless of which value was sent first. The addon shall not require timestamps or version comparisons. [Source: SYNC-017]
- **DR-SYNC-017** Received family names, including empty values, shall persist between game sessions as known cache entries. [Source: SYNC-004, SYNC-019, STORE-001, STORE-002, STORE-005]
- **DR-SYNC-018** The cache shall have no fixed capacity or eviction policy. [Source: STORE-004]
- **DR-SYNC-019** An empty broadcast shall overwrite the sender's previous cache value and be treated as known. [Source: SYNC-019, STORE-005]
- **DR-SYNC-020** The addon shall send announcements through WoW addon messaging on the `GUILD` distribution and shall not use visible chat channels to synchronize family-name data. [Source: SYNC-001, SYNC-020]
- **DR-SYNC-021** Resetting local data shall clear the persistent cache and immediately broadcast the empty account-wide family name; the cache shall repopulate only from later broadcasts. [Source: SYNC-021]