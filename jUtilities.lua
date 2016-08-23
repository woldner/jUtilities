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

  -- enable taint logging
  SetCVar('taintLog', '1'); -- 2

  -- disable secure ability toggle
  SetCVar('secureAbilityToggle', 0);

  -- enable Custom Lag Tolerance (0-400 ms)
  SetCVar('reducedLagTolerance', 1);
  SetCVar('MaxSpellStartRecoveryOffset', 50);

  -- hide friendly/enemy player names/guild/titles
  SetCVar('UnitNameFriendlyPlayerName', 0);
  SetCVar('UnitNameEnemyPlayerName', 0);
  SetCVar('UnitNamePlayerPVPTitle', 0);
  SetCVar('UnitNamePlayerGuild', 0);
  SetCVar('UnitNameGuildTitle', 0);
end

-- call
Addon:Load();
