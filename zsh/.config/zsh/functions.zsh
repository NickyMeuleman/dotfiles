function zsh_add_file() {
  [ -f "$ZDIR/$1" ] && source "$ZDIR/$1"
}

function zsh_add_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZDIR/plugins/$PLUGIN_NAME" ]; then
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ||
      zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
  else
    git clone "https://github.com/$1.git" "$ZDIR/plugins/$PLUGIN_NAME"
  fi
}

function completion_via_local() {
  # arg1: project_dir
  # absolute path to project directory
  # eg: $HOME/projects/bootandy/dust
  # arg2: relative_compfile
  # A relative path from project_dir
  # eg: completions/zsh_completions_for_dust
  # arg3: filename to rename to
  # eg: _dust
  local dir_path="$1"
  local relative_path="$2"
  local filename="$3"
  local origin_path="$dir_path/$relative_path"
  local target_path="$ZDIR/completions/$filename"

  # check if project directory exists
  if [[ ! -d "$dir_path" ]]; then
    print -ru2 "Error: project directory not found: $dir_path"
    return 1
  fi

  # check if completion file exists
  if [[ ! -f "$origin_path" ]]; then
    print -ru2 "Error: completion file not found: $origin_path"
    return 1
  fi

  # check if zsh completions dir exists.
  if [[ ! -d "$ZDIR/completions" ]]; then
    print -ru2 "Error: zsh completions directory not found: $ZDIR/completions"
    return 1
  fi

  # Copy the completion file
  if cp "$origin_path" "$target_path" 2>/dev/null; then
    print "Completion file added at: $target_path"
    return 0
  else
    print -ru2 "Error: failed to copy completion file from '$origin_path' to '$target_path'"
    return 1
  fi
}

function completion_via_tool() {
  local full_cmd="$1"
  local filename="$2"
  local target_path="$ZDIR/completions/$filename"
  local executable
  local cmd_array

  # Extract executable
  executable="${full_cmd%% *}"

  # Check if the executable exists
  if ! command -v $executable >/dev/null 2>&1; then
    print -ru2 "Command $executable not found in PATH."
    return 1
  fi

  # Split the command into an array
  cmd_array=($=full_cmd)

  # Execute the full command
  if ! "${cmd_array[@]}" >"$target_path"; then
    print -ru2 "Failed to execute: $full_cmd"
    return 1
  fi

  # Check if file was written
  if [[ ! -f "$target_path" ]]; then
    print -ru2 "Failed to write: $target_path"
    return 1
  fi

  print "Completion file added at: $target_path"
}

function install_completions() {
  completion_via_tool "bat --completion zsh" "_bat"
  completion_via_tool "fnm completions --shell=zsh" "_fnm"
  completion_via_tool "gh completion -s zsh" "_gh"
  completion_via_tool "just --completions zsh" "_just"
  completion_via_tool "kondo --completions zsh" "_kondo"
  completion_via_tool "rg --generate complete-zsh" "_rg"
  completion_via_tool "rustup completions zsh cargo" "_cargo"
  completion_via_tool "rustup completions zsh" "_rustup"
  completion_via_tool "starship completions zsh" "_starship"

  # generate file with BTM_GENERATE=true cargo build --release --locked
  completion_via_local "$HOME/projects/ClementTsang/bottom" "target/tmp/bottom/completion/_btm" "_btm"
  # No guarantee the tool version and completion version match (so build from source first)
  completion_via_local "$HOME/projects/bootandy/dust" "completions/_dust" "_dust"
  completion_via_local "$HOME/projects/eza-community/eza" "completions/zsh/_eza" "_eza"
  # This command works, but the repo has a better completions file in it you should use instead
  # see: https://github.com/sharkdp/fd/commit/ef1bfc750862b751de1e235a5bf7e112c5378187
  # completion_via_tool "fd --gen-completions zsh" "_fd"
  completion_via_local "$HOME/projects/sharkdp/fd" "contrib/completion/_fd" "_fd"
  completion_via_local "$HOME/projects/tealdeer-rs/tealdeer" "completion/zsh_tealdeer" "_tldr"
  completion_via_local "$HOME/projects/ajeetdsouza/zoxide" "contrib/completions/_zoxide" "_zoxide"
}

# overwrite fzf functions that get called by trigger-sequence tabbing
# things like `vim **<tab>` run _fzf_compgen_path()
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# $@ means all argument separated by a space
function _fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$@"
}
# `cd **<tab>` runs _fzf_compgen_dir()
function _fzf_compgen_dir() {
  fd --type directory --hidden --follow --exclude ".git" . "$@"
}
