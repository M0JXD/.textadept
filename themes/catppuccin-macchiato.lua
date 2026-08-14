-- Copyright 2026 Jamie Drinkell. See LICENSE.
-- Catppuccin Macchiato theme for Textadept.
-- Using https://catppuccin.com/palette/ and https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md

local view, colors, styles = view, view.colors, view.styles

-- LuaFormatter off
colors.rosewater = 0xd6dbf4
colors.flamingo  = 0xc6c6f0
colors.pink      = 0xe6bdf5
colors.mauve     = 0xf6a0c6
colors.red       = 0x9687ed
colors.maroon    = 0xa099ee
colors.peach     = 0x7fa9f5
colors.yellow    = 0x9fd4ee
colors.green     = 0x95daa6
colors.teal      = 0xcad58b
colors.sky       = 0xe3d791
colors.sapphire  = 0xe4c47d
colors.blue      = 0xf4ad8a
colors.lavender  = 0xf8bdb7
colors.text      = 0xf5d3ca
colors.subtext_1 = 0xe0c0b8
colors.subtext_0 = 0xcbada5
colors.overlay_2 = 0xb79a93
colors.overlay_1 = 0xa28780
colors.overlay_0 = 0x8d736e
colors.surface_2 = 0x78605b
colors.surface_1 = 0x644d49
colors.surface_0 = 0x4f3a36
colors.base      = 0x3a2724
colors.mantle    = 0x30201e
colors.crust     = 0x261918
-- LuaFormatter on

colors.selection = UI == 'terminal' and 0x594440 or (0x40000000 + colors.overlay_2)
colors.lineback = UI == 'terminal' and 0x4c3532 or (0x18000000 + colors.lavender)

-- Default font.
if not font then font = OS == 'windows' and 'Consolas' or OSX and 'Monaco' or 'Monospace' end
if not size then size = OS ~= 'macos' and 10 or 12 end

-- Predefined styles.
styles[view.STYLE_DEFAULT] = {font = font, size = size, fore = colors.text, back = colors.base}
styles[view.STYLE_LINENUMBER] = {fore = colors.overlay_1, back = colors.mantle}
styles[view.STYLE_BRACELIGHT] = {fore = colors.yellow, bold = true}
styles[view.STYLE_BRACEBAD] = {fore = colors.red}
-- styles[view.STYLE_CONTROLCHAR] = {}
styles[view.STYLE_INDENTGUIDE] = {fore = colors.overlay_1}
styles[view.STYLE_CALLTIP] = {fore = colors.overlay_0}
styles[view.STYLE_FOLDDISPLAYTEXT] = {fore = colors.surface_2, back = colors.surface_0}

-- Tag styles.
styles[lexer.ANNOTATION] = {fore = colors.yellow}
styles[lexer.ATTRIBUTE] = {fore = colors.yellow}
styles[lexer.BOLD] = {fore = colors.red, bold = true}
styles[lexer.CLASS] = {fore = colors.yellow}
styles[lexer.CODE] = {fore = colors.overlay_0, eol_filled = true}
styles[lexer.COMMENT] = {fore = colors.overlay_2, italic = true}
-- styles[lexer.CONSTANT] = {fore = colors.peach}
styles[lexer.CONSTANT_BUILTIN] = {fore = colors.red}
styles[lexer.EMBEDDED] = {fore = colors.rosewater}
styles[lexer.ERROR] = {fore = colors.red}
styles[lexer.FUNCTION] = {fore = colors.blue}
styles[lexer.FUNCTION_BUILTIN] = {fore = colors.rosewater}
styles[lexer.FUNCTION_METHOD] = {fore = colors.blue}
styles[lexer.HEADING] = {fore = colors.red, bold = true}
-- styles[lexer.IDENTIFIER] = {fore = colors.yellow}
styles[lexer.ITALIC] = {fore = colors.red, italic = true}
styles[lexer.KEYWORD] = {fore = colors.mauve}
styles[lexer.LABEL] = {fore = colors.subtext_0}
styles[lexer.LINK] = {fore = colors.blue, underline = true}
styles[lexer.LIST] = {fore = colors.teal}
styles[lexer.NUMBER] = {fore = colors.peach}
-- styles[lexer.OPERATOR] = {fore = colors.sky}
styles[lexer.PREPROCESSOR] = {fore = colors.mauve}
styles[lexer.REFERENCE] = {underline = true}
styles[lexer.REGEX] = {fore = colors.pink}
styles[lexer.STRING] = {fore = colors.green}
styles[lexer.TAG] = {fore = colors.blue}
styles[lexer.TYPE] = {fore = colors.yellow}
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
styles.change = {fore = colors.blue}
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
	black = colors.surface_1, red = colors.red, green = colors.green, yellow = colors.yellow,
	blue = colors.blue, magenta = colors.mauve, cyan = colors.sky, white = colors.text
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
view.element_color[view.ELEMENT_SELECTION_BACK] = colors.selection
if UI ~= 'terminal' then
	view.selection_layer = view.LAYER_OVER_TEXT
	-- view.element_color[view.ELEMENT_SELECTION_TEXT] = colors.black
	-- view.element_color[view.ELEMENT_SELECTION_ADDITIONAL_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_ADDITIONAL_BACK] = colors.selection
	-- view.element_color[view.ELEMENT_SELECTION_SECONDARY_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_SECONDARY_BACK] = colors.selection
	-- view.element_color[view.ELEMENT_SELECTION_INACTIVE_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_INACTIVE_BACK] = colors.selection
	-- view.element_color[view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_TEXT] = colors.black
	view.element_color[view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_BACK] = colors.selection
	view.element_color[view.ELEMENT_CARET] = colors.rosewater
	-- view.element_color[view.ELEMENT_CARET_ADDITIONAL] =
	view.caret_line_layer = view.LAYER_UNDER_TEXT
else
	view:reset_element_color(view.ELEMENT_SELECTION_TEXT) -- For whatever reason the default ain't default for terminal
end

if view ~= ui.command_entry then
	view.element_color[view.ELEMENT_CARET_LINE_BACK] = colors.lineback
end

-- Fold Margin.
view:set_fold_margin_color(true, colors.base)
view:set_fold_margin_hi_color(true, colors.crust)

-- Markers.
-- view.marker_fore[textadept.bookmarks.MARK_BOOKMARK] = colors.white
view.marker_back[textadept.bookmarks.MARK_BOOKMARK] = colors.sapphire
-- view.marker_fore[textadept.run.MARK_WARNING] = colors.white
view.marker_back[textadept.run.MARK_WARNING] = colors.yellow
-- view.marker_fore[textadept.run.MARK_ERROR] = colors.white
view.marker_back[textadept.run.MARK_ERROR] = colors.red
for i = view.MARKNUM_FOLDEREND, view.MARKNUM_FOLDEROPEN do -- fold margin
	view.marker_fore[i] = UI == 'terminal' and colors.subtext_1 or colors.crust
	view.marker_back[i] = UI == 'terminal' and colors.base or colors.overlay_1
	view.marker_back_selected[i] = colors.overlay_2
end

-- Indicators.
view.indic_fore[ui.find.INDIC_FIND] = colors.yellow
view.indic_alpha[ui.find.INDIC_FIND] = 0x50
view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = colors.peach
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 0x50
view.indic_fore[textadept.snippets.INDIC_PLACEHOLDER] = colors.surface_1
view.indic_fore[textadept.run.INDIC_WARNING] = colors.yellow
view.indic_fore[textadept.run.INDIC_ERROR] = colors.red

-- Call tips.
view.call_tip_fore_hlt = colors.blue

-- Long Lines.
view.edge_color = colors.lavender

-- Find & replace pane entries.
ui.find.entry_font = font .. ' ' .. size
