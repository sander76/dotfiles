-- Leader key (set before lazy loads plugins)
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Quick escape from insert mode
vim.keymap.set('i', 'jj', '<Esc>')

-- Save with Ctrl+S (normal, insert, and visual mode)
vim.keymap.set({ 'n', 'v' }, '<C-s>', '<cmd>w<cr>',      { desc = 'Save file' })
vim.keymap.set('i',          '<C-s>', '<cmd>w<cr><Esc>', { desc = 'Save file' })

-- Disable F1 help key (avoid accidental help window)
vim.keymap.set({ 'n', 'i', 'v' }, '<F1>', '<Nop>')

-- Exit terminal insert mode with Esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal insert mode' })

-- General options
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.signcolumn     = "yes"

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true

vim.opt.wrap           = false
vim.opt.scrolloff      = 8
vim.opt.cursorline     = true


vim.opt.splitright     = true
vim.opt.splitbelow     = true

vim.opt.ignorecase     = true
vim.opt.smartcase      = true

vim.opt.undofile       = true
vim.opt.swapfile       = false
vim.opt.confirm        = true   -- ask to save instead of erroring on :q

vim.opt.clipboard      = "unnamedplus"  -- sync with system clipboard
vim.opt.termguicolors  = true
vim.opt.updatetime     = 250
vim.opt.winborder      = "rounded"  -- rounded borders for all floating windows

-- Disable unused remote-plugin providers to silence checkhealth warnings
vim.g.loaded_node_provider   = 0
vim.g.loaded_perl_provider   = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider   = 0
