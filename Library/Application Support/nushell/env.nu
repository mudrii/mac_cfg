# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional

$env.CLOUDSDK_PYTHON = "/opt/homebrew/bin/python3" 

# pyenv configuration
$env.PYENV_ROOT = (^/opt/homebrew/bin/pyenv root | str trim)
$env.PATH = ($env.PATH | prepend ($env.PYENV_ROOT | path join "shims"))

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}