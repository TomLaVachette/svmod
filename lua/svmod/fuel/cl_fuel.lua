net.Receive("SV_SetFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_Fuel = net.ReadFloat()
	end
end)

net.Receive("SV_SetMaxFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_MaxFuel = net.ReadFloat()
	end
end)

net.Receive("SV_GetFuel", function()
	local Vehicle = net.ReadEntity()

	if SVMOD:IsVehicle(Vehicle) then
		Vehicle.SV_Fuel = net.ReadFloat()
		Vehicle.SV_MaxFuel = net.ReadFloat()
	end
end)