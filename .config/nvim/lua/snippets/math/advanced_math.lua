-- =============================================
-- ADVANCED MATH SNIPPETS (TAB-TRIGGERED)
-- =============================================
-- These snippets require manual Tab trigger for complex expressions
-- Optimized for performance - load on-demand for heavy operations
-- like integrals, matrices, environments

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

local math = require('utils.math')

local snippets = {
	-- ===== INTEGRALS & DERIVATIVES (tab-triggered for performance) =====
	s({trig = "int", condition = math.math},
		{t("\\int_{"), i(1, "a"), t("}^{"), i(2, "b"), t("} "), i(3), t(" \\, d"), i(4, "x"), i(0)}
	),
	
	s({trig = "iint", condition = math.math},
		{t("\\iint_{"), i(1, "D"), t("} "), i(2), t(" \\, dA"), i(0)}
	),
	
	s({trig = "iiint", condition = math.math},
		{t("\\iiint_{"), i(1, "D"), t("} "), i(2), t(" \\, dV"), i(0)}
	),
	
	s({trig = "oint", condition = math.math},
		{t("\\oint_{"), i(1, "C"), t("} "), i(2), t(" \\, d"), i(3, "x"), i(0)}
	),
	
	-- Indefinite integral
	s({trig = "dint", condition = math.math},
		{t("\\int "), i(1), t(" \\, d"), i(2, "x"), i(0)}
	),
	
	-- Derivatives
	s({trig = "dif", condition = math.math},
		{t("\\frac{d"), i(1, "y"), t("}{d"), i(2, "x"), t("}"), i(0)}
	),
	
	s({trig = "pdif", condition = math.math},
		{t("\\frac{\\partial "), i(1, "f"), t("}{\\partial "), i(2, "x"), t("}"), i(0)}
	),
	
	s({trig = "dif2", condition = math.math},
		{t("\\frac{d^2"), i(1, "y"), t("}{d"), i(2, "x"), t("^2}"), i(0)}
	),
	
	s({trig = "pdif2", condition = math.math},
		{t("\\frac{\\partial^2 "), i(1, "f"), t("}{\\partial "), i(2, "x"), t("^2}"), i(0)}
	),
	
	-- ===== SUMMATION & PRODUCTS =====
	s({trig = "sum", condition = math.math},
		{t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} "), i(0)}
	),
	
	s({trig = "prod", condition = math.math},
		{t("\\prod_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} "), i(0)}
	),
	
	s({trig = "coprod", condition = math.math},
		{t("\\coprod_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} "), i(0)}
	),
	
	-- Limits
	s({trig = "lim", condition = math.math},
		{t("\\lim_{"), i(1, "x \\to"), t(" "), i(2, "\\infty"), t("} "), i(0)}
	),
	
	s({trig = "limsup", condition = math.math},
		{t("\\limsup_{"), i(1, "n \\to \\infty"), t("} "), i(0)}
	),
	
	s({trig = "liminf", condition = math.math},
		{t("\\liminf_{"), i(1, "n \\to \\infty"), t("} "), i(0)}
	),
	
	-- ===== MATRICES (tab-triggered, complex) =====
	s({trig = "pmat", condition = math.math},
		{t("\\begin{pmatrix}"), t({"", "\t"}), i(1), t({"", "\\end{pmatrix}"}), i(0)}
	),
	
	s({trig = "bmat", condition = math.math},
		{t("\\begin{bmatrix}"), t({"", "\t"}), i(1), t({"", "\\end{bmatrix}"}), i(0)}
	),
	
	s({trig = "Bmat", condition = math.math},
		{t("\\begin{Bmatrix}"), t({"", "\t"}), i(1), t({"", "\\end{Bmatrix}"}), i(0)}
	),
	
	s({trig = "vmat", condition = math.math},
		{t("\\begin{vmatrix}"), t({"", "\t"}), i(1), t({"", "\\end{vmatrix}"}), i(0)}
	),
	
	s({trig = "Vmat", condition = math.math},
		{t("\\begin{Vmatrix}"), t({"", "\t"}), i(1), t({"", "\\end{Vmatrix}"}), i(0)}
	),
	
	-- 2x2 matrix shortcut
	s({trig = "2mat", condition = math.math},
		{t("\\begin{pmatrix} "), i(1, "a"), t(" & "), i(2, "b"), t(" \\\\ "), i(3, "c"), t(" & "), i(4, "d"), t(" \\end{pmatrix}"), i(0)}
	),
	
	-- ===== DELIMITERS & GROUPING =====
	s({trig = "lr(", condition = math.math},
		{t("\\left( "), i(1), t(" \\right)"), i(0)}
	),
	
	s({trig = "lr[", condition = math.math},
		{t("\\left[ "), i(1), t(" \\right]"), i(0)}
	),
	
	s({trig = "lr{", condition = math.math},
		{t("\\left\\{ "), i(1), t(" \\right\\}"), i(0)}
	),
	
	s({trig = "lr|", condition = math.math},
		{t("\\left| "), i(1), t(" \\right|"), i(0)}
	),
	
	s({trig = "lr||", condition = math.math},
		{t("\\left\\| "), i(1), t(" \\right\\|"), i(0)}
	),
	
	-- Angle brackets
	s({trig = "lra", condition = math.math},
		{t("\\left\\langle "), i(1), t(" \\right\\rangle"), i(0)}
	),
	
	-- ===== CASES & CONDITIONALS =====
	s({trig = "cases", condition = math.math},
		{t("\\begin{cases}"), t({"", "\t"}), i(1), t(" & "), i(2), t({"", "\\end{cases}"}), i(0)}
	),
	
	-- ===== ROOTS =====
	s({trig = "sqrt", condition = math.math},
		{t("\\sqrt{"), i(1), t("}"), i(0)}
	),
	
	s({trig = "nroot", condition = math.math},
		{t("\\sqrt["), i(1, "n"), t("]{"), i(2), t("}"), i(0)}
	),
	
	-- ===== TRIGONOMETRIC FUNCTIONS =====
	s({trig = "sin", condition = math.math},
		{t("\\sin "), i(0)}
	),
	
	s({trig = "cos", condition = math.math},
		{t("\\cos "), i(0)}
	),
	
	s({trig = "tan", condition = math.math},
		{t("\\tan "), i(0)}
	),
	
	s({trig = "cot", condition = math.math},
		{t("\\cot "), i(0)}
	),
	
	s({trig = "sec", condition = math.math},
		{t("\\sec "), i(0)}
	),
	
	s({trig = "csc", condition = math.math},
		{t("\\csc "), i(0)}
	),
	
	-- Inverse trig
	s({trig = "arcsin", condition = math.math},
		{t("\\arcsin "), i(0)}
	),
	
	s({trig = "arccos", condition = math.math},
		{t("\\arccos "), i(0)}
	),
	
	s({trig = "arctan", condition = math.math},
		{t("\\arctan "), i(0)}
	),
	
	-- Hyperbolic
	s({trig = "sinh", condition = math.math},
		{t("\\sinh "), i(0)}
	),
	
	s({trig = "cosh", condition = math.math},
		{t("\\cosh "), i(0)}
	),
	
	s({trig = "tanh", condition = math.math},
		{t("\\tanh "), i(0)}
	),
	
	-- ===== LOGARITHMS & EXPONENTIALS =====
	s({trig = "log", condition = math.math},
		{t("\\log "), i(0)}
	),
	
	s({trig = "ln", condition = math.math},
		{t("\\ln "), i(0)}
	),
	
	s({trig = "exp", condition = math.math},
		{t("\\exp "), i(0)}
	),
	
	s({trig = "lg", condition = math.math},
		{t("\\log_{10} "), i(0)}
	),
	
	s({trig = "logb", condition = math.math},
		{t("\\log_{"), i(1, "b"), t("} "), i(0)}
	),
	
	-- ===== LINEAR ALGEBRA =====
	s({trig = "inv", condition = math.math},
		{t("^{-1}"), i(0)}
	),
	
	s({trig = "tr", condition = math.math},
		{t("^T"), i(0)}
	),
	
	s({trig = "herm", condition = math.math},
		{t("^\\dagger"), i(0)}
	),
	
	s({trig = "det", condition = math.math},
		{t("\\det "), i(0)}
	),
	
	s({trig = "tr", condition = math.math},
		{t("\\operatorname{tr} "), i(0)}
	),
	
	s({trig = "rank", condition = math.math},
		{t("\\operatorname{rank} "), i(0)}
	),
	
	s({trig = "dim", condition = math.math},
		{t("\\dim "), i(0)}
	),
	
	s({trig = "ker", condition = math.math},
		{t("\\ker "), i(0)}
	),
	
	s({trig = "img", condition = math.math},
		{t("\\operatorname{im} "), i(0)}
	),
	
	-- Norms
	s({trig = "norm", condition = math.math},
		{t("\\|"), i(1), t("\\|"), i(0)}
	),
	
	s({trig = "norm1", condition = math.math},
		{t("\\|"), i(1), t("\\|_1"), i(0)}
	),
	
	s({trig = "norm2", condition = math.math},
		{t("\\|"), i(1), t("\\|_2"), i(0)}
	),
	
	s({trig = "normf", condition = math.math},
		{t("\\|"), i(1), t("\\|_F"), i(0)}
	),
	
	s({trig = "norminf", condition = math.math},
		{t("\\|"), i(1), t("\\|_\\infty"), i(0)}
	),
	
	-- ===== OPERATORS =====
	s({trig = "grad", condition = math.math},
		{t("\\nabla "), i(0)}
	),
	
	s({trig = "div", condition = math.math},
		{t("\\nabla \\cdot "), i(0)}
	),
	
	s({trig = "curl", condition = math.math},
		{t("\\nabla \\times "), i(0)}
	),
	
	s({trig = "lap", condition = math.math},
		{t("\\nabla^2 "), i(0)}
	),
	
	-- ===== PROBABILITY & STATISTICS =====
	s({trig = "prob", condition = math.math},
		{t("\\mathbb{P}\\left( "), i(1), t(" \\right)"), i(0)}
	),
	
	s({trig = "exp", condition = math.math},
		{t("\\mathbb{E}\\left[ "), i(1), t(" \\right]"), i(0)}
	),
	
	s({trig = "var", condition = math.math},
		{t("\\operatorname{Var}\\left( "), i(1), t(" \\right)"), i(0)}
	),
	
	s({trig = "cov", condition = math.math},
		{t("\\operatorname{Cov}\\left( "), i(1), t(", "), i(2), t(" \\right)"), i(0)}
	),
	
	-- ===== MISC ENVIRONMENTS & OPERATORS =====
	s({trig = "max", condition = math.math},
		{t("\\max_{"), i(1), t("} "), i(0)}
	),
	
	s({trig = "min", condition = math.math},
		{t("\\min_{"), i(1), t("} "), i(0)}
	),
	
	s({trig = "argmax", condition = math.math},
		{t("\\arg\\max_{"), i(1), t("} "), i(0)}
	),
	
	s({trig = "argmin", condition = math.math},
		{t("\\arg\\min_{"), i(1), t("} "), i(0)}
	),
	
	s({trig = "sup", condition = math.math},
		{t("\\sup_{"), i(1), t("} "), i(0)}
	),
	
	s({trig = "inf", condition = math.math},
		{t("\\inf_{"), i(1), t("} "), i(0)}
	),
}

return snippets