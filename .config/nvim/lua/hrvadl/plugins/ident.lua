return {
  {
    "nvimdev/indentmini.nvim",
    config = function()
      local c = require("nord.colors").palette
      vim.api.nvim_set_hl(0, "IndentLine", { fg = c.polar_night.bright })
      vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = c.frost.polar_water })
      require("indentmini").setup()
    end,
  },
}
