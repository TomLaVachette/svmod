surface.CreateFont("SVModFont", {
	font = "Arial",
	size = 30
})

hook.Add("PostDrawTranslucentRenderables", "SV_WrenchHUD", function()
	local Vehicle = SVMOD.VehicleRenderedParts
	if not SVMOD:IsVehicle(Vehicle) then return end

	if not Vehicle.SV_Data.Parts then return end

	for _, p in ipairs(Vehicle.SV_Data.Parts) do
		if p.Health then
			if not p.StartLerp or not p.LastLerp then
				p.LastLerp = p.Health
				p.StartLerp = SysTime()
			end

			if SysTime() < p.StartLerp or SysTime() - p.StartLerp > 0.05 then
				p.StartLerp = SysTime()
			end

			p.LastLerp = Lerp(SysTime() - p.StartLerp, p.LastLerp, p.Health)

			local Colour = Color(255, 255, 0)
			if p.LastLerp > 50 then
				Colour.r = math.floor(255 - (p.LastLerp * 2 - 100) * 255 / 100)
			else
				Colour.g = math.floor((p.LastLerp*2) * 255 / 100)
			end

			cam.Start3D2D(Vehicle:LocalToWorld(p.Position), SVMOD:RotateAroundAxis(Vehicle:GetAngles(), p.Angle), 0.05)
				draw.RoundedBox(20, 0, 0, 350, 40, ColorAlpha(Colour, 100))
				if p.LastLerp > 0 then
					draw.RoundedBox(20, 0, 0, 350 * p.LastLerp/100, 40, Colour)
				end
				draw.DrawText(math.Round(p.LastLerp) .. "%", "SVModFont", math.Clamp(350 * p.LastLerp/100 - 5, 60, 350), 5, Color(0, 0, 0), TEXT_ALIGN_RIGHT)
			cam.End3D2D()
		end
	end
end)

net.Receive("SV_Parts", function()
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	local Count = net.ReadUInt(4)

	for i = 1, math.min(Count, #Vehicle.SV_Data.Parts) do
		Vehicle.SV_Data.Parts[i].Health = net.ReadUInt(7)
	end
end)