# Synchronization and Discovery

## Guild Synchronization

- **SYNC-001** Family names shall be shared exclusively between members of the same guild.
- **SYNC-002** A character shall announce its current family name when it logs in.
- **SYNC-003** A family-name change shall be announced immediately to online guild members.
- **SYNC-004** Received family names shall be stored temporarily in memory.
- **SYNC-005** Characters on the same WoW account shall use the locally stored account-wide family name; the value shall not need to be transferred between those characters through guild messaging.
- **SYNC-006** When a character logs in, the addon shall request family names from all currently online guild members.
- **SYNC-007** When a character joins a guild while already online, the join shall be treated as a login for synchronization: the character shall announce its own family name to the new guild and request the family names of all currently online guild members.
- **SYNC-008** An online character shall respond to requests for its own family name.

## On-Demand Discovery and Retries

- **SYNC-009** If the addon needs to display a guild member's family name and does not know it, the addon shall request it.
- **SYNC-010** A family-name request shall be considered unanswered if no response is received within one minute.
- **SYNC-011** Repeated requests for the same character shall be spaced at least one minute apart.
- **SYNC-012** If no response is received, the original Blizzard character name shall be displayed.
- **SYNC-013** An unsuccessful request shall be retried once per minute, up to five total request attempts, including the initial request.
- **SYNC-014** The maximum polling-attempt count shall be five total attempts per queried character.
- **SYNC-015** The polling-attempt limit for a queried character shall reset when that character logs in again.
- **SYNC-016** When the local character logs in, polling-attempt limits shall reset for all queried characters.

## Update Semantics

- **SYNC-017** A newly received family name shall overwrite the previously known value; timestamps and version comparisons are not required.
- **SYNC-018** When a character changes its family name, it shall share the new value with online guild members. Each receiving member shall get the update directly from that character, not indirectly through a third character.
- **SYNC-019** An empty family name shall be announced and stored as a valid known value and shall not trigger further discovery requests.