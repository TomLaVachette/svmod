--[[---------------------------------------------------------
   Name: Vehicle:SV_GetBackLightsState()
   Type: Shared
   Desc: Returns the state of the vehicle's back lights.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetBackLightsState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.BackLights
	end
	return self.SV_States.BackLights
end