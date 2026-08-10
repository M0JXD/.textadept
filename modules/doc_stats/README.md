# Textadept Document Statistics

Simple document statistics module, providing additional details about the buffer and selections.

Document Statistics is inspired by the plugin of the same name in the Xed editor, and the
Summary feature in Notepad++. It adds a "Tools > Document Statistics" menu entry which opens a
dialog with details for the current selection and the whole document.

You can also add these details in the buffer status bar with the [`doc_stats.display`](#doc_stats.display) table.
Set each field as true to use the default placement, or use a number to insert at that position.

NB: The field `doc_stats.display.lines` will replace Textadept's line counter so that it shows
the amount of lines instead of the line the cursor is on when a selection exists.

The internal count functions are exposed, they work on the currently active buffer.

The word count uses the algorithm from
<https://www.countofwords.com/word-count-algorithms-and-how-you-can-use-them.html>

The separators are configurable in the [`doc_stats.separators`](#doc_stats.separators) array.
By default, it only matches whitespace, which provides the same results as MS Office.


<a id="doc_stats.ALL_SPACES"></a>
## `doc_stats.ALL_SPACES`

Constant for [`doc_stats.count_chars`](#doc_stats.count_chars) to include spaces in the count.

<a id="doc_stats.DISCARD_NEWLINES"></a>
## `doc_stats.DISCARD_NEWLINES`

Constant for [`doc_stats.count_chars`](#doc_stats.count_chars) to discard newlines in the count.

<a id="doc_stats.DISCARD_SPACES"></a>
## `doc_stats.DISCARD_SPACES`

Constant for [`doc_stats.count_chars`](#doc_stats.count_chars) to discard spaces in the count.

<a id="doc_stats.count_bytes"></a>
## `doc_stats.count_bytes`(*all*)

Count the amount of bytes.

Parameters:
- *all*:  Boolean to signify whether to count current selection or "all" of the document.

Returns: Amount of bytes counted.

<a id="doc_stats.count_chars"></a>
## `doc_stats.count_chars`(*spaces*, *all*)

Count the amount of characters.

Parameters:
- *spaces*:  Constant value to signify what whitespace should(n't) be included in the count.
- *all*:  Boolean to signify whether to count current selection or "all" of the document.

Returns: Amount of chars counted.

Usage:

```lua
local all_chars = doc_stats.count_chars(doc_stats.ALL_SPACES, true)
```

<a id="doc_stats.count_newline"></a>
## `doc_stats.count_newline`(*all*)

Count the amount of newlines.

Parameters:
- *all*:  Boolean to signify whether to count current selection or "all" of the document.

Returns: Amount of newlines counted.

<a id="doc_stats.count_rows"></a>
## `doc_stats.count_rows`()

Count the amount of rows for the current selection.

Returns: Amount of rows counted.

<a id="doc_stats.count_spaces"></a>
## `doc_stats.count_spaces`(*all*)

Count the amount of spaces.

Parameters:
- *all*:  Boolean to signify whether to count current selection or "all" of the document.

Returns: Amount of spaces counted.

<a id="doc_stats.count_words"></a>
## `doc_stats.count_words`(*all*)

Count the amount of words.

Parameters:
- *all*:  Boolean to signify whether to count current selection or "all" of the document.

Returns: Amount of words counted.

<a id="doc_stats.display"></a>
## `doc_stats.display`

What to display in the buffer statusbar.

All values are `false` by default.
Set `true` for the default placement, or a number for a specific location.

Fields:
- `words`: Display word counts.
- `bytes`: Display byte counts.
- `lines`: Replace line counter with one that uses the selection.
- `rows`: Display row counts.
- `chars`: Display char counts.
- `chars_ns`: Display char (exc. spaces) counts.
- `chars_nl`: Display char (exc. newlines) counts.

<a id="doc_stats.separators"></a>
## `doc_stats.separators`

Separators for the Word Count Algorithm.

Default entries are whitespace characters `'\t'`, `'\n'`, `'\r'` and `' '`.

Usage:

```lua
doc_stats.separators[#doc_stats.separators+1] = '-' -- Add '-' to separators
```
