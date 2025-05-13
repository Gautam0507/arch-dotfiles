-- Autocompletion using nvim-cmp
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- Uncomment to load friendly snippets
				-- {
				--   "rafamadriz/friendly-snippets",
				--   config = function()
				--     require("luasnip.loaders.from_vscode").lazy_load()
				--   end,
				-- },
			},
			opts = {},
		},
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"folke/lazydev.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<Tab>"] = cmp.mapping.confirm({ select = true }), -- 'super-tab' preset
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			formatting = {
				format = function(entry, vim_item)
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						path = "[Path]",
						luasnip = "[Snip]",
						lazydev = "[LazyDev]",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "lazydev", priority = 100 },
			}),
			window = {
				documentation = {
					border = "rounded",
					winhighlight = "Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
				},
			},
			experimental = {
				ghost_text = false,
			},
		})

		-- LazyDev integration
		require("lazydev").setup()
	end,
}
