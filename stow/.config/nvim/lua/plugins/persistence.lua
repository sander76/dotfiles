-- Session management: auto-save on exit, manual restore
return {
  {
    "folke/persistence.nvim",
    lazy = false, -- load immediately so keymaps are available before opening any file
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true, -- use git branch in session filename
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- Load the session for the current directory
      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end, { desc = "Restore session (current dir)" })

      -- Select a session to load
      vim.keymap.set("n", "<leader>qS", function()
        require("persistence").select()
      end, { desc = "Select session" })

      -- Load the last session
      vim.keymap.set("n", "<leader>ql", function()
        require("persistence").load({ last = true })
      end, { desc = "Restore last session" })

      -- Stop persistence (session won't be saved on exit)
      vim.keymap.set("n", "<leader>qd", function()
        require("persistence").stop()
      end, { desc = "Stop session persistence" })
    end,
  },
}
