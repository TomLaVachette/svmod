-- @class SVMOD
-- @clientside

-- Sets the horn state of the vehicle driven by the player.
-- @tparam boolean result True for honking
function SVMOD:SetHornState(value)
	local Vehicle = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

	if not value then
		value = false
	end

	net.Start("SV_SetHornState")
	net.WriteBool(value)
	net.SendToServer()
end

net.Receive("SV_TurnHorn", function()
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	local State = net.ReadBool()

	if State then
		Vehicle.SV_States.Horn = true

		Vehicle.SV_HornSound = CreateSound(Vehicle, "svmod/horn/" .. (Vehicle.SV_Data.Sounds.Horn or "normal") .. ".wav")
		Vehicle.SV_HornSound:SetSoundLevel(75)
		Vehicle.SV_HornSound:Play()
		Vehicle.SV_HornSound:ChangePitch(100, 0)
		timer.Simple(0.1, function()
			if Vehicle.SV_HornSound then
				Vehicle.SV_HornSound:ChangeVolume(SVMOD.CFG.Sounds.Horn * 2, 0)
			end
		end)

	else
		Vehicle.SV_States.Horn = false

		if Vehicle.SV_HornSound then
			Vehicle.SV_HornSound:Stop()
		end
	end
end)