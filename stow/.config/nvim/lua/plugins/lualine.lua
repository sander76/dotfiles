-- lualine: statusline
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme                = "catppuccin-nvim",
        globalstatus         = true,   -- single statusline across all splits
        section_separators   = "",
        component_separators = "",
      },
      winbar = {
        lualine_a = { { "filename", path = 1 } },
      },
      inactive_winbar = {
        lualine_a = { { "filename", path = 1 } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },  -- relative path
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
