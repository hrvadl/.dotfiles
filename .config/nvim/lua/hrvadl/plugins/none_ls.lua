return {
  "nvimtools/none-ls.nvim",
  config = function()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- C
        null_ls.builtins.formatting.clang_format,
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- JS
        null_ls.builtins.formatting.prettierd,
        -- GO
        null_ls.builtins.formatting.golines.with({
          extra_args = { "--base-formatter=gofumpt" },
        }),
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.diagnostics.golangci_lint.with({
          args = { "run", "--fix=false", "--show-stats=false", "--output.json.path=stdout" },
          -- extra_args = { "--allow-parallel-runners" },
        }),
        -- PROTO
        null_ls.builtins.diagnostics.protolint,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
            end,
          })
        end
      end,
    })

    vim.diagnostic.config({ underline = false, severity_sort = true })
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
