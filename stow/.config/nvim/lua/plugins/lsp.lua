-- LSP configuration
-- ty (https://github.com/astral-sh/ty) is not yet in nvim-lspconfig, so it is
-- registered here with Neovim's native vim.lsp.config API (requires nvim 0.11+).

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ── ty – Python type checker (LSP server) ──────────────────────────
      -- `ty server` speaks LSP; root detection follows PEP 517/518 conventions.
      vim.lsp.config("ty", {
        cmd          = { "ty", "server" },
        filetypes    = { "python" },
        root_markers = { "pyproject.toml", "setup.cfg", "setup.py", ".git" },
      })

      vim.lsp.enable("ty")

      -- ── ruff – Python linter & formatter ───────────────────────────────
      vim.lsp.config("ruff", {
        cmd          = { "ruff", "server" },
        filetypes    = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        init_options = {
          settings = {
            logLevel = "warn",
          },
        },
      })

      vim.lsp.enable("ruff")

      -- ── Auto-trigger signature help when cursor is inside brackets ────
      vim.api.nvim_create_autocmd("CursorHoldI", {
        pattern  = "*.py",
        callback = function()
          local line   = vim.api.nvim_get_current_line()
          local col    = vim.api.nvim_win_get_cursor(0)[2]
          local before = line:sub(1, col)
          if before:match("[%w_]+%s*%(.*") then
            require("blink.cmp.signature.trigger").show({ force = true })
          end
        end,
      })

      -- ── Format Python files with ruff on save ──────────────────────────
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(event)
          vim.lsp.buf.format({ name = "ruff", bufnr = event.buf })
        end,
      })

      -- ── Diagnostic display ──────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
        signs         = true,
        underline     = true,
        update_in_insert = false,
        severity_sort = true,
        float         = { border = "rounded", source = true },
      })

      -- ── Keymaps (set when an LSP attaches to a buffer) ──────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd",        vim.lsp.buf.definition,      "Go to definition")
          map("gD",        vim.lsp.buf.declaration,     "Go to declaration")
          map("gr",        vim.lsp.buf.references,      "References")
          map("gi",        vim.lsp.buf.implementation,  "Go to implementation")
          map("K",         vim.lsp.buf.hover,           "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename,         "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
          map("<leader>e",  vim.diagnostic.open_float,  "Show diagnostics")
          map("[d",         vim.diagnostic.goto_prev,   "Previous diagnostic")
          map("]d",         vim.diagnostic.goto_next,   "Next diagnostic")
        end,
      })
    end,
  },
}
