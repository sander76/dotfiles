-- code-review: add inline review comments, preview/export as Markdown for AI pair programming
-- Uses <leader>v (review) instead of the plugin's default <leader>r prefix,
-- since <leader>r is already bound to Snacks.picker.resume().
return {
  {
    "choplin/code-review.nvim",
    keys = {
      { "<leader>vc", function() require("code-review").add_comment() end,           mode = { "n", "v" }, desc = "Add comment" },
      { "<leader>vp", function() require("code-review").preview() end,               desc = "Preview review" },
      { "<leader>vw", function() require("code-review").save() end,                  desc = "Save review to file" },
      { "<leader>vy", function() require("code-review").copy() end,                  desc = "Copy review to clipboard" },
      { "<leader>vs", function() require("code-review").show_comment_at_cursor() end, desc = "Show comment at cursor" },
      { "<leader>vl", function() require("code-review").list_comments() end,         desc = "List comments" },
      { "<leader>vd", function() require("code-review").delete_comment() end,        desc = "Delete comment" },
      { "<leader>vx", function() require("code-review").clear() end,                 desc = "Clear all comments" },
    },
    opts = {
      keymaps = false, -- keymaps set up above under <leader>v instead of default <leader>r
    },
    config = function(_, opts)
      require("code-review").setup(opts)
    end,
  },
}
