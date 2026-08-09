# Export Extensions for PDFs and Markdown

Export Extensions for PDFs and Markdown

This module extends the Export module's functionality by adding additional render options:

- Markdown to plain HTML.

- Calling pandoc to convert the current document to HTML, PDF or ODT.

For it to work right it must be added after the official Export module:

```lua
local export = require('export')
require('export_ext')
```

The additional options will be available under the "File > Export" menu.


<a id="export_ext.browser"></a>
## `export_ext.browser`

Command used to open exported HTML files in the user's default web browser.

<a id="export_ext.markdown_to_html"></a>
## `export_ext.markdown_to_html`()

Converts Markdown to HTML.

Checks for a installed in `markdown` command (e.g. the perl version or discount)
or falls back to a bundled Lua implementation if it does not exist.

<a id="export_ext.pandoc"></a>
## `export_ext.pandoc`(*type*)

Calls pandoc to convert Markdown or LaTeX files.

Parameters:
- *type*:  Type to document convert to, supports 'html', 'pdf' or 'odt'.
