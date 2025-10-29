# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.buffer_editor = "vim"
$env.config.show_banner = false

# aliases
alias lsa = eza --long --all --group --header --group-directories-first --sort=type --icons
alias lta = eza --long --all --group --icons --tree .
alias lt = eza --icons --tree .

# path (prepend Homebrew paths for higher priority)
use std/util "path add"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"

# path remaining custom paths after Homebrew
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | append /usr/local/bin
  | append /System/Cryptexes/App/usr/bin
  | append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
  | append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
  | append /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
  | append /Library/Apple/usr/bin
  | append /Applications/Wireshark.app/Contents/MacOS
  | append '/Applications/Little Snitch.app/Contents/Components'
  | append /opt/podman/bin
  | append /Applications/iTerm.app/Contents/Resources/utilities
  | append '/Users/mudrii/Library/Application Support/zoxide'
  | append '/Users/mudrii/Library/Application Support/nushell/plugins'
  | append /Users/mudrii/.cargo/bin
  | append /Users/mudrii/.local/bin
  | uniq # filter so the paths are unique
)

# dependencies
source ~/.oh-my-posh.nu
source ~/.local/share/atuin/init.nu
source ~/.zoxide.nu
source ~/.cache/carapace/init.nu

def allup [] {
  brew update
  brew outdated
  brew upgrade --greedy --dry-run
  mas outdated
  try { brew bundle --file=~/brewfile --force } catch { |err| print -e $err }
  brew upgrade --greedy --force
  npm ls -g
  try { npm outdated -g --depth=0 } catch { |err| print -e $err }
  npm update -g
  uv pip list
  uv pip list --outdated
  uv tool list
  uv tool upgrade --all --no-cache
}

def brewup [] { 
  brew update
  brew outdated
  brew upgrade --greedy --dry-run
  mas outdated
  try { brew bundle --file=~/brewfile --force } catch { |err| print -e $err }
  brew upgrade --greedy --force
}

def npmup [] {
  npm ls -g
  try { npm outdated -g --depth=0 } catch { |err| print -e $err }
  npm update -g
}

def pipup [] {
  uv pip list
  uv pip list --outdated
  uv tool list
  uv tool upgrade --all --no-cache
}

def mcfg [...args: string] {
    git --git-dir=$"($nu.home-path)/src/personal/mac_cfg" --work-tree=$"($nu.home-path)" ...$args
}
