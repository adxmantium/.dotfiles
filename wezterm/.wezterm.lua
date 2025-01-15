-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- config.colors = {
-- 	foreground = "#CBE0F0",
-- 	background = "#011423",
-- 	cursor_bg = "#47FF9C",
-- 	cursor_border = "#47FF9C",
-- 	cursor_fg = "#011423",
-- 	selection_bg = "#033259",
-- 	selection_fg = "#CBE0F0",
-- 	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
-- 	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
-- }

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local themes = {
	dracula = "Dracula",
	ghDark = "GitHub Dark",
	ghLight = "Github Light (Gogh)",
	gooey = "Gooey (Gogh)",
	gruvbox = "GruvboxDark",
	gruvboxLight = "GruvboxLight",
	everforestDark = "Everforest Dark (Gogh)",
	catppuccin = "Catppuccin Macchiato",
	catppuccinMocha = "Catppuccin Mocha",
	cyberpunk = "cyberpunk",
	rosePine = "rose-pine-moon",
	tokyo = "Tokyo Night",
	tokyoStorm = "Tokyo Night Storm",
	kanagawa = "Kanagawa (Gogh)",
	bones = "kanagawabones",
	kolorit = "Kolorit",
	vscode = "Vs Code Dark+ (Gogh)",
}

function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return themes["bones"]
	else
		return themes["ghLight"]
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.enable_tab_bar = false
config.font_size = 12
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20

-- -- and finally, return the configuration to wezterm
return config
