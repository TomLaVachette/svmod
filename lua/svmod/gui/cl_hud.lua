surface.CreateFont('HudHintTextLarge40', {
	font = 'HudHintTextLarge',
	size = 40
})

surface.CreateFont('HudHintTextLarge25', {
	font = 'HudHintTextLarge',
	size = 25
})

-- hook.Add("SV_PlayerEnteredVehicle", "SV_EnableHUD", function(ply, veh)
--	 hook.Add("HUDPaint", "SV_HUDPaint", function()
--		 local Vehicle = LocalPlayer():GetVehicle()
--		 if not SVMOD:IsVehicle(Vehicle) then return end

--		 local Width, Height = 250, 80

--		 local Speed = Vehicle:SV_GetCachedSpeed()
--		 local PercentSpeed = Speed / 150

--		 surface.SetDrawColor(0, 0, 0, 200)
--		 surface.DrawRect(ScrW() / 2 - Width / 2, ScrH() - Height, Width, Height)

--		 surface.SetDrawColor(0, 93, 255, 25)
--		 surface.DrawRect(ScrW() / 2 - Width / 2, ScrH() - Height, Width * PercentSpeed, Height)

--		 draw.DrawText(Speed .. " km/h", "HudHintTextLarge40", ScrW() / 2, ScrH() - Height * 0.75, Color(255, 255, 255), TEXT_ALIGN_CENTER)

--		 surface.SetDrawColor(0, 93, 255)
--		 surface.DrawRect(ScrW() / 2 - Width / 2, ScrH() - Height - 2, Width * Vehicle:SV_GetPercentFuel() / 100, 2)
--	 end)
-- end)

-- hook.Add("SV_PlayerLeaveVehicle", "SV_DisableHUD", function()
--	 hook.Remove("HUDPaint", "SV_HUDPaint")
-- end)