return {
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "neovim/nvim-lspconfig" },
  { "L3MON4D3/LuaSnip" },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      vim.cmd([[autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy]])
      vim.cmd([[autocmd BufRead,BufNewFile *.tf set filetype=hcl]])

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })

        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition()
        end, {})
        vim.keymap.set("n", "gt", function()
          vim.lsp.buf.type_definition()
        end, {})
        vim.keymap.set("n", "gi", function()
          vim.lsp.buf.implementation()
        end, {})
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()
        end, {})
        vim.keymap.set("n", "<leader>ds", function()
          vim.diagnostic.open_float()
        end, {})
        vim.keymap.set("n", "<leader>dj", function()
          vim.diagnostic.goto_next()
        end, {})
        vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {})
        vim.keymap.set("n", "<leader>dk", function()
          vim.diagnostic.goto_prev()
        end, {})
        vim.keymap.set("n", "<leader>ca", function()
          vim.lsp.buf.code_action()
        end, {})
        vim.keymap.set("n", "<leader>vrr", function()
          vim.lsp.buf.references()
        end, {})
        vim.keymap.set("n", "<leader>r", function()
          vim.lsp.buf.rename()
        end, {})
        vim.keymap.set("i", "<C-lh>", function()
          vim.lsp.buf.signature_help()
        end, {})
      end)

      local function custom_rename_handler(err, result, ctx, config)
        if err then
          vim.notify("Rename failed: " .. err.message, vim.log.levels.ERROR)
          return
        end

        local client = vim.lsp.get_client_by_id(ctx.client_id)
        vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

        -- Autosave and close affected buffers
        for _, change in ipairs(result.changes or {}) do
          for uri, edits in pairs(change) do
            local bufnr = vim.uri_to_bufnr(uri)
            if vim.api.nvim_buf_is_loaded(bufnr) then
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("write")
                vim.cmd("bdelete")
              end)
            end
          end
        end

        vim.notify("Rename successful", vim.log.levels.INFO)
      end

      -- Override the default rename handler
      vim.lsp.handlers["textDocument/rename"] = vim.lsp.with(custom_rename_handler, {})

      local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Information = "",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      require("mason").setup({})

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          -- Lua
          "lua_ls",
          -- JS/HTML/CSS
          "stylelint_lsp",
          -- GO
          "gopls",
          "golangci_lint_ls",
          -- PROTO
          "bufls",
        },
        handlers = {
          lsp_zero.default_setup,
        },
      })

      local lspconfig = require("lspconfig")
      local configs = require("lspconfig/configs")

      if not configs.golangcilsp then
        configs.golangcilsp = {
          default_config = {
            cmd = { "golangci-lint-langserver" },
            root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
            init_options = {
              command = {
                "golangci-lint",
                "run",
                "--fast",
                "--issues-exit-code=1",
              },
            },
          },
        }
      end
      lspconfig.golangci_lint_ls.setup({
        filetypes = { "go", "gomod" },
      })

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              loopclosure = false,
            },
          },
        },
      })

      require("mason-null-ls").setup({
        ensure_installed = {
          -- Groovy
          -- Lua
          "formatting.stylua",
          -- SHELL
          -- formatting.shellharden,
          -- JS
          "prettierd",
          -- CSS
          -- "stylelint",
          -- GO
          "golines",
          "gofumpt",
          "goimports-reviser",
          -- diagnostics.revive,
          -- C
          -- "clang-format",
          -- "clang-d",
          -- PROTO
          "buf",
          "protolint",
        },
        automatic_installation = false,
      })
    end,
  },
}
