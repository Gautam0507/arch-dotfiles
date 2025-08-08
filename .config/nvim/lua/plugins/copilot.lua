return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		keys = {
			{ "<leader>cp", "<CMD>Copilot panel<CR>" },
			{ "<leader>ce", "<CMD>Copilot enable<CR>" },
			{ "<leader>cd", "<CMD>Copilot disable<CR>" },
			{ "<C-l>", "copilot#AcceptWord()", mode = "i", expr = true, replace_keycodes = false },
			{
				"<C-b>",
				'copilot#Accept("\\<CR>")',
				mode = "i",
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion",
			},
		},
		config = function()
			vim.g.copilot_no_tab_map = true -- Disable default tab mapping
			vim.g.copilot_assume_mapped = true -- Assume mappings are already set
		end,
	},
}
