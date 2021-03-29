hook.Add("InitPostEntity", "SV_SpawnFuelPump", function()
	SVMOD:Load()

	local function spawnPump(pos, ang, model)
		local newEnt = ents.Create("sv_gaspump")
		newEnt:SetPos(pos)
		newEnt:SetAngles(ang)
		newEnt:Spawn()
		newEnt:SetModel(model)
		newEnt:GetPhysicsObject():EnableMotion(false)

		return newEnt
	end

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

SVMOD.FuelPumps = SVMOD.FuelPumps or {}

function SVMOD:GetFuelPumpByEnt(ent)
	return SVMOD.FuelPumps[ent]
end