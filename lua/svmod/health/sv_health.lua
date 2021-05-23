-- @class SV_Vehicle
-- @serverside

hook.Add("SV_LoadVehicle", "SV_LoadVehicle_Health", function(veh)
	veh:SV_SetMaxHealth(100)
	veh:SV_SetHealth(100)

	veh:SV_SetWheelFLHealth(100)
	veh:SV_SetWheelFRHealth(100)
	veh:SV_SetWheelRLHealth(100)
	veh:SV_SetWheelRRHealth(100)
end)

hook.Add("PlayerEnteredVehicle", "SV_Health_StopEngine", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	-- Timer needed here because Source use the next frame to start the engine
	timer.Simple(FrameTime() * 4, function()
		-- Stop the engine if the vehicle is exploded
		if veh.SV_IsExploded then
			veh:EnableEngine(false)
			veh:StartEngine(false)
		end
	end)
end)

hook.Add("SV_UnloadVehicle", "SV_RemoveFireParticles", function(veh)
	veh:StopParticles()
end)

-- Sets the health of the vehicle.
-- @tparam number health New health value
function SVMOD.Metatable:SV_SetHealth(value)
	local veh = self
	if self:SV_IsPassengerSeat() then
		veh = self:SV_GetDriverSeat()
	end

	veh:SetNW2Int("SV_Health", math.Clamp(value, 0, veh:SV_GetMaxHealth()))

	if veh:SV_GetHealth() == 0 then
		if not veh.SV_IsExploded then
			veh:SV_TurnOffHeadlights()
			veh:SV_TurnOffLeftBlinker()
			veh:SV_TurnOffRightBlinker()
			veh:SV_TurnOffHazardLights()
			veh:SV_TurnOffFlashingLights()

			veh:StopParticles()

			veh:EmitSound("ambient/fire/ignite.wav", 100)

			ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN_FOLLOW, veh, 0)
			veh:EmitSound("fire_med_loop1", 75)

			veh.SV_IsExploded = true

			veh:SV_SetFuel(0)

			timer.Simple(5, function()
				if not SVMOD:IsVehicle(veh) then return end

				veh:StopSound("fire_med_loop1")

				for _, ply in ipairs(veh:SV_GetAllPlayers()) do
					ply:GetVehicle():SV_ExitVehicle(ply)

					local pos = veh:GetPos()
					local ang = math.random(1, 359)
					pos.x = pos.x + 10 * math.cos(ang)
					pos.y = pos.y + 10 * math.sin(ang)
					pos.z = pos.z + 50
					ply:SetPos(pos)
				end

				util.BlastDamage(veh, veh, veh:GetPos(), 300, 200)
				veh:EmitSound("ambient/explosions/explode_1.wav", 100)

				veh:SetHandbrake(false)

				if math.random(1, 100) < (SVMOD.CFG.Damage.CarbonisedChance * 100) then
					veh:Remove()

					local CarbonisedVehicle = ents.Create("prop_physics")
					CarbonisedVehicle:SetModel(veh:GetModel())
					CarbonisedVehicle:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
					CarbonisedVehicle:SetColor(Color(115, 115, 115, 255))
					CarbonisedVehicle:SetPos(veh:GetPos())
					CarbonisedVehicle:SetAngles(veh:GetAngles())
					CarbonisedVehicle:Spawn()

					if not hook.Run("SV_ExplodedVehicle", veh) then
						ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN_FOLLOW, CarbonisedVehicle, 0)
						CarbonisedVehicle:EmitSound("fire_med_loop1", 75)
						timer.Simple(10, function()
							CarbonisedVehicle:StopSound("fire_med_loop1")
						end)
					end

					CarbonisedVehicle:GetPhysicsObject():ApplyForceCenter(CarbonisedVehicle:GetUp() * 500000)

					timer.Simple(45, function()
						if IsValid(CarbonisedVehicle) then
							CarbonisedVehicle:Remove()
						end
					end)
				else
					timer.Simple(10, function()
						if IsValid(veh) then
							veh:StopParticles()
						end
					end)

					hook.Run("SV_ExplodedVehicle", veh)
				end
			end)
		end
	elseif veh:SV_GetHealth() < (SVMOD.CFG.Damage.SmokePercent * 100) then
		if not veh.SV_IsSmoking then
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, veh, 0)
			veh:EmitSound("ambient/fire/ignite.wav", 100)

			-- Slow the vehicle
			-- Vehicle:SetMaxThrottle(0.3)

			veh.SV_IsSmoking = true
		end
	else
		veh.SV_IsExploded = false
		if veh.SV_IsSmoking then
			veh:StopParticles()

			veh.SV_IsSmoking = false
		end
	end
end

-- Sets the maximum health of the vehicle.
-- @tparam number health New health value
function SVMOD.Metatable:SV_SetMaxHealth(value)
	self:SetNW2Int("SV_MaxHealth", value)
end

-- Repairs a vehicle.
function SVMOD.Metatable:SV_FullRepair()
	self:SV_SetHealth(self:SV_GetMaxHealth())
	self:SV_SetWheelFLHealth(100)
	self:SV_SetWheelFRHealth(100)
	self:SV_SetWheelRLHealth(100)
	self:SV_SetWheelRRHealth(100)
end

hook.Add("SV_LoadVehicle", "SV_InitCrashDamageHook", function(veh)
	if not veh:SV_IsDriverSeat() then return end

	veh:AddCallback("PhysicsCollide", function(ent, data)
		if not SVMOD:IsVehicle(ent) then
			return
		elseif data.Speed < 300 or data.DeltaTime < 1 then
			return
		elseif data.HitNormal.z < -0.9 then
			-- Avoid random damages
			return
		end

		if IsValid(data.HitEntity) then
			if data.HitEntity:IsPlayer() or data.HitEntity:IsPlayerHolding() then
				return
			end
		elseif ent:IsPlayerHolding() then
			return
		end

		local totalDamage = math.Round(data.Speed * 0.02 * SVMOD.CFG.Damage.PhysicsMultiplier)

		if data.Speed > 500 then
			for _, passengerSeat in ipairs(ent:SV_GetPassengerSeats()) do
				if IsValid(passengerSeat:GetDriver()) then
					local DInfo = DamageInfo()
					if IsValid(ent:SV_GetLastDriver()) then
						DInfo:SetAttacker(ent:SV_GetLastDriver())
					else
						DInfo:SetAttacker(game.GetWorld())
					end
					DInfo:SetInflictor(ent)
					DInfo:SetDamage(totalDamage)
					DInfo:SetDamageType(DMG_VEHICLE)
					passengerSeat:GetDriver():TakeDamageInfo(DInfo)
				end
			end
		end

		local nearestWheelID, _ = ent:SV_GetNearestWheel(ent:WorldToLocal(data.HitPos))

		ent:SV_SetHealth(ent:SV_GetHealth() - totalDamage)
		ent:SV_DealDamageToWheel(nearestWheelID, totalDamage * 0.5 * SVMOD.CFG.Damage.WheelCollisionMultiplier)

		ent:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1, 3) .. ".wav")
	end)
end)

hook.Add("EntityTakeDamage", "SV_VehicleDamage", function(ent, dmg)
	if not SVMOD:IsVehicle(ent) or not ent:SV_IsDriverSeat() then
		return
	end

	if dmg:GetInflictor() == ent then
		return
	end

	local totalDamage = dmg:GetDamage()
	if totalDamage < 0.1 then
		-- Fix for GMod doing shit on the damage
		totalDamage = totalDamage * 10000
	end

	totalDamage = math.floor(math.max(1, totalDamage * SVMOD.CFG.Damage.BulletMultiplier))

	-- Deal damage to the driver
	local driver = ent:GetDriver()
	if IsValid(driver) then
		local dInfo = DamageInfo()
		dInfo:SetAttacker(dmg:GetAttacker())
		dInfo:SetInflictor(dmg:GetInflictor())
		dInfo:SetDamage(math.Round(totalDamage * 0.5 * SVMOD.CFG.Damage.DriverMultiplier))
		dInfo:SetDamageType(DMG_VEHICLE)
		driver:TakeDamageInfo(dInfo)
	end

	-- Deal damage to passengers
	for _, passengerSeat in ipairs(ent:SV_GetPassengerSeats()) do
		if IsValid(passengerSeat:GetDriver()) then
			local dInfo = DamageInfo()
			dInfo:SetAttacker(dmg:GetAttacker())
			dInfo:SetInflictor(dmg:GetInflictor())
			dInfo:SetDamage(math.Round(totalDamage * 0.5 * SVMOD.CFG.Damage.PassengerMultiplier))
			dInfo:SetDamageType(DMG_VEHICLE)
			passengerSeat:GetDriver():TakeDamageInfo(dInfo)
		end
	end

	local nearestWheelID, nearestWheelDistance = ent:SV_GetNearestWheel(ent:WorldToLocal(dmg:GetDamagePosition()))

	if nearestWheelDistance < 800 then
		ent:SV_SetHealth(ent:SV_GetHealth() - totalDamage * 0.2)
		ent:SV_DealDamageToWheel(nearestWheelID, totalDamage * 0.8 * SVMOD.CFG.Damage.WheelShotMultiplier)
		ent:SV_StartPunctureWheel(nearestWheelID, SVMOD.CFG.Damage.TimeBeforeWheelIsPunctured) -- 0 to disable
	else
		ent:SV_SetHealth(ent:SV_GetHealth() - totalDamage * 0.8)
		ent:SV_DealDamageToWheel(nearestWheelID, totalDamage * 0.2 * SVMOD.CFG.Damage.WheelShotMultiplier)
	end
end)

hook.Add("SV_PlayerLeaveVehicle", "SV_DealDamageOnLeave", function(ply, veh)
	if not SVMOD.CFG.IsEnabled or not SVMOD:IsVehicle(veh) then
		return
	elseif ply.SV_IsSwitchingSeat then
		return
	end

	local speed = veh:SV_GetSpeed()
	if speed < 30 then
		return
	end

	local DInfo = DamageInfo()
	DInfo:SetAttacker(ply)
	DInfo:SetInflictor(veh)
	DInfo:SetDamage(math.Round(speed / 5 * SVMOD.CFG.Damage.PlayerExitMultiplier))
	DInfo:SetDamageType(DMG_VEHICLE)
	ply:TakeDamageInfo(DInfo)
end)