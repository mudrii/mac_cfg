# config.nu
# =============================================================================
# Nushell Configuration File
# Version: 0.110.0 (updated from 0.101.0)
# =============================================================================
# This file is loaded after env.nu and before login.nu
# Edit with: config nu
# See: https://www.nushell.sh/book/configuration.html
# =============================================================================

# -----------------------------------------------------------------------------
# Editor Configuration
# -----------------------------------------------------------------------------
# Set nvim as the buffer editor for command line editing (Ctrl+X Ctrl+E)
$env.config.buffer_editor = "nvim"

# Disable the startup banner for cleaner terminal
$env.config.show_banner = false

# -----------------------------------------------------------------------------
# Aliases - Editor shortcuts
# -----------------------------------------------------------------------------
alias vim = nvim
alias vi = nvim
alias v = nvim
alias vimdiff = nvim -d

# Quick access to config files
# NOTE: Actual nushell config location on macOS
alias vimrc = nvim ~/.config/nvim/init.lua
alias nuconfig = nvim ("~/Library/Application Support/nushell/config.nu" | path expand)
alias nuenv = nvim ("~/Library/Application Support/nushell/env.nu" | path expand)

# -----------------------------------------------------------------------------
# Aliases - File listing with eza
# -----------------------------------------------------------------------------
# Long listing with all files, grouped directories first
alias lsa = eza --long --all --group --header --group-directories-first --sort=type --icons

# Tree view with all details
alias lta = eza --long --all --group --icons --tree .

# Simple tree view
alias lt = eza --icons --tree .

# -----------------------------------------------------------------------------
# Aliases - Package management
# -----------------------------------------------------------------------------
# Clean up Homebrew packages not in brewfile
alias brewcl = brew bundle cleanup --force --file=~/brewfile

# Run topgrade with verbose output
alias topgup = topgrade -v -c

# -----------------------------------------------------------------------------
# PATH Configuration
# -----------------------------------------------------------------------------
# Use nushell's path add utility for consistent PATH management
use std/util "path add"

# System paths (lower priority, appended)
path add --append /usr/local/bin
path add --append /System/Cryptexes/App/usr/bin
path add --append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
path add --append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
path add --append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
path add --append /Library/Apple/usr/bin

# Application-specific paths
path add --append /Applications/Wireshark.app/Contents/MacOS
path add --append "/Applications/Little Snitch.app/Contents/Components"
path add --append /opt/podman/bin
path add --append /Applications/iTerm.app/Contents/Resources/utilities

# User-specific paths
path add --append ($env.HOME | path join "Library/Application Support/zoxide")
path add --append ($env.HOME | path join "Library/Application Support/nushell/plugins")
path add --append ($env.HOME | path join ".cargo/bin")

# Deduplicate PATH entries
$env.PATH = ($env.PATH | uniq)

# -----------------------------------------------------------------------------
# External Tool Integrations
# -----------------------------------------------------------------------------
# Load Oh-My-Posh prompt
source ~/.oh-my-posh.nu

# Load Atuin - shell history with sync and search
source ~/.local/share/atuin/init.nu

# Load Zoxide - smarter cd command that learns your habits
source ~/.zoxide.nu

# Load Carapace - multi-shell completion library
source ~/.cache/carapace/init.nu

# =============================================================================
# Custom Functions
# =============================================================================

# -----------------------------------------------------------------------------
# Neovim Integration Functions
# -----------------------------------------------------------------------------

# Fuzzy find files and open in neovim
# Uses fzf with bat preview for syntax highlighting
# Note: Preview command uses sh -c to handle bash-style || operator
def vf [] {
    let file = (fzf --preview "sh -c 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'" --preview-window=right:60%)
    if ($file | is-not-empty) {
        nvim $file
    }
}

# Search file contents with ripgrep and open result in neovim at the matching line
# Usage: vg "search pattern"
# Note: Preview command uses sh -c to handle bash-style || operator
def vg [pattern: string] {
    let selection = (
        rg --line-number --no-heading --color=always $pattern
        | fzf --ansi
            --delimiter ':'
            --preview "sh -c 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}'"
            --preview-window=right:60%
    )
    if ($selection | is-not-empty) {
        let parts = ($selection | split row ':')
        let file = ($parts | get 0)
        let line = ($parts | get 1)
        # Open nvim at specific line using +line syntax
        nvim $"+($line)" $file
    }
}

# Fuzzy find directory, cd into it, and open neovim
# Useful for quickly jumping into projects
def --env vcd [] {
    let dir = (fd --type d | fzf --preview 'ls -la {}')
    if ($dir | is-not-empty) {
        cd $dir
        nvim .
    }
}

# -----------------------------------------------------------------------------
# File and Directory Functions
# -----------------------------------------------------------------------------

# List files sorted by modification time (most recent first)
# Note: Does not need --env as it doesn't modify environment
def ll [] {
    ls | sort-by modified -r
}

# Fuzzy find and cd into directory
# Uses fd for fast directory finding and fzf for selection
def --env cdf [] {
    let dir = (fd --type d | fzf)
    if ($dir | is-not-empty) {
        cd $dir
    }
}

# -----------------------------------------------------------------------------
# Package Management Functions
# -----------------------------------------------------------------------------

# Full Homebrew update workflow
# Updates, shows outdated, does dry-run, syncs with brewfile, then upgrades
def brewup [] {
    print "Updating Homebrew..."
    brew update

    print "\nOutdated packages:"
    brew outdated

    print "\nDry run of upgrades:"
    brew upgrade --greedy --dry-run

    print "\nSyncing with brewfile..."
    brew bundle --file=~/brewfile

    print "\nUpgrading packages..."
    brew upgrade --greedy
}

# Update all global npm packages
def npmup [] {
    print "Current global packages:"
    npm list -g

    print "\nUpdating global packages..."
    npm update -g --loglevel verbose
}

# Update all uv tools
def uvup [] {
    print "Installed uv tools:"
    uv tool list

    print "\nUpgrading all tools..."
    uv tool upgrade --all
}

# Update system Python packages via uv
# Note: Uses Python 3.14 - update version as needed
def pipup [] {
    const PYTHON_VERSION = "3.14"

    print $"Current packages (Python ($PYTHON_VERSION)):"
    uv pip list --python $PYTHON_VERSION --system

    print "\nOutdated packages:"
    uv pip list --python $PYTHON_VERSION --system --outdated

    # Parse outdated packages and upgrade each
    let packages = (uv pip list --python $PYTHON_VERSION --system --outdated
        | lines
        | skip 2
        | each { |line| $line | split row ' ' | first }
    )

    if ($packages | is-not-empty) {
        print $"\nUpgrading ($packages | length) packages..."
        $packages | each { |pkg|
            print $"Upgrading ($pkg)..."
            uv pip install --python $PYTHON_VERSION --system --break-system-packages --upgrade $pkg
        }
    } else {
        print "\nAll packages are up to date."
    }
}

# -----------------------------------------------------------------------------
# Python Environment Functions
# -----------------------------------------------------------------------------

# Set pyenv shell version
# Usage: pyenv shell 3.12.0
def --env "pyenv shell" [version: string] {
    $env.PYENV_VERSION = $version
}

# Unset pyenv shell version (revert to global)
def --env "pyenv shell --unset" [] {
    hide-env PYENV_VERSION
}

# -----------------------------------------------------------------------------
# Git Dotfiles Management
# -----------------------------------------------------------------------------

# Manage dotfiles using bare git repository
# Usage: mcfg status, mcfg add <file>, mcfg commit -m "msg", etc.
def mcfg [...args: string] {
    git --git-dir=$"($env.HOME)/src/personal/mac_cfg" --work-tree=$"($env.HOME)" ...$args
}
