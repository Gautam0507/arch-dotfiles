-- =============================================
-- MATH PERFORMANCE OPTIMIZATION
-- =============================================
-- Optimizes math snippet performance for large files and quick detection

local M = {}

function M.setup()
	-- Detect available math detection method on markdown open
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			local ok, parser = pcall(vim.treesitter.get_parser, buf, 'markdown')
			
			if ok and parser then
				vim.b.math_detection_method = 'treesitter'
			else
				vim.b.math_detection_method = 'regex'
			end
		end
	})
	
	-- Cache math context to avoid repeated checks
	local math_cache = {}
	local last_check_line = -1
	
	vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
		pattern = "*.md",
		callback = function()
			local current_line = vim.api.nvim_win_get_cursor(0)[1]
			if current_line ~= last_check_line then
				math_cache = {}
				last_check_line = current_line
			end
		end
	})
	
	-- Performance: Optimize for large files
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*.md",
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			local line_count = vim.api.nvim_buf_line_count(buf)
			
			-- For very large files, use only regex detection
			if line_count > 5000 then
				vim.b.math_detection_method = 'regex'
			end
		end
	})
	
	-- Setup debug command for troubleshooting
	vim.api.nvim_create_user_command('MathDebug', function()
		local math_utils = require('utils.math')
		math_utils.debug_status()
	end, { desc = "Debug math context detection" })
	
	-- Setup command to test snippets
	vim.api.nvim_create_user_command('MathTest', function()
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		
		print("Math mode tests:")
		print("Line: " .. line)
		print("Column: " .. col)
		
		local math_utils = require('utils.math')
		print("in_mathzone(): " .. tostring(math_utils.in_mathzone()))
		print("in_math_ts(): " .. tostring(math_utils.in_math_ts()))
		print("in_math(): " .. tostring(math_utils.in_math()))
		print("in_display_math(): " .. tostring(math_utils.in_display_math()))
	end, { desc = "Test math detection functions" })
end

return M