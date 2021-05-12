surface.CreateFont("SVModFont", {
	font = "Arial",
	size = 30
})

hook.Add("PostDrawTranslucentRenderables", "SV_WrenchHUD", function()
	local veh = SVMOD.VehicleRenderedParts
	if not SVMOD:IsVehicle(veh) then return end

	if not veh.SV_Data.Parts then return end

	for _, p in ipairs(veh.SV_Data.Parts) do
		local health = 0
		if p.GetHealth then
			health = p:GetHealth()
		end

		if not p.StartLerp or not p.LastLerp then
			p.LastLerp = health
			p.StartLerp = SysTime()
		end

		if SysTime() < p.StartLerp or SysTime() - p.StartLerp > 0.05 then
			p.StartLerp = SysTime()
		end

		p.LastLerp = Lerp(SysTime() - p.StartLerp, p.LastLerp, health)

		local Colour = Color(255, 255, 0)
		if p.LastLerp > 50 then
			Colour.r = math.floor(255 - (p.LastLerp * 2 - 100) * 255 / 100)
		else
			Colour.g = math.floor((p.LastLerp * 2) * 255 / 100)
		end

		cam.Start3D2D(veh:LocalToWorld(p.Position), SVMOD:RotateAroundAxis(veh:GetAngles(), p.Angles), 0.05)
			draw.RoundedBox(20, 0, 0, 350, 40, ColorAlpha(Colour, 100))
			if p.LastLerp > 0 then
				draw.RoundedBox(20, 0, 0, 350 * p.LastLerp / 100, 40, Colour)
			end
			draw.DrawText(math.Round(p.LastLerp) .. "%", "SVModFont", math.Clamp(350 * p.LastLerp / 100 - 5, 60, 350), 5, Color(0, 0, 0), TEXT_ALIGN_RIGHT)
		cam.End3D2D()
	end
end)