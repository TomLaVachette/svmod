AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.EnablePhysgun = false

function ENT:Initialize()
	self:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	-- self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	
	-- self:GetPhysicsObject():Sleep()
	-- self:GetPhysicsObject():EnableMotion(false)
end

function ENT:StartTouch(ent)
	print(ent)
end