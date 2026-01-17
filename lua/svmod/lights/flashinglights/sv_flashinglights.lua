-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_TurnFlashingLights")
util.AddNetworkString("SV_TurnFlashingSound")

-- Turns on the flashing lights and siren of the vehicle.
-- @treturn boolean True if the state was changed, false otherwise
function SVMOD.Metatable:SV_TurnOnFlashingLights()
	-- 1.5.2 -> 1.6.0: Keep the same behavior as 1.5.2
	return self:SV_SetFlashingLightsState(true, true)
end

-- Turns off the flashing lights and siren of the vehicle.
-- @treturn boolean True if the state was changed, false otherwise
function SVMOD.Metatable:SV_TurnOffFlashingLights()
	-- 1.5.2 -> 1.6.0: Keep the same behavior as 1.5.2
	return self:SV_SetFlashingLightsState(false, false)
end

-- Sets the state of the flashing lights and siren of the vehicle.
-- @tparam boolean flashingLightState True to enable the flashing lights, false to disable (default: true)
-- @tparam boolean sirenState True to enable the siren, false to disable (default: false)
-- @treturn boolean True if the state was changed, false otherwise
function SVMOD.Metatable:SV_SetFlashingLightsState(flashingLightState, sirenState)
	if not self.SV_IsEditMode and #self.SV_Data.FlashingLights == 0 then
		return false -- No flashing light on this vehicle
	elseif not SVMOD.CFG.ELS.AreFlashingLightsEnabled then
		return false -- Flashing lights disabled
	elseif not self.SV_IsEditMode and self:SV_GetHealth() == 0 then
		return false -- Vehicle destroyed
	end

	-- Default value (for editor mode, enable flashing lights only)
	if flashingLightState == nil then flashingLightState = true end
	if sirenState == nil then sirenState = false end

	if flashingLightState == self:SV_GetFlashingLightsState() and sirenState == self:SV_GetSirenState() then
		return false -- No change
	end

	net.Start("SV_TurnFlashingLights")
	net.WriteEntity(self)
	net.WriteBool(flashingLightState)
	net.WriteBool(sirenState)
	net.Broadcast()

	self.SV_States.FlashingLights = flashingLightState
	self.SV_States.Siren = sirenState

	return true
end

util.AddNetworkString("SV_SetFlashingLightsState")
net.Receive("SV_SetFlashingLightsState", function(_, ply)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	local flashingLightState = net.ReadBool()
	local sirenState = net.ReadBool()

	if hook.Run("SV_PlayerCanToggleFlashingLights", ply, veh, flashingLightState, sirenState) == false then
		return
	end

	veh:SV_SetFlashingLightsState(flashingLightState, sirenState)
end)

local function turnFlashingSound(veh, state)
	net.Start("SV_TurnFlashingSound")
	net.WriteEntity(veh)
	net.WriteBool(state)
	net.Broadcast()
end

local function disableFlashingLights(veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	if SVMOD.CFG.ELS.TurnOffFlashingLightsOnExit then
		timer.Create("SV_DisableFlashingLights_" .. veh:EntIndex(), SVMOD.CFG.ELS.TimeTurnOffFlashingLights, 1, function()
			if not SVMOD:IsVehicle(veh) then return end

			veh:SV_SetFlashingLightsState(false, false)
		end)

		timer.Create("SV_DisableFlashingSound_" .. veh:EntIndex(), SVMOD.CFG.ELS.TimeTurnOffSound, 1, function()
			if not SVMOD:IsVehicle(veh) then return end

			turnFlashingSound(veh, false)
		end)
	end
end

hook.Add("PlayerEnteredVehicle", "SV_EnableFlashingSoundOnEnter", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	if veh.SV_States.Siren then
		turnFlashingSound(veh, true)
	end
end)

hook.Add("PlayerLeaveVehicle", "SV_DisableFlashingLightsOnLeave", function(ply, veh)
	disableFlashingLights(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableFlashingLightsOnDisconnect", function(ply, veh)
	local veh = ply:GetVehicle()

	disableFlashingLights(veh)
end)

hook.Add("PlayerEnteredVehicle", "SV_UndoDisableFlashingLightsOnLeave", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Remove("SV_DisableFlashingLights_" .. veh:EntIndex())
	timer.Remove("SV_DisableFlashingSound_" .. veh:EntIndex())
end)