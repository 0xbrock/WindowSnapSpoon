--- === WindowSnap ===
---
--- Adds a hotkeys to position the active window in the position of the 1-9 number pad.
--- Default modifiers: {"ctrl", "alt", "cmd"}
---
--- 7   8   9
--- 4   5   6
--- 1   2   3
---
--- Also, use `-` and `=` to move the active window between screens
---
--- Download: [https://github.com/0xbrock/WindowSnap/releases](https://github.com/0xbrock/WindowSnap/releases)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowSnap"
obj.version = "1.0"
obj.author = "0xbrock"
obj.homepage = "https://github.com/0xbrock/WindowSnap"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.defaultHotkeys = {
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


obj.hkpwin = nil
obj.hknwin = nil
obj.hknw = nil
obj.hkn = nil
obj.hkne = nil
obj.hkw = nil
obj.hkc = nil
obj.hke = nil
obj.hksw = nil
obj.hks = nil
obj.hkse = nil

--- WindowSnap:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowSnap
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:---  * reloadConfiguration - This will cause the configuration to be reloaded
function obj:bindHotkeys(mapping)
  if (self.hkpwin) then self.hkpwin:delete() end
  if (self.hknwin) then self.hknwin:delete() end
  if (self.hknw) then self.hknw:delete() end
  if (self.hkn) then self.hkn:delete() end
  if (self.hkne) then self.hkne:delete() end
  if (self.hkw) then self.hkw:delete() end
  if (self.hkc) then self.hkc:delete() end
  if (self.hke) then self.hke:delete() end
  if (self.hksw) then self.hksw:delete() end
  if (self.hks) then self.hks:delete() end
  if (self.hkse) then self.hkse:delete() end

  local mods = mapping["pwin"][1]
  local key = mapping["pwin"][2]
  self.hkpwin = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    self:nextScreen(win, 1)
  end)
  
  mods = mapping["nwin"][1]
  key = mapping["nwin"][2]
  self.hknwin = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    self:nextScreen(win, -1)
  end)
  
  mods = mapping["nw"][1]
  key = mapping["nw"][2]
  self.hknw = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "NW")
  end)
    
  mods = mapping["n"][1]
  key = mapping["n"][2]
  self.hkn = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "N")
  end)
    
  mods = mapping["ne"][1]
  key = mapping["ne"][2]
  self.hkne = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "NE")
  end)
    
  mods = mapping["w"][1]
  key = mapping["w"][2]
  self.hkw = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "W")
  end)
  
  mods = mapping["c"][1]
  key = mapping["c"][2]
  self.hkc = hs.hotkey.bind(mods, key, function()
    local win = hs.window.frontmostWindow() or hs.window.focusedWindow()
    local screen = win:screen()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "C")
  end)

  mods = mapping["e"][1]
  key = mapping["e"][2]
  self.hke = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "E")
  end)
    
  mods = mapping["sw"][1]
  key = mapping["sw"][2]
  self.hksw = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "SW")
  end)
    
  mods = mapping["s"][1]
  key = mapping["s"][2]
  self.hks = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "S")
  end)
    
  mods = mapping["se"][1]
  key = mapping["se"][2]
  self.hkse = hs.hotkey.bind(mods, key, function()
    local win = hs.window.focusedWindow()
    local sf = win:screen():frame()
    self:windowSnapMove(win, sf, "SE")
  end)

  return self
end

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
  
function obj:windowSnapMove(win, sf, location)
  local f = win:frame()

  if (location == "NW") then
    f.x = sf.x
    f.y = sf.y
  elseif (location == "N") then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y
  elseif (location == "NE") then
    f.x = sf.x + sf.w - f.w 
    f.y = sf.y
  elseif (location == "W") then
    f.x = sf.x
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == "C") then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == "E") then
    f.x = sf.x + sf.w - f.w 
    f.y = sf.y + (sf.h/2) - (f.h/2)
  elseif (location == "SW") then
    f.x = sf.x 
    f.y = sf.y + sf.h - f.h
  elseif (location == "S") then
    f.x = sf.x + (sf.w/2) - (f.w/2)
    f.y = sf.y + sf.h - f.h
  elseif (location == "SE") then
    f.x = sf.x + sf.w - f.w
    f.y = sf.y + sf.h - f.h
  end
  win:setFrame(f)
end
  

return obj
