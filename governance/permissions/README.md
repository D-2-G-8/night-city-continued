# governance/permissions/

One file per mod author who has given written permission to include their work at the
`included` tier: `<mod-id>.md`.

Each file records the link to the message, the date, the author's name and contact, and
the exact scope of what was permitted. A permission is evidence — agents are denied write
access here, and a human adds the file after reading the actual message.

No file here means the mod cannot be `included`. It can still be `linked` or `compat`.

**Withdrawals are recorded in the same file**, under the grant they revoke, with the date and
a link. A withdrawal is honoured whether or not a grant was ever given, and covers every tier
including a compatibility entry — see `governance/author-rights.md` and ADR-011. Recording it
is what stops the next person to pick up the recipe from reopening a settled question.

A recipe's `permissions` block (ADR-010) is transcribed from the author's own page and is
separate from this: it records what they published, while this directory records what they
told us directly.
