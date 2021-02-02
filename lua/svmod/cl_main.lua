--[[---------------------------------------------------------
   Name: SVMOD:SetAddonState(boolean value = false)
   Type: Client
   Desc: Enables or disables SVMod on the server.
-----------------------------------------------------------]]
function SVMOD:SetAddonState(value)
	if not value then
		value = false
	end

	net.Start("SV_SetAddonState")
	net.WriteBool(value)
	net.SendToServer()
end

hook.Add("InitPostEntity", "SV_GetAddonStateOnInitialSpawn", function()
	net.Start("SV_GetAddonState")
	net.SendToServer()
end)

net.Receive("SV_SetAddonState", function()
	SVMOD.IsEnabled = net.ReadBool()

	http.Fetch("https://api.svmod.com/get_version.php", function(body, _, _, code)
		SVMOD.FCFG.LastVersion = body
	end)

	if SVMOD.IsEnabled then
		hook.Run("SV_Enabled")
	else
		hook.Run("SV_Disabled")
	end
end)