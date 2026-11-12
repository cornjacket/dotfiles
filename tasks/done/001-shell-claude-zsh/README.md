# 001 — shell/claude.zsh: Claude Code shell config

## Context

Claude Code shell config (the `claude-yolo` alias) lives untracked in `~/.zshrc`.
Move it into this repo as `shell/claude.zsh`, symlinked like the existing `claude/` entries.
Add helpers to start a "leader" session at the root of a git-workspace.

## Steps

Original prompt, verbatim:

````text
Add a shell/claude.zsh file holding Claude Code shell config, symlinked like the existing claude/ entries.

1. Create shell/claude.zsh containing the claude-yolo alias (move it from ~/.zshrc, keep its comment) and these functions:

   # List git-workspaces: repos at ~/src/<host>/<org>/<repo> that have .workspace/config.yml.
   claude-workspaces() {
     local f
     for f in $HOME/src/*/*/*/.workspace/config.yml(N); do print -r -- ${f:h:h}; done
   }

   # Leader session for a git-workspace: rooted at the workspace root, named, auto mode.
   # Usage: claude-leader [name | path] [extra claude args]
   #   no arg -> the git-workspace that contains $PWD (walks up to .workspace/config.yml)
   #   name   -> the workspace of that name from claude-workspaces
   #   path   -> that directory
   # e.g. claude-leader --continue | claude-leader personal-workspace | claude-leader ~/src/x/ws
   claude-leader() {
     local root
     if [[ -n $1 && $1 != -* ]]; then
       if [[ $1 == */* ]]; then
         root=$1
       else
         local -a hits=(${(M)${(f)"$(claude-workspaces)"}:#*/$1})
         (( $#hits == 1 )) || { echo "claude-leader: '$1' matches ${#hits} workspaces; run claude-workspaces" >&2; return 1; }
         root=$hits[1]
       fi
       shift
     else
       root=$PWD
       while [[ $root != / && ! -f $root/.workspace/config.yml ]]; do root=${root:h}; done
     fi
     [[ -f $root/.workspace/config.yml ]] || { echo "claude-leader: no git-workspace at $root" >&2; return 1; }
     cd "$root" && claude -n "leader:${root:t}" --permission-mode auto "$@"
   }

   # Tab-complete workspace names for claude-leader.
   _claude-leader() { compadd -- ${${(f)"$(claude-workspaces)"}:t} }
   (( $+functions[compdef] )) && compdef _claude-leader claude-leader

2. Symlink it: ln -sfn "$PWD/shell/claude.zsh" ~/.config/zsh/claude.zsh (create ~/.config/zsh first), and verify with test -e.
3. In ~/.zshrc, remove the claude-yolo alias and add: [ -f ~/.config/zsh/claude.zsh ] && source ~/.config/zsh/claude.zsh
   Put the line after compinit if ~/.zshrc runs compinit; otherwise the tab completion does not register.
4. Update README.md: a "What's here" row and the setup commands, in the existing style. Say that the ~/.zshrc source line is a manual step on a new machine.
5. Add a README setup note for ~/.claude/settings.json, which is not tracked because Claude Code writes to it:
   set "permissions": {"defaultMode": "auto"} so every new session starts in auto mode.
   Explain in one line why the file is a manual step and not a symlink.
6. Test in a new interactive zsh (zsh -ic '...'). Before each claude-leader call, stub claude so nothing starts:
   claude() { print -r -- "cwd=$PWD args=$*" }
   Check each case and report the output:
   a. claude-workspaces lists dev-workspace and personal-workspace, and not dev-workspace/git-workspace-test.
   b. claude-leader personal-workspace -> cwd is personal-workspace, args include -n leader:personal-workspace.
   c. From ~/src/github.com/cornjacket/dev-workspace/create-git-workspace, claude-leader --continue -> cwd is dev-workspace, args end with --continue.
   d. claude-leader no-such-ws -> the "matches 0 workspaces" error, exit status 1.
   e. From /tmp, claude-leader with no arg -> the "no git-workspace" error.
7. Commit with the repo's commit schema. Don't push.
````

Added after capture (2026-11-12):

8. Update README.md: say that `PLAN.md` and `tasks/` track work in this repo, and point to `PLAN.md` for how tasks work.
9. Add `autoload -Uz compinit && compinit` to `~/.zshrc` just before the source line, so tab completion registers.

## Verification

Step 6 of the prompt: cases a–e, run in `zsh -ic` with `claude` stubbed. Record each output under Outcome.

## Open questions

- Resolved: `~/.zshrc` did not run `compinit`, so the `compdef` guard would skip. Decision: add compinit (step 9).

## Outcome

Done 2026-11-12. Link verified with `test -e`. `~/.zshrc` backed up before the edit.

Step 6 results (`zsh -ic`, `claude` stubbed):

```text
a. /Users/david/src/github.com/cornjacket/dev-workspace
   /Users/david/src/github.com/cornjacket/personal-workspace
b. cwd=.../cornjacket/personal-workspace args=-n leader:personal-workspace --permission-mode auto
c. cwd=.../cornjacket/dev-workspace args=-n leader:dev-workspace --permission-mode auto --continue
d. claude-leader: 'no-such-ws' matches 0 workspaces; run claude-workspaces   (exit=1)
e. claude-leader: no git-workspace at /   (exit=1)
```

Extra: `_comps[claude-leader]` is `_claude-leader` (completion registered); `claude-yolo` alias loads.

