# My (M0JXD's) ~/.textadept/

My Textadept setup. It's mainly here so I can grab it wherever I need it, but anyone is welcome to use.
There is:

- My *init.lua*.
- Various utility modules.
- Ayu, Catppuccin and Xed themes.
- Some Lexers for Typst, GTK Blueprint and Markdown.
- Scripts to generate module documentation and run system integration steps.

## Modules

All of the modules have LDoc comments, which work well with Textadept's LSP module.

| Module                     | Description                                                                             |
| :------------------------- | :-------------------------------------------------------------------------------------- |
| Buffer Statusbar Utilities | String manipulation utilities to make adjusting the Buffer Statusbar easier.            |
| Distraction Free           | Updated Distraction Free Mode with additional features and terminal support.            |
| Document Statistics        | Provides details about the buffer such as word count, selected lines et cetera.         |
| Export Extensions          | Extends the official export module to convert markup languages via Pandoc.              |
| Quick Open                 | Based on "Open Terminal Here", adding options to open File Browser and TUI Git Clients. |
| Theme Manager              | Set up switched and per lexer themes, and detects missing features (e.g. fonts).        |

## Scripts

I usually install Textadept to *~/Applications/textadept/* on POSIX systems. 
The script *integrate_posix_xdg.lua* puts startup scripts, desktop files and icons under the user's *~/.local* directory based on this install location.

The script *generate_docs.lua* generates the *README.md* for each module in this repo from its LDoc,
using [the Markdown filter from Textadept's own documentation.](https://github.com/orbitalquark/textadept/blob/default/scripts/markdowndoc.lua)

## Themes

These themes are made to match official specifications from the theme designers better than the base16 ones, and are also compatible with the terminal version.

- Ayu Light, Mirage, Dark and Evolve (Evolve is an even darker theme, like the one in Helix).
- Catppuccin Latte, Frappé, Macchiato and Mocha.
- Xed Light and Dark to match Linux Mint's default editor.

## Lexers

Some additional information about the lexers...

- Typst: See [Scintillua PR](https://github.com/orbitalquark/scintillua/pull/217).
- GTK Blueprint: I don't intend to merge this upstream.
    It was knocked together in 10 mins when I was experimenting with GTK4 for [axeiiloader](https://github.com/M0JXD/axeiiloader), so it's very incomplete.
    I might finish it one day if I ever need to use GTK4. Maybe.
- Markdown: Add's tagging for `$ - $` ranges as I'm using [mdbook-typst-math](https://duskmoon314.github.io/mdbook-typst-math/) for a project.
