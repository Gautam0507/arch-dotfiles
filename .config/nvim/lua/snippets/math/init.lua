-- =============================================
-- SMART SNIPPET LOADER
-- =============================================
-- Handles on-demand loading of math snippet collections
-- Provides infrastructure for expanding with Gilles Castel patterns

local M = {}

-- Track what's been loaded to avoid duplicates
local loaded_collections = {
	basic = false,
	advanced = false,
	greek = false,
	environments = false,
	comprehensive = false
}

-- Core snippets (always loaded on startup)
function M.load_basic()
	if loaded_collections.basic then
		return false
	end
	
	local ls = require('luasnip')
	local basic = require('snippets.math.basic_math')
	ls.add_snippets("markdown", basic)
	loaded_collections.basic = true
	return true
end

-- Advanced snippets (integrals, matrices, etc.)
function M.load_advanced()
	if loaded_collections.advanced then
		return false
	end
	
	local ls = require('luasnip')
	local advanced = require('snippets.math.advanced_math')
	ls.add_snippets("markdown", advanced)
	loaded_collections.advanced = true
	print("Advanced math snippets loaded (integrals, matrices, derivatives)")
	return true
end

-- Greek letters collection (load when needed)
function M.load_greek()
	if loaded_collections.greek then
		return false
	end
	
	-- You can create this file later with extended Greek alphabet
	local ok, greek = pcall(require, 'snippets.math.greek_letters')
	if ok then
		local ls = require('luasnip')
		ls.add_snippets("markdown", greek)
		loaded_collections.greek = true
		print("Extended Greek letters loaded")
		return true
	else
		print("Greek letters collection not found at snippets.math.greek_letters")
		return false
	end
end

-- Environments (align, split, etc.)
function M.load_environments()
	if loaded_collections.environments then
		return false
	end
	
	local ok, envs = pcall(require, 'snippets.math.environments')
	if ok then
		local ls = require('luasnip')
		ls.add_snippets("markdown", envs)
		loaded_collections.environments = true
		print("Math environments loaded (align, split, etc.)")
		return true
	else
		print("Environments collection not found at snippets.math.environments")
		return false
	end
end

-- Full Gilles Castel collection (500+ snippets)
function M.load_comprehensive()
	if loaded_collections.comprehensive then
		return false
	end
	
	local ok, comp = pcall(require, 'snippets.math.comprehensive')
	if ok then
		local ls = require('luasnip')
		ls.add_snippets("markdown", comp)
		loaded_collections.comprehensive = true
		print("Comprehensive Castel collection loaded (500+ snippets)")
		return true
	else
		print("Comprehensive collection not found at snippets.math.comprehensive")
		print("Create snippets/math/comprehensive.lua to use this feature")
		return false
	end
end

-- Load all available collections
function M.load_all()
	M.load_basic()
	M.load_advanced()
	M.load_greek()
	M.load_environments()
	M.load_comprehensive()
	print("All available math snippet collections loaded")
end

-- Get status of loaded collections
function M.status()
	print("Math Snippet Collections Status:")
	for name, loaded in pairs(loaded_collections) do
		local status = loaded and "✓ loaded" or "○ not loaded"
		print(string.format("  %s: %s", name, status))
	end
	
	-- Show available files
	print("\nAvailable collections to create:")
	local collections = {
		"snippets.math.greek_letters",
		"snippets.math.environments", 
		"snippets.math.comprehensive",
		"snippets.math.operators",
		"snippets.math.physics"
	}
	
	for _, collection in ipairs(collections) do
		local ok, _ = pcall(require, collection)
		local status = ok and "✓ exists" or "○ can create"
		print(string.format("  %s: %s", collection, status))
	end
end

-- Initialize with keymaps for easy loading
function M.setup_keymaps()
	-- Leader key mappings for loading collections
	vim.keymap.set('n', '<leader>mla', function()
		M.load_advanced()
	end, { noremap = true, desc = "Load advanced math snippets" })
	
	vim.keymap.set('n', '<leader>mlg', function()
		M.load_greek()
	end, { noremap = true, desc = "Load Greek letters" })
	
	vim.keymap.set('n', '<leader>mle', function()
		M.load_environments()
	end, { noremap = true, desc = "Load math environments" })
	
	vim.keymap.set('n', '<leader>mlc', function()
		M.load_comprehensive()
	end, { noremap = true, desc = "Load comprehensive collection" })
	
	vim.keymap.set('n', '<leader>mlA', function()
		M.load_all()
	end, { noremap = true, desc = "Load all math snippets" })
	
	vim.keymap.set('n', '<leader>mls', function()
		M.status()
	end, { noremap = true, desc = "Show math snippets status" })
end

-- Auto-load advanced on first Tab in math mode
function M.setup_auto_load()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function()
			-- Create buffer-local keymap to auto-load advanced on first Tab
			vim.keymap.set('i', '<Tab>', function()
				local math_utils = require('utils.math')
				if math_utils.in_math() then
					M.load_advanced()
				end
				-- Restore original Tab behavior
				vim.api.nvim_feedkeys(vim.keycode('<Tab>'), 'n', false)
			end, { buffer = true, silent = true })
		end
	})
end

-- Main setup function
function M.setup()
	-- Always load basic snippets
	M.load_basic()
	
	-- Setup keymaps for manual loading
	M.setup_keymaps()
	
	-- Setup auto-loading (optional, can be disabled)
	-- M.setup_auto_load()  -- Uncomment to enable auto-loading
end

return M