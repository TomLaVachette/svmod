hook.Add("Initialize", "SV_LoadConfiguration", function()
	-- Load the configuration
	SVMOD:Load()
end)

hook.Add("SV_Enabled", "SV_PrintConsole", function()
	if SERVER then
		SVMOD:PrintConsole(SVMOD.LOG.Info, "Addon enabled server-side.")
	else -- CLIENT
		SVMOD:PrintConsole(SVMOD.LOG.Info, "Addon enabled client-side.")
	end
end)

hook.Add("SV_Disabled", "SV_PrintConsole", function()
	if SERVER then
		SVMOD:PrintConsole(SVMOD.LOG.Info, "Addon disabled server-side.")
	else -- CLIENT
		SVMOD:PrintConsole(SVMOD.LOG.Info, "Addon disabled client-side.")
	end
end)

--[[---------------------------------------------------------
   Name: SVMOD:GetAddonState()
   Type: Shared
   Desc: Returns true if SVMod is enabled, false otherwise.
   Note: Can return nil if the addon does not yet know its
		 status.
-----------------------------------------------------------]]
function SVMOD:GetAddonState()
	if SERVER then
		-- From the configuration file
		return self.CFG.IsEnabled
	else -- CLIENT
		-- Given by the server, can be nil
		return self.IsEnabled
	end
end