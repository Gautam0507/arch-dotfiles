return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		keys = {
			{ "<leader>cp", "<CMD>Copilot panel<CR>" },
			{ "<leader>ce", "<CMD>Copilot enable<CR>" },
			{ "<leader>cd", "<CMD>Copilot disable<CR>" },
			{ "<C-l>", "copilot#AcceptWord()", mode = "i", expr = true, replace_keycodes = false },
		},
	},
}
