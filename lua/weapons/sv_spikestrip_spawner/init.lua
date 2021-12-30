AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)
	if trace.Hit and trace.HitNormal.z > 0.95 then
		local spikestrip = ents.Create("sv_spikestrip")
		spikestrip:SetPos(trace.HitPos)
		spikestrip:SetAngles( Angle(0,90 + self:GetAngles().y,0) )
		spikestrip:Spawn()
		self:Remove()
		self:SetNextPrimaryFire(CurTime() + 1)
	end
end