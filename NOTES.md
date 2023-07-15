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

I installed this one from source because the version in `apt` is old.
This meant I had to copy the manpage and completions file to their correct location manually.

For some reason I can't find where the built files go when I do the `cargo install --locked bat` that's on the readme.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Change dir to `target/release`.
4. Move the executable to a directory in `$PATH`
    - In my case `mv bat $HOME/.local/bin`
5. Change dir to the location of the built output files
    - In my case `cd build/bat-c95ebc37c4f6628f/out/assets`
4. Move completions to a directory in `$fpath`
    - In my case `mv completions/bat.zsh $ZDIR/completions/_bat`
5. Move man page to its dedicated directory
    - `mv manual/bat.1 $HOME/.local/share/man/man1/bat.1`

Configure theme
https://github.com/catppuccin/bat

## Better `find`: `fd`

The version in `apt` was old.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - In my case `mv target/release/fd $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - In my case `mv contrib/completion/_fd $ZDIR/completions/_fd`
5. Move man page to its dedicated directory
    - `mv doc/fd.1 $HOME/.local/share/man/man1/fd.1`

## Document conversion tool: `pandoc`

The version in `apt` was old.

So I downloaded a release and installed that.
https://github.com/jgm/pandoc/releases
https://github.com/jgm/pandoc/blob/main/INSTALL.md

I'm on Ubuntu, not on an ARM CPU so I chose the `amd64.deb`
Installed it with:
`sudo dpkg -i pandoc-3.1.5-1-amd64.deb`

This automatically adds completions and manpages.

## Better `make`: `just`

This wasn't in `apt`, so I built it from source.
https://github.com/casey/just

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - In my case `mv target/release/just $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - In my case `mv completions/just.zsh $ZDIR/completions/_just`
    - Alternatively `just --completions zsh > $ZDIR/completions/_just`
5. Move man page to its dedicated directory
    - `mv man/just.1 $HOME/.local/share/man/man1/just.1`

## Better `ls`: `exa`

The version in `apt` did not have the `git` feature enabled.

So I cloned the repo and built the project manually.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - In my case `mv target/release/exa $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - In my case `mv completions/zsh/_exa $ZDIR/completions/_exa`
5. Build man pages with `just man`
5. Move man page to its dedicated directory
    - `mv target/man/exa.1 $HOME/.local/share/man/man1/`
    - `mv target/man/exa_colors.5 $HOME/.local/share/man/man5/`

## tealdeer `tldr`

https://github.com/dbrgn/tealdeer
Not in `apt`, build from source. (at this point I'm going to default to building tools from source tbh)
This tool accesses the community pages on https://tldr.sh/.
This is a rust version, the usual `tldr` tool is written in nodejs.

1. Clone repo and change directory into it
2. Build for release with `cargo build --release`
3. Move the executable to a directory in `$PATH`
    - In my case `mv target/release/tldr $HOME/.local/bin`
4. Move completions to a directory in `$fpath`
    - In my case `mv completion/zsh_tealdeer $ZDIR/completions/_tldr`

No manpages (but `tldr` has a `tldr` page! Hah!)