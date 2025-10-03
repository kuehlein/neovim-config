local M = {}

local function reset_theme()
	-- if another theme is set, clear it, then apply our theme
	if vim.g.colors_name then
		vim.cmd("highlight clear")
	end

	-- name of theme we are applying
	vim.g.colors_name = "theme"
end

local function apply_theme(theme)
	vim.opt.termguicolors = true

	-- Each entry into the inner table corresponds to a configuration key,
	-- mapped to a highlight argument. We implement this in a function which we
	-- conveniently call highlight(), just like the vim command we wrap:
	for group, style in pairs(theme) do
		-- 0 is the global level, maybe add level to the `t` object?
		vim.api.nvim_set_hl(0, group, style)
	end
end

-- dark color theme for github theme
local colors = {
	NONE = "NONE",
	black = "#010409",
	white = "#ffffff",

	gray = {
		[0] = "#f0f6fc",
		[1] = "#c9d1d9",
		[2] = "#b1bac4",
		[3] = "#8b949e",
		[4] = "#6e7681",
		[5] = "#484f58",
		[6] = "#30363d",
		[7] = "#21262d",
		[8] = "#161b22",
		[9] = "#0d1117",
	},
	blue = {
		[0] = "#cae8ff",
		[1] = "#a5d6ff",
		[2] = "#79c0ff",
		[3] = "#58a6ff",
		[4] = "#388bfd",
		[5] = "#1f6feb",
		[6] = "#1158c7",
		[7] = "#0d419d",
		[8] = "#0c2d6b",
		[9] = "#051d4d",
	},
	green = {
		[0] = "#aff5b4",
		[1] = "#7ee787",
		[2] = "#56d364",
		[3] = "#3fb950",
		[4] = "#2ea043",
		[5] = "#238636",
		[6] = "#196c2e",
		[7] = "#0f5323",
		[8] = "#033a16",
		[9] = "#04260f",
	},
	yellow = {
		[0] = "#f8e3a1",
		[1] = "#f2cc60",
		[2] = "#e3b341",
		[3] = "#d29922",
		[4] = "#bb8009",
		[5] = "#9e6a03",
		[6] = "#845306",
		[7] = "#693e00",
		[8] = "#4b2900",
		[9] = "#341a00",
	},
	orange = {
		[0] = "#ffdfb6",
		[1] = "#ffc680",
		[2] = "#ffa657",
		[3] = "#f0883e",
		[4] = "#db6d28",
		[5] = "#bd561d",
		[6] = "#9b4215",
		[7] = "#762d0a",
		[8] = "#5a1e02",
		[9] = "#3d1300",
	},
	red = {
		[0] = "#ffdcd7",
		[1] = "#ffc1ba",
		[2] = "#ffa198",
		[3] = "#ff7b72",
		[4] = "#f85149",
		[5] = "#da3633",
		[6] = "#b62324",
		[7] = "#8e1519",
		[8] = "#67060c",
		[9] = "#490202",
	},
	purple = {
		[0] = "#eddeff",
		[1] = "#e2c5ff",
		[2] = "#d2a8ff",
		[3] = "#bc8cff",
		[4] = "#a371f7",
		[5] = "#8957e5",
		[6] = "#6e40c9",
		[7] = "#553098",
		[8] = "#3c1e70",
		[9] = "#271052",
	},
	pink = {
		[0] = "#ffdaec",
		[1] = "#ffbedd",
		[2] = "#ff9bce",
		[3] = "#f778ba",
		[4] = "#db61a2",
		[5] = "#bf4b8a",
		[6] = "#9e3670",
		[7] = "#7d2457",
		[8] = "#5e103e",
		[9] = "#42062a",
	},
	coral = {
		[0] = "#ffddd2",
		[1] = "#ffc2b2",
		[2] = "#ffa28b",
		[3] = "#f78166",
		[4] = "#ea6045",
		[5] = "#cf462d",
		[6] = "#ac3220",
		[7] = "#872012",
		[8] = "#640d04",
		[9] = "#460701",
	},
}

-- commonly used colors in chosen theme
local palette = {
	white = colors.white,
	gray = colors.gray[5],
	black = colors.black,

	pink = colors.pink[5],
	red = colors.red[5],
	orange = colors.orange[5],
	yellow = colors.yellow[5],
	green = colors.green[5],
	blue = colors.blue[5],
	purple = colors.purple[5],

	-- background
	bg = {
		gray = colors.gray[9],
		pink = colors.pink[9],
		red = colors.red[9],
		orange = colors.orange[9],
		yellow = colors.yellow[9],
		green = colors.green[9],
		blue = colors.blue[9],
		purple = colors.purple[9],
	},

	-- foreground
	fg = {
		gray = colors.gray[3],
		pink = colors.pink[3],
		red = colors.red[3],
		orange = colors.orange[2],
		yellow = colors.yellow[3],
		green = colors.green[3],
		blue = colors.blue[3],
		purple = colors.purple[3],
	},
}

M.colors = colors
M.palette = palette
M.apply_theme = apply_theme
M.reset_theme = reset_theme

return M
