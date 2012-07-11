#!/bin/bash -e

if [[ "$SHELL" =~ bash ]]; then
  test -d ".git" || git init
  git_root=`git rev-parse --show-toplevel`
  source "$git_root/git_hooks/env_vars.sh"

  if test ! -L "$git_root/.git/hooks"; then
    test -d "$git_root/.git/hooks" && rm -rf "$git_root/.git/hooks"
    ln -s "$git_root/git_hooks" "$git_root/.git/hooks"
    echo "Git Hooks installed"
  else
    echo "Git Hooks already installed; nothing to do"
  fi
else
  echo "ERROR: Please run using bash, not $SHELL"
fi
