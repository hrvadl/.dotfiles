return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.2.0",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"VonHeikemen/lsp-zero.nvim",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			require("luasnip.loaders.from_vscode").lazy_load()

			local c = require("nord.colors").palette

			vim.api.nvim_set_hl(0, "CmpNormal", { bg = c.polar_night.bright })
			vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = c.polar_night.light })

			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = c.frost.artic_water })
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = c.frost.artic_water })
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = c.frost.polar_water })
			vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = c.frost.polar_water })
			vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = c.frost.ice })

			cmp.setup({
				window = {
					completion = {
						winhighlight = "Normal:CmpNormal,CursorLine:CmpCursorLine",
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
						autocomplete = true,
						keyword_length = 1,
					},
					documentation = {
						winhighlight = "Normal:CmpNormal,FloatBorder:Pmenu,Search:None",
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip", keyword_length = 1 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "copilot", group_index = 2 },
				},
				formatting = lsp_zero.cmp_format(),
				mapping = {
					-- See $VIMPLUG/nvim-cmp/lua/cmp/config/mapping.lua
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(cmp_select),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping.close(),
					["<Down>"] = cmp.mapping.select_next_item(cmp_select),
					["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm(),
					["<Tab>"] = { -- see GH-880, GH-897
						i = function(fallback) -- see GH-231, GH-286
							if cmp.visible() then
								cmp.select_next_item()
							elseif has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end,
					},
					["<S-Tab>"] = {
						i = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							else
								fallback()
							end
						end,
					},
				},
			})
		end,
	},
}
