local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local action = wezterm.action

-- color scheme
-- config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Catppuccin Mocha'

-- font
config.font = wezterm.font_with_fallback({
    { family = 'JetBrains Mono' },
    { family = 'Symbols Nerd Font  Mono', scale = 0.8 },
})

-- font size
config.font_size = 14
config.line_height = 1.05

-- scrollback lines
config.scrollback_lines = 100000

  -- scrollbar
config.enable_scroll_bar = true

-- tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true

-- window
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  }
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

-- inactive panes
config.inactive_pane_hsb = {
    saturation = 0.24,
    brightness = 0.5
  }
  
-- behaviours
config.automatically_reload_config = true
config.exit_behavior = "CloseOnCleanExit" -- if the shell program exited with a successful status
config.status_update_interval = 1000


return config