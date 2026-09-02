-- Copyright 2026 Jamie Drinkell. See LICENSE.

--- Run integration steps for POSIX systems with XDG compliant desktops (Linux/BSD).
-- Expects a Textadept installation under *~/Applications/textadept*
-- @usage `textadept -L ~/.textadept/scripts/integrate_xdg.lua`

local install = '$HOME/Applications/textadept'

local function install_icon()
	print('Installing SVG icon to XDG directory...')
	local img_path = install .. '/core/images/textadept.svg'
	local sys_img_path = '$HOME/.local/share/icons/hicolor/scalable/apps'
	os.execute('mkdir -p ' .. sys_img_path)
	os.execute('cp ' .. img_path .. ' ' .. sys_img_path)
end

local function install_desktops()
	print('Installing .destkop files to XDG directory...')
	local sys_desktop_path = '$HOME/.local/share/applications'
	local qt_desktop = install .. '/textadept.desktop'
	local gtk_desktop = install .. '/textadept-gtk.desktop'
	local curses_desktop = install .. '/textadept-curses.desktop'
	os.execute('mkdir -p ' .. sys_desktop_path)
	os.execute('cp ' .. qt_desktop .. ' ' .. gtk_desktop .. ' ' .. curses_desktop .. ' ' ..
		sys_desktop_path)
end

--- Create starter scripts in *.local/bin*
local function create_shell_scripts()
	local script_start =
		'#!/bin/sh\nexport TEXTADEPT_HOME=\\$HOME/Applications/textadept\n\\$TEXTADEPT_HOME/textadept'
	local qt = script_start .. ' \\"\\$@\\"'
	local gtk = script_start .. '-gtk \\"\\$@\\"'
	local term = script_start .. '-curses \\"\\$@\\"'
	os.execute('mkdir -p ~/.local/bin')
	os.execute('echo "' .. qt .. '" > ~/.local/bin/textadept')
	os.execute('echo "' .. qt .. '" > ~/.local/bin/ta-qt')
	os.execute('echo "' .. gtk .. '" > ~/.local/bin/textadept-gtk')
	os.execute('echo "' .. gtk .. '" > ~/.local/bin/ta-gtk')
	os.execute('echo "' .. term .. '" > ~/.local/bin/textadept-curses')
	os.execute('echo "' .. term .. '" > ~/.local/bin/ta')
	os.execute('chmod +x ~/.local/bin/textadept')
	os.execute('chmod +x ~/.local/bin/ta-qt')
	os.execute('chmod +x ~/.local/bin/textadept-gtk')
	os.execute('chmod +x ~/.local/bin/ta-gtk')
	os.execute('chmod +x ~/.local/bin/textadept-curses')
	os.execute('chmod +x ~/.local/bin/ta')
end

-- Run installation
create_shell_scripts()
print('POSIX integration complete!')
install_icon()
install_desktops()
print('XDG integration complete!')
