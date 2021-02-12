function SVMOD:EDITOR_Fuel(panel, veh, data)
	panel:Clear()

    local bottomPanel = vgui.Create("DPanel", panel)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetSize(0, 30)
    bottomPanel:SetDrawBackground(false)

    veh:SV_ShowFillingHUD()
    local gasolinePistol = ClientsideModel("models/kaesar/kaesar_weapons/w_petrolgun.mdl")

    bottomPanel.OnRemove = function()
        veh:SV_HideFillingHUD()
        gasolinePistol:Remove()
    end

    local xPositionNumSlider
    local yPositionNumSlider
    local zPositionNumSlider

    local function createNumSlidePanel(name, defaultValue, minValue, maxValue)
        local numSlider = SVMOD:CreateNumSlidePanel(panel, name, function() end)
        numSlider:SetSize(400, 30)
        numSlider:SetValue(defaultValue)
        numSlider:SetMinValue(minValue)
        numSlider:SetMaxValue(maxValue)
        numSlider:SetUnit(" ")
        numSlider:SetRealTime(true)
    
        return numSlider
    end

    SVMOD:CreateTitle(panel, SVMOD:GetLanguage("FUEL"))

    local capacityNumSlider = SVMOD:CreateNumSlidePanel(panel, "Capacity", function(val)
        data.Capacity = val
    end)
    capacityNumSlider:SetMaxValue(110)
    capacityNumSlider:SetValue(data.Capacity or 60)
    capacityNumSlider:SetUnit("L")

    local consumptionNumSlider = SVMOD:CreateNumSlidePanel(panel, "Consumption", function(val)
        data.Consumption = val
    end)
    consumptionNumSlider:SetMaxValue(30)
    consumptionNumSlider:SetValue(data.Consumption or 5)
    consumptionNumSlider:SetUnit("L / 100 km")

    data.GasTank = data.GasTank or {}
    data.GasTank.Position = data.GasTank.Position or Vector(0, 0, 0)
    data.GasTank.Angle = data.GasTank.Angle or Angle(0, 0, 0)

    local title = SVMOD:CreateTitle(panel, "GAS TANK OPENING POSITION")
    title:DockMargin(0, 30, 0, 0)
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.GasTank.Position = trace.Entity:WorldToLocal(trace.HitPos)

            xPositionNumSlider:SetValue(data.GasTank.Position.x)
            yPositionNumSlider:SetValue(data.GasTank.Position.y)
            zPositionNumSlider:SetValue(data.GasTank.Position.z)
        end
    end)
    button:Dock(RIGHT)

    xPositionNumSlider = createNumSlidePanel("X Position", data.GasTank.Position.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.GasTank.Position.x = val
    end)

    yPositionNumSlider = createNumSlidePanel("Y Position", data.GasTank.Position.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.GasTank.Position.y = val
    end)

    zPositionNumSlider = createNumSlidePanel("Z Position", data.GasTank.Position.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.GasTank.Position.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "GAS TANK OPENING ANGLE")
    title:DockMargin(0, 30, 0, 0)

    local xAngleNumSlider = createNumSlidePanel("Y Angle", data.GasTank.Angle.x, -180, 180)
    xAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.x = val
    end)

    local yAngleNumSlider = createNumSlidePanel("P Angle", data.GasTank.Angle.y, -180, 180)
    yAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.y = val
    end)

    local zAngleNumSlider = createNumSlidePanel("R Angle", data.GasTank.Angle.z, -180, 180)
    zAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.z = val
    end)

    data.GasolinePistol = data.GasolinePistol or {}
    data.GasolinePistol.Position = data.GasolinePistol.Position or Vector(0, 0, 0)
    data.GasolinePistol.Angle = data.GasolinePistol.Angle or Angle(0, 0, 0)

    local xPistolPositionNumSlider, yPistolPositionNumSlider, zPistolPositionNumSlider

    local title = SVMOD:CreateTitle(panel, "GASOLINE PISTOL POSITION")
    title:DockMargin(0, 30, 0, 0)
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.GasolinePistol.Position = trace.Entity:WorldToLocal(trace.HitPos)

            xPistolPositionNumSlider:SetValue(data.GasolinePistol.Position.x)
            yPistolPositionNumSlider:SetValue(data.GasolinePistol.Position.y)
            zPistolPositionNumSlider:SetValue(data.GasolinePistol.Position.z)

            gasolinePistol:SetPos(veh:LocalToWorld(data.GasolinePistol.Position))
        end
    end)
    button:Dock(RIGHT)

    xPistolPositionNumSlider = createNumSlidePanel("X Position", data.GasolinePistol.Position.x, -200, 200)
    xPistolPositionNumSlider:SetFunction(function(val)
        data.GasolinePistol.Position.x = val
        gasolinePistol:SetPos(veh:LocalToWorld(data.GasolinePistol.Position))
    end)

    yPistolPositionNumSlider = createNumSlidePanel("Y Position", data.GasolinePistol.Position.y, -200, 200)
    yPistolPositionNumSlider:SetFunction(function(val)
        data.GasolinePistol.Position.y = val
        gasolinePistol:SetPos(veh:LocalToWorld(data.GasolinePistol.Position))
    end)

    zPistolPositionNumSlider = createNumSlidePanel("Z Position", data.GasolinePistol.Position.z, -200, 200)
    zPistolPositionNumSlider:SetFunction(function(val)
        data.GasolinePistol.Position.z = val
        gasolinePistol:SetPos(veh:LocalToWorld(data.GasolinePistol.Position))
    end)

    local title = SVMOD:CreateTitle(panel, "GASOLINE PISTOL ANGLE")
    title:DockMargin(0, 30, 0, 0)

    local xAngleNumSlider = createNumSlidePanel("Y Angle", data.GasolinePistol.Angle.x, -180, 180)
    xAngleNumSlider:SetFunction(function(val)
        data.GasolinePistol.Angle.x = val
        gasolinePistol:SetAngles(veh:LocalToWorldAngles(data.GasolinePistol.Angle))
    end)

    local yAngleNumSlider = createNumSlidePanel("P Angle", data.GasolinePistol.Angle.y, -180, 180)
    yAngleNumSlider:SetFunction(function(val)
        data.GasolinePistol.Angle.y = val
        gasolinePistol:SetAngles(veh:LocalToWorldAngles(data.GasolinePistol.Angle))
    end)

    local zAngleNumSlider = createNumSlidePanel("R Angle", data.GasolinePistol.Angle.z, -180, 180)
    zAngleNumSlider:SetFunction(function(val)
        data.GasolinePistol.Angle.z = val
        gasolinePistol:SetAngles(veh:LocalToWorldAngles(data.GasolinePistol.Angle))
    end)

    gasolinePistol:SetPos(veh:LocalToWorld(data.GasolinePistol.Position))
    gasolinePistol:SetAngles(veh:LocalToWorldAngles(data.GasolinePistol.Angle))
end