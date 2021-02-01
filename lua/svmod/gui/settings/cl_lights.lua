function SVMOD:GUI_Lights(panel, data)
    panel:Clear()

    SVMOD:CreateTitle(panel, SVMOD:GetLanguage("HEADLIGHTS"))

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable headlights"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.AreHeadlightsEnabled == true),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreHeadlightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(true)
                net.SendToServer()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.AreHeadlightsEnabled == false),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreHeadlightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(false)
                net.SendToServer()
            end
        }
    })

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Turning off the headlights when the driver exits the vehicle"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.TurnOffHeadlightsOnExit == true),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("TurnOffHeadlightsOnExit")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(true)
                net.SendToServer()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.TurnOffHeadlightsOnExit == false),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("TurnOffHeadlightsOnExit")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(false)
                net.SendToServer()
            end
        }
    })

    local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Time to deactivate the headlights"), function(val)
        net.Start("SV_Settings")
        net.WriteString("Lights")
        net.WriteString("TimeTurnOffHeadlights")
        net.WriteUInt(1, 2) -- float
        net.WriteFloat(val)
        net.SendToServer()
    end)
    slide:SetValue(data.TimeTurnOffHeadlights)
    slide:SetMaxValue(300)
    slide:SetUnit(SVMOD:GetLanguage("seconds"))

    local title = SVMOD:CreateTitle(panel, SVMOD:GetLanguage("BLINKERS AND HAZARD LIGHTS"))
    title:DockMargin(0, 30, 0, 0)

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Turning off the hazard lights when the driver exits the vehicle"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.AreHazardLightsEnabled == true),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreHazardLightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(true)
                net.SendToServer()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.AreHazardLightsEnabled == false),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreHazardLightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(false)
                net.SendToServer()
            end
        }
    })

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Turning off the hazard lights when the driver exits the vehicle"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.TurnOffHazardOnExit == true),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("TurnOffHazardOnExit")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(true)
                net.SendToServer()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.TurnOffHazardOnExit == false),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("TurnOffHazardOnExit")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(false)
                net.SendToServer()
            end
        }
    })
    
    local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Time to deactivate the hazard lights"), function(val)
        net.Start("SV_Settings")
        net.WriteString("Lights")
        net.WriteString("TimeTurnOffHazard")
        net.WriteUInt(1, 2) -- float
        net.WriteFloat(val)
        net.SendToServer()
    end)
    slide:SetValue(data.TimeTurnOffHazard)
    slide:SetMaxValue(300)
    slide:SetUnit(SVMOD:GetLanguage("seconds"))

    local title = SVMOD:CreateTitle(panel, SVMOD:GetLanguage("REVERSE LIGHTS"))
    title:DockMargin(0, 30, 0, 0)

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable reverse lights"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.AreReverseLightsEnabled == true),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreReverseLightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(true)
                net.SendToServer()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.AreReverseLightsEnabled == false),
            DoClick = function()
                net.Start("SV_Settings")
                net.WriteString("Lights")
                net.WriteString("AreReverseLightsEnabled")
                net.WriteUInt(0, 2) -- bool
                net.WriteBool(false)
                net.SendToServer()
            end
        }
    })
end