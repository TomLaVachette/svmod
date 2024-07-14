AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SV_PlacingSpikeStrip")

function SWEP:PrimaryAttack()
	if self.IsPlacingSpikeStrip then
		return
	end

	local owner = self:GetOwner()

	local trace = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + 200 * owner:GetAimVector(),
		filter = { owner }
	})

	if trace.HitWorld and trace.HitNormal.z > 0.95 then
		if hook.Run("SV_PlayerCanPlaceSpikeStrip", owner, spikestrip) == false then
			return
		end

		self:SetNextPrimaryFire(CurTime() + 1)

		self.IsPlacingSpikeStrip = true

		local ent = self
		local pos = trace.HitPos
		local ang = Angle(0, owner:GetAngles().y, 0)

		local function deploySpikeTrip()
			local spikestrip = ents.Create("sv_spikestrip")
			spikestrip:SetPos(pos)
			spikestrip:SetAngles(ang)
			spikestrip:Spawn()

			hook.Run("SV_PlayerPlacedSpikeStrip", owner, spikestrip)

			ent:Remove()
		end

		if SVMOD.CFG.Others.TimeDeploySpikeStrips == 0 then
			deploySpikeTrip()
		else
			owner:Freeze(true)

			net.Start("SV_PlacingSpikeStrip")
			net.WriteUInt(SVMOD.CFG.Others.TimeDeploySpikeStrips, 5) -- max: 31
			net.Send(owner)

			timer.Simple(SVMOD.CFG.Others.TimeDeploySpikeStrips, function()
				if not IsValid(owner) then
					return
				end

				owner:Freeze(false)

				if not IsValid(ent) then
					return
				end

				deploySpikeTrip()
			end)
		end
	else
		-- Avoid spamming
		self:SetNextPrimaryFire(CurTime() + 0.1)
	end
end

function SWEP:Holster(weapon)
	if game.SinglePlayer() then
		self:CallOnClient("Holster")
	end
	return true
end