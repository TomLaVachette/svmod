AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.EnablePhysgun = false

function ENT:Initialize()
	self:SetModel("models/props_equipment/gas_pump.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	if not IsValid(self.Handle) then
		self.Handle = ents.Create("sv_handle")
		self.Handle:SetPos(self:LocalToWorld(Vector(10, 0, 40)))
		self.Handle:Spawn()
	
		self.rope = constraint.Rope(
			self.Handle,
			self,
			0,
			0,
			Vector(0, 6, 0),
			Vector(0, 0, 40),
			250,
			0,
			0,
			0.75,
			"cable/cable",
			false
		)
	end
end

function ENT:StartTouch(ent)
	if ent == self.Handle then
		ent:Remove()
		self.Handle = nil
	end
end

function ENT:OnRemove()
	if IsValid(self.Handle) then
		self.Handle:Remove()
	end
end