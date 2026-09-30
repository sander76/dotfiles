-- nvim-hlslens: shows [n/N] match count/lens while searching (incsearch) and
-- when moving between matches with n/N/*/#, since Vim/Neovim's own incsearch
-- never displays the count while typing (see :help 'incsearch').
return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = {
      -- By default hlslens only shows the full "[idx/total]" lens for the
      -- nearest match; other on-screen matches just get "[idx]" plus a
      -- direction arrow. Force every visible lens into "[idx/total]" form.
      override_lens = function(render, posList, nearest, idx, _relIdx)
        local text = ("[%d/%d]"):format(idx, #posList)
        local hl = nearest and "HlSearchLensNear" or "HlSearchLens"
        local lnum, col = unpack(posList[idx])
        render.setVirt(0, lnum - 1, col - 1, { { " " }, { text, hl } }, nearest)
      end,
    },
    config = function(_, opts)
      require("hlslens").setup(opts)

      -- Give the lens overlay a dark green color instead of the theme
      -- default. Re-applied on every colorscheme change since colorschemes
      -- clear custom highlight links/definitions.
      local function set_hlslens_colors()
        vim.api.nvim_set_hl(0, "HlSearchLens", { fg = "#1e5631", bold = true })
        vim.api.nvim_set_hl(0, "HlSearchLensNear", { fg = "#1e5631", bold = true })
      end
      set_hlslens_colors()
      vim.api.nvim_create_autocmd("ColorScheme", {
        desc = "Re-apply hlslens dark green lens colors",
        callback = set_hlslens_colors,
      })
    end,
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
