-- fzf-lua: fuzzy finder
return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>f", "<cmd>FzfLua files<cr>",                desc = "Find files" },
      { "<leader>g", "<cmd>FzfLua live_grep<cr>",            desc = "Live grep" },
      { "<leader>b", "<cmd>FzfLua buffers<cr>",              desc = "Buffers" },
      { "<leader>d", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
    },
    opts = {
      winopts = {
        height  = 0.85,
        width   = 0.80,
        preview = { layout = "vertical", vertical = "up:40%" },
      },
      fzf_opts = {
        ["--layout"] = "reverse",  -- prompt at top
      },
      grep = {
        rg_glob = true,  -- type ' --' to switch from query to glob, e.g. 'foo -- *.lua'
      },
    },
  },
}
