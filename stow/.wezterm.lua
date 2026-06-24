local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General
config.font_size = 11
config.line_height = 1
-- Disable font ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.color_scheme = "tokyonight_night"
config.colors = {
    cursor_bg = "#7aa2f7",
    cursor_border = "#7aa2f7",
}

-- Quick select patterns for Python files and ripgrep output
config.quick_select_patterns = {
    '[\\w./-]+\\.\\w+(?::\\d+(?::\\d+)?)?',
}

-- Hyperlink rules
config.hyperlink_rules = {
    {
        regex = [[\b\w+\.py\b]],
        format = '$0',
    },
}

-- OS detection
wezterm.GLOBAL.os = wezterm.GLOBAL.os or
    string.find(wezterm.target_triple, '-windows-') and 'windows' or
    string.find(wezterm.target_triple, '-apple-') and 'macos' or
    string.find(wezterm.target_triple, '-linux-') and 'linux' or
    error('Unsupported Operating System')

if wezterm.GLOBAL.os == 'windows' then
    config.default_domain = 'WSL:Ubuntu-24.04'
    config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
end


config.audible_bell = "Disabled"

-- Keybindings
-- Override only CTRL+Tab / CTRL+SHIFT+Tab so they are not eaten by
-- ActivateTabRelative and are instead forwarded to tmux as escape sequences.
config.keys = {
    -- Pass Ctrl-Tab / Ctrl-Shift-Tab through to tmux as escape sequences
    { key = 'Tab', mods = 'CTRL',       action = wezterm.action.SendString '\x1b[27;5;9~' },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[27;6;9~' },

    -- CTRL+SHIFT+F: quick-select a file/test pattern and append it quoted to the
    -- current command line.  Type a prefix first ('pt ' or 'nv '), hit this
    -- binding, pick a label, and the selection is appended quoted + executed.
    -- Quoting prevents shell-glob expansion of [params] suffixes.
    -- Patterns: path/to/file.py[:line[:col]]  |  module::test[params]
    {
        key = 'f',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.QuickSelectArgs {
            label = 'pick file/test',
            patterns = {
                '[\\w./-]+\\.\\w+(?::\\d+(?::\\d+)?)?',
                '[\\w./-]+::\\w+(?:\\[[^\\]]*\\])?',
            },
            action = wezterm.action_callback(function(window, pane)
                local sel = window:get_selection_text_for_pane(pane)
                if not sel or sel == '' then return end
                window:perform_action(
                    wezterm.action.SendString('"' .. sel .. '"\r'),
                    pane
                )
            end),
        },
    },

    -- CTRL+SHIFT+O: open file in nvim via quick select.
    -- Matches: path/to/file.py[:line[:col]]  |  module::test
    {
        key = 'o',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.QuickSelectArgs {
            label = 'open in nvim',
            patterns = {
                '[\\w./-]+\\.\\w+(?::\\d+(?::\\d+)?)?',
                '[\\w./-]+::\\w+',
            },
            action = wezterm.action_callback(function(window, pane)
                local sel = window:get_selection_text_for_pane(pane)
                if not sel or sel == '' then return end
                window:perform_action(
                    wezterm.action.SendString(string.format(' wezterm-open-nvim.zsh "%s"\r', sel)),
                    pane
                )
            end),
        },
    },
}

-- Remove window padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tabs: disabled
config.enable_tab_bar = false

-- Autostart tmux on launch (Linux/macOS)
if wezterm.GLOBAL.os ~= 'windows' then
    config.default_prog = { 'tmux', 'new-session', '-A', '-s', 'main' }
end

return config
