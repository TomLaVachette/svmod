SVMOD.Shortcuts = {
	{
		Name = "svmod.shortcuts.honking",
		DefaultKey = KEY_R,
		Key = KEY_R,
		BypassTimer = true,
		PressedFunction = function(veh)
			SVMOD:SetHornState(true)
		end,
		ReleasedFunction = function(veh)
			SVMOD:SetHornState(false)
		end
	},
	{
		Name = "svmod.shortcuts.lock",
		DefaultKey = KEY_LALT,
		Key = KEY_LALT,
		ReleasedFunction = function(veh)
			if SVMOD.SV_PlayerKickedFromSeat then
				SVMOD.SV_PlayerKickedFromSeat = nil
			else
				SVMOD:SwitchLockState()
			end
		end
	},
	{
		Name = "svmod.shortcuts.headlights",
		DefaultKey = KEY_F,
		Key = KEY_F,
		PressedFunction = function(veh)
			if veh:SV_GetHeadlightsState() then
				SVMOD:SetHeadlightsState(false)
			else
				SVMOD:SetHeadlightsState(true)
			end
		end
	},
	{
		Name = "svmod.shortcuts.left_blinkers",
		DefaultKey = MOUSE_LEFT,
		Key = MOUSE_LEFT,
		PressedFunction = function(veh)
			if veh:SV_GetLeftBlinkerState() then
				SVMOD:SetLeftBlinkerState(false)
			else
				SVMOD:SetLeftBlinkerState(true)
			end
		end
	},
	{
		Name = "svmod.shortcuts.right_blinkers",
		DefaultKey = MOUSE_RIGHT,
		Key = MOUSE_RIGHT,
		PressedFunction = function(veh)
			if veh:SV_GetRightBlinkerState() then
				SVMOD:SetRightBlinkerState(false)
			else
				SVMOD:SetRightBlinkerState(true)
			end
		end
	},
	{
		Name = "svmod.shortcuts.hazard",
		DefaultKey = KEY_COMMA,
		Key = KEY_COMMA,
		PressedFunction = function(veh)
			if veh:SV_GetHazardLightsState() then
				SVMOD:SetHazardLightsState(false)
			else
				SVMOD:SetHazardLightsState(true)
			end
		end
	},
	{
		Name = "svmod.shortcuts.flashing",
		DefaultKey = KEY_LSHIFT,
		Key = KEY_LSHIFT,
		PressedFunction = function(veh)
			if veh:SV_GetFlashingLightsState() then
				SVMOD:SetFlashingLightsState(false)
			else
				SVMOD:SetFlashingLightsState(true)
			end
		end
	}
}