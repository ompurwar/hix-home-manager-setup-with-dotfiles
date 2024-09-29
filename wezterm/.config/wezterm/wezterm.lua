-- Pull the wezterm API
local wezterm = require("wezterm")

local function scheme_for_appearance(appearance)
	if appearance:find "Dark" then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end
-- Set the initial theme
local current_theme = "Catppuccin Mocha"

-- WezTerm Configuration
local config = {
	-- font = wezterm.font("FiraCode Nerd Font"),
	--   font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 10.0,
	color_scheme = current_theme,
	enable_tab_bar = false,
	window_decorations = "NONE",
}

-- Toggle Theme Function
wezterm.on("toggle-theme", function(window, pane)
	if current_theme == "Catppuccin Mocha" then
		current_theme = "Catppuccin Macchiato"
	elseif current_theme == "Catppuccin Macchiato" then
		current_theme = "Catppuccin Frappe"
	elseif current_theme == "Catppuccin Frappe" then
		current_theme = "Catppuccin Latte"
	else
		current_theme = "Catppuccin Mocha"
	end

	window:set_config_overrides({
		--   colors = catppuccin[current_theme],
		color_scheme = current_theme
	})
end)

-- Keybinding to toggle the theme
config.keys = {
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-theme") },
}
-- Set window background opacity
config.window_background_opacity = 1

-- Return the configuration to WezTerm
return config
