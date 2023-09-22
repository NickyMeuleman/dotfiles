# Dotfiles

## Housekeeping

First, fixing the weird things that annoy me.
Ranging from things that don't work correctly by default to things that are straight up broken without some intervention.

### More software

Since I'm on Fedora, I enabled [RPM Fusion](https://rpmfusion.org/).
And I set up [Flathub](https://flathub.org/nl/setup/Fedora).

I then also did the multimedia steps the RMP Fusion site has.
Apparently Fedora doesn't ship some media codecs you need to play a lot of videofiles.
https://rpmfusion.org/Howto/Multimedia

At this point, update all the things!
`sudo dnf update && sudo dnf upgrade`

### Audio

The audio was popping every time a sound starts playing similar to the sound you hear when you first plug in headphones.

To fix, I turned off power saving for the audio on my motherboard.

```sh
echo `options snd-hda-intel power_save=0` > /etc/modprobe.d/alsa-base.conf
```

### Login screen

There are 3 screens plugged into this computer:

- 2 PC monitors
- 1 TV

Either I use the 2 monitors, or the single TV.
No matter what, it showed the login screen on the TV, even when it was off.

To fix it I deleted the `~/.config/monitors.xml` file.
Then set up my monitors with the graphical Gnome tool (right click on the desktop followed by Display Settings).

This created that file again.
Then I made GDM (that's Gnome's login manager, in other words it's the screen with the password input when you boot) to use that file.

I copied the file that setting up the monitors created and made sure the `gdm` user and group owned that file.

```sh
sudo cp -v ~/.config/monitors.xml /var/lib/gdm/.config/ 
sudo chown gdm:gdm /var/lib/gdm/.config/monitors.xml
```

### Browser

Sadly, in Firefox my cursor went invisible if I dare to watch a YouTube video.
So I fell into old habits and used Google Chrome.

But the text of tab titles was blurry.

In the browser I went to `chrome://flags` and set the `Preferred Ozone platform` to `Wayland`.

### Build requirements

Similar to how I installed `build-essential` on WSL Ubuntu, Fedora needs some installed packages that are needed to build various pieces of software.

`sudo dnf install make automake gcc gcc-c++ kernel-devel cmake`

## Setup

### Version control: `git`

```sh
sudo dnf install git
```

Some default settings:

```sh
git config --global user.name "Nicky Meuleman"
git config --global user.email "nicky.dev@outlook.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
```

### Shell: `zsh`

```sh
sudo dnf install zsh
```

Change the default shell (`bash`) to `zsh` so it launches whenever you open the terminal.

```sh
chsh -s $(which zsh)
```

### Prompt: Starship

https://starship.rs/

Install using the command they provide.

No manpage, so `man starship` does not work.
See https://github.com/starship/starship/issues/2926

`starship --help` works.

`starship explain` is a handy tool that prints a quick summary of what every part of the current prompt is.

The `starship` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
starship completions zsh > $ZDIR/completions/_starship
```

### Rust language

https://www.rust-lang.org/

Install using the command they provide.

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

### Node manager: `fnm`

https://github.com/Schniz/fnm

Install using the command they provide.

No manpage, so `man fnm` does not work.

`fnm --help` works.

A tl;dr is available: `tldr fnm`

The `fnm` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
fnm completions --shell=zsh > $ZDIR/completions/_fnm
```

### Fuzzy finder: `fzf`

https://github.com/junegunn/fzf

Installed from source.
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

### Smarter `cd`: `zoxide`

https://github.com/ajeetdsouza/zoxide

Installed from source.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `cp target/release/zoxide $HOME/.local/bin/`
4. Move man page to its dedicated directory
    - `cp -r man/ $HOME/.local/share/`
5. Move completions to a directory in `$fpath`
    - `cp contrib/completions/_zoxide $ZDIR/completions/_zoxide`

Make sure to use the full name instead of the `z` alias when using it for anything other than the base jumping functionality.

`zoxide --help` works, but `z --help` does not.

zoxide integrates with `zsh-autocomplete` to show frecent (not a typo) directories when tabbing direcly after `z`.

https://github.com/ajeetdsouza/zoxide/issues/9

Pressing tab after a space triggers interactive completion (like you get when you use `zi`)
eg. `z thing ` and then tabbing triggers the interactive searcher that uses `fzf` with "thing" as query.
https://github.com/ajeetdsouza/zoxide/issues/9#issuecomment-986195030

### Document conversion tool: `pandoc`

https://github.com/jgm/pandoc

I could download the release from github and install that via these instructions:
https://github.com/jgm/pandoc/blob/main/INSTALL.md#linux

Instead I opted for convenience and installed a slightly older version with

```sh
sudo dnf install pandoc
```

### Better `find`: `fd`

https://github.com/sharkdp/fd


```sh
sudo dnf install fd-find
```

The binary name is `fd`, not `fd-find`.

### Better `make`: `just`

https://github.com/casey/just

```sh
sudo dnf install just
```

The `just` binary can generate shell completions.
Put the output for the specific shell in a file in the `$fpath`

```sh
just --completions zsh > $ZDIR/completions/_just
```

### Better `ls`: `eza`

I previously used [`exa`](https://github.com/ogham/exa), but that's unmaintained now.

https://github.com/eza-community/eza

Built from source.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - `cp target/release/eza $HOME/.local/bin/`
5. Build man pages with `just man`
5. Move man page to its dedicated directory
    - `cp target/man/eza.1 $HOME/.local/share/man/man1/`
    - `cp target/man/eza_colors.5 $HOME/.local/share/man/man5/`
    - `cp target/man/eza_colors-explanation.5 $HOME/.local/share/man/man5/`
4. Move completions to a directory in `$fpath`
    - In my case `cp completions/zsh/_eza $ZDIR/completions/`