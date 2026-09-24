return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Navigate left" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Navigate down" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Navigate up" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Navigate right" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
    -- Insert mode: leave insert mode first, then navigate.
    { "<c-h>", "<Esc><cmd>TmuxNavigateLeft<cr>",     mode = "i", desc = "Navigate left" },
    { "<c-j>", "<Esc><cmd>TmuxNavigateDown<cr>",     mode = "i", desc = "Navigate down" },
    { "<c-k>", "<Esc><cmd>TmuxNavigateUp<cr>",       mode = "i", desc = "Navigate up" },
    { "<c-l>", "<Esc><cmd>TmuxNavigateRight<cr>",    mode = "i", desc = "Navigate right" },
  },
}
