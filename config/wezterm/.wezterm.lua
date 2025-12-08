local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General

config.font_size=11
config.line_height=1
config.color_scheme="tokyonight_night"

config.colors= {
  cursor_bg="#7aa2f7",cursor_border="#7aa2f7"}
-- config.use_fancy_tab_bar=true
config.window_decorations="RESIZE"
-- Selection patterns
config.quick_select_patterns = {
  "[^\\s]+\\.py(?!\\w)"
}

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

config.audible_bell = "Disabled"

-- Window dressing.
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    theme = "tokyonight_night",
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = { },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {},
    tabline_y = {},
    tabline_z = {},
  },
  extensions = {},
})

-- tabline.apply_to_config(config)


return config
