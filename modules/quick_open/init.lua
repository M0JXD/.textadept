-- Copyright 2025-2026 Jamie Drinkell. MIT License.

--- Textadept Quick Open
--
-- Quickly open a terminal, file explorer or git client at the current buffer's file path.
-- It's based on <https://github.com/orbitalquark/textadept/wiki/TerminalHere>.
--
-- I don't have any Apple devices so have not implemented for macOS.
-- If setting a custom terminal, as the directory argument may of the form `--working-directory=`
-- you might need to add the trailing whitespace.
--
-- Only for GUI Textadept, returns an empty table if used in the terminal version.
-- @module quick_open
local M = {}

if UI == 'terminal' then return M end

local desktop = os.getenv('XDG_CURRENT_DESKTOP')
if desktop == nil then desktop = '' end

--- Bindings to use to launch applications at current path.
-- @usage quick_open.bindings.terminal = 'alt+T'
M.bindings = {
	terminal = 'ctrl+T', -- Binding to launch Terminal. Default value is `'ctrl+T'`.
	explorer = 'ctrl+E', -- Binding to launch File Explorer. Default value is `'ctrl+E'`.
	git_client = 'ctrl+G' -- -- Binding to launch Git Client. Default value is `'ctrl+G'`.
}

--- Terminal emulator to open.
-- The module attempts to detect what is correct for your OS/Desktop.
-- @usage quick_open.terminal = 'cool-retro-term'
M.terminal = OS == 'windows' and 'cmd.exe /f:on' or 'xterm -hold'

--- Argument to maximise the terminal emulator.
-- The module attempts to detect what is correct for your OS/Desktop.
-- @usage quick_open.term_max_arg = '--fullscreen'
M.term_max_arg = '-fullscreen'

--- Argument to pass a starting directory to the terminal emulator.
-- The module attempts to detect what is correct for your OS/Desktop.
-- @usage quick_open.term_dir_arg = '--workdir ' -- Trailing space might be needed
M.term_dir_arg = '--working-directory='
-- TODO: xterm doesn't really support giving a directory at startup?

if desktop:match('Cinnamon') then
	M.terminal = 'gnome-terminal'
	M.term_max_arg = '--maximize'
elseif desktop:match('XFCE') then
	M.terminal = 'xfce4-terminal'
	M.term_max_arg = '--maximize'
elseif desktop:match('MATE') then
	M.terminal = 'mate-terminal'
	M.term_max_arg = '--maximize'
elseif desktop:match('LXDE') then
	M.terminal = 'lxterminal'
	M.term_max_arg = '--maximize'
elseif desktop:match('GNOME') then
	M.terminal = 'kgx'
	M.term_max_arg = '--maximize'
	-- Check if Ubuntu because it still uses gnome-terminal
	local handle = io.popen("lsb_release -si 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		if result:find("Ubuntu") then M.terminal = 'gnome-terminal' end
		handle:close()
	end
elseif desktop:match('KDE') then
	M.terminal = 'konsole'
	M.term_dir_arg = '--workdir '
	M.term_max_arg = '--fullscreen'
elseif desktop:match('ENLIGHTENMENT') then
	M.terminal = 'terminology'
	M.term_dir_arg = '-d='
	M.term_max_arg = '-M'
elseif desktop:match('LXQt') then
	M.terminal = 'qterminal'
	M.term_max_arg = '--maximize'
	-- Presumably the same as lxterminal?
end

--- Command to open a file explorer.
-- Default value is `'explorer.exe'` on Windows and `'xdg-open'` on Linux/BSD.
-- @usage quick_open.explorer = 'nautilus'
M.explorer = OS == 'windows' and 'explorer.exe' or 'xdg-open'

--- Git client to open.
-- Default value is `'lazygit'`.
-- @usage quick_open.git_client = 'gitui'
M.git_client = OS == 'windows' and 'lazygit.exe' or 'lazygit'

--- Open a terminal at the current buffer's directory.
-- @param arg[opt] Command to pass to terminal emulator (used to open git client).
function M.openTerminalHere(arg)
	local argString = '~'
	if OS ~= 'windows' then
		if buffer.filename then
			argString = '"' .. buffer.filename:match('.+/') .. '"'
			argString = M.term_dir_arg .. argString
		end
		if arg then
			argString = argString .. ' ' .. M.term_max_arg .. ' -e ' .. arg
		else
			argString = argString .. ' &'
		end
		io.popen(M.terminal .. ' ' .. argString)
	else
		local prePath = buffer.filename:match('.+\\')
		local start = 'start '
		argString = ' /K "cd /d ' .. prePath .. '"'
		if arg then
			argString = ' /C "cd /d ' .. prePath .. ' & ' .. arg .. '"'
			start = 'start /MAX '
		end
		io.popen(start .. M.terminal .. ' ' .. argString)
	end
end

--- Open a file explorer at the current buffer's directory.
function M.openFileBrowserHere()
	local pathString = '~'
	if OS ~= 'windows' then
		if buffer.filename then pathString = buffer.filename:match('.+/') end
		io.popen(M.explorer .. ' "' .. pathString .. '" &')
	else
		local prePath = buffer.filename:match('.+\\')
		pathString = ' /e,' .. prePath
		io.popen('start ' .. M.explorer .. pathString)
	end
end

--- Open a git client at the current buffer's directory.
function M.openGitClientHere()
	M.openTerminalHere(M.git_client)
end

local quick_open = textadept.menu.menubar[_L['Tools/Quick Open']]
_L['Open Terminal Here...'] = 'Open _Terminal Here...'
table.insert(quick_open, 5, {_L['Open Terminal Here...'], M.openTerminalHere})

_L['Open File Browser Here...'] = 'Open _File Browser Here...'
table.insert(quick_open, 6, {_L['Open File Browser Here...'], M.openFileBrowserHere})

_L['Open Git Client Here...'] = 'Open _Git Client Here...'
table.insert(quick_open, 7, {_L['Open Git Client Here...'], M.openGitClientHere})

events.connect(events.INITIALIZED, function()
	keys[M.bindings.terminal] = M.openTerminalHere
	keys[M.bindings.explorer] = M.openFileBrowserHere
	keys[M.bindings.git_client] = M.openGitClientHere
end)

return M
