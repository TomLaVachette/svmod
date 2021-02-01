local function WriteRecursive(tab, isSuperAdmin)
    for k, v in pairs(tab) do
        if k == "Write" then
            v(tab)
        elseif (not tab.SuperAdminOnly or isSuperAdmin) and istable(v) then
            WriteRecursive(v, isSuperAdmin)
        end
    end
end

util.AddNetworkString("SV_Menu_Open")
net.Receive("SV_Menu_Open", function(_, ply)
    net.Start("SV_Menu_Open")

    WriteRecursive(SVMOD.Menu, ply:IsSuperAdmin())

    net.Send(ply)
end)

local ReadTypes = {
    [0] = net.ReadBool,
    [1] = net.ReadFloat
}

util.AddNetworkString("SV_Editor_Set")
net.Receive("SV_Editor_Set", function(_, ply)
    if not ply:IsSuperAdmin() then return end

    local Category = net.ReadString()
    local Name = net.ReadString()
    local Type = net.ReadUInt(2)
    
    SVMOD.CFG[Category][Name] = ReadTypes[Type]()

    SVMOD:Save()
end)