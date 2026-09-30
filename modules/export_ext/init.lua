-- Copyright 2016-2026 Mitchell. See LICENSE.
-- Copyright 2026 Jamie Drinkell. See LICENSE.

--- Export Extensions for PDFs and Markdown
--
-- This module extends the Export module's functionality by adding additional render options.
-- For it to work right it should be added after the official Export module:
--
-- ```lua
-- local export = require('export')
-- require('export_ext')
-- ```
--
-- The additional options will be available under the "File > Export" menu.
--
-- Additonal render options are:
--
-- - Markdown to plain HTML.
-- - Calling pandoc to convert the current document to HTML, PDF or ODT.
--
-- Pandoc's output has some defaults applied by the module, although you may pass your own options.
--
-- @module export_ext
local M = {}
local module_path = _USERHOME .. (OS == 'windows' and '\\modules\\export_ext\\' or '/modules/export_ext/')

--- PDF engine to instruct Pandoc to use
-- Default is `'typst'`
M.pdf_engine = 'typst'

--- Defaults file to instruct Pandoc to use with PDF output
-- Defaults to the bundled *pdf.yaml*
M.pdf_defaults = module_path .. 'pdf.yaml'

--- Reference file to instruct Pandoc to use with ODT output
-- Defaults to the bundled *reference.odt*
M.odt_reference = module_path .. 'reference.odt'

--- CSS file to instruct Pandoc to use with HTML output
-- Defaults to the bundled *bundle.css*
M.css = module_path .. 'bundle.css'

--- Command used to open exported HTML files in the user's default web browser.
M.browser = OS == 'windows' and 'start ""' or OS == 'macos' and 'open' or 'xdg-open'

--- Checks if the current buffer is a Markdown or LaTeX document.
local function check(type)
	if not (buffer:get_lexer() == 'markdown' or buffer:get_lexer() == 'latex') then
		ui.statusbar_text = "Can't convert " .. buffer:get_lexer() .. ' to ' .. type .. '!'
		return false
	end
	return true
end

--- Converts Markdown to HTML.
-- Checks for a installed in `markdown` command (e.g. the perl version or discount)
-- or falls back to a bundled Lua implementation if it does not exist.
function M.markdown_to_html()
	if check('HTML') then
		-- Prompt the user for the HTML file to export to
		local filename = buffer.filename or ''
		local dir, name = filename:match('^(.-)[/\\]?([^/\\]-)%.?[^.]*$')
		local out_filename = ui.dialogs.save{
			title = _L['Save File'], dir = dir, file = name .. '.html'
		}
		if not out_filename then return end

		-- Check if a "markdown" command exists (Perl, Discount etc.)
		local htmlout
		local mdproc = os.spawn('markdown')
		if mdproc == nil then
			-- Fallback to bundled Lua implementation
			htmlout = require('export_ext/markdown')(buffer:get_text())
		else
			mdproc:write(buffer:get_text())
			mdproc:close()
			htmlout = mdproc:read('a')
		end
		io.open(out_filename, 'w'):write(htmlout):close()
		os.spawn(string.format('%s "%s"', M.browser, out_filename))
	end
end

--- Calls pandoc to convert Markdown or LaTeX files.
-- @param type Type to document convert to, supports 'html', 'pdf' or 'odt'.
function M.pandoc(type)
	if check(type:upper()) then
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
			pandoc_str = pandoc_str .. '--pdf-engine=' .. M.pdf_engine .. ' --defaults ' .. M.pdf_defaults
		elseif type == 'odt' then
			pandoc_str = pandoc_str .. '--reference-doc ' .. M.odt_reference
		end
		pandoc_str = pandoc_str .. ' -s -o "' .. out_filename .. '" "' .. filename .. '"'
		os.remove('"' .. out_filename .. '"')
		os.execute(pandoc_str)
		os.execute(M.browser .. ' "' .. out_filename .. '"')
	end
end

-- TODO: Once there's an Asciidoc lexer, add Asciidoc tooling

-- Add to Export sub-menu.
_L['Convert Markdown to HTML...'] = 'Convert _Markdown to HTML...'
_L['Pandoc to HTML...'] = 'Pandoc to H_TML...'
_L['Pandoc to ODT...'] = 'Pandoc to _ODT...'
_L['Pandoc to PDF...'] = 'Pandoc to _PDF...'
local m_export = textadept.menu.menubar['File/Export']
table.insert(m_export, {_L['Convert Markdown to HTML...'], M.markdown_to_html})
table.insert(m_export, {_L['Pandoc to HTML...'], function() M.pandoc('html') end})
table.insert(m_export, {_L['Pandoc to ODT...'], function() M.pandoc('odt') end})
table.insert(m_export, {_L['Pandoc to PDF...'], function() M.pandoc('pdf') end})

return M
