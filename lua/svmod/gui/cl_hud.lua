local circles = include("cl_circles.lua")

local fuelStationMaterial = Material("materials/vgui/svmod/fuel_station.png", "noclamp smooth")
local heartMaterial = Material("materials/vgui/svmod/heart.png", "noclamp smooth")

net.Receive("SV_HUDConfiguration", function()
	local isHUDEnabled = net.ReadBool()
	if isHUDEnabled then
		local ratioX = math.Round(net.ReadFloat(), 3)
		local ratioY = math.Round(net.ReadFloat(), 3)
		local radius = net.ReadUInt(9) -- max: 511
		local color = net.ReadColor()

		SVMOD:EnableHUD(ratioX, ratioY, radius, color)
	else
		SVMOD:DisableHUD()
	end
end)

function SVMOD:EnableHUD(ratioX, ratioY, radius, color)
	local function createDrawHook(veh)
		local maxSpeed = 200
		local positionX = ScrW() * ratioX
		local positionY = ScrH() * ratioY
		local scale = radius * (ScrW() / 1920)

		surface.CreateFont("SV_HUD40", {
			font = "Tahoma",
			size = scale * 0.7
		})

		surface.CreateFont("SV_HUD20", {
			font = "Tahoma",
			size = (scale * 0.7) / 2
		})

		local big_circle = circles.New(CIRCLE_OUTLINED, scale * 1.1, positionX, positionY, 2 * scale / 100)
		big_circle:SetMaterial(true)
		big_circle:SetColor(Color(59, 66, 74, 175))
		big_circle:SetAngles(140, 350)

		local speed_circle_background = circles.New(CIRCLE_OUTLINED, scale, positionX, positionY, 7 * scale / 100)
		speed_circle_background:SetMaterial(true)
		speed_circle_background:SetColor(Color(62, 61, 69, 175))
		speed_circle_background:SetAngles(135, 360)

		local speed_circle = circles.New(CIRCLE_OUTLINED, scale, positionX, positionY, 7 * scale / 100)
		speed_circle:SetMaterial(true)
		speed_circle:SetColor(color)
		speed_circle:SetAngles(135, 135)

		local fuel_circle_background = circles.New(CIRCLE_OUTLINED, scale / 3, positionX + scale * 0.9, positionY + scale * 0.5, 5 * scale / 100)
		fuel_circle_background:SetMaterial(true)
		fuel_circle_background:SetColor(Color(62, 61, 69, 175))
		fuel_circle_background:SetAngles(90, 360)
		fuel_circle_background:Rotate(45)
		fuel_circle_background:SetDistance(8)

		local fuel_circle = circles.New(CIRCLE_OUTLINED, scale / 3, positionX + scale * 0.9, positionY + scale * 0.5, 5 * scale / 100)
		fuel_circle:SetMaterial(true)
		fuel_circle:SetColor(color)
		fuel_circle:SetAngles(0, 270)
		fuel_circle:Rotate(135)
		fuel_circle:SetDistance(8)

		local health_circle_background = circles.New(CIRCLE_OUTLINED, scale / 3, positionX + scale * 1.7, positionY + scale * 0.5, 5 * scale / 100)
		health_circle_background:SetMaterial(true)
		health_circle_background:SetColor(Color(62, 61, 69, 175))
		health_circle_background:SetAngles(90, 360)
		health_circle_background:Rotate(45)
		health_circle_background:SetDistance(8)

		local health_circle = circles.New(CIRCLE_OUTLINED, scale / 3, positionX + scale * 1.7, positionY + scale * 0.5, 5 * scale / 100)
		health_circle:SetMaterial(true)
		health_circle:SetColor(color)
		health_circle:SetAngles(0, 270)
		health_circle:Rotate(135)
		health_circle:SetDistance(8)

		hook.Add("HUDPaint", "SV_HUDPaint", function()
			if not SVMOD:IsVehicle(veh) then
				return
			end

			local speed = veh:SV_GetSpeed()

			draw.DrawText(speed, "SV_HUD40", positionX, positionY - scale * 0.6, Color(230, 230, 230), TEXT_ALIGN_CENTER)
			draw.DrawText("KM/H", "SV_HUD20", positionX, positionY + scale * 0.1, Color(200, 200, 200), TEXT_ALIGN_CENTER)

			speed_circle_background()
			speed_circle:SetEndAngle(135 + 225 * math.min(speed / maxSpeed, 1))
			speed_circle()
			big_circle()

			fuel_circle_background()
			fuel_circle:SetEndAngle(math.floor(270 * veh:SV_GetPercentFuel() / 100))
			fuel_circle()

			surface.SetDrawColor(230, 230, 230)
			surface.SetMaterial(fuelStationMaterial)
			surface.DrawTexturedRect(positionX + scale * 0.76, positionY + scale * 0.31, 32 * scale / 100, 32 * scale / 100)

			health_circle_background()
			health_circle:SetEndAngle(math.floor(270 * veh:SV_GetPercentHealth() / 100))
			health_circle()

			surface.SetDrawColor(230, 230, 230)
			surface.SetMaterial(heartMaterial)
			surface.DrawTexturedRect(positionX + scale * 1.55, positionY + scale * 0.31, 32 * scale / 100, 32 * scale / 100)
		end)
	end

	hook.Add("SV_PlayerEnteredVehicle", "SV_EnableHUD2", function(_, veh)
		createDrawHook(veh)
	end)

	hook.Add("SV_PlayerLeaveVehicle", "SV_DisableHUD2", function()
		hook.Remove("HUDPaint", "SV_HUDPaint")
	end)

	if LocalPlayer().GetVehicle then
		local veh = LocalPlayer():GetVehicle()
		if IsValid(veh) then
			createDrawHook(veh)
		end
	end
end

function SVMOD:DisableHUD()
	hook.Remove("SV_PlayerEnteredVehicle", "SV_EnableHUD2")
	hook.Remove("HUDPaint", "SV_HUDPaint")
end

hook.Add("SV_Disabled", "SV_DisableHUD", function()
	SVMOD:DisableHUD()
end)