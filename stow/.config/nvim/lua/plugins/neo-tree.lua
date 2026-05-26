-- neo-tree: floating modal file explorer with live preview
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>n", "<cmd>Neotree toggle<cr>",  desc = "Toggle file tree" },
      { "<leader>N", "<cmd>Neotree reveal<cr>",  desc = "Reveal file in tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      -- Notify LSP clients when a file is renamed/moved
      event_handlers = {
        {
          event = "file_renamed",
          handler = function(args)
            Snacks.rename.on_rename_file(args.source, args.destination)
          end,
        },
        {
          event = "file_moved",
          handler = function(args)
            Snacks.rename.on_rename_file(args.source, args.destination)
          end,
        },
      },

      window = {
        position = "float",
        popup = {
          size     = { height = "80%", width = "35" },
          position = "20%", -- lean left so the preview float fits to the right
        },
        mappings = {
          -- P toggles a floating preview window to the right of the tree
          ["P"] = {
            "toggle_preview",
            config = {
              use_float       = true,
              use_snacks_image = true,
            },
          },
          ["l"] = "focus_preview",
        },
      },

      filesystem = {
        filtered_items = {
          visible      = false,
          hide_dotfiles    = false, -- show dotfiles
          hide_gitignored  = true,
        },
        follow_current_file  = { enabled = true },
        use_libuv_file_watcher = true, -- auto-refresh on external changes
        hijack_netrw_behavior  = "disabled",
      },
    },
  },
}
