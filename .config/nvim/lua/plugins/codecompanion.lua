return {
	"olimorris/codecompanion.nvim",
	lazy = false,
	dependencies = {
		"j-hui/fidget.nvim",
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
							callback = "strategies.chat.slash_commands.file",
							description = "Select a file using FZF",
							opts = {
								provider = "fzf_lua",
								contains_code = true,
							},
						},
						["model"] = {
							callback = "strategies.chat.slash_commands.model",
							description = "Change the LLM model",
						},
					},
				},
			},

			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ",
					provider = "telescope",
					opts = {
						show_default_actions = true,
						show_default_prompt_library = true,
					},
				},
				chat = {
					icons = {
						pinned_buffer = " ",
						watched_buffer = "👀 ",
					},
					header = {
						model = true, -- Show the current model in use
					},
				},
			},

			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-4o", -- Latest Claude model
								choices = {
									"claude-3-opus-20240229", -- Latest Claude 3 Opus
									"claude-3-sonnet-20240229", -- Latest Claude 3 Sonnet
									"claude-3-haiku-20240307", -- Latest Claude 3 Haiku
									"gpt-4o", -- Latest GPT-4o
									"gpt-4-turbo",
									"gpt-4",
									"gpt-3.5-turbo",
								},
							},
							temperature = {
								default = 0.1,
								min = 0,
								max = 1,
								step = 0.1,
							},
							top_p = {
								default = 0.95,
								min = 0,
								max = 1,
								step = 0.05,
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

			adapter = "copilot",
		})

		-- Add keybinding for action palette
		vim.keymap.set("n", "<leader>ap", function()
			codecompanion.actions()
		end, { desc = "CodeCompanion Action Palette" })

		-- Add keybinding for chat command
		vim.keymap.set("n", "<leader>ac", function()
			codecompanion.chat()
		end, { desc = "CodeCompanion Chat" })

		-- Add keybinding to switch models quickly
		vim.keymap.set("n", "<leader>am", function()
			codecompanion.chat.model()
		end, { desc = "CodeCompanion Switch Model" })

		-- Custom commands for specific models
		vim.api.nvim_create_user_command("CCOpus", function()
			codecompanion.chat({ model = "claude-3-opus-20240229" })
		end, { desc = "Start CodeCompanion with Claude 3 Opus" })

		vim.api.nvim_create_user_command("CCSonnet", function()
			codecompanion.chat({ model = "claude-3-sonnet-20240229" })
		end, { desc = "Start CodeCompanion with Claude 3 Sonnet" })

		vim.api.nvim_create_user_command("CCHaiku", function()
			codecompanion.chat({ model = "claude-3-haiku-20240307" })
		end, { desc = "Start CodeCompanion with Claude 3 Haiku" })
	end,
}
