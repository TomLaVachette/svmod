function SVMOD:GUI_Contributor(panel, data)
    panel:Clear()

    SVMOD:CreateTitle(panel, SVMOD:GetLanguage("CONTRIBUTOR"))

    local keyPanel = vgui.Create("DPanel", panel)
    keyPanel:Dock(TOP)
    keyPanel:DockMargin(0, 4, 0, 4)
    keyPanel:SetSize(0, 30)
    keyPanel:SetDrawBackground(false)

    local label = vgui.Create("DLabel", keyPanel)
    label:SetPos(2, 4)
    label:SetFont("SV_Calibri18")
    label:SetText(SVMOD:GetLanguage("API Key"))
    label:SizeToContents()

    local keyTextEntry = vgui.Create("DTextEntry", keyPanel)
    keyTextEntry:Dock(RIGHT)
    keyTextEntry:DockMargin(8, 0, 0, 0)
    keyTextEntry:SetSize(300, 0)
    keyTextEntry:SetPlaceholderText("I am a placeholder")
    keyTextEntry.Paint = function(self, w, h)
        surface.SetDrawColor(18, 25, 31)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(41, 56, 63)
        surface.DrawOutlinedRect(0, 0, w, h)

        draw.SimpleText(self:GetValue(), "SV_Calibri18", 8, h / 2, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    keyTextEntry:SetValue(SVMOD.CFG.Contributor.Key or "")

    local subKeyPanel = vgui.Create("DPanel", panel)
    subKeyPanel:Dock(TOP)
    subKeyPanel:DockMargin(0, 4, 0, 4)
    subKeyPanel:SetSize(0, 30)
    subKeyPanel:SetDrawBackground(false)

    local checkedPanel = vgui.Create("DImage", subKeyPanel)
    checkedPanel:SetPos(5, 5)
    checkedPanel:SetSize(24, 24)

    if SVMOD.CFG.Contributor.IsEnabled then
        checkedPanel:SetImageColor(Color(112, 255, 117))
        checkedPanel:SetImage("vgui/svmod/checked.png")

        local label = vgui.Create("DLabel", subKeyPanel)
        label:SetPos(38, 7)
        label:SetFont("SV_Calibri18")
        label:SetColor(Color(112, 255, 117))
        label:SetText(SVMOD:GetLanguage("Contributor mode enabled"))
        label:SizeToContents()
    else
        checkedPanel:SetImageColor(Color(255, 112, 112))
        checkedPanel:SetImage("vgui/svmod/invalid.png")

        local label = vgui.Create("DLabel", subKeyPanel)
        label:SetPos(38, 7)
        label:SetFont("SV_Calibri18")
        label:SetColor(Color(255, 112, 112))
        label:SetText(SVMOD:GetLanguage("Contributor mode disabled"))
        label:SizeToContents()
    end
    
    local validButton = SVMOD:CreateButton(subKeyPanel, SVMOD:GetLanguage("Verify"), function()
        SVMOD.CFG.Contributor.Key = keyTextEntry:GetValue()

        http.Fetch("https://api.svmod.com/check_serial.php?serial=" .. keyTextEntry:GetValue(), function(_, _, _, code)
            if code == 200 then
                notification.AddLegacy(SVMOD:GetLanguage("Contributor mode enabled") .. ".", NOTIFY_GENERIC, 5)

                SVMOD.CFG.Contributor.IsEnabled = true

                SVMOD:Save()

                panel:GetParent():Remove()
            else
                notification.AddLegacy(SVMOD:GetLanguage("Invalid API key."), NOTIFY_ERROR, 5)
            end
        end, function()
            notification.AddLegacy(SVMOD:GetLanguage("Server does not respond."), NOTIFY_ERROR, 5)
        end)
    end)
    validButton:Dock(RIGHT)
end