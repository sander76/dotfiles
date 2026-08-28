-- gitsigns: gutter signs, hunk actions, and blame data for lualine
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>cb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
    },
    opts = {
      current_line_blame = true,   -- must be true to populate vim.b.gitsigns_blame_line
      current_line_blame_opts = {
        virt_text = false,          -- don't render in buffer; lualine shows it instead
        delay = 500,
      },
      current_line_blame_formatter = " <author>, <author_time:%R> · <summary>",
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
    },
  },
}
