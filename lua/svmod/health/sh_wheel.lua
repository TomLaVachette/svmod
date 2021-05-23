hook.Add("SV_LoadVehicle", "SV_InitWheels", function(veh)
	for _, v in ipairs(veh:GetAttachments()) do
		if v.name == "wheel_fl" then
			veh.SV_WheelFrontLeftID = v.id
		elseif v.name == "wheel_fr" then
			veh.SV_WheelFrontRightID = v.id
		elseif v.name == "wheel_rl" then
			veh.SV_WheelRearLeftID = v.id
		elseif v.name == "wheel_rr" then
			veh.SV_WheelRearRightID = v.id
		end
	end
end)

function SVMOD.Metatable:SV_GetWheelFLHealth()
	local veh = self:SV_GetDriverSeat()
	return veh:GetNW2Int("SV_WheelFLHealth", 0)
end

function SVMOD.Metatable:SV_GetWheelFRHealth()
	local veh = self:SV_GetDriverSeat()
	return veh:GetNW2Int("SV_WheelFRHealth", 0)
end

function SVMOD.Metatable:SV_GetWheelRLHealth()
	local veh = self:SV_GetDriverSeat()
	return veh:GetNW2Int("SV_WheelRLHealth", 0)
end

function SVMOD.Metatable:SV_GetWheelRRHealth()
	local veh = self:SV_GetDriverSeat()
	return veh:GetNW2Int("SV_WheelRRHealth", 0)
end

function SVMOD.Metatable:SV_IsWheelFLPunctured()
	return self:GetNW2Bool("SV_IsWheelFLPunctured", false)
end

function SVMOD.Metatable:SV_IsWheelFRPunctured()
	return self:GetNW2Bool("SV_IsWheelFRPunctured", false)
end

function SVMOD.Metatable:SV_IsWheelRLPunctured()
	return self:GetNW2Bool("SV_IsWheelRLPunctured", false)
end

function SVMOD.Metatable:SV_IsWheelRRPunctured()
	return self:GetNW2Bool("SV_IsWheelRRPunctured", false)
end

function SVMOD.Metatable:SV_GetWheelID(type)
	for _, v in ipairs(self:GetAttachments()) do
		if v.name == type then
			return v.id
		end
	end
end

function SVMOD.Metatable:SV_GetNearestWheel(pos)
	local bestWheel
	local bestDistance = 999999

	for _, part in ipairs(self.SV_Data.Parts) do
		if part.WheelID then
			local distance = part.Position:DistToSqr(pos)
			if distance < bestDistance then
				bestWheel = part.WheelID
				bestDistance = distance
			end
		end
	end

	return bestWheel, bestDistance
end