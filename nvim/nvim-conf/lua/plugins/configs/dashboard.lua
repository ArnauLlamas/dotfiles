local dashboard = require("dashboard")

local conf = {}
conf.header = {
	"                                                       ",
	"                                                       ",
	"                                                       ",
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	"                                                       ",
	"                                                       ",
	"                                                       ",
	"                                                       ",
}

conf.center = {
	{
		icon = "󰈞  ",
		desc = "Find  File                              ",
		action = "Telescope find_files",
		key = "SPC f f",
	},
	{
		icon = "󰈬  ",
		desc = "Project grep                            ",
		action = "Telescope live_grep",
		key = "SPC f g",
	},
	{
		icon = "󰈢  ",
		desc = "Recently opened files                   ",
		action = "Telescope oldfiles",
		key = "SPC f r",
	},
	{
		icon = "󰗼  ",
		desc = "Quit Nvim                               ",
		action = "qa",
		key = "q",
	},
}

dashboard.setup({
	theme = "doom",
	shortcut_type = "number",
	config = conf,
})
