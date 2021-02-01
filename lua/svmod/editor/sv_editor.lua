util.AddNetworkString("SV_Editor_Open")
net.Receive("SV_Editor_Open", function(_, ply)
    -- if not game.SinglePlayer() then return end

    local Model = net.ReadString()

    local VehicleList = SVMOD:GetVehicleList()
    local VehicleData
    for _, v in pairs(VehicleList) do
        if v.Model == Model then
            VehicleData = v
            break
        end
    end
    if not VehicleData then return end

    local Vehicle = ents.Create("prop_vehicle_jeep")
    duplicator.DoGeneric(Vehicle, VehicleData)

    Vehicle:SetModel(VehicleData.Model)
    Vehicle:SetPos(ply:GetEyeTrace().HitPos)

    if VehicleData and VehicleData['KeyValues'] then
        for k, v in pairs(VehicleData['KeyValues']) do
            local kLower = string.lower(k)

            if (kLower == "vehiclescript" or
                kLower == "limitview" or
                kLower == "vehiclelocked" or
                kLower == "cargovisible" or
                kLower == "enablegun")
            then
                Vehicle:SetKeyValue(k, v)
            end
        end

        Vehicle:SetKeyValue("enablegun", "true")
    end

    -- IsEditMode is used for bypassing some tests
    Vehicle.SV_IsEditMode = true

    Vehicle:Spawn()
    Vehicle:Activate()

    hook.Run("PlayerSpawnedVehicle", ply, Vehicle)

    Vehicle:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    SVMOD:LoadVehicle(Vehicle)

    timer.Simple(1, function()
        net.Start("SV_Editor_Open")
        net.WriteEntity(Vehicle)
        net.Send(ply)
    end)
end)

util.AddNetworkString("SV_Editor_ActiveTab")
net.Receive("SV_Editor_ActiveTab", function(_, ply)
    -- if not game.SinglePlayer() then return end

    local veh = net.ReadEntity()
    if not SVMOD:IsVehicle(veh) then
        return
    end

    local OldTab = net.ReadString()
    local NewTab = net.ReadString()
    
    local Actions = {
        ["Headlights"] = {
            Close = function()
                veh:SV_TurnOffHeadlights()
            end,
            Open = function()
                veh:SV_TurnOnHeadlights()
            end
        },
        ["Brake"] = {
            Close = function()
                veh:SV_TurnOffBackLights()
            end,
            Open = function()
                veh:SV_TurnOnBackLights()
            end
        },
        ["Reversing"] = {
            Close = function()
                veh:SV_TurnOffBackLights()
            end,
            Open = function()
                veh:SV_TurnOnBackLights()
            end
        },
        ["Left Blinker"] = {
            Close = function()
                veh:SV_TurnOffLeftBlinker()
            end,
            Open = function()
                veh:SV_TurnOnLeftBlinker()
            end
        },
        ["Right Blinker"] = {
            Close = function()
                veh:SV_TurnOffRightBlinker()
            end,
            Open = function()
                veh:SV_TurnOnRightBlinker()
            end
        },
        ["Flashing Lights"] = {
            Close = function()
                veh:SV_TurnOffFlashingLights()
            end,
            Open = function()
                veh:SV_TurnOnFlashingLights()
            end
        }
    }

    if Actions[OldTab] then
        Actions[OldTab].Close()
    end
    if Actions[NewTab] then
        Actions[NewTab].Open()
    end
end)

util.AddNetworkString("SV_Editor_Close")
net.Receive("SV_Editor_Close", function(_, ply)
    -- if not game.SinglePlayer() then return end

    local Entity = net.ReadEntity()
    
    if IsValid(Entity) then
        Entity:Remove()
    end
end)