-- @class SV_Vehicle
-- @clientside

net.Receive("SV_SetFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_Fuel = net.ReadFloat()
	end
end)

net.Receive("SV_SetMaxFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_MaxFuel = net.ReadFloat()
	end
end)

net.Receive("SV_GetFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_Fuel = net.ReadFloat()
		Vehicle.SV_MaxFuel = net.ReadFloat()
	end
end)

-- Displays the interface to view a vehicle's fuel level.
function SVMOD.Metatable:SV_ShowFillingHUD()
	local lastLerp, startLerp

	hook.Add("PostDrawTranslucentRenderables", "SV_FillingHUD_" .. self:EntIndex(), function()
		if not SVMOD:IsVehicle(self) then
			hook.Remove("PostDrawTranslucentRenderables", "SV_FillingHUD_" .. self:EntIndex())
			return
		end

		local fuel = self:SV_GetFuel()
		local maxFuel = self:SV_GetMaxFuel()
		local percent = fuel / maxFuel

		if not startLerp or not lastLerp then
			lastLerp = percent
			startLerp = SysTime()
		end

		if SysTime() < startLerp or SysTime() - startLerp > 0.02 then
			startLerp = SysTime()
		end

		lastLerp = Lerp(SysTime() - startLerp, lastLerp, percent)

		local col = Color(255, 255, 0)
		if lastLerp > 0.5 then
			col.r = math.floor(255 - (lastLerp * 200 - 100) * 255 / 100)
		else
			col.g = math.floor((lastLerp * 200) * 255 / 100)
		end

		for _, v in ipairs(self.SV_Data.Fuel.GasTank) do
			local pos = self:LocalToWorld(v.GasHole.Position or Vector(0, 0, 0))
			local ang = SVMOD:RotateAroundAxis(self:GetAngles(), v.GasHole.Angles or Angle(0, 0, 0))

			cam.Start3D2D(pos, ang, 0.05)
				draw.RoundedBox(20, 0, 0, 70, 200, ColorAlpha(col, 100))
				if fuel > 0 then
					draw.RoundedBox(20, 0, 200 - (200 * lastLerp), 70, 200 * lastLerp, col)
				end
				draw.DrawText(math.Round(lastLerp * 100) .. "%", "SVModFont", 35, math.Clamp(200 - 200 * lastLerp, 5, 180), Color(0, 0, 0), TEXT_ALIGN_CENTER)
			cam.End3D2D()
			end
	end)
end

-- Hides the interface to view a vehicle's fuel level.
function SVMOD.Metatable:SV_HideFillingHUD()
	hook.Remove("PostDrawTranslucentRenderables", "SV_FillingHUD_" .. self:EntIndex())
end

net.Receive("SV_StartFilling", function()
	local veh = net.ReadEntity()

	if SVMOD:IsVehicle(veh) then
		-- veh.SV_FillingSound = CreateSound(veh, "svmod/fuel/fill-up.wav")
		-- veh.SV_FillingSound:Play()

		veh:SV_ShowFillingHUD()
	end
end)

net.Receive("SV_StopFilling", function()
	local veh = net.ReadEntity()

	if SVMOD:IsVehicle(veh) then
		-- veh.SV_FillingSound:Stop()

		veh:SV_HideFillingHUD()
	end
end)

net.Receive("SV_Settings_SetPriceFuelPump", function()
	local ent = net.ReadEntity()
	local value = net.ReadUInt(9) -- max: 511

	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 110)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(178, 95, 245)
		surface.DrawRect(0, 0, w, 4)
	end
	frame:MakePopup()

	local slide = SVMOD:CreateNumSlidePanel(frame, language.GetPhrase("svmod.fuel.price"), function(val)
		value = math.Round(val)
	end)
	slide:SetValue(value)
	slide:SetMaxValue(500)
	slide:SetUnit("u")

	local button = SVMOD:CreateButton(frame, language.GetPhrase("svmod.close"), function()
		frame:Close()

		net.Start("SV_Settings_SetPriceFuelPump")
		net.WriteEntity(ent)
		net.WriteUInt(value, 9) -- max: 511
		net.SendToServer()
	end)
	button:Dock(BOTTOM)
	button:SetSize(0, 30)
end)