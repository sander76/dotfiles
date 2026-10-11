-- grug-far.nvim: project-wide search & replace in a single buffer UI
-- Open with :GrugFar (or <leader>sr); <localleader>r executes the replacement
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      -- <cmd> keeps the visual range, so visual mode pre-fills the search
      { "<leader>sr", "<cmd>GrugFar<cr>", mode = { "n", "x" }, desc = "Search & replace (grug-far)" },
    },
    opts = {},
  },
}
