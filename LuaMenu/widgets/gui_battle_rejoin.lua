--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:GetInfo()
	return {
		name      = "Battle Rejoin",
		desc      = "Prompts the user to rejoin a previous battle on login.",
		author    = "Rogshotz",
		date      = "13 July 2025",
		license   = "GNU LGPL, v2.1 or later",
		layer     = 0,
		enabled   = true
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--42616
local function DelayedInitialize()
	local lobby = WG.LibLobby.lobby

	Spring.Echo("Saved BattleID:")
	Spring.Echo(WG.Chobby.Configuration.rejoinID)

	local function LoginRejoinOption(listener, battleID)
		-- if no ID is present then there is no server to rejoin
		if not WG.Chobby.Configuration.rejoinID then
			return
		end

		local function RejoinBattleFunc()
			Spring.Echo('Rejoining Lobby ID:')
			Spring.Echo(WG.Chobby.Configuration.rejoinID)
			lobby:RejoinBattle(WG.Chobby.Configuration.rejoinID)
		end

		WG.Chobby.ConfirmationPopup(RejoinBattleFunc, "During the last launch you were still in a game that is still ongoing, would you like to reconnect?", nil, 315, 200, "rejoin", "abandon")
	end

	local function OnBattleStartMultiplayer(listener, battleID)
		Spring.Echo('Saving Lobby ID:')
		local lobbyID = lobby:GetMyBattleID()
		Spring.Echo(lobbyID)
		WG.Chobby.Configuration:SetConfigValue("rejoinID", lobbyID)
		Spring.Echo(WG.Chobby.Configuration.rejoinID)
	end

	lobby:AddListener("OnLoginInfoEnd", LoginRejoinOption)
	lobby:AddListener("OnBattleAboutToStart", OnBattleStartMultiplayer)
end

function widget:Initialize()
	CHOBBY_DIR = LUA_DIRNAME .. "widgets/chobby/"
	VFS.Include(LUA_DIRNAME .. "widgets/chobby/headers/exports.lua", nil, VFS.RAW_FIRST)
	WG.Delay(DelayedInitialize, 1)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
