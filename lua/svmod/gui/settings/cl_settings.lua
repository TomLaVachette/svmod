surface.CreateFont("SV_CalibriLight22", {
	font = "Calibri Light",
	size = 22
})

surface.CreateFont("SV_CalibriLight18", {
	font = "Calibri Light",
	size = 18
})

surface.CreateFont("SV_Calibri18", {
	font = "Calibri",
	size = 18
})

net.Receive("SV_Settings", function()
    local data = {}

    data.HasAccess = net.ReadBool()

    data.Status = net.ReadBool()
    data.LastVehicleUpdate = net.ReadString()
    data.ConflictList = net.ReadString()

    if data.HasAccess then
        data.IsSwitchEnabled = net.ReadBool()
        data.IsKickEnabled = net.ReadBool()
        data.IsLockEnabled = net.ReadBool()

        data.AreHeadlightsEnabled = net.ReadBool()
        data.TurnOffHeadlightsOnExit = net.ReadBool()
        data.TimeTurnOffHeadlights = net.ReadFloat()
        data.AreHazardLightsEnabled = net.ReadBool()
        data.TurnOffHazardOnExit = net.ReadBool()
        data.TimeTurnOffHazard = net.ReadFloat()
        data.AreReverseLightsEnabled = net.ReadBool()

        data.AreFlashingLightsEnabled = net.ReadBool()
        data.TurnOffFlashingLightsOnExit = net.ReadBool()
        data.TimeTurnOffFlashingLights = net.ReadFloat()

        data.HornIsEnabled = net.ReadBool()

        data.PhysicsMultiplier = math.Round(net.ReadFloat(), 2)
        data.BulletMultiplier = math.Round(net.ReadFloat(), 2)
        data.CarbonisedChance = math.Round(net.ReadFloat(), 2)
        data.SmokePercent = math.Round(net.ReadFloat(), 2)
        data.DriverMultiplier = math.Round(net.ReadFloat(), 2)
        data.PassengerMultiplier = math.Round(net.ReadFloat(), 2)
        data.PlayerExitMultiplier = math.Round(net.ReadFloat(), 2)

        data.FuelIsEnabled = net.ReadBool()
        data.FuelMultiplier = math.Round(net.ReadFloat(), 2)
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 650)
    frame:Center()
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(18, 25, 31)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(178, 95, 245)
        surface.DrawRect(0, 0, w, 4)
    end

    local title = vgui.Create("DLabel", frame)
    title:SetPos(15, 12)
    title:SetFont("SV_CalibriLight22")
    title:SetText("SVMOD : SIMPLE VEHICLE MOD 1.2")
    title:SetColor(Color(178, 95, 245))
    title:SizeToContents()

    local topHorizontalLine = vgui.Create("DPanel", frame)
    topHorizontalLine:Dock(TOP)
    topHorizontalLine:DockMargin(10, 15, 10, 0)
    topHorizontalLine:SetSize(0, 1)
    topHorizontalLine.Paint = function(self, w, h)
        surface.SetDrawColor(39, 52, 58)
        surface.DrawRect(0, 0, w, h)
    end

    local leftPanel = vgui.Create("DPanel", frame)
    leftPanel:Dock(LEFT)
    leftPanel:SetSize(160, 0)
    leftPanel:DockPadding(10, 10, 10, 10)
    leftPanel:SetDrawBackground(false)

    local leftHorizontalLine = vgui.Create("DPanel", frame)
    leftHorizontalLine:Dock(LEFT)
    leftHorizontalLine:DockMargin(0, 10, 0, 10)
    leftHorizontalLine:SetSize(1, 0)
    leftHorizontalLine.Paint = function(self, w, h)
        surface.SetDrawColor(39, 52, 58)
        surface.DrawRect(0, 0, w, h)
    end

    local centerPanel = vgui.Create("DPanel", frame)
    centerPanel:Dock(FILL)
    centerPanel:DockPadding(20, 15, 20, 15)
    centerPanel:SetDrawBackground(false)

    local function createMenuButton(text, dock, fun)
        local button = vgui.Create("DButton", leftPanel)
        button:Dock(dock)
        button:DockMargin(0, 2, 0, 2)
        button:SetSize(0, 32)
        button:SetText("")
        button.DoClick = function(self)
            surface.PlaySound("garrysmod/ui_click.wav")

            fun()
        end
        button.Paint = function(self, w, h)
            surface.SetDrawColor(12, 22, 24)
            surface.DrawRect(0, 0, w, h)
    
            local color
    
            if self:IsHovered() then
                if not self.soundPlayed then
                    surface.PlaySound("garrysmod/ui_hover.wav")
                    self.soundPlayed = true
                end
    
                surface.SetDrawColor(237, 197, 255)
                color = Color(237, 197, 255)
            else
                self.soundPlayed = false
    
                surface.SetDrawColor(154, 128, 166)
                color = Color(154, 128, 166)
            end
    
            surface.DrawRect(3, 3, 7, 1)
            surface.DrawRect(3, 3, 1, 7)
    
            surface.DrawRect(w - 3 - 7, 3, 7, 1)
            surface.DrawRect(w - 3, 3, 1, 7)
    
            surface.DrawRect(3, h - 3, 7, 1)
            surface.DrawRect(3, h - 3 - 7, 1, 7)
    
            surface.DrawRect(w - 3 - 7, h - 3, 7, 1)
            surface.DrawRect(w - 3, h - 3 - 7, 1, 7)
    
            draw.SimpleText(text, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        return button
    end

    createMenuButton(SVMOD:GetLanguage("HOME"), TOP, function()
        SVMOD:GUI_Home(centerPanel, data)
    end)

    createMenuButton(SVMOD:GetLanguage("SHORTCUTS"), TOP, function()
        SVMOD:GUI_Shortcuts(centerPanel, data)
    end)

    createMenuButton(SVMOD:GetLanguage("OPTIONS"), TOP, function()
        SVMOD:GUI_Options(centerPanel, data)
    end)

    createMenuButton(SVMOD:GetLanguage("VEHICLES"), TOP, function()
        SVMOD:GUI_Vehicles(centerPanel, data)
    end)

    if data.HasAccess then
        createMenuButton(SVMOD:GetLanguage("SEATS"), TOP, function()
            SVMOD:GUI_Seats(centerPanel, data)
        end)

        createMenuButton(SVMOD:GetLanguage("LIGHTS"), TOP, function()
            SVMOD:GUI_Lights(centerPanel, data)
        end)

        createMenuButton(SVMOD:GetLanguage("ELS"), TOP, function()
            SVMOD:GUI_ELS(centerPanel, data)
        end)

        createMenuButton(SVMOD:GetLanguage("SOUNDS"), TOP, function()
            SVMOD:GUI_Sounds(centerPanel, data)
        end)

        createMenuButton(SVMOD:GetLanguage("DAMAGE"), TOP, function()
            SVMOD:GUI_Damage(centerPanel, data)
        end)

        createMenuButton(SVMOD:GetLanguage("FUEL"), TOP, function()
            SVMOD:GUI_Fuel(centerPanel, data)
        end)
    end

    createMenuButton(SVMOD:GetLanguage("CLOSE"), BOTTOM, function()
        frame:Remove()
    end)

    createMenuButton(SVMOD:GetLanguage("CREDITS"), BOTTOM, function()
        SVMOD:GUI_Credits(centerPanel, data)
    end)

    createMenuButton(SVMOD:GetLanguage("CONTRIBUTOR"), BOTTOM, function()
        SVMOD:GUI_Contributor(centerPanel, data)
    end)

    SVMOD:GUI_Home(centerPanel, data)
end)