# env.nu
# =============================================================================
# Nushell Environment Configuration
# Version: 0.110.0 (updated from 0.101.0)
# =============================================================================
# This file is loaded BEFORE config.nu and login.nu
# Environment variables and PATH should be configured here
# See: https://www.nushell.sh/book/configuration.html
# =============================================================================

# -----------------------------------------------------------------------------
# Carapace Completion Configuration
# -----------------------------------------------------------------------------
# Enable completion bridges for multiple shells
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# -----------------------------------------------------------------------------
# Google Cloud SDK Configuration
# -----------------------------------------------------------------------------
$env.CLOUDSDK_PYTHON = "/opt/homebrew/bin/python3"

# -----------------------------------------------------------------------------
# XDG Base Directory Specification
# -----------------------------------------------------------------------------
$env.XDG_DATA_DIRS = "/opt/homebrew/share"

# -----------------------------------------------------------------------------
# Homebrew Configuration
# -----------------------------------------------------------------------------
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"

# -----------------------------------------------------------------------------
# PATH Configuration (High Priority Items)
# -----------------------------------------------------------------------------
# Note: Additional paths are added in config.nu
# These paths need highest priority so they're set first
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend $"($env.HOME)/.local/bin"         # User local binaries (highest)
    | prepend "/opt/homebrew/sbin"               # Homebrew system binaries
    | prepend "/opt/homebrew/bin"                # Homebrew binaries
    | uniq
)

# -----------------------------------------------------------------------------
# Python Configuration
# -----------------------------------------------------------------------------
# Get Python version once and cache it to avoid slow startup
# This runs python3 to get the version for user site-packages path
let python_version = (python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" | str trim)
$env.PATH = ($env.PATH | prepend $"($env.HOME)/Library/Python/($python_version)/bin")

# pyenv configuration - manages multiple Python versions
$env.PYENV_ROOT = (^/opt/homebrew/bin/pyenv root | str trim)
$env.PATH = ($env.PATH | prepend ($env.PYENV_ROOT | path join "shims"))

# -----------------------------------------------------------------------------
# Editor Configuration
# -----------------------------------------------------------------------------
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# -----------------------------------------------------------------------------
# FZF (Fuzzy Finder) Configuration
# -----------------------------------------------------------------------------
# Default command for file search - uses fd for speed
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"

# Ctrl+T uses same command as default
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND

# Alt+C command for directory search
$env.FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git"

# Default FZF appearance options
$env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border"

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
