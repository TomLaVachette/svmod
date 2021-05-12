-- @class SVMOD
-- @clientside

-- Sets the state of the flashing lights of the vehicle
-- driven by the player.
-- @tparam boolean result True to enable the flashing lights, false to disable
function SVMOD:SetFlashingLightsState(value)
	local Vehicle = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

	if not value then
		value = false
	end

	net.Start("SV_SetFlashingLightsState")
	net.WriteBool(value)
	net.SendToServer()
end

local function startFlashingSound(veh)
	if veh.SV_Data.Sounds.Siren and #veh.SV_Data.Sounds.Siren > 0 then
		veh.SV_FlashingLightSound = CreateSound(veh, "svmod/siren/" .. veh.SV_Data.Sounds.Siren .. ".wav")
		veh.SV_FlashingLightSound:SetSoundLevel(75)
		veh.SV_FlashingLightSound:Play()
		veh.SV_FlashingLightSound:ChangePitch(100, 0)
		timer.Simple(0.1, function()
			if veh.SV_FlashingLightSound then
				veh.SV_FlashingLightSound:ChangeVolume(SVMOD.CFG.Sounds.Siren, 0)
			end
		end)
	end
end

local function stopFlashingSound(veh)
	if veh.SV_FlashingLightSound then
		veh.SV_FlashingLightSound:Stop()
	end
end

net.Receive("SV_TurnFlashingLights", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	local state = net.ReadBool()

	if state then
		veh.SV_States.FlashingLights = true
		veh:EmitSound("svmod/headlight/switch_on.wav")
		startFlashingSound(veh)
	else
		veh.SV_States.FlashingLights = false
		veh:EmitSound("svmod/headlight/switch_off.wav")
		stopFlashingSound(veh)
	end
end)

net.Receive("SV_TurnFlashingSound", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end

	local state = net.ReadBool()

	if state then
		startFlashingSound(veh)
	else
		stopFlashingSound(veh)
	end
end)

hook.Add("SV_UnloadVehicle", "SV_TurnOffFlashingLightsOnRemove", function(veh)
	stopFlashingSound(veh)
end)