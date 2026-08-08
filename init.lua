-- Copyright 2025-2026 Jamie Drinkell. MIT License.

-- Theming
local theme_mgr = require('theme_mgr')
theme_mgr.theme.light = 'ayu-light'
theme_mgr.theme.dark = 'ayu-dark'
theme_mgr.theme.term = 'ayu-evolve'
theme_mgr.theme.markdown = {'catppuccin-latte', 'ayu-dark'}
if OS ~= 'windows' then theme_mgr.theme.text = {'xed-light', 'xed-dark'} end
-- theme_mgr.font.family = 'Droid Sans Mono'
-- theme_mgr.font.family = 'Noto Mono'
-- theme_mgr.font.family = 'FreeMono'

-- Modules (Official)
-- require('debugger')
local export = require('export')
-- export.line_numbers = false
require('file_diff')
local format = require('format')
local function prettier_formatter()
	-- Most parsers are the same as the lexer name
	local parser = buffer:get_lexer()
	if parser == 'javascript' then parser = 'babel' end
	return format.config_file_contains('package.json', 'prettier') and 'npx prettier --parser ' ..
		parser or nil
end
format.commands.html = prettier_formatter
format.commands.css = prettier_formatter
format.commands.javascript = prettier_formatter
format.commands.typescript = prettier_formatter
format.commands.markdown = prettier_formatter
format.commands.yaml = prettier_formatter
format.commands.python = OS == 'windows' and 'py' or 'python' .. ' -m black -'
local lsp = false
if OS ~= 'bsd' then
	lsp = require('lsp')
	if UI == 'qt' then
		lsp.server_commands.dart = 'dart language-server'
		keys['ctrl+.'] = textadept.menu.menubar['Tools/Language Server/Code Action'][2]
	end
end
require('lua_repl')
keys[(UI == 'terminal' and 'meta+O' or 'alt+O')] = require('open_file_mode')
-- require('scratch')
local spellcheck = require('spellcheck')
spellcheck.check_spelling_on_save = false
local update_notifier = require('update_notifier')
update_notifier.check_on_startup = true

-- Modules (M0JXD)
require('bfstatbar_utils')
require('distraction_free')
require('quick_open')
require('export_ext')
local ds = require('doc_stats')
ds.display.lines = true
if OS ~= 'bsd' then require('discord_rpc')() end

-- Modules (External)
-- theme_mgr() ; require('textredux').hijack() -- @rgieseke

-- Buffer/Language Settings
lexer.detect_extensions.adoc = 'asciidoc'
lexer.detect_extensions.blp = 'blueprint'
lexer.detect_extensions.C = 'cpp'
lexer.detect_extensions['direwolf.conf'] = 'bash'
lexer.detect_extensions.h = 'c'
lexer.detect_extensions.njk = 'html'
textadept.editing.auto_pairs.text = {}
textadept.editing.auto_pairs.markdown = {['*'] = '*', ['_'] = '_'}
events.connect(events.LEXER_LOADED, function(name)
	local prop = 'scintillua.comment.' .. name
	buffer.property[prop] = buffer.property[prop] .. ' ' -- extra trailing space
end)
textadept.editing.comment_string.c = '/* | */'
textadept.editing.highlight_words = textadept.editing.HIGHLIGHT_SELECTED
textadept.run.run_in_background = true
ui.find.highlight_all_matches = true
view.edge_column = 100
local function lexer_settings()
	buffer.tab_width = 4
	buffer.use_tabs = false
	view.wrap_mode = view.WRAP_NONE
	textadept.editing.strip_trailing_spaces = true
	if format then format.on_save = false end
	ds.display.chars = false
	ds.display.words = false

	local name = buffer:get_lexer()
	if name == 'makefile' or name == 'lua' then
		buffer.use_tabs = true
	elseif name == 'dart' then
		buffer.tab_width = 2
		if format then format.on_save = true end
	elseif name == 'text' or name == 'markdown' then
		view.wrap_mode = view.WRAP_WHITESPACE
		textadept.editing.strip_trailing_spaces = false
		ds.display.chars = 3
		ds.display.words = 3
	end
end
events.connect(events.LEXER_LOADED, lexer_settings)
events.connect(events.BUFFER_AFTER_SWITCH, lexer_settings)
events.connect(events.VIEW_AFTER_SWITCH, lexer_settings)

-- Tools
textadept.run.build_commands['CMakeLists.txt'] = 'cmake --build build'
textadept.run.build_commands['xmake.lua'] = 'xmake'
textadept.run.compile_commands.python = (OS == 'windows' and 'py' or 'python') .. ' -m flake8 %f' -- Run a linter
textadept.run.compile_commands.ino = 'arduino-cli compile -b arduino:avr:nano "%p"' -- Verify
textadept.run.run_commands.ino = 'arduino-cli upload "%p" -b arduino:avr:nano -p /dev/ttyACM0' -- Upload

-- Extra Utilities
_L['Rename'] = '_Rename'
table.insert(textadept.menu.menubar[_L['File']], 8, {
	_L['Rename'], function()
		local oldname = buffer.filename
		buffer:save_as()
		os.remove(oldname)
	end
})

-- Pandoc conversions to Markdown often have extra blank lines
_L['Delete Blank Lines'] = 'Delete Blank _Lines'
table.insert(textadept.menu.menubar[_L['Edit']], 11, {
	_L['Delete Blank Lines'], function()
		local i = 1
		while i < buffer.line_count do
			local line = buffer:get_line(i)
			if line:match("^%s*$") then
				buffer:goto_line(i)
				buffer:line_delete()
			else
				i = i + 1
			end
		end
	end
})

_L['Reset Lua State'] = 'Reset L_ua State'
local tools_menu = textadept.menu.menubar[_L['Tools']]
tools_menu[#tools_menu + 1] = {''}
tools_menu[#tools_menu + 1] = {_L['Reset Lua State'], reset}

_L['Toggle Line Guide'] = 'Toggle _Line Guide'
table.insert(textadept.menu.menubar[_L['View']], 18, {
	_L['Toggle Line Guide'], function()
		view.edge_mode = view.edge_mode == view.EDGE_LINE and view.EDGE_NONE or view.EDGE_LINE
	end
})

_L['Toggle Strip Trailing Whitespace'] = 'Toggle Strip _Trailing Whitespace'
table.insert(textadept.menu.menubar[_L['View']], 19, {
	_L['Toggle Strip Trailing Whitespace'], function()
		textadept.editing.strip_trailing_spaces = not textadept.editing.strip_trailing_spaces
		events.emit(events.UPDATE_UI, 3)
	end
})

_L['Toggle End Of Line Characters'] = 'Toggle _End Of Line Characters'
table.insert(textadept.menu.menubar[_L['View']], 20, {
	_L['Toggle End Of Line Characters'], function() view.view_eol = not view.view_eol end
})

_L['Flip a Coin'] = 'Flip a _Coin'
math.randomseed(os.time())
table.insert(textadept.menu.menubar[_L['Help']], 7, {
	_L['Flip a Coin'], function()
		local flip = math.random(2) > 1 and true or false
		ui.dialogs.message{
			title = 'Coin Flip', icon = flip and 'face-angel' or 'face-devilish',
			text = 'You got ' .. (flip and 'Heads.' or 'Tails.')
		}
	end
})

-- UI Adjustments
events.connect(events.UPDATE_UI, function(updated)
	if not updated or updated & 3 == 0 then return end
	local strip = 'Strip: ' .. (textadept.editing.strip_trailing_spaces and 'On' or 'Off')
	ui.buffer_statusbar_text = ui.buffer_statusbar_text:bst_insert(
		ui.buffer_statusbar_text:bst_count() - 1, strip)
end)

-- Keybindings
local menubar = textadept.menu.menubar
keys['f2'] = menubar['File/Rename'][2]
keys['f5'] = reset
keys['ctrl+g'] = menubar['Search/Go To Line...'][2]
keys['ctrl+l'] = textadept.editing.select_line
keys[(UI == 'terminal' and 'ctrl+k' or 'ctrl+K')] = buffer.line_delete
keys[(UI == 'terminal' and 'meta+L' or 'ctrl+L')] = menubar['Buffer/Select Lexer...'][2]
keys[(UI == 'terminal' and 'meta+,' or 'ctrl+,')] = menubar['Edit/Preferences'][2]
keys[(UI == 'terminal' and 'meta+up' or 'alt+up')] = buffer.move_selected_lines_up
keys[(UI == 'terminal' and 'meta+down' or 'alt+down')] = buffer.move_selected_lines_down

-- Hide some folders from the quick open list
table.insert(lfs.default_filter, '!assets')
table.insert(lfs.default_filter, '!build')
table.insert(lfs.default_filter, '!build_dir')
table.insert(lfs.default_filter, '!resources')
table.insert(lfs.default_filter, '!.vs')
table.insert(lfs.default_filter, '!.vscode')
table.insert(lfs.default_filter, '!.xmake')

-- Save session data regularly in case of crash or battery
local function save_session()
	local append = (OS == 'windows' and '\\' or '/') ..
		(UI == 'terminal' and 'session_term' or 'session')
	textadept.session.save(_USERHOME .. append)
end
events.connect(events.FILE_OPENED, save_session)
events.connect(events.FILE_AFTER_SAVE, save_session)
events.connect(events.BUFFER_DELETED, save_session)

-- Platform Specific Adjustments
if UI == 'terminal' then
	-- Add a suspend menu entry
	table.insert(textadept.menu.menubar[_L['View']], {'Suspend...', ui.suspend})
elseif OS == 'windows' then
	keys['ctrl+alt+|'] = nil -- Disable due to weird UK keyboard
elseif UI == 'gtk' then
	-- Dirty fix for X11 focus
	events.connect(events.INITIALIZED, function()
		local filename = buffer.filename or buffer._type or _L['Untitled']
		if buffer.filename then
			filename = select(2, pcall(string.iconv, filename, 'UTF-8', _CHARSET))
		end
		local basename = buffer.filename and filename:match('[^/\\]+$') or filename
		local title = string.format('%s %s Textadept (%s)', basename, buffer.modify and '*' or '-',
			filename)
		os.execute('wmctrl -a "' .. title .. '"')
	end)
end
