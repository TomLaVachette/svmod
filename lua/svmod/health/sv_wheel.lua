function SVMOD.Metatable:SV_SetWheelFLHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(0, value)
	self:SetNW2Int("SV_WheelFLHealth", value)
	self:SV_UpdateWheelSpeed()
end

function SVMOD.Metatable:SV_SetWheelFRHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(1, value)
	self:SetNW2Int("SV_WheelFRHealth", value)
	self:SV_UpdateWheelSpeed()
end

function SVMOD.Metatable:SV_SetWheelRLHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(2, value)
	self:SetNW2Int("SV_WheelRLHealth", value)
	self:SV_UpdateWheelSpeed()
end

function SVMOD.Metatable:SV_SetWheelRRHealth(value)
	value = math.Clamp(value, 0, 100)
	self:SV_SetWheelPercent(3, value)
	self:SetNW2Int("SV_WheelRRHealth", value)
	self:SV_UpdateWheelSpeed()
end

function SVMOD.Metatable:SV_DealDamageToWheel(wheelID, value)
	if value <= 0 then
		return
	end

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

function SVMOD.Metatable:SV_StartPunctureWheel(wheelID, delayToPuncture)
	if delayToPuncture <= 0 then
		return
	end

	local setter, getter
	if wheelID == self.SV_WheelFrontLeftID then
		if self:SV_IsWheelFLPunctured() then
			return
		end
		setter = self.SV_SetWheelFLHealth
		getter = self.SV_GetWheelFLHealth
		self:SetNW2Bool("SV_IsWheelFLPunctured", true)
	elseif wheelID == self.SV_WheelFrontRightID then
		if self:SV_IsWheelFRPunctured() then
			return
		end
		setter = self.SV_SetWheelFRHealth
		getter = self.SV_GetWheelFRHealth
		self:SetNW2Bool("SV_IsWheelFRPunctured", true)
	elseif wheelID == self.SV_WheelRearLeftID then
		if self:SV_IsWheelRLPunctured() then
			return
		end
		setter = self.SV_SetWheelRLHealth
		getter = self.SV_GetWheelRLHealth
		self:SetNW2Bool("SV_IsWheelRLPunctured", true)
	elseif wheelID == self.SV_WheelRearRightID then
		if self:SV_IsWheelRRPunctured() then
			return
		end
		setter = self.SV_SetWheelRRHealth
		getter = self.SV_GetWheelRRHealth
		self:SetNW2Bool("SV_IsWheelRRPunctured", true)
	else
		return
	end

	local veh = self
	timer.Create("SV_PunctureWheel_" .. self:EntIndex() .. "_" .. wheelID, delayToPuncture / 11, 0, function()
		if not IsValid(veh) then
			timer.Remove("SV_PunctureWheel_" .. self:EntIndex() .. "_" .. wheelID)
			return
		end

		local value = getter(veh)

		if value == 0 then
			self:SV_StopPunctureWheel(wheelID)
		else
			if veh:GetVelocity():Length() > 400 then
				setter(veh, value - 11 * 2)
			else
				setter(veh, value - 11)
			end
		end
	end)
end

function SVMOD.Metatable:SV_StopPunctureWheel(wheelID)
	timer.Remove("SV_PunctureWheel_" .. self:EntIndex() .. "_" .. wheelID)

	if wheelID == self.SV_WheelFrontLeftID then
		self:SetNW2Bool("SV_IsWheelFLPunctured", false)
	elseif wheelID == self.SV_WheelFrontRightID then
		self:SetNW2Bool("SV_IsWheelFRPunctured", false)
	elseif wheelID == self.SV_WheelRearLeftID then
		self:SetNW2Bool("SV_IsWheelRLPunctured", false)
	elseif wheelID == self.SV_WheelRearRightID then
		self:SetNW2Bool("SV_IsWheelRRPunctured", false)
	end
end

function SVMOD.Metatable:SV_UpdateWheelSpeed()
	self:SetMaxThrottle((self:SV_GetWheelFLHealth() * 0.25 + self:SV_GetWheelFRHealth() * 0.25 + self:SV_GetWheelRLHealth() * 0.25 + self:SV_GetWheelRRHealth() * 0.25) / 100)
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