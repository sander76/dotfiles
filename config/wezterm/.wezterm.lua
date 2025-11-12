local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General

config.font_size=11
config.line_height=1
config.color_scheme="tokyonight_night"

config.colors= {
  cursor_bg="#7aa2f7",cursor_border="#7aa2f7"}
config.use_fancy_tab_bar=true

-- Selection patterns
config.selection_word_boundary = ' \t\n{}[]()"\':;,│'

-- Hyperlink rules
config.hyperlink_rules = {
  -- Make files with .py extension clickable
  {
    regex = [[\b\w+\.py\b]],
    format = '$0',
  },
}

wezterm.GLOBAL.os = wezterm.GLOBAL.os or
  string.find(wezterm.target_triple, '-windows-') and 'windows' or
  string.find(wezterm.target_triple, '-apple-') and 'macos' or
  string.find(wezterm.target_triple, '-linux-') and 'linux' or
  error('Unsupported Operating System')




if wezterm.GLOBAL.os == 'windows' then
  config.default_domain = 'WSL:Ubuntu-24.04'
end

return config
