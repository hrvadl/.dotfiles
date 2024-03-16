return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "gbprod/nord.nvim",
  },
  config = function()
    vim.opt.termguicolors = true
    local c = require("nord.colors").palette

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "nord",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "buffers",
            symbols = {
              modified = " ●",
              alternate_file = "",
            },
            buffers_color = {
              active = { bg = c.frost.ice, fg = c.polar_night.origin },
            },
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })

    vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>", { noremap = true })
    vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>", { noremap = true })
  end,
}
