# ADR-022: The project does not rebuild a living mod in order to replace it

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** E — Ecosystem
- **Extends:** ADR-005 (recipes, not copies), ADR-011 (author opt-out), ADR-014 (patch churn)

## Context

Copyright protects expression, not ideas. Writing our own implementation of something another
mod already does, in our own code, is lawful — in the US, in the EU and in Russian civil law
alike, ideas, concepts, principles and methods are outside copyright. Patents do not
meaningfully appear in this space, a published mod holds no trade secret, and trademark
reaches only the name.

So the question this ADR answers is not whether we may. It is what happens when we do.

**Community norms here are stricter than the law.** Rebuilding someone's mod from the idea is
widely read as taking their work, even when no line of their code was touched. The largest
ruptures in modding history — the Nexus Collections revolt, the removal of the Unofficial
Patches — were not caused by legal breach. They were caused by authors concluding that a
platform had stopped treating their wishes as decisive.

**A platform doing it is not the same as a person doing it.** An individual writing a similar
mod is competition. This project has a distribution, a launcher and a test lab; when it ships
its own version of an existing mod, the original author's downloads move to us. Protecting
those downloads is the entire purpose of the `linked` tier and most of
`governance/author-rights.md`.

**The worst consequence is not to the author.** If the project ever replaces a mod after its
author declined to take part, then "let's work together" starts reading as "or we will build
it ourselves" — in every invitation afterwards, whether or not anyone means it that way.
Launch plan step 6 is personal messages to authors. One precedent turns each of those into a
message the recipient reads as a threat, and no amount of good intent afterwards undoes it.

## Decision

**The project does not build its own version of a maintained mod whose author is reachable,
in order to replace it.**

An author declining to take part is **not** a reason to build our own. The `compat` tier
requires nothing from an author — no permission, no reply, no involvement — so declining to
cooperate never blocks us from testing a mod and telling players what works.

### When we may build our own

1. **The platform needs something the existing mod cannot provide** — integration with the
   core API, agent perception, the lab harness. This is a different thing solving an adjacent
   problem, not a reimplementation, and the difference must be stated specifically. "We need
   our own version" is not a reason; "we need X to expose Y to the core API, which cannot be
   added from outside" is.
2. **The mod is unmaintained, broken, and its author is unreachable**, after a documented
   attempt to reach them. Even then ADR-014 comes first: **repair their mod and point players
   at the repair** before replacing it.
3. **The author has explicitly refused any relationship and the capability is required by the
   platform.** This is the narrowest case and it still carries every rule below.

### Rules when we do build our own

- **Say so publicly and name the prior work.** Crediting the idea costs nothing and defuses
  most of the conflict. Silence about an obvious predecessor is what reads as theft.
- **Clean room if anyone involved has read the source.** One person studies the existing mod
  and writes a specification of *what it does*; another implements from that specification
  without seeing the source. Record who did which. Independent creation is a defence, and it
  is only worth having if it can be shown.
- **Do not take the name.**
- **Never position ours as a replacement.** Ship compatibility with the original wherever it
  is possible to have both.
- The decision is recorded in an issue with the reasoning, before code.

### The test

Ask: **would this still be worth building if the other mod did not exist?** If the honest
answer is no, we are replacing it, whatever else it is called.

### Worked example: wheel support

A mod already provides Logitech wheel support, uses the official Logitech SDK, and is verified
on 2.31. The project's roadmap entry (I2) is *compatibility with the wheel mod, checked in
every release* — not a wheel module of our own.

What we can offer its author is what they do not have: a lab that runs the real game against
their mod on every release, and a compatibility report when a game patch breaks it. If they
never answer, `compat` still lets us test it and tell players the result. At no point does
building our own become the next step.

## Consequences

- Some capabilities arrive later, or not at all, because the right answer is to wait for an
  author or to do without. That cost is accepted.
- Case 1 is the loophole this decision will fail through: "integration with the core API" can
  be claimed for almost anything. It is therefore written as a public, specific statement in
  an issue before code, where someone can disagree with it.
- Clean-room discipline is slow and annoying, and the temptation is to skip it precisely when
  someone already knows the answer from having read the source.
- We may knowingly ship something worse than an existing mod because we chose not to look at
  how it was done.
- The invitation in step 6 stays an invitation. That is the whole point, and it is worth more
  than any individual capability.

## Alternatives considered

- **Say nothing and decide case by case.** The current state. Every case then gets argued from
  first principles under pressure, at the moment when building our own is most attractive.
- **Never build anything resembling an existing mod.** Unworkable — nearly every useful thing
  has been attempted by someone, and abandoned mods would freeze whole capabilities forever.
- **Rely on the law alone**, since ideas are not protected. Legally sound, and it answers a
  question nobody was asking. The risk here was never legal.
