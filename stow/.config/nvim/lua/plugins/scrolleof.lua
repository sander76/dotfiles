-- scrollEOF.nvim: make scrolloff apply past end of file.
-- NOTE: once native 'scrolloffpad' lands in a stable release (after 0.12.2),
-- this plugin can be removed. Set `vim.opt.scrolloffpad = 1` instead.
return {
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {},
  },
}