-- locals and speed
local AddonName, Addon = ...;

local select = select;

local CreateFrame = CreateFrame;
local GetCVar = GetCVar;
local GetNetStats = GetNetStats;

local currentTolerance = GetCVar('maxSpellStartRecoveryOffset');
local lastUpdateTime = 0;

-- main
function Addon:Load()
  do
    local eventHandler = CreateFrame('Frame', nil);

    -- set OnEvent handler
    eventHandler:SetScript('OnEvent', function(handler, ...)
        self:OnEvent(...);
      end)

    -- set OnUpdate handler
    eventHandler:SetScript('OnUpdate', function(handler, ...)
        self:OnUpdate(...);
      end)

    eventHandler:RegisterEvent('PLAYER_LOGIN');
  end
end

-- frame events
function Addon:OnEvent(event, ...)
  local action = self[event];

  if (action) then
    action(self, event, ...);
  end
end

function Addon:OnUpdate(elapsed)
  lastUpdateTime = lastUpdateTime + elapsed;

  -- limit update to once per second
  if (lastUpdateTime < 1) then return end
  lastUpdateTime = 0;

  -- get world latency
  local newTolerance = select(4, GetNetStats());

  -- ignore empty value and prevent update spam
  if (newTolerance == 0 or newTolerance == currentTolerance) then return end
  currentTolerance = newTolerance;

  -- set lag tolerance
  SetCVar('maxSpellStartRecoveryOffset', newTolerance);
end

function Addon:PLAYER_LOGIN()
  -- set up alias reload slash command
  SLASH_RL1 = '/rl';
  function SlashCmdList.RL(msg, editbox)
    ReloadUI();
  end

  -- set status text
  SetCVar('statusText', '0');

  -- ensure key press on key down
  SetCVar('ActionButtonUseKeyDown', '1');

  -- enable taint logging
  SetCVar('taintLog', '1'); -- 2

  -- disable secure ability toggle
  SetCVar('secureAbilityToggle', 0);

  -- enable Custom Lag Tolerance (0-400 ms)
  SetCVar('reducedLagTolerance', 1);
  -- with a value of 50
  SetCVar('maxSpellStartRecoveryOffset', 50);

  -- enable LUA errors
  SetCVar('scriptErrors', 1);
end

-- call
Addon:Load();
