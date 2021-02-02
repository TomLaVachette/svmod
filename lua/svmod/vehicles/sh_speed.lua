--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetSpeed()
   Type: Shared
   Desc: Returns the vehicle speed in km/h.
   Note: You should use the cached version if you are going to
		 call it often (like in a draw).
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetSpeed()
	local veh = self
	if self:SV_IsPassengerSeat() then
		veh = self:SV_GetDriverSeat()
	end

	return math.Round(veh:GetVelocity():Length() / 10.936133)
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetCachedSpeed()
   Type: Shared
   Desc: Returns the vehicle cached speed in km/h. This value
		 is updated once every 0.2 second.
   Note: You can call it every frame in a draw.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetCachedSpeed()
	if not self.SV_SavedSpeed or not self.SV_SavedSpeedTime or CurTime() > self.SV_SavedSpeedTime then
		self.SV_SavedSpeed = self:SV_GetSpeed()
		self.SV_SavedSpeedTime = CurTime() + 0.2
	end

	return self.SV_SavedSpeed
end