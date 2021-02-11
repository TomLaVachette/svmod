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

function ENT:DropPistol()
	if IsValid(self.FillerPistol) then
		local ply = self.FillerPistol:GetOwner()

		if IsValid(ply) then
			ply:StripWeapon("sv_fillerpistol")
			if ply.SV_WeaponBeforePickUpFiller then
				ply:SelectWeapon(ply.SV_WeaponBeforePickUpFiller)
				ply.SV_WeaponBeforePickUpFiller = nil
			end

			ply:EmitSound("svmod/fuel/pick-up.wav")
		end
	end

	self.FillerPistol = nil

	if IsValid(self.Rope) then
		self.Rope:Remove()
	end

	timer.Remove("SV_GasPump_" .. self:EntIndex())
end

function ENT:Use(ply)
	if IsValid(self.FillerPistol) then
		if self.FillerPistol:GetOwner() == ply then
			self:DropPistol()
		end
	else
		if IsValid(ply:GetActiveWeapon()) then
			ply.SV_WeaponBeforePickUpFiller = ply:GetActiveWeapon():GetClass()
		end

		if ply:HasWeapon("sv_fillerpistol") then
			return
		end

		self.FillerPistol = ply:Give("sv_fillerpistol")
		self.FillerPistol:SetNWEntity("SV_FuelPump", self)
		
		ply:SelectWeapon("sv_fillerpistol")

		ply:EmitSound("svmod/fuel/pick-up.wav")

		local a, b = self:GetModelBounds()
	
		self.Rope = constraint.Rope(
			ply,
			self,
			0,
			0,
			Vector(0, 6, 30),
			(b + a) / 2,
			250,
			0,
			1,
			1.5,
			"cable/cable2",
			false
		)

		ply.SV_CurrentFuelPump = self

		timer.Create("SV_GasPump_" .. self:EntIndex(), 2, 0, function()
			-- if not IsValid(ply) or self:GetPos():DistToSqr(ply:GetPos()) > 50000 then
			if not IsValid(self.Rope) then
				self:DropPistol()
			end
		end)
	end
end

function ENT:OnRemove()
	if IsValid(self.FillerPistol) then
		self.FillerPistol:Remove()
	end

	timer.Remove("SV_GasPump_" .. self:EntIndex())
end