-- A player starts a car repair
net.Receive("SV_StartRepair", function()
    local Vehicle = net.ReadEntity()
    if not IsValid(Vehicle) then return end

    local Index = net.ReadUInt(4)

    local Player = net.ReadEntity()
    if not IsValid(Player) then return end

    if not Vehicle.SV_Data or not Vehicle.SV_Data.Parts then return end

    local PartCount = #Vehicle.SV_Data.Parts
    local Part = Vehicle.SV_Data.Parts[Index]
    if not Part then return end

    Player:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)

    timer.Create("SV_RepairVehicle_" .. Player:UserID(), 1, 0, function()
        Part.Health = math.min(100, math.floor(Part.Health + (2.5 * PartCount)))

        Player:EmitSound("svmod/repair/wrench" .. math.random(1, 4) .. ".wav", 60)
        
        if Part.Health >= 100 then
            timer.Remove("SV_RepairVehicle_" .. Player:UserID())
        end
    end)
end)

net.Receive("SV_StopRepair", function()
    local Player = net.ReadEntity()
    if not IsValid(Player) then return end

    timer.Remove("SV_RepairVehicle_" .. Player:UserID())
end)