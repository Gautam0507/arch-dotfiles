-- =============================================
-- MATH CONTEXT DETECTION FOR MARKDOWN
-- =============================================
-- Detects if cursor is inside LaTeX math environments ($...$ or $$...$$)
-- Optimized for performance with hybrid detection methods

local M = {}

-- Basic regex-based math detection (fast)
function M.in_mathzone()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	
	-- Count unescaped $ symbols before cursor
	local math_count = 0
	local escaped = false
	
	for i = 1, col do
		local char = line:sub(i, i)
		if char == '\\' and not escaped then
			escaped = true
		elseif char == '$' and not escaped then
			math_count = math_count + 1
		else
			escaped = false
		end
	end
	
	-- Odd number = inside math, even = outside
	return math_count % 2 == 1
end

-- Check for display math ($$...$$)
function M.in_display_math()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	
	local before = line:sub(1, col)
	local after = line:sub(col + 1)
	
	-- Check for $$ pattern
	local double_before = before:find("%$%$[^$]*$")
	local double_after = after:find("^[^$]*%$%$")
	
	return double_before and double_after
end

-- TreeSitter-based detection (more reliable, slightly slower)
function M.in_math_ts()
	local filetype = vim.bo.filetype
	if filetype ~= 'markdown' then
		return false
	end
	
	local buf = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1 -- 0-indexed
	
	local ok, parser = pcall(vim.treesitter.get_parser, buf, 'markdown')
	if not ok or not parser then
		return M.in_mathzone() -- Fallback
	end
	
	local tree = parser:parse()[1]
	if not tree then return M.in_mathzone() end
	
	local node = tree:root():named_descendant_for_range(row, col, row, col)
	
	while node do
		local type = node:type()
		if type == 'inline_formula' or type == 'latex_block' or type == 'code_span' then
			-- In code span is also "math-like" for LaTeX
			return type ~= 'code_span' or M.in_mathzone()
		end
		node = node:parent()
	end
	
	return M.in_mathzone()
end

-- Main detection function (uses hybrid approach)
function M.in_math()
	-- For performance: use regex as quick check first
	if not M.in_mathzone() then
		return false
	end
	
	-- For reliability: verify with TreeSitter if available
	-- (TreeSitter is slower, so only check if regex says we're in math)
	if vim.b.math_detection_method == 'treesitter' then
		return M.in_math_ts()
	end
	
	return true
end

-- Conditions for snippets
function M.math() return M.in_math() end
function M.not_math() return not M.in_math() end

-- Debug function - shows current detection status
function M.debug_status()
	local status = {
		in_math = M.in_math(),
		in_mathzone = M.in_mathzone(),
		in_display = M.in_display_math(),
		detection_method = vim.b.math_detection_method or 'none',
		filetype = vim.bo.filetype,
		line = vim.api.nvim_get_current_line(),
		col = vim.api.nvim_win_get_cursor(0)[2],
	}
	print(vim.inspect(status))
	return status
end

return M