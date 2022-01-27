--- === WindowSnap ===
---
--- Adds a hotkeys to position the active window in the position of the 1-9 number pad.
--- Default modifiers: {“ctrl”, “alt”, “cmd”}
---
--- 7   8   9
--- 4   5   6
--- 1   2   3
---
--- Also, use `-` and `=` to move the active window between screens
---
--- Download: [https://github.com/0xbrock/WindowSnap/releases](https://github.com/0xbrock/WindowSnap/releases)

local log=hs.logger.new(‘WindowSnap’,‘verbose’)
local numpadkeys = {[‘1’] = true,[‘2’] = true,[‘3’] = true,[‘4’] = true,[‘5’] = true,[‘6’] = true,[‘7’] = true,[‘8’] = true,[‘9’] = true,[‘0’] = true,[‘=’] = true,[‘/’] = true,[‘*’] = true,[‘-’] = true,[‘+’] = true}
local cardinals = {“NW”, “N”, “NE”, “W”, “C”, “E”, “SW”, “S”, “SE”}
local obj = {}
obj.__index = obj
obj.defaultHotkeys = {
  pwin    = { {“ctrl”, “alt”, “cmd”}, "-" },
  nwin    = { {“ctrl”, “alt”, “cmd”}, "=" },
  nw      = { {“ctrl”, “alt”, “cmd”}, "7" },
  n       = { {“ctrl”, “alt”, “cmd”}, "8" },
  ne      = { {“ctrl”, “alt”, “cmd”}, "9" },
  w       = { {“ctrl”, “alt”, “cmd”}, "4" },
  c       = { {“ctrl”, “alt”, “cmd”}, "5" },
  e       = { {“ctrl”, “alt”, “cmd”}, "6" },
  sw      = { {“ctrl”, “alt”, “cmd”}, "1" },
  s       = { {“ctrl”, “alt”, “cmd”}, "2" },
  se      = { {“ctrl”, “alt”, “cmd”}, "3" },
}
obj.hotkeyBindings = {}

-- Metadata
obj.name = "WindowSnap"
obj.version = "1.1"
obj.author = "0xbrock"
obj.homepage = "https://github.com/0xbrock/WindowSnap"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- WindowSnap:start()
--- Method
--- Bind default hotkeys
---
--- Parameters:
---  * None
function obj:start()
  self:bindHotkeys(self.defaultHotkeys)
  return self
end

--- WindowSnap:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowSnap
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:---  * reloadConfiguration - This will cause the configuration to be reloaded
function obj:bindHotkeys(mappings)
  self:deleteAllHotkeys(self.hotkeyBindings)

  self:bindNextScreen(mappings[“pwin”], 1)
  self:bindNextScreen(mappings[“nwin”], -1)
  
  for _,c in ipairs(cardinals) do
    self:bindWindowMove(mappings, c)
  end

  return self
end

function obj:bindHotkeyWithPad(mods, key, func)
  table.insert(self.hotkeyBindings, hs.hotkey.bind(mods, key, func))
  if numpadkeys[key] then
    log.f(‘Binding numpad: pad%s’,key)
    table.insert(self.hotkeyBindings, hs.hotkey.bind(mods, ‘pad’..key, func))
  end
end

function obj:deleteAllHotkeys(hkbindings)
  log.f(‘Deleting bindings’)
  if hkbindings then
    for _, hkbinding in ipairs(hkbindings) do
      if hkbinding then 
        hkbinding:delete() end
    end
  end
  self.hotkeyBindings = nil
  self.hotkeyBindings = {}
end

function obj:bindNextScreen(mapping, direction)
  self:bindHotkeyWithPad(mapping[1], mapping[2], function()
    local win = hs.window.focusedWindow()
    self:nextScreen(win, direction)
  end)
end

function obj:nextScreen(win, direction)
  local allScreens = hs.screen.allScreens()
  local nextIdx = 1
  local currentScreenIndex = GetScreenIndex(win, allScreens)
  if (direction == -1) then -- Left
    if (currentScreenIndex == 1) then
      nextIdx = tablelength(allScreens)
    else
      nextIdx = currentScreenIndex + direction
    end
  elseif (direction == 1) then -- Right
    if (currentScreenIndex == tablelength(allScreens)) then
      nextIdx = 1
    else
      nextIdx = currentScreenIndex + direction
    end
  end
  win:moveToScreen(allScreens[nextIdx])
end

local function GetScreenIndex(win, allScreens)
  local idx = 1
  for i,s in ipairs(allScreens) do
    if (s == win:screen()) then
      return idx
    end
    idx = idx + 1
  end
end

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function obj:bindWindowMove(mapping, location)
  self:bindHotkeyWithPad(mapping[string.lower(location)][1], mapping[string.lower(location)][2], function()
    local win = hs.window.frontmostWindow() or hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, location)
  end)
end

function obj:windowSnapMove(win, sf, location)
  local f = win:frame()

  if (location == “NW”) then
    f.x = sf.x
    f.y = sf.y
  elseif (location == “N”) then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y
  elseif (location == “NE”) then
    f.x = sf.x + sf.w - f.w 
    f.y = sf.y
  elseif (location == “W”) then
    f.x = sf.x
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == “C”) then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == “E”) then
    f.x = sf.x + sf.w - f.w 
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == “SW”) then
    f.x = sf.x 
    f.y = sf.y + sf.h - f.h
  elseif (location == “S”) then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y + sf.h - f.h
  elseif (location == “SE”) then
    f.x = sf.x + sf.w - f.w
    f.y = sf.y + sf.h - f.h
  end
  win:setFrame(f)
end

return obj