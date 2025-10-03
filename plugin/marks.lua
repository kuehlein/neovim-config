--
-- Custom plugin for displaying local marks in the sign column
--

local theme_utils = require("utils.theme")

local p = theme_utils.palette -- commonly used colors

local SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP = "SignColumnMarkIndicator"

function PlaceMarkIndicator(char)
	local mark_pos = vim.api.nvim_buf_get_mark(0, char)

	if mark_pos[1] > 0 then
		local sign_name = "MarkSign_" .. char

		vim.fn.sign_define(sign_name, { text = char, texthl = SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP })
		vim.fn.sign_place(
			0, -- Sign ID (0 allows automatic assignment)
			"MarkSignGroup", -- Group name to place/unplace marks
			sign_name,
			vim.api.nvim_get_current_buf(),
			{ lnum = mark_pos[1], priority = 0 } -- Lowest priority so as not to override other values in sign column
		)
	end
end

function DisplayMarkIndicator()
	-- Prevents sign column from resizing when inserting/removing marks
	vim.o.signcolumn = "yes"

	vim.fn.sign_unplace("MarkSignGroup")

	-- a-z marks
	for i = string.byte("a"), string.byte("z") do
		PlaceMarkIndicator(string.char(i))
	end

	-- Special marks
	PlaceMarkIndicator("'") -- Last jump position (line)
	PlaceMarkIndicator('"') -- Last jump position (exact cursor position)
	PlaceMarkIndicator("^") -- Last insert position
	PlaceMarkIndicator(".") -- Last change position
	PlaceMarkIndicator("[") -- Start of last modification
	PlaceMarkIndicator("]") -- End of last modification
	PlaceMarkIndicator("{") -- Start of last undo block
	PlaceMarkIndicator("}") -- End of last undo block
	PlaceMarkIndicator("<") -- Start of last visual selection
	PlaceMarkIndicator(">") -- End of last visual selection
end

vim.api.nvim_create_autocmd({
	"BufEnter", -- Triggered after switching to a new buffer
	"CursorHold", -- Triggered when the cursor stops moving
}, {
	pattern = "*",
	callback = DisplayMarkIndicator,
})

-- Ensure that marks are correctly highlighted
vim.api.nvim_set_hl(0, SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP, { fg = p.fg.orange })
