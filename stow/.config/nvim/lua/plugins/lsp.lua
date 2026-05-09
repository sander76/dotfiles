-- LSP configuration
-- Both ty and ruff are configured via nvim-lspconfig's built-in definitions;
-- we enable them and only override settings that differ from the defaults (requires nvim 0.11+).

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ── ty – Python type checker (LSP server) ──────────────────────────
      -- nvim-lspconfig provides cmd/filetypes/root_markers (ty.toml,
      -- pyproject.toml, setup.py, setup.cfg, requirements.txt, .git).
      vim.lsp.enable("ty")

      -- ── ruff – Python linter & formatter ───────────────────────────────
      -- nvim-lspconfig provides cmd/filetypes/root_markers; only override
      -- logLevel to suppress noisy info messages.
      vim.lsp.config("ruff", {
        init_options = { settings = { logLevel = "warn" } },
      })
      vim.lsp.enable("ruff")

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
        end,
      })
    end,
  },
}
