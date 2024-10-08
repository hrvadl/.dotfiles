return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/playground",
	},
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "lua", "javascript", "html", "css", "typescript", "go", "yaml", "hcl" },
			sync_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
