-- @class SV_Vehicle
-- @shared

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

-- Gets the state of the SVMod.
--
-- Can return nil if the addon does not yet know its
-- status.
-- @treturn boolean True if enabled, false if disabled, nil if unknown.
-- @internal
function SVMOD:GetAddonState()
	if SERVER then
		-- From the configuration file
		return self.CFG.IsEnabled
	else -- CLIENT
		-- Given by the server, can be nil
		return self.IsEnabled
	end
end