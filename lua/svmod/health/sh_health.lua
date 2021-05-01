-- @class SV_Vehicle
-- @shared

-- Gets the vehicle health.
-- @treturn number Vehicle health
function SVMOD.Metatable:SV_GetHealth()
	local veh = self:SV_GetDriverSeat()

	if not veh.SV_Data.Parts or #veh.SV_Data.Parts == 0 then
		return -1
	end

	local Health = 0

	for _, p in ipairs(veh.SV_Data.Parts) do
		Health = Health + p.Health
	end

	return Health / #veh.SV_Data.Parts
end

-- Gets the vehicle max health.
-- @treturn number Vehicle max health
function SVMOD.Metatable:SV_GetMaxHealth()
	local veh = self:SV_GetDriverSeat()

	return veh:GetMaxHealth()
end

-- Gets the vehicle health as a percentage.
-- @treturn number Vehicle health percentage
function SVMOD.Metatable:SV_GetPercentHealth()
	return self:SV_GetHealth() / self:SV_GetMaxHealth() * 100
end