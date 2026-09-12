# Author rights

If your mod is in this project, or someone has proposed adding it, this page is what you are
entitled to. It is short on purpose.

## You can leave, at any time, without giving a reason

Ask, and your mod is removed. From every tier, including a compatibility-table entry.

- No review, no appeal, no negotiation, no "could you reconsider".
- No reason required, and none will be asked for.
- Removed from the development branch the next working day, and from the next release.
- **We keep no archival copy** to keep our releases working. When you leave, the files go.

Releases already on players' disks are not recalled; the component simply becomes
unavailable, which our launcher handles by installing everything else and saying what is
missing. Keeping your work in a release against your wishes is not a trade we make.

Downgrading — say, from `included` to `linked`, or to a compatibility entry — is the same
right used partially, and works the same way.

**How:** open an issue on the repository, or contact a maintainer. One line is enough.

## You are never included without permission

`included` — where we ship your files with our release — requires either a license that
permits it or your written permission. It is never assumed, never inferred from silence, and
never taken from the fact that your mod is public.

At `linked` we ship only a recipe: a link to your page, a hash, and the lab scenarios that
test it. Your files stay yours, on your page.

## Your downloads stay yours

For `linked` mods the launcher opens **your** download page and waits for the player to fetch
the file from you. We never proxy, mirror, cache or hotlink it.

This is slower for the player, and it is deliberate: the download, the endorsement and the
traffic to your donation links stay with you. Automated packs that route that past the author
are the main reason modders distrust distributions, and we would rather be slow.

## We do not touch what you said not to touch

We read your stated permissions — redistribution, modification, conversion, asset use — and
we follow them separately from your license. If you have said no modifications, we do not
patch your mod, even locally on a player's machine, even for compatibility. A mod that needs
a patch to work with us and whose author forbids modification is recorded as a compatibility
note instead, with the reason stated.

Where your permissions are unstated, we treat them as denied until we have asked you.

## Saying no costs you nothing

If you would rather not take part, that is the end of it. **We do not build our own version of
your mod because you declined**, and we never will — not as leverage, not as a fallback, not
quietly a year later.

Writing our own implementation of someone's idea is legal; copyright protects expression, not
ideas. We are telling you we will not, because "work with us or we will build it ourselves" is
not an invitation, and we would rather be slow than be that.

There are narrow cases where we build something that overlaps with existing work: when the
platform needs something your mod cannot expose, when a mod is abandoned and broken and its
author cannot be reached, or when someone has refused any relationship and the capability is
genuinely required. When that happens we say so publicly, we name the work that came first,
we do not take its name, and we do not present ours as a replacement. If we have read your
code, the person who writes ours will not have. See ADR-022.

Declining also does not cost you the useful part. Compatibility testing needs nothing from
you: we can run your mod in the lab, publish whether it works on each release, and tell
players — without your permission, your involvement, or a single message from you.

## Nothing about you is behind money

Your mod is never part of a paid tier, a donor build, early access or a bundle anyone pays
for. Nobody can pay to have your mod included, excluded, prioritised or ranked. We do not
take money with conditions attached to content.

You keep your own donation links, on your own pages, and the contributors page links to them.

## You do not have to move

Joining costs you nothing you already have. You do not have to leave Nexus, change your
license, hand over a repository, or accept our patches. An author who owns their recipe here
decides which patches are accepted into it.

## What you get

- The test lab runs the real game against your mod on every change, and reports back with
  screenshots, frame rates and logs. Free.
- Compatibility reports when the game is patched.
- A release pipeline and distribution through the launcher, if you want them.
- Attribution everywhere your work appears: the recipe, `THIRD_PARTY.md`, the launcher, the
  contributors page.

## If we get this wrong

Tell us, and we fix it. If the problem is conduct rather than process,
`governance/CODE_OF_CONDUCT.md` has the reporting route.

---

The decisions behind this page: ADR-005 (recipes, not copies), ADR-010 (permissions),
ADR-011 (opt-out), ADR-009 (releases survive a component disappearing), ADR-022 (we do not
rebuild a living mod to replace it).
