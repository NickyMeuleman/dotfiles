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

```sh
sudo apt update && sudo apt upgrade
```

#### `git`

Install with `apt`

```sh
sudo apt install git
```

Some default settings:

```sh
git config --global user.name "Nicky Meuleman"
git config --global user.email "nicky.dev@outlook.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
```

#### Install some tools other tools depend on

```sh
sudo apt install build-essential cmake unzip
```

#### Shell: `zsh`

```sh
sudo apt install zsh
```

Change the default shell (`bash`) to `zsh` so it launches whenever you open the terminal.

```sh
chsh -s $(which zsh)
```

#### Prompt: Starship

https://starship.rs/

Install the `starship` prompt by following the linux install directions

No manpage, so `man starship` does not work.
See https://github.com/starship/starship/issues/2926

`starship --help` works.

`starship explain` is a handy tool that prints a quick summary of what every part of the current prompt is.

The `starship` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
starship completions zsh > $ZDIR/completions/_starship
```

#### WSL utilities: `wslu`

https://github.com/wslutilities/wslu

Mainly used for the `wslview` tool.

These tools all have man pages, eg. `man wslvar`

None of these tools have shell completions.

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

https://www.rust-lang.org/

Install `rustup` using the command that installs it on WSL.
Don't do the Windows one, I want my tools on the Linux side, not the Windows side.

Manpages are weird.
Cargo is under `rustup man cargo`

Trying to use it gives a usage hint that says:
```
USAGE:
    rustup man [OPTIONS] <command>
```

But I have no idea what `[OPTIONS] <command>` is, I only guessed `cargo`.

Related: https://github.com/rust-lang/rustup/issues/1729

Add completions to shell for both `rustup` and `cargo`: `rustup help completions`

```sh
rustup completions zsh > $ZDIR/completions/_rustup
rustup completions zsh cargo > $ZDIR/completions/_cargo
```

#### Node manager: `fnm`

https://github.com/Schniz/fnm

No manpage, so `man fnm` does not work.

`fnm --help` works.

A tl;dr is available: `tldr fnm`

The `fnm` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
fnm completions --shell=zsh > $ZDIR/completions/_fnm
```

#### Smarter `cd`: `zoxide`

https://github.com/ajeetdsouza/zoxide

The version in `apt` was old, I built from source.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/zoxide $HOME/.local/bin/`
4. Move man page to its dedicated directory
    - `mv -r man/ $HOME/.local/share/`
5. Move completions to a directory in `$fpath`
    - `mv contrib/completions/_zoxide $ZDIR/completions/_zoxide`

Make sure to use the full name instead of the `z` alias when using it for anything other than the base jumping functionality.

`zoxide --help` works, but `z --help` does not.

zoxide integrates with `zsh-autocomplete` to show frecent (not a typo) directories when tabbing direcly after `z`.

https://github.com/ajeetdsouza/zoxide/issues/9

Pressing tab after a space triggers interactive completion (like you get when you use `zi`)
eg. `z thing ` and then tabbing triggers the interactive searcher that uses `fzf` with "thing" as query.
https://github.com/ajeetdsouza/zoxide/issues/9#issuecomment-986195030

#### Document conversion tool: `pandoc`

https://github.com/jgm/pandoc

Version in `apt` was old.

https://github.com/jgm/pandoc/blob/main/INSTALL.md#linux

This is a Haskell tool, so I used the prepackaged `.deb` to install this.

I'm on Ubuntu, not on an ARM CPU so I chose the `amd64.deb`

Installed it with:
```sh
sudo dpkg -i pandoc-3.1.5-1-amd64.deb
```

This automatically adds completions and manpages

#### Better `make`: `just`

https://github.com/casey/just

This wasn't in `apt`, so I built it from source.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/just $HOME/.local/bin`
4. Move man page to its dedicated directory
    - `mv man/just.1 $HOME/.local/share/man/man1/just.1`
5. Move completions to a directory in `$fpath`
    - `mv completions/just.zsh $ZDIR/completions/_just`
    - Alternatively generate them (see below)

The `just` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
just --completions zsh > $ZDIR/completions/_just
```

#### Better `ls`: `exa`

https://github.com/ogham/exa

The version in `apt` did not have the `git` feature enabled.

So I built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/exa $HOME/.local/bin/`
5. Build man pages with `just man`
5. Move man page to its dedicated directory
    - `mv target/man/exa.1 $HOME/.local/share/man/man1/`
    - `mv target/man/exa_colors.5 $HOME/.local/share/man/man5/`
4. Move completions to a directory in `$fpath`
    - In my case `mv completions/zsh/_exa $ZDIR/completions/_exa`

#### Simplified manpages with Tealdeer: `tldr`

Install tealdeer
https://github.com/dbrgn/tealdeer

Executable named `tldr`

#### cli benchmark: `hyperfine`

#### Better `du`: `dust`

Install `dust`
https://github.com/bootandy/dust