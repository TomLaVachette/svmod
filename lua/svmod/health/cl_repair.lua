-- A player starts a car repair
net.Receive("SV_StartRepair", function()
	local veh = net.ReadEntity()
	if not IsValid(veh) then return end

	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	ply:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)

	timer.Create("SV_RepairVehicle_" .. ply:UserID(), 1, 0, function()
		if IsValid(ply) then
			ply:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)
		end
	end)
end)

net.Receive("SV_StopRepair", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	timer.Remove("SV_RepairVehicle_" .. ply:UserID())
end)