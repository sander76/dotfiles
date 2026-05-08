-- Telescope – fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Native FZF sorter for faster fuzzy matching
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>d", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<C-u>"] = false,  -- clear prompt with C-u
            },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
