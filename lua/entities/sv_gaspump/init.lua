AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.EnablePhysgun = false

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	if CurTime() < (self.NextFire or 0) then
		return
	end

	self.NextFire = CurTime() + 1

	if ply:HasWeapon("weapon_gasolinepistol") then
		if ply.SV_CurrentFuelPump == self then
			self:EmitSound("svmod/fuel/pick-up.wav")

			if ply:GetActiveWeapon():GetClass() == "weapon_gasolinepistol" and ply.SV_WeaponBeforePickUpFiller then
				ply:SelectWeapon(ply.SV_WeaponBeforePickUpFiller)
			end

			ply:StripWeapon("weapon_gasolinepistol")
		end
	elseif SVMOD:GetAddonState() then
		if IsValid(ply:GetActiveWeapon()) then
			ply.SV_WeaponBeforePickUpFiller = ply:GetActiveWeapon():GetClass()
		end

		ply.SV_CurrentFuelPump = self

		ply:Give("weapon_gasolinepistol")
		ply:SelectWeapon("weapon_gasolinepistol")

		self:EmitSound("svmod/fuel/pick-up.wav")
	end
end