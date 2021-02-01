--[[---------------------------------------------------------
   Name: Vehicle:SV_GetFlashingLightsState()
   Type: Shared
   Desc: Returns the state of the vehicle's flashing lights.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetFlashingLightsState()
    if self:SV_IsPassengerSeat() then
        return self:SV_GetDriverSeat().SV_States.FlashingLights
    end
    return self.SV_States.FlashingLights
end