return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()

      -- ── pyrefly (completions only) ────────────────────────────────────────
      -- ty handles all other LSP features. Strip every capability from pyrefly
      -- except completionProvider so there are no duplicate results.
      vim.lsp.config("pyrefly", {
        on_exit = nil,                -- suppress noisy "exited with code" notification
        on_init = function(client)
          client.server_capabilities.diagnosticProvider        = nil
          client.server_capabilities.hoverProvider             = false
          client.server_capabilities.definitionProvider        = false
          client.server_capabilities.declarationProvider       = false
          client.server_capabilities.typeDefinitionProvider    = false
          client.server_capabilities.implementationProvider    = false
          client.server_capabilities.referencesProvider        = false
          client.server_capabilities.renameProvider            = false
          client.server_capabilities.codeActionProvider        = false
          client.server_capabilities.inlayHintProvider         = false
          client.server_capabilities.signatureHelpProvider     = false
          client.server_capabilities.documentHighlightProvider = false
          client.server_capabilities.documentSymbolProvider    = false
          client.server_capabilities.workspaceSymbolProvider   = false
          client.server_capabilities.semanticTokensProvider    = nil
        end,
      })
      vim.lsp.enable("pyrefly")

      -- ── ty (everything except completions) ───────────────────────────────
      -- Astral's Rust-based type checker. Owns diagnostics, hover, navigation,
      -- rename, inlay hints, etc. Completions stay with pyrefly.
      -- Note: ty is beta — callHierarchy and implementation not yet supported.
      vim.lsp.config("ty", {
        on_init = function(client)
          client.server_capabilities.completionProvider = nil
        end,
      })
      vim.lsp.enable("ty")

      -- ── ruff ──────────────────────────────────────────────────────────────
      vim.lsp.config("ruff", {
        init_options = { settings = { logLevel = "warn" } },
      })
      vim.lsp.enable("ruff")

      -- ── Fix + format on save ──────────────────────────────────────────────
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(event)
          local bufnr  = event.buf
          local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ruff" })[1]
          if client then
            local win    = vim.api.nvim_get_current_win()
            local params = vim.lsp.util.make_range_params(win, client.offset_encoding)
            params.context = { only = { "source.fixAll.ruff" }, diagnostics = {} }
            local resp = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
            if resp and resp.result then
              for _, action in ipairs(resp.result) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
                if action.command then
                  client:exec_cmd(action.command, { bufnr = bufnr })
                end
              end
            end
          end
          vim.lsp.buf.format({ name = "ruff", bufnr = bufnr, async = false })
        end,
      })

      -- ── Diagnostics ───────────────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text     = { prefix = "●" },
        signs            = true,
        underline        = true,
        update_in_insert = false,   -- ← was: true (noisy)
        severity_sort    = true,
        float            = { source = true },
      })

      -- ── Keymaps ───────────────────────────────────────────────────────────
      local lsp_group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Only pyrefly reaches here (ty's completionProvider is stripped).
          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, {
              autotrigger = true,
              convert = function(item)
                return { abbr = item.label:gsub("%b()", "") }
              end,
            })
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
