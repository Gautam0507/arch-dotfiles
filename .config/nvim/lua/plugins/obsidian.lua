return {
	"epwalsh/obsidian.nvim",
	init = function()
		-- Set conceallevel for ALL markdown buffers (will be refined later)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.opt_local.conceallevel = 2 -- Temporary global setting
			end,
		})
	end,
	version = "*",
	lazy = true,
	event = {
		"BufReadPre /home/Gautam/Documents/obsidian-notes/*.md",
		"BufNewFile /home/Gautam/Documents/obsidian-notes/*.md",
	},
	keys = {
		{
			"<leader>so",
			":ObsidianQuickSwitch<CR>",
			desc = "Open Obsidian Quick Switcher",
			mode = "n",
		},
		{
			"<leader>oo",
			":ObsidianOpen<CR>",
			desc = "Open the note in the app",
			mode = "n",
		},
		{
			"<leader>ob",
			":ObsidianBacklinks<CR>",
			desc = "Open backlinks for the note",
			mode = "n",
		},
		{
			"<leader>ot",
			":ObsidianTemplate<CR>",
			desc = "Open templates to insert into the buffer",
			mode = "n",
		},
		{
			"<leader>os",
			":ObsidianSearch<CR>",
			desc = "Search through notes",
			mode = "n",
		},
		{
			"<leader>od",
			":ObsidianDailies<CR>",
			desc = "Search through recent dailies",
			mode = "n",
		},
		{
			"<leader>od",
			":ObsidianToday<CR>",
			desc = "Open today's note",
			mode = "n",
		},
		{
			"<leader>opi",
			":ObsidianPasteImg<CR>",
			desc = "Open today's note",
			mode = "n",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "/home/Gautam/Documents/obsidian-notes",
			},
		},
		daily_notes = {
			folder = "dailyNotes",
			date_format = "%d-%m-%y",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = "DailyNoteTemplate.md",
		},
		completion = {
			nvim_cmp = true,
			min_chars = 1,
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		new_notes_location = "current_dir",
		note_id_func = function(title)
			if not title then
				return ""
			end
			local cleaned_title = title
				:gsub("%s+", " ")
				:gsub("^%s*(.-)%s*$", "%1")
				:gsub("(%a)([%w_']*)", function(first, rest)
					return first:upper() .. rest:lower()
				end)
			return cleaned_title
		end,
		note_path_func = function(spec)
			local title = spec.title or "Untitled"
			return title .. ".md"
		end,
		wiki_link_func = function(opts)
			local title = opts.label or opts.title or opts.id
			local alias = title:lower()
			return string.format("[[%s|%s]]", title, alias)
		end,
		markdown_link_func = function(opts)
			return require("obsidian.util").markdown_link(opts)
		end,
		preferred_link_style = "wiki",
		disable_frontmatter = false,
		note_frontmatter_func = function(note)
			local out = { aliases = note.aliases, tags = note.tags }
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,
		templates = {
			folder = "templates",
			date_format = "%d-%m-%y",
			time_format = "%H:%M",
			substitutions = {},
		},
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,
		follow_img_func = function(img)
			vim.fn.jobstart({ "xdg-open", url })
		end,
		use_advanced_uri = false,
		open_app_foreground = false,
		picker = {
			name = "telescope.nvim",
			note_mappings = {
				new = "<C-CR>",
				insert_link = "<C-l>",
			},
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
		},
		sort_by = "modified",
		sort_reversed = true,
		search_max_lines = 1000,
		open_notes_in = "current",
		callbacks = {
			post_setup = function(client)
				vim.api.nvim_clear_autocmds({ group = "ObsidianConceal" })
				vim.api.nvim_create_autocmd("FileType", {
					group = vim.api.nvim_create_augroup("ObsidianConceal", {}),
					pattern = "markdown",
					callback = function()
						if string.find(vim.fn.expand("%:p"), "/home/Gautam/Documents/obsidian-notes") then
							vim.opt_local.conceallevel = 2
						else
							vim.opt_local.conceallevel = 0 -- Reset for non-Obsidian markdown
						end
					end,
				})
			end,
			enter_note = function(client, note)
				vim.opt_local.conceallevel = 2
			end,
			leave_note = function(client, note) end,
			pre_write_note = function(client, note) end,
			post_set_workspace = function(client, workspace) end,
		},
		ui = {
			enable = true,
			update_debounce = 200,
			max_file_length = 5000,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = "", hl_group = "ObsidianImportant" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			block_ids = { hl_group = "ObsidianBlockID" },
			hl_groups = {
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianImportant = { bold = true, fg = "#d73128" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianBlockID = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},
		attachments = {
			img_folder = "attachments",
			img_name_func = function()
				return string.format("%s-", os.time())
			end,
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},
	},
}
