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
# Aliases - File listing (additional eza aliases)
# -----------------------------------------------------------------------------
# ls is a nushell built-in (structured output) — use `els` for eza
alias els = ^eza --icons
alias la = ^eza --long --all --icons

# -----------------------------------------------------------------------------
# Aliases - Safety (confirm before overwrite)
# -----------------------------------------------------------------------------
# rm, cp, mv are nushell built-ins — use `erm`/`ecp`/`emv` for external + interactive
alias erm = ^rm -i
alias ecp = ^cp -i
alias emv = ^mv -i

# -----------------------------------------------------------------------------
# Aliases - Utility
# -----------------------------------------------------------------------------
# grep is external, df is external — safe to alias directly
# du is a nushell built-in — use `edu` for external du
alias grep = ^grep --color=auto
alias df = ^df -h
alias edu = ^du -h
alias zshrc = nvim ~/.zshrc

# -----------------------------------------------------------------------------
# Aliases - Git shortcuts
# -----------------------------------------------------------------------------
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git pull
alias gd = git diff
alias gco = git checkout
alias gb = git branch
alias glog = git log --oneline --graph --decorate

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
path add --append ($nu.home-dir | path join "Library/Application Support/zoxide")
path add --append ($nu.home-dir | path join "Library/Application Support/nushell/plugins")
path add --append ($nu.home-dir | path join ".cargo/bin")

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
    let result = (fzf --preview "sh -c 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'" --preview-window=right:60% | complete)
    if $result.exit_code == 0 and ($result.stdout | str trim | is-not-empty) {
        nvim ($result.stdout | str trim)
    }
}

# Search file contents with ripgrep and open result in neovim at the matching line
# Usage: vg "search pattern"
# Note: Preview command uses sh -c to handle bash-style || operator
def vg [pattern: string] {
    let result = (
        rg --line-number --no-heading --color=always $pattern
        | fzf --ansi
            --delimiter ':'
            --preview "sh -c 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}'"
            --preview-window=right:60%
        | complete
    )
    if $result.exit_code == 0 and ($result.stdout | str trim | is-not-empty) {
        let selection = ($result.stdout | str trim)
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
    let result = (fd --type d | fzf --preview 'ls -la {}' | complete)
    if $result.exit_code == 0 and ($result.stdout | str trim | is-not-empty) {
        cd ($result.stdout | str trim)
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
    let result = (fd --type d | fzf | complete)
    if $result.exit_code == 0 and ($result.stdout | str trim | is-not-empty) {
        cd ($result.stdout | str trim)
    }
}

# -----------------------------------------------------------------------------
# Yazi File Manager Integration
# -----------------------------------------------------------------------------
# Open yazi and cd to its exit directory
# This allows yazi to change the shell's working directory
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
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

# Update all global npm packages to latest versions
def npmup [] {
    print "Current global packages:"
    npm list -g --depth=0

    print "\nChecking for outdated packages..."
    try { npm outdated -g } catch { }

    print "\nUpgrading outdated packages to latest..."
    let raw = (do { npm outdated -g --json } | complete | get stdout)
    let outdated = ($raw | from json)
    for pkg in ($outdated | columns) {
        let latest = ($outdated | get $pkg | get latest)
        print $"Installing ($pkg)@($latest)..."
        npm install -g $"($pkg)@($latest)"
    }
}

# Update all uv tools
def uvup [] {
    print "Installed uv tools:"
    uv tool list

    print "\nUpgrading all tools..."
    uv tool upgrade --all
}

# Update system Python packages via uv
# Auto-detects all Homebrew Python versions and updates each
def pipup [] {
    let versions = (brew list --formula | lines | where {|l| $l starts-with "python@"} | each {|l| $l | str replace "python@" ""})

    for pyver in $versions {
        print $"==> Python ($pyver)"
        uv pip list --python $pyver --system

        print "\nOutdated packages:"
        uv pip list --python $pyver --system --outdated

        let packages = (uv pip list --python $pyver --system --outdated
            | lines
            | skip 2
            | each { |line| $line | split row ' ' | first }
        )

        if ($packages | is-not-empty) {
            print $"\nUpgrading ($packages | length) packages..."
            $packages | each { |pkg|
                print $"Upgrading ($pkg)..."
                uv pip install --python $pyver --system --break-system-packages --upgrade $pkg
            }
        } else {
            print "\nAll packages are up to date."
        }
        print ""
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

# Completion for mcfg - common git subcommands
def "nu-complete mcfg" [] {
    [
        { value: "status", description: "Show working tree status" }
        { value: "add", description: "Add file contents to the index" }
        { value: "commit", description: "Record changes to the repository" }
        { value: "push", description: "Update remote refs" }
        { value: "pull", description: "Fetch and integrate with remote" }
        { value: "diff", description: "Show changes between commits" }
        { value: "log", description: "Show commit logs" }
        { value: "ls-files", description: "List tracked files" }
        { value: "ls-tree", description: "List tree objects (files in commits)" }
        { value: "checkout", description: "Switch branches or restore files" }
        { value: "branch", description: "List, create, or delete branches" }
        { value: "stash", description: "Stash changes in dirty working directory" }
        { value: "reset", description: "Reset current HEAD to specified state" }
        { value: "restore", description: "Restore working tree files" }
    ]
}

# Manage dotfiles using bare git repository
# Usage: mcfg status, mcfg add <file>, mcfg commit -m "msg", etc.
def mcfg [
    cmd: string@"nu-complete mcfg"  # Git subcommand
    ...args: string                  # Additional arguments
] {
    git --git-dir=$"($nu.home-dir)/src/personal/mac_cfg" --work-tree=$"($nu.home-dir)" $cmd ...$args
}

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

# Show memory usage (macOS)
def free [] {
    ^top -l 1 -s 0 | lines | find PhysMem
}

# Show listening ports
def ports [] {
    ^lsof -i -P -n | lines | find LISTEN
}

# Print PATH entries one per line
def show-path [] {
    $env.PATH
}

# Reload nushell config by restarting the shell
def reload [] {
    print "Restarting nushell..."
    exec nu
}

# Create directory and cd into it
def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

# Extract various archive formats
def extract [file: string] {
    if not ($file | path exists) {
        print $"'($file)' is not a valid file"
        return
    }
    if ($file | str ends-with ".tar.bz2") {
        ^tar xjf $file
    } else if ($file | str ends-with ".tar.gz") {
        ^tar xzf $file
    } else if ($file | str ends-with ".tar.xz") {
        ^tar xJf $file
    } else if ($file | str ends-with ".bz2") {
        ^bunzip2 $file
    } else if ($file | str ends-with ".rar") {
        ^unrar x $file
    } else if ($file | str ends-with ".gz") {
        ^gunzip $file
    } else if ($file | str ends-with ".tar") {
        ^tar xf $file
    } else if ($file | str ends-with ".tbz2") {
        ^tar xjf $file
    } else if ($file | str ends-with ".tgz") {
        ^tar xzf $file
    } else if ($file | str ends-with ".zip") {
        ^unzip $file
    } else if ($file | str ends-with ".Z") {
        ^uncompress $file
    } else if ($file | str ends-with ".7z") {
        ^7z x $file
    } else {
        print $"'($file)' cannot be extracted via extract"
    }
}

# -----------------------------------------------------------------------------
# System Update Functions
# -----------------------------------------------------------------------------

# Update Mac App Store apps
def masup [] {
    mas list
    mas outdated
    mas upgrade --verbose
}

# Full system update - run all updaters
def allup [] {
    print "==> Updating Homebrew packages..."
    brewup
    print "\n==> Updating Mac App Store apps..."
    masup
    print "\n==> Updating npm packages..."
    npmup
    print "\n==> Updating pip packages..."
    pipup
    print "\n==> Updating uv tools..."
    uvup
    print "\n==> Running topgrade..."
    topgup
    print "\n==> All updates complete!"
}
