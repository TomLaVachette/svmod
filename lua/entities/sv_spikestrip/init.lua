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

local nextTouchCheck = 0

function ENT:Touch(ent)
	if CurTime() < nextTouchCheck then return end
	nextTouchCheck = CurTime() + 0.1
	if ent:GetClass() == "prop_vehicle_jeep" and SVMOD:IsVehicle(ent) then
		for _, part in ipairs(ent.SV_Data.Parts) do
			if part.WheelID then
				local wheelPos = ent:LocalToWorld(part.Position)
				local trace = util.TraceHull({
					start = wheelPos,
					endpos = wheelPos + Vector(0, 0, -50),
					filter = ent,
					maxs = Vector(30, 30, 30),
					mins = Vector(-30, -30, -30),
					ignoreworld = true
				})
				if trace.Entity == self then
					ent:SV_StartPunctureWheel(part.WheelID, 1)
				end
			end
		end
	end
end

function ENT:StartTouch(entity)
	if IsValid(entity) and entity:IsPlayer() then
		entity:TakeDamage(5, self, self)
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