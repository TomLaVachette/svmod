--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetHeadlightsState()
   Type: Shared
   Desc: Returns true if headlights are on, false otherwise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetHeadlightsState()
    if self:SV_IsPassengerSeat() then
        return self:SV_GetDriverSeat().SV_States.Headlights
    end

    return self.SV_States.Headlights
end