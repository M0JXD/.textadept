# My (M0JXD's) ~/.textadept/

My collection of things I use/modified for Textadept.
They're mainly here so I can grab them wherever I need them, but anyone is welcome to use. There's:

- My *init.lua*.
- Various simple utility modules.
- A couple of scripts to generate module documentation and run system integration steps.
- Themes that match specifications better than the base16 ones, and include fixes to adapt to to the terminal version:
    - Ayu Light, Mirage, Dark and Evolve (Evolve is Dark with near black background, like the Helix theme).
    - Catppuccin Latte, Frappé, Macchiato and Mocha.
    - Xed Light and Dark to match Linux Mint's default editor.

All of the modules I've made are have LDoc documentation. There is:

| Module Name                 | Description                                                                             |
| :-------------------------- | :-------------------------------------------------------------------------------------- |
| Buffer Statusbar Utilities  | String manipulation utilities to make adjusting the Buffer Statusbar easier.            |
| Distraction Free            | Updated Distraction Free Mode with additional features and terminal support.            |
| Document Statistics         | Provides details about the buffer such as word count, selected lines et cetera.         |
| Export Extensions           | Extends the official export module to convert Markdown and LaTeX to PDF and HTML.       |
| Quick Open                  | Based on "Open Terminal Here", adding options to open File Browser and TUI Git Clients. |
| Theme Manager               | Set up switched and per lexer themes, and detects missing features (e.g. fonts).        |

I usually install Textadept to *~/Applications/textadept/* on POSIX systems.
The script *integrate_posix_xdg.lua* sets up PATH extensions, aliases, desktop files and icons based on this install location.
