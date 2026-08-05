# dotfiles

Version-controlled personal config, so it's backed up and portable: on a new machine,
`git clone` this repo and symlink the tracked files into place. **Edit the file here in the repo —
the live location is a symlink to it, so the two never drift.**

## What's here

| Path | Symlinked to | Purpose |
| --- | --- | --- |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | **Global** Claude Code instructions — standing preferences applied in *every* repo, every session (e.g. "lead with a one-line summary", the second-brain consult rule). |

## Setup on a new machine

Clone, then symlink each tracked file to its live location. For the Claude global config:

```sh
ln -s ~/src/github.com/cornjacket/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**Gotcha:** `ln -s` fails with *"File exists"* if the live path is already a real file. Back it up
and remove it first (`mv ~/.claude/CLAUDE.md /tmp/`), *then* symlink. Verify with
`readlink ~/.claude/CLAUDE.md` — it should print the repo path.

A symlink is the simplest approach and needs no tooling. If you later want a manager: **GNU Stow**
(`stow claude` from the repo root) is the lightweight fit; **chezmoi** is heavier, worth it only for
per-machine templating or secret handling.

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
```

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
