# Persistence and Storage

- **STORE-001** Family names received from other characters shall be stored in the account's local SavedVariables cache keyed by Blizzard character name.
- **STORE-002** Received family names shall persist between game sessions and be loaded when the addon initializes.
- **STORE-003** A cached family name shall remain usable for supported displays while its character is offline or no longer shares a guild with the local character.
- **STORE-004** The persistent received-name cache shall be unlimited and shall not evict entries or expire them by time.
- **STORE-005** Empty family names shall be retained in the persistent cache as valid known values.