# Textadept Quick Open

Quickly open a terminal, file explorer or git client at the current buffer's file path.

It's based on <https://github.com/orbitalquark/textadept/wiki/TerminalHere>.

I don't have any Apple devices so have not implemented for macOS.
If setting a custom terminal, as the directory argument may of the form `--working-directory=`
you might need to add the trailing whitespace.

Only for GUI Textadept, returns an empty table if used in the terminal version.

<a id="quick_open.bindings"></a>
## `quick_open.bindings`

Bindings to use to launch applications at current path.

Fields:
- `terminal`: Binding to launch Terminal. Default value is `'ctrl+T'`.
- `explorer`: Binding to launch File Explorer. Default value is `'ctrl+E'`.
- `git_client`: Binding to launch Git Client. Default value is `'ctrl+G'`.

Usage:

```lua
quick_open.bindings.terminal = 'alt+T'
```

<a id="quick_open.explorer"></a>
## `quick_open.explorer`

Command to open a file explorer.

Default value is `'explorer.exe'` on Windows and `'xdg-open'` on Linux/BSD.

Usage:

```lua
quick_open.explorer = 'nautilus'
```

<a id="quick_open.git_client"></a>
## `quick_open.git_client`

Git client to open.

Default value is `'lazygit'`.

Usage:

```lua
quick_open.git_client = 'gitui'
```

<a id="quick_open.openFileBrowserHere"></a>
## `quick_open.openFileBrowserHere`()

Open a file explorer at the current buffer's directory.

<a id="quick_open.openGitClientHere"></a>
## `quick_open.openGitClientHere`()

Open a git client at the current buffer's directory.

<a id="quick_open.openTerminalHere"></a>
## `quick_open.openTerminalHere`(*arg*)

Open a terminal at the current buffer's directory.

Parameters:
- *arg*: Command to pass to terminal emulator (used to open git client).

<a id="quick_open.term_dir_arg"></a>
## `quick_open.term_dir_arg`

Argument to pass a starting directory to the terminal emulator.

The module attempts to detect what is correct for your OS/Desktop.

Usage:

```lua
quick_open.term_dir_arg = '--workdir ' -- Trailing space might be needed
```

<a id="quick_open.term_max_arg"></a>
## `quick_open.term_max_arg`

Argument to maximise the terminal emulator.

The module attempts to detect what is correct for your OS/Desktop.

Usage:

```lua
quick_open.term_max_arg = '--fullscreen'
```

<a id="quick_open.terminal"></a>
## `quick_open.terminal`

Terminal emulator to open.

The module attempts to detect what is correct for your OS/Desktop.

Usage:

```lua
quick_open.terminal = 'cool-retro-term'
```
