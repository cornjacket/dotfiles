# PLAN — dotfiles

Tracks the occasional feature work in this repo. One task = one directory.

## Where I left off

- current task — none
- next concrete step — none
- files mid-edit — none
- uncommitted / unpushed — 001 and 002 committed, not pushed
- open questions — none

## How tasks work

1. Add a task: make `tasks/open/NNN-<slug>/README.md`. NNN is the next free number across `open/` and `done/`.
2. Add a row to the task index below.
3. Finish a task: `git mv tasks/open/NNN-<slug> tasks/done/`, then set the row's status to `done`.
4. Commit the task move with the work it records.

The directory is the status. The index is a convenience; if they disagree, the directory wins.
A task README holds: **Context** (why), **Steps** (what to do), **Verification** (how to check), **Outcome** (filled in when done).

## Task index

| ID | Task | Status |
| --- | --- | --- |
| 001 | [shell/claude.zsh — Claude Code shell config](tasks/done/001-shell-claude-zsh/README.md) | done |
| 002 | [Use GNU Stow for the symlinks](tasks/done/002-stow-links/README.md) | done |

## Decisions

- Task status = directory (`open/`, `done/`), not a field in the file. Rules out status drift; `ls` shows state. Follows second-brain note `directory-structure-as-status-indicator`.
- Only two states. This repo has little feature work; `backlog/` and `in-progress/` would sit empty.
- 001: `~/.zshrc` gains `compinit` so `claude-leader` tab completion registers.
- 002: links managed by GNU Stow (`claude/`, `zsh/` packages); `prompts/` moved out so it is not linked. Rules out hand-written `ln` lists and an install script.
- PLAN.md layout matches the `/wrap` command, so `/wrap` can maintain it.
