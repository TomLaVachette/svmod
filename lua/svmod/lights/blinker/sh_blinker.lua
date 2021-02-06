-- @class SV_Vehicle
-- @shared

-- Gets the state of the left blinkers.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetLeftBlinkerState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.LeftBlinkers
	end
	return self.SV_States.LeftBlinkers
end

-- Gets the state of the right blinkers.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetRightBlinkerState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.RightBlinkers
	end
	return self.SV_States.RightBlinkers
end