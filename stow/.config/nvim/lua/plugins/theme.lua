-- Tokyo Night theme
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- before other plugins
    opts = {
      style = "night", -- night | storm | day | moon
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")

      local dark = true
      vim.keymap.set("n", "<leader>t", function()
        dark = not dark
        if dark then
          vim.o.background = "dark"
          vim.cmd.colorscheme("tokyonight")
        else
          vim.o.background = "light"
          vim.cmd.colorscheme("tokyonight-day")
        end
      end, { desc = "Toggle dark/light theme" })
    end,
  },
}
