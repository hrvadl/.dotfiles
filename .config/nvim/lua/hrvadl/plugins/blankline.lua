return {
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {},
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "echasnovski/mini.indentscope",
    version = "*",
    config = function()
      local indentscope = require("mini.indentscope")
      indentscope.gen_animation.none()
      indentscope.setup({ symbol = "|", debounce = 0 })
    end,
  },
}
