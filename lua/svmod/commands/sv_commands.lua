concommand.Add("sv_givewrench", function(ply)
    if not ply:IsAdmin() then
        return
    end

    ply:Give("sv_wrench")
end)

concommand.Add("sv_lock", function(ply)
    if not ply:IsAdmin() then
        return
    end

    local Vehicle = ply:GetEyeTrace().Entity
    if not SVMOD:IsVehicle(Vehicle) then
        return
    end

    Vehicle:SV_Lock()
end)

concommand.Add("sv_unlock", function(ply)
    if not ply:IsAdmin() then
        return
    end

    local Vehicle = ply:GetEyeTrace().Entity
    if not SVMOD:IsVehicle(Vehicle) then
        return
    end

    Vehicle:SV_Unlock()
end)

concommand.Add("sv_repair", function(ply)
    if not ply:IsAdmin() then
        return
    end

    local Vehicle = ply:GetEyeTrace().Entity
    if not SVMOD:IsVehicle(Vehicle) then return end

    Vehicle:SV_SetHealth(100)
end)