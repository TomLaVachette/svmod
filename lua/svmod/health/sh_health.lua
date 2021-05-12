-- @class SV_Vehicle
-- @shared

-- Gets the vehicle health.
-- @treturn number Vehicle health
function SVMOD.Metatable:SV_GetHealth()
	return self:GetNW2Int("SV_Health", 0)
end

-- Gets the vehicle max health.
-- @treturn number Vehicle max health
function SVMOD.Metatable:SV_GetMaxHealth()
	return self:GetNW2Int("SV_MaxHealth", 0)
end

-- Gets the vehicle health as a percentage.
-- @treturn number Vehicle health percentage
function SVMOD.Metatable:SV_GetPercentHealth()
	return self:SV_GetHealth() / self:SV_GetMaxHealth() * 100
end