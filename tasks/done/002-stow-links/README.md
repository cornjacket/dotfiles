# 002 — Use GNU Stow for the symlinks

## Context

The README said to revisit an installer "when the table at the top has three rows".
There are now three symlinks: `CLAUDE.md`, `writing-docs`, `claude.zsh`.
The README lists each link's `ln` and `test -e` commands twice: in setup and in "Do not move this repo".
Task 001 had to edit both copies. A missed copy leaves a dangling link, and dangling links fail silently.
The README already names Stow as the answer at this point.

Stow makes the links from the repo layout. The repo must mirror `$HOME`:
a file at `<package>/.claude/CLAUDE.md` links to `~/.claude/CLAUDE.md`.

## Steps

1. `brew install stow`.
2. Restructure into Stow packages (use `git mv`):

   | Today | With Stow |
   | --- | --- |
   | `claude/CLAUDE.md` | `claude/.claude/CLAUDE.md` |
   | `claude/skills/writing-docs/` | `claude/.claude/skills/writing-docs/` |
   | `shell/claude.zsh` | `zsh/.config/zsh/claude.zsh` |
   | `claude/prompts/` | move out of the `claude` package (e.g. `prompts/`) so Stow does not link it |

3. Remove the current hand-made links, then run `stow -t ~ claude zsh` from the repo root.
4. Make sure no real file is in the way: Stow refuses to overwrite one. Back up first if it does.
5. Update README.md:
   - "What's here" paths.
   - Setup: `brew install stow`, `stow -t ~ claude zsh`, a `test -e` check per link, then the manual `~/.zshrc` and `settings.json` steps.
   - "Do not move this repo": replace the per-link commands with `stow -t ~ -R claude zsh` plus the `test -e` checks.
   - "Why there is no `install.sh` here": record that the threshold was reached and Stow was adopted.
   - Fix links to moved files (e.g. `claude/prompts/working-in-this-repo.md`).
6. Search the repo and `~/.claude` for references to the old paths and fix them.
7. Commit with the repo's commit schema. Don't push.

## Verification

- `test -e` passes for `~/.claude/CLAUDE.md`, `~/.claude/skills/writing-docs/SKILL.md`, `~/.config/zsh/claude.zsh`.
- `readlink` on each points into the new package paths.
- `zsh -ic 'type claude-leader'` finds the function.
- A new Claude session still loads the global `CLAUDE.md`.
- `~/.claude/prompts` (or similar) does not exist: prompts were not stowed.

## Outcome

Done 2026-11-12. Stow 2.4.1 via Homebrew.

- `stow -n -v` dry run showed exactly the 3 expected links; then `stow -t ~ claude zsh`.
- `test -e` OK for all three. Links are relative, e.g. `~/.claude/CLAUDE.md -> ../src/github.com/cornjacket/dotfiles/claude/.claude/CLAUDE.md`.
- `~/.claude/prompts` does not exist. `claude-leader` loads from the linked file; completion registered.
- No references to old paths outside this repo.

**Correction found while testing:** `stow -R` does **not** re-point links after a repo move.
Tested in a scratch home: the old links dangle, Stow does not own them, and it aborts with
"existing target is not owned by stow". The README now says: `stow -D` before moving, or delete the
dead dotfiles links after moving, then `stow`. The cleanup `find` matches only links into `dotfiles/`,
so it cannot delete other dangling links such as `second-brain`.

