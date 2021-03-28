hook.Add("SV_PlayerEnteredVehicle", "SV_StartShortcutsThink", function(_, veh)
	local LastShortcut
	hook.Add("Think", "SV_DetectShortcuts", function()
		-- Return if menu open
		if vgui.CursorVisible() then return end

		-- Return if not driver seat
		local veh = LocalPlayer():GetVehicle()
		if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

		if LastShortcut and not (input.IsKeyDown(LastShortcut.Key) or input.IsMouseDown(LastShortcut.Key)) then
			if LastShortcut.ReleasedFunction then
				LastShortcut.ReleasedFunction(veh)

				if not LastShortcut.BypassTimer then
					SVMOD.ShortcutTime = CurTime() + SVMOD.FCFG.ShortcutTime
				end
			end

			LastShortcut = nil
		end

		-- Return if shortcut in cooldown
		if CurTime() < SVMOD.ShortcutTime then
			return
		end

		for _, s in ipairs(SVMOD.Shortcuts) do
			if (input.IsKeyDown(s.Key) or input.IsMouseDown(s.Key)) and (not LastShortcut or s.Key ~= LastShortcut.Key) then
				if s.PressedFunction then
					s.PressedFunction(veh)

					if not s.BypassTimer then
						SVMOD.ShortcutTime = CurTime() + SVMOD.FCFG.ShortcutTime
					end
				end

				LastShortcut = s

				break
			end
		end
	end)
end)

hook.Add("SV_PlayerLeaveVehicle", "SV_StopShortcutsThink", function()
	hook.Remove("Think", "SV_DetectShortcuts")
end)