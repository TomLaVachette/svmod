hook.Add("InitPostEntity", "SV_SpawnFuelPump", function()
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

                pump.Entity = spawnPump(pos, ang, model)
            end
        else
            pump.Entity = spawnPump(pump.Position, pump.Angle, pump.Model)
        end
    end
end)