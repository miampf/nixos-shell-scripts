# nixos-shell-scripts
Some wasteful shell scripts I wrote to work with nixos.
Please note that they were customized for my system and may not work in your environment

## Provided scripts
`edit-nixos-config.sh` lets you edit your nixos configuration with neovim (as a user! If you need to edit as root, use sudo), commit and push changes, view the diff and rebuild your system. This requires you to have your nixos configuration set up as a flake (using `#default`). It does not take any command line arguments.

`nixos-revert-last-change.sh` lets you revert the last git commit you made after you saw a diff (hard reset!). It then allows you to force push and rebuild.

`nixos-collect-garbage.sh` is just a wrapper around `nix-collect-garbage -d`. Nothing fancy here.

## Dependencies
The scripts depend on the following programs: [gum](https://search.nixos.org/packages?channel=unstable&show=gum&from=0&size=50&sort=relevance&type=packages&query=gum), [neovim](https://search.nixos.org/packages?channel=unstable&show=neovim&from=0&size=50&sort=relevance&type=packages&query=neovim), [git](https://search.nixos.org/packages?channel=unstable&show=git&from=0&size=50&sort=relevance&type=packages&query=git) and [ripgrep](https://search.nixos.org/packages?channel=unstable&show=ripgrep&from=0&size=50&sort=relevance&type=packages&query=ripgrep). I did not provide any packaging `.nix` files because I assume a lot of people already have their own way of managing shell scripts. I did not provide a flake because I was to lazy :)
