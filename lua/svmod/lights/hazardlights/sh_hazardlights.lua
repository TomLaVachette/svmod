-- @class SV_Vehicle
-- @shared

-- Returns the state of the vehicle's left turn signals.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetHazardLightsState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.HazardLights
	end
	return self.SV_States.HazardLights
end