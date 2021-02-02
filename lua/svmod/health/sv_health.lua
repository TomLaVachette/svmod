hook.Add("SV_LoadVehicle", "SV_LoadVehicle_Health", function(veh)
	veh:SetMaxHealth(100)
	veh:SetHealth(100)

	if veh.SV_Data.Parts then
		for _, p in ipairs(veh.SV_Data.Parts) do
			p.Health = 100
		end
	end
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

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_SetHealth(number value)
   Type: Server
   Desc: Sets the vehicle health.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_SetHealth(value)
	local Vehicle = self
	if self:SV_IsPassengerSeat() then
		Vehicle = self:SV_GetDriverSeat()
	end

	if not Vehicle.SV_Data.Parts or #Vehicle.SV_Data.Parts == 0 then return end

	value = math.Round(math.Clamp(value, 0, Vehicle:SV_GetMaxHealth()), 2)

	local CurrentHealth = Vehicle:SV_GetHealth()
	local Count = #Vehicle.SV_Data.Parts
	local Left = CurrentHealth - value
	local MaxIte = 100

	if value == CurrentHealth then
		return
	elseif value == 100 then
		for _, p in ipairs(Vehicle.SV_Data.Parts) do
			p.Health = 100
		end
	elseif value == 0 then
		for _, p in ipairs(Vehicle.SV_Data.Parts) do
			p.Health = 0
		end
	elseif value < CurrentHealth then
		while MaxIte > 0 and Left > 0 do
			local Random = math.random(1, Count)
			Vehicle.SV_Data.Parts[Random].Health = math.Clamp(Vehicle.SV_Data.Parts[Random].Health - Count, 0, 100)
			if Vehicle.SV_Data.Parts[Random].Health > 0 then
				Left = Left - 1
			end
			MaxIte = MaxIte - 1
		end
	else
		while MaxIte > 0 and Left > 0 do
			local Random = math.random(1, Count)
			Vehicle.SV_Data.Parts[Random].Health = math.Clamp(Vehicle.SV_Data.Parts[Random].Health + Count, 0, 100)
			if Vehicle.SV_Data.Parts[Random].Health < 100 then
				Left = Left - 1
			end
			MaxIte = MaxIte - 1
		end
	end

	Vehicle:SetHealth(value)

	if Vehicle:SV_GetHealth() == 0 then
		if not Vehicle.SV_IsExploded then
			Vehicle:StopParticles()
			
			Vehicle:EmitSound("ambient/fire/ignite.wav", 100)

			ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN_FOLLOW, Vehicle, 0)
			Vehicle:EmitSound("fire_med_loop1", 75)

			Vehicle.SV_IsExploded = true

			Vehicle:SV_SetFuel(0)

			timer.Simple(5, function()
				if not SVMOD:IsVehicle(Vehicle) then return end

				Vehicle:StopSound("fire_med_loop1")

				local Driver = Vehicle:SV_GetDriverSeat():GetDriver()

				for _, ply in ipairs(Vehicle:SV_GetAllPlayers()) do
					ply:GetVehicle():SV_ExitVehicle(ply)

					local Position = Vehicle:GetPos()
					local Angle = math.random(1,359)
					Position.x = Position.x + 10 * math.cos(Angle)
					Position.y = Position.y + 10 * math.sin(Angle)
					Position.z = Position.z + 50
					ply:SetPos(Position)
				end

				util.BlastDamage(Vehicle, Vehicle, Vehicle:GetPos(), 300, 200)
				Vehicle:EmitSound("ambient/explosions/explode_1.wav", 100)

				Vehicle:SetHandbrake(false)
				
				if math.random(1, 100) < (SVMOD.CFG.Damage.CarbonisedChance * 100) then
					Vehicle:Remove()
					
					local CarbonisedVehicle = ents.Create("prop_physics")
					CarbonisedVehicle:SetModel(Vehicle:GetModel())
					CarbonisedVehicle:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
					CarbonisedVehicle:SetColor(Color(115, 115, 115, 255))
					CarbonisedVehicle:SetPos(Vehicle:GetPos())
					CarbonisedVehicle:SetAngles(Vehicle:GetAngles())
					CarbonisedVehicle:Spawn()

					if not hook.Run("SV_ExplodedVehicle", Vehicle) then
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
						if IsValid(Vehicle) then
							Vehicle:StopParticles()
						end
					end)

					hook.Run("SV_ExplodedVehicle", Vehicle)
				end
			end)
		end
	elseif Vehicle:SV_GetHealth() < (SVMOD.CFG.Damage.SmokePercent * 100) then
		if not Vehicle.SV_IsSmoking then
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, Vehicle, 0)
			Vehicle:EmitSound("ambient/fire/ignite.wav", 100)

			-- Slow the vehicle
			-- Vehicle:SetMaxThrottle(0.3)

			Vehicle.SV_IsSmoking = true
		end
	else
		Vehicle.SV_IsExploded = false
		if Vehicle.SV_IsSmoking then
			Vehicle:StopParticles()

			Vehicle.SV_IsSmoking = false
		end
	end
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_SetMaxHealth(number value)
   Type: Server
   Desc: Sets the vehicle max health.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_SetMaxHealth(value)
	self:SetMaxHealth(value)
end

hook.Add("SV_LoadVehicle", "SV_InitCrashDamageHook", function(veh)
	if not veh:SV_IsDriverSeat() then return end

	veh:AddCallback("PhysicsCollide", function(ent, data)
		if not SVMOD:IsVehicle(ent) then
			return
		elseif data.Speed < 300 or data.DeltaTime < 1 then
			return
		elseif data.HitNormal.z < -0.9 then -- Avoid random damages
			return
		end

		if IsValid(data.HitEntity) then
			if data.HitEntity:IsPlayer() or data.HitEntity:IsPlayerHolding() then
				return
			end
		elseif ent:IsPlayerHolding() then
			return
		end

		local Health = math.Round(data.Speed * 0.02 * SVMOD.CFG.Damage.PhysicsMultiplier)

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
					DInfo:SetDamage(Health)
					DInfo:SetDamageType(DMG_VEHICLE)
					passengerSeat:GetDriver():TakeDamageInfo(DInfo)
				end
			end
		end

		ent:SV_SetHealth(ent:SV_GetHealth() - Health)

		ent:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1,3) .. ".wav")
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
	if totalDamage < 0.1 then -- Fix for GMod doing shit on the damage
		totalDamage = totalDamage * 10000
	end

	local totalDamage = math.floor(math.max(1, totalDamage * SVMOD.CFG.Damage.BulletMultiplier / 2))

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

	ent:SV_SetHealth(ent:SV_GetHealth() - totalDamage)
end)

hook.Add("SV_ExitVehicle", "SV_DealDamageOnLeave", function(ply, veh)
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