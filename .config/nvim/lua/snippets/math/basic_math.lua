-- =============================================
-- BASIC MATH SNIPPETS (AUTO-EXPANDING)
-- =============================================
-- These snippets trigger automatically while typing in math mode
-- Optimized for common LaTeX patterns with mixed approach:
-- - Auto-expand for frequently used patterns
-- - High performance with regex-based triggers

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

local math = require('utils.math')

local snippets = {
	-- ===== MATH MODE ENTRY/EXIT (auto, outside math) =====
	s({trig = "mk", snippetType = "autosnippet", wordTrig = true, condition = math.not_math},
		{t("$"), i(1), t("$"), i(0)}
	),
	
	s({trig = "dm", snippetType = "autosnippet", wordTrig = true, condition = math.not_math},
		{t("$$"), t({"", ""}), i(1), t({"", "$$"}), i(0)}
	),
	
	-- ===== FRACTIONS (auto, inside math) =====
	-- Simple: // → \frac{}{}
	s({trig = "//", snippetType = "autosnippet", condition = math.math},
		{t("\\frac{"), i(1), t("}{"), i(2), t("}"), i(0)}
	),
	
	-- Advanced fraction with regex: (a+b)/ → \frac{a+b}{}
	s({trig = "(.*)%)/", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip)
			local expr = snip.captures[1]
			-- Find matching parentheses
			local depth = 0
			local start_pos = 0
			
			for i = #expr, 1, -1 do
				local char = expr:sub(i, i)
				if char == ')' then
					depth = depth + 1
				elseif char == '(' then
					depth = depth - 1
					if depth == 0 then
						start_pos = i
						break
					end
				end
			end
			
			if start_pos > 0 then
				local before = expr:sub(1, start_pos - 1)
				local inside = expr:sub(start_pos + 1, -2) -- Remove parentheses
				return before .. "\\frac{" .. inside .. "}{"
			else
				return "\\frac{" .. expr .. "}{"
			end
		end),
		i(1), t("}"), i(0)
	),
	
	-- ===== SUBSCRIPTS & SUPERSCRIPTS (auto with regex) =====
	-- x1 → x_1, x2 → x_2, etc.
	s({trig = "([%a%d])1", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return snip.captures[1] .. "_1" end)
	),
	
	s({trig = "([%a%d])2", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return snip.captures[1] .. "_2" end)
	),
	
	s({trig = "([%a%d])3", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return snip.captures[1] .. "_3" end)
	),
	
	s({trig = "([%a%d])n", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return snip.captures[1] .. "_n" end)
	),
	
	s({trig = "([%a%d])i", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return snip.captures[1] .. "_i" end)
	),
	
	-- Quick powers: sr → ^2, cb → ^3, td → ^{}
	s({trig = "sr", snippetType = "autosnippet", condition = math.math},
		{t("^2")}
	),
	
	s({trig = "cb", snippetType = "autosnippet", condition = math.math},
		{t("^3")}
	),
	
	s({trig = "td", snippetType = "autosnippet", condition = math.math},
		{t("^{"), i(1), t("}"), i(0)}
	),
	
	s({trig = "rd", snippetType = "autosnippet", condition = math.math},
		{t("^{"), i(1), t("}"), i(0)}
	),
	
	-- ===== COMMON SYMBOLS (auto) =====
	s({trig = "ooo", snippetType = "autosnippet", condition = math.math},
		{t("\\infty")}
	),
	
	s({trig = "...", snippetType = "autosnippet", condition = math.math},
		{t("\\cdots")}
	),
	
	s({trig = "xx", snippetType = "autosnippet", condition = math.math},
		{t("\\times")}
	),
	
	s({trig = "**", snippetType = "autosnippet", condition = math.math},
		{t("\\star")}
	),
	
	s({trig = "+-", snippetType = "autosnippet", condition = math.math},
		{t("\\pm")}
	),
	
	s({trig = "-+", snippetType = "autosnippet", condition = math.math},
		{t("\\mp")}
	),
	
	-- ===== GREEK LETTERS (auto, essential ones) =====
	s({trig = "aa", snippetType = "autosnippet", condition = math.math},
		{t("\\alpha")}
	),
	
	s({trig = "bb", snippetType = "autosnippet", condition = math.math},
		{t("\\beta")}
	),
	
	s({trig = "gg", snippetType = "autosnippet", condition = math.math},
		{t("\\gamma")}
	),
	
	s({trig = "dd", snippetType = "autosnippet", condition = math.math},
		{t("\\delta")}
	),
	
	s({trig = "ee", snippetType = "autosnippet", condition = math.math},
		{t("\\epsilon")}
	),
	
	s({trig = "zz", snippetType = "autosnippet", condition = math.math},
		{t("\\zeta")}
	),
	
	s({trig = "ll", snippetType = "autosnippet", condition = math.math},
		{t("\\lambda")}
	),
	
	s({trig = "mm", snippetType = "autosnippet", condition = math.math},
		{t("\\mu")}
	),
	
	s({trig = "nn", snippetType = "autosnippet", condition = math.math},
		{t("\\nu")}
	),
	
	s({trig = "pp", snippetType = "autosnippet", condition = math.math},
		{t("\\pi")}
	),
	
	s({trig = "rr", snippetType = "autosnippet", condition = math.math},
		{t("\\rho")}
	),
	
	s({trig = "ss", snippetType = "autosnippet", condition = math.math},
		{t("\\sigma")}
	),
	
	s({trig = "tt", snippetType = "autosnippet", condition = math.math},
		{t("\\tau")}
	),
	
	s({trig = "ff", snippetType = "autosnippet", condition = math.math},
		{t("\\phi")}
	),
	
	s({trig = "cc", snippetType = "autosnippet", condition = math.math},
		{t("\\chi")}
	),
	
	s({trig = "ww", snippetType = "autosnippet", condition = math.math},
		{t("\\omega")}
	),
	
	-- Capital Greek (with shift pattern)
	s({trig = "GG", snippetType = "autosnippet", condition = math.math},
		{t("\\Gamma")}
	),
	
	s({trig = "DD", snippetType = "autosnippet", condition = math.math},
		{t("\\Delta")}
	),
	
	s({trig = "TT", snippetType = "autosnippet", condition = math.math},
		{t("\\Theta")}
	),
	
	s({trig = "LL", snippetType = "autosnippet", condition = math.math},
		{t("\\Lambda")}
	),
	
	s({trig = "PP", snippetType = "autosnippet", condition = math.math},
		{t("\\Pi")}
	),
	
	s({trig = "SS", snippetType = "autosnippet", condition = math.math},
		{t("\\Sigma")}
	),
	
	s({trig = "FF", snippetType = "autosnippet", condition = math.math},
		{t("\\Phi")}
	),
	
	s({trig = "WW", snippetType = "autosnippet", condition = math.math},
		{t("\\Omega")}
	),
	
	-- ===== RELATIONS & OPERATORS (auto) =====
	s({trig = "!=", snippetType = "autosnippet", condition = math.math},
		{t("\\neq")}
	),
	
	s({trig = "<=", snippetType = "autosnippet", condition = math.math},
		{t("\\leq")}
	),
	
	s({trig = ">=", snippetType = "autosnippet", condition = math.math},
		{t("\\geq")}
	),
	
	s({trig = "<<", snippetType = "autosnippet", condition = math.math},
		{t("\\ll")}
	),
	
	s({trig = ">>", snippetType = "autosnippet", condition = math.math},
		{t("\\gg")}
	),
	
	s({trig = "~~", snippetType = "autosnippet", condition = math.math},
		{t("\\sim")}
	),
	
	s({trig = "=~", snippetType = "autosnippet", condition = math.math},
		{t("\\approx")}
	),
	
	s({trig = "==", snippetType = "autosnippet", condition = math.math},
		{t("\\equiv")}
	),
	
	-- Arrows
	s({trig = "->", snippetType = "autosnippet", condition = math.math},
		{t("\\to")}
	),
	
	s({trig = "=>", snippetType = "autosnippet", condition = math.math},
		{t("\\Rightarrow")}
	),
	
	s({trig = "=<", snippetType = "autosnippet", condition = math.math},
		{t("\\Leftarrow")}
	),
	
	s({trig = "<>", snippetType = "autosnippet", condition = math.math},
		{t("\\Leftrightarrow")}
	),
	
	-- ===== LOGIC & SET THEORY (auto) =====
	s({trig = "inn", snippetType = "autosnippet", condition = math.math},
		{t("\\in")}
	),
	
	s({trig = "notin", snippetType = "autosnippet", condition = math.math},
		{t("\\notin")}
	),
	
	s({trig = "\\\\\\", snippetType = "autosnippet", condition = math.math},
		{t("\\setminus")}
	),
	
	s({trig = "sub", snippetType = "autosnippet", condition = math.math},
		{t("\\subset")}
	),
	
	s({trig = "sup", snippetType = "autosnippet", condition = math.math},
		{t("\\supset")}
	),
	
	s({trig = "UU", snippetType = "autosnippet", condition = math.math},
		{t("\\cup")}
	),
	
	s({trig = "NN", snippetType = "autosnippet", condition = math.math},
		{t("\\cap")}
	),
	
	s({trig = "EE", snippetType = "autosnippet", condition = math.math},
		{t("\\exists")}
	),
	
	s({trig = "AA", snippetType = "autosnippet", condition = math.math},
		{t("\\forall")}
	),
	
	-- ===== ACCENTS & DECORATIONS (auto with regex) =====
	-- xhat → \hat{x}
	s({trig = "([%a])hat", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\hat{" .. snip.captures[1] .. "}" end)
	),
	
	s({trig = "([%a])bar", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\overline{" .. snip.captures[1] .. "}" end)
	),
	
	s({trig = "([%a])dot", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\dot{" .. snip.captures[1] .. "}" end)
	),
	
	s({trig = "([%a])ddot", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\ddot{" .. snip.captures[1] .. "}" end)
	),
	
	s({trig = "([%a])tilde", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\tilde{" .. snip.captures[1] .. "}" end)
	),
	
	s({trig = "([%a])vec", regTrig = true, snippetType = "autosnippet", condition = math.math},
		f(function(_, snip) return "\\vec{" .. snip.captures[1] .. "}" end)
	),
	
	-- ===== ROOTS & BASIC FUNCTIONS (auto) =====
	s({trig = "sq", snippetType = "autosnippet", condition = math.math},
		{t("\\sqrt{"), i(1), t("}")}
	),
	
	-- ===== QUICK DELIMITERS (auto) =====
	s({trig = "()", snippetType = "autosnippet", condition = math.math},
		{t("("), i(1), t(")")}
	),
	
	s({trig = "[]", snippetType = "autosnippet", condition = math.math},
		{t("["), i(1), t("]")}
	),
}

return snippets