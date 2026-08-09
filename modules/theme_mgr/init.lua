-- Copyright 2025-2026 Jamie Drinkell. MIT License.

--- Theme manager for Textadept
--
-- To truly change themes with the system in Textadept
-- [is a bit complicated if you don't want to override the default theme files][1].
-- Theme manager is a module for setting themes that switch with the system in the GUI version,
-- and carefully applies theme aspects depending on system limitations.
--
-- If a font is missing, it will opt to use Textadept's default font instead of the OS default font.
--
-- When changing themes, it resets styles to avoid spurious behaviours like line backgrounds
-- persisting on themes that don't have them.
--
-- Since 12.7, Textadept supports arbitrary RGB colours in the terminal version, which means many
-- GUI themes also work in terminals with true-colour support. The module detects if the current
-- terminal is capable to otherwise fallback to the default theme.
--
-- If using the GTK2 build, it attempts to detect if the system GTK theme is a dark one so it can
-- apply your chosen dark theme. There is no mode changed support for GTK2
-- (I don't think any GTK2 DEs had such capability anyway).
-- NB: The check relies on `textadept-gtk` being in your `PATH`.
--
-- I've added [@kbarni's theme selector][2] too just for fun!
--
-- By default, Theme Manager uses Textadept's default themes and settings.
-- Theme manager allows for per lexer theming, including separate light and dark themes.
--
-- Example usage:
--
-- ```lua
-- local theme_mgr = require('theme_mgr')
-- theme_mgr.theme.light = 'xed-light'
-- theme_mgr.theme.dark = 'ayu-evolve'
-- theme_mgr.theme.term = 'catppuccin-latte'
-- theme_mgr.font.family = 'Comic Sans MS'
-- theme_mgr() -- Call the module if you need themes set before events.INITIALIZED
-- ```
--
-- [1]: https://github.com/orbitalquark/textadept/issues/602#issuecomment-2758753214
-- [2]: https://github.com/orbitalquark/textadept/pull/690#issue-3996335774
--
-- @module theme_mgr
local M = {}

local mt = {}
local default_font = (OS == 'windows') and 'Consolas' or (OS == 'macos') and 'Monaco' or 'Monospace'

--- Map of lexers with the themes to use for them, or light/dark/term if not.
-- @field light Which light theme to use when there's no specified lexer theme. Default value is `'light'`.
-- @field dark Which dark theme to use when there's no specified lexer theme. Default value is `'dark'`.
-- @field term Which terminal theme to use when there's no specified lexer theme. Default value is `'term'`.
-- @usage theme_mgr.theme.python = 'xed-dark' -- Set a lexer specific theme
-- @usage theme_mgr.theme.markdown = {'ayu-mirage', 'catppuccin-macchiato'} -- Light then dark lexer themes
M.theme = {
	light = 'light',
	dark = 'dark',
	term = 'term'
}

--- Table of font properties to use.
-- @field family The font to use. Default value is the same as Textadept's default for each OS.
-- @field size The font size to use. Default value is `12`.
M.font = {
	family = default_font,
	size = 12
}

--- Checks if a font is installed on the system.
-- The matching is very simple so if you've put 'Comic Sans' instead of 'Comic Sans MS' it can fail.
-- @param font Font name to check exists.
-- @return `nil` if not found, otherwise a truthy value.
local function check_font(font)
	local font_check_cmd
	if OS == 'windows' then
		-- Source - https://superuser.com/a/1534136
		-- Posted by phuclv, modified by community. See post 'Timeline' for change history
		-- Retrieved 2026-02-27, License - CC BY-SA 4.0
		font_check_cmd =
			'reg query "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" /s'
		-- Source - https://superuser.com/a/1534136
		-- Posted by phuclv, modified by community. See post 'Timeline' for change history
		-- Retrieved 2026-02-27, License - CC BY-SA 4.0
		-- font_check_cmd =
		--	'Get-ItemProperty \'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts\\\''
	else
		font_check_cmd = 'fc-list' -- Linux/BSD
	end
	local proc = os.spawn(font_check_cmd)
	local list = proc:read('a')
	return list:match(font)
end

--- Checks current terminal for TUI version can support a colourful theme.
-- @return `true` if terminal can support colourful themes.
local function check_term()
	-- GNOME Terminal, Tilix, Konsole, XFCE, LXDE etc. all report 'xterm-256color'
	-- Alacritty reports 'alacritty'
	local terminal = os.getenv("TERM")
	if terminal == nil then terminal = 'WIN' end
	if terminal == 'xterm' or terminal == 'linux' or terminal == 'cons25' or terminal == 'WIN' then
		return false
	end
	return true
end

--- If running the GTK2 version, checks if it should be using a dark theme.
-- @return A truthy value if a dark theme should be forcefully applied.
local function check_gtk2_dark()
	local path = os.spawn('which textadept-gtk'):read('a'):match("^%s*(.-)%s*$")
	if os.execute('ldd ' .. path .. ' | grep gtk-x11-2') then
		return os.spawn('gsettings get org.gnome.desktop.interface gtk-theme'):read('a'):match(
			'[dD][aA][rR][kK]')
	end
end

--- Reset some commonly adjusted things that cause problems when switching themes
-- @param view_to_reset View that should have values reset.
local function reset_view(view_to_reset)
	if UI ~= 'terminal' or (UI == 'terminal' and not (M.theme.term == 'term')) then
		view_to_reset:style_reset_default()
		view_to_reset:style_clear_all()
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_CARET_LINE_BACK)
	end
	if UI ~= 'terminal' then
		view_to_reset.caret_style = view.CARETSTYLE_LINE
		view_to_reset.caret_line_layer = view.LAYER_BASE
		view_to_reset.selection_layer = view.LAYER_BASE
		-- Reset all the element colours
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_TEXT)
		view_to_reset:reset_element_color(view.ELEMENT_WHITE_SPACE)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_ADDITIONAL_TEXT)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_ADDITIONAL_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_SECONDARY_TEXT)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_SECONDARY_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_INACTIVE_TEXT)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_INACTIVE_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_TEXT)
		view_to_reset:reset_element_color(view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_CARET)
		view_to_reset:reset_element_color(view.ELEMENT_CARET_ADDITIONAL)
		view_to_reset:reset_element_color(view.ELEMENT_WHITE_SPACE_BACK)
		view_to_reset:reset_element_color(view.ELEMENT_FOLD_LINE)
		view_to_reset:reset_element_color(view.ELEMENT_HIDDEN_LINE)
	end
end

--- Apply selected themes to a view.
-- @param view_reset Whether to reset the view before theming it.
-- @param view View to theme.
function M.theme_view(view_reset, view)
	if view_reset then reset_view(view) end
	local theme
	local lex = view.buffer:get_lexer()
	if M.theme[lex] and UI ~= 'terminal' then
		if type(M.theme[lex]) == 'table' then
			theme = (_THEME == 'light') and M.theme[lex][1] or M.theme[lex][2]
		else
			theme = M.theme[lex]
		end
	else
		theme = UI == 'terminal' and M.theme.term or (_THEME == 'dark') and M.theme.dark or
			M.theme.light
	end
	-- TODO: When splitting this fails saying set_theme is a nil value, but only on Qt?
	if view.set_theme then view:set_theme(theme, {font = M.font.family, size = M.font.size}) end
end

--- Applies theme to all views.
-- @param view_reset Whether to reset each view before applying the theme.
function M.theme_all_views(view_reset)
	for _, view in ipairs(_VIEWS) do M.theme_view(view_reset, view) end
end

--- Applies theme to command entry.
function M.theme_command_entry()
	local theme = UI == 'terminal' and M.theme.term or (_THEME == 'dark') and M.theme.dark or
		M.theme.light
	pcall(function()
		ui.command_entry:set_theme(theme, {font = M.font.family, size = M.font.size})
	end)
end

--- Checks done at startup for fonts and theme capabilities.
local function init_checks()
	if M.font.family ~= default_font and not check_font(M.font.family) then
		M.font.family = default_font
	elseif UI == 'terminal' and not check_term() then
		M.theme.term = 'term'
	end
	if UI ~= 'terminal' then
		-- Check for any lexer specific themes, because then we need to theme on switches
		for k, v in pairs(M.theme) do
			if k ~= 'light' or k ~= 'dark' or k ~= 'term' then
				-- Views except the last get upset if we reset styles (because some styles are global)
				events.connect(events.VIEW_AFTER_SWITCH, function()
					M.theme_view(true, view)
				end)
				events.connect(events.LEXER_LOADED, function()
					M.theme_view(true, view)
				end)
				events.connect(events.BUFFER_AFTER_SWITCH, function()
					M.theme_view(true, view)
				end)
				break
			end
		end
	end
	if UI == 'gtk' and check_gtk2_dark() then _G._THEME = 'dark' end
	events.connect(events.VIEW_NEW, function() M.theme_view(true, view) end)
end

local function init()
	init_checks()
	M.theme_all_views(false)
end
events.connect(events.INITIALIZED, init)

events.connect(events.INITIALIZED, function()
	if UI ~= 'terminal' then
		-- For whatever reason, if we connect this before init view:set_theme doesn't work right
		events.connect(events.MODE_CHANGED, function()
			M.theme_command_entry()
			M.theme_all_views(true)
		end)
	end
end)

--- Theme selector adapted from @kbarni
-- Lists themes to user and allows them to select what to apply.
-- @param mode Whether theme should be applied to light or dark mode.
function M.select_theme(mode)
	local themes = {}
	for _, dir in ipairs{_USERHOME .. '/themes', _HOME .. '/themes'} do
		if lfs.attributes(dir, 'mode') == 'directory' then
			for file in lfs.dir(dir) do
				local name = file:match('^(.+)%.lua$')
				if name then themes[#themes + 1] = name end
			end
		end
	end
	table.sort(themes)
	-- Remove duplicates.
	local i = 1
	while i < #themes do
		if themes[i] == themes[i + 1] then
			table.remove(themes, i + 1)
		else
			i = i + 1
		end
	end
	local i = ui.dialogs.list{title = _L['Select Theme'], items = themes}
	if i then
		local lex = view.buffer:get_lexer()
		if M.theme[lex] and UI ~= 'terminal' then
			if type(M.theme[lex]) == 'table' then
				M.theme[lex][(mode == 'light') and 1 or 2] = themes[i]
			else
				M.theme[lex] = themes[i]
			end
		else
			if mode == 'light' then
				M.theme.light = themes[i]
			elseif mode == 'dark' then
				M.theme.dark = themes[i]
			elseif mode == 'term' then
				M.theme.term = themes[i]
			end
		end
		M.theme_command_entry()
		M.theme_all_views(true)
	end
end

mt.__call = function()
	events.disconnect(events.INITIALIZED, init)
	init_checks()
	local theme = UI == 'terminal' and M.theme.term or (_THEME == 'dark') and M.theme.dark or
		M.theme.light
	view:set_theme(theme, {font = M.font.family, size = M.font.size})
end
setmetatable(M, mt)

_L['Change Theme...'] = 'Change _Theme...'
_L['Select Light Theme'] = 'Select _Light Theme'
_L['Select Dark Theme'] = 'Select _Dark Theme'
local view_menu = textadept.menu.menubar[_L['View']]
if UI ~= 'terminal' then
	table.insert(view_menu, #view_menu - 2, {
		title = _L['Change Theme...'],
		{_L['Select Light Theme'], function() M.select_theme('light') end},
		{_L['Select Dark Theme'], function() M.select_theme('dark') end}
	})
else
	table.insert(view_menu, #view_menu - 2,
		{_L['Change Theme...'], function() M.select_theme('term') end})
end
table.insert(view_menu, #view_menu - 2, {''})

return M
