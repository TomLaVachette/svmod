include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("SV_StartFilling")
util.AddNetworkString("SV_StopFilling")

local function stopFilling(ply, veh)
    timer.Remove("SV_FillerPistol_" .. veh:EntIndex())

    if IsValid(ply) then
        net.Start("SV_StopFilling")
        net.WriteEntity(veh)
        net.Send(ply)
    end
end

net.Receive("SV_StartFilling", function(_, ply)
    local veh = net.ReadEntity()
    if not SVMOD:IsVehicle(veh) then
        return
    end

    timer.Create("SV_FillerPistol_" .. veh:EntIndex(), 3, 0, function()
        if not IsValid(veh) or not IsValid(ply) then
            stopFilling(ply, veh)
        else
            if veh:SV_GetFuel() == veh:SV_GetMaxFuel() then
                stopFilling(ply, veh)
            end

            local hitPos = ply:GetEyeTrace().HitPos

            if hitPos:DistToSqr(veh:LocalToWorld(veh.SV_Data.Fuel.GasTankPosition)) < 200 then
                local function callback()
                    veh:SV_SetFuel(veh:SV_GetFuel() + 21)
                    veh:SV_SendFuel(ply)
                end

                local pump = SVMOD:GetFuelPumpByEnt(ply.SV_CurrentFuelPump)
                if not pump then
                    return
                end

                local result = hook.Run("SV_PayFuelPump", callback)

                if result == false then
                    stopFilling(ply, veh)
                elseif result == nil then
                    local name = gmod.GetGamemode().Name

                    if name == "DarkRP" then
                        local money = ply:getDarkRPVar("money")

                        if money >= pump.Price then
                            ply:addMoney(pump.Price * -1)
                            callback()
                        else
                            stopFilling(ply, veh)
                        end
                    else
                        callback()
                    end
                end
            else
                stopFilling(ply, veh)
            end
        end
    end)

    veh:SV_SendFuel(ply)

    net.Start("SV_StartFilling")
    net.WriteEntity(veh)
    net.Send(ply)
end)

net.Receive("SV_StopFilling", function(_, ply)
    local veh = net.ReadEntity()
    if not SVMOD:IsVehicle(veh) then
        return
    end

    stopFilling(ply, veh)
end)

function SWEP:PrimaryAttack()
    if game.SinglePlayer() then
        self:CallOnClient("PrimaryAttack")
    end
end