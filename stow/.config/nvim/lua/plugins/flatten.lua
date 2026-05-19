return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001, -- must load before everything else
  opts = {
    window = {
      open = "alternate", -- open file in the alternate window (not the terminal)
    },
    block_for = {
      gitcommit = true,
      gitrebase = true,
    },
    -- nest_if_no_args = false  (default) — typing bare `nvim` in :term won't nest
  },
}
