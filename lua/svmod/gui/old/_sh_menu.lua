local WriteTypes = {
    [0] = net.WriteBool,
    [1] = net.WriteFloat
}

local function SendSet(category, name, type, value)
    net.Start("SV_Editor_Set")
    net.WriteString(category)
    net.WriteString(name)
    net.WriteUInt(type, 2)
    WriteTypes[type](value)
    net.SendToServer()
end

SVMOD.Menu = {
    {
        Name = "Home",
        Icon = "house",
        SuperAdminOnly = false,
        Categories = {
            {
                Name = "SVMod Status",
                Color = Color(255, 255, 255),
                Description = nil,
                Controls = {
                    {
                        Type = "STATUS",
                        Write = function()
                            net.WriteBool(SVMOD.CFG.IsEnabled)
                        end,
                        Read = function()
                            if net.ReadBool() then
                                return { Icon = "accept", Text = SVMOD:GetLanguage("Enabled") }
                            else
                                return { Icon = "delete", Text = SVMOD:GetLanguage("Disabled") }
                            end
                        end
                    },
                    {
                        Type = "STATUS",
                        Write = function() end,
                        Read = function()
                            if SVMOD.FCFG.Version == SVMOD.FCFG.LastVersion then
                                return { Icon = "accept", Text = SVMOD:GetLanguage("Addon is up to date") }
                            else
                                return { Icon = "delete", Text = SVMOD:GetLanguage("Addon not on the latest version") .. " (" .. SVMOD.FCFG.Version .. " ~ " .. SVMOD.FCFG.LastVersion .. ")" }
                            end
                        end
                    },
                    {
                        Type = "STATUS",
                        Write = function()
                            net.WriteString(SVMOD.CFG.VehicleDataUpdateTime or "")
                        end,
                        Read = function()
                            local lastUpdate = net.ReadString()
                            if SVMOD.Data and #lastUpdate > 0 then
                                return { Icon = "accept", Text = SVMOD:GetLanguage("Vehicle data up to date") }
                            else
                                return { Icon = "exclamation", Text = SVMOD:GetLanguage("Vehicle data not updated") }
                            end
                        end
                    },
                    {
                        Type = "STATUS",
                        Write = function()
                            net.WriteString(SVMOD:GetConflictList())
                        end,
                        Read = function()
                            local conflicts = net.ReadString()
                            if #conflicts == 0 then
                                return { Icon = "accept", Text = SVMOD:GetLanguage("No conflict detected") }
                            else
                                return { Icon = "exclamation", Text = SVMOD:GetLanguage("Conflict detected with") .. ": " .. conflicts }
                            end
                        end
                    },
                    {
                        Type = "STATUS",
                        Write = function() end,
                        Read = function()
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

                            local IncompatibleText
                            if vehicleIncompatibleCount > 1 then
                                IncompatibleText = string.format(SVMOD:GetLanguage("%s incompatibles"), vehicleIncompatibleCount)
                            else
                                IncompatibleText = string.format(SVMOD:GetLanguage("%s incompatible"), vehicleIncompatibleCount)
                            end


                            if vehicleIncompatibleCount == 0 then
                                return { Icon = "accept", Text = loadedText .. ", " .. IncompatibleText }
                            else
                                return { Icon = "exclamation", Text = loadedText .. ", " .. IncompatibleText }
                            end
                        end
                    },
                    {
                        Type = "STATUS",
                        Write = function() end,
                        Read = function()
                            if SVMOD.CFG.Contributor.IsEnabled then
                                return { Icon = "accept", Text = SVMOD:GetLanguage("Contributor mode enabled") }
                            else
                                return { Icon = "information", Text = SVMOD:GetLanguage("Contributor mode disabled") }
                            end
                        end
                    }
                }
            },
            {
                Name = "Global Settings",
                Color = Color(255, 255, 255),
                Description = nil,
                Controls = {
                    {
                        Type = "CHECKBOX",
                        Write = function()
                            net.WriteBool(SVMOD.CFG.IsEnabled)
                        end,
                        Read = function()
                            return {
                                Name = "Enable SVMod",
                                DefaultValue = net.ReadBool(),
                                OnChangeFun = function(self, value)
                                    SVMOD:SetAddonState(value)
                                    self:GetParent():GetParent():GetParent():Close() -- Close the frame
                                end
                            }
                        end
                    },
                    {
                        Type = "COMBOBOX",
                        Write = function() end,
                        Read = function()
                            return {
                                DefaultValue = SVMOD:GetLanguage("Language"),
                                Values = {
                                    {
                                        Value = "English",
                                        Data = "EN"
                                    },
                                    {
                                        Value = "Français",
                                        Data = "FR"
                                    }
                                },
                                OnChangeFun = function(self, _, _, data)
                                    SVMOD.CFG.Language = data
                                    SVMOD:Save()
                                    self:GetParent():GetParent():GetParent():Close()
                                end
                            }
                        end
                    }
                }
            },
            {
                Name = "Contributor Mode",
                Color = Color(255, 255, 255),
                Description = nil,
                Controls = function(panel)
                    local Panel_Contributor = vgui.Create("DPanel", panel)
                    Panel_Contributor:Dock(TOP)
                    Panel_Contributor:DockMargin(5, 0, 0, 0)
                    Panel_Contributor:SetSize(0, 27)
                    Panel_Contributor:SetDrawBackground(false)

                    local TextEntry_APIKey = vgui.Create("DTextEntry", Panel_Contributor)
                    TextEntry_APIKey:Dock(FILL)
                    TextEntry_APIKey:DockMargin(0, 0, 0, 0)
                    TextEntry_APIKey:SetPlaceholderText(SVMOD:GetLanguage("Enter your API key..."))
                    if SVMOD.CFG.Contributor.Key then
                        TextEntry_APIKey:SetText(SVMOD.CFG.Contributor.Key)
                    end
                    if SVMOD.CFG.Contributor.IsEnabled then
                        TextEntry_APIKey:SetDisabled(true)
                    end

                    local Button_APIKey = vgui.Create("DButton", Panel_Contributor)
                    Button_APIKey:Dock(RIGHT)
                    Button_APIKey:DockMargin(5, 0, 5, 0)
                    Button_APIKey:SetSize(100, 0)
                    Button_APIKey:SetText(SVMOD:GetLanguage("Enable"))
                    if SVMOD.CFG.Contributor.IsEnabled then
                        Button_APIKey:SetDisabled(true)
                    end
                    Button_APIKey.DoClick = function(self)
                        SVMOD.CFG.Contributor.Key = TextEntry_APIKey:GetValue()

                        http.Fetch("https://api.svmod.com/check_serial.php?serial=" .. TextEntry_APIKey:GetValue(), function(body, _, _, code)
                            if code == 200 then
                                notification.AddLegacy(SVMOD:GetLanguage("Contributor mode enabled") .. ".", NOTIFY_GENERIC, 5)

                                SVMOD.CFG.Contributor.IsEnabled = true

                                self:SetDisabled(true)
                                TextEntry_APIKey:SetDisabled(true)

                                SVMOD:Save()
                            else
                                notification.AddLegacy(SVMOD:GetLanguage("Invalid API key."), NOTIFY_ERROR, 5)
                            end
                        end, function()
                            notification.AddLegacy(SVMOD:GetLanguage("Server does not respond."), NOTIFY_ERROR, 5)
                        end)
                    end

                    local Panel_HelpAPI = vgui.Create("DPanel", Panel_Contributor)
                    Panel_HelpAPI:Dock(RIGHT)
                    Panel_HelpAPI:SetSize(22, 0)
                    Panel_HelpAPI:SetDrawBackground(false)

                    local Button_HelpAPI = vgui.Create("DImageButton", Panel_HelpAPI)
                    Button_HelpAPI:SetPos(5, 5)
                    Button_HelpAPI:SetSize(16, 16)
                    Button_HelpAPI:SetText("")
                    Button_HelpAPI:SetImage("icon16/help.png")
                end
            },
        }
    },
    {
        Name = "Shortcuts",
        Icon = "keyboard",
        SuperAdminOnly = false,
        Categories = {
            {
                Name = "Shortcuts list",
                Color = Color(255, 255, 255),
                Description = "The shortcuts below only work when you are in a vehicle. They are the same on all servers.",
                Controls = function(panel, savePanelFun)
                    local ShortcutsButton = {}

                    for i, s in ipairs(SVMOD.Shortcuts) do
                        local Panel_Shortcut = vgui.Create("DPanel", panel)
                        Panel_Shortcut:Dock(TOP)
                        Panel_Shortcut:DockMargin(5, 5, 0, 0)
                        Panel_Shortcut:SetSize(0, 25)
                        Panel_Shortcut:SetDrawBackground(false)

                        local Button_Shortcut = vgui.Create("DBinder", Panel_Shortcut)
                        Button_Shortcut:Dock(LEFT)
                        Button_Shortcut:SetSize(100, 0)
                        Button_Shortcut.OnChange = function(self, value)
                            self:SetText(string.upper(input.GetKeyName(value)))
                        end
                        Button_Shortcut:SetValue(s.Key)

                        ShortcutsButton[i] = Button_Shortcut

                        local Label_Shortcut = vgui.Create("DLabel", Panel_Shortcut)
                        Label_Shortcut:Dock(FILL)
                        Label_Shortcut:DockMargin(10, 0, 0, 0)
                        Label_Shortcut:SetText(SVMOD:GetLanguage(s.Name))
                        Label_Shortcut:SizeToContents()
                    end

                    savePanelFun(panel, function()
                        for i, b in ipairs(ShortcutsButton) do
                            SVMOD.Shortcuts[i].Key = b:GetValue()
                        end

                        SVMOD:Save()

                        notification.AddLegacy(SVMOD:GetLanguage("Shortcuts updated."), NOTIFY_GENERIC, 5)
                    end, function()
                        for i, b in ipairs(ShortcutsButton) do
                            b:SetValue(SVMOD.Shortcuts[i].DefaultKey)
                            SVMOD.Shortcuts[i].Key = SVMOD.Shortcuts[i].DefaultKey
                        end

                        SVMOD:Save()

                        notification.AddLegacy(SVMOD:GetLanguage("Shortcuts updated."), NOTIFY_GENERIC, 5)
                    end)
                end
            }
        }
    },
    {
        Name = "Options",
        Icon = "wrench_orange",
        SuperAdminOnly = false,
        ResetButton = true,
        Categories = {
            {
                Name = "Performance",
                Color = Color(255, 179, 0),
                Description = nil,
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Draw the projected lights of the headlights",
                                DefaultValue = SVMOD.CFG.Lights.DrawProjectedLights,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Lights.DrawProjectedLights = value
                                    SVMOD:Save()
                                end
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = false,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Enable shadows cast from the projected lights",
                                DefaultValue = SVMOD.CFG.Lights.DrawShadows,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Lights.DrawShadows = value
                                    SVMOD:Save()
                                end
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Draw smoke from damaged vehicles",
                                DefaultValue = SVMOD.CFG.Damage.DrawSmoke,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Damage.DrawSmoke = value
                                    SVMOD:Save()
                                end
                            }
                        end
                    }
                }
            },
            {
                Name = "Gameplay",
                Color = Color(255, 179, 0),
                Description = nil,
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Automatically disable the blinkers once the vehicle has been rotated",
                                DefaultValue = SVMOD.CFG.Lights.DisableBlinkersOnTurn,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Lights.DisableBlinkersOnTurn = value
                                    SVMOD:Save()
                                end
                            }
                        end
                    }
                }
            },
            {
                Name = "Volume",
                Color = Color(255, 179, 0),
                Description = nil,
                Controls = {
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Horn volume",
                                Min = 0,
                                Max = 1,
                                Decimal = 1,
                                DefaultValue = SVMOD.CFG.Sounds.Horn,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Sounds.Horn = math.Round(value, 2)
                                    SVMOD:Save()
                                end
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Write = function() end,
                        Read = function()
                            return {
                                Name = "Siren volume",
                                Min = 0,
                                Max = 1,
                                Decimal = 1,
                                DefaultValue = SVMOD.CFG.Sounds.Siren,
                                OnChangeFun = function(self, value)
                                    SVMOD.CFG.Sounds.Siren = math.Round(value, 2)
                                    SVMOD:Save()
                                end
                            }
                        end
                    }
                }
            },
        }
    },
    {
        Name = "Vehicles",
        Icon = "car",
        SuperAdminOnly = false,
        Categories = {
            {
                Controls = function(panel)
                    local Button = vgui.Create("DButton", panel)
                    Button:Dock(BOTTOM)
                    Button:DockMargin(0, 5, 0, 0)
                    Button:SetSize(0, 30)
                    Button:SetText(SVMOD:GetLanguage("Update vehicle data"))

                    local ListView = vgui.Create("DListView", panel)
                    ListView:Dock(FILL)
                    ListView:AddColumn(SVMOD:GetLanguage("Name"))
                    ListView:AddColumn(SVMOD:GetLanguage("Category"))
                    ListView:AddColumn(SVMOD:GetLanguage("Author"))
                    ListView:AddColumn(SVMOD:GetLanguage("Last edition"))

                    ListView.OnRowRightClick = function(_, _, panel)
                        if panel:GetColumnText(3) == "-" then
                            if SVMOD.CFG.Contributor.IsEnabled then
                                local Menu = DermaMenu()

                                Menu:AddOption(SVMOD:GetLanguage("Create"), function()
                                    SVMOD:Editor_Open(panel.Model)
                                end):SetIcon("icon16/pencil.png")

                                Menu:Open()
                            end
                        else
                            local Menu = DermaMenu()

                            if SVMOD.CFG.Contributor.IsEnabled then
                                Menu:AddOption(SVMOD:GetLanguage("Edit"), function()
                                    SVMOD:Editor_Open(panel.Model)
                                end):SetIcon("icon16/pencil.png")
                            end

                            Menu:AddOption(SVMOD:GetLanguage("Author profile"), function()
                                gui.OpenURL("http://steamcommunity.com/profiles/" .. panel.Data.Author.SteamID64)
                            end):SetIcon("icon16/user.png")

                            Menu:AddOption(SVMOD:GetLanguage("Report"), function()
                                SVMOD:OpenReportMenu(panel.Model, panel.Data.Timestamp)
                            end):SetIcon("icon16/exclamation.png")

                            Menu:Open()
                        end
                    end

                    local function UpdateVehicleList()
                        if not IsValid(ListView) then return end

                        ListView:Clear()

                        if not SVMOD.Data then return end

                        for _, veh in ipairs(SVMOD:GetVehicleList()) do
                            local VehicleData = SVMOD:GetData(veh.Model)
                            local Line
                            if VehicleData then
                                Line = ListView:AddLine(veh.Name, veh.Category, VehicleData.Author.Name, os.date("%d/%m/%Y - %H:%M", VehicleData.Timestamp))
                                Line.Data = VehicleData
                            else
                                Line = ListView:AddLine(veh.Name, veh.Category, "-", "-")
                            end
                            Line.Model = veh.Model
                        end
                    end
                    UpdateVehicleList()

                    Button.DoClick = function()
                        SVMOD:Data_Update()

                        if LocalPlayer():IsSuperAdmin() then
                            net.Start("SV_UpdateData")
                            net.SendToServer()
                        end

                        timer.Simple(1, function()
                            UpdateVehicleList()
                            notification.AddLegacy(SVMOD:GetLanguage("Vehicle data has been updated."), NOTIFY_GENERIC, 5)
                        end)
                    end
                end
            }
        }
    },
    {
        Name = "Seats",
        Icon = "wrench",
        SuperAdminOnly = true,
        SaveButton = true,
        ResetButton = true,
        Categories = {
            {
                Name = "Seats",
                Color = Color(0, 119, 255),
                Description = nil,
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Seats",
                        Name = "IsSwitchEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable seat changing from inside the vehicle",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Seats",
                        Name = "IsKickEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable the ability to exclude passengers as drivers",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Seats",
                        Name = "IsLockEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable the ability to lock/unlock the vehicle from the inside",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    }
                }
            }
        }
    },
    {
        Name = "Lights",
        Icon = "lightbulb",
        SuperAdminOnly = true,
        SaveButton = true,
        ResetButton = true,
        Categories = {
            {
                Name = "Headlights",
                Color = Color(0, 119, 255),
                Description = "Lights on the front of a vehicle, used for driving at night.",
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "AreHeadlightsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable headlights",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "TurnOffHeadlightsOnExit",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Turning off the headlights when the driver exits the vehicle",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 10,
                        Category = "Lights",
                        Name = "TimeTurnOffHeadlights",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Time to deactivate the headlights (in seconds)",
                                Min = 0,
                                Max = 300,
                                Decimal = 0,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            },
            {
                Name = "Blinkers and Hazard lights",
                Color = Color(0, 119, 255),
                Description = "Blinkers are lights that turn on and off quickly to show other people you are going to turn in that direction. Hazard lights are lights at the front and back of a vehicle to warn other drivers of danger. Blinkers and hazard lights use the same options below.",
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "AreHazardLightsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable hazard lights",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "TurnOffHazardOnExit",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Turning off the hazard lights when the driver exits the vehicle",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 120,
                        Category = "Lights",
                        Name = "TimeTurnOffHazard",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Time to deactivate the hazard lights (in seconds)",
                                Min = 0,
                                Max = 300,
                                Decimal = 0,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            },
            {
                Name = "Reverse lights",
                Color = Color(0, 119, 255),
                Description = "Light at the back of a vehicle that signals that it is going backward.",
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "AreReverseLightsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable reverse lights",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                }
            },
            {
                Name = "Flashing lights",
                Color = Color(0, 119, 255),
                Description = "Rotating light placed on the roof of certain priority vehicles.",
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "AreFlashingLightsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable flashing lights",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Lights",
                        Name = "TurnOffFlashingLightsOnExit",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Turning off the flashing lights when the driver exits the vehicle",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 10,
                        Category = "Lights",
                        Name = "TimeTurnOffFlashingLights",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Time to deactivate the flashing lights (in seconds)",
                                Min = 0,
                                Max = 300,
                                Decimal = 0,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            }
        }
    },
    {
        Name = "Sounds",
        Icon = "sound",
        SuperAdminOnly = true,
        SaveButton = true,
        ResetButton = true,
        Categories = {
            {
                Name = "Horn",
                Color = Color(0, 119, 255),
                Description = nil,
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Horn",
                        Name = "IsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable the vehicle horn",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    }
                }
            }
        }
    },
    {
        Name = "Damages",
        Icon = "heart",
        SuperAdminOnly = true,
        SaveButton = true,
        ResetButton = true,
        Categories = {
            {
                Name = "Vehicle damage",
                Color = Color(0, 119, 255),
                Description = "Vehicles can receive damage and lose health. A vehicle with no more health can explode, carbonizing the car and\nmaking it unrepairable.",
                Controls = {
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Damage",
                        Name = "PhysicsMultiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Physics damage multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Damage",
                        Name = "BulletMultiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Bullet damage multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 10,
                        Category = "Damage",
                        Name = "CarbonisedChance",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Chance that the vehicle carbonises",
                                Min = 0,
                                Max = 100,
                                Decimal = 0,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 25,
                        Category = "Damage",
                        Name = "SmokePercent",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Percentage of life before the vehicle smokes",
                                Min = 1,
                                Max = 99,
                                Decimal = 0,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            },
            {
                Name = "Player damage",
                Color = Color(0, 119, 255),
                Description = nil,
                Controls = {
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Damage",
                        Name = "DriverMultiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Driver damage multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Damage",
                        Name = "PassengerMultiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Passenger damage multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Damage",
                        Name = "PlayerExitMultiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Exit damage multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            }
        }
    },
    {
        Name = "Fuel",
        Icon = "database",
        SuperAdminOnly = true,
        SaveButton = true,
        ResetButton = true,
        Categories = {
            {
                Name = "Fuel",
                Color = Color(0, 119, 255),
                Description = "Vehicles consume fuel for every meter driven. A vehicle that runs out of fuel will no longer be able to be driven.",
                Controls = {
                    {
                        Type = "CHECKBOX",
                        ResetValue = true,
                        Category = "Fuel",
                        Name = "IsEnabled",
                        Write = function(self)
                            net.WriteBool(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Enable fuel consumption on vehicles",
                                DefaultValue = net.ReadBool()
                            }
                        end
                    },
                    {
                        Type = "NUMSLIDER",
                        ResetValue = 1,
                        Category = "Fuel",
                        Name = "Multiplier",
                        Write = function(self)
                            net.WriteFloat(SVMOD.CFG[self.Category][self.Name])
                        end,
                        Read = function()
                            return {
                                Name = "Fuel consumption multiplier",
                                Min = 0,
                                Max = 2,
                                Decimal = 1,
                                DefaultValue = net.ReadFloat()
                            }
                        end
                    }
                }
            }
        }
    }
}