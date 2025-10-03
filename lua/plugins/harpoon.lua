return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader><leader>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		-- vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end); -- hmmm....
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)

		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end)
		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():prev()
		end)

		-- -- Set <space>1..<space>5 be my shortcuts to moving to the files
		-- for _, idx in ipairs { 1, 2, 3, 4, 5 } do
		--   vim.keymap.set("n", string.format("<space>%d", idx), function()
		--     harpoon:list():select(idx);
		--   end);
		-- end
	end,
}
