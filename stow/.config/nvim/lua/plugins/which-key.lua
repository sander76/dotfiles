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
        { "s", mode = "n" },  -- manual trigger: s is <Nop> (surround prefix)
        { "s", mode = "v" },  -- show sa in visual mode
      },
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>q", group = "session" },
        { "s",         group = "surround" },
        { "s",         group = "surround", mode = "v" },
      },
    },
  },
}
