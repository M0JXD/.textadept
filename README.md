# My (M0JXD's) ~/.textadept/

My collection of things I use/modified for Textadept.
They're mainly here so I can grab them wherever I need them, but anyone is welcome to use. There's:

- My init.lua
- Various simple utility modules
- Themes that match specifications better than the base16 ones, and include fixes to adapt to to the terminal version:
    - Ayu Light, Mirage, Dark and Evolve (Evolve is Dark with near black background, like the Helix theme).
    - Catppuccin Latte, Frappé, Macchiato and Mocha.
    - Xed Light and Dark to match Linux Mint's default editor.

All of the modules I've made are have LDoc documentation that works with Textadept's LSP
and is used to generate the README's. There is:

| Module Name                 | Description                                                                                          |
| :-------------------------- | :--------------------------------------------------------------------------------------------------- |
| Buffer Statusbar Utilities  | String manipulation utilities to make adjusting the Buffer Statusbar easier                          |
| Distraction Free            | Updated Distraction Free mode supporting the terminal and taking advantage of new Textadept features |
| Document Statistics         | Gives details about the buffer such as word count, selected lines etc.                               |
| Export Extensions           | Extends the official export module with options to convert Markdown and LaTeX to PDF and HTML        |
| Quick Open                  | Based on "Open Terminal Here", but also allows opening File Browser and TUI Git Clients              |
| Theme Manager               | Sets up switched themes and detects missing features (e.g. fonts) to gracefully fallback to defaults |

I usually install Textadept to *~/Applications/textadept/*, I always forget my desktop integration steps so:

- Copy desktop files to *~.local/share/applications/* and SVG icons in *~/.local/share/icons/hicolor/scalable/apps/*.
- Add this into *.profile*, *.bashrc* and *.bash_profile*:

```bash
export PATH=$HOME/Applications/textadept:$PATH
alias ta="textadept-curses"
alias ta-gtk="textadept-gtk"
alias ta-qt="textadept"
```
