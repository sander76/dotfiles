-- nvim-hlslens: shows [n/N] match count/lens while searching (incsearch) and
-- when moving between matches with n/N/*/#, since Vim/Neovim's own incsearch
-- never displays the count while typing (see :help 'incsearch').
return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Next search match (hlslens)",
      },
      {
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Prev search match (hlslens)",
      },
      { "*",  [[*<Cmd>lua require('hlslens').start()<CR>]],  desc = "Search word under cursor (hlslens)" },
      { "#",  [[#<Cmd>lua require('hlslens').start()<CR>]],  desc = "Search word under cursor, backward (hlslens)" },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search partial word under cursor (hlslens)" },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search partial word under cursor, backward (hlslens)" },
      { "<leader>l", "<Cmd>noh<CR>", desc = "Clear search highlight" },
    },
  },
}
