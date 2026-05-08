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
    end,
  },
}
