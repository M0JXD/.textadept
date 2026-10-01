# Export Extensions

This module extends the Export module's functionality by adding additional render options via Pandoc.

For it to work right it should be added after the official Export module:

```lua
local export = require('export')
require('export_ext')
```

The additional options will be available under the "File > Export" menu.
Pandoc's output has some defaults applied by the module, although you may pass your own options.

This module also has a Markdown compiler. If you try to compile Markdown and it fails,
it will try to take over for you with the bundled implementation.


<a id="export_ext.browser"></a>
## `export_ext.browser`

Command used to open exported HTML files in the user's default web browser.

<a id="export_ext.css"></a>
## `export_ext.css`

CSS file to instruct Pandoc to use with HTML output.

Defaults to the bundled *bundle.css*.

<a id="export_ext.markdown_to_html"></a>
## `export_ext.markdown_to_html`()

Converts Markdown to HTML using the bundled Lua implementation.

Textadept comes with a Markdown compile command, this exists for emergency environments
where there's no Markdown compiler. Will open in Browser after use.

<a id="export_ext.odt_reference"></a>
## `export_ext.odt_reference`

Reference file to instruct Pandoc to use with ODT output.

Defaults to the bundled *reference.odt*.

<a id="export_ext.pandoc"></a>
## `export_ext.pandoc`(*type*)

Calls pandoc to convert Markdown or LaTeX files.

Parameters:
- *type*:  Type to document convert to, supports 'html', 'pdf' or 'odt'.

<a id="export_ext.pdf_defaults"></a>
## `export_ext.pdf_defaults`

Defaults file to instruct Pandoc to use with PDF output.

Defaults to the bundled *pdf.yaml*.

<a id="export_ext.pdf_engine"></a>
## `export_ext.pdf_engine`

PDF engine to instruct Pandoc to use.

Default is `'typst'`
