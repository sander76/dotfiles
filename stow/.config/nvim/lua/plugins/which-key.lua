-- which-key: shows keybinding hints in a popup
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer keymaps (which-key)",
      },
    },
    opts = {
      preset = "helix",
      delay = 0, -- ms before popup appears
      triggers = {
        { "<auto>", mode = "nxso" },
        { "m", mode = "n" },  -- manual trigger: m is <Nop> (surround prefix)
        { "m", mode = "x" },  -- show ma in visual mode
      },
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>q", group = "session" },
        { "m",         group = "surround" },
        { "m",         group = "surround", mode = "x" },
      },
    },
  },
}
