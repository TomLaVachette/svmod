util.AddNetworkString("SV_HUDConfiguration")

function SVMOD:SendHUDConfiguration(ply)
	net.Start("SV_HUDConfiguration")
	net.WriteBool(SVMOD.CFG.Others.IsHUDEnabled)
	if SVMOD.CFG.Others.IsHUDEnabled then
		net.WriteFloat(SVMOD.CFG.Others.HUDPositionX)
		net.WriteFloat(SVMOD.CFG.Others.HUDPositionY)
		net.WriteUInt(SVMOD.CFG.Others.HUDSize, 9) -- max: 511
		net.WriteColor(SVMOD.CFG.Others.HUDColor)
	end

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

hook.Add("SV_Enabled", "SV_SendHUDConfiguration", function()
	SVMOD:SendHUDConfiguration()
end)