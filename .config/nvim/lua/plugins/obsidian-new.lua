return {
	"obsidian-nvim/obsidian.nvim",
	init = function()
		-- Set conceallevel to 2 only for obsidian vault files on plugin load
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				-- Only set conceallevel for files in obsidian vault
				if string.find(vim.fn.expand("%:p"), "/home/Gautam/Documents/obsidian-vault") then
					vim.opt_local.conceallevel = 2
				end
			end,
		})
	end,
	version = "3.14.7", -- Pinned to avoid blink.cmp completion bug in 3.14.8
	lazy = true,
	event = {
		"BufReadPre /home/Gautam/Documents/obsidian-vault/*.md",
		"BufNewFile /home/Gautam/Documents/obsidian-vault/*.md",
	},
	ft = "markdown",
	---@module 'obsidian'
	---@type obsidian.config
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
			desc = "Paste image into note",
			mode = "n",
		},
		{
			"<leader>on",
			":ObsidianNew ",
			desc = "Create new Obsidian note",
			mode = "n",
		},
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		-- nvim-cmp dependency removed for blink.cmp compatibility
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "/home/Gautam/Documents/obsidian-vault",
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
			blink = true, -- Enable blink.cmp completion
			nvim_cmp = false, -- Disable nvim-cmp (auto-disabled when blink=true)
			min_chars = 1, -- Minimum characters to trigger completion
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
        -- Place new notes at the vault root (no sub‑directory)
        new_notes_location = "notes_subdir",
		note_id_func = function(title)
			if not title then
				return ""
			end
			-- Convert to kebab-case for new notes
			-- "Adam Optimizer" -> "adam-optimizer"
			return title
				:lower() -- convert to lowercase
				:gsub("%s+", "-") -- replace spaces with hyphens
				:gsub("[^%w%-]", "") -- remove special characters except letters, numbers, hyphens
		end,
		note_path_func = function(spec)
			-- Use the kebab-case id for new file creation
			local id = spec.id or spec.title
			if spec.title and not spec.id then
				-- If creating a new note, apply kebab-case transformation
				id = spec.title:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
			end
			return id .. ".md"
		end,
		-- wiki_link_func removed - uses default obsidian behavior
		-- Default creates simple [[Link Name]] without aliases
		-- 		-- Add this to your opts table in obsidian-new.lua
		wiki_link_func = function(opts)
			local link_id = opts.id or opts.path or opts.label
			-- Debug logging
			vim.notify("wiki_link_func called with: " .. vim.inspect(opts), vim.log.levels.INFO)

			if link_id and link_id:match("%-") then
				local alias = link_id:gsub("%-", " "):gsub("(%w)(%w*)", function(first, rest)
					return first:upper() .. rest:lower()
				end)
				return string.format("[[%s|%s]]", link_id, alias)
			else
				return string.format("[[%s]]", link_id)
			end
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
			vim.fn.jobstart({ "xdg-open", img }) -- Fixed: was 'url', should be 'img'
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
				-- Create or get the augroup first
				local augroup = vim.api.nvim_create_augroup("ObsidianConceal", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = augroup,
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
			pre_write_note = function(client, note)
				-- Auto-format wiki links to add aliases for kebab-case names
				local function format_wiki_links_in_buffer()
					local bufnr = vim.api.nvim_get_current_buf()
					local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
					local modified = false

					-- Function to convert kebab-case to readable text (remove dashes, keep original case)
					local function kebab_to_readable(text)
						return text:gsub("%-", " ")
					end

					for i, line in ipairs(lines) do
						local new_line = line

						-- Process regular wiki links without aliases: [[text]] -> [[text|Text]]
						new_line = new_line:gsub("%[%[([^%]|#]+)%]%]", function(link_name)
							if link_name:match("%-") then
								local alias = kebab_to_readable(link_name)
								return string.format("[[%s|%s]]", link_name, alias)
							end
							return "[[" .. link_name .. "]]" -- Return unchanged if no dashes
						end)

						-- Process heading links without aliases: [[file#heading]] -> [[file#heading|Heading]]
						new_line = new_line:gsub("%[%[([^%]|#]+)#([^%]|]+)%]%]", function(file_name, heading)
							if heading:match("%-") then
								local alias = kebab_to_readable(heading)
								return string.format("[[%s#%s|%s]]", file_name, heading, alias)
							end
							return string.format("[[%s#%s]]", file_name, heading) -- Return unchanged if no dashes
						end)

						if new_line ~= line then
							lines[i] = new_line
							modified = true
						end
					end

					if modified then
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
					end
				end

				-- Only format wiki links in obsidian vault files
				local file_path = vim.fn.expand("%:p")
				if file_path:match("/home/Gautam/Documents/obsidian-vault") then
					format_wiki_links_in_buffer()
				end
			end,
			post_set_workspace = function(client, workspace) end,
		},
		ui = {
			enable = true,
			update_debounce = 200,
			max_file_length = 5000,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = "", hl_group = "ObsidianImportant" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
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
