AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/novacars/spikestrip/spikestrip.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
end

function ENT:PunctureClosestWheels(veh)
	for _, part in ipairs(veh.SV_Data.Parts) do
		if part.WheelID then
			local distance = self:GetPos():DistToSqr(veh:LocalToWorld(part.Position))
			if distance < 20000 then
				veh:SV_StartPunctureWheel(part.WheelID, 1)
			end
		end
	end
end

function ENT:StartTouch(ent)
	if not IsValid(ent) then
		return
	end
	if ent:IsPlayer() then
		ent:TakeDamage(5, self, self)
	elseif SVMOD:IsVehicle(ent) then
		self:PunctureClosestWheels(ent)
	end
end

function ENT:EndTouch(ent)
	if SVMOD:IsVehicle(ent) then
		self:PunctureClosestWheels(ent)
	end
end

function ENT:Use(ply)
	-- This "Used" prevent duplication. ENTITY:Use can be called multiple time per tick.
	if self.Used then
		return
	end

	if not IsValid(ply) then
		return
	end

	if hook.Run("SV_PlayerCanPickupSpikeStrip", ply, self) == false then
		return
	end

	self.Used = true
	self:Remove()
	ply:Give("sv_spikestrip_spawner")
	ply:EmitSound("CW_HOLSTER")
end