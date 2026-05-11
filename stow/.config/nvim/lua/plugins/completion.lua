-- nvim-cmp: completion engine (LSP, buffer, path, cmdline, signature)
return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",           -- LSP completions
      "hrsh7th/cmp-buffer",             -- buffer-word completions
      "hrsh7th/cmp-path",               -- filesystem path completions
      "hrsh7th/cmp-cmdline",            -- : / ? cmdline completions
      "hrsh7th/cmp-nvim-lsp-signature-help", -- signature help as a completion source
    },
    config = function()
      local cmp = require("cmp")

      -- ── Insert-mode completion ──────────────────────────────────────────
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),

        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]   = cmp.mapping.abort(),
          ["<C-d>"]   = cmp.mapping.scroll_docs(4),
          ["<C-u>"]   = cmp.mapping.scroll_docs(-4),
        }),

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        experimental = {
          ghost_text = true,
        },
      })

      -- ── Cmdline: / and ? search ─────────────────────────────────────────
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- ── Cmdline: : commands ─────────────────────────────────────────────
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
