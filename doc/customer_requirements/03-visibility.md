# Visibility and Guild Membership

- **VIS-001** The addon shall display a family name whenever the Blizzard character name has a non-empty entry in the local cache, regardless of current guild membership or online status.
- **VIS-002** A cache entry alone shall determine family-name display eligibility; the addon shall not require the character to be online or in the current guild.
- **VIS-003** This cache-based eligibility shall apply consistently to all supported display locations, including chat, guild roster, member details, presence notifications, and group invitations.
- **VIS-004** Characters outside the guild may have their family names displayed when their names are present in the local cache.
- **VIS-005** Guild login notifications shall include family names where available. In a guild logout notification, the displayed member name in the "has gone offline" message shall include the family name known immediately before the member went offline, where available.
- **VIS-006** An offline character shall use its cached family name in supported displays when the cache contains a non-empty value.
- **VIS-007** Cached family names shall remain available for display after their character logs out or leaves a guild.
- **VIS-008** When a character broadcasts an updated family name, the receiver shall replace that character's cached value.
- **VIS-009** The addon shall not check current guild membership before displaying a cached family name. Entries learned from a previous guild shall remain displayable.
- **VIS-010** The addon shall continue to use a cached value after the character logs out; only a later broadcast or local cache reset shall change or remove it.
- **VIS-011** There shall be no online-only or logout-only exception to cache-based visibility.