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

  gum style \
    --foreground "#D3C6AA" --border-foreground "#A7C080" --border double \
    --align center --width 50 \
    'Edit your nixos configuration'

  # edit the config
  cd /etc/nixos
  nvim configuration.nix

  # commit the changes 
  commitmessage=$(gum input \
    --cursor.foreground "#D3C6AA" --prompt.foreground "#A7C080" \
    --prompt "Commit message: " --placeholder "message" --width 50)
  sudo git add .
  gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Commiting changes..." -- sudo git commit -m "$commitmessage"

  # get the git diff and show it
  sudo git diff HEAD~1 HEAD | gum pager --border-foreground "#A7C080" 

  gum confirm --selected.background "#A7C080" "Push changes?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Pushing changes..." -- sudo git push
  gum confirm --selected.background "#A7C080" "Rebuild system?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Rebuilding system..." --show-output -- bash -c "source $script && rebuild_system"
  # go back to initial directory
  cd - &>/dev/null
}


RUNNING="$(basename $0)"

if [[ "$RUNNING" == "edit-nixos-config.sh" ]]
then
  main
fi
