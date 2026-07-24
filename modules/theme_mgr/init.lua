-- Copyright 2025-2026 Jamie Drinkell. MIT License.
-- Theme manager for Textadept.
-- Allow system switching and automatic detection/application of what's best in some environments.
-- Handy if you don't want to override the default themes to achieve this.
-- (Leaving a fallback for when you edit your themes and crash everything...)

local M = {theme = {}, font = {}, mt = {}}
local default_font = (OS == 'windows') and 'Consolas' or (OS == 'macos') and 'Monaco' or 'Monospace'
M.theme.light = 'light'
M.theme.dark = 'dark'
M.theme.term = 'term'
M.font.size = 12
M.font.family = default_font

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

local function check_gtk2_dark()
	local path = os.spawn('which textadept-gtk'):read('a'):match("^%s*(.-)%s*$")
	if os.execute('ldd ' .. path .. ' | grep gtk-x11-2') then
		return os.spawn('gsettings get org.gnome.desktop.interface gtk-theme'):read('a'):match(
			'[dD][aA][rR][kK]')
	end
end

-- Reset some commonly adjusted things that cause problems when switching themes
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
	-- TODO: When splitting this fails saying set_theme is a nil value, but only on Windows??
	view:set_theme(theme, {font = M.font.family, size = M.font.size})
end

function M.theme_all_views(view_reset)
	for _, view in ipairs(_VIEWS) do M.theme_view(view_reset, view) end
end

function M.theme_command_entry()
	local theme = UI == 'terminal' and M.theme.term or (_THEME == 'dark') and M.theme.dark or
		M.theme.light
	pcall(function()
		ui.command_entry:set_theme(theme, {font = M.font.family, size = M.font.size})
	end)
end

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

-- Theme selector by @kbarni! https://github.com/orbitalquark/textadept/pull/690#issue-3996335774
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

M.mt.__call = function()
	events.disconnect(events.INITIALIZED, init)
	init_checks()
	local theme = UI == 'terminal' and M.theme.term or (_THEME == 'dark') and M.theme.dark or
		M.theme.light
	view:set_theme(theme, {font = M.font.family, size = M.font.size})
end
setmetatable(M, M.mt)

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
