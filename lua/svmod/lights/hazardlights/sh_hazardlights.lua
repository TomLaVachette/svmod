--[[---------------------------------------------------------
   Name: Vehicle:SV_GetHazardLightsState()
   Type: Shared
   Desc: Returns the state of the vehicle's left turn
         signals.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetHazardLightsState()
    if self:SV_IsPassengerSeat() then
        return self:SV_GetDriverSeat().SV_States.HazardLights
    end
    return self.SV_States.HazardLights
end