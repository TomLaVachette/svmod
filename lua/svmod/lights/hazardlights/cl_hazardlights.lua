-- @class SVMOD
-- @clientside

-- Sets the state of the hazard lights of the vehicle
-- driven by the player.
-- @tparam boolean result True to enable the hazard lights, false to disable
function SVMOD:SetHazardLightsState(value)
	local Vehicle = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

	if not value then
		value = false
	end

	net.Start("SV_SetHazardLightsState")
	net.WriteBool(value)
	net.SendToServer()
end

net.Receive("SV_TurnHazardLights", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	veh.SV_States.HazardLights = net.ReadBool()

	if veh.SV_States.HazardLights then
		veh:EmitSound("svmod/blinker/switch_on.wav")
	else
		veh:EmitSound("svmod/blinker/switch_off.wav")
	end
end)