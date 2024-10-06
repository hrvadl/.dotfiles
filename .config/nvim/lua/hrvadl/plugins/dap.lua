return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "folke/neodev.nvim",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
      local dap = require("dap")
      dap.set_log_level("INFO")

      local c = require("nord.colors").palette
      vim.api.nvim_set_hl(0, "DapUIDecoration", { fg = c.frost.polar_water })
      vim.api.nvim_set_hl(0, "DapUIScope", { fg = c.frost.polar_water })

      vim.api.nvim_set_hl(0, "DapUISource", { fg = c.frost.ice })
      vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { fg = c.frost.ice })
      vim.api.nvim_set_hl(0, "DapUILineNumber", { fg = c.frost.ice })
      vim.api.nvim_set_hl(0, "DapUIStoppedThread", { fg = c.frost.ice })

      vim.api.nvim_set_hl(0, "DapUIStoppedThread", { fg = c.frost.ice })
      vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { fg = c.frost.ice })

      vim.api.nvim_set_hl(0, "DapUIThread", { fg = c.frost.artic_water })
      vim.api.nvim_set_hl(0, "DapUIType", { fg = c.frost.artic_water })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "delve" },
      })
    end,
  },
  {
    "stevearc/overseer.nvim",
    opts = {},
    config = function()
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      require("overseer").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      local nvim_dap_virtual_text = require("nvim-dap-virtual-text")
      nvim_dap_virtual_text.setup({
        enabled = true,                    -- enable this plugin (the default)
        enabled_commands = true,           -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,  -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,           -- show stop reason when stopped for exceptions
        commented = true,                  -- prefix virtual text with comment string
        only_first_definition = true,      -- only show virtual text at first definition (if there are multiple)
        all_references = false,            -- show virtual text on all all references of the variable (not only definitions)
        filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
        -- experimental features:
        virt_text_pos = "eol",             -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false,                -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,                -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil,           -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
      })
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      {
        "microsoft/vscode-js-debug",
        -- After install, build it and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
    },
    config = function()
      -- local defPath = "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
        -- debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({
        layouts = {
          {
            elements = {
              {
                id = "stacks",
                size = 0.33,
              },
              {
                id = "breakpoints",
                size = 0.33,
              },
              {
                id = "scopes",
                size = 0.33,
              },
              --		{
              --			id = "watches",
              --			size = 0.25,
              --		},
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              --	{
              --		id = "repl",
              --		size = 0.5,
              --	},
              {
                id = "console",
                size = 1,
              },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- this fucking does not work
      vim.api.nvim_set_hl(0, "DapBreakpoint", { default = true, link = "Visual" })
      vim.fn.sign_define("DapBreakpoint", { text = "󰧞", texthl = "DapUIStop", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰐊", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      local js_based_languages = { "typescript", "javascript", "typescriptreact" }
      vim.keymap.set("n", "<F5>", function()
        if vim.fn.filereadable(".vscode/launch.json") then
          require("dap.ext.vscode").load_launchjs(nil, {
            ["pwa-chrome"] = js_based_languages,
            ["node"] = js_based_languages,
            ["javascript"] = js_based_languages,
          })
        end
        dap.continue()
      end)
      vim.keymap.set("n", "<F7>", function()
        dap.disconnect({ terminateDebuggee = true })
      end)
      vim.keymap.set("n", "<F6>", function()
        dap.restart({ terminateDebuggee = true })
      end)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
      vim.keymap.set("n", "dt", dapui.toggle)
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dr",
        ":lua require('dapui').open({reset = true})<CR>",
        { noremap = true }
      )
    end,
  },
}
