-- A player starts a car repair
net.Receive("SV_StartRepair", function()
	local veh = net.ReadEntity()
	if not IsValid(veh) then return end

	local index = net.ReadUInt(4)

	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	if not veh.SV_Data or not veh.SV_Data.Parts then return end

	local PartCount = #veh.SV_Data.Parts
	local Part = veh.SV_Data.Parts[index]
	if not Part then return end

	ply:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)

	timer.Create("SV_RepairVehicle_" .. ply:UserID(), 1, 0, function()
		Part.Health = math.min(100, math.floor(Part.Health + (2.5 * PartCount)))

		ply:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)
		
		if Part.Health >= 100 then
			timer.Remove("SV_RepairVehicle_" .. ply:UserID())
		end
	end)
end)

net.Receive("SV_StopRepair", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	timer.Remove("SV_RepairVehicle_" .. ply:UserID())
end)