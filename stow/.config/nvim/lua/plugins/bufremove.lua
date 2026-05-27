-- mini.bufremove: delete buffers without closing the window
return {
  {
    "echasnovski/mini.bufremove",
    version = "*",
    keys = {
      {
        "<leader>x",
        function() require("mini.bufremove").delete() end,
        desc = "Delete buffer (keep window)",
      },
    },
  },
}
