# Visibility and Guild Membership

- **VIS-001** Before displaying a character's family name, the addon shall verify that the character belongs to the currently logged-in character's guild.
- **VIS-002** In ordinary displays, family names shall be displayed only for currently online members of the current guild. The logout notification exception is defined in VIS-005 and VIS-011.
- **VIS-003** These guild-membership and online-status restrictions shall apply to every supported display location: chat and the guild roster.
- **VIS-004** Friends outside the guild shall not have family names displayed.
- **VIS-005** Guild login notifications shall include family names where available. In a guild logout notification, the displayed member name in the "has gone offline" message shall include the family name known immediately before the member went offline, where available.
- **VIS-006** An offline character shall retain its original Blizzard display name in all displays except its own logout notification, which may include the family name known immediately before logout.
- **VIS-007** A family name may remain in memory after its character logs out, but shall not be displayed while the character is offline.
- **VIS-008** When a character comes online again, it shall announce its family name again so the locally known value is updated.
- **VIS-009** The addon shall always check current guild membership before displaying a family name. Information retained from a previous guild shall not be displayed to members of another guild.
- **VIS-010** After a character's logout notification has been handled, the addon shall ignore that offline character and shall not request, update, or otherwise use its family name until the character comes online again.
- **VIS-011** The family-name logout notification described in VIS-005 is the sole exception to the online-only visibility requirements.