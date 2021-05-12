hook.Add("InitPostEntity", "SV_RegisterCAMIPrivilege", function()
	CAMI.RegisterPrivilege{
		Name = "SV_UseCommands",
		MinAccess = "admin"
	}

	CAMI.RegisterPrivilege{
		Name = "SV_RepairVehicle", -- used when reload key is pressed with the wrench
		MinAccess = "admin"
	}

	CAMI.RegisterPrivilege{
		Name = "SV_EditOptions",
		MinAccess = "superadmin"
	}
end)