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
			local currFlashing = veh:SV_GetFlashingLightsState()
			local currSiren = veh:SV_GetSirenState()
			local hasSiren = veh.SV_Data.Sounds.Siren and #veh.SV_Data.Sounds.Siren > 0
			local separated = SVMOD.CFG.Lights.SeparateFlashingLights

			-- Cycle : Off -> Flashing only -> Flashing + Siren -> Off
			if separated then
				-- Off -> Flashing only
				if not currFlashing and not currSiren then
					SVMOD:SetFlashingLightsState(true, false)

				-- Flashing only -> Flashing + Siren
				elseif currFlashing and not currSiren and hasSiren then
					SVMOD:SetFlashingLightsState(true, true)

				-- Flashing + Siren -> Off
				else
					SVMOD:SetFlashingLightsState(false, false)
				end

				return
			end

			-- Cycle : Off -> (Flashing + Siren) -> Off
			if not currFlashing and not currSiren then
				-- turn everything on
				SVMOD:SetFlashingLightsState(true, hasSiren)
			else
				-- turn everything off
				SVMOD:SetFlashingLightsState(false, false)
			end
		end
	}
}