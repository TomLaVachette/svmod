function SVMOD.Metatable:SV_SetWheelFLHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(0, value)
	self:SetNW2Int("SV_WheelFLHealth", value)
end

function SVMOD.Metatable:SV_SetWheelFRHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(1, value)
	self:SetNW2Int("SV_WheelFRHealth", value)
end

function SVMOD.Metatable:SV_SetWheelRLHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(2, value)
	self:SetNW2Int("SV_WheelRLHealth", value)
end

function SVMOD.Metatable:SV_SetWheelRRHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(3, value)
	self:SetNW2Int("SV_WheelRRHealth", value)
end

function SVMOD.Metatable:SV_DealDamageToWheel(wheelID, value)
	if wheelID == self.SV_WheelFrontLeftID then
		self:SV_SetWheelFLHealth(self:SV_GetWheelFLHealth() - value)
	elseif wheelID == self.SV_WheelFrontRightID then
		self:SV_SetWheelFRHealth(self:SV_GetWheelFRHealth() - value)
	elseif wheelID == self.SV_WheelRearLeftID then
		self:SV_SetWheelRLHealth(self:SV_GetWheelRLHealth() - value)
	elseif wheelID == self.SV_WheelRearRightID then
		self:SV_SetWheelRRHealth(self:SV_GetWheelRRHealth() - value)
	end
end

function SVMOD.Metatable:SV_SetWheelPercent(wheelID, percent)
	if not self.SV_Suspension or not self.GetWheelTotalHeight then
		return
	end

	local defaultValue = (self:GetWheelTotalHeight(1) * 2.54) / 100
	self:SetSpringLength(wheelID, self.SV_Suspension + (defaultValue * 0.25) + (defaultValue * 0.75 * (percent / 100)))
end

hook.Add("SV_LoadVehicle", "SV_LoadVehicle_CustomSuspension", function(veh)
	veh.SV_Suspension = 500 + (SVMOD.CFG.Others.CustomSuspension / 100)

	if veh.SV_Suspension ~= 500 then
		for i = 0, veh:GetWheelCount() - 1 do
			veh:SV_SetWheelPercent(i, 100)
		end
	end
end)