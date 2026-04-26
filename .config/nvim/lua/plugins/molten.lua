return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		dependencies = { "3rd/image.nvim", "GCBallesteros/jupytext.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			-- these are examples, not defaults. Please see the readme
			-- I find auto open annoying; disable automatic opening of the output.
			-- Note: disabling this requires a keybind for
			-- `:noautocmd MoltenEnterOutput` to open the output again.
			vim.g.molten_auto_open_output = false

			-- this guide will be using image.nvim
			-- Don't forget to setup and install the plugin if you want to view image outputs
			vim.g.molten_image_provider = "image.nvim"

			-- optional, I like wrapping. works for virt text and the output window
			vim.g.molten_wrap_output = true

			-- Output as virtual text. Allows outputs to always be shown, works with images, but can
			-- be buggy with longer images
			vim.g.molten_virt_text_output = true

			-- this will make it so the output shows up below the ``` cell delimiter
			vim.g.molten_virt_lines_off_by_1 = true

			vim.g.molten_output_win_max_height = 20

			-- Keymaps for using molten.nvim. Disable auto-open above requires the
			-- `:noautocmd MoltenEnterOutput` mapping to open the output again.
			vim.keymap.set(
				"n",
				"<localleader>e",
				":MoltenEvaluateOperator<CR>",
				{ desc = "evaluate operator", silent = true }
			)
			vim.keymap.set(
				"n",
				"<localleader>os",
				":noautocmd MoltenEnterOutput<CR>",
				{ desc = "open output window", silent = true }
			)
			vim.keymap.set(
				"n",
				"<localleader>rr",
				":MoltenReevaluateCell<CR>",
				{ desc = "re-eval cell", silent = true }
			)
            vim.keymap.set(
                "v",
                "<localleader>e",
                ":<C-u>MoltenEvaluateVisual<CR>gv",
                { desc = "execute visual selection", silent = true }
            )
			vim.keymap.set(
				"n",
				"<localleader>oh",
				":MoltenHideOutput<CR>",
				{ desc = "close output window", silent = true }
			)
			vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

			-- if you work with html outputs:
			vim.keymap.set(
				"n",
				"<localleader>mx",
				":MoltenOpenInBrowser<CR>",
				{ desc = "open output in browser", silent = true }
			)

			-- restart molten.nvim (add mapping only if none exists elsewhere)
			vim.keymap.set("n", "<localleader>mr", ":MoltenRestart!<CR>", { desc = "restart molten", silent = true })

			-- jupytext.nvim configuration: keep jupytext behavior consistent with markdown
			-- Repository: https://github.com/GCBallesteros/jupytext.nvim
			require("jupytext").setup({
				style = "markdown",
				output_extension = "md",
				force_ft = "markdown",
			})

			-- Provide a command to create a blank new Python notebook
			-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
			-- if you use another language than Python, you should change it in the template.
			local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

			local function new_notebook(filename)
				if not filename or filename == "" then
					print("NewNotebook cancelled")
					return
				end
				local path = filename
				if not path:match("%.ipynb$") then
					path = path .. ".ipynb"
				end
				local file = io.open(path, "w")
				if file then
					file:write(default_notebook)
					file:close()
					-- open the newly created file, using fnameescape for safety
					vim.cmd("edit " .. vim.fn.fnameescape(path))
				else
					print("Error: Could not open new notebook file for writing: " .. path)
				end
			end

			vim.api.nvim_create_user_command('NewNotebook', function(opts)
				new_notebook(opts.args)
			end, {
				nargs = 1,
				complete = 'file',
			})

			-- Keymap to create a new molten notebook; prompts for a path (file completion)
			vim.keymap.set('n', '<localleader>mc', function()
				local name = vim.fn.input('New notebook path: ', '', 'file')
				if name and name ~= '' then
					new_notebook(name)
				end
			end, { desc = 'Molten create notebook', silent = true })
		end,
	},
	{
		-- see the image.nvim readme for more information about configuring this plugin
		"3rd/image.nvim",
		opts = {
			backend = "kitty", -- whatever backend you would like to use
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},
}
