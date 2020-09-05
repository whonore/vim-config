function add_path_uniq --description "Prepend a path to PATH if it's not already there"
    for p in $argv
        if not contains $p $PATH
            set -p PATH $p
        end
    end
end

set -l FISH_HOME "$HOME/.config/fish"

# Load extra definitions
if test -f "$FISH_HOME/local.fish"
    source "$FISH_HOME/local.fish"
end

# Local bin directories
add_path_uniq "$HOME/bin" "$HOME/.local/bin"

# Rust bin directories
add_path_uniq "$HOME/.cargo/bin"

# Nix
# Generated by https://gist.github.com/sebastien/18a7eb71fdd34f6a0f825e69f9461d01
if test -d "$HOME/.nix-profile"; and test -d /nix
    source "$HOME/.config/fish/conf.d/nix.fish"
end

# Yarn
if test -d "$HOME/.yarn"
    add_path_uniq "$HOME/.yarn/bin"
end

# Pyenv
if test -d "$HOME/.pyenv"
    set PYENV_ROOT "$HOME/.pyenv"
    add_path_uniq "$PYENV_ROOT/bin"
    pyenv init - | source
    pyenv virtualenv-init - | source
end

# Pyenv
if test -d "$HOME/.rbenv"
    set RBENV_ROOT "$HOME/.rbenv"
    add_path_uniq "$RBENV_ROOT/bin"
    rbenv init - | source
end

# tlmgr
set TEXMFHOME "$HOME/.local/texmf"

# Fzf
set -x FZF_DEFAULT_COMMAND "fd --type f"
set -x FZF_DEFAULT_OPTS "--height=40% --reverse --cycle"
set FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND . \$dir"
set FZF_ALT_C_COMMAND "fd --type d . \$dir"

# Rust CLI aliases
if command -q exa
    alias ls exa
end

# Clean up
# Clean up PATH if started by nix-shell
function clean_nix_path
    set -l first_nix 1
    for idx in (seq (count $PATH))
        if string match -e -q "/nix" $PATH[$idx]
            set first_nix $idx
            break
        end
    end
    if test $first_nix -ne 1
        set -e PATH[1..(math $first_nix - 1)]
    end
end

if test -n "$IN_NIX_SHELL"
    clean_nix_path
end
functions -e add_path_uniq
functions -e clean_nix_path
