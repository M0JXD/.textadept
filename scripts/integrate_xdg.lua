-- Copyright 2026 Jamie Drinkell. See LICENSE.

--- Run integration steps for XDG compliant desktops (Linux/BSD)
-- Expects a Textadept installation under *~/Applications/textadept*
-- Safe to rerun as checks for existing rules when adding the paths/aliases
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

local function check_installed_path_aliases(to_check, text)
	local file = io.open(os.getenv('HOME') .. '/' .. to_check, "r")
	if not file then return true end -- Treat file not existing as 'true' condition
	local content = file:read("*all")
	file:close()
	return string.find(content, text, 1, true) ~= nil
end

local function append_file(to_append, text)
	local file = io.open(os.getenv('HOME') .. '/' .. to_append, 'a')
	file:write('\n' .. text)
	file:close()
end

local function install_path_aliases()
	local export = 'export PATH=$HOME/Applications/textadept:$PATH'
	local aliases =
		'alias ta="textadept-curses"\nalias ta-gtk="textadept-gtk"\nalias ta-qt="textadept"'

	if not check_installed_path_aliases('.profile', export) then
		print('Exporting install path and adding aliases to ~/.profile...')
		append_file('.profile', export .. '\n' .. aliases)
	end

	if not check_installed_path_aliases('.bashrc', export) then
		print('Exporting install path and adding aliases to ~/.bashrc...')
		append_file('.bashrc', export .. '\n' .. aliases)
	end

	if not check_installed_path_aliases('.bash_profile', export) then
		print('Exporting install path and adding aliases to ~/.bash_profile...')
		append_file('.bash_profile', export .. '\n' .. aliases)
	end
end

-- Run installation
install_icon()
install_desktops()
install_path_aliases()
print('XDG integration complete!')
