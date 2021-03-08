--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_IsDriverSeat()
   Type: Shared
   Desc: Returns true if it is a driver seat, false
		 otherwise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_IsDriverSeat()
	-- return not self:SV_IsPassengerSeat()
	return self.SV_Data ~= nil
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetDriverSeat()
   Type: Shared
   Desc: Returns the driver seat of the vehicle, self if the
		 vehicle is already the driver seat.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetDriverSeat()
	local parent = self:GetParent()

	if IsValid(parent) then
		return parent
	end

	return self
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_IsPassengerSeat()
   Type: Shared
   Desc: Returns true if it is a passenger seat, false
		 otherwise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_IsPassengerSeat()
	-- return IsValid(self:GetParent()) and self:GetParent():IsVehicle()
	return self.SV_Data == nil
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetPassengerSeats()
   Type: Shared
   Desc: Returns a list of all passenger seats of the
		 vehicle. Returns a list of all passenger seats of
		 the vehicle. Seats with no seated player are not
		 created, and therefore cannot be included in this
		 table.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetPassengerSeats()
	local passengerSeats = {}

	for _, child in ipairs(self:SV_GetDriverSeat():GetChildren()) do
		if child:GetClass() == "prop_vehicle_prisoner_pod" then
			table.insert(passengerSeats, child)
		end
	end

	return passengerSeats
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetAllPlayers()
   Type: Shared
   Desc: Returns a table with the driver and passengers of a
		 vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetAllPlayers()
	local players = {}

	if IsValid(self:SV_GetDriverSeat():GetDriver()) then
		table.insert(players, self:SV_GetDriverSeat():GetDriver())
	end

	for _, veh in ipairs(self:SV_GetPassengerSeats()) do
		if IsValid(veh:GetDriver()) then
			table.insert(players, veh:GetDriver())
		end
	end

	return players
end