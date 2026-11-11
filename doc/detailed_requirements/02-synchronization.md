# Synchronization and Discovery

Each requirement below cites its source customer requirements. The request timeout, retry interval, and maximum attempt count are specified in SYNC-010, SYNC-011, SYNC-013, and SYNC-014.

## Announcements and Responses

- **DR-SYNC-001** When the local character logs in, the addon shall announce that character's current family name to the current guild, including an empty family name. [Source: NAME-005, NAME-008, SYNC-001, SYNC-002, SYNC-019]
- **DR-SYNC-002** When a family-name change is applied, the addon shall announce the new value to online members of the current guild without waiting for another login or discovery request. [Source: NAME-006, SYNC-001, SYNC-003]
- **DR-SYNC-003** When the local character joins a guild while online, the addon shall announce its current value to that guild and request the values of all members reported online in that guild. [Source: SYNC-001, SYNC-006, SYNC-007]
- **DR-SYNC-004** On login, the addon shall request values from all members reported online in the current guild. [Source: SYNC-006]
- **DR-SYNC-005** An online addon character receiving a request shall respond with the current account-wide family name, including an empty value. [Source: NAME-003, SYNC-008, SYNC-019]
- **DR-SYNC-006** A received announcement or response shall be associated with the character that sent it. A value from one character shall not be treated as another character's value. [Source: SCOPE-001, SYNC-001, SYNC-017, SYNC-018]
- **DR-SYNC-007** The addon shall not forward a family-name change received from one character as though it were an update from that character; the changed character shall send its own update directly to guild members. [Source: SYNC-018]
- **DR-SYNC-008** Guild family-name exchange shall be limited to the current guild. Characters on one account shall read their shared value from the local account-wide setting rather than transfer it through guild messaging. [Source: SYNC-001, SYNC-005, NAME-014]

## Discovery and Retry Behavior

- **DR-SYNC-009** When a family name is needed for an eligible display and the value is unknown, the addon shall request it from that character. A known empty value shall not be considered unknown and shall not cause another request. [Source: SYNC-009, SYNC-019, STORE-005]
- **DR-SYNC-010** A request shall be considered unanswered if no matching response is received within one minute after the request is sent. [Source: SYNC-010]
- **DR-SYNC-011** If a request is unanswered, the addon shall retry once per minute, up to five total requests per queried character, counting the initial request. [Source: SYNC-011, SYNC-013, SYNC-014]
- **DR-SYNC-012** When a request is unanswered or its retry limit has been reached, the family name shall remain unavailable and the original Blizzard character name shall be used for display. [Source: SYNC-010, SYNC-012, SYNC-013, DISPLAY-006, DISPLAY-007]
- **DR-SYNC-013** A later login by the queried character shall reset the attempt limit tracked for that character. [Source: SYNC-015]
- **DR-SYNC-014** Login of the local character shall reset the attempt limits tracked for all queried characters. [Source: SYNC-016]
- **DR-SYNC-015** The initial request shall count as the first of the five total attempts. [Source: SYNC-013, SYNC-014]

## Received Values

- **DR-SYNC-016** A newly received value shall replace the previously known value for that character, regardless of which value was sent first. The addon shall not require timestamps or version comparisons. [Source: SYNC-017]
- **DR-SYNC-017** Received family names shall be retained only in memory and shall not be restored in a later game session. Empty values shall be retained as known values for the current session. [Source: SYNC-004, SYNC-019, STORE-001, STORE-002, STORE-005]
- **DR-SYNC-018** The addon is not required to enforce a fixed capacity, eviction policy, or time-based expiration for received family names. [Source: STORE-004]
- **DR-SYNC-019** When a response is received from the queried character, including a response with an empty family name, the addon shall stop retrying requests for that character until that character logs in again and its attempt limit resets. [Source: SYNC-008, SYNC-013, SYNC-015, SYNC-019]