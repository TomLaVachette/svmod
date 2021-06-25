include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function SWEP:PrimaryAttack()
	local ent = self.Owner:GetEyeTrace().Entity
	if not IsValid(ent) then
		return
	end

	local ply = self:GetOwner()

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			if SVMOD:AddFuelPump(ent) then
				SVMOD:SendNotification(ply, "Fuel pump added.", 0, 5)
			else
				SVMOD:SendNotification(ply, "Already a fuel pump.", 1, 5)
			end
		end
	end)
end

function SWEP:SecondaryAttack()
	local ent = self:GetOwner():GetEyeTrace().Entity
	if not IsValid(ent) or self.Owner:GetPos():DistToSqr(ent:GetPos()) > 300000 then
		return
	end

	local ply = self:GetOwner()

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			if SVMOD:DeleteFuelPump(ent) then
				SVMOD:SendNotification(ply, "Fuel pump deleted.", 0, 5)
			else
				SVMOD:SendNotification(ply, "Error occurred.", 1, 5)
			end
		end
	end)
end

function SWEP:Reload()
	if CurTime() < (self.NextReload or 0) then
		return
	end

	self.NextReload = CurTime() + 0.5

	local ent = self:GetOwner():GetEyeTrace().Entity
	if not IsValid(ent) or self.Owner:GetPos():DistToSqr(ent:GetPos()) > 300000 then
		return
	end

	local fuelData = SVMOD:GetFuelPumpByEnt(ent)
	if not fuelData then
		return
	end

	net.Start("SV_Settings_SetPriceFuelPump")
	net.WriteEntity(ent)
	net.WriteUInt(fuelData.Price, 9) -- max: 511
	net.Send(self:GetOwner())
end