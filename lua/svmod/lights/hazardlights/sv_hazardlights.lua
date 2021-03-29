-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_TurnHazardLights")

-- Turns off the left blinker signals of a vehicle.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOnHazardLights()
	if #self.SV_Data.Blinkers.LeftLights == 0 and #self.SV_Data.Blinkers.RightLights == 0 then
		return false -- No blinkers on this vehicle
	elseif not SVMOD.CFG.Lights.AreHazardLightsEnabled then
		return false -- Hazard disabled
	elseif self:SV_GetHazardLightsState() then
		return false -- Hazard already active
	elseif not self.SV_IsEditMode and self:SV_GetHealth() == 0 then
		return false -- Vehicle destroyed
	end

	net.Start("SV_TurnHazardLights")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()

	self.SV_States.HazardLights = true

	return true
end

-- Turns on the left blinker signals of a vehicle.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOffHazardLights()
	if not self:SV_GetHazardLightsState() then
		return false -- Hazard already inactive
	end

	net.Start("SV_TurnHazardLights")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()

	self.SV_States.HazardLights = false
end

util.AddNetworkString("SV_SetHazardLightsState")
net.Receive("SV_SetHazardLightsState", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	local state = net.ReadBool()

	if state then
		veh:SV_TurnOnHazardLights()
	else
		veh:SV_TurnOffHazardLights()
	end
end)