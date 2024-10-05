return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    file_ignore_patterns = { "node%_modules/.*", ".git/*" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] }
      )
      vim.keymap.set("n", "<leader>s", "<cmd>Telescope spell_suggest<cr>")
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>")
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({
          find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
        })
      end, {})
      vim.keymap.set("n", "<leader>fg", function()
        local conf = require("telescope.config").values
        builtin.live_grep({
          vimgrep_arguments = table.insert(conf.vimgrep_arguments, "--fixed-strings"),
        })
      end, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>n",
        "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { noremap = true }
      )

      vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope file_browser<CR>", { noremap = true })
      local fb_actions = require("telescope._extensions.file_browser.actions")

      require("telescope").setup({
        extensions = {
          file_browser = {
            cwd_to_path = true,
            hidden = { file_browser = true, folder_browser = true },
            collapse_dirs = false,
            hijack_netrw = true,
            mappings = {
              ["n"] = {
                ["n"] = fb_actions.create,
              },
            },
          },
        },
      })
      require("telescope").load_extension("file_browser")
    end,
  },
}
