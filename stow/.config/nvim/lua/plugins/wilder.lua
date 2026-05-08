-- wilder: automatic command-line autosuggestions as you type
return {
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")

      wilder.setup({ modes = { ":", "/", "?" } })

      wilder.set_option("renderer", wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          border        = "rounded",
          max_height    = "25%",
          min_width     = "100%",
          pumblend      = 10,
          highlighter   = wilder.basic_highlighter(),
          left          = { " ", wilder.popupmenu_devicons() },
          right         = { " ", wilder.popupmenu_scrollbar() },
        })
      ))
    end,
  },
}
