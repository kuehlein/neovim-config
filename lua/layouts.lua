local opts = { noremap = true, silent = true }

local colemak = function()
	-- Colemak mnei(hjkl), t(i), <C-n>(f), l(e)
	vim.keymap.set({ "n", "v" }, "m", "h", opts) -- Move left
	vim.keymap.set({ "n", "v" }, "n", "j", opts) -- Move down
	vim.keymap.set({ "n", "v" }, "e", "k", opts) -- Move up
	vim.keymap.set({ "n", "v" }, "i", "l", opts) -- Move right

	vim.keymap.set({ "n", "v" }, "gm", "gh", opts) -- Move left (with wrap)
	vim.keymap.set({ "n", "v" }, "gn", "gj", opts) -- Move down (with wrap)
	vim.keymap.set({ "n", "v" }, "ge", "gk", opts) -- Move up (with wrap)
	vim.keymap.set({ "n", "v" }, "gi", "gl", opts) -- Move right (with wrap)

	vim.keymap.set({ "n", "v" }, "t", "i", opts) -- (t)ype replaces (i)nsert
	vim.keymap.set({ "n", "v" }, "T", "I", opts) -- (T)ype at bol replaces (I)nsert

	vim.keymap.set({ "n", "v" }, "l", "e", opts) -- (l)ast replaces (e)nd
	vim.keymap.set({ "n", "v" }, "h", "m", opts) -- (h)ighlight replaces (m)ark

	-- vim.keymap.set('n', 'h', 'n', opts);          -- next match replaces (n)ext
	-- vim.keymap.set('n', 'k', 'N', opts);          -- previous match replaces (N) prev

	vim.keymap.set({ "n", "v" }, "<C-m>", "m", opts) -- mark replaces (m)ark

	-- vim.keymap.set('n', '<C-n>', '<C-f>', opts);  -- Page down
	-- vim.keymap.set('n', '<C-e>', '<C-b>H', opts); -- Page up, cursor up

	vim.keymap.set("n", "<C-w>m", "<C-w>h", opts) -- move to the left window
	vim.keymap.set("n", "<C-w>n", "<C-w>j", opts) -- move to the below window
	vim.keymap.set("n", "<C-w>e", "<C-w>k", opts) -- move to the above window
	vim.keymap.set("n", "<C-w>i", "<C-w>l", opts) -- move to the right window
end

local qwerty = function()
	vim.keymap.set({ "n", "v" }, "h", "h", opts)
	vim.keymap.set({ "n", "v" }, "j", "j", opts)
	vim.keymap.set({ "n", "v" }, "k", "k", opts)
	vim.keymap.set({ "n", "v" }, "l", "l", opts)

	vim.keymap.set({ "n", "v" }, "gh", "gh", opts)
	vim.keymap.set({ "n", "v" }, "gj", "gj", opts)
	vim.keymap.set({ "n", "v" }, "gk", "gk", opts)
	vim.keymap.set({ "n", "v" }, "gl", "gl", opts)

	vim.keymap.set({ "n", "v" }, "i", "i", opts)
	vim.keymap.set({ "n", "v" }, "I", "I", opts)

	vim.keymap.set({ "n", "v" }, "e", "e", opts)
	vim.keymap.set({ "n", "v" }, "n", "n", opts)
	vim.keymap.set({ "n", "v" }, "N", "N", opts)
	vim.keymap.set({ "n", "v" }, "m", "m", opts)

	vim.keymap.set("n", "<C-w>h", "<C-w>h", opts)
	vim.keymap.set("n", "<C-w>j", "<C-w>j", opts)
	vim.keymap.set("n", "<C-w>k", "<C-w>k", opts)
	vim.keymap.set("n", "<C-w>l", "<C-w>l", opts)
end

vim.api.nvim_create_user_command("Colemak", colemak, { nargs = 0 })
vim.api.nvim_create_user_command("Qwerty", qwerty, { nargs = 0 })

-- return remaps to invoke in init.lua
return {
	colemak = colemak,
	qwerty = qwerty,
}
