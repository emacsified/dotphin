return {
	"ggandor/leap.nvim",
	enabled = true,
	config = function()
		local leap = require("leap")
		vim.keymap.set("n", "s", function() leap.go_forward() end, { desc = "Leap Forward to" })
		vim.keymap.set("n", "S", function() leap.go_backward() end, { desc = "Leap Backward to" })
		vim.keymap.set("n", "gs", function() leap.go_from_windows() end, { desc = "Leap from Windows" })
		leap.add_default_mappings(true)
	end

}
