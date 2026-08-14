-- Copyright 2025-2026 Jamie Drinkell. See LICENSE.
-- Ayu Light theme for Textadept.
-- Using colours from https://ayutheme.com/

local view, colors, styles = view, view.colors, view.styles

-- Greyscale colors.
colors.black = 0x66615c -- foreground
colors.light_black = UI == 'terminal' and 0xf6e4d6 or 0x26d65b03 -- selection
colors.dark_grey = 0xb1aead -- comment
-- colors.grey = --unused
colors.light_grey = UI == 'terminal' and 0xf1eeec or 0x1a9f8e82 -- current line
colors.white = 0xfcfcfc -- background

colors.red = 0x7171f0 -- markup
colors.pink = 0x91a1f2 -- operator
colors.orange = 0x3285fa -- keyword
colors.yellow = 0x00a4eb -- function
colors.beige = 0x4596e5 -- special
colors.violet = 0xcc7aa3 -- constant
colors.green = 0x00b386 -- string
colors.turquoise = 0x99bf4c -- regexp
colors.blue = 0xe6a422 -- entity
colors.aqua = 0xd4b455 -- tag

-- Default font.
if not font then font = OS == 'windows' and 'Consolas' or OS == 'macos' and 'Monaco' or 'Monospace' end
if not size then size = OS ~= 'macos' and 10 or 12 end

-- Predefined styles.
styles[view.STYLE_DEFAULT] = {font = font, size = size, fore = colors.black, back = colors.white}
styles[view.STYLE_LINENUMBER] = {fore = colors.dark_grey, back = colors.white}
styles[view.STYLE_BRACELIGHT] = {fore = colors.yellow, bold = true}
styles[view.STYLE_BRACEBAD] = {fore = colors.red}
-- styles[view.STYLE_CONTROLCHAR] = {}
styles[view.STYLE_INDENTGUIDE] = {fore = colors.light_grey}
styles[view.STYLE_CALLTIP] = {fore = colors.black}
styles[view.STYLE_FOLDDISPLAYTEXT] = {fore = colors.dark_grey, back = colors.light_grey}

-- Tag styles.
styles[lexer.ANNOTATION] = {fore = colors.beige}
styles[lexer.ATTRIBUTE] = {fore = colors.beige}
styles[lexer.BOLD] = {bold = true}
styles[lexer.CLASS] = {fore = colors.blue}
styles[lexer.CODE] = {fore = colors.dark_grey, eol_filled = true}
styles[lexer.COMMENT] = {fore = colors.dark_grey, italic = true}
-- styles[lexer.CONSTANT] = {}
styles[lexer.CONSTANT_BUILTIN] = {fore = colors.aqua}
styles[lexer.EMBEDDED] = {fore = colors.beige}
styles[lexer.ERROR] = {fore = colors.red}
styles[lexer.FUNCTION] = {fore = colors.yellow}
styles[lexer.FUNCTION_BUILTIN] = {fore = colors.pink}
styles[lexer.FUNCTION_METHOD] = {fore = colors.yellow}
styles[lexer.HEADING] = {fore = colors.green, bold = true}
-- styles[lexer.IDENTIFIER] = {fore = colors.yellow}
styles[lexer.ITALIC] = {italic = true}
styles[lexer.KEYWORD] = {fore = colors.orange}
styles[lexer.LABEL] = {fore = colors.blue}
styles[lexer.LINK] = {underline = true}
styles[lexer.LIST] = {fore = colors.pink}
styles[lexer.NUMBER] = {fore = colors.violet}
-- styles[lexer.OPERATOR] = {fore = colors.orange}
styles[lexer.PREPROCESSOR] = {fore = colors.orange}
styles[lexer.REFERENCE] = {underline = true}
styles[lexer.REGEX] = {fore = colors.turquoise}
styles[lexer.STRING] = {fore = colors.green}
styles[lexer.TAG] = {fore = colors.aqua}
styles[lexer.TYPE] = {fore = colors.aqua}
styles[lexer.UNDERLINE] = {underline = true}
-- styles[lexer.VARIABLE] = {}
styles[lexer.VARIABLE_BUILTIN] = {fore = colors.blue}
-- styles[lexer.WHITESPACE] = {}

-- CSS.
styles.property = styles[lexer.ATTRIBUTE]
-- styles.pseudoclass = {}
-- styles.pseudoelement = {}
-- Diff.
styles.addition = {fore = colors.green}
styles.deletion = {fore = colors.red}
styles.change = {fore = colors.yellow}
-- HTML.
styles.tag_unknown = styles.tag .. {italic = true}
styles.attribute_unknown = styles.attribute .. {italic = true}
-- Latex, TeX, and Texinfo.
styles.command = styles[lexer.KEYWORD]
styles.command_section = styles[lexer.HEADING]
styles.environment = styles[lexer.TYPE]
styles.environment_math = styles[lexer.NUMBER]
-- Makefile.
-- styles.target = {}
-- Markdown.
-- styles.hr = {}
-- Output.
styles.csi = {visible = false}
local csi_colors = {
	black = colors.black, red = colors.red, green = colors.green, yellow = colors.yellow,
	blue = colors.blue, magenta = colors.beige, cyan = colors.aqua, white = colors.white
}
for k, v in pairs(csi_colors) do styles['csi_' .. k] = {fore = v} end
for k, v in pairs(csi_colors) do styles['csi_' .. k .. '_bright'] = {fore = v, bold = true} end
-- Python.
styles.keyword_soft = {}
-- XML.
-- styles.cdata = {}
-- YAML.
styles.error_indent = {back = colors.red}

-- Element colors.
view.element_color[view.ELEMENT_SELECTION_BACK] = colors.light_black
if UI ~= 'terminal' then
	view.selection_layer = view.LAYER_OVER_TEXT
	-- view.element_color[view.ELEMENT_SELECTION_TEXT] = colors.black
	-- view.element_color[view.ELEMENT_SELECTION_ADDITIONAL_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_ADDITIONAL_BACK] = colors.light_black
	-- view.element_color[view.ELEMENT_SELECTION_SECONDARY_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_SECONDARY_BACK] = colors.light_black
	-- view.element_color[view.ELEMENT_SELECTION_INACTIVE_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_INACTIVE_BACK] = colors.light_black
	-- view.element_color[view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_BACK] = colors.light_black
	view.element_color[view.ELEMENT_CARET] = colors.dark_grey
	-- view.element_color[view.ELEMENT_CARET_ADDITIONAL] =
	view.caret_line_layer = view.LAYER_UNDER_TEXT
else
	view:reset_element_color(view.ELEMENT_SELECTION_TEXT) -- For whatever reason the default ain't default in UI == 'terminal'
end
if view ~= ui.command_entry then
	view.element_color[view.ELEMENT_CARET_LINE_BACK] = colors.light_grey
end

-- Fold Margin.
view:set_fold_margin_color(true, colors.white)
view:set_fold_margin_hi_color(true, colors.white)

-- Markers.
-- view.marker_fore[textadept.bookmarks.MARK_BOOKMARK] = colors.white
view.marker_back[textadept.bookmarks.MARK_BOOKMARK] = colors.blue
-- view.marker_fore[textadept.run.MARK_WARNING] = colors.white
view.marker_back[textadept.run.MARK_WARNING] = colors.yellow
-- view.marker_fore[textadept.run.MARK_ERROR] = colors.white
view.marker_back[textadept.run.MARK_ERROR] = colors.red
for i = view.MARKNUM_FOLDEREND, view.MARKNUM_FOLDEROPEN do -- fold margin
	view.marker_fore[i] = UI == 'terminal' and colors.dark_grey or colors.white
	view.marker_back[i] = UI == 'terminal' and colors.white or colors.dark_grey
	view.marker_back_selected[i] = colors.black
end

-- Indicators.
view.indic_fore[ui.find.INDIC_FIND] = colors.yellow
view.indic_alpha[ui.find.INDIC_FIND] = 0x80
view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = colors.orange
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 0x80
view.indic_fore[textadept.snippets.INDIC_PLACEHOLDER] = colors.black
view.indic_fore[textadept.run.INDIC_WARNING] = colors.yellow
view.indic_fore[textadept.run.INDIC_ERROR] = colors.red

-- Call tips.
view.call_tip_fore_hlt = colors.blue

-- Long Lines.
view.edge_color = colors.light_grey

-- Find & replace pane entries.
ui.find.entry_font = font .. ' ' .. size
