# dotfiles

Version-controlled personal config, so it's backed up and portable: on a new machine,
`git clone` this repo and symlink the tracked files into place. **Edit the file here in the repo —
the live location is a symlink to it, so the two never drift.**

## What's here

`claude/` and `zsh/` are [GNU Stow](https://www.gnu.org/software/stow/) packages. Inside each
package, a file sits at the same path it has under `~`. Stow links it there.

| Path | Symlinked to | Purpose |
| --- | --- | --- |
| `claude/.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | **Global** Claude Code instructions — standing preferences applied in *every* repo, every session (e.g. "lead with a one-line summary", the second-brain consult rule). |
| `claude/.claude/skills/writing-docs/` | `~/.claude/skills/writing-docs` | User-level skill for writing human-facing docs in plain technical English (word list, templates, final check). Extends the always-on style rules in the global `CLAUDE.md`; does not repeat them. |
| `zsh/.config/zsh/claude.zsh` | `~/.config/zsh/claude.zsh` | Claude Code shell config: the `claude-yolo` alias, `claude-workspaces` (list git-workspaces), and `claude-leader` (start a named, auto-mode session at a workspace root, with tab completion). `~/.zshrc` sources it. |
| `prompts/` | — (not linked; open or paste) | Reusable task prompts for setting up a repo. See [New repo checklist](#new-repo-checklist). |
| `PLAN.md`, `tasks/` | — (repo only) | Work tracking for this repo. `PLAN.md` is the index and says how tasks work; each task is a directory under `tasks/open/` or `tasks/done/`. |

To add a linked file, put it in a package at its `~`-relative path, then run `stow` again.
Keep anything that must not be linked outside the packages, like `prompts/`.

## Setup on a new machine

Clone anywhere, then **run this from the repo root**:

```sh
brew install stow
stow -t ~ claude zsh
for p in ~/.claude/CLAUDE.md ~/.claude/skills/writing-docs/SKILL.md ~/.config/zsh/claude.zsh; do
  test -e "$p" && echo "OK $p" || echo "MISSING $p"
done
```

**`-t ~` is required.** Stow's default target is the parent of the repo, not your home folder.

**Stow refuses to overwrite a real file.** If `~/.claude/CLAUDE.md` already exists as a file, Stow
stops with a conflict. Back the file up, remove it, and run `stow` again.

**Verify with `test -e`, not `readlink` alone.** `readlink` prints its target whether or not
anything is there, so it will happily confirm a link that points at nothing.

**`~/.zshrc` is a manual step.** It is not tracked here, so on a new machine add these lines to it
yourself. `compinit` must run before the source line, or `claude-leader` tab completion does not
register:

```sh
autoload -Uz compinit && compinit
[ -f ~/.config/zsh/claude.zsh ] && source ~/.config/zsh/claude.zsh
```

**`~/.claude/settings.json` is a manual step too.** Add this so every new Claude Code session
starts in auto mode:

```json
"permissions": { "defaultMode": "auto" }
```

Claude Code writes to this file itself, so a symlink would put its runtime edits into this repo.

**Why Stow and not an `install.sh`.** Until 2026-11 this repo used one hand-written `ln -sfn` per
file, and said to revisit at three links. At three links, each link's commands were listed twice in
this README, and every new link meant editing both lists. Stow removes the lists: the folder layout
is the link list. A hand-rolled installer would be one more thing to maintain. **chezmoi** is the
heavier option, worth it only for per-machine templating or secret handling.

**The instruction cannot live in the file it installs.** Worth stating plainly, because it is the
trap: `claude/.claude/CLAUDE.md` *is* the global agent instruction file. If the link is broken or was
never made, that file is not loaded — so any "how to set up the link" guidance written inside it is
invisible in precisely the situation where it is needed. It has to live here, in the repo's README,
where a human or an agent reading the repo will find it regardless.

## New repo checklist

Run these when you start a new repo. Each line links to the tool or prompt that does the work.

1. Add the task system (`create-project-system`).
2. Add context hygiene (`create-context-hygiene`).
3. Add invariants: run [prompts/working-in-this-repo.md](prompts/working-in-this-repo.md).
4. Register the repo in its workspace (`make add-repo` from the workspace root).

When a prompt here has stayed the same across two or three repos, promote it: make it a skill, or
have a generator emit it. A generator does not forget.

## Do not move this repo without re-pointing the links

**The links point into this checkout, so moving or renaming it breaks them — silently.**
A dangling symlink reads as a *missing file*, and a missing global `CLAUDE.md` is not an error: every
Claude session on this machine would simply run without these standing preferences, and nothing would
say so. That is the whole hazard — it does not announce itself, and you would notice only by
wondering why the assistant stopped following rules you thought were loaded.

Near-miss on 2026-08-04: this repo was a candidate for being moved into a managed workspace, which
would have done exactly that. It stayed put — see below — but if you ever do move it:

1. **Before the move,** from the old location, remove the links: `stow -D -t ~ claude zsh`.
2. Move the repo.
3. From the new location, make the links again and check them:

   ```sh
   stow -t ~ claude zsh
   for p in ~/.claude/CLAUDE.md ~/.claude/skills/writing-docs/SKILL.md ~/.config/zsh/claude.zsh; do
     test -e "$p" && echo "OK $p" || echo "MISSING $p"
   done
   ```

**Already moved without step 1?** `stow -R` does not fix it. Stow does not own the old, dangling
links, so it stops with *"existing target is not owned by stow"*. Delete the dead links that point
into this repo, then do step 3:

```sh
find ~/.claude ~/.config/zsh -maxdepth 2 -type l -lname '*dotfiles/*' ! -exec test -e {} \; -print -delete
```

The `test -e` loop is the check that matters. `readlink` prints a path whether or not anything is
there; only `test -e` proves the target actually exists.

## This repo belongs to no workspace, on purpose

It is **config, not a project**. Its subject is *this machine* — it is consumed by every session in
every repo and is a member of none of them. That puts it in the same class as the second-brain vault:
an end product that tooling references, rather than a repo a workspace tracks. So it is deliberately
absent from every `repos.yml`, and that absence is a decision, not an oversight.

The cost, stated so it is not a surprise: **nothing watches this repo.** It appears in no status
sweep and no rollup, so uncommitted changes here are invisible until you look. `git status` in this
directory is the only check there is.

## Guidelines — what belongs here, and what must NOT

These are hard-won; don't relearn them.

- **Symlink the specific *file*, never the whole `~/.claude/` directory.** That directory also holds
  `.credentials.json`, session history, statsig cache, and Claude's auto-memory
  (`~/.claude/projects/<project>/memory/`). None of that belongs in a git repo — it's secrets and
  runtime state. Version individual files (`CLAUDE.md`, and optionally `settings.json`, `commands/`,
  `agents/`), leave the rest local.

- **Auto-memory is runtime state, not config — don't version it or hand-author it.** Claude writes
  its own per-project notes under `~/.claude/projects/<project>/memory/`. That's self-generated and
  machine-local; it is *not* the same thing as the instructional `CLAUDE.md` here.

- **The global `CLAUDE.md` is a per-session tax.** It loads into the context of *every* project,
  *every* session. So the bar for putting something in it is: **true across all my repos, and worth
  paying tokens for on every invocation.** Keep it lean and stable — treat it like a shared prefix.
  - **Earns the global tier:** cross-project personal defaults (language/test/build/git idioms I use
    everywhere), environment facts (OS, shell, package manager), and working style (e.g. "direct,
    comprehensive fixes over incremental patches").
  - **Does NOT belong globally:** project architecture (that's a *per-repo* `CLAUDE.md`), long
    personality prose (low signal, paid every session), and anything secret.

- **Precedence: global is the *lowest* priority.** A project's `CLAUDE.md` (and a local-project one)
  override the global — more-specific-wins. So global rules are *defaults* any repo can quietly
  countermand; that's intended, but it's why a project can seem to "ignore" a global rule.

- **Never commit secrets.** Keep this repo (or at least anything derived from `~/.claude/`) free of
  `.credentials.json`, tokens, and keys. A private remote is a good default even so.
