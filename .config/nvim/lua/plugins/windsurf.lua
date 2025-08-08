-- add this to the file where you setup your other plugins:
return {
	"monkoose/neocodeium",
	lazy = true,
	-- event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<A-f>", neocodeium.accept)
	end,
}
