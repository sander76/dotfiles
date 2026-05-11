-- blink.cmp: completion engine (LSP, buffer, path, cmdline, signature help)
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
      keymap = {
        preset  = "default",
        -- Tab/S-Tab to navigate the list; CR to accept
        ["<Tab>"]   = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"]    = { "accept", "fallback" },
        -- C-k toggles the signature-help popup (built-in default)
      },

      sources = {
        default = { "lsp", "path", "buffer" },
      },

      -- Cmdline completion (`:` commands, `/` search, …)
      cmdline = {
        sources = { "cmdline" },
        completion = {
          menu = { auto_show = true },
        },
      },

      -- Signature help (replaces the manual CursorHoldI autocmd in lsp.lua)
      signature = { enabled = true },

      completion = {
        documentation = {
          auto_show          = true,
          auto_show_delay_ms = 200,
        },
      },

      -- Use Rust fuzzy matcher when available, fall back to Lua silently
      fuzzy = { implementation = "prefer_rust" },
    },
  },
}
