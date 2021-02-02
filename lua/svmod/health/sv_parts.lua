--[[---------------------------------------------------------
   Name: Vehicle:SV_SendParts()
   Type: Server
   Desc: Sends the health parts of the vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_SendParts(ply)
	net.Start("SV_Parts")

	net.WriteEntity(self)

	-- Number of parts
	net.WriteUInt(#self.SV_Data.Parts, 4) -- max: 15

	-- Health of each part
	for _, v in ipairs(self.SV_Data.Parts) do
		net.WriteUInt(v.Health, 7)
	end

	net.Send(ply)
end