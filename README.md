# Development Environment Configuration

Optimized macOS development environment with Neovim, Zsh, Tmux, Nushell, and supporting tools.

**Theme:** Catppuccin Macchiato (consistent across all tools)

---

## Table of Contents

- [Core Tools](#core-tools)
  - [Neovim](#neovim)
  - [Tmux](#tmux)
- [Shells](#shells)
  - [Zsh](#zsh)
  - [Nushell](#nushell)
- [Terminal & File Management](#terminal--file-management)
  - [Ghostty Terminal](#ghostty-terminal)
  - [Yazi File Manager](#yazi-file-manager)
- [Shell Enhancements](#shell-enhancements)
  - [Atuin Shell History](#atuin-shell-history)
  - [Zoxide Smart CD](#zoxide-smart-cd)
  - [Carapace Completions](#carapace-completions)
  - [Oh-My-Posh Prompt](#oh-my-posh-prompt)
- [System Management](#system-management)
  - [Topgrade System Updater](#topgrade-system-updater)
  - [Dotfiles Management](#dotfiles-management)
- [Integration & Reference](#integration--reference)
  - [Tool Integration](#tool-integration)
  - [Quick Reference Card](#quick-reference-card)
  - [Configuration Files](#configuration-files)
  - [Dependencies](#dependencies)
  - [Node.js Version Management (asdf)](#nodejs-version-management-asdf)
  - [Brewfile](#brewfile)

---

# Core Tools

## Neovim

**Config:** `~/.config/nvim/init.lua` | **Plugin Manager:** lazy.nvim | **Leader Key:** `Space`

### Plugin Management

| Command | Description |
|---------|-------------|
| `:Lazy` | Open lazy.nvim UI |
| `:Lazy update` | Update all plugins |
| `:Lazy sync` | Install/clean/update plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy health` | Check plugin health |

### File Navigation

| Shortcut | Description |
|----------|-------------|
| `<C-n>` | Toggle nvim-tree file explorer |
| `<C-p>` | Find files (fzf) |
| `<leader>e` | Focus nvim-tree |
| `<leader>ff` | Find files (fzf) |
| `<leader>fg` | Grep in files (fzf + ripgrep) |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find in history |
| `<leader>mp` | Markdown preview (Glow) |

### Markdown Preview (Glow)

| Command | Description |
|---------|-------------|
| `:Glow` | Preview current markdown file |
| `:Glow!` | Close preview window |
| `<leader>mp` | Preview markdown (keymap) |
| `q` | Close Glow window |

### nvim-tree (File Explorer)

| Shortcut | Description |
|----------|-------------|
| `o` / `<CR>` | Open file/expand directory |
| `<Tab>` | Preview file |
| `a` | Create file/directory |
| `d` | Delete file/directory |
| `r` | Rename |
| `x` / `c` / `p` | Cut / Copy / Paste |
| `y` / `Y` / `gy` | Copy name / relative path / absolute path |
| `I` / `H` | Toggle hidden files / dotfiles |
| `R` | Refresh |
| `q` / `?` | Close / Show help |

### Git Integration

| Shortcut | Description |
|----------|-------------|
| `<leader>gs` | Git status (fugitive) |
| `<leader>gh` / `<leader>gu` | Get diff from right / left (merge conflicts) |
| `]c` / `[c` | Next / Previous git hunk |
| `<leader>hs` / `<leader>hr` | Stage / Reset hunk |
| `<leader>hS` / `<leader>hR` | Stage / Reset buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>tb` / `<leader>td` | Toggle line blame / deleted |
| `<leader>hd` | Diff this |

### Git Commands (Fugitive)

| Command | Description |
|---------|-------------|
| `:G` or `:Git` | Open git status (interactive) |
| `:Gwrite` / `:Gread` | Stage / Checkout current file |
| `:Gcommit` / `:Gpush` / `:Gpull` | Commit / Push / Pull |
| `:Gblame` / `:Gdiff` / `:Glog` | Blame / Diff / History |

### LSP (Language Server Protocol)

| Shortcut | Description |
|----------|-------------|
| `gd` / `gD` | Go to definition / declaration |
| `gy` / `gi` / `gr` | Go to type definition / implementation / references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>lf` | Format buffer |
| `[d` / `]d` | Previous / Next diagnostic |
| `<leader>ld` / `<leader>lq` | Show diagnostic / Diagnostics to location list |

### Autocompletion (nvim-cmp)

| Shortcut | Description |
|----------|-------------|
| `<C-Space>` | Trigger completion |
| `<Tab>` / `<S-Tab>` | Next / Previous item |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

### Buffers, Tabs & Splits

| Shortcut | Description |
|----------|-------------|
| `<leader>bp` / `<leader>bn` | Previous / Next buffer |
| `<leader>bl` / `<leader>bd` | List / Close buffer |
| `<leader>tn` / `<leader>tc` / `<leader>tt` | New / Close / Next tab |
| `<leader>to` / `<leader>tm` | Close other tabs / Move tab |
| `<leader>sv` / `<leader>sh` | Vertical / Horizontal split |
| `<C-h/j/k/l>` | Navigate panes |

### Editing

| Shortcut | Description |
|----------|-------------|
| `gcc` / `gc{motion}` / `gc` | Comment line / motion / selection (native Neovim 0.10+, enhanced by ts-comments.nvim) |
| `<leader>i` | Fix indentation |
| `<leader><space>` | Clear search highlighting |
| `<leader>sp` | Toggle spell check |
| `<F5>` | Toggle undo tree |
| `<leader>W` | Sudo save |

### Autopairs (nvim-autopairs)

Auto-closes brackets, quotes, and parentheses in insert mode:

| Input | Result |
|-------|--------|
| `(` | `()` |
| `[` | `[]` |
| `{` | `{}` |
| `"` | `""` |
| `'` | `''` |

Treesitter-aware (won't pair inside strings/comments). Integrates with nvim-cmp to auto-add parentheses after function completions.

### Formatting (conform.nvim)

Format-on-save is enabled via conform.nvim with LSP fallback.

| Command | Description |
|---------|-------------|
| `:ConformInfo` | Show active formatters for current buffer |

| Language | Formatter |
|----------|-----------|
| Lua | stylua |
| JS/TS/JSON/YAML/HTML/CSS | prettier |
| Python | black |
| Shell/Bash | shfmt |

Install formatters via Mason: `:MasonInstall stylua prettier black shfmt`

### Clipboard

Clipboard is synced automatically with `clipboard = "unnamed,unnamedplus"`.

| Shortcut | Description |
|----------|-------------|
| `y` | Copy to system clipboard (auto-sync) |
| `p` | Paste from system clipboard (auto-sync) |
| `d`, `x`, `c` | Also sync with clipboard |

### Code Folding

| Shortcut | Description |
|----------|-------------|
| `za` | Toggle fold under cursor |
| `zc` / `zo` | Close / Open fold |
| `zM` / `zR` | Close / Open all folds |

### FZF (Inside fzf Window)

| Shortcut | Description |
|----------|-------------|
| `<C-t>` / `<C-x>` / `<C-v>` | Open in new tab / horizontal / vertical split |
| `<C-j>` / `<C-k>` | Navigate results |

---

## Tmux

**Config:** `~/.config/tmux/tmux.conf` | **Prefix:** `Ctrl-a` | **Theme:** Catppuccin Macchiato

### General

| Shortcut | Description |
|----------|-------------|
| `<prefix> r` | Reload config |
| `<prefix> <C-a>` | Switch to last window |
| `<prefix> a` | Send Ctrl-a to application |

### Windows

| Shortcut | Description |
|----------|-------------|
| `<prefix> c` | New window (in current path) |
| `<prefix> ,` | Rename window |
| `<prefix> n` / `<prefix> p` | Next / Previous window |
| `<prefix> <C-h>` / `<prefix> <C-l>` | Select window left / right |
| `<prefix> &` | Kill window |
| `<prefix> 1-9` | Select window by number |

### Panes

| Shortcut | Description |
|----------|-------------|
| `<prefix> -` / `<prefix> =` | Split horizontal / vertical |
| `<prefix> h/j/k/l` | Navigate panes (vim-style) |
| `<prefix> H/J/K/L` | Resize panes |
| `<prefix> <` / `<prefix> >` | Swap pane up / down |
| `<prefix> x` / `<prefix> z` | Kill pane / Toggle zoom |
| `<prefix> m` / `<prefix> !` | Maximize pane / Break to new window |

### Sessions

| Shortcut | Description |
|----------|-------------|
| `<prefix> S` / `<prefix> N` | Choose / New session |
| `<prefix> $` / `<prefix> X` | Rename / Kill session |
| `<prefix> d` | Detach |
| `<prefix> (` / `<prefix> )` | Previous / Next session |
| `<prefix> <C-f>` | Find session |

### Copy Mode (Vi-style)

| Shortcut | Description |
|----------|-------------|
| `<prefix> Escape` | Enter copy mode |
| `v` / `<C-v>` | Begin / Rectangle selection |
| `y` | Copy selection (to clipboard) |
| `/` / `?` | Search forward / backward |
| `Escape` | Cancel |

### Plugins (TPM)

| Shortcut | Description |
|----------|-------------|
| `<prefix> I` / `<prefix> U` | Install / Update plugins |
| `<prefix> <Alt-u>` | Remove unused plugins |
| `<prefix> <C-s>` / `<prefix> <C-r>` | Save / Restore session |

---

# Shells

## Zsh

**Config:** `~/.zshrc` | **Prompt:** oh-my-posh (gruvbox theme)

### Key Bindings

| Shortcut | Description |
|----------|-------------|
| `<Up>` / `<Down>` | History search backward / forward |
| `<Option-Right>` / `<Option-Left>` | Forward / Backward word |
| `<Option-Backspace>` | Delete word backward |
| `<Home>` / `<End>` | Beginning / End of line |
| `<Ctrl-Space>` | Accept autosuggestion |

### Aliases

| Category | Alias | Description |
|----------|-------|-------------|
| **Navigation** | `..` / `...` / `....` | Go up 1/2/3 directories |
| | `-` | Previous directory |
| | `z <dir>` | Smart cd (zoxide) |
| | `y` | Yazi file manager |
| **Listing (eza)** | `ls` / `ll` / `la` | List / Long / All files |
| | `lsa` / `lt` / `lta` | Detailed / Tree / Tree detailed |
| **Safety** | `rm` / `cp` / `mv` | With confirmation |
| **Editor** | `vim` / `vi` / `v` | Open Neovim |
| | `vimrc` / `zshrc` | Edit configs |
| **Git** | `g` / `gs` / `ga` / `gc` | git / status / add / commit |
| | `gp` / `gl` / `gd` / `gco` | push / pull / diff / checkout |
| | `gb` / `glog` | branch / pretty log |
| **Updates** | `brewup` | Full Homebrew update cycle |
| | `npmup` | Update global npm packages to latest (JSON-based) |
| | `pipup` | Update system pip packages for all Python versions |
| | `uvup` / `topgup` | Update uv tools / Run topgrade |
| | `brewcl` | Clean Homebrew |
| | `masup` | Update Mac App Store apps |
| | `allup` | Run all updaters |

### Functions

| Function | Description |
|----------|-------------|
| `vf` | Fuzzy find file and open in nvim |
| `vg <pattern>` | Grep and open result in nvim |
| `vcd` | Fuzzy cd and open nvim |
| `cdf` | Fuzzy find and cd into directory (no editor) |
| `mkcd <dir>` | Create directory and cd into it |
| `extract <file>` | Extract any archive format |
| `dot <args>` | Dotfiles management via bare git repo |

### FZF Shortcuts

| Shortcut | Description |
|----------|-------------|
| `<Ctrl-T>` | Find files |
| `<Ctrl-R>` | Search history (atuin) |
| `<Alt-C>` | Find directories |

---

## Nushell

**Config:** `~/Library/Application Support/nushell/` | **Prompt:** oh-my-posh

### Configuration Files

| File | Description |
|------|-------------|
| `env.nu` | Environment variables, PATH setup |
| `config.nu` | Aliases, functions, integrations |

### Aliases

| Category | Alias | Description |
|----------|-------|-------------|
| **Listing (eza)** | `els` / `la` | List with icons / Long all files |
| | `lsa` / `lt` / `lta` | Detailed / Tree / Tree detailed |
| **Safety** | `erm` / `ecp` / `emv` | External rm/cp/mv with confirmation |
| **Editor** | `vim` / `vi` / `v` | Open Neovim |
| | `vimrc` / `zshrc` | Edit nvim/zsh configs |
| | `nuconfig` / `nuenv` | Edit nushell configs |
| **Utility** | `grep` / `df` / `edu` | Colored grep / human df / external du |
| **Git** | `g` / `gs` / `ga` / `gc` | git / status / add / commit |
| | `gp` / `gl` / `gd` / `gco` | push / pull / diff / checkout |
| | `gb` / `glog` | branch / pretty log |
| **Updates** | `brewup` | Full Homebrew update cycle |
| | `npmup` | Update global npm packages to latest (JSON-based) |
| | `pipup` | Update system pip packages for all Python versions |
| | `uvup` / `topgup` / `brewcl` | Update uv tools / topgrade / clean brew |
| | `masup` / `allup` | Update App Store / Run all updaters |

> **Note:** Nushell built-in commands (`ls`, `rm`, `cp`, `mv`, `du`) are preserved.
> External equivalents use the `e` prefix (`els`, `erm`, `ecp`, `emv`, `edu`).

### Functions

| Function | Description |
|----------|-------------|
| `vf` / `vg <pattern>` / `vcd` | Fuzzy find / grep / cd + nvim |
| `ll` | List files sorted by modification time (nushell-native) |
| `cdf` | Fuzzy find and cd into directory |
| `y [args]` | Yazi file manager |
| `mkcd <dir>` | Create directory and cd into it |
| `extract <file>` | Extract any archive format |
| `free` | Show memory usage (macOS) |
| `ports` | Show listening ports |
| `show-path` | Print PATH entries |
| `reload` | Restart nushell to reload config |
| `dot <args>` | Dotfiles management via bare git repo |
| `pyenv shell <ver>` | Set pyenv version |

### Environment Variables

| Variable | Value |
|----------|-------|
| `EDITOR` / `VISUAL` | nvim |
| `FZF_DEFAULT_COMMAND` | fd --type f --hidden --follow --exclude .git |
| `FZF_DEFAULT_OPTS` | --height 40% --layout=reverse --border |
| `HOMEBREW_PREFIX` | /opt/homebrew |
| `ASDF_DIR` | /opt/homebrew/opt/asdf/libexec |
| `ASDF_DATA_DIR` | ~/.asdf |

### Integrations

| Tool | Init File |
|------|-----------|
| oh-my-posh | `~/.oh-my-posh.nu` |
| atuin | `~/.local/share/atuin/init.nu` |
| zoxide | `~/.zoxide.nu` |
| carapace | `~/.cache/carapace/init.nu` |

---

# Terminal & File Management

## Ghostty Terminal

**Config:** `~/.config/ghostty/config` | **Theme:** Catppuccin Macchiato

### Settings

| Setting | Value |
|---------|-------|
| Font | MesloLGL Nerd Font Mono, 14pt |
| Cursor | Block with blink |
| Background Blur | 20 |
| Window Padding | 8px |

### Features

| Feature | Status |
|---------|--------|
| Copy on select | Enabled |
| Mouse hide while typing | Enabled |
| Window state persistence | Enabled |
| URL click to open | Enabled |
| Single instance mode | Enabled |

### Keybindings

| Shortcut | Description |
|----------|-------------|
| `Ctrl+S` (global) | Toggle quick terminal (dropdown) |

---

## Yazi File Manager

**Config:** `~/.config/yazi/` | **Theme:** Catppuccin Macchiato

### Configuration Files

| File | Description |
|------|-------------|
| `yazi.toml` | Main configuration |
| `keymap.toml` | Custom keybindings |
| `theme.toml` | Theme selection |
| `init.lua` | Lua plugins/customizations |

### Keybindings

| Shortcut | Description |
|----------|-------------|
| `j/k` / `h/l` | Navigate / Parent/enter directory |
| `<Enter>` / `<Space>` | Open file / Select |
| `y` / `d` / `p` | Yank / Delete / Paste |
| `r` / `a` / `A` | Rename / Create file / Create directory |
| `.` / `~` | Toggle hidden / Go home |
| `z` / `/` / `?` | Jump (zoxide) / Search / Help |
| `q` | Quit |
| `<C-d>` | Diff selected with hovered file |
| `c m` | Chmod on selected files |

### Plugins

| Plugin | Description |
|--------|-------------|
| `git.yazi` | Git status integration |
| `diff.yazi` | File diff viewer |
| `chmod.yazi` | Permission management |

---

# Shell Enhancements

## Atuin Shell History

**Config:** `~/.config/atuin/config.toml` | **Sync:** Enabled (api.atuin.sh)

### Settings

| Setting | Value |
|---------|-------|
| Search mode | Fuzzy |
| Filter mode | Global |
| Sync frequency | 1 hour |
| Secrets filter | Enabled |

### Keybindings

| Shortcut | Description |
|----------|-------------|
| `Ctrl+R` | Search history |
| `Up` | History search (shell up-key) |

### Filter Modes

| Mode | Description |
|------|-------------|
| `global` | All history (default) |
| `host` / `session` | Current host / session only |
| `directory` / `workspace` | Current directory / git workspace |

---

## Zoxide Smart CD

**Init:** `~/.zoxide.nu` (Nushell)

### Commands

| Command | Description |
|---------|-------------|
| `z <query>` | Jump to best match |
| `z <query1> <query2>` | Jump using multiple keywords |
| `z -` | Jump to previous directory |
| `zi` | Interactive selection with fzf |

### Examples

```bash
z myapp           # Jump to ~/projects/myapp
z work rep        # Jump to ~/documents/work/reports
zi projects       # Interactive selection
```

---

## Carapace Completions

**Init:** `~/.cache/carapace/init.nu` (Nushell)

### Features

- Multi-shell completion support (zsh, fish, bash)
- Bridges completions between shells
- Alias expansion support
- External command completions

---

## Oh-My-Posh Prompt

**Config:** `~/.config/oh-my-posh/gruvbox.omp.json` | **Init:** `~/.oh-my-posh.nu`

### Prompt Segments

| Segment | Description |
|---------|-------------|
| OS | Operating system icon |
| SSH Session | `user@hostname` in red — only visible during SSH sessions |
| Path | Current directory (full path) |
| Git | Branch, status, stash count |
| Go / Python / Ruby / Julia | Version (when in project) |
| AWS | Profile and region |

### Git Status Colors

| Color | Meaning |
|-------|---------|
| Green | Clean |
| Orange | Changes (working/staging) |
| Purple | Ahead or behind remote |
| Red-orange | Both ahead and behind |

---

# System Management

## Topgrade System Updater

**Config:** `~/.config/topgrade.toml`

### Enabled Steps

| Step | Description |
|------|-------------|
| Homebrew | Formulae and casks |
| Mac App Store | via `mas` |
| macOS System | Software updates |
| TPM | Tmux plugins |
| VS Code / Cursor | Extensions |
| pipx / pip3 / uv | Python package managers |
| npm / yarn / pnpm | Node.js package managers |
| GitHub CLI Extensions | gh extensions |
| Yazi | Plugin updates |
| gcloud | Google Cloud SDK |
| TLDR | Pages database |

**Ignored failures:** firmware, containers, gcloud, uv (flaky/network-dependent)

### Usage

```bash
topgrade              # Run all updates
topgrade -v           # Verbose mode
topgrade --dry-run    # Preview
topgrade --only brew  # Specific step only
```

---

## Dotfiles Management

Dotfiles are managed using a bare git repository.

### Commands (dot)

| Command | Description |
|---------|-------------|
| `dot status` | Show status of tracked files |
| `dot add <file>` | Track a new file |
| `dot commit -m "msg"` | Commit changes |
| `dot push` | Push to remote |
| `dot ls-files` | List all tracked files |
| `dot diff` | Show uncommitted changes |

### Tracked Files

- Shell configs: `~/.zshrc`, `~/Library/Application Support/nushell/{config,env}.nu`
- Editor: `~/.config/nvim/init.lua`, `~/.config/wezterm/wezterm.lua`
- Tool configs: `~/.config/atuin/{config,server}.toml`, `~/.config/ghostty/config`, `~/.config/yazi/`, `~/.config/topgrade.toml`, `~/.config/tmux/tmux.conf`
- Init files: `~/.oh-my-posh.nu`, `~/.zoxide.nu`, `~/.cache/carapace/init.nu`, `~/.local/share/atuin/init.nu`
- Homebrew: `~/brewfile`
- Docs: `README.md`, `VIM_README.md`

---

# Integration & Reference

## Tool Integration

### Vim-Tmux Navigator

Seamless navigation between Tmux panes and Neovim splits:

| Shortcut | Description |
|----------|-------------|
| `<C-h/j/k/l>` | Move left/down/up/right |
| `<C-\>` | Move to previous pane |

### Theme Consistency (Catppuccin Macchiato)

| Tool | Theme Source |
|------|--------------|
| Neovim | catppuccin/nvim plugin |
| Tmux | catppuccin/tmux plugin |
| Ghostty | Built-in theme |
| Yazi | catppuccin-macchiato.yazi flavor |
| FZF | Custom colors in shell config |

### Tool Interactions

| Tool | Description |
|------|-------------|
| zoxide | Smart `cd` replacement |
| atuin | Enhanced shell history with sync |
| fzf | Fuzzy finding in terminal and Neovim |
| ripgrep | Fast search used by fzf and Neovim |
| bat | Syntax-highlighted file previews |
| eza | Modern ls replacement with icons |
| carapace | Shell completion for many tools |
| yazi | File manager with shell integration |
| topgrade | Unified system updater |

---

## Quick Reference Card

### Navigation
```
<C-n>          Toggle file tree (nvim)
<C-p>          Find files (nvim)
<C-h/j/k/l>    Navigate panes (nvim/tmux)
z <dir>        Smart cd (zsh/nu)
y              Yazi file manager (zsh/nu)
```

### Editing (leader = Space)
```
gcc            Comment line (nvim)
y              Copy to clipboard (auto-sync)
p              Paste from clipboard (auto-sync)
Space+hs       Stage git hunk (nvim)
gd             Go to definition (nvim)
K              Hover docs (nvim)
Space+mp       Markdown preview (nvim)
```

### Tmux (prefix = Ctrl-a)
```
prefix c       New window
prefix -/=     Split horizontal/vertical
prefix d       Detach
prefix S       Choose session
```

### Shell (Zsh/Nushell)
```
Ctrl-T         Find files (fzf)
Ctrl-R         Search history (atuin)
Alt-C          Find directories (fzf)
vf             Find file and open in nvim
vg <pattern>   Grep and open at line
cdf            Fuzzy find and cd into directory
dot <args>    Dotfiles management
allup          Run all system updaters
brewup         Full brew update
```

### Yazi
```
j/k h/l        Navigate / Parent/enter
<Space>        Select
y/d/p          Yank/delete/paste
<C-d>          Diff files
```

---

## Configuration Files

| Tool | Location |
|------|----------|
| Neovim | `~/.config/nvim/init.lua` |
| Zsh | `~/.zshrc`, `~/.zprofile` |
| Tmux | `~/.config/tmux/tmux.conf` |
| Ghostty | `~/.config/ghostty/config` |
| Yazi | `~/.config/yazi/` |
| Atuin | `~/.config/atuin/config.toml` |
| Topgrade | `~/.config/topgrade.toml` |
| Oh-My-Posh | `~/.config/oh-my-posh/gruvbox.omp.json` |
| Nushell | `~/Library/Application Support/nushell/` |

---

## Dependencies

Install all required tools via Homebrew:

```bash
# Core tools
brew install neovim ripgrep fzf fd bat glow

# Shell enhancements
brew install zsh-syntax-highlighting zsh-autosuggestions

# Modern CLI tools
brew install eza zoxide atuin carapace oh-my-posh

# Terminal & file manager
brew install --cask ghostty
brew install yazi ffmpegthumbnailer unar jq poppler

# Multiplexer & alternative shell
brew install tmux nushell

# Python & linting
brew install uv ruff kimi-cli

# Version management
brew install asdf

# System updater
brew install topgrade

# Fonts (Nerd Fonts for icons)
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

### Node.js Version Management (asdf)

Node.js is managed via [asdf](https://asdf-vm.com/) instead of Homebrew, allowing per-project version pinning.

```bash
# Setup
brew install asdf
asdf plugin add nodejs
asdf install nodejs 22.22.0    # LTS
asdf install nodejs 25.4.0     # Current

# Set global default
asdf set -u nodejs 22.22.0

# Set per-project version (creates .tool-versions)
asdf set nodejs 22.22.0

# List installed versions
asdf list nodejs
```

asdf is configured in both shells:

**Zsh** (`~/.zshrc`):
```bash
source /opt/homebrew/opt/asdf/libexec/asdf.sh
```

**Nushell** (`env.nu`): asdf shims are prepended to PATH, with `ASDF_DIR` and `ASDF_DATA_DIR` set as environment variables. asdf shims have highest PATH priority in both shells, above Homebrew.

### Brewfile

All Homebrew packages are declared in `~/brewfile` for reproducible setup:

```bash
# Install everything from brewfile
brew bundle --file ~/brewfile

# Check if brewfile is satisfied
brew bundle check --file ~/brewfile
```

**brewfile conventions:**
- Only include explicitly needed packages, not their dependencies
- Use correct formula names (e.g., `go` not `golang`, `openssl@3` not `openssl`)
- Tap packages use full path (e.g., `oven-sh/bun/bun`)

### Regenerate Init Files

```bash
# Oh-My-Posh
oh-my-posh init nu --config ~/.config/oh-my-posh/gruvbox.omp.json --print | save -f ~/.oh-my-posh.nu

# Zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# Carapace
carapace _carapace nushell | save -f ~/.cache/carapace/init.nu

# Atuin
atuin init nu | save -f ~/.local/share/atuin/init.nu
```

---

*Last updated: February 9, 2026*
