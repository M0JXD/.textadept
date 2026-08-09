-- Copyright 2026 Jamie Drinkell. MIT License.

--- Buffer Statusbar Text Manipulation Utilites
-- Buffer Statusbar Utilties is the very short awaited replacement for both bfstatbar_helper that
-- was [removed][1] and the [table idea introduced in Textadept's Discussions][2].
--
-- It introduces some additional string functions to manage the buffer_statusbar more easily.
--
-- Example usage:
--
-- ```lua
-- require('bfstatbar_utils')
--
-- -- Remove Line Endings from being displayed
-- events.connect(events.UPDATE_UI, function (updated)
-- 	if not updated or updated & 3 == 0 then return end
-- 	ui.buffer_statusbar_text = ui.buffer_statusbar_text:bst_remove(4)
-- end)
--
-- -- Display whether strip trailing whitespace is on
-- events.connect(events.UPDATE_UI, function (updated)
-- 	if not updated or updated & 3 == 0 then return end
-- 	local strip = 'Strip: ' .. (textadept.editing.strip_trailing_spaces and 'On' or 'Off')
-- 	ui.buffer_statusbar_text = ui.buffer_statusbar_text:bst_insert(5, strip)
-- end)
-- ```
--
-- [1]: https://github.com/M0JXD/.textadept-M0JXD/commit/f97274743940cbb4150a379c7e6c2b7cf7a7536d
-- [2]: https://github.com/orbitalquark/textadept/discussions/688
-- @module bfstatbar_utils
local M = {}

local spacing = UI == 'terminal' and '  ' or '    '

--- Counts the entries in the buffer statusbar.
-- @param str Buffer statusbar string to count entries of.
-- @return amount of entries in the buffer statusbar.
function string.bst_count(str)
	local _, count = str:gsub(spacing, spacing)
	return count + 1
end

--- Insert an item into the buffer statusbar.
-- @param str Current buffer statusbar string to add to.
-- @param[opt] pos Buffer statusbar position to insert the string (defaults to end).
-- @param value String to insert.
-- @return Buffer statusbar string with value inserted at pos.
function string.bst_insert(str, ...)
	local text, pos, value
	local count = str:bst_count()

	local arg = table.pack(...)
	if arg.n == 1 then
		pos = count + 1
		value = arg[1]
	elseif arg.n == 2 then
		pos = arg[1]
		value = arg[2]
	end

	if pos <= 1 then
		text = value .. spacing .. str
	elseif pos >= (count + 1) then
		text = str .. spacing .. value
	else
		local c = 0
		text, count = str:gsub(spacing, function(match)
			c = c + 1
			if c == pos - 1 then return match .. value .. match end
			return match
		end)
	end
	return text
end

--- Remove an item into the buffer statusbar.
-- @param str Current buffer statusbar string to remove from.
-- @param pos Buffer statusbar position to remove.
-- @return Buffer statusbar string with value at pos removed.
function string.bst_remove(str, pos)
	local text
	local entry_pat = '%S*%s?%S*' .. spacing
	local count = str:bst_count()
	pos = pos and pos or count + 1

	if pos <= 1 then
		text = str:gsub(entry_pat, '', 1)
	elseif pos >= count then
		entry_pat = spacing .. '%S*%s?%S*$'
		text = str:gsub(entry_pat, '', 1)
	else
		local c = 0
		text = str:gsub(entry_pat, function(match)
			c = c + 1
			if c == pos then return '' end
			return match
		end)
	end
	return text
end

--- Replace an item into the buffer statusbar.
-- @param str Current buffer statusbar string to replace an entry in.
-- @param pos Buffer statusbar position to replace.
-- @param value String to be used as replacement.
-- @return Buffer statusbar string with value at pos replaced.
function string.bst_replace(str, pos, value)
	local text
	local entry_pat = '%S*%s?%S*' .. spacing
	local count = str:bst_count()

	if pos >= count then
		entry_pat = spacing .. '%S*%s?%S*$'
		text = str:gsub(entry_pat, spacing .. value, 1)
	else
		pos = pos <= 1 and 1 or pos
		local c = 0
		text = str:gsub(entry_pat, function(match)
			c = c + 1
			if c == pos then return value .. spacing end
			return match
		end)
	end
	return text
end

return M
