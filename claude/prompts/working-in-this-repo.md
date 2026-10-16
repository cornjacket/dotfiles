# Task: add a "Working in this repo" section using docs/INVARIANTS.md

Paste this into a session rooted in the target repo, or use it as the body of a task there.

## Goal
Give humans and AI agents the same short list of rules that a change in this repo must not
break. Keep one copy: README.md links to it and CLAUDE.md imports it.

## Steps
1. Read README.md, CLAUDE.md, the test and CI setup, and the last ~30 commits.
2. Find the invariants: rules that, if broken, cause damage that a reader would not expect.
   Look for: who consumes this repo's output, generated or managed files, public interfaces,
   lockfiles, compatibility promises, and rules already scattered across README.md and CLAUDE.md.
3. Write `docs/INVARIANTS.md`:
   - A one-line title stating what the repo is.
   - 5–10 rules. Each rule is one line, plus a short "because" clause.
   - The command that proves a change is safe (test, self-test, golden check).
   - Keep it under ~40 lines. It loads into every agent turn.
4. In README.md, add a link to `docs/INVARIANTS.md` in the Contributing or Development section.
   Create that section if it does not exist.
5. In CLAUDE.md, add a "Working in this repo" section with:
   - `@docs/INVARIANTS.md`
   - One stance line: how careful to be and what to protect.
     Example: "Template edits are releases: bump VERSION and update golden files."
   - At most 3 lines about mistakes agents make here that a human would not.
   - No persona or identity statement ("You are a …").
6. Remove the copies. If README.md or CLAUDE.md already states a rule that is now in
   INVARIANTS.md, replace that text with a link or delete it.
7. Show me the draft invariants list before you commit. I confirm which rules are real.

## Constraints
- Do not edit inside generator-managed blocks (text between `begin`/`end` markers or under a
  "managed" heading). Put new text outside them.
- Follow this repo's task system and commit convention.
- Write in plain technical English: short sentences, active voice, no filler.

## Done when
- `docs/INVARIANTS.md` exists and I have confirmed each rule.
- README.md links to it; CLAUDE.md imports it with `@`.
- No invariant is stated in two places.
- The always-on CLAUDE.md content did not grow by more than ~15 lines (excluding the import).
