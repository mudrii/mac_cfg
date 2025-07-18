# make sure we have the right prompt render correctly
if ($env.config? | is-not-empty) {
    $env.config = ($env.config | upsert render_right_prompt_on_last_line true)
}

$env.POWERLINE_COMMAND = 'oh-my-posh'
$env.POSH_THEME = (echo "/Users/mudrii/.config/oh-my-posh/gruvbox.omp.json")
$env.PROMPT_INDICATOR = ""
$env.POSH_SESSION_ID = (echo "40a918d0-5900-4e6c-80a6-98a510e4d037")
$env.POSH_SHELL = "nu"
$env.POSH_SHELL_VERSION = (version | get version)

# disable all known python virtual environment prompts
$env.VIRTUAL_ENV_DISABLE_PROMPT = 1
$env.PYENV_VIRTUALENV_DISABLE_PROMPT = 1

let _omp_executable: string = (echo "/opt/homebrew/bin/oh-my-posh")

# PROMPTS

# Optional enhancement: Add error handling when Oh My Posh executable isn't found
def --wrapped _omp_get_prompt [
    type: string,
    ...args: string
] {
    if not ($_omp_executable | path exists) {
        return $"(ansi red)Error: Oh My Posh executable not found at ($_omp_executable)(ansi reset)"
    }
    
    mut execution_time = -1
    mut no_status = true
    # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
    # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
    if $env.CMD_DURATION_MS != '0823' {
        $execution_time = $env.CMD_DURATION_MS
        $no_status = false
    }

    (
        ^$_omp_executable print $type
            --save-cache
            --shell=nu
            $"--shell-version=($env.POSH_SHELL_VERSION)"
            $"--status=($env.LAST_EXIT_CODE)"
            $"--no-status=($no_status)"
            $"--execution-time=($execution_time)"
            $"--terminal-width=((term size).columns)"
            ...$args
    )
}

$env.PROMPT_MULTILINE_INDICATOR = (
    ^$_omp_executable print secondary
        --shell=nu
        $"--shell-version=($env.POSH_SHELL_VERSION)"
)

$env.PROMPT_COMMAND = {||
    # hack to set the cursor line to 1 when the user clears the screen
    # this obviously isn't bulletproof, but it's a start
    mut clear = false
    if $nu.history-enabled {
        $clear = (history | is-empty) or ((history | last 1 | get 0.command) == "clear")
    }

    if ($env.SET_POSHCONTEXT? | is-not-empty) {
        do --env $env.SET_POSHCONTEXT
    }

    _omp_get_prompt primary $"--cleared=($clear)"
}

$env.PROMPT_COMMAND_RIGHT = {|| _omp_get_prompt right }

# Optional enhancement: Add module version check function to ensure up-to-date installation
def check_omp_version [] {
    let installed_version = (^$_omp_executable --version | str trim)
    print $"Oh My Posh version: ($installed_version)"
    # You could add version checking logic here if needed
}