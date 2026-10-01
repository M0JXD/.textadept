-- Copyright 2016-2026 Mitchell. See LICENSE.
-- Copyright 2026 Jamie Drinkell. See LICENSE.

--- Export Extensions
--
-- This module extends the Export module's functionality by adding additional render options via Pandoc.
-- For it to work right it should be added after the official Export module:
--
-- ```lua
-- local export = require('export')
-- require('export_ext')
-- ```
--
-- The additional options will be available under the "File > Export" menu.
-- Pandoc's output has some defaults applied by the module, although you may pass your own options.
--
-- This module also has a Markdown compiler. If you try to compile Markdown and it fails,
-- it will try to take over for you with the bundled implementation.
--
-- @module export_ext
local M = {}
local module_path = _USERHOME ..
	(OS == 'windows' and '\\modules\\export_ext\\' or '/modules/export_ext/')

--- PDF engine to instruct Pandoc to use.
-- Default is `'typst'`
M.pdf_engine = 'typst'

--- Defaults file to instruct Pandoc to use with PDF output.
-- Defaults to the bundled *pdf.yaml*.
M.pdf_defaults = module_path .. 'pdf.yaml'

--- Reference file to instruct Pandoc to use with ODT output.
-- Defaults to the bundled *reference.odt*.
M.odt_reference = module_path .. 'reference.odt'

--- CSS file to instruct Pandoc to use with HTML output.
-- Defaults to the bundled *bundle.css*.
M.css = module_path .. 'bundle.css'

--- Command used to open exported HTML files in the user's default web browser.
M.browser = OS == 'windows' and 'start ""' or OS == 'macos' and 'open' or 'xdg-open'

--- Checks if the current buffer is a Markdown or LaTeX document.
local function check(buffer, type)
	if not (buffer:get_lexer() == 'markdown' or buffer:get_lexer() == 'latex') then
		ui.statusbar_text = "Can't convert " .. buffer:get_lexer() .. ' to ' .. type .. '!'
		return false
	end
	return true
end

--- Converts Markdown to HTML (internal version).
local function markdown_to_html(buffer)
	if check(buffer, 'HTML') then
		-- Prompt the user for the HTML file to export to
		local filename = buffer.filename or ''
		local dir, name = filename:match('^(.-)[/\\]?([^/\\]-)%.?[^.]*$')
		local out_filename = ui.dialogs.save{
			title = _L['Save File'], dir = dir, file = name .. '.html'
		}
		if not out_filename then return end
		htmlout = require('export_ext/markdown')(buffer:get_text())
		io.open(out_filename, 'w'):write(htmlout):close()
	end
end

--- Converts Markdown to HTML.
-- Uses the bundled Lua implementation.
-- Textadept comes with a Markdown compile command, this exists for emergency environments
-- where there's no Markdown compiler. Will open in Browser after use.
function M.markdown_to_html()
	markdown_to_html(buffer)
	os.spawn(string.format('%s "%s"', M.browser, out_filename))
end

--- Returns a buffer's UTF-8 filename and basename for display.
-- If that buffer does not have a filename, returns its type or 'Untitled'.
-- @param buffer Buffer to get display names for.
local function get_display_names(buffer)
	local filename = buffer.filename or buffer._type or _L['Untitled']
	if buffer.filename then
		filename = select(2, pcall(string.iconv, filename, 'UTF-8', _CHARSET))
	end
	return buffer.filename and filename:match('[^/\\]+$') or filename
end

events.connect(events.ERROR, function(text)
	local buffer_to_convert
	if string.find(text, 'markdown', 1, true) then
		-- Try to work out the buffer...
		for i, v in ipairs(_BUFFERS) do
			local name = get_display_names(_BUFFERS[i])
			if string.find(text, name, 1, true) then
				buffer_to_convert = _BUFFERS[i]
				break
			end
		end
		ui.print(
			'Seems like you don\'t have a `markdown` command installed, export_ext will take over...')
		markdown_to_html(buffer_to_convert)
	end
end)

--- Calls pandoc to convert Markdown or LaTeX files.
-- @param type Type to document convert to, supports 'html', 'pdf' or 'odt'.
function M.pandoc(type)
	if check(buffer, type:upper()) then
		-- Prompt the user for the file to export to
		local filename = buffer.filename or ''
		local dir, name = filename:match('^(.-)[/\\]?([^/\\]-)%.?[^.]*$')
		local out_filename = ui.dialogs.save{
			title = _L['Save File'], dir = dir, file = name .. '.' .. type
		}
		if not out_filename then return end

		local pandoc_str = 'pandoc '
		if type == 'html' then
			pandoc_str = pandoc_str .. '--standalone --embed-resources=true --css=' .. M.css
		elseif type == 'pdf' then
			pandoc_str = pandoc_str .. '--pdf-engine=' .. M.pdf_engine .. ' --defaults ' ..
				M.pdf_defaults
		elseif type == 'odt' then
			pandoc_str = pandoc_str .. '--reference-doc ' .. M.odt_reference
		elseif type == 'docx' then
			pandoc_str = pandoc_str
		end
		pandoc_str = pandoc_str .. ' -s -o "' .. out_filename .. '" "' .. filename .. '"'
		os.remove('"' .. out_filename .. '"')
		os.execute(pandoc_str)
		os.execute(M.browser .. ' "' .. out_filename .. '"')
	end
end

-- Add to Export sub-menu.
_L['Pandoc to HTML...'] = 'Pandoc to H_TML...'
_L['Pandoc to ODT...'] = 'Pandoc to _ODT...'
_L['Pandoc to PDF...'] = 'Pandoc to _PDF...'
_L['Pandoc to DOCX...'] = 'Pandoc to _DOCX...'
local m_export = textadept.menu.menubar['File/Export']
table.insert(m_export, {_L['Pandoc to DOCX...'], function() M.pandoc('docx') end})
table.insert(m_export, {_L['Pandoc to HTML...'], function() M.pandoc('html') end})
table.insert(m_export, {_L['Pandoc to ODT...'], function() M.pandoc('odt') end})
table.insert(m_export, {_L['Pandoc to PDF...'], function() M.pandoc('pdf') end})

return M
