-- nvim-tree: file explorer sidebar
return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>n",  "<cmd>NvimTreeToggle<cr>",   desc = "Toggle file tree" },
      { "<leader>N",  "<cmd>NvimTreeFindFile<cr>", desc = "Reveal file in tree" },
    },
    init = function()
      -- Notify LSP clients when a file is renamed/moved via nvim-tree
      local prev = { new_name = "", old_name = "" }
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              prev = { new_name = data.new_name, old_name = data.old_name }
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })
    end,
    opts = {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 32,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
  },
}
