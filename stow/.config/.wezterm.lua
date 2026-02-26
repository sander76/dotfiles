local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General
config.font_size = 11
config.line_height = 1
config.color_scheme = "tokyonight_night"

config.colors = {
    cursor_bg = "#7aa2f7",
    cursor_border = "#7aa2f7",
    tab_bar = {
        background = "#ffffff",
        active_tab = { bg_color = "#1A1B26", fg_color = "#c0c0c0" }
    }
}

-- Quick select patterns for Python files and ripgrep output
config.quick_select_patterns = {
    "[^\\s]+\\.py(?::\\d+(?::\\d+)?)?",
    "^\\d+:.*$"
}

-- Key bindings
config.keys = {
    {
        key = 'p',
        mods = 'CTRL',
        action = wezterm.action.QuickSelectArgs {
            label = 'open file',
            patterns = config.quick_select_patterns,
            action = wezterm.action_callback(function(window, pane)
                local text = window:get_selection_text_for_pane(pane)
                if not text then
                    return
                end

                -- Check if this is a ripgrep line number match (starts with number:)
                local line_num = string.match(text, "^(%d+):")
                if line_num then
                    -- Get pane text and split into lines
                    local pane_text = pane:get_lines_as_text()
                    local lines = {}
                    for line in string.gmatch(pane_text, "[^\r\n]+") do
                        table.insert(lines, line)
                    end

                    -- Find the index of the selected line
                    local target_index = nil
                    for i, line in ipairs(lines) do
                        if line == text then
                            target_index = i
                            break
                        end
                    end

                    -- Search upwards from the target line to find a .py file path
                    local file_path = nil
                    if target_index then
                        for i = target_index - 1, 1, -1 do
                            local line = lines[i]
                            if string.match(line, "%.py$") and not string.match(line, "^%d+:") then
                                file_path = line
                                break
                            end
                        end
                    end

                    if file_path then
                        pane:send_text(' code -g ' .. file_path .. ':' .. line_num)
                    end
                elseif string.match(text, ":%d+") then
                    pane:send_text(' code -g ' .. text)
                else
                    pane:send_text(' code ' .. text)
                end
            end),
        },
    },
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
end

config.audible_bell = "Disabled"

return config
