-- codediff: VSCode-style diff review workspace for local/staged changes, PRs, and history
return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>cd", "<cmd>CodeDiff<cr>", desc = "Diff explorer" },
    },
    opts = {},
  },
}
