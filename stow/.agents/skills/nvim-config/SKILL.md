---
name: nvim-config
description: Review, edit, and extend a Neovim Lua config. Use when auditing nvim options, adding or configuring lazy.nvim plugins, fetching plugin docs from GitHub, or fixing common config issues (LSP setup, keymaps, which-key groups, clipboard, treesitter).
---

# Neovim Config

## Workflow

1. **Explore** — map out all files before touching anything
   ```bash
   find <nvim-config-dir> -type f | sort
   ```
2. **Read everything** — `init.lua`, `config/options.lua`, `config/lazy.lua`, all `plugins/*.lua`
3. **Fetch plugin docs** — use `fetch_content` on GitHub README URLs when reviewing or configuring a plugin
4. **Edit precisely** — use `edit` with minimal `oldText`; one call per file, multiple entries for disjoint changes

## Config Structure (lazy.nvim)

```
init.lua                  ← require config.options, then config.lazy
lua/config/options.lua    ← vim.opt.*, vim.g.*, keymaps
lua/config/lazy.lua       ← bootstrap + require("lazy").setup("plugins", …)
lua/plugins/*.lua         ← one plugin (or tight group) per file
```

Each plugin file returns a lazy.nvim spec table. Prefer `opts` over `config` when no extra logic is needed.

## Checklist — Common Issues

| # | Check | Fix |
|---|-------|-----|
| 1 | `mapleader` set before lazy loads | Must be in `options.lua`, loaded first in `init.lua` |
| 2 | Clipboard not set | `vim.opt.clipboard = "unnamedplus"` |
| 3 | Unused providers | `vim.g.loaded_node_provider = 0` etc. |
| 4 | lua_ls missing | Add `vim.lsp.config("lua_ls", …)` + `vim.lsp.enable("lua_ls")` |
| 5 | Treesitter missing | Add `nvim-treesitter` plugin with `ensure_installed` |
| 6 | which-key groups missing | Add `spec = { { "<leader>x", group = "name" } }` in opts |
| 7 | Theme toggle state | Derive from `vim.o.background`, not a local variable |

## nvim 0.11+ APIs

Prefer the new LSP API over legacy `lspconfig.setup()`:
```lua
vim.lsp.config("server_name", { … })   -- override defaults
vim.lsp.enable("server_name")           -- activate
```

Global floating window borders in one line:
```lua
vim.opt.winborder = "rounded"
```

## which-key Groups

Register prefix groups via `spec` in opts — no separate `require("which-key").add()` call needed:
```lua
opts = {
  spec = {
    { "<leader>c", group = "code" },
    { "<leader>q", group = "session" },
  },
}
```

Add the buffer-keymaps helper key:
```lua
keys = {
  { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
},
```

## References

- [Neovim user docs](https://neovim.io/doc/user/) — options, LSP, Lua, treesitter, autocmds
  - [lua](https://neovim.io/doc/user/lua/)
  - [lsp](https://neovim.io/doc/user/lsp/)
  - [options](https://neovim.io/doc/user/options/)

## lua_ls Setup

```lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime  = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      diagnostics = { globals = { "vim" } },
      telemetry   = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")
```
