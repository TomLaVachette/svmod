--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_IsLocked()
   Type: Server
   Desc: Returns true if the vehicle is locked, false
         otherwhise.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_IsLocked()
    local Vehicle = self:SV_GetDriverSeat()

    return Vehicle:GetSaveTable().VehicleLocked
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_Lock()
   Type: Server
   Desc: Locks the vehicle. Returns true if the operation was
         successful, false if the vehicle was already locked.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_Lock()
    local Vehicle = self:SV_GetDriverSeat()

    if self:SV_IsLocked() then
        return false
    end

    Vehicle:Fire("lock", "", 0)

    Vehicle:EmitSound("doors/door_latch1.wav")

    return true
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_Unlock()
   Type: Server
   Desc: Unlocks the vehicle. Returns true if the operation
         was successful, false if the vehicle was already
         unlocked.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_Unlock()
    local Vehicle = self:SV_GetDriverSeat()

    if not self:SV_IsLocked() then
        return false
    end

    Vehicle:Fire("unlock", "", 0)

    Vehicle:EmitSound("doors/door_latch3.wav")

    return true
end

util.AddNetworkString("SV_SetLockState")
net.Receive("SV_SetLockState", function(_, ply)
    if not SVMOD.CFG.Seats.IsLockEnabled then return end

    local Vehicle = ply:GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    local State = net.ReadBool()

    if State then
        if not Vehicle:SV_IsLocked() then
            Vehicle:SV_Lock()
        end
    else
        if Vehicle:SV_IsLocked() then
            Vehicle:SV_Unlock()
        end
    end
end)

util.AddNetworkString("SV_SwitchLockState")
net.Receive("SV_SwitchLockState", function(_, ply)
    if not SVMOD.CFG.Seats.IsLockEnabled then return end

    local Vehicle = ply:GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    if Vehicle:SV_IsLocked() then
        Vehicle:SV_Unlock()
    else
        Vehicle:SV_Lock()
    end
end)