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

function ENT:Use( activator, caller )
end

function ENT:Think()
end

function ENT:Touch(ent)
	if ent:GetClass() == "prop_vehicle_jeep" and SVMOD:IsVehicle(ent) then
		for wheel = 0, ent:GetWheelCount() do
			if ent:GetWheelContactPoint(wheel):Distance( self:GetTouchTrace().HitPos ) < 50 then
				ent:SV_DealDamageToWheel(wheel + 1, math.random(40,80))
			end
		end
	end
end

function ENT:Use(ent)

	if IsValid(ent) then
		self:Remove()
		ent:Give("sv_spikestrip_spawner")
	end
end