-- @class SV_Vehicle
-- @shared

-- Gets the vehicle speed in km/h.
--
-- You should use the cached version if you are going to
-- call it often (like in a draw).
-- @treturn number Vehicle speed in km/h
function SVMOD.Metatable:SV_GetSpeed()
	local veh = self
	if self:SV_IsPassengerSeat() then
		veh = self:SV_GetDriverSeat()
	end

	return math.Round(veh:GetVelocity():Length() / 10.936133)
end

-- Returns the vehicle cached speed in km/h. This value
-- is updated once every 0.2 second.
--
-- You can call it every frame in a draw.
-- @treturn number Vehicle speed in km/h
function SVMOD.Metatable:SV_GetCachedSpeed()
	if not self.SV_SavedSpeed or not self.SV_SavedSpeedTime or CurTime() > self.SV_SavedSpeedTime then
		self.SV_SavedSpeed = self:SV_GetSpeed()
		self.SV_SavedSpeedTime = CurTime() + 0.2
	end

	return self.SV_SavedSpeed
end