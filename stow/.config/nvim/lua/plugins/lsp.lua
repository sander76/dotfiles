-- LSP configuration
-- pyrefly and ruff are configured via nvim-lspconfig's built-in definitions;
-- we enable them and only override settings that differ from the defaults (requires nvim 0.11+).

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ── pyrefly – Python type checker + completions ───────────────────────
      -- ruff owns linting/formatting; pyrefly owns types + completions.
      vim.lsp.enable("pyrefly")

      -- ── ruff – Python linter & formatter ───────────────────────────────
      vim.lsp.config("ruff", {
        init_options = { settings = { logLevel = "warn", } } ,
      })
      vim.lsp.enable("ruff")

      -- ── Fix all + format Python files with ruff on save ──────────────
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(event)
          -- Apply all auto-fixable lint fixes first, then format.
          vim.lsp.buf.code_action({
            context = { only = { "source.fixAll.ruff" }, diagnostics = {} },
            apply = true,
          })
          vim.lsp.buf.format({ name = "ruff", bufnr = event.buf })
        end,
      })

      -- ── Diagnostic display ──────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
        signs         = true,
        underline     = true,
        update_in_insert = true,
        severity_sort = true,
        float         = { source = true },
      })

      -- ── Keymaps (set when an LSP attaches to a buffer) ──────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(event)
          -- Enable native LSP completion for this buffer
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, {
              autotrigger = true,
              -- Prefer pyrefly items over ruff items
              cmp = function(a, b)
                local function priority(item)
                  local id = vim.tbl_get(item, "user_data", "nvim", "lsp", "client_id")
                  local c = id and vim.lsp.get_client_by_id(id)
                  return (c and c.name == "pyrefly") and 0 or 1
                end
                return priority(a) < priority(b)
              end,
              convert = function(item)
                -- Strip trailing () from function labels so the abbreviation is cleaner
                return { abbr = item.label:gsub("%b()", "") }
              end,
            })
            -- Manually trigger completion
            vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get,
              { buffer = event.buf, desc = "LSP: Trigger completion" })
          end

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd",         vim.lsp.buf.definition,     "Go to definition")
          map("gD",         vim.lsp.buf.declaration,    "Go to declaration")
          map("gr",         vim.lsp.buf.references,     "References")
          map("gi",         vim.lsp.buf.implementation, "Go to implementation")
          map("K",          vim.lsp.buf.hover,          "Hover docs")
          map("<leader>cn", vim.lsp.buf.rename,         "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
          map("<leader>e",  vim.diagnostic.open_float,  "Show diagnostics")
        end,
      })
    end,
  },
}
