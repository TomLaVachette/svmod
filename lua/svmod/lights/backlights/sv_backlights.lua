-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_TurnBackLights")

-- Turns on the back lights of a vehicle.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOnBackLights()
	if not SVMOD.CFG.Lights.AreReverseLightsEnabled then
		return false -- Reverse lights disabled
	end

	net.Start("SV_TurnBackLights")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()

	self.SV_States.BackLights = true
end

-- Turns off the back lights of a vehicle.
-- @treturn boolean True if successful, false otherwise
function SVMOD.Metatable:SV_TurnOffBackLights()
	if not SVMOD.CFG.Lights.AreReverseLightsEnabled then
		return false -- Reverse lights disabled
	end

	net.Start("SV_TurnBackLights")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()

	self.SV_States.BackLights = false
end

-- Local function for redundant code
local function getVehicle(ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	return veh
end

-- Enable back lights
local cfg = SVMOD.CFG.Lights
hook.Add("KeyPress", "SV_BroadcastBackLightsEnabled", function(ply, key)
	if not cfg.AreReverseLightsEnabled then
		return -- Reverse lights disabled
	end

	if ply:KeyDown(IN_FORWARD) and not ply:KeyDown(IN_JUMP) then
		local veh = getVehicle(ply)

		if veh and veh:SV_GetBackLightsState() then
			veh:SV_TurnOffBackLights()
		end
	elseif key == IN_BACK or key == IN_JUMP then
		local veh = getVehicle(ply)

		if veh and not veh:SV_GetBackLightsState() then
			veh:SV_TurnOnBackLights()
		end
	end
end)

-- Disable back lights
hook.Add("KeyRelease", "SV_BroadcastBackLightsDisabled", function(ply, key)
	if key == IN_FORWARD then
		if ply:KeyDown(IN_BACK) or ply:KeyDown(IN_JUMP) then
			local veh = getVehicle(ply)

			if veh and not veh:SV_GetBackLightsState() then
				veh:SV_TurnOnBackLights()
			end
		end
	elseif key == IN_BACK or key == IN_JUMP then
		if not ply:KeyDown(IN_BACK) and not ply:KeyDown(IN_JUMP) then
			local veh = getVehicle(ply)

			if veh and veh:SV_GetBackLightsState() then
				veh:SV_TurnOffBackLights()
			end
		end
	end
end)

local function disableBackLights(veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	if veh:SV_GetBackLightsState() then
		veh:SV_TurnOffBackLights()
	end
end

-- Disable the back lights if they are activated when the player exits the vehicle
hook.Add("PlayerLeaveVehicle", "SV_DisableBackLightsOnLeave", function(ply, veh)
	disableBackLights(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableBackLightsOnDisconnect", function(ply)
	local veh = ply:GetVehicle()

	disableBackLights(veh)
end)