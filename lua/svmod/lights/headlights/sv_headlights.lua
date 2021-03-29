-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_TurnHeadlights")


-- Turns on the headlights of a vehicle.
--
-- The operation will fail if the headlights are
-- already on, if the vehicle has no headlights,
-- or if the headlights have been disabled.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOnHeadlights()
	if not self.SV_IsEditMode and #self.SV_Data.Headlights == 0 then
		return false -- No headlight on this vehicle
	elseif not SVMOD.CFG.Lights.AreHeadlightsEnabled then
		return false -- Headlights disabled
	elseif self:SV_GetHeadlightsState() then
		return false -- Headlights already active
	elseif not self.SV_IsEditMode and self:SV_GetHealth() == 0 then
		return false -- Vehicle destroyed
	end

	net.Start("SV_TurnHeadlights")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()

	self.SV_States.Headlights = true

	return true
end

-- Turns off the headlights of a vehicle.
--
-- The operation will fail if the headlights are
-- already switched off.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOffHeadlights()
	if not self:SV_GetHeadlightsState() then
		return false -- Headlights already inactive
	end

	net.Start("SV_TurnHeadlights")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()

	self.SV_States.Headlights = false

	return true
end

util.AddNetworkString("SV_SetHeadlightsState")
net.Receive("SV_SetHeadlightsState", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	local state = net.ReadBool()

	if state then
		veh:SV_TurnOnHeadlights()
	else
		veh:SV_TurnOffHeadlights()
	end
end)

local function disableHeadlights(veh)
	if not SVMOD.CFG.Lights.TurnOffHeadlightsOnExit then
		return
	elseif not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Create("SV_DisableHeadlights_" .. veh:EntIndex(), SVMOD.CFG.Lights.TimeTurnOffHeadlights, 1, function()
		if not SVMOD:IsVehicle(veh) then
			return
		end

		veh:SV_TurnOffHeadlights()
	end)
end

hook.Add("PlayerLeaveVehicle", "SV_DisableHeadlightsOnLeave", function(ply, veh)
	disableHeadlights(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableHeadlightsOnDisconnect", function(ply)
	local veh = ply:GetVehicle()

	disableHeadlights(veh)
end)

hook.Add("PlayerEnteredVehicle", "SV_UndoDisableHeadlightsOnLeave", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Remove("SV_DisableHeadlights_" .. veh:EntIndex())
end)