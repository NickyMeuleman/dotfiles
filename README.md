# Dotfiles

## Setup

### Windows side

- Install the [Windows Terminal](https://github.com/microsoft/terminal)

Set it as [default terminal application](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup#default-terminal-application) in the settings (need the GUI as this is an OS setting) under startup.
Theme it: [Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal)

- Install [git](https://git-scm.com/) for Windows

Store your credentials so you aren't asked for your password every time you try to push to a github repo.either do it manually, or do it once and let the GCM do the work for you.
https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git

Manually: Add a "Windows Credential" to the credential manager:
- Search for "credential manager" in control panel
- Add a new entry under "Windows Credentials"
    - internet or network address: git:https://github.com
    - username: your github username
    - passworde: a [github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

In the Windows command prompt, [install WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

The Windows Terminal now has an option to launch the Linux distro prompt.

Set it as [default profile](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup#default-profile) so that starts up when you launch Windows Terminal.

### Linux side

I chose the defaults to install WSL, so I'm on Ubuntu, and use `apt` as package manager.
Remember, for every tool here, I want all tools on the Linux side.
So if you can choose between Windows and Linux in some installation instructions, choose Linux.

#### Update all the things!

`sudo apt update`

`sudo apt upgrade`

#### git

Install with `sudo apt install git`

Some default settings
```
git config --global user.name "Nicky Meuleman"
git config --global user.email "nicky.dev@outlook.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
```

#### Install some tools other tools depend on

`sudo apt install build-essential`

`sudo apt install cmake`

`sudo apt install unzip`

#### Shell: zsh

`sudo apt install zsh`

Change the default shell (`bash`) to `zsh` so it launches whenever you open the terminal.

`chsh -s $(which zsh)`

#### Prompt: Starship

Install the `starship` prompt by following the linux install directions
https://starship.rs/

Add completions to shell by adding the output of `starship completions zsh` to a direcory in `$fpath`.
Name it underscore starship to follow conventions.

`starship completions zsh > $ZDIR/completions/_starship`

#### WSL utilities: `wslu`

https://github.com/wslutilities/wslu

Mainly used for the `wslview` tool.
These tools all have man pages, eg. `man wslvar`

##### wslview

This lets me open up links from WSL with the default Windows programs.
The dotfiles configure this so linux tools that call `xdg-open` call `wslview` instead.
This prevents a bunch of irritation when CLI tools try to automatically open websites or images

examples:
- `wslview .` opens the current directory in Windows explorer
- `wslview https://google.com` opens the default browser on the Windows side
- same pattern for other files (photos, videos, ...)

##### wslclip

While there are other ways to share the clipboard from the Linux side to the Windows side, this is handy.

Put what's in your Linux clipboard in your Windows clipboard with `wsclip`

Get what's in your Windows clipboard with the `-g` flag, example: `echo $(wslclip -g)`

##### wslfetch

It's a `neofetch` thing.
I configured it, but never use it.
It's slow and unnecessary imo.

#### Rust language

Install `rust` using the command that installs it on WSL.
Don't do the Windows one, I want my tools on the Linux side, not the Windows side.

https://www.rust-lang.org/

Add completions to shell for both `rustup` and `cargo`: `rustup help completions`

#### Node manager: `fnm`

Install `fnm`
https://github.com/Schniz/fnm

#### Smarter `cd`: `zoxide`

Install `zoxide`.
https://github.com/ajeetdsouza/zoxide

#### Better `ls`: `exa`

Install `exa`
https://github.com/ogham/exa