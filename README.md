# dotfiles

Version-controlled personal config, so it's backed up and portable: on a new machine,
`git clone` this repo and symlink the tracked files into place. **Edit the file here in the repo —
the live location is a symlink to it, so the two never drift.**

## What's here

| Path | Symlinked to | Purpose |
| --- | --- | --- |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | **Global** Claude Code instructions — standing preferences applied in *every* repo, every session (e.g. "lead with a one-line summary", the second-brain consult rule). |
| `claude/skills/writing-docs/` | `~/.claude/skills/writing-docs` | User-level skill for writing human-facing docs in plain technical English (word list, templates, final check). Extends the always-on style rules in `claude/CLAUDE.md`; does not repeat them. |
| `claude/prompts/` | — (not linked; open or paste) | Reusable task prompts for setting up a repo. See [New repo checklist](#new-repo-checklist). |

## Setup on a new machine

Clone anywhere, then **run this from the repo root** — it links the Claude global config to
wherever *this* checkout actually is:

```sh
ln -sfn "$PWD/claude/CLAUDE.md" ~/.claude/CLAUDE.md
test -e ~/.claude/CLAUDE.md && readlink ~/.claude/CLAUDE.md || echo DANGLING
ln -sfn "$PWD/claude/skills/writing-docs" ~/.claude/skills/writing-docs
test -e ~/.claude/skills/writing-docs/SKILL.md && echo OK || echo DANGLING
```

**Why `$PWD` and not a hardcoded path.** This README used to spell out
`~/src/github.com/cornjacket/dotfiles/...`, which is wrong the moment you clone somewhere else —
i.e. exactly the situation "setup on a new machine" describes. Deriving the path from where you are
standing cannot go stale.

**`-f` replaces, `-n` avoids nesting.** Together they make the command idempotent and remove the old
*"File exists"* gotcha: `-f` overwrites an existing link, and `-n` stops `ln` from burrowing a link
*inside* `~/.claude/CLAUDE.md` if that path is already a symlink to a directory. If the live path is
a **real file** you still want it backed up first (`cp ~/.claude/CLAUDE.md /tmp/`) — `-f` would
delete it without asking.

**Verify with `test -e`, not `readlink` alone.** `readlink` prints its target whether or not
anything is there, so it will happily confirm a link that points at nothing.

A symlink is the simplest approach and needs no tooling. If you later want a manager: **GNU Stow**
(`stow claude` from the repo root) is the lightweight fit; **chezmoi** is heavier, worth it only for
per-machine templating or secret handling.

**Why there is no `install.sh` here.** One tracked file and one link do not earn a script, and this
repo already argues against bespoke tooling — the moment a second or third file makes the manual
step tedious, the answer above is Stow, not a hand-rolled installer nobody maintains. Revisit when
the table at the top has three rows.

**The instruction cannot live in the file it installs.** Worth stating plainly, because it is the
trap: `claude/CLAUDE.md` *is* the global agent instruction file. If the link is broken or was never
made, that file is not loaded — so any "how to set up the link" guidance written inside it is
invisible in precisely the situation where it is needed. It has to live here, in the repo's README,
where a human or an agent reading the repo will find it regardless.

## New repo checklist

Run these when you start a new repo. Each line links to the tool or prompt that does the work.

1. Add the task system (`create-project-system`).
2. Add context hygiene (`create-context-hygiene`).
3. Add invariants: run [claude/prompts/working-in-this-repo.md](claude/prompts/working-in-this-repo.md).
4. Register the repo in its workspace (`make add-repo` from the workspace root).

When a prompt here has stayed the same across two or three repos, promote it: make it a skill, or
have a generator emit it. A generator does not forget.

## Do not move this repo without re-pointing the links

**The links above are absolute paths, so moving or renaming this checkout breaks them — silently.**
A dangling symlink reads as a *missing file*, and a missing global `CLAUDE.md` is not an error: every
Claude session on this machine would simply run without these standing preferences, and nothing would
say so. That is the whole hazard — it does not announce itself, and you would notice only by
wondering why the assistant stopped following rules you thought were loaded.

Near-miss on 2026-08-04: this repo was a candidate for being moved into a managed workspace, which
would have done exactly that. It stayed put — see below — but if you ever do move it:

```sh
ln -sfn <new-path>/claude/CLAUDE.md ~/.claude/CLAUDE.md   # -f replaces, -n avoids nesting into a dir
readlink ~/.claude/CLAUDE.md                              # must print the NEW path
test -e ~/.claude/CLAUDE.md && echo OK || echo DANGLING    # -e follows the link: catches a dead target
ln -sfn <new-path>/claude/skills/writing-docs ~/.claude/skills/writing-docs
test -e ~/.claude/skills/writing-docs/SKILL.md && echo OK || echo DANGLING
```

Every row in the table at the top is one link to re-point. A link you forget fails the same silent
way: the skill simply stops loading.

The last check is the one that matters. `readlink` prints a path whether or not anything is there;
only `test -e` proves the target actually exists.

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
