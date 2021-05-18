hook.Add("SV_PlayerEnteredVehicle", "SV_AddWheelMouse", function()
	hook.Add("StartCommand", "SV_Wheel", function(ply, cmd)
		local veh = ply:GetVehicle()
		if not SVMOD:IsVehicle(veh) then return end

		veh = veh:SV_GetDriverSeat()

		local A, B = veh:GetModelBounds()
		local Width = B.y - A.y
		if ply:GetVehicle():GetThirdPersonMode() and cmd:GetMouseWheel() ~= 0 then
			veh:SetCameraDistance(math.Clamp(veh:GetCameraDistance() + (-cmd:GetMouseWheel() / 10), Width / 1000 * 3, Width / 1000 * 7))
		end

		-- Disable default camera distance
		cmd:SetMouseWheel(0)
	end)
end)

hook.Add("SV_PlayerLeaveVehicle", "SV_RemoveWheelMouse", function()
	hook.Remove("StartCommand", "SV_Wheel")
end)

hook.Add("CalcVehicleView", "SV_VehicleView", function(veh, ply, view)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:GetThirdPersonMode() then return end

	veh = veh:SV_GetDriverSeat()

	if veh:GetCameraDistance() == 0 then
		veh:SetCameraDistance(0.8)
	end
	local origin = veh:GetPos() + Vector(0, 0, 75) - (view.angles:Forward() * 250) * veh:GetCameraDistance()

	local tr = util.TraceHull({
		start = view.origin,
		endpos = origin,
		filter = function(e)
			if e:IsVehicle() then
				return false
			end
		end,
		mins = Vector(-4, -4, -4),
		maxs = Vector(4, 4, 4),
	})

	view.origin = tr.HitPos
	view.drawviewer = true

	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * 4
	end

	return view
end)