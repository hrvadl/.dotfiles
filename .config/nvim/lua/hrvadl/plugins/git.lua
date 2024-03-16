return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
      })

      vim.keymap.set("n", "co", "<cmd>GitConflictChooseOurs<cr>")
      vim.keymap.set("n", "ct", "<cmd>GitConflictChooseTheirs<cr>")
      vim.keymap.set("n", "cb", "<cmd>GitConflictChooseBoth<cr>")
      vim.keymap.set("n", "cn", "<cmd>GitConflictChooseNone<cr>")
      vim.keymap.set("n", "cj", "<cmd>GitConflictNextConflict<cr>")
      vim.keymap.set("n", "ck", "<cmd>GitConflictPrevConflict<cr>")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 500,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
      })

      vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", { noremap = true })
    end,
  },
}
