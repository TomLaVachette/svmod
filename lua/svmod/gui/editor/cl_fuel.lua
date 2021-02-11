function SVMOD:EDITOR_Fuel(panel, veh, data)
	panel:Clear()

    local bottomPanel = vgui.Create("DPanel", panel)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetSize(0, 30)
    bottomPanel:SetDrawBackground(false)

    veh:SV_ShowFillingHUD()

    bottomPanel.OnRemove = function()
        veh:SV_HideFillingHUD()
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

    local title = SVMOD:CreateTitle(panel, "GAS TANK OPENING LOCAL POSITION")
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

    local xAngleNumSlider = createNumSlidePanel("X Angle", data.GasTank.Angle.x, -200, 200)
    xAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.x = val
    end)

    local yAngleNumSlider = createNumSlidePanel("Y Angle", data.GasTank.Angle.y, -200, 200)
    yAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.y = val
    end)

    local zAngleNumSlider = createNumSlidePanel("Z Angle", data.GasTank.Angle.z, -200, 200)
    zAngleNumSlider:SetFunction(function(val)
        data.GasTank.Angle.z = val
    end)
end