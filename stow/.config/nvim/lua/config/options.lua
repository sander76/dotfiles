-- Leader key (set before lazy loads plugins)
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Quick escape from insert mode
vim.keymap.set('i', 'jj', '<Esc>')

-- Close buffer without closing the split window
vim.keymap.set('n', '<leader>x', function() Snacks.bufdelete() end, { desc = 'Delete buffer (keep window)' })

-- Save with Ctrl+S (normal, insert, and visual mode)
vim.keymap.set({ 'n', 'v' }, '<C-s>', '<cmd>w<cr>',      { desc = 'Save file' })
vim.keymap.set('i',          '<C-s>', '<cmd>w<cr><Esc>', { desc = 'Save file' })

-- Disable F1 help key (avoid accidental help window)
vim.keymap.set({ 'n', 'i', 'v' }, '<F1>', '<Nop>')

-- Exit terminal insert mode with Esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal insert mode' })
-- Disable arrow keys (enforce hjkl)
vim.keymap.set({ 'n', 'i', 'v' }, '<Up>',    '<Nop>')
vim.keymap.set({ 'n', 'i', 'v' }, '<Down>',  '<Nop>')
vim.keymap.set({ 'n', 'i', 'v' }, '<Left>',  '<Nop>')
vim.keymap.set({ 'n', 'i', 'v' }, '<Right>', '<Nop>')

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

-- LSP / insert-mode completion (native, no plugin needed)
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy", "nearest" }
vim.opt.pummaxwidth  = 40
-- Tab / S-Tab navigate the popup; CR confirms; <C-Space> triggers (set in lsp.lua)
vim.keymap.set("i", "<Tab>",   function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"   end, { expr = true, desc = "Next completion / Tab" })
vim.keymap.set("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true, desc = "Prev completion / S-Tab" })
vim.keymap.set("i", "<CR>",    function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"    end, { expr = true, desc = "Accept completion / CR" })

-- Built-in cmdline autocompletion (popup as you type)
vim.opt.wildmode    = "noselect:lastused,full"  -- don't auto-select; prefer last-used on first Tab
vim.opt.wildoptions = "pum,fuzzy"               -- popup menu + fuzzy matching

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = { ":", "/", "?" },
  desc    = "Trigger wildmenu popup as you type",
  callback = function() vim.fn.wildtrigger() end,
})

-- Keep <Up>/<Down> for history when the popup is not open
vim.keymap.set("c", "<Up>",   function() return vim.fn.wildmenumode() == 1 and "<C-E><Up>"   or "<Up>"   end, { expr = true })
vim.keymap.set("c", "<Down>", function() return vim.fn.wildmenumode() == 1 and "<C-E><Down>" or "<Down>" end, { expr = true })

vim.opt.undofile       = true
vim.opt.swapfile       = false
vim.opt.confirm        = true   -- ask to save instead of erroring on :q

vim.opt.clipboard      = "unnamedplus"  -- sync with system clipboard
vim.opt.termguicolors  = true
vim.opt.updatetime     = 250
vim.opt.winborder      = "rounded"  -- rounded borders for all floating windows
vim.opt.pumborder      = "rounded"  -- rounded borders for the completion popup menu (pum)

-- Disable unused remote-plugin providers to silence checkhealth warnings
vim.g.loaded_node_provider   = 0
vim.g.loaded_perl_provider   = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider   = 0
