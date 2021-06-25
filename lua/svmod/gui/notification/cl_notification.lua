net.Receive("SV_Notification", function()
	notification.AddLegacy(net.ReadString(), net.ReadInt(4), net.ReadInt(4))
end)