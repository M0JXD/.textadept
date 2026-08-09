# Theme manager for Textadept

Theme manager for Textadept

To truly change themes with the system in Textadept
[is a bit complicated if you don't want to override the default theme files][1].

Theme manager is a module for setting themes that switch with the system in the GUI version,
and carefully applies theme aspects depending on system limitations.

If a font is missing, it will opt to use Textadept's default font instead of the OS default font.

When changing themes, it resets styles to avoid spurious behaviours like line backgrounds
persisting on themes that don't have them.

Since 12.7, Textadept supports arbitrary RGB colours in the terminal version, which means many
GUI themes also work in terminals with true-colour support. The module detects if the current
terminal is capable to otherwise fallback to the default theme.

If using the GTK2 build, it attempts to detect if the system GTK theme is a dark one so it can
apply your chosen dark theme. There is no mode changed support for GTK2
(I don't think any GTK2 DEs had such capability anyway).
NB: The check relies on `textadept-gtk` being in your `PATH`.

I've added [@kbarni's theme selector][2] too just for fun!

By default, Theme Manager uses Textadept's default themes and settings.
Theme manager allows for per lexer theming, including separate light and dark themes.

Example usage:

```lua
local theme_mgr = require('theme_mgr')
theme_mgr.theme.light = 'xed-light'
theme_mgr.theme.dark = 'ayu-evolve'
theme_mgr.theme.term = 'catppuccin-latte'
theme_mgr.font.family = 'Comic Sans MS'
theme_mgr() -- Call the module if you need themes set before events.INITIALIZED
```

[1]: https://github.com/orbitalquark/textadept/issues/602#issuecomment-2758753214
[2]: https://github.com/orbitalquark/textadept/pull/690#issue-3996335774


<a id="theme_mgr.font"></a>
## `theme_mgr.font`

Table of font properties to use.

Fields:
- `family`:  The font to use. Default value is the same as Textadept's default for each OS.
- `size`:  The font size to use. Default value is `12`.

<a id="theme_mgr.select_theme"></a>
## `theme_mgr.select_theme`(*mode*)

Theme selector adapted from @kbarni
Lists themes to user and allows them to select what to apply.

Parameters:
- *mode*:  Whether theme should be applied to light or dark mode.

<a id="theme_mgr.theme"></a>
## `theme_mgr.theme`

Map of lexers with the themes to use for them, or light/dark/term if not.

Fields:
- `light`:  Which light theme to use when there's no specified lexer theme. Default value is `'light'`.
- `dark`:  Which dark theme to use when there's no specified lexer theme. Default value is `'dark'`.
- `term`:  Which terminal theme to use when there's no specified lexer theme. Default value is `'term'`.

Usage:

```lua
theme_mgr.theme.python = 'xed-dark' -- Set a lexer specific theme
theme_mgr.theme.markdown = {'ayu-mirage', 'catppuccin-macchiato'} -- Light then dark lexer themes
```

<a id="theme_mgr.theme_all_views"></a>
## `theme_mgr.theme_all_views`(*view_reset*)

Applies theme to all views.

Parameters:
- *view_reset*:  Whether to reset each view before applying the theme.

<a id="theme_mgr.theme_command_entry"></a>
## `theme_mgr.theme_command_entry`()

Applies theme to command entry.

<a id="theme_mgr.theme_view"></a>
## `theme_mgr.theme_view`(*view_reset*, *view*)

Apply selected themes to a view.

Parameters:
- *view_reset*:  Whether to reset the view before theming it.
- *view*:  View to theme.
