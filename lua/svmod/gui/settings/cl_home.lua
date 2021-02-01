function SVMOD:GUI_Home(panel, data)
    panel:Clear()

    local function createHorizontalLine()
        local topHorizontalLine = vgui.Create("DPanel", panel)
        topHorizontalLine:Dock(TOP)
        topHorizontalLine:DockMargin(0, 10, 0, 10)
        topHorizontalLine:SetSize(0, 1)
        topHorizontalLine.Paint = function(self, w, h)
            surface.SetDrawColor(39, 52, 58)
            surface.DrawRect(0, 0, w, h)
        end
    end

    local function createStatus(status, text)
        if not status then
            status = false
        end

        local statusPanel = vgui.Create("DPanel", panel)
        statusPanel:Dock(TOP)
        statusPanel:DockMargin(0, 2, 0, 0)
        statusPanel:SetSize(0, 30)
        statusPanel:SetDrawBackground(false)
    
        local checkedPanel = vgui.Create("DImage", statusPanel)
        checkedPanel:SetPos(0, 0)
        checkedPanel:SetSize(24, 24)
        if status then
            checkedPanel:SetImageColor(Color(112, 255, 117))
            checkedPanel:SetImage("vgui/svmod/checked.png")
        else
            checkedPanel:SetImageColor(Color(255, 112, 112))
            checkedPanel:SetImage("vgui/svmod/invalid.png")
        end
    
        local statusLabel = vgui.Create("DLabel", statusPanel)
        statusLabel:SetPos(35, 2)
        statusLabel:SetFont("SV_Calibri18")
        if status then
            statusLabel:SetColor(Color(112, 255, 117))
        else
            statusLabel:SetColor(Color(255, 112, 112))
        end
        statusLabel:SetText(text)
        statusLabel:SizeToContents()
    end

    local headerPanel = vgui.Create("DPanel", panel)
    headerPanel:Dock(TOP)
    headerPanel:SetSize(0, 20)
    headerPanel:SetDrawBackground(false)

    local titleLabel = vgui.Create("DLabel", headerPanel)
    titleLabel:SetPos(0, 0)
    titleLabel:SetFont("SV_CalibriLight22")
    titleLabel:SetColor(Color(178, 95, 245))
    titleLabel:SetText(SVMOD:GetLanguage("HOME"))
    titleLabel:SizeToContents()

    createHorizontalLine()

    if data.Status then
        createStatus(true, SVMOD:GetLanguage("Enabled"))
    else
        createStatus(false, SVMOD:GetLanguage("Disabled"))
    end

    if SVMOD.FCFG.Version == SVMOD.FCFG.LastVersion then
        createStatus(true, SVMOD:GetLanguage("Addon is up to date"))
    else
        createStatus(false, SVMOD:GetLanguage("Addon not on the latest version") .. " (" .. SVMOD.FCFG.Version .. " - " .. SVMOD.FCFG.LastVersion .. ")")
    end

    if SVMOD.Data and #data.LastVehicleUpdate > 0 then
        createStatus(true, SVMOD:GetLanguage("Vehicle data up to date"))
    else
        createStatus(false, SVMOD:GetLanguage("Vehicle data not updated"))
    end

    if #data.ConflictList == 0 then
        createStatus(true, SVMOD:GetLanguage("No conflict detected"))
    else
        createStatus(false, SVMOD:GetLanguage("Conflict detected with") .. " : " .. data.ConflictList)
    end

    local vehicleLoadedCount = 0
    if SVMOD.Data then
        vehicleLoadedCount = table.Count(SVMOD.Data)
    end
    local vehicleIncompatibleCount = table.Count(SVMOD:GetVehicleList()) - vehicleLoadedCount
    
    local loadedText
    if vehicleLoadedCount > 1 then
        loadedText = string.format(SVMOD:GetLanguage("%s vehicles loaded"), vehicleLoadedCount)
    else
        loadedText = string.format(SVMOD:GetLanguage("%s vehicle loaded"), vehicleLoadedCount)
    end

    local incompatibleText
    if vehicleIncompatibleCount > 1 then
        incompatibleText = string.format(SVMOD:GetLanguage("%s incompatibles"), vehicleIncompatibleCount)
    else
        incompatibleText = string.format(SVMOD:GetLanguage("%s incompatible"), vehicleIncompatibleCount)
    end

    if vehicleIncompatibleCount == 0 then
        createStatus(true, loadedText .. ", " .. incompatibleText)
    else
        createStatus(false, loadedText .. ", " .. incompatibleText)
    end

    createHorizontalLine()

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable SVMod"), {
        {
            Name = SVMOD:GetLanguage("Enable"),
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (data.Status == true),
            DoClick = function()
                SVMOD:SetAddonState(true)
                panel:GetParent():Remove()
            end
        },
        {
            Name = SVMOD:GetLanguage("Disable"),
            Color = Color(173, 48, 43),
            HoverColor = Color(224, 62, 56),
            IsSelected = (data.Status == false),
            DoClick = function()
                SVMOD:SetAddonState(false)
                panel:GetParent():Remove()
            end
        }
    })

    SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Language"), {
        {
            ISO = "FR",
            Name = "Français",
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (SVMOD.CFG.Language == "FR"),
            DoClick = function()
                SVMOD.CFG.Language = "FR"
                panel:GetParent():Remove()
                LocalPlayer():ConCommand("svmod")
            end
        },
        {
            ISO = "EN",
            Name = "English",
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            IsSelected = (SVMOD.CFG.Language == "EN"),
            DoClick = function()
                SVMOD.CFG.Language = "EN"
                panel:GetParent():Remove()
                LocalPlayer():ConCommand("svmod")
            end
         }
    })

    SVMOD:CreateSettingPanel(panel, "Performance", {
        {
            Name = "High",
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            DoClick = function()

            end
        },
        {
            Name = "Normal",
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            DoClick = function()

            end
        },
        {
            Name = "Low",
            Color = Color(59, 217, 85),
            HoverColor = Color(156, 255, 161),
            DoClick = function()

            end
        }
    })

    createHorizontalLine()

    local bottomPanel = vgui.Create("DPanel", panel)
    bottomPanel:Dock(TOP)
    bottomPanel:DockMargin(0, 4, 0, 4)
    bottomPanel:SetSize(0, 30)
    bottomPanel:SetDrawBackground(false)

    local discordButton = SVMOD:CreateButton(bottomPanel, "Support", function()
        gui.OpenURL("https://discord.svmod.com")
    end)

    surface.SetFont("SV_Calibri18")
    local firstWidth = surface.GetTextSize("Developed with")
    local secondWidth = surface.GetTextSize("by TomLaVachette")

    local firstLabel = vgui.Create("DLabel", bottomPanel)
    firstLabel:SetFont("SV_Calibri18")
    firstLabel:SetText(SVMOD:GetLanguage("Developed with"))
    firstLabel:SizeToContents()

    local secondLabel = vgui.Create("DLabel", bottomPanel)
    secondLabel:SetFont("SV_Calibri18")
    secondLabel:SetColor(Color(173, 48, 43))
    secondLabel:SetText("♥")
    secondLabel:SizeToContents()

    local thirdLabel = vgui.Create("DLabel", bottomPanel)
    thirdLabel:SetFont("SV_Calibri18")
    thirdLabel:SetText(SVMOD:GetLanguage("by TomLaVachette"))
    thirdLabel:SizeToContents()

    timer.Simple(FrameTime(), function()
        firstLabel:SetPos(bottomPanel:GetSize() - firstWidth - 20 - secondWidth - 5, 4)
        secondLabel:SetPos(bottomPanel:GetSize() - 14 - secondWidth - 5, 4)
        thirdLabel:SetPos(bottomPanel:GetSize() - secondWidth - 5, 4)
    end)
end