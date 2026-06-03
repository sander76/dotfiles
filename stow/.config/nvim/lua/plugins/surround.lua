-- nvim-surround: add, delete, change surrounding pairs
-- Default mappings: ys{motion}{char}, ds{char}, cs{target}{replacement}
return {
  {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- stable
    event = "VeryLazy",
    opts = {},
  },
}
