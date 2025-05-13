return {
	"olimorris/codecompanion.nvim", -- The KING of AI programming
	lazy = false,
	dependencies = {
		"j-hui/fidget.nvim",
		--{ "echasnovski/mini.pick", config = true },
		{ "ibhagwan/fzf-lua", config = true },
	},
	config = function()
		local codecompanion = require("codecompanion")
		codecompanion.setup({
			strategies = {
				chat = {
					mappings = {
						close = {
							modes = { n = "", i = "" },
						},
					},
					slash_commands = {
						["file"] = {
							-- Location to the slash command in CodeCompanion
							callback = "strategies.chat.slash_commands.file",
							description = "Select a file using Telescope",
							opts = {
								provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
								contains_code = true,
							},
						},
					},
				},
			},

			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "telescope", -- default|telescope|mini_pick
					opts = {
						show_default_actions = true, -- Show the default actions in the action palette?
						show_default_prompt_library = true, -- Show the default prompt library in the action palette?
					},
				},
				chat = {
					icons = {
						pinned_buffer = " ",
						watched_buffer = "👀 ",
					},
				},
			},

			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							num_ctx = {
								default = 20000,
							},
						},
					})
				end,
			},
		})

		-- Add keybinding for action palette
		vim.keymap.set("n", "<leader>ap", function()
			codecompanion.actions()
		end, { desc = "CodeCompanion Action Palette" })

		-- Add keybinding for chat command
		vim.keymap.set("n", "<leader>ac", function()
			codecompanion.chat()
		end, { desc = "CodeCompanion Chat" })
	end,
}
