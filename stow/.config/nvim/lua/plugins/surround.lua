-- mini.surround: add, delete, replace, find, highlight surrounding pairs
-- Mappings use "m" prefix (ma, md, mr, mf, mF, mh) instead of default "s"
-- The built-in "m" (set mark) is disabled to free up the prefix.
return {
  {
    "nvim-mini/mini.surround",
    version = "*", -- stable
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "ma", -- Add surrounding in Normal and Visual modes
        delete = "md", -- Delete surrounding
        find = "mf", -- Find surrounding (to the right)
        find_left = "mF", -- Find surrounding (to the left)
        highlight = "mh", -- Highlight surrounding
        replace = "mr", -- Replace surrounding
        update_n_lines = "mn", -- Update `n_lines`
      },
    },
    init = function()
      -- Disable the built-in "m" mark command to free up the prefix
      vim.keymap.set({ "n", "x" }, "m", "<Nop>", { desc = "disabled (surround prefix)" })
    end,
  },
}
