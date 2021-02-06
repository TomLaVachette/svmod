-- @class SV_Vehicle
-- @shared

-- Gets the state of the headlights.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetHeadlightsState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.Headlights
	end

	return self.SV_States.Headlights
end