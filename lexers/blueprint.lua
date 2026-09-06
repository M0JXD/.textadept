-- Copyright 2025 Jamie Drinkell. See LICENSE.
-- GTK4 Blueprint LPeg lexer.

local lexer = lexer
local P, S, B, R = lpeg.P, lpeg.S, lpeg.B, lpeg.R

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Constants.
lex:add_rule('constants', lex:tag(lexer.CONSTANT_BUILTIN, lex:word_match(lexer.CONSTANT_BUILTIN)))

-- Types.
local capitalized_word = R('AZ') * (R('AZ', 'az', '09') + P('_'))^0
lex:add_rule('type', lex:tag(lexer.TYPE, lex:word_match(lexer.TYPE) + capitalized_word))

-- Functions.
local builtin_func = -(B('.') + B('->')) *
	lex:tag(lexer.FUNCTION_BUILTIN, lex:word_match(lexer.FUNCTION_BUILTIN))
local func = lex:tag(lexer.FUNCTION, lexer.word)
local method = (B('.') + B('->')) * lex:tag(lexer.FUNCTION_METHOD, lexer.word)
lex:add_rule('function', (builtin_func + method + func) * #(lexer.space^0 * '('))

-- Strings.
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"', true)
lex:add_rule('string', lex:tag(lexer.STRING, P('L')^-1 * (sq_str + dq_str)))

-- Comments.
local line_comment = lexer.to_eol('//', true)
local block_comment = lexer.range('/*', '*/')
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Numbers.
local integer = lexer.integer * lexer.word_match('u l ll ul ull lu llu', true)^-1
local float = lexer.float * lexer.word_match('f l df dd dl i j', true)^-1
lex:add_rule('number', lex:tag(lexer.NUMBER, float + integer))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-/*%<>~!=^&|?~:;,.()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.OPERATOR, '{', '}')
lex:add_fold_point(lexer.OPERATOR, '[', ']')
lex:add_fold_point(lexer.COMMENT, '/*', '*/')

-- Word lists.
lex:set_word_list(lexer.KEYWORD, {
	'as', 'bind', 'using', 'template', 'styles', 'destructive', 'suggested', 'disabled',
	'responses', 'items', 'bind-property', 'menu', 'section'
})

lex:set_word_list(lexer.CONSTANT_BUILTIN, {
	'Adw', 'Gtk'
})

lexer.property['scintillua.comment'] = '//'

return lex
