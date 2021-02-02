--[[---------------------------------------------------------
   Name: Vehicle:SV_GetLeftBlinkerState()
   Type: Shared
   Desc: Returns true if the left blinkers are on, false
		 otherwise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetLeftBlinkerState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.LeftBlinkers
	end
	return self.SV_States.LeftBlinkers
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_GetRightBlinkerState()
   Type: Shared
   Desc: Returns true if the right blinkers are on, false
		 otherwise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetRightBlinkerState()
	if self:SV_IsPassengerSeat() then
		return self:SV_GetDriverSeat().SV_States.RightBlinkers
	end
	return self.SV_States.RightBlinkers
end