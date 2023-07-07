## Starship

https://starship.rs/

No manpage, so `man starship` does not work.

`starship --help` works.

`starship explain` is a handy tool that prints a quick summary of what every part of the current prompt is.

## Rust

Installed via `rustup`
Manpages can only be accessed from `rustup` and not directly.
eg. `rustup man cargo` instead of `man cargo`

related issue: https://github.com/rust-lang/rustup/issues/1729

## `fnm`

No manpage, so `man fnm` does not work.

`fnm --help` works.

## `zoxide`

Make sure to use the full name instead of the `z` alias when using it for anything other than the base jumping functionality.

`zoxide --help` works, but `z --help` does not.

No traditional completions so it does not fill in flags.
eg. when tabbing after `zoxide -`.

But it does integrate with `zsh-autocomplete` to show frecent (not a typo) directories when tabbing direcly after `z`.

https://github.com/ajeetdsouza/zoxide/issues/9

Pressing tab after a space triggers interactive completion (like you get when you use `zi`)
eg. `z thing ` and then tabbing triggers the interactive searcher that uses `fzf` with "thing" as query.
https://github.com/ajeetdsouza/zoxide/issues/9#issuecomment-986195030

## `fzf`

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

#### Better `cat`: `bat`

Install `bat`
https://github.com/sharkdp/bat

If you installed via apt, the `bat` binary might be named `batcat`
Make `bat` available by symlinking `batcat` as `bat` into a spot that's in the PATH

Configure theme
https://github.com/catppuccin/bat