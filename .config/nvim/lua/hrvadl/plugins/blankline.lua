return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    local c = require("nord.colors").palette
    local highlight = {
      "NordBlue",
    }

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "NordBlue", { fg = c.frost.artic_water })
    end)

    require("ibl").setup({ scope = { highlight = highlight } })

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
