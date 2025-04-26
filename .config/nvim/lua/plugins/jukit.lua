return {
	"luk400/vim-jukit",
	event = { "BufReadPre", "BufNewFile" },
	cond = function()
		local filename = vim.fn.expand("%:t")
		local extension = vim.fn.expand("%:e")
		return extension == "py" or filename:match("%.ipynb$")
	end,
	init = function()
		-- Always overwrite and save as JSON
		vim.g.jukit_convert_overwrite_default = 1
		vim.g.jukit_convert_open_default = 0
		vim.g.jukit_convert_ext = ".json"

		-- Autocmd to set filetype=ipynb for *.ipynb files
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = "*.ipynb",
			callback = function()
				vim.bo.filetype = "ipynb"
			end,
		})
	end,
	config = function()
		-- Set keymaps
		vim.api.nvim_set_keymap("n", "<C-Enter>", "<cmd>call jukit#send_line()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"v",
			"<C-Enter>",
			"<cmd>call jukit#send_selection()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader><space>",
			"<cmd>call jukit#send_cell()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
