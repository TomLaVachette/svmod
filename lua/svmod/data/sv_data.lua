util.AddNetworkString("SV_UpdateData")
net.Receive("SV_UpdateData", function(_, ply)
    if not ply:IsSuperAdmin() then return end

    SVMOD:Data_Update()
end)