-- mini.surround: add, delete, replace, find, highlight surroundings
-- Default mappings: sa, sd, sr, sf, sF, sh
-- "s" is remapped to <Nop> so it acts as a pure prefix (which-key shows popup)
return {
  {
    "nvim-mini/mini.surround",
    version = "*", -- stable branch
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
      -- Disable built-in "s" (substitute char, equivalent to "cl")
      -- so "s" becomes a pure prefix key for surround actions
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
  },
}
