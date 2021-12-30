AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/novacars/spikestrip/spikestrip.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
end

function ENT:Touch(ent)
	if ent:GetClass() == "prop_vehicle_jeep" and SVMOD:IsVehicle(ent) then
		for _, part in ipairs(ent.SV_Data.Parts) do
			if part.WheelID then
				local wheelPos = ent:LocalToWorld(part.Position)
				local trace = util.TraceLine({
					start = wheelPos,
					endpos = wheelPos + Vector(0, 0, -50),
					filter = ent
				})
				if trace.Entity == self then
					ent:SV_DealDamageToWheel(part.WheelID, 50)
				end
			end
		end
	end
end

function ENT:Use(ent)
	-- This "Used" prevent duplication. ENTITY:Use can be called multiple time per tick.
	if self.Used then return end
	self.Used = true
	if IsValid(ent) then
		self:Remove()
		ent:Give("sv_spikestrip_spawner")
	end
	self.Used = false
end