-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_TurnLeftBlinker")
util.AddNetworkString("SV_TurnRightBlinker")

-- Turns on the left blinkers of a vehicle.
--
-- The operation will fail if the left blinkers are
-- already on, if the vehicle has no left blinkers,
-- or if the blinkers have been disabled.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOnLeftBlinker()
	if not self.SV_IsEditMode and #self.SV_Data.Blinkers.LeftLights == 0 then
		return false -- No left blinkers on this vehicle
	elseif not SVMOD.CFG.Lights.AreHeadlightsEnabled then
		return false -- Blinkers disabled
	elseif self:SV_GetLeftBlinkerState() then
		return false -- Left blinkers already active
	elseif not self.SV_IsEditMode and self:SV_GetHealth() == 0 then
		return false -- Vehicle destroyed
	end

	net.Start("SV_TurnLeftBlinker")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()

	self.SV_States.LeftBlinkers = true
	self.SV_States.RightBlinkers = false

	return true
end


-- Turns off the left blinkers of a vehicle.
--
-- The operation will fail if the left blinkers are
-- already switched off.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOffLeftBlinker()
	if not self:SV_GetLeftBlinkerState() then
		return false -- Left blinkers already inactive
	end

	net.Start("SV_TurnLeftBlinker")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()

	self.SV_States.LeftBlinkers = false
	self.SV_States.RightBlinkers = false

	return true
end

-- Turns on the right blinkers of a vehicle.
--
-- The operation will fail if the right blinkers are
-- already on, if the vehicle has no right blinkers,
-- or if the blinkers have been disabled.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOnRightBlinker()
	if not self.SV_IsEditMode and #self.SV_Data.Blinkers.RightLights == 0 then
		return false -- No right blinkers on this vehicle
	elseif not SVMOD.CFG.Lights.AreHeadlightsEnabled then
		return false -- Blinkers disabled
	elseif self:SV_GetRightBlinkerState() then
		return false -- Right blinkers already active
	elseif not self.SV_IsEditMode and self:SV_GetHealth() == 0 then
		return false -- Vehicle destroyed
	end

	net.Start("SV_TurnRightBlinker")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()

	self.SV_States.RightBlinkers = true
	self.SV_States.LeftBlinkers = false

	return true
end

-- Turns off the right blinkers of a vehicle.
--
-- The operation will fail if the right blinkers are
-- already switched off.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOffRightBlinker()
	if not self:SV_GetRightBlinkerState() then
		return false -- Right blinkers already inactive
	end

	net.Start("SV_TurnRightBlinker")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()

	self.SV_States.RightBlinkers = false
	self.SV_States.LeftBlinkers = false

	return true
end

util.AddNetworkString("SV_SetLeftBlinkerState")
net.Receive("SV_SetLeftBlinkerState", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	local state = net.ReadBool()

	if state then
		if not veh:SV_GetLeftBlinkerState() then
			veh:SV_TurnOnLeftBlinker()
		end
	else
		if veh:SV_GetLeftBlinkerState() then
			veh:SV_TurnOffLeftBlinker()
		end
	end
end)

util.AddNetworkString("SV_SetRightBlinkerState")
net.Receive("SV_SetRightBlinkerState", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	local state = net.ReadBool()

	if state then
		if not veh:SV_GetRightBlinkerState() then
			veh:SV_TurnOnRightBlinker()
		end
	else
		if veh:SV_GetRightBlinkerState() then
			veh:SV_TurnOffRightBlinker()
		end
	end
end)

local function disableHazard(veh)
	if not SVMOD.CFG.Lights.TurnOffHazardOnExit then return end

	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Create("SV_DisableHazard_" .. veh:EntIndex(), SVMOD.CFG.Lights.TimeTurnOffHazard, 1, function()
		if not SVMOD:IsVehicle(veh) then return end

		if veh:SV_GetHazardLightsState() then
			veh:SV_TurnOffHazardLights()
		end

		if veh:SV_GetLeftBlinkerState() then
			veh:SV_TurnOffLeftBlinker()
		end

		if veh:SV_GetRightBlinkerState() then
			veh:SV_TurnOffRightBlinker()
		end
	end)
end

hook.Add("PlayerLeaveVehicle", "SV_DisableHazardOnLeave", function(ply, veh)
	disableHazard(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableHazardOnDisconnect", function(ply)
	local veh = ply:GetVehicle()

	disableHazard(veh)
end)

hook.Add("PlayerEnteredVehicle", "SV_UndoDisableHazardOnLeave", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Remove("SV_DisableHazard_" .. veh:EntIndex())
end)