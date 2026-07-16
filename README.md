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
