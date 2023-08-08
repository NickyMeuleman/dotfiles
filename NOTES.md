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