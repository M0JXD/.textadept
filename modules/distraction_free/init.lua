-- Copyright 2020 Mitchell. Copyright 2025-2026 Jamie Drinkell. See LICENSE.

--- Textadept Distraction Free Mode
--
-- Based on Mitchell's [Distraction Free Mode][1], but wrapped into a module.
-- It can hide more UI elements and allows you to configure what you want to hide.
-- Also works in the terminal version. Defaults to my preferences.
--
-- [1]: https://github.com/orbitalquark/textadept/wiki/DistractionFreeMode
-- @module distraction_free
local M = {}

--- Whether to hide the menubar.
-- The default value is `true`.
M.hide_menubar = true

--- Whether to hide the tabbar.
-- The default value is `true`.
M.hide_tabs = true

-- Whether to hide the scrollbars.
-- The default value is `true`.
M.hide_scrollbars = true

--- Whether to hide the statusbar.
-- The default value is `true`.
M.hide_statusbar = true

--- Whether to hide the margins (line numbers).
-- The default value is `false`.
M.hide_margins = false

--- Whether to hide the title in the terminal version.
-- The default value is `true`.
M.hide_term_title = true

--- Whether to maximise the window.
-- The default value is `false`.
M.maximise = false

--- The shortcut used to toggle distraction free mode.
-- The default value is `ctrl+f11` except for BSD, which is `f11`.
M.toggle_shortcut = OS == 'bsd' and 'f11' or 'ctrl+f11'

-- NB: This is carefully connected to the right events instead of generic UPDATE_UI
-- Otherwise it just flickers all the time.
local function clear_title()
	ui.title = nil
end

-- Distraction free mode
local distraction_free = false
local menubar = textadept.menu.menubar
local tab_bar = ui.tabs
local margin_widths = {}
local maximized = ui.maximized

keys[M.toggle_shortcut] = function()
	if not distraction_free then
		if M.hide_menubar then textadept.menu.menubar = nil end -- Remove menu bar
		if M.hide_tabs then ui.tabs = false end -- Remove the tab bar
		if M.maximise then ui.maximized = true end -- maximise
		-- Disable scroll bars
		if M.hide_scrollbars then
			view.h_scroll_bar = false
			view.v_scroll_bar = false
		end
		-- Force the statusbar to always be blank
		ui.statusbar = false
		-- Hide margins/line numbers
		if M.hide_margins then
			for i = 1, view.margins do
				margin_widths[i] = view.margin_width_n[i]
				view.margin_width_n[i] = 0
			end
		end

		-- Remove the "Title" in curses
		if UI == 'terminal' and M.hide_term_title then
			events.connect(events.BUFFER_AFTER_SWITCH, clear_title)
			events.connect(events.BUFFER_NEW, clear_title)
			events.connect(events.SAVE_POINT_REACHED, clear_title)
			events.connect(events.SAVE_POINT_LEFT, clear_title)
			events.connect(events.VIEW_AFTER_SWITCH, clear_title)
			events.emit(events.BUFFER_AFTER_SWITCH, 1)
		end
		-- Restore old state.
	else
		if M.hide_menubar then textadept.menu.menubar = menubar end
		if M.hide_tabs then ui.tabs = tab_bar end
		if M.maximise then ui.maximized = maximized end
		if M.hide_scrollbars then
			view.h_scroll_bar = true
			view.v_scroll_bar = true
		end
		if M.hide_statusbar then ui.statusbar = true end
		if M.hide_margins then
			for i = 1, view.margins do view.margin_width_n[i] = margin_widths[i] end
		end
		-- Restore the title by switching to the same buffer
		if UI == 'terminal' and M.hide_term_title then
			events.disconnect(events.BUFFER_AFTER_SWITCH, clear_title)
			events.disconnect(events.BUFFER_NEW, clear_title)
			events.disconnect(events.SAVE_POINT_REACHED, clear_title)
			events.disconnect(events.SAVE_POINT_LEFT, clear_title)
			events.disconnect(events.VIEW_AFTER_SWITCH, clear_title)
			view:goto_buffer(0)
		end
	end
	distraction_free = not distraction_free
end

return M
