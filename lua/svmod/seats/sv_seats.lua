--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetNearestEmptySeat(Vector position)
   Type: Server
   Desc: Returns the nearest empty seat of a given position.
   Note: This is an internal function, you should not use it.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetNearestEmptySeat(position)
	local bestDistance = 15000
	local bestIndex = nil

	for i, seat in ipairs(self.SV_Data.Seats) do
		if not seat.Entity then
			local CurrentDistance = position:DistToSqr(self:LocalToWorld(seat.Position))
			if CurrentDistance < bestDistance then
				bestDistance = CurrentDistance
				bestIndex = i
			end
		end
	end

	return bestIndex, self.SV_Data.Seats[bestIndex]
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetNearestEmptyPassengerSeat(Vector position)
   Type: Server
   Desc: Returns the nearest empty passenger seat of a given position.
   Note: This is an internal function, you should not use it.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetNearestEmptyPassengerSeat(position)
	local bestDistance = 15000
	local bestIndex = nil

	for i, seat in ipairs(self.SV_Data.Seats) do
		if not seat.Entity and i ~= 1 then
			local CurrentDistance = position:DistToSqr(self:LocalToWorld(seat.Position))
			if CurrentDistance < bestDistance then
				bestDistance = CurrentDistance
				bestIndex = i
			end
		end
	end

	return bestIndex, self.SV_Data.Seats[bestIndex]
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetSeat(int index)
   Type: Server
   Desc: Returns the seat to the specified index.
   Note: This is an internal function, you should not use it.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetSeat(index)
	if index <= #self.SV_Data.Seats  then
		-- May be an entity or nil
		return self.SV_Data.Seats[index].Entity
	end

	return nil
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_CreateSeat(int index)
   Type: Server
   Desc: Creates a seat from a vehicle seat index.
   Note: This is an internal function, you should not use it.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_CreateSeat(index)
	-- Return if sit does not exist
	if not self.SV_Data.Seats[index] then
		return nil
	end

	-- Return if sit already created
	if IsValid(self.SV_Data.Seats[index].Entity) then
		return nil
	end

	-- Return the main vehicle if it is a driver seat
	if index == 1 then
		self.SV_Data.Seats[index].Entity = self

		-- Without this timer, driver's seat is inaccessible
		-- if an addon returns false in PlayerCanEnterVehicle.
		timer.Simple(FrameTime(), function()
			if not IsValid(self:GetDriver()) then
				self.SV_Data.Seats[index].Entity = nil
			end
		end)

		return self
	end

	local seat = ents.Create("prop_vehicle_prisoner_pod")
	seat:SetModel("models/nova/airboat_seat.mdl")
	seat:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview","0")
	seat:AddEFlags(EFL_NO_THINK_FUNCTION)

	seat:SetParent(self)
	seat:SetLocalPos(self.SV_Data.Seats[index].Position)
	seat:SetLocalAngles(self.SV_Data.Seats[index].Angles)

	seat:SetCollisionGroup(COLLISION_GROUP_WORLD)

	seat:SetNW2Bool("SV_IsSeat", true)

	-- Add pointers to the vehicle metatable
	for k, v in pairs(SVMOD.Metatable) do
		seat[k] = v
	end

	seat:Spawn()
	seat:Activate()

	seat:PhysicsDestroy()
	seat:SetNotSolid(true)

	-- seat:SetNoDraw(true) => Players sitting on it become invisible?
	seat:SetRenderMode(RENDERMODE_TRANSALPHA)
	seat:SetColor(Color(255, 255, 255, 0))
	seat:DrawShadow(false)

	self.SV_Data.Seats[index].Entity = seat

	-- Without this timer, passenger seats are inaccessible
	-- if an addon returns false in PlayerCanEnterVehicle.
	timer.Simple(FrameTime(), function()
		if IsValid(seat) and not IsValid(seat:GetDriver()) then
			seat:Remove()
		end
	end)

	seat:CallOnRemove("SV_RemoveSeatFromParentTable", function(vehSeat)
		local Parent = vehSeat:GetParent()
		if not IsValid(Parent) or not Parent.SV_Data.Seats then return end

		for _, s in ipairs(Parent.SV_Data.Seats) do
			if s.Entity == vehSeat then
				s.Entity = nil
				break
			end
		end
	end)

	return seat
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_EnterVehicle(Player ply)
   Type: Server
   Desc: Sit the player on the nearest available seat. The
		 seat can be a driver or passenger seat. The
		 operation will fail if the vehicle is locked.
   Note: If you want to bypass all checks and seat a player
		 in a specific seat, use Player:EnterVehicle instead.
-----------------------------------------------------------]]
util.AddNetworkString("SV_PlayerEnteredVehicle")
function SVMOD.Metatable:SV_EnterVehicle(ply, seat)
	-- No seat configuration for this vehicle
	if not self.SV_Data or not self.SV_Data.Seats then
		return -1
	end

	-- Vehicle locked
	if self:SV_IsLocked() then
		self:EmitSound("doors/default_locked.wav")
		hook.Run("SV_TriedToEnterLockedVehicle", self, ply)
		return -2
	end

	local seatIndex = self:SV_GetNearestEmptySeat(ply:GetShootPos())

	if seat and self.SV_Data.Seats[seat] and not self.SV_Data.Seats[seat].Entity then
		seatIndex = seat
	end

	-- No seat available
	if not seatIndex then
		return -3
	end

	local seat = self:SV_CreateSeat(seatIndex)
	-- Error on creating seat
	if not IsValid(seat) then
		return -4
	end

	ply:ExitVehicle()
	ply:EnterVehicle(seat)

	return 1
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_HandcuffedPlayerEnterVehicle(Player ply)
   Type: Server
   Desc: Sit the player on the nearest available seat. The
		 seat is a passenger seat. The
		 operation will fail if the vehicle is locked.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_HandcuffedPlayerEnterVehicle(ply, handcuffer)
	if not IsValid(handcuffer) then return end

	-- No seat configuration for this vehicle
	if not self.SV_Data or not self.SV_Data.Seats then
		return -1
	end

	-- Vehicle locked
	if self:SV_IsLocked() then
		self:EmitSound("doors/default_locked.wav")
		hook.Run("SV_TriedToEnterLockedVehicle", self, ply)
		return -2
	end

	local seatIndex = self:SV_GetNearestEmptyPassengerSeat(handcuffer:GetShootPos())

	-- No seat available
	if not seatIndex then
		return -3
	end

	local seat = self:SV_CreateSeat(seatIndex)
	-- Error on creating seat
	if not IsValid(seat) then
		return -4
	end

	ply:ExitVehicle()
	ply:EnterVehicle(seat)

	return 1
end

util.AddNetworkString("SV_EnterVehicle")
net.Receive("SV_EnterVehicle", function(_, ply)
	local veh = ply:GetEyeTrace().Entity
	if not SVMOD:IsVehicle(veh) then
		return
	end

	veh:SV_EnterVehicle(ply)
end)

hook.Add("PlayerEnteredVehicle", "SV_PlayerEnteredVehicle", function(ply, seat)
	if not SVMOD:IsVehicle(seat) then
		return
	end

	ply:SetEyeAngles(Angle(0, 90, 0))

	-- Update last driver
	if seat:SV_IsDriverSeat() then
		seat.SV_LastDriver = ply
	end

	if not ply.SV_IsSwitchingSeat then
		-- Hook server side
		hook.Run("SV_PlayerEnteredVehicle", ply, seat:SV_GetDriverSeat())

		-- Hook client side
		net.Start("SV_PlayerEnteredVehicle")
		net.WriteEntity(seat:SV_GetDriverSeat())
		net.Send(ply)
	end
end)

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_ExitVehicle()
   Type: Server
   Desc: Take the player out of the vehicle. The operation
		 will fail if the vehicle is locked.
   Note: If you want to bypass the vehicle lock, use
		 Player:ExitVehicle instead.
-----------------------------------------------------------]]
util.AddNetworkString("SV_PlayerLeaveVehicle")
function SVMOD.Metatable:SV_ExitVehicle(ply)
	local driverSeat = self:SV_GetDriverSeat()

	-- The player is not sitting in this vehicle
	if ply:GetVehicle():SV_GetDriverSeat() ~= driverSeat then
		return -1
	end

	if hook.Run("CanExitVehicle", driverSeat, ply) == false then
		return -3
	end

	if self:SV_IsLocked() then
		self:EmitSound("doors/default_locked.wav")
		hook.Run("SV_TriedToExitLockedVehicle", self, ply)
		return -2
	end

	ply:ExitVehicle()

	return 1
end

util.AddNetworkString("SV_ExitVehicle")
net.Receive("SV_ExitVehicle", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) then return end

	veh:SV_ExitVehicle(ply)
end)

hook.Add("PlayerLeaveVehicle", "SV_PlayerLeaveVehicle", function(ply, seat)
	if not SVMOD:IsVehicle(seat) then
		return
	elseif ply.SV_IsSwitchingSeat then
		return
	end

	ply:SetEyeAngles(Angle(0, (seat:GetPos() - ply:GetPos()):Angle().y, 0))

	if #seat:SV_GetDriverSeat().SV_Data.Seats > 0 then
		-- Set the player position because the player will
		-- be teleported on a blocked zone otherwise
		local vectorList = {
			Vector(-50, 0, 10), Vector(50, 0, 10),
			Vector(-70, 0, 10), Vector(70, 0, 10),
			Vector(-90, 0, 10), Vector(90, 0, 10)
		}

		for i, v in ipairs(vectorList) do
			local position = seat:GetPos()
			local newPosition = seat:LocalToWorld(v)

			-- If it is the driver's seat, the position of the player is incorrect.
			-- Then, we take the position of the seat as a reference.
			if seat:SV_IsDriverSeat() then
				position = seat:LocalToWorld(seat.SV_Data.Seats[1].Position)
				newPosition = LocalToWorld(v, seat:GetAngles(), position, seat:GetAngles())
			end

			-- Check if the player can spawn without going through a wall
			local isHittingWall = util.TraceLine({
				start = position,
				endpos = newPosition,
				filter = seat:SV_GetDriverSeat()
			}).Hit

			if not isHittingWall then
				-- From the gmod wiki, thank you <3
				-- Check if player can spawn without getting stuck inside anything
				local isHittingAnything = util.TraceHull({
					start = newPosition,
					endpos = newPosition,
					mins = Vector(-16, -16, 0), -- Magic values
					maxs = Vector(16, 16, 71), -- Magic values
					filter = ply
				}).Hit

				if not isHittingAnything then
					ply:SetPos(newPosition)
					break
				end
			end
		end
	end

	ply:SetVelocity(seat:GetVelocity())

	-- Hook server side
	hook.Run("SV_PlayerLeaveVehicle", ply, seat:SV_GetDriverSeat())

	-- Hook client side
	net.Start("SV_PlayerLeaveVehicle")
	net.WriteEntity(seat:SV_GetDriverSeat())
	net.Send(ply)
end)

util.AddNetworkString("SV_SwitchSeat")
net.Receive("SV_SwitchSeat", function(_, ply)
	if not SVMOD.CFG.Seats.IsSwitchEnabled then return end

	local currentSeat = ply:GetVehicle()
	if not SVMOD:IsVehicle(currentSeat) then return end

	local veh = currentSeat:SV_GetDriverSeat()
	
	if hook.Run("CanExitVehicle", veh, ply) == false then return end

	local seatIndex = net.ReadUInt(4) -- max: 15

	local seat = veh:SV_CreateSeat(seatIndex)
	if IsValid(seat) then
		if hook.Run("SV_PlayerCanSwitchSeat", ply, currentSeat, seat) == false then
			return
		end
		
		if hook.Run("CanPlayerEnterVehicle", ply, seat) == false then
			return
		end

		local EyeAngle = seat:WorldToLocalAngles(ply:EyeAngles())

		seat:SetThirdPersonMode(veh:GetThirdPersonMode())

		ply.SV_IsSwitchingSeat = true

		ply:ExitVehicle()

		local isDriverSeat = seat:SV_IsDriverSeat()

		if SVMOD.CFG.Seats.AllowWeaponsInVehicle and not isDriverSeat then
			ply:SetAllowWeaponsInVehicle(true)
		end

		ply:EnterVehicle(seat)

		timer.Simple(FrameTime(), function()
			ply.SV_IsSwitchingSeat = false
		end)

		-- Update last driver
		if isDriverSeat then
			seat.SV_LastDriver = ply
		end

		ply:SetEyeAngles(EyeAngle)
	end
end)

util.AddNetworkString("SV_KickSeat")
net.Receive("SV_KickSeat", function(_, ply)
	if not SVMOD.CFG.Seats.IsKickEnabled then return end

	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	local seatIndex = net.ReadUInt(4) -- max: 15
	local seat = veh:SV_GetSeat(seatIndex)

	if IsValid(seat) then
		local Driver = seat:GetDriver()
		if IsValid(Driver) and Driver ~= ply then
			seat:SV_ExitVehicle(Driver)
		end
	end
end)

hook.Add("PlayerLeaveVehicle", "SV_VehicleHandbrake", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	-- Release the handbrake if the player does not down the SPACE key
	if not ply:KeyDown(IN_JUMP) then
		-- Wait for the next frames because the player is in the vehicle right now
		timer.Simple(0.1, function()
			if IsValid(veh) then
				veh:ReleaseHandbrake()
			end
		end)
	else
		veh:EmitSound("svmod/handbrake.wav", 75, 100, 0.5)
	end
end)

hook.Add("PlayerLeaveVehicle", "SV_SaveSteeringWheel", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end
	local vehSteering = veh:GetSteering()
		timer.Simple(FrameTime(), function()
		if not IsValid(veh) then
			return
		end
			veh:SetSteering(vehSteering,0)
		end)
end)

hook.Add("PlayerLeaveVehicle", "SV_RemoveSeats_PlayerLeaveVehicle", function(ply, veh)
	if not SVMOD:IsVehicle(veh) then
		return
	end

	if veh:SV_IsPassengerSeat() then
		-- Remove the passenger seat
		veh:Remove()
	else
		-- Free the driver seat
		if #veh.SV_Data.Seats > 0 then
			veh.SV_Data.Seats[1].Entity = nil
		end
	end
end)

hook.Add("PlayerDisconnected", "SV_RemoveSeats_PlayerDisconnected", function(ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) then
		return
	end

	if veh:SV_IsPassengerSeat() then
		-- Remove the passenger seat
		veh:Remove()
	else
		-- Free the driver seat
		veh.SV_Data.Seats[1].Entity = nil
	end
end)

hook.Add("EntityRemoved", "SV_ExitPlayer", function(ent)
	if not SVMOD:IsVehicle(ent) then
		return
	end

	local ply = ent:GetDriver()

	if IsValid(ply) then
		-- Hook server side
		hook.Run("SV_PlayerLeaveVehicle", ply, ent)

		-- Hook client side
		net.Start("SV_PlayerLeaveVehicle")
		net.WriteEntity(ent)
		net.Send(ply)
	end
end)

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetLastDriver()
   Type: Server
   Desc: Returns the last driver of a vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetLastDriver()
	return self.SV_LastDriver
end
