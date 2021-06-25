--[[---------------------------------------------------------
   Name: SVMOD:SendNotification()
   Type: Client
   Desc: Sends a notification to a specific client.
   Note: This is an internal function, you should not use it.
-----------------------------------------------------------]]
util.AddNetworkString("SV_Notification")
function SVMOD:SendNotification(ply, text, type, length)
	net.Start("SV_Notification")
	net.WriteString(text)
	net.WriteUInt(type, 4)
	net.WriteUInt(length, 4)
	net.Send(ply)
end