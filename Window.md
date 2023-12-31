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

#### Fuzzy finder: `fzf`

https://github.com/junegunn/fzf

The version in `apt` was old, installing by cloning the git repo again.
They have a handy script that does it for us, neat!

https://github.com/junegunn/fzf#using-git

No traditional completions so it does not fill in flags.
eg. when tabbing after `fzf -`.
https://github.com/junegunn/fzf/issues/3349

Fuzzy completion can be entered while typing a command pressing tax after the trigger sequence, which is "**" by default.

eg. `vim **` and hitting tab will start a fuzzy search.
When a file is selected the "**" will be replaced with the path to that file.

You can start that fuzzy search off with a query by placing it before the trigger sequence before hitting tab. eg. `vim potatoes**` starts fzf off with "potatoes" already entered.

https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh

You can also do this with hotkeys

https://github.com/junegunn/fzf#key-bindings-for-command-line

`CTRL-t` does the almost same thing, it adds the selection to your prompt.
It does NOT start the fuzzy search off with what you already entered.

So if you did `vim pota`, hit `CTRL-t` and chose `potatoes.txt`, your final prompt would be `vim potapotatoes.txt`

The fuzzy finder uses some vim motion keys to navigate.
https://github.com/junegunn/fzf#using-the-finder

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

#### Better `find`: `fd`

https://github.com/sharkdp/fd

The version in `apt` was old.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/fd $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - `mv contrib/completion/_fd $ZDIR/completions/_fd`
5. Move man page to its dedicated directory
    - `mv doc/fd.1 $HOME/.local/share/man/man1/fd.1`

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

https://github.com/dbrgn/tealdeer

This tool accesses the community pages on https://tldr.sh/.
This is a rust version, the usual `tldr` tool is written in nodejs.

Executable named `tldr`

The version in `apt` was old.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/tldr $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - `mv completion/zsh_tealdeer $ZDIR/completions/_tldr`

No manpage (but `tldr` has a `tldr` page! Hah!)
The website functions as those docs https://dbrgn.github.io/tealdeer/

#### Better `cat`: `bat`

https://github.com/sharkdp/bat

If you installed via apt, the `bat` binary might be named `batcat`
Make `bat` available by symlinking `batcat` as `bat` into a spot that's in the PATH.

I installed this one from source because the version in `apt` is old (Sound familiar huh?).

So I built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/bat $HOME/.local/bin/`
5. Change dir to the location of the built output files
    - In my case `cd build/bat-c95ebc37c4f6628f/out/assets`
5. Move man page to its dedicated directory
    - `mv manual/bat.1 $HOME/.local/share/man/man1/bat.1`
4. Move completions to a directory in `$fpath`
    - `mv completions/bat.zsh $ZDIR/completions/_bat`

Configure theme:
https://github.com/catppuccin/bat

#### cli benchmark: `hyperfine`

https://github.com/sharkdp/hyperfine

CLI benchmarking tool. Handy for quickly benchmarking some code without having to set up a proper benchmarking suite. (eg. using hyperfine instead of `criterion` to quickly bench something in Rust)

As expected, the version in `apt` is old.
So I built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/hyperfine $HOME/.local/bin/`
4. Move man page to its dedicated directory
    - `mv doc/hyperfine.1 $HOME/.local/share/man/man1/hyperfine.1`
5. Change dir to the location of the built output files
    - In my case `cd build/hyperfine-813f970f0b8c8f10/out`
6. Move completions to a directory in `$fpath`
    - `mv _hyperfine $ZDIR/completions/_hyperfine`

#### Better `du`: `dust`

https://github.com/bootandy/dust

This wasn't in `apt` at all.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/dust $HOME/.local/bin/`
4. Move man page to its dedicated directory
    - `mv man-page/dust.1 $HOME/.local/share/man/man1/dust.1`
5. Move completions to a directory in `$fpath`
    - `mv _completions/_dust $ZDIR/completions/_dust`

#### GitHub CLI: `gh`

https://github.com/cli/cli

after installing, authenticate with
```sh
gh auth login
```

That opens the browser using `xdg-open`.
We don't have that, but these dotfiles have a commented out line to symlink `wslview` to where `xdg-open` would be so the browser opens on the Windows side.

```sh
sudo ln -s $(which wslview) /usr/local/bin/xdg-open
```

These dotfiles also provide a shortcut (`gh c`) to clone a github repo into a folder structure of OWNER/REPONAME.
Usage is either `gh c owner/repo` or `gh c repo-url`

#### `btop`

https://github.com/aristocratos/btop

Resource monitoring utility.

Same deal, old `apt` version, building from source.

They have a detailed section on how to build it in the README https://github.com/aristocratos/btop#installation

To keep consistent with other installed tools, I installed the binary in /.local/bin. (the default is /usr/local)

No manpage.
No shell completions.

#### Better `grep`: ripgrep `rg`

https://github.com/BurntSushi/ripgrep

The version in `apt` was old.

So I cloned the repo and built the project manually.

This project might be fully written in Rust, but it uses a ruby package (called gems I think) to build the manpages.
https://github.com/BurntSushi/ripgrep/blob/962d47e6a1208cf2187cd34c2a7f6cf32e2a4903/build.rs#L97C46-L97C57
So before building the project, install `asciidoctor`.

It would be way easier to download the `.deb` that's included in each release and install that using `sudo dpkg -i that.deb`, but I'm not doing that, because I'm _learning_.
https://github.com/BurntSushi/ripgrep#building

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `mv target/release/rg $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - `mv complete/_rg $ZDIR/completions/_rg`
5. Change dir to the location of the built output files
    - In my case `cd ripgrep/target/release/build/ripgrep-5edee77a49c07109/out`
6. Move man page to its dedicated directory
    - `mv rg.1 $HOME/.local/share/man/man1/rg.1`
