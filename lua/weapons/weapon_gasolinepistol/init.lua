include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function SWEP:Equip(ply)
	local pump = ply.SV_CurrentFuelPump
	if not IsValid(pump) then
		self:Remove()
		return
	elseif pump:GetPos():DistToSqr(ply:GetPos()) > 50000 then
		self:Remove()
		return
	end

	local a, b = pump:GetModelBounds()

	local pumpPos = pump:GetPos()

	self.Rope = constraint.CreateKeyframeRope(
		pumpPos,
		1,
		"cable/cable2",
		nil,
		pump,
		(b + a) / 2,
		0,
		ply,
		Vector(0, 6, 30),
		0,
		{
			Length = 250,
			Collide = 1
		}
	)

	timer.Create("SV_FillerPistol_" .. self:EntIndex(), 1, 0, function()
		if not IsValid(self.Rope) or ply:GetPos():DistToSqr(pumpPos) > 50000 then
			self:Remove()
		end
	end)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)

	local trace = self:GetOwner():GetEyeTrace()

	local ent = trace.Entity

	if SVMOD:IsVehicle(ent) then
		for i, v in ipairs(ent.SV_Data.Fuel.GasTank) do
			if trace.HitPos:DistToSqr(ent:LocalToWorld(ent.SV_Data.Fuel.GasTank[i].GasolinePistol.Position)) < 400 then
				self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

				timer.Simple(0.45, function()
					if not IsValid(self) then
						return
					end

					if self:GetOwner().SV_WeaponBeforePickUpFiller then
						self:GetOwner():SelectWeapon(self:GetOwner().SV_WeaponBeforePickUpFiller)
					end

					self:Remove()

					if not IsValid(ent) then
						return
					end

					local fillerPistol = ents.Create("sv_gasolinepistol")
					fillerPistol:AttachVehicle(ent, self:GetOwner(), i)
					fillerPistol:Spawn()
					fillerPistol:SpawnRope()
				end)
			end
		end
	elseif ent == self:GetOwner().SV_CurrentFuelPump then
		self:Remove()
	end
end

function SWEP:OnRemove()
	timer.Remove("SV_FillerPistol_" .. self:EntIndex())

	if IsValid(self.Rope) then
		self.Rope:Remove()
	end
end