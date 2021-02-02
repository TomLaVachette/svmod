--[[---------------------------------------------------------
   Name: SVMOD:SetFlashingLightsState(int value = false)
   Type: Client
   Desc: Sets the state of the flashing lights of the vehicle
		 driven by the player.
-----------------------------------------------------------]]
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

net.Receive("SV_TurnFlashingLights", function()
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	local State = net.ReadBool()

	if State then
		Vehicle.SV_States.FlashingLights = true

		Vehicle:EmitSound("svmod/headlight/switch_on.wav")

		if Vehicle.SV_Data.Sounds.Siren and #Vehicle.SV_Data.Sounds.Siren > 0 then
			Vehicle.SV_FlashingLightSound = CreateSound(Vehicle, "svmod/siren/" .. Vehicle.SV_Data.Sounds.Siren .. ".wav")
			Vehicle.SV_FlashingLightSound:SetSoundLevel(75)
			Vehicle.SV_FlashingLightSound:Play()
			Vehicle.SV_FlashingLightSound:ChangePitch(100, 0)
			timer.Simple(0.1, function()
				if Vehicle.SV_FlashingLightSound then
					Vehicle.SV_FlashingLightSound:ChangeVolume(SVMOD.CFG.Sounds.Siren, 0)
				end
			end)
		end
	else
		Vehicle.SV_States.FlashingLights = false

		Vehicle:EmitSound("svmod/headlight/switch_off.wav")

		if Vehicle.SV_FlashingLightSound then
			Vehicle.SV_FlashingLightSound:Stop()
		end
	end
end)

hook.Add("SV_UnloadVehicle", "SV_TurnOffFlashingLightsOnRemove", function(veh)
	if veh.SV_FlashingLightSound then
		veh.SV_FlashingLightSound:Stop()
	end
end)