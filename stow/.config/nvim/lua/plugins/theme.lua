-- Catppuccin theme
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- load at startup
    priority = 1000, -- before other plugins
    opts = {
      flavour = "mocha",
      transparent_background = false,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")

      vim.keymap.set("n", "<leader>t", function()
        if vim.o.background == "dark" then
          vim.o.background = "light"
          vim.cmd.colorscheme("catppuccin-latte")
        else
          vim.o.background = "dark"
          vim.cmd.colorscheme("catppuccin-mocha")
        end
      end, { desc = "Toggle dark/light theme" })
    end,
  },
}
