-- @class SV_Vehicle
-- @shared

-- Gets the state of the vehicle's back lights.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetBackLightsState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.BackLights
	end
	return self.SV_States.BackLights
end