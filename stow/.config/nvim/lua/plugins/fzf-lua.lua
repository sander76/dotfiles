return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>f", function() require("fzf-lua").files() end,                desc = "Find files" },
      { "<leader>g", function() require("fzf-lua").live_grep() end,       desc = "Live grep" },
      { "<leader>b", function() require("fzf-lua").buffers() end,              desc = "Buffers" },
      { "<leader>d", function() require("fzf-lua").diagnostics_workspace() end, desc = "Diagnostics" },
      { "<leader>r", function() require("fzf-lua").resume() end,               desc = "Resume last picker" },
    },
    opts = {
      winopts = {
        border  = "rounded",
        height  = 0.85,
        width   = 0.80,
        preview = {
          border     = "rounded",
          layout     = "flex",
          flip_columns = 120,
        },
      },
    },
  },
}
