AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SV_StartFilling")
util.AddNetworkString("SV_StopFilling")

ENT.EnablePhysgun = false

function ENT:Initialize()
	self:SetModel("models/kaesar/kaesar_weapons/w_petrolgun.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)

	local entIndex = self:EntIndex()
	local timerName = "SV_FillerPistol_" .. entIndex

	local function stopTimer()
		timer.Remove(timerName)
		self:StopSound("svmod/fuel/fill-up.wav")
	end

	timer.Create(timerName, 4, 0, function()
		local veh = self:GetParent()

		if not SVMOD:IsVehicle(veh) or not IsValid(self.Player) then
			self:Remove()
		else
			if veh:SV_GetFuel() == veh:SV_GetMaxFuel() then
				stopTimer()
				return
			end

			local function callback()
				veh:SV_SetFuel(veh:SV_GetFuel() + veh:SV_GetMaxFuel() * 0.21)
				veh:SV_SendFuel(self.Player)
			end

			local result = hook.Run("SV_PayFuelPump", self.Player, self.Price)

			if result == true then
				callback()
			elseif result == false then
				stopTimer()
			else -- nil
				local name = gmod.GetGamemode().Name

				if name == "DarkRP" then
					local money = self.Player:getDarkRPVar("money")

					if money >= self.Price then
						self.Player:addMoney(self.Price * -1)
						callback()
					else
						stopTimer()
					end
				else
					callback()
				end
			end
		end
	end)

	local pumpPos = self.Pump:GetPos()

	timer.Create("SV_FillerPistolRope_" .. entIndex, 1, 0, function()
		if not IsValid(self.Rope) or not IsValid(self.Player) or self.Player:GetPos():DistToSqr(pumpPos) > 50000 then
			hook.Run("SV_FillerPistolRopeDestroyed", self:GetParent(), self.Player, self.Pump)
			self:Remove()
		end
	end)
end

function ENT:Use(ply)
	if not ply:HasWeapon("weapon_gasolinepistol") then
		self:Remove()

		if IsValid(ply:GetActiveWeapon()) then
			ply.SV_WeaponBeforePickUpFiller = ply:GetActiveWeapon():GetClass()
		end

		ply:Give("weapon_gasolinepistol")
		ply:SelectWeapon("weapon_gasolinepistol")
	end
end

function ENT:AttachVehicle(veh, ply, index)
	local pumpData = SVMOD:GetFuelPumpByEnt(ply.SV_CurrentFuelPump)
	if not pumpData then
		pumpData = { Price = 0 }
		if IsValid(ply.SV_CurrentFuelPump) then
			SVMOD:PrintConsole(SVMOD.LOG.Error, "Fuel pump (ID: " .. ply.SV_CurrentFuelPump:EntIndex() .. ") does not have a configuration.")
		end
	end

	for _, ent in ipairs(veh:GetChildren()) do
		if ent:GetClass() == "sv_gasolinepistol" then
			self:Remove()
			return
		end
	end

	self:SetParent(veh)
	self:SetPos(veh:LocalToWorld(veh.SV_Data.Fuel.GasTank[index].GasolinePistol.Position))
	self:SetAngles(veh:LocalToWorldAngles(veh.SV_Data.Fuel.GasTank[index].GasolinePistol.Angles))

	self.Player = ply
	self.Pump = ply.SV_CurrentFuelPump
	self.Price = pumpData.Price

	if veh:SV_GetFuel() < veh:SV_GetMaxFuel() then
		self:EmitSound("svmod/fuel/fill-up.wav", 75, 100, 2)
	end

	veh:SV_SendFuel(ply)

	net.Start("SV_StartFilling")
	net.WriteEntity(veh)
	net.Send(ply)
end

function ENT:SpawnRope()
	if not self.Pump then
		return
	end

	local a, b = self.Pump:GetModelBounds()

	local pumpPos = self.Pump:GetPos()

	self.Rope = constraint.CreateKeyframeRope(
		pumpPos,
		1,
		"cable/cable2",
		nil,
		pump,
		(b + a) / 2,
		0,
		self,
		Vector(3.5, 1, -3),
		0,
		{
			Length = 250,
			Collide = 1
		}
	)
end

function ENT:OnRemove()
	local entIndex = self:EntIndex()

	timer.Remove("SV_FillerPistol_" .. entIndex)
	timer.Remove("SV_FillerPistolRope_" .. entIndex)

	self:StopSound("svmod/fuel/fill-up.wav")

	if IsValid(self.Player) then
		net.Start("SV_StopFilling")
		net.WriteEntity(self:GetParent())
		net.Send(self.Player)
	end
end