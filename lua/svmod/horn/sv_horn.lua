util.AddNetworkString("SV_TurnHorn")

--[[---------------------------------------------------------
   Name: Vehicle:SV_TurnOnHorn()
   Type: Server
   Desc: Turns off the right blinker signals of a vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOnHorn()
    if not SVMOD.CFG.Horn.IsEnabled then
        return false -- Horn disabled
    elseif self:SV_GetHornState() then
        return false -- Horn already active
    end

    net.Start("SV_TurnHorn")
    net.WriteEntity(self)
    net.WriteBool(true)
    net.Broadcast()
    
    self.SV_States.Horn = true

    return true
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_TurnOffHorn()
   Type: Server
   Desc: Turns off the right blinker signals of a vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOffHorn()
    if not self:SV_GetHornState() then
        return false -- Horn already inactive
    end

    net.Start("SV_TurnHorn")
    net.WriteEntity(self)
    net.WriteBool(false)
    net.Broadcast()
    
    self.SV_States.Horn = false

    return true
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_GetHornState()
   Type: Shared
   Desc: Returns the horn state of the vehicle.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetHornState()
    return self.SV_States.Horn
end

util.AddNetworkString("SV_SetHornState")
net.Receive("SV_SetHornState", function(_, ply)
    local Vehicle = ply:GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    local State = net.ReadBool()

    if State then
        if not Vehicle:SV_GetHornState() then
            Vehicle:SV_TurnOnHorn()
        end
    else
        if Vehicle:SV_GetHornState() then
            Vehicle:SV_TurnOffHorn()
        end
    end
end)

local function DisableHorn(veh)
    if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

    if veh:SV_GetHornState() then
        veh:SV_TurnOffHorn()
    end
end

hook.Add("PlayerLeaveVehicle", "SV_DisableHornOnLeave", function(ply, veh)
    DisableHorn(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableHornOnDisconnect", function(ply, veh)
    DisableHorn(ply:GetVehicle())
end)