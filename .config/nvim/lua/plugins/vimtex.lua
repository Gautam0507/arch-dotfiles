return {
	"lervag/vimtex",
	lazy = false, -- don't lazy load VimTeX
	-- tag = "v2.15", -- uncomment if you want to pin a specific release
	init = function()
		-- Required for VimTeX to work correctly (usually default in nvim)
		vim.cmd("filetype plugin indent on")
		vim.cmd("syntax enable")

		-- Viewer options
		vim.g.vimtex_view_method = "zathura"
		-- Alternative generic viewer example (commented)
		-- vim.g.vimtex_view_general_viewer = "okular"
		-- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

		-- Compiler backend, use 'latexrun' or the default 'latexmk' (recommended)
		vim.g.vimtex_compiler_method = "latexmk"

		-- Map localleader to comma, VimTeX mappings use localleader
		vim.g.maplocalleader = " "

		vim.g.vimtex_compiler_latexmk = {
			options = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=build" },
		}
	end,
}
