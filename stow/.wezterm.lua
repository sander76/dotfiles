local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General
config.font_size = 12
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

-- Open file in nvim via quick select (CTRL+SHIFT+O)
-- Matches: path/to/file.py  |  path/to/file.py:4  |  path/to/file.py:4:10
config.keys = {
    {
        key = 'o',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.QuickSelectArgs {
            label = 'open in nvim',
            patterns = {
                '[\\w./-]+\\.\\w+(?::\\d+(?::\\d+)?)?',
            },
            action = wezterm.action_callback(function(window, pane)
                local sel = window:get_selection_text_for_pane(pane)
                if not sel or sel == '' then return end
                -- Strip surrounding whitespace
                sel = sel:match('^%s*(.-)%s*$')
                -- Try file:line:col, then file:line, then bare file
                local file, line = sel:match('^(.+):(%d+):%d+$')
                if not file then
                    file, line = sel:match('^(.+):(%d+)$')
                end
                if not file then
                    file = sel
                end
                local cmd
                if line then
                    cmd = string.format('nvim +%s "%s"', line, file)
                else
                    cmd = string.format('nvim "%s"', file)
                end
                window:perform_action(
                    wezterm.action.SendString(' ' .. cmd .. '\r'),
                    pane
                )
            end),
        },
    },
}

-- Remove window padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tab title: show current folder name
wezterm.on('format-tab-title', function(tab)
    local cwd = tab.active_pane.current_working_dir
    if cwd then
        local path = cwd.file_path or tostring(cwd)
        local name = path:match('[^/\\]+[/\\]?$') or path
        -- strip trailing slash
        name = name:gsub('[/\\]$', '')
        return ' ' .. name .. ' '
    end
    return tab.active_pane.title
end)
--
-- Tabs
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32

return config
