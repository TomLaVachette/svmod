-- @class SV_Vehicle
-- @shared

-- Returns the horn state of the vehicle.
-- @treturn boolean True if enabled, false if disabled
function SVMOD.Metatable:SV_GetHornState()
	return self.SV_States.Horn
end