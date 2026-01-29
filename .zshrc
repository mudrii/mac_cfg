# ============================================================================
# ~/.zshrc - Zsh Configuration
# ============================================================================
# Optimized zsh configuration with modern tooling
# Last updated: 2025
#
# Features:
#   - Modern prompt (oh-my-posh)
#   - Smart completions (carapace)
#   - Fuzzy finding (fzf + fd)
#   - Smart directory navigation (zoxide)
#   - Enhanced history (atuin)
#   - Syntax highlighting & autosuggestions
#
# Requirements (install via Homebrew):
#   brew install zsh-syntax-highlighting zsh-autosuggestions
#   brew install fzf fd ripgrep bat eza zoxide atuin carapace oh-my-posh
# ============================================================================

# ============================================================================
# Zsh Options
# ============================================================================
# These must be set early before other configurations

# History configuration
HISTSIZE=50000                       # Lines of history to keep in memory
SAVEHIST=50000                       # Lines of history to save to file
HISTFILE=~/.zsh_history              # History file location

setopt HIST_IGNORE_DUPS              # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS          # Remove older duplicate entries
setopt HIST_IGNORE_SPACE             # Don't record entries starting with space
setopt HIST_REDUCE_BLANKS            # Remove superfluous blanks
setopt HIST_VERIFY                   # Show command before executing from history
setopt SHARE_HISTORY                 # Share history between sessions
setopt EXTENDED_HISTORY              # Record timestamp of command
setopt INC_APPEND_HISTORY            # Add commands immediately to history

# Directory navigation
setopt AUTO_CD                       # cd by typing directory name
setopt AUTO_PUSHD                    # Push directories onto stack
setopt PUSHD_IGNORE_DUPS             # Don't push duplicates
setopt PUSHD_SILENT                  # Don't print directory stack

# Globbing and patterns
setopt EXTENDED_GLOB                 # Extended globbing (#, ~, ^)
setopt NO_CASE_GLOB                  # Case-insensitive globbing
setopt GLOB_DOTS                     # Include dotfiles in globbing

# Completion behavior
setopt COMPLETE_IN_WORD              # Complete from both ends of word
setopt ALWAYS_TO_END                 # Move cursor to end after completion
setopt AUTO_MENU                     # Show completion menu on tab press
setopt NO_MENU_COMPLETE              # Don't autoselect first completion

# Miscellaneous
setopt INTERACTIVE_COMMENTS          # Allow comments in interactive shell
setopt NO_BEEP                       # Disable beep on error
setopt PROMPT_SUBST                  # Enable prompt substitution

# ============================================================================
# Completion System (must be initialized early)
# ============================================================================

# Initialize completion system before other completions load
autoload -Uz compinit

# Only regenerate .zcompdump once per day for faster startup
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completions
zstyle ':completion:*' menu select                          # Menu selection
zstyle ':completion:*' special-dirs true                    # Complete . and ..
zstyle ':completion:*' squeeze-slashes true                 # Treat // as /
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# ============================================================================
# Environment Variables
# ============================================================================

# Editor configuration (nvim as default)
export EDITOR="nvim"
export VISUAL="nvim"

# XDG directories
export XDG_DATA_DIRS="/opt/homebrew/share"

# Disable Python virtual environment prompts (oh-my-posh handles this)
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Google Cloud SDK Python
export CLOUDSDK_PYTHON="/opt/homebrew/bin/python3"

# Elixir/Erlang shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# ============================================================================
# PATH Configuration
# ============================================================================
# Use typeset -U to automatically remove duplicates

typeset -U PATH path

# Build PATH in order of priority (highest first)
path=(
    # Homebrew (highest priority)
    /opt/homebrew/bin
    /opt/homebrew/sbin

    # pyenv shims
    "$(/opt/homebrew/bin/pyenv root)/shims"

    # User local binaries
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"

    # Python user packages (dynamically detected)
    "$HOME/Library/Python/3.14/bin"
    "$HOME/Library/Python/3.13/bin"
    "$HOME/Library/Python/3.12/bin"

    # Application-specific paths
    /opt/podman/bin
    "$HOME/.cache/lm-studio/bin"
    "$HOME/Library/Application Support/zoxide"
    "$HOME/Library/Application Support/nushell/plugins"

    # System paths
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin

    # macOS Cryptex paths
    /System/Cryptexes/App/usr/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
    /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
    /Library/Apple/usr/bin

    # Application utilities
    "/Applications/Wireshark.app/Contents/MacOS"
    "/Applications/Little Snitch.app/Contents/Components"
    "/Applications/iTerm.app/Contents/Resources/utilities"

    # Keep existing PATH entries
    $path
)

export PATH

# ============================================================================
# Key Bindings
# ============================================================================

# Disable XON/XOFF flow control to free up Ctrl+Q and Ctrl+S
stty -ixon -ixoff 2>/dev/null

# Use emacs-style line editing
bindkey -e

# Better history search with arrow keys
bindkey '^[[A' history-search-backward    # Up arrow
bindkey '^[[B' history-search-forward     # Down arrow

# Word navigation (Option + Arrow on macOS)
bindkey '^[[1;3C' forward-word            # Option + Right
bindkey '^[[1;3D' backward-word           # Option + Left

# Delete word (Option + Backspace)
bindkey '^[^?' backward-kill-word         # Option + Backspace

# Home/End keys
bindkey '^[[H' beginning-of-line          # Home
bindkey '^[[F' end-of-line                # End

# Delete key
bindkey '^[[3~' delete-char               # Delete

# Kill line (Ctrl+Q as alternative to Ctrl+K)
bindkey '^Q' kill-line                    # Ctrl+Q

# ============================================================================
# FZF Configuration
# ============================================================================

# Catppuccin Macchiato theme for fzf (matches Neovim/Ghostty)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--height 40% --layout=reverse --border --info=inline"

# Use fd for faster file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Preview configuration
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' --preview-window=right:60%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -50'"

# FZF shell integration
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ============================================================================
# Aliases - File Listing (using eza)
# ============================================================================

alias ls='eza --icons'                                    # Default ls with icons
alias ll='eza --long --icons'                             # Long format
alias la='eza --long --all --icons'                       # Long format with hidden
alias lsa='eza --long --all --group --header --group-directories-first --sort=type --icons'
alias lt='eza --icons --tree'                             # Tree view
alias lta='eza --long --all --group --icons --tree'       # Tree view with details

# ============================================================================
# Aliases - Safety (confirm before overwrite)
# ============================================================================

alias rm='rm -i'                      # Confirm before removing
alias cp='cp -i'                      # Confirm before overwriting
alias mv='mv -i'                      # Confirm before overwriting

# ============================================================================
# Aliases - Directory Navigation
# ============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'                     # Go to previous directory

# ============================================================================
# Aliases - Utility
# ============================================================================

alias grep='grep --color=auto'
alias df='df -h'                      # Human readable sizes
alias du='du -h'                      # Human readable sizes
alias free='top -l 1 -s 0 | grep PhysMem'  # Memory usage on macOS
alias mkdir='mkdir -pv'               # Create parent dirs, verbose
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias path='echo $PATH | tr ":" "\n"' # Print PATH entries one per line
alias ports='lsof -i -P -n | grep LISTEN'  # Show listening ports

# ============================================================================
# Aliases - Neovim
# ============================================================================

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vimdiff='nvim -d'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias zshrc='nvim ~/.zshrc'

# ============================================================================
# Aliases - Package Management
# ============================================================================

alias brewcl='brew bundle cleanup --force --file=~/brewfile'
alias brewup='brew update && brew outdated && brew upgrade --greedy --dry-run && brew bundle --file=~/brewfile && brew upgrade --greedy'
alias masup='mas list && mas outdated && mas upgrade --verbose'
alias npmup='npm list -g && npm update -g --loglevel verbose'
alias pipup="uv pip list --python 3.14 --system && uv pip list --python 3.14 --system --outdated && uv pip list --python 3.14 --system --outdated | tail -n +3 | awk '{print \$1}' | xargs uv pip install --python 3.14 --system --break-system-packages --upgrade"
alias uvup='uv tool list && uv tool upgrade --all'
alias topgup='topgrade -v -c'

# ============================================================================
# Aliases - Git (quick shortcuts)
# ============================================================================

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# ============================================================================
# Functions
# ============================================================================

# Full system update
allup() {
    echo "==> Updating Homebrew packages..."
    brewup
    echo "\n==> Updating Mac App Store apps..."
    masup
    echo "\n==> Updating npm packages..."
    npmup
    echo "\n==> Updating pip packages..."
    pipup
    echo "\n==> Updating uv tools..."
    uvup
    echo "\n==> Running topgrade..."
    topgup
    echo "\n==> All updates complete!"
}

# yazi file manager with directory changing
y() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file "$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Fuzzy find and open file in nvim
vf() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' --preview-window=right:60%)
    [[ -n "${file}" ]] && nvim "${file}"
}

# Search with ripgrep and open at line in nvim
vg() {
    if [[ -z "$1" ]]; then
        echo "Usage: vg <search-pattern>"
        return 1
    fi
    local selection file line
    selection=$(rg --line-number --no-heading --color=always "$@" | \
        fzf --ansi -d ':' \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
            --preview-window=right:60%)
    if [[ -n "${selection}" ]]; then
        file=$(echo "${selection}" | cut -d':' -f1)
        line=$(echo "${selection}" | cut -d':' -f2)
        nvim "${file}" +"${line}"
    fi
}

# Fuzzy cd and open nvim
vcd() {
    local dir
    dir=$(fd --type d | fzf --preview 'eza --tree --color=always {} | head -50')
    [[ -n "${dir}" ]] && cd "${dir}" && nvim .
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================================================
# Tool Integrations
# ============================================================================

# Homebrew shell environment
# Note: brew shellenv is already in .zprofile for login shells
# Only run if not already set (avoids duplicate PATH entries)
[[ -z "$HOMEBREW_PREFIX" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# oh-my-posh prompt (must be after PATH setup)
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/gruvbox.omp.json)"

# zoxide (smart cd replacement)
eval "$(zoxide init zsh)"

# atuin (enhanced shell history)
eval "$(atuin init zsh)"

# carapace completions (must be after compinit)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# pyenv initialization
eval "$(pyenv init -)"

# asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# ============================================================================
# Syntax Highlighting & Autosuggestions (must be last)
# ============================================================================
# Install with: brew install zsh-syntax-highlighting zsh-autosuggestions

# Syntax highlighting (load last for best results)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Use Ctrl+Space to accept suggestion
    bindkey '^ ' autosuggest-accept
fi

# ============================================================================
# Quick Reference
# ============================================================================
#
# NAVIGATION:
#   z <dir>         Smart cd (zoxide)
#   ../.../....     Go up directories
#   -               Go to previous directory
#   y               yazi file manager
#
# FILE OPERATIONS:
#   ls/ll/la/lt     List files (eza)
#   vf              Fuzzy find and open in nvim
#   vg <pattern>    Grep and open in nvim
#   extract <file>  Extract any archive
#   mkcd <dir>      Create and cd into directory
#
# PACKAGE UPDATES:
#   allup           Update all packages
#   brewup          Update Homebrew
#   reload          Reload zshrc
#
# GIT:
#   g/gs/ga/gc/gp   Git shortcuts
#   glog            Pretty git log
#
# FZF:
#   Ctrl+T          Find files
#   Ctrl+R          Search history (atuin)
#   Alt+C           Find directories
#
# ============================================================================
