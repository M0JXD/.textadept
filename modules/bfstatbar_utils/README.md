# Buffer Statusbar Text Manipulation Utilites

Buffer Statusbar Text Manipulation Utilites
Buffer Statusbar Utilties is the very short awaited replacement for both bfstatbar_helper that
was [removed][1] and the [table idea introduced in Textadept's Discussions][2].


It introduces some additional string functions to manage the buffer_statusbar more easily.

Example usage:

```lua
require('bfstatbar_utils')

-- Remove Line Endings from being displayed
events.connect(events.UPDATE_UI, function (updated)
	if not updated or updated & 3 == 0 then return end
	ui.buffer_statusbar_text = ui.buffer_statusbar_text:bst_remove(4)
end)

-- Display whether strip trailing whitespace is on
events.connect(events.UPDATE_UI, function (updated)
	if not updated or updated & 3 == 0 then return end
	local strip = 'Strip: ' .. (textadept.editing.strip_trailing_spaces and 'On' or 'Off')
	ui.buffer_statusbar_text = ui.buffer_statusbar_text:bst_insert(5, strip)
end)
```

[1]: https://github.com/M0JXD/.textadept-M0JXD/commit/f97274743940cbb4150a379c7e6c2b7cf7a7536d
[2]: https://github.com/orbitalquark/textadept/discussions/688

<a id="string.bst_count"></a>
## `string.bst_count`(*str*)

Counts the entries in the buffer statusbar.

Parameters:
- *str*:  Buffer statusbar string to count entries of.

Returns: amount of entries in the buffer statusbar.

<a id="string.bst_insert"></a>
## `string.bst_insert`(*str*[, *pos*], *value*)

Insert an item into the buffer statusbar.

Parameters:
- *str*:  Current buffer statusbar string to add to.
- *pos*:  Buffer statusbar position to insert the string (defaults to end).
- *value*:  String to insert.

Returns: Buffer statusbar string with value inserted at pos.

<a id="string.bst_remove"></a>
## `string.bst_remove`(*str*, *pos*)

Remove an item into the buffer statusbar.

Parameters:
- *str*:  Current buffer statusbar string to remove from.
- *pos*:  Buffer statusbar position to remove.

Returns: Buffer statusbar string with value at pos removed.

<a id="string.bst_replace"></a>
## `string.bst_replace`(*str*, *pos*, *value*)

Replace an item into the buffer statusbar.

Parameters:
- *str*:  Current buffer statusbar string to replace an entry in.
- *pos*:  Buffer statusbar position to replace.
- *value*:  String to be used as replacement.

Returns: Buffer statusbar string with value at pos replaced.



