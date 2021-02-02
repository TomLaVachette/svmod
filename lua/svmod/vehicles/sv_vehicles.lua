util.AddNetworkString("SV_GetVehicleStates")
net.Receive("SV_GetVehicleStates", function(_, ply)
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end

	if not veh.SV_States then return end

	if veh:SV_GetHeadlightsState() then
		net.Start("SV_TurnHeadlights")
		net.WriteEntity(veh)
		net.WriteBool(true)
		net.Send(ply)
	end

	if veh:SV_GetFlashingLightsState() then
		net.Start("SV_TurnFlashingLights")
		net.WriteEntity(veh)
		net.WriteBool(true)
		net.Send(ply)
	end
end)