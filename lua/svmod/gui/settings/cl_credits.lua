function SVMOD:GUI_Credits(panel, data)
    panel:Clear()

    SVMOD:CreateTitle(panel, SVMOD:GetLanguage("CREDITS"))

    local function addLabel(name, text, gender, steamId64)
        local creditPanel = vgui.Create("DPanel", panel)
        creditPanel:Dock(TOP)
        creditPanel:DockMargin(0, 4, 0, 4)
        creditPanel:SetSize(0, 30)
        creditPanel:SetDrawBackground(false)
    
        local leftLabel = vgui.Create("DLabel", creditPanel)
        leftLabel:SetPos(2, 4)
        leftLabel:SetFont("SV_Calibri18")
        leftLabel:SetText(name)
        leftLabel:SizeToContents()

        surface.SetFont("SV_Calibri18")
        local width = surface.GetTextSize(name)

        if steamId64 then
            local steamButton = vgui.Create("DImageButton", creditPanel)
            steamButton:SetPos(2 + width + 5, 5)
            if gender then
                steamButton:SetMaterial("materials/icon16/user_female.png")
            else
                steamButton:SetMaterial("materials/icon16/user.png")
            end
            steamButton:SetSize(16, 16)
            steamButton.DoClick = function()
                gui.OpenURL("http://steamcommunity.com/profiles/" .. steamId64)
            end
        end

        surface.SetFont("SV_Calibri18")
        local width = surface.GetTextSize(text)

        local rightLabel = vgui.Create("DLabel", creditPanel)
        rightLabel:SetPos(2, 4)
        rightLabel:SetFont("SV_Calibri18")
        rightLabel:SetText(text)
        rightLabel:SizeToContents()

        timer.Simple(FrameTime(), function()
            rightLabel:SetPos(creditPanel:GetSize() - width - 5, 4)
        end)
    end

    addLabel("TomLaVachette", "LUA Developer", false, "76561198061601582")
    addLabel("wow", "Web Developer", false, "76561198084178846")
    addLabel("Hertinox", "Vehicle Editor Tester", false, "76561198250792770")
    addLabel("Nelna", "Vehicle Editor Tester", true, "76561198195818413")
    addLabel("jycxed", "UI Helper", false, "76561198119106746")
end