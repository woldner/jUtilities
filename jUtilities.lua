-- locals and speed
local AddonName, Addon = ...;

-- main
function Addon:Load()
  do
    local eventHandler = CreateFrame('Frame', nil);

    -- set OnEvent handler
    eventHandler:SetScript('OnEvent', function(handler, ...)
        self:OnEvent(...);
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
end

-- call
Addon:Load();
