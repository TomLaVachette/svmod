-- @class SVMOD
-- @clientside

-- Enables or disables SVMod on the server.
-- @tparam boolean result True to enable, false to disable
function SVMOD:SetAddonState(value)
	if not value then
		value = false
	end

	net.Start("SV_SetAddonState")
	net.WriteBool(value)
	net.SendToServer()
end

hook.Add("InitPostEntity", "SV_GetAddonStateOnInitialSpawn", function()
	SVMOD:Load()
	net.Start("SV_GetAddonState")
	net.SendToServer()
end)

net.Receive("SV_SetAddonState", function()
	local state = net.ReadBool()

	if state == SVMOD.IsEnabled then
		return
	end

	SVMOD.IsEnabled = state

	HTTP({
		url = "https://api.svmod.com/get_version.php",
		method = "GET",
		parameters = {
			server = game.GetIPAddress()
		},
		success = function(code, body)
			if code == 200 then
				SVMOD.FCFG.LastVersion = body
			end
		end
	})

	if SVMOD.IsEnabled then
		SVMOD.CFG.Contributor.EnterpriseID = net.ReadUInt(16) -- max: 65535
		hook.Run("SV_Enabled")
	else
		hook.Run("SV_Disabled")
	end
end)