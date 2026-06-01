-- oil.nvim: edit the filesystem like a normal buffer (vim-vinegar style)
return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    lazy = false, -- loading lazily is tricky; keep it eager
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory (oil)" },
    },
    opts = {
      default_file_explorer = true, -- take over directory buffers (netrw disabled)
      watch_for_changes = true,     -- auto-reload on external filesystem changes
      columns = { "icon" },
      view_options = {
        show_hidden = false,        -- toggle with g. inside oil
        natural_order = "fast",
      },
      -- Remap <C-s> (conflicts with global save keymap) to <C-v> for vertical split
      keymaps = {
        ["<C-s>"] = false,
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
      },
      float = {
        padding = 2,
        border = "rounded",
      },
    },
    init = function()
      -- When oil deletes a file, wipe any open buffer for that file.
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.err then return end
          for _, action in ipairs(event.data.actions) do
            if action.type == "delete" and action.entry_type == "file" then
              -- Oil URLs are like "oil:///absolute/path"; strip the scheme.
              local path = action.url:gsub("^oil://", "")
              local bufnr = vim.fn.bufnr(path)
              if bufnr ~= -1 then
                vim.api.nvim_buf_delete(bufnr, { force = true })
              end
            end
          end
        end,
      })
    end,
  },
}
