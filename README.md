# WindowSnap Spoon

Hammerspoon module spoon to facilitate more efficient window positioning from the keyboard.

Adds a hotkeys to position the active window in the position of the 1-9 number pad.

Default modifiers: {"ctrl", "alt", "cmd"}

```
7   8   9
4   5   6
1   2   3
```
Also, use `-` and `=` to move the active window between screens

## Setup

After installing the spoon.  Add the following to the `.hammerspoon/init.lua` script.
```
hs.loadSpoon("WindowSnap")
spoon.WindowSnap:start()
```

Alternatively you can bind customized hotkeys via:
```
spoon.WindowSnap:bindHotkeys(spoon.WindowSnap.defaultHotkeys)
```

## Customize Hotkeys

The hotkeys can be customized based on the following:

```{
  pwin    = { {"ctrl", "alt", "cmd"}, "-" },
  nwin    = { {"ctrl", "alt", "cmd"}, "=" },
  nw      = { {"ctrl", "alt", "cmd"}, "7" },
  n       = { {"ctrl", "alt", "cmd"}, "8" },
  ne      = { {"ctrl", "alt", "cmd"}, "9" },
  w       = { {"ctrl", "alt", "cmd"}, "4" },
  c       = { {"ctrl", "alt", "cmd"}, "5" },
  e       = { {"ctrl", "alt", "cmd"}, "6" },
  sw      = { {"ctrl", "alt", "cmd"}, "1" },
  s       = { {"ctrl", "alt", "cmd"}, "2" },
  se      = { {"ctrl", "alt", "cmd"}, "3" },
}
```