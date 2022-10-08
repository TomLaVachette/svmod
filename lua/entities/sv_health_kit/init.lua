AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.EnablePhysgun = false

function ENT:Initialize()
	self:SetModel("models/props_c17/tools_wrench01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:SetPos(self:GetPos() + Vector(0, 0, 10)) -- dirty quick fix
end

function ENT:StartTouch(ent)
	if not self.Disabled and SVMOD:IsVehicle(ent) then
		ent:SV_FullRepair() -- Fix the vehicle
		self.Disabled = true -- Protection to avoid applying health to several vehicles at the same time
		self:Remove() -- Remove the health kit
	end
end

function ENT:Use(ply)
	if not hook.Run("SV_UseHealthKit", self, ply) then
		self:Remove()
	end
end