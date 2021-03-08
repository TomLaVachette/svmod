-- @class SV_Vehicle
-- @shared

hook.Add("SV_LoadVehicle", "SV_LoadVehicle_Fuel", function(veh)
	veh.SV_MaxFuel = veh.SV_Data.Fuel.Capacity or 50
	veh.SV_Fuel = veh.SV_MaxFuel
end)

-- Gets the vehicle fuel in liters.
-- @tparam number fuel Fuel in liters
function SVMOD.Metatable:SV_GetFuel()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_Fuel
	end
	return self.SV_Fuel
end

-- Gets the vehicle maximum fuel in liters.
-- @tparam number maxFuel Maximum fuel in liters
function SVMOD.Metatable:SV_GetMaxFuel()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_MaxFuel
	end
	return self.SV_MaxFuel
end

-- Gets the vehicle fuel as a percentage.
-- @tparam number percentFuel Fuel in percentage
function SVMOD.Metatable:SV_GetPercentFuel()
	local MaxFuel = self:SV_GetMaxFuel()
	if MaxFuel == 0 then
		return 0
	end

	return self:SV_GetFuel() / MaxFuel * 100
end