util.AddNetworkString("SV_Settings_SetPriceFuelPump")
util.AddNetworkString("SV_Settings_GoToFuelPump")

SVMOD.FuelPumps = SVMOD.FuelPumps or {}

local function spawnPump(pos, ang, model)
	local newEnt = ents.Create("sv_gaspump")
	newEnt:SetPos(pos)
	newEnt:SetAngles(ang)
	newEnt:SetModel(model)
	newEnt:Spawn()

	local phys = newEnt:GetPhysicsObject()
	print(IsValid(phys))
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	return newEnt
end

hook.Add("InitPostEntity", "SV_SpawnFuelPump", function()
	SVMOD:Load()

	for _, pump in ipairs(SVMOD.CFG.Fuel.Pumps) do
		if pump.MapCreationID >= 0 then
			local ent = ents.GetMapCreatedEntity(pump.MapCreationID)

			if IsValid(ent) then
				local model = ent:GetModel()
				local pos = ent:GetPos()
				local ang = ent:GetAngles()

				ent:Remove()

				SVMOD.FuelPumps[spawnPump(pos, ang, model)] = pump
			end
		else
			SVMOD.FuelPumps[spawnPump(pump.Position, pump.Angles, pump.Model)] = pump
		end
	end

	SVMOD:PrintConsole(SVMOD.LOG.Info, #ents.FindByClass("sv_gaspump") .. " gas pump(s) created.")
end)

function SVMOD:GetFuelPumpByEnt(ent)
	return SVMOD.FuelPumps[ent]
end

function SVMOD:AddFuelPump(ent)
	if ent:GetClass() == "sv_gaspump" then
		return false
	end

	local model = ent:GetModel()
	local mapCreationID = ent:MapCreationID()
	local position = ent:GetPos()
	local angles = ent:GetAngles()

	SVMOD.CFG.Fuel.currentID = (SVMOD.CFG.Fuel.currentID or 0) + 1

	local i = table.insert(SVMOD.CFG["Fuel"]["Pumps"], {
		ID = SVMOD.CFG.Fuel.currentID,
		Model = model,
		MapCreationID = mapCreationID,
		Position = position,
		Angles = angles,
		Price = 0
	})
	SVMOD:Save()

	ent:EmitSound("garrysmod/balloon_pop_cute.wav")
	ent:Remove()

	timer.Simple(1, function()
		SVMOD.FuelPumps[spawnPump(position, angles, model)] = SVMOD.CFG["Fuel"]["Pumps"][i]
	end)

	return true
end

function SVMOD:DeleteFuelPump(ent)
	if ent:GetClass() ~= "sv_gaspump" then
		return false
	end

	local data = SVMOD:GetFuelPumpByEnt(ent)

	for i, pump in ipairs(SVMOD.CFG.Fuel.Pumps) do
		if pump.ID == data.ID then
			table.remove(SVMOD.CFG.Fuel.Pumps, i)
			SVMOD:Save()

			ent:EmitSound("garrysmod/balloon_pop_cute.wav")
			ent:Remove()

			return true
		end
	end

	return false
end

net.Receive("SV_Settings_SetPriceFuelPump", function(_, ply)
	local ent = net.ReadEntity()
	local price = net.ReadUInt(9) -- max: 511

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			local fuelPump = SVMOD:GetFuelPumpByEnt(ent)
			if fuelPump then
				for _, pump in ipairs(SVMOD.CFG.Fuel.Pumps) do
					if pump.ID == fuelPump.ID then
						pump.Price = price
						fuelPump.Price = price

						SVMOD:Save()
						SVMOD:SendNotification(ply, "Price edited.", 0, 5)

						return
					end
				end

				SVMOD:SendNotification(ply, "Error occurred.", 1, 5)
			else
				SVMOD:SendNotification(ply, "Error occurred.", 1, 5)
			end
		end
	end)
end)

net.Receive("SV_Settings_GoToFuelPump", function(_, ply)
	local index = net.ReadUInt(5) -- max: 31

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			local pumpData = SVMOD.CFG.Fuel.Pumps[index]
			if pumpData then
				ply:SetPos(pumpData.Position + Vector(0, 0, 40))
			end
		end
	end)
end)