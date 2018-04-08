local AddonName, Addon = ...

local hooksecurefunc = hooksecurefunc

local select = select

local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetNetStats = GetNetStats

local UPDATE_INTERVAL = 3.0

function Addon:Load()
  do
    local eventHandler = CreateFrame("Frame", nil)

    eventHandler:SetScript("OnEvent", function(handler, ...)
        self:OnEvent(...)
      end)

    eventHandler:SetScript("OnUpdate", function(handler, ...)
        self:OnUpdate(...)
      end)

    eventHandler:RegisterEvent("PLAYER_LOGIN")
    eventHandler:RegisterEvent("TALKINGHEAD_REQUESTED")

    self.eventHandler = eventHandler

    self.tolerance = GetCVar("spellQueueWindow") or 0
    self.lastUpdate = 0
  end
end

function Addon:OnEvent(event, ...)
  local action = self[event]

  if (action) then
    action(self, event, ...)
  end
end

do
  local function Minimap_OnMouseWheel(frame, delta)
    Addon:MinimapOnMouseWheel(frame, delta)
  end

  function Addon:HookActionEvents()
    Minimap:SetScript("OnMouseWheel", Minimap_OnMouseWheel)
  end
end

function Addon:MinimapOnMouseWheel(frame, delta)
  if (delta > 0) then
    Minimap_ZoomIn()
  else
    Minimap_ZoomOut()
  end
end

function Addon:OnUpdate(elapsed)
  self.lastUpdate = self.lastUpdate + elapsed

  -- limit update to once per second
  if (self.lastUpdate < UPDATE_INTERVAL) then
    return
  end

  -- get world latency
  local newTolerance = select(4, GetNetStats())

  -- ignore empty value and prevent update spam
  if (newTolerance == 0 or newTolerance == self.tolerance) then
    return
  end

  -- set lag tolerance
  SetCVar("spellQueueWindow", newTolerance)

  self.tolerance = newTolerance
  self.lastUpdate = 0
end

function Addon:PLAYER_LOGIN()
  self:HookActionEvents()

  -- set up alias reload slash command
  SLASH_RL1 = "/rl"
  function SlashCmdList.RL(msg, editbox)
    ReloadUI()
  end

  -- set status text
  SetCVar("statusText", 0)

  -- ensure key press on key down
  SetCVar("ActionButtonUseKeyDown", 1)

  -- enable taint logging
  SetCVar("taintLog", 1) -- 2

  -- disable secure ability toggle
  SetCVar("secureAbilityToggle", 0)

  -- set lag tolerance (0-400 ms)
  SetCVar("spellQueueWindow", 50)

  -- enable LUA errors
  SetCVar("scriptErrors", 1)

  -- disable click-to-move
  SetCVar("autoInteract", 0)

  -- set console key
  SetConsoleKey("F12")

  -- enable mouse wheel over minimap
  Minimap:EnableMouseWheel(true)

  -- hide the minimap zoom buttons
  MinimapZoomIn:Hide()
  MinimapZoomOut:Hide()

  -- move the minimap tracking icon
  MiniMapTracking:ClearAllPoints()
  MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)

  self.eventHandler:UnregisterEvent("PLAYER_LOGIN")
end

function Addon:TALKINGHEAD_REQUESTED()
  local frame = TalkingHeadFrame

  local displayInfo, cameraID, vo, duration, lineNumber, numLines, name, text, isNewTalkingHead = C_TalkingHead.GetCurrentLineInfo()
  if displayInfo and displayInfo ~= 0 then
    frame.Show = function()
      return
    end

    frame:Hide()
  end
end

-- call
Addon:Load()
