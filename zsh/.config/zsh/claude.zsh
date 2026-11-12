# Claude Code shell config. Sourced from ~/.zshrc via ~/.config/zsh/claude.zsh (a symlink to this file).

# Claude Code without permission prompts ("YOLO mode") — use in throwaway dirs/containers
alias claude-yolo='claude --dangerously-skip-permissions'

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
