-- which-key: shows keybinding hints in a popup
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 100, -- ms before popup appears
      spec = {
        -- Group labels for your existing prefixes
        { "<leader>f", desc = "Find files" },
        { "<leader>g", desc = "Live grep" },
        { "<leader>b", desc = "Buffers" },
        { "<leader>d", desc = "Diagnostics" },
        { "g",         group = "goto/comment" },
        { "gc",        group = "comment" },
        { "[",         group = "prev" },
        { "]",         group = "next" },
        { "<leader>c", group = "code" },
        { "<leader>q", group = "session" },
        { "<leader>t", group = "toggle-theme" },
      },
    },
  },
}
