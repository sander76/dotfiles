-- blink.cmp: completion engine (LSP, buffer, path, snippets)
return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"]    = { "accept", "fallback" },
        ["<Tab>"]   = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      cmdline = {
        enabled = true,
        sources = { "cmdline" },
        completion = {
          menu = { auto_show = true },  -- show immediately without Tab
        },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          window    = { border = "rounded" },
        },
      },
    },
  },
}
