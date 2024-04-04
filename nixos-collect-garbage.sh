#!/bin/bash

gum style \
    --foreground "#D3C6AA" --border-foreground "#A7C080" --border double \
    --align center --width 50 \
    'Clean up your system'

if [ "$EUID" -ne 0 ]
  then gum log --level="error" "Please run as root" 
  exit
fi

gum confirm --selected.background "#A7C080" "Clean system?" && gum spin --spinner pulse --spinner.foreground "#A7C080" --title "Cleaning system and collecting garbage..." -- nix-collect-garbage -d
