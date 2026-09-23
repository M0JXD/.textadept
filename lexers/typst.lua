-- Copyright 2026 Jamie Drinkell. See LICENSE.
-- Typst LPeg lexer.
-- Reference: https://typst.app/docs/reference/syntax/

local lexer = lexer
local P, S, B = lpeg.P, lpeg.S, lpeg.B

-- Typst is essentially three languages for markup, math and scripting
-- So create three lexers and use the embedding rules
-- Markup can be passed into the scripting via [], but embedding it
-- creates an endless loading loop resulting in stack overflow
local script = lexer.new('script')
local mathematics = lexer.new('mathematics')
local lex = lexer.new(...)

-- Comment patterns for all lexers
local line_comment = lexer.to_eol('//', true)
local block_comment = lexer.range('/*', '*/')

-- Typst Scripting

-- Keywords
script:add_rule('keyword', script:tag(lexer.KEYWORD, script:word_match(lexer.KEYWORD)))

-- Functions.
local builtin_func = -B('.') *
	script:tag(lexer.FUNCTION_BUILTIN, script:word_match(lexer.FUNCTION_BUILTIN))
local func = script:tag(lexer.FUNCTION, lexer.word)
local method = B('.') * script:tag(lexer.FUNCTION_METHOD, lexer.word)
script:add_rule('function', (builtin_func + method + func) * '(')

-- Comments
script:add_rule('comment', script:tag(lexer.COMMENT, line_comment + block_comment))

script:set_word_list(lexer.KEYWORD, {
	'set', 'let', 'if', 'else', 'for', 'while', 'in', 'not', 'and', 'or', 'import', 'include',
	'break'
})

-- Typst Mathematics
-- mathematics:add_rule('keyword',
-- 	mathematics:tag(lexer.KEYWORD, mathematics:word_match(lexer.KEYWORD)))

-- Functions.
local builtin_func = -B('.') *
	mathematics:tag(lexer.FUNCTION_BUILTIN, mathematics:word_match(lexer.FUNCTION_BUILTIN))
local func = mathematics:tag(lexer.FUNCTION, lexer.word)
local method = B('.') * mathematics:tag(lexer.FUNCTION_METHOD, lexer.word)
mathematics:add_rule('function', (builtin_func + method + func) * '(')

-- Comments
mathematics:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Typst Markup

-- Headings
lex:add_rule('header', lex:tag(lexer.HEADING, lexer.to_eol(lexer.starts_line('='))))

-- Lists
lex:add_rule('list', lex:tag(lexer.LIST, lexer.starts_line(S('*+-'), true) * S(' \t')))

-- Strings
lex:add_rule('string', lex:tag(lexer.STRING, P('L')^-1 * lexer.range('"', true)))

-- Raw Text
local raw_text = lpeg.Cmt(lpeg.C(P('`')^1), function(input, index, bt)
	-- `foo`, ``foo``, ``foo`bar``, `foo``bar` are all allowed.
	local _, e = input:find('[^`]' .. bt .. '%f[^`]', index)
	return (e or #input) + 1
end)
lex:add_rule('raw', lex:tag(lexer.CODE, raw_text))

-- Links
local link_url = 'http' * P('s')^-1 * '://' * (lexer.any - lexer.space)^1 +
	('<' * lexer.alpha^2 * ':' * (lexer.any - lexer.space - '>')^1 * '>')
lex:add_rule('link', lex:tag(lexer.LINK, link_url))

-- Strong and Emphasis
lex:add_rule('strong', lex:tag(lexer.BOLD, lexer.range('*', true)))
lex:add_rule('em', lex:tag(lexer.ITALIC, lexer.range('_', true)))

-- Plain text.
lex:add_rule('word', lex:tag(lexer.DEFAULT, lexer.word_utf8))

local FOLD_HEADER, FOLD_BASE = lexer.FOLD_HEADER, lexer.FOLD_BASE
-- Fold '=' headers.
function lex:fold(text, start_line, start_level)
	local levels = {}
	local line_num = start_line
	if start_level > FOLD_HEADER then start_level = start_level - FOLD_HEADER end
	for line in (text .. '\n'):gmatch('(.-)\r?\n') do
		local header = line:match('^%s*(=*)')
		-- If the previous line was a header, this line's level has been pre-defined.
		-- Otherwise, use the previous line's level, or if starting to fold, use the start level.
		local level = levels[line_num] or levels[line_num - 1] or start_level
		if level > FOLD_HEADER then level = level - FOLD_HEADER end
		-- If this line is a header, set its level to be one less than the header level
		-- (so it can be a fold point) and mark it as a fold point.
		if #header > 0 then
			level = FOLD_BASE + #header - 1 + FOLD_HEADER
			levels[line_num + 1] = FOLD_BASE + #header
		end
		levels[line_num] = level
		line_num = line_num + 1
	end
	return levels
end

lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Embedding
local math_delimit = lex:tag(lexer.EMBEDDED, P('$') - P('\\$'))
local script_start = lex:tag(lexer.EMBEDDED, '#' - P('\\#') * #lexer.word)
local script_end = ';' + P('\n\n') + '\n' * #P('#')
	-- + (lexer.word - script:word_match(lexer.KEYWORD))
	-- + (lexer.word - (lexer.word * S('(:)')))

-- script:embed(lex, P('['), P(']')) -- Stack overflow
lex:embed(mathematics, math_delimit, math_delimit)
lex:embed(script, script_start, script_end)

return lex
