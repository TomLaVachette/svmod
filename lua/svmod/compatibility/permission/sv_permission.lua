hook.Add("InitPostEntity", "SV_RegisterCAMIPrivilege", function()
    CAMI.RegisterPrivilege{
        Name = "SV_UseCommands",
        MinAccess = "admin"
    }

    CAMI.RegisterPrivilege{
        Name = "SV_EditOptions",
        MinAccess = "admin"
    }
end)