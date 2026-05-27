return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()

      -- ── basedpyright ──────────────────────────────────────────────────────
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            typeCheckingMode = "standard",
          },
        },
      })
      vim.lsp.enable("basedpyright")

      -- ── ruff ──────────────────────────────────────────────────────────────
      vim.lsp.config("ruff", {
        init_options = { settings = { logLevel = "warn" } },
      })
      vim.lsp.enable("ruff")

      -- ── Fix + format on save ──────────────────────────────────────────────
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(event)
          local bufnr = event.buf
          -- code_action has no callback param; use request_sync so format runs after fixes
          local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ruff" })
          if clients[1] then
            local win    = vim.api.nvim_get_current_win()
            local params = vim.lsp.util.make_range_params(win, clients[1].offset_encoding)
            params.context = { only = { "source.fixAll.ruff" }, diagnostics = {} }
            local resp = clients[1]:request_sync("textDocument/codeAction", params, 1000, bufnr)
            if resp and resp.result then
              for _, action in ipairs(resp.result) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, clients[1].offset_encoding)
                end
                if action.command then
                  clients[1]:exec_cmd(action.command, { bufnr = bufnr })
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
      local lsp_group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }) -- ← moved out

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, {
              autotrigger = true,
              cmp = function(a, b)
                local function is_basedpyright(item)
                  local id = vim.tbl_get(item, "user_data", "nvim", "lsp", "client_id")
                  local c = id and vim.lsp.get_client_by_id(id)
                  return c ~= nil and c.name == "basedpyright"
                end
                if is_basedpyright(a) and not is_basedpyright(b) then return true end
                if is_basedpyright(b) and not is_basedpyright(a) then return false end
              end,
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
