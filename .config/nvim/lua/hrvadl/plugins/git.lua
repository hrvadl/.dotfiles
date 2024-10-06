return {
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
			vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { noremap = true })
			vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { noremap = true })
		end,
	},
}
