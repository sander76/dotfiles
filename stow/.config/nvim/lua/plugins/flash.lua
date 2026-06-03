-- flash.nvim: quick jump to any visible word via overlay labels
-- Replaces the need for /search or f/t motions for distant targets
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- Jump to any visible word with overlay labels
      {
        "s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash jump",
      },
      -- Jump to Treesitter node (e.g. function, class) with labels
      {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
      
    },
  },
}
