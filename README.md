# Dotfiles

This repository contains scripts to bootstrap my Macbook, as well as initialise
and update dotfiles.

It will:
- Set some sensible MacOS Configurations (`./macOS'`)
- Install homebrew and packages (`./brew'`)
- Configure dotfiles for various apps (`./zsh`, `./vim`...)

## Running
- If you trust me, you can simply run `curl -s https://raw.githubusercontent.com/emacsified/dotfiles/main/setup.sh | bash`A

> [!WARNING]
> This script should double-check for file existence to ensure it does not clobber existing files, however this is not guaranteed.

This will run the setup script, which will:
- Prompt you for a profile - work will install the templates with `work` files overlaid, while personal will do the same with `personal` files overlaid.
- Prompt you for sudo access
- Install Homebrew
- Clone this repo to ~/.dotfiles
- Install all the packages in the `./brew` Brewfiles.
- Link brew completions and apps
- Configure ZSH and plugins
- Configure Git and config
- Configure SSH, including [GPG Signing from 1pass](#gpg-signing)
- Copy all dotfiles to the relevant locations via symlink
- Install quartz filters for PDF editing
- Hide some mac home apps
- Any profile specific setup in `./profiles/setup-work.sh`
- Prompt you to restart the terminal.

> [!NOTE]
> If you run `./setup --update`, it will not clone the repo, or prompt you to restart terminal.


## GPG signing
This script will configure GPG signing with 1password. To do this, you will need to have 1password installed and have the CLI installed.
You will also need to have a GPG key in 1password, by default under a document titled `private.key`.
This can be changed in `profiles/setup-work.sh`

## SSH Keys
This script will also configure SSH keys. You will need to have your SSH keys in 1password, by default under a document titled `ssh.key`.

## Thanks
### Dotfiles
Thanks to [Steffen Kötte](github.com/Nef10/dotfiles), [Sam Hosseini](github.com/sam-hosseini/dotfiles) and [Mathias Bynens](github.com/mathiasbynens/dotfiles) for inspiration and code snippets.
This project began as an effective fork of Steffen's dotfiles, but is under active modification.

### NVim
Thanks to [Primeagen](github.com/primeagen/init.lua), and a number of my coworkers for inspirations for the Neovim setup.


