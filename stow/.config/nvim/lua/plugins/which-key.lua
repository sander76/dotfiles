-- which-key: shows keybinding hints in a popup
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 500, -- ms before popup appears
      spec = {
        -- Group labels for your existing prefixes
        { "<leader>f", group = "find (telescope)" },
        { "g",         group = "goto" },
        { "[",         group = "prev" },
        { "]",         group = "next" },
      },
    },
  },
}
