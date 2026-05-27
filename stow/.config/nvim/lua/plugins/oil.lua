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
  },
}
