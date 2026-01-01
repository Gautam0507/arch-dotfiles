-- =============================================
-- EXTENDED GREEK LETTERS COLLECTION
-- =============================================
-- Complete Greek alphabet with variants
-- Load with: require('snippets.math.init').load_greek()

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

local math = require('utils.math')

-- Extended Greek alphabet (beyond basics in basic_math.lua)
local snippets = {
	-- Lowercase variants not in basic collection
	s({trig = "eta", snippetType = "autosnippet", condition = math.math},
		{t("\\eta")}
	),
	
	s({trig = "theta", snippetType = "autosnippet", condition = math.math},
		{t("\\theta")}
	),
	
	s({trig = "iota", snippetType = "autosnippet", condition = math.math},
		{t("\\iota")}
	),
	
	s({trig = "kappa", snippetType = "autosnippet", condition = math.math},
		{t("\\kappa")}
	),
	
	s({trig = "xi", snippetType = "autosnippet", condition = math.math},
		{t("\\xi")}
	),
	
	s({trig = "omicron", snippetType = "autosnippet", condition = math.math},
		{t("\\omicron")}
	),
	
	s({trig = "upsilon", snippetType = "autosnippet", condition = math.math},
		{t("\\upsilon")}
	),
	
	s({trig = "psi", snippetType = "autosnippet", condition = math.math},
		{t("\\psi")}
	),
	
	-- Uppercase variants  
	s({trig = "ETA", snippetType = "autosnippet", condition = math.math},
		{t("\\Eta")}
	),
	
	s({trig = "IOTA", snippetType = "autosnippet", condition = math.math},
		{t("\\Iota")}
	),
	
	s({trig = "KAPPA", snippetType = "autosnippet", condition = math.math},
		{t("\\Kappa")}
	),
	
	s({trig = "XI", snippetType = "autosnippet", condition = math.math},
		{t("\\Xi")}
	),
	
	s({trig = "UPSILON", snippetType = "autosnippet", condition = math.math},
		{t("\\Upsilon")}
	),
	
	s({trig = "PSI", snippetType = "autosnippet", condition = math.math},
		{t("\\Psi")}
	),
	
	-- Variants
	s({trig = "vartheta", snippetType = "autosnippet", condition = math.math},
		{t("\\vartheta")}
	),
	
	s({trig = "varpi", snippetType = "autosnippet", condition = math.math},
		{t("\\varpi")}
	),
	
	s({trig = "varrho", snippetType = "autosnippet", condition = math.math},
		{t("\\varrho")}
	),
	
	s({trig = "varsigma", snippetType = "autosnippet", condition = math.math},
		{t("\\varsigma")}
	),
	
	s({trig = "varphi", snippetType = "autosnippet", condition = math.math},
		{t("\\varphi")}
	),
	
	s({trig = "varepsilon", snippetType = "autosnippet", condition = math.math},
		{t("\\varepsilon")}
	),
}

return snippets