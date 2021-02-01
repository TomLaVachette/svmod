--[[---------------------------------------------------------
   Name: SVMOD:SetLockState(boolean value = false)
   Type: Client
   Desc: Sets the lock of the vehicle driven by the player.
-----------------------------------------------------------]]
function SVMOD:SetLockState(value)
    local Vehicle = LocalPlayer():GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    if not value then
        value = false
    end

    net.Start("SV_SetLockState")
    net.WriteBool(value)
    net.SendToServer()
end

--[[---------------------------------------------------------
   Name: SVMOD:SwitchLockState()
   Type: Client
   Desc: Switch the lock of the vehicle driven by the player.
-----------------------------------------------------------]]
function SVMOD:SwitchLockState()
    local Vehicle = LocalPlayer():GetVehicle()
    if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

    net.Start("SV_SwitchLockState")
    net.SendToServer()
end