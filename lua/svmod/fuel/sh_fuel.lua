hook.Add("SV_LoadVehicle", "SV_LoadVehicle_Fuel", function(veh)
	veh.SV_MaxFuel = veh.SV_Data.Fuel.Capacity or 50
	veh.SV_Fuel = veh.SV_MaxFuel
end)

--[[---------------------------------------------------------
   Name: Vehicle:SV_GetFuel()
   Type: Shared
   Desc: Returns the vehicle fuel in liters.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetFuel()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_Fuel
	end
	return self.SV_Fuel
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_GetMaxFuel()
   Type: Shared
   Desc: Returns the vehicle max fuel in liters.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetMaxFuel()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_MaxFuel
	end
	return self.SV_MaxFuel
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_GetPercentFuel()
   Type: Shared
   Desc: Returns the vehicle fuel as a percentage.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetPercentFuel()
	local MaxFuel = self:SV_GetMaxFuel()
	if MaxFuel == 0 then
		return 0
	end
	
	return self:SV_GetFuel() / MaxFuel * 100
end