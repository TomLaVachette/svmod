game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("smoke_small_01")

hook.Add("InitPostEntity", "SV_InitializeCS", function()
    SVMOD.ShortcutTime = CurTime()
end)

net.Receive("SV_PlayerEnteredVehicle", function()
    local Seat = net.ReadEntity()

    hook.Run("SV_PlayerEnteredVehicle", Seat)
end)

net.Receive("SV_PlayerLeaveVehicle", function()
    local Vehicle = net.ReadEntity()

    hook.Run("SV_PlayerLeaveVehicle", Vehicle)
end)

hook.Add("SV_LoadVehicle", "SV_GetVehicleStates", function(veh)
    net.Start("SV_GetVehicleStates")
    net.WriteEntity(veh)
    net.SendToServer()
end)