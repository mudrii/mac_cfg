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
# Prepend homebrew share to existing XDG_DATA_DIRS (or use default if not set)
$env.XDG_DATA_DIRS = (
    "/opt/homebrew/share:" + ($env.XDG_DATA_DIRS? | default "/usr/local/share:/usr/share")
)

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
    | prepend $"($env.HOME)/.asdf/shims"        # asdf version manager shims
    | uniq
)

# -----------------------------------------------------------------------------
# asdf Version Manager Configuration
# -----------------------------------------------------------------------------
$env.ASDF_DIR = "/opt/homebrew/opt/asdf/libexec"
$env.ASDF_DATA_DIR = $"($env.HOME)/.asdf"

# -----------------------------------------------------------------------------
# GitHub Token for MCP/Copilot integrations (pulled from gh CLI auth)
# -----------------------------------------------------------------------------
$env.GITHUB_PERSONAL_ACCESS_TOKEN = (gh auth token 2>/dev/null | str trim)


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
# Python Configuration (Cached for Performance)
# -----------------------------------------------------------------------------
# Hardcode pyenv root to avoid running external command on every startup
# Update this if your pyenv root location changes
$env.PYENV_ROOT = $"($env.HOME)/.pyenv"
$env.PATH = ($env.PATH | prepend ($env.PYENV_ROOT | path join "shims"))

# Cache Python version - update when you change your default Python
# To get current version: python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
const CACHED_PYTHON_VERSION = "3.13"
$env.PATH = ($env.PATH | prepend $"($env.HOME)/Library/Python/($CACHED_PYTHON_VERSION)/bin")
