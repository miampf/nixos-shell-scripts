#!/bin/bash

function rebuild_system {
  error=$(sudo nixos-rebuild switch --flake /etc/nixos#default 2> >(rg "error: "))
  if [[ -n "$error" ]] && [[ "$error" == *"error:"* ]]; then
    echo
    gum log --level="error" "Failed to rebuild system"
    echo "$error"
  fi
}

function main {
  # get realpath of file; this is later used as a hacky way for spinning
  script=$(realpath "$0")

  cd /etc/nixos 

  gum style \
    --foreground "#D3C6AA" --border-foreground "#A7C080" --border double \
    --align center --width 50 \
    'Revert your last change to your nixos configuration'

  sudo git diff HEAD HEAD~1 | gum pager --border-foreground "#A7C080" 

  gum confirm --selected.background "#A7C080" "Revert last change?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Reverting last change..." -- sudo git reset --hard HEAD~1 || exit 1 
  gum confirm --selected.background "#A7C080" "Force push?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Force pushing changes..." -- sudo git push --force
  gum confirm --selected.background "#A7C080" "Rebuild system?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Rebuilding system..." --show-output -- bash -c "source $script && rebuild_system"

  cd - &>/dev/null
}

RUNNING="$(basename $0)"

if [[ "$RUNNING" == "nixos-revert-last-change.sh" ]]
then
  main
fi
