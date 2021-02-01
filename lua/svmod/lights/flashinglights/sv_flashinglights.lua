util.AddNetworkString("SV_TurnFlashingLights")

--[[---------------------------------------------------------
   Name: Vehicle:SV_TurnOnFlashingLights()
   Type: Server
   Desc: Turns on the flashing lights of a vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOnFlashingLights()
    if #self.SV_Data.FlashingLights == 0 then
        return false -- No flashing light on this vehicle
    elseif not SVMOD.CFG.Lights.AreFlashingLightsEnabled then
        return false -- Flashing lights disabled
    elseif self:SV_GetFlashingLightsState() then
        return false -- Flashing lights already active
    end

    net.Start("SV_TurnFlashingLights")
    net.WriteEntity(self)
    net.WriteBool(true)
    net.Broadcast()
    
    self.SV_States.FlashingLights = true

    return true
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_TurnOffFlashingLights()
   Type: Server
   Desc: Turns off the flashing lights of a vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOffFlashingLights()
    if not self:SV_GetFlashingLightsState() then
        return false -- Flashing lights already inactive
    end

    net.Start("SV_TurnFlashingLights")
    net.WriteEntity(self)
    net.WriteBool(false)
    net.Broadcast()
    
    self.SV_States.FlashingLights = false

    return true
end

util.AddNetworkString("SV_SetFlashingLightsState")
net.Receive("SV_SetFlashingLightsState", function(_, ply)
    local Vehicle = ply:GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    local State = net.ReadBool()

    if State then
        Vehicle:SV_TurnOnFlashingLights()
    else
        Vehicle:SV_TurnOffFlashingLights()
    end
end)

local function DisableFlashingLights(veh)
    if not SVMOD.CFG.Lights.TurnOffFlashingLightsOnExit then return end

    if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

    timer.Create("SV_DisableFlashingLights_" .. veh:EntIndex(), SVMOD.CFG.Lights.TimeTurnOffFlashingLights, 1, function()
        if not SVMOD:IsVehicle(veh) then return end
        
        veh:SV_TurnOffFlashingLights()
    end)
end

hook.Add("PlayerLeaveVehicle", "SV_DisableFlashingLightsOnLeave", function(ply, veh)
    DisableFlashingLights(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableFlashingLightsOnDisconnect", function(ply, veh)
    DisableFlashingLights(ply:GetVehicle())
end)

hook.Add("PlayerEnteredVehicle", "SV_UndoDisableFlashingLightsOnLeave", function(ply, veh)
    if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
        return
    end

    timer.Remove("SV_DisableFlashingLights_" .. veh:EntIndex())
end)