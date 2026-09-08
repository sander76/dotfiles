-- nvim-treesitter (main branch, requires Nvim 0.12+): parser install manager.
-- Highlighting/indent are NOT auto-enabled by the plugin itself since the
-- rewrite — Neovim provides the features natively, we just need to turn them
-- on per-filetype and tell nvim-treesitter which parsers to install.
-- Folding is intentionally left on the default (manual, no auto-collapse).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      local ensure_installed = {
        "lua", "vim", "vimdoc", "query",           -- config editing
        "python", "bash",                          -- your LSP-backed languages
        "json", "yaml", "toml",
        "markdown", "markdown_inline",
      }

      -- Install missing parsers, then enable features for the languages
      -- attached to (or about to attach to) a buffer.
      ts.install(ensure_installed)

      local group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang or not vim.treesitter.language.add(lang) then return end

          vim.treesitter.start(event.buf, lang)

          -- Folding intentionally left on the default (foldmethod=manual,
          -- no auto-collapse) — only highlighting + indent use treesitter.
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
