-- @class SV_Vehicle
-- @shared

-- Gets the state of the vehicle's flashing lights.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetFlashingLightsState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.FlashingLights
	end
	return self.SV_States.FlashingLights
end