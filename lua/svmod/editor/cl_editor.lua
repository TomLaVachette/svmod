local SeatList
local NumSlider_Capacity
local NumSlider_Consumption

local function CreateCategory(panel, color, name, description)
    local Label_Category = vgui.Create("DLabel", panel)
    Label_Category:Dock(TOP)
    Label_Category:DockMargin(10, 5, 0, 5)
    Label_Category:SetFont("DermaDefaultBold")
    Label_Category:SetTextColor(color)
    Label_Category:SetText(name)
    Label_Category:SizeToContents()

    local Panel_Separator = vgui.Create("DPanel", panel)
    Panel_Separator:Dock(TOP)
    Panel_Separator:DockMargin(5, 0, 0, 5)
    Panel_Separator.Paint = function(self, width, height)
        surface.SetDrawColor(color.r, color.g, color.b, 255)
        surface.DrawRect(0, 0, width, height)
    end
    Panel_Separator:SetSize(0, 1)

    if description then
        local Label_Description = vgui.Create("DLabel", panel)
        Label_Description:Dock(TOP)
        Label_Description:DockMargin(10, 5, 0, 5)
        Label_Description:SetText(description)
        Label_Description:SizeToContents()
    end
end

local function CreateInformationsPanel(veh, frame, author)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    CreateCategory(Panel, Color(255, 255, 255), "Informations", "Press F2 to get or lose the focus on the window to write text.")

    local TextEntry_Name = vgui.Create("DTextEntry", Panel)
    TextEntry_Name:Dock(TOP)
    TextEntry_Name:DockMargin(10, 5, 5, 2)
    TextEntry_Name:SetSize(0, 25)
    TextEntry_Name:SetEditable(true)
    TextEntry_Name:SetPlaceholderText("Author name")
    if author.Name then
        TextEntry_Name:SetValue(author.Name)
    end

    local Button_Close = vgui.Create("DButton", Panel)
    Button_Close:Dock(BOTTOM)
    Button_Close:DockMargin(2, 0, 2, 2)
    Button_Close:SetSize(0, 35)
    Button_Close:SetText("Cancel")
    Button_Close:SetTextColor(Color(255, 0, 0))
    Button_Close.DoClick = function()
        local Frame = vgui.Create("DFrame")
        Frame:SetSize(300, 100)
        Frame:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 50)
        Frame:SetTitle("Disclaimer")
        Frame:MakePopup()

        local Button_Continue = vgui.Create("DButton", Frame)
        Button_Continue:Dock(BOTTOM)
        Button_Continue:DockMargin(50, 0, 50, 5)
        Button_Continue:SetText("Exit anyway")
        Button_Continue:SetTextColor(Color(255, 0, 0))
        Button_Continue.DoClick = function()
            frame:Close()
            Frame:Close()
        end

        local Label_Text = vgui.Create("DLabel", Frame)
        Label_Text:Dock(FILL)
        Label_Text:DockMargin(10, 0, 0, 0)
        Label_Text:SetText("You will leave the edit menu.\nAny changes you make will be lost!")
        Label_Text:SizeToContents()
    end

    local Button_Save = vgui.Create("DButton", Panel)
    Button_Save:Dock(BOTTOM)
    Button_Save:DockMargin(2, 0, 2, 2)
    Button_Save:SetSize(0, 35)
    Button_Save:SetText("Save")
    Button_Save:SetTextColor(Color(12, 135, 0))
    Button_Save.DoClick = function()
        local Table = table.Copy(veh.SV_Data)

        Table.Timestamp = nil

        -- Author
        Table.Author.Name = TextEntry_Name:GetValue()
        Table.Author.SteamID64 = LocalPlayer():SteamID64()

        -- Seats
        Table.Seats = {}
        for _, s in pairs(SeatList:GetLines()) do
            local Index = tonumber(s:GetColumnText(1))
            if IsValid(s.Seat) then
                Table.Seats[Index] = {
                    Position = s.Seat:GetLocalPos(),
                    Angle = s.Seat:GetLocalAngles()
                }
            end
        end

        for _, v in ipairs(Table.FlashingLights) do
            if v.Sprite then
                v.Sprite.CurrentAngle = nil
            end

            if v.SpriteCircle then
                v.SpriteCircle.CurrentAngle = nil
            end
        end

        -- Fuel
        Table.Fuel = {
            Capacity = NumSlider_Capacity:GetValue(),
            Consumption = NumSlider_Consumption:GetValue()
        }

        HTTP({
            url = "https://api.svmod.com/add_vehicle.php",
            method = "POST",
            parameters = {
                model = veh:GetModel(),
                json = util.TableToJSON(Table),
                serial = SVMOD.CFG.Contributor.Key
            },
            success = function(code, body)
                if code == 200 then
                    notification.AddLegacy("Data was sent successfully.", NOTIFY_GENERIC, 5)

                    SVMOD:Data_Update()
                else
                    notification.AddLegacy("Invalid API key.", NOTIFY_ERROR, 5)
                end
            end,
            failed = function()
                notification.AddLegacy("Server does not respond.", NOTIFY_ERROR, 5)
            end
        })

        frame:Close()
    end

    return Panel
end

local function CreateSeatPanel(veh, seats)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    local Panel_Left = vgui.Create("DPanel", Panel)
    Panel_Left:Dock(LEFT)
    Panel_Left:SetSize(60, 0)
    Panel_Left:SetDrawBackground(false)

    SeatList = vgui.Create("DListView", Panel_Left)
    SeatList:Dock(FILL)
    SeatList:SetMultiSelect(true)
    SeatList:AddColumn("Index")

    hook.Add("PreDrawHalos", "Sv_Editor_Halo", function()
        local _, Line = SeatList:GetSelectedLine()
        if Line and IsValid(Line.Seat) then
            halo.Add({ Line.Seat }, Color(255, 0, 0), 2, 2, 1, true, true)
        end
    end)

    Panel.OnRemove = function()
        for _, line in pairs(SeatList:GetLines()) do
            if IsValid(line.Seat) then
                line.Seat:Remove()
            end
        end

        hook.Remove("PreDrawHalos", "Sv_Editor_Halo")
    end

    local function AddSeat(position, angles)
        local Max = 0
        for _, line in pairs(SeatList:GetLines()) do
            local Index = tonumber(line:GetColumnText(1))
            if Index > Max then
                Max = Index
            end
        end

        local Line = SeatList:AddLine(Max + 1)
        Line.Seat = SVMOD:CreateCSSeat(veh)
        Line.Seat:SetParent(veh)
        Line.Seat:SetLocalPos(position)
        Line.Seat:SetLocalAngles(angles)
    end

    local function RemoveSeat(index)
        local Line = SeatList:GetLine(index)
        ColumnText = tonumber(Line:GetColumnText(1))
        if IsValid(Line.Seat) then
            Line.Seat:Remove()
        end

        for _, v in pairs(SeatList:GetLines()) do
            local Index = tonumber(v:GetColumnText(1))
            if Index > ColumnText then
                v:SetColumnText(1, Index - 1)
            end
        end

        SeatList:RemoveLine(index)
    end

    local function UpSeat(index)
        local Line = SeatList:GetLine(index)
        LineIndex = tonumber(Line:GetColumnText(1))

        for _, v in pairs(SeatList:GetLines()) do
            local TempIndex = tonumber(v:GetColumnText(1))
            if IsValid(v.Seat) and TempIndex == LineIndex - 1 then
                Line.Seat, v.Seat = v.Seat, Line.Seat
                break
            end
        end
    end

    local function DownSeat(index)
        local Line = SeatList:GetLine(index)
        LineIndex = tonumber(Line:GetColumnText(1))

        for _, v in pairs(SeatList:GetLines()) do
            local TempIndex = tonumber(v:GetColumnText(1))
            if IsValid(v.Seat) and TempIndex == LineIndex + 1 then
                Line.Seat, v.Seat = v.Seat, Line.Seat
                break
            end
        end
    end

    local Button_AddSeat = vgui.Create("DButton", Panel_Left)
    Button_AddSeat:Dock(BOTTOM)
    Button_AddSeat:DockMargin(0, 2, 0, 0)
    Button_AddSeat:SetSize(0, 30)
    Button_AddSeat:SetText("+")
    Button_AddSeat.DoClick = function()
        AddSeat(Vector(0, 0, 0), Angle(0, 0, 0))
    end

    local function CreateNumSlider(name, min, max, decimal)
        local NumSlider = vgui.Create("DNumSlider", Panel)
        NumSlider:Dock(TOP)
        NumSlider:DockMargin(5, 0, 0, 0)
        NumSlider:SetSize(0, 25)
        NumSlider:SetText(name)
        NumSlider:SetMin(min)
        NumSlider:SetMax(max)
        NumSlider:SetDecimals(decimal)
        NumSlider:SetValue(0)

        return NumSlider
    end

    local Label_Message = vgui.Create("DLabel", Panel)
    Label_Message:Dock(TOP)
    Label_Message:DockMargin(5, 0, 0, 0)
    Label_Message:SetText("The driver's seat is always the first seat index (1).")
    Label_Message:SizeToContents()

    CreateCategory(Panel, Color(255, 255, 255), "Position")

    local NumSlider_XPosition = CreateNumSlider("X Position", -200, 200, 1)
    local NumSlider_YPosition = CreateNumSlider("Y Position", -200, 200, 1)
    local NumSlider_ZPosition = CreateNumSlider("Z Position", -200, 200, 1)

    CreateCategory(Panel, Color(255, 255, 255), "Angle")

    local NumSlider_XAngle = CreateNumSlider("X Angle", -180, 180, 0)
    local NumSlider_YAngle = CreateNumSlider("Y Angle", -180, 180, 0)
    local NumSlider_ZAngle = CreateNumSlider("Z Angle", -180, 180, 0)

    for _, seat in ipairs(seats) do
        AddSeat(seat.Position, seat.Angle)
    end

    SeatList.OnRowRightClick = function(_, index, e)
        local Menu = DermaMenu()

        Menu:AddOption("Up", function()
            UpSeat(index)
        end):SetIcon("icon16/arrow_up.png")

        Menu:AddOption("Down", function()
            DownSeat(index)
        end):SetIcon("icon16/arrow_down.png")

        Menu:AddOption("Symmetric", function()
            for _, line in pairs(SeatList:GetSelected()) do
                local Position = line.Seat:GetLocalPos()
                Position.x = -Position.x
                AddSeat(Position, line.Seat:GetLocalAngles())
            end
        end):SetIcon("icon16/arrow_refresh.png")

        Menu:AddOption("Delete", function()
            RemoveSeat(index)
        end):SetIcon("icon16/cross.png")

        Menu:Open()
    end
    
    local SelectedSeatPanel
    SeatList.OnRowSelected = function(_, _, e)
        local Position = e.Seat:GetLocalPos()
        
        NumSlider_XPosition.OnValueChanged = function(self, value)
            local Pos = e.Seat:GetLocalPos()
            e.Seat:SetLocalPos(Vector(value, Pos.y, Pos.z))
        end
        NumSlider_XPosition:SetValue(Position.x)
        
        NumSlider_YPosition.OnValueChanged = function(self, value)
            local Pos = e.Seat:GetLocalPos()
            e.Seat:SetLocalPos(Vector(Pos.x, value, Pos.z))
        end
        NumSlider_YPosition:SetValue(Position.y)
        
        NumSlider_ZPosition.OnValueChanged = function(self, value)
            local Pos = e.Seat:GetLocalPos()
            e.Seat:SetLocalPos(Vector(Pos.x, Pos.y, value))
        end
        NumSlider_ZPosition:SetValue(Position.z)
        

        local Angles = e.Seat:GetLocalAngles()

        NumSlider_XAngle.OnValueChanged = function(self, value)
            local Ang = e.Seat:GetLocalAngles()
            e.Seat:SetLocalAngles(Angle(math.floor(value), Ang.y, Ang.z))
        end
        NumSlider_XAngle:SetValue(Angles.x)

        NumSlider_YAngle.OnValueChanged = function(self, value)
            local Ang = e.Seat:GetLocalAngles()
            e.Seat:SetLocalAngles(Angle(Ang.x, math.floor(value), Ang.z))
        end
        NumSlider_YAngle:SetValue(Angles.y)

        NumSlider_ZAngle.OnValueChanged = function(self, value)
            local Ang = e.Seat:GetLocalAngles()
            e.Seat:SetLocalAngles(Angle(Ang.x, Ang.y, math.floor(value)))
        end
        NumSlider_ZAngle:SetValue(Angles.z)
    end

    return Panel
end

local function CreatePartPanel(veh, parts)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    local Panel_Left = vgui.Create("DPanel", Panel)
    Panel_Left:Dock(LEFT)
    Panel_Left:SetSize(60, 0)
    Panel_Left:SetDrawBackground(false)

    PartList = vgui.Create("DListView", Panel_Left)
    PartList:Dock(FILL)
    PartList:SetMultiSelect(true)
    PartList:AddColumn("Index")

    Panel.OnRemove = function()
        SVMOD.DrawParts = false
    end

    local function UpdateList()
        PartList:Clear()

        for i, p in ipairs(parts) do
            local Line = PartList:AddLine(i)
            Line.Data = p
            p.Health = 50
        end

        PartList:SelectFirstItem()
    end
    UpdateList()

    local function AddPart(position, angles)
        table.insert(parts, {
            Position = position,
            Angle = angles
        })

        UpdateList()
    end

    local function RemovePart(index)
        table.remove(parts, index)

        UpdateList()
    end

    local Button_AddPart = vgui.Create("DButton", Panel_Left)
    Button_AddPart:Dock(BOTTOM)
    Button_AddPart:DockMargin(0, 2, 0, 0)
    Button_AddPart:SetSize(0, 30)
    Button_AddPart:SetText("+")
    Button_AddPart.DoClick = function()
        AddPart(Vector(0, 0, 0), Angle(0, 0, 0))
    end

    local function CreateNumSlider(name, min, max, decimal)
        local NumSlider = vgui.Create("DNumSlider", Panel)
        NumSlider:Dock(TOP)
        NumSlider:DockMargin(5, 0, 0, 0)
        NumSlider:SetSize(0, 25)
        NumSlider:SetText(name)
        NumSlider:SetMin(min)
        NumSlider:SetMax(max)
        NumSlider:SetDecimals(decimal)
        NumSlider:SetValue(0)

        return NumSlider
    end

    CreateCategory(Panel, Color(255, 255, 255), "Position")

    local NumSlider_XPosition = CreateNumSlider("X Position", -200, 200, 1)
    local NumSlider_YPosition = CreateNumSlider("Y Position", -200, 200, 1)
    local NumSlider_ZPosition = CreateNumSlider("Z Position", -200, 200, 1)

    CreateCategory(Panel, Color(255, 255, 255), "Angle")

    local NumSlider_XAngle = CreateNumSlider("X Angle", -180, 180, 0)
    local NumSlider_YAngle = CreateNumSlider("Y Angle", -180, 180, 0)
    local NumSlider_ZAngle = CreateNumSlider("Z Angle", -180, 180, 0)

    PartList.OnRowRightClick = function(_, index, e)
        local Menu = DermaMenu()

        Menu:AddOption("Symmetric", function()
            for _, line in pairs(PartList:GetSelected()) do
                local Position = line.Data.Position
                local Angles = line.Data.Angle
                AddPart(Vector(-Position.x, Position.y - 18, Position.z), Angle(Angles.x, -Angles.y, -Angles.z))
            end
        end):SetIcon("icon16/arrow_refresh.png")

        Menu:AddOption("Delete", function()
            local DeleteList = {}
            for _, line in pairs(PartList:GetSelected()) do
                table.insert(DeleteList, line:GetColumnText(1))
            end

            table.sort(DeleteList, function(a, b) return a > b end )

            for _, v in ipairs(DeleteList) do
                RemovePart(v)
            end
        end):SetIcon("icon16/cross.png")

        Menu:Open()
    end
    
    local SelectedSeatPanel
    PartList.OnRowSelected = function(_, _, e)
        NumSlider_XPosition.OnValueChanged = function(self, value)
            e.Data.Position.x = math.Round(value, 1)
        end
        NumSlider_XPosition:SetValue(e.Data.Position.x)
        
        NumSlider_YPosition.OnValueChanged = function(self, value)
            e.Data.Position.y = math.Round(value, 1)
        end
        NumSlider_YPosition:SetValue(e.Data.Position.y)
        
        NumSlider_ZPosition.OnValueChanged = function(self, value)
            e.Data.Position.z = math.Round(value, 1)
        end
        NumSlider_ZPosition:SetValue(e.Data.Position.z)

        NumSlider_XAngle.OnValueChanged = function(self, value)
            e.Data.Angle.x = math.floor(value)
        end
        NumSlider_XAngle:SetValue(e.Data.Angle.x)

        NumSlider_YAngle.OnValueChanged = function(self, value)
            e.Data.Angle.y = math.floor(value)
        end
        NumSlider_YAngle:SetValue(e.Data.Angle.y)

        NumSlider_ZAngle.OnValueChanged = function(self, value)
            e.Data.Angle.z = math.floor(value)
        end
        NumSlider_ZAngle:SetValue(e.Data.Angle.z)
    end

    return Panel
end

local function CreateLightsPanel(veh, lights, copyTo)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    local Panel_Left = vgui.Create("DPanel", Panel)
    Panel_Left:Dock(LEFT)
    Panel_Left:SetSize(60, 0)
    Panel_Left:SetDrawBackground(false)

    local LightList = vgui.Create("DListView", Panel_Left)
    LightList:Dock(FILL)
    LightList:SetMultiSelect(true)
    LightList:AddColumn("Index")

    local function UpdateList()
        LightList:Clear()

        for i, l in ipairs(lights) do
            local Line = LightList:AddLine(i)
            Line.Data = l
        end

        LightList:SelectFirstItem()
    end

    local function RemoveLight(index)
        local Line = LightList:GetLine(index)
        ColumnText = tonumber(Line:GetColumnText(1))

        table.remove(lights, ColumnText)

        UpdateList()
    end

    local function UpLight(index)
        local Line = LightList:GetLine(index)
        LineIndex = tonumber(Line:GetColumnText(1))
        if LineIndex == 1 then return end

        local Element = table.remove(lights, LineIndex)
        table.insert(lights, LineIndex - 1, Element)

        UpdateList()
    end

    local function DownLight(index)
        local Line = LightList:GetLine(index)
        LineIndex = tonumber(Line:GetColumnText(1))
        if LineIndex == #LightList:GetLines() then return end

        local Element = table.remove(lights, LineIndex)
        table.insert(lights, LineIndex + 1, Element)

        UpdateList()
    end

    local Button_AddLight = vgui.Create("DButton", Panel_Left)
    Button_AddLight:Dock(BOTTOM)
    Button_AddLight:DockMargin(0, 2, 0, 0)
    Button_AddLight:SetSize(0, 30)
    Button_AddLight:SetText("+")
    Button_AddLight.DoClick = function()
        table.insert(lights, {
            Sprite = {
                Position = Vector(0, 0, 0),
                Color = Color(255, 255, 255),
                Size = 30
            }
        })

        UpdateList()
    end

    local function CreateNumSlider(panel, name, min, max, decimal)
        local NumSlider = vgui.Create("DNumSlider", panel)
        NumSlider:Dock(TOP)
        NumSlider:DockMargin(10, 0, 0, 0)
        NumSlider:SetSize(0, 25)
        NumSlider:SetText(name)
        NumSlider:SetMin(min)
        NumSlider:SetMax(max)
        NumSlider:SetDecimals(decimal)
        NumSlider:SetValue(0)

        return NumSlider
    end

    UpdateList()

    LightList.OnRowRightClick = function(_, index, e)
        local Menu = DermaMenu()

        Menu:AddOption("Up", function()
            UpLight(index)
        end):SetIcon("icon16/arrow_up.png")

        Menu:AddOption("Down", function()
            DownLight(index)
        end):SetIcon("icon16/arrow_down.png")

        local CopyChild, CopyParent = Menu:AddSubMenu("Copy")
        CopyParent:SetIcon("icon16/page_copy.png")

        if e.Data.ProjectedTexture and e.Data.Sprite then
            CopyChild:AddOption("Sprite to Projected light", function()
                e.Data.ProjectedTexture.Position = Vector(
                    math.floor(e.Data.Sprite.Position.x),
                    math.floor(e.Data.Sprite.Position.y),
                    math.floor(e.Data.Sprite.Position.z)
                )

                UpdateList()
            end):SetIcon("icon16/weather_sun.png")
        end

        if e.Data.SpriteLine then
            CopyChild:AddOption("Position 1 to Position 2", function()
                e.Data.SpriteLine.Position2 = e.Data.SpriteLine.Position1

                UpdateList()
            end):SetIcon("icon16/weather_sun.png")
        end

        for i, l in ipairs(lights) do
            if i ~= tonumber(e:GetColumnText(1)) then
                CopyChild:AddOption("From light #" .. i, function()
                    if l.Sprite then
                        e.Data.Sprite = {}
                        e.Data.Sprite.Position = l.Sprite.Position
                        e.Data.Sprite.Color = l.Sprite.Color
                        e.Data.Sprite.Width = l.Sprite.Width
                        e.Data.Sprite.Height = l.Sprite.Height
                        e.Data.Sprite.ActiveTime = l.Sprite.ActiveTime
                        e.Data.Sprite.HiddenTime = l.Sprite.HiddenTime
                        e.Data.Sprite.OffsetTime = l.Sprite.OffsetTime
                    end

                    if l.SpriteLine then
                        e.Data.SpriteLine = {}
                        e.Data.SpriteLine.Position1 = l.SpriteLine.Position1
                        e.Data.SpriteLine.Position2 = l.SpriteLine.Position2
                        e.Data.SpriteLine.Color = l.SpriteLine.Color
                        e.Data.SpriteLine.Width = l.SpriteLine.Width
                        e.Data.SpriteLine.Height = l.SpriteLine.Height
                        e.Data.SpriteLine.Count = l.SpriteLine.Count
                    end

                    if l.SpriteCircle then
                        e.Data.SpriteCircle = {}
                        e.Data.SpriteCircle.Position = l.SpriteCircle.Position
                        e.Data.SpriteCircle.Color = l.SpriteCircle.Color
                        e.Data.SpriteCircle.Width = l.SpriteCircle.Width
                        e.Data.SpriteCircle.Height = l.SpriteCircle.Height
                        e.Data.SpriteCircle.Radius = l.SpriteCircle.Radius
                        e.Data.SpriteCircle.Speed = l.SpriteCircle.Speed
                        e.Data.SpriteCircle.ActiveTime = l.SpriteCircle.ActiveTime
                        e.Data.SpriteCircle.HiddenTime = l.SpriteCircle.HiddenTime
                        e.Data.SpriteCircle.OffsetTime = l.SpriteCircle.OffsetTime
                    end

                    if l.ProjectedTexture then
                        e.Data.ProjectedTexture = {}
                        e.Data.ProjectedTexture.Position = l.ProjectedTexture.Position
                        e.Data.ProjectedTexture.Angle = l.ProjectedTexture.Angle
                        e.Data.ProjectedTexture.Color = l.ProjectedTexture.Color
                        e.Data.ProjectedTexture.Size = l.ProjectedTexture.Size
                        e.Data.ProjectedTexture.FOV = l.ProjectedTexture.FOV
                    end

                    UpdateList()
                end):SetIcon("icon16/lightbulb_off.png")
            end
        end

        Menu:AddOption("Symmetric", function()
            for _, line in pairs(LightList:GetSelected()) do
                local Copy = util.JSONToTable(util.TableToJSON(line.Data))

                if Copy.ProjectedTexture then
                    Copy.ProjectedTexture.Position.x = -Copy.ProjectedTexture.Position.x
                end

                if Copy.Sprite then
                    Copy.Sprite.Position.x = -Copy.Sprite.Position.x
                end

                if Copy.SpriteLine then
                    Copy.SpriteLine.Position1.x = -Copy.SpriteLine.Position1.x
                    Copy.SpriteLine.Position2.x = -Copy.SpriteLine.Position2.x
                end

                if Copy.SpriteCircle then
                    Copy.SpriteCircle.Position.x = -Copy.SpriteCircle.Position.x
                end

                if copyTo then
                    table.insert(copyTo, Copy)
                else
                    table.insert(lights, Copy)
                end
            end

            UpdateList()
        end):SetIcon("icon16/arrow_refresh.png")

        --[[
            ADD
        --]]

        local Child, Parent = Menu:AddSubMenu("Add")
        Parent:SetIcon("icon16/add.png")
        
        if not e.Data.ProjectedTexture then
            Child:AddOption("Projected light", function()
                local Position = Vector(0, 0, 0)
                if e.Data.Sprite then
                    Position = e.Data.Sprite.Position
                end

                e.Data.ProjectedTexture = {
                    Position = Position,
                    Angle = Angle(0, 90, 0),
                    Color = Color(255, 255, 255),
                    Size = 1000,
                    FOV = 110
                }

                UpdateList()
            end):SetIcon("icon16/weather_sun.png")
        end

        if not e.Data.Sprite then
            Child:AddOption("Sprite", function()
                e.Data.Sprite = {
                    Position = Vector(0, 0, 0),
                    Color = Color(255, 255, 255),
                    Width = 25,
                    Height = 25,
                    ActiveTime = 0,
                    HiddenTime = 0,
                    OffsetTime = 0
                }

                UpdateList()
            end):SetIcon("icon16/color_wheel.png")
        end

        if not e.Data.SpriteLine then
            Child:AddOption("Sprite line", function()
                e.Data.SpriteLine = {
                    Position1 = Vector(0, 0, 0),
                    Position2 = Vector(0, 0, 0),
                    Color = Color(255, 255, 255),
                    Count = 10,
                    Width = 10,
                    Height = 10
                }

                UpdateList()
            end):SetIcon("icon16/chart_line.png")
        end

        if not e.Data.SpriteCircle then
            Child:AddOption("Sprite circle", function()
                e.Data.SpriteCircle = {
                    Position = Vector(0, 0, 0),
                    Color = Color(255, 255, 255),
                    Width = 25,
                    Height = 25,
                    Radius = 15,
                    Speed = 0.1,
                    ActiveTime = 0,
                    HiddenTime = 0,
                    OffsetTime = 0
                }

                UpdateList()
            end):SetIcon("icon16/vector.png")
        end

        --[[
            DELETE
        --]]

        local Child, Parent = Menu:AddSubMenu("Delete")
        Parent:SetIcon("icon16/delete.png")
        
        Child:AddOption("Projected light", function()
            e.Data.ProjectedTexture = nil

            UpdateList()
        end):SetIcon("icon16/weather_sun.png")

        Child:AddOption("Sprite", function()
            e.Data.Sprite = nil

            UpdateList()
        end):SetIcon("icon16/color_wheel.png")

        Child:AddOption("Sprite Line", function()
            e.Data.SpriteLine = nil

            UpdateList()
        end):SetIcon("icon16/chart_line.png")

        Child:AddOption("Sprite Circle", function()
            e.Data.SpriteCircle = nil

            UpdateList()
        end):SetIcon("icon16/vector.png")

        Menu:AddOption("Delete", function()
            local DeleteList = {}
            for _, line in pairs(LightList:GetSelected()) do
                table.insert(DeleteList, line:GetColumnText(1))
            end

            table.sort(DeleteList, function(a, b) return a > b end )

            for _, v in ipairs(DeleteList) do
                RemoveLight(v)
            end
        end):SetIcon("icon16/cross.png")

        Menu:Open()
    end
    
    local PropertySheet
    LightList.OnRowSelected = function(_, _, e)
        if IsValid(PropertySheet) then
            PropertySheet:Remove()
        end
    
        PropertySheet = vgui.Create("DPropertySheet", Panel)
        PropertySheet:Dock(FILL)
        PropertySheet:DockMargin(5, 0, 0, 0)

        if e.Data.Sprite then
            local Panel_Sprite = vgui.Create("DPanel", PropertySheet)
            Panel_Sprite:SetDrawBackground(false)
            PropertySheet:AddSheet("Sprite", Panel_Sprite, "icon16/color_wheel.png")

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Position")

            local NumSlider_XPosition = CreateNumSlider(Panel_Sprite, "X Position", -200, 200, 1)
            NumSlider_XPosition:SetValue(e.Data.Sprite.Position.x)
            NumSlider_XPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Position = Vector(value, l.Data.Sprite.Position.y, l.Data.Sprite.Position.z)
                end
            end

            local NumSlider_YPosition = CreateNumSlider(Panel_Sprite, "Y Position", -200, 200, 1)
            NumSlider_YPosition:SetValue(e.Data.Sprite.Position.y)
            NumSlider_YPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Position = Vector(l.Data.Sprite.Position.x, value, l.Data.Sprite.Position.z)
                end
            end

            local NumSlider_ZPosition = CreateNumSlider(Panel_Sprite, "Z Position", -200, 200, 1)
            NumSlider_ZPosition:SetValue(e.Data.Sprite.Position.z)
            NumSlider_ZPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Position = Vector(l.Data.Sprite.Position.x, l.Data.Sprite.Position.y, value)
                end
            end

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Color")

            local ColorMixer = vgui.Create("DColorMixer", Panel_Sprite)
            ColorMixer:Dock(TOP)
            ColorMixer:SetSize(0, 69)
            ColorMixer:SetPalette(false)
            ColorMixer:SetAlphaBar(false)
            ColorMixer:SetWangs(true)
            ColorMixer:SetColor(e.Data.Sprite.Color)
            ColorMixer.ValueChanged = function(self, color)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Color = color
                end
            end

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Others")

            local NumSlider_Width = CreateNumSlider(Panel_Sprite, "Width", 0, 100)
            NumSlider_Width:SetValue(e.Data.Sprite.Width)
            NumSlider_Width.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Width = math.floor(value)
                end
            end

            local NumSlider_Height = CreateNumSlider(Panel_Sprite, "Height", 0, 100)
            NumSlider_Height:SetValue(e.Data.Sprite.Height)
            NumSlider_Height.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.Height = math.floor(value)
                end
            end

            local NumSlider_ActiveTime = CreateNumSlider(Panel_Sprite, "Active time", 0, 5, 2)
            NumSlider_ActiveTime:SetValue(e.Data.Sprite.ActiveTime)
            NumSlider_ActiveTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.ActiveTime = value
                end
            end

            local NumSlider_HiddenTime = CreateNumSlider(Panel_Sprite, "Hide time", 0, 5, 2)
            NumSlider_HiddenTime:SetValue(e.Data.Sprite.HiddenTime)
            NumSlider_HiddenTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.HiddenTime = value
                end
            end

            local NumSlider_OffsetTime = CreateNumSlider(Panel_Sprite, "Offset time", 0, 5, 2)
            NumSlider_OffsetTime:SetValue(e.Data.Sprite.OffsetTime)
            NumSlider_OffsetTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.Sprite.OffsetTime = value
                end
            end
        end

        if e.Data.SpriteLine then
            local Panel_SpriteLine = vgui.Create("DPanel", PropertySheet)
            Panel_SpriteLine:SetDrawBackground(false)
            PropertySheet:AddSheet("Sprite Line", Panel_SpriteLine, "icon16/chart_line.png")

            CreateCategory(Panel_SpriteLine, Color(255, 255, 255), "Position 1")

            local NumSlider_XPosition = CreateNumSlider(Panel_SpriteLine, "X Position", -200, 200, 1)
            NumSlider_XPosition:SetValue(e.Data.SpriteLine.Position1.x)
            NumSlider_XPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position1 = Vector(value, l.Data.SpriteLine.Position1.y, l.Data.SpriteLine.Position1.z)
                end
            end

            local NumSlider_YPosition = CreateNumSlider(Panel_SpriteLine, "Y Position", -200, 200, 1)
            NumSlider_YPosition:SetValue(e.Data.SpriteLine.Position1.y)
            NumSlider_YPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position1 = Vector(l.Data.SpriteLine.Position1.x, value, l.Data.SpriteLine.Position1.z)
                end
            end

            local NumSlider_ZPosition = CreateNumSlider(Panel_SpriteLine, "Z Position", -200, 200, 1)
            NumSlider_ZPosition:SetValue(e.Data.SpriteLine.Position1.z)
            NumSlider_ZPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position1 = Vector(l.Data.SpriteLine.Position1.x, l.Data.SpriteLine.Position1.y, value)
                end
            end

            CreateCategory(Panel_SpriteLine, Color(255, 255, 255), "Position 2")

            local NumSlider_XPosition = CreateNumSlider(Panel_SpriteLine, "X Position", -200, 200, 1)
            NumSlider_XPosition:SetValue(e.Data.SpriteLine.Position2.x)
            NumSlider_XPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position2 = Vector(value, l.Data.SpriteLine.Position2.y, l.Data.SpriteLine.Position2.z)
                end
            end

            local NumSlider_YPosition = CreateNumSlider(Panel_SpriteLine, "Y Position", -200, 200, 1)
            NumSlider_YPosition:SetValue(e.Data.SpriteLine.Position2.y)
            NumSlider_YPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position2 = Vector(l.Data.SpriteLine.Position2.x, value, l.Data.SpriteLine.Position2.z)
                end
            end

            local NumSlider_ZPosition = CreateNumSlider(Panel_SpriteLine, "Z Position", -200, 200, 1)
            NumSlider_ZPosition:SetValue(e.Data.SpriteLine.Position2.z)
            NumSlider_ZPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Position2 = Vector(l.Data.SpriteLine.Position2.x, l.Data.SpriteLine.Position2.y, value)
                end
            end

            CreateCategory(Panel_SpriteLine, Color(255, 255, 255), "Color")

            local ColorMixer = vgui.Create("DColorMixer", Panel_SpriteLine)
            ColorMixer:Dock(TOP)
            ColorMixer:SetSize(0, 69)
            ColorMixer:SetPalette(false)
            ColorMixer:SetAlphaBar(false)
            ColorMixer:SetWangs(true)
            ColorMixer:SetColor(e.Data.SpriteLine.Color)
            ColorMixer.ValueChanged = function(self, color)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Color = color
                end
            end

            CreateCategory(Panel_SpriteLine, Color(255, 255, 255), "Others")

            local NumSlider_Width = CreateNumSlider(Panel_SpriteLine, "Width", 0, 100)
            NumSlider_Width:SetValue(e.Data.SpriteLine.Width)
            NumSlider_Width.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Width = math.floor(value)
                end
            end

            local NumSlider_Height = CreateNumSlider(Panel_SpriteLine, "Height", 0, 100)
            NumSlider_Height:SetValue(e.Data.SpriteLine.Height)
            NumSlider_Height.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Height = math.floor(value)
                end
            end

            local NumSlider_Count = CreateNumSlider(Panel_SpriteLine, "Count", 1, 100)
            NumSlider_Count:SetValue(e.Data.SpriteLine.Count)
            NumSlider_Count.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteLine.Count = math.floor(value)
                end
            end
        end

        if e.Data.SpriteCircle then
            local Panel_Sprite = vgui.Create("DPanel", PropertySheet)
            Panel_Sprite:SetDrawBackground(false)
            PropertySheet:AddSheet("Sprite Circle", Panel_Sprite, "icon16/vector.png")

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Position")

            local NumSlider_XPosition = CreateNumSlider(Panel_Sprite, "X Position", -200, 200, 1)
            NumSlider_XPosition:SetValue(e.Data.SpriteCircle.Position.x)
            NumSlider_XPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Position = Vector(value, l.Data.SpriteCircle.Position.y, l.Data.SpriteCircle.Position.z)
                end
            end

            local NumSlider_YPosition = CreateNumSlider(Panel_Sprite, "Y Position", -200, 200, 1)
            NumSlider_YPosition:SetValue(e.Data.SpriteCircle.Position.y)
            NumSlider_YPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Position = Vector(l.Data.SpriteCircle.Position.x, value, l.Data.SpriteCircle.Position.z)
                end
            end

            local NumSlider_ZPosition = CreateNumSlider(Panel_Sprite, "Z Position", -200, 200, 1)
            NumSlider_ZPosition:SetValue(e.Data.SpriteCircle.Position.z)
            NumSlider_ZPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Position = Vector(l.Data.SpriteCircle.Position.x, l.Data.SpriteCircle.Position.y, value)
                end
            end

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Color")

            local ColorMixer = vgui.Create("DColorMixer", Panel_Sprite)
            ColorMixer:Dock(TOP)
            ColorMixer:SetSize(0, 69)
            ColorMixer:SetPalette(false)
            ColorMixer:SetAlphaBar(false)
            ColorMixer:SetWangs(true)
            ColorMixer:SetColor(e.Data.SpriteCircle.Color)
            ColorMixer.ValueChanged = function(self, color)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Color = color
                end
            end

            CreateCategory(Panel_Sprite, Color(255, 255, 255), "Others")

            local NumSlider_Width = CreateNumSlider(Panel_Sprite, "Width", 0, 100)
            NumSlider_Width:SetValue(e.Data.SpriteCircle.Width)
            NumSlider_Width.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Width = math.floor(value)
                end
            end

            local NumSlider_Height = CreateNumSlider(Panel_Sprite, "Height", 0, 100)
            NumSlider_Height:SetValue(e.Data.SpriteCircle.Height)
            NumSlider_Height.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Height = math.floor(value)
                end
            end

            local NumSlider_Radius = CreateNumSlider(Panel_Sprite, "Radius", 1, 100)
            NumSlider_Radius:SetValue(e.Data.SpriteCircle.Radius)
            NumSlider_Radius.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Radius = math.floor(value)
                end
            end

            local NumSlider_Speed = CreateNumSlider(Panel_Sprite, "Speed", 0, 0.3, 4)
            NumSlider_Speed:SetValue(e.Data.SpriteCircle.Speed)
            NumSlider_Speed.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.Speed = value
                end
            end

            local NumSlider_ActiveTime = CreateNumSlider(Panel_Sprite, "Active time", 0, 5, 2)
            NumSlider_ActiveTime:SetValue(e.Data.SpriteCircle.ActiveTime)
            NumSlider_ActiveTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.ActiveTime = value
                end
            end

            local NumSlider_HiddenTime = CreateNumSlider(Panel_Sprite, "Hide time", 0, 5, 2)
            NumSlider_HiddenTime:SetValue(e.Data.SpriteCircle.HiddenTime)
            NumSlider_HiddenTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.HiddenTime = value
                end
            end

            local NumSlider_OffsetTime = CreateNumSlider(Panel_Sprite, "Offset time", 0, 5, 2)
            NumSlider_OffsetTime:SetValue(e.Data.SpriteCircle.OffsetTime)
            NumSlider_OffsetTime.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.SpriteCircle.OffsetTime = value
                end
            end
        end

        if e.Data.ProjectedTexture then
            local Panel_PTexture = vgui.Create("DPanel", PropertySheet)
            Panel_PTexture:SetDrawBackground(false)
            PropertySheet:AddSheet("Projected light", Panel_PTexture, "icon16/weather_sun.png")

            CreateCategory(Panel_PTexture, Color(255, 255, 255), "Position")

            local NumSlider_XPosition = CreateNumSlider(Panel_PTexture, "X Position", -200, 200, 1)
            NumSlider_XPosition:SetValue(e.Data.ProjectedTexture.Position.x)
            NumSlider_XPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Position = Vector(value, l.Data.ProjectedTexture.Position.y, l.Data.ProjectedTexture.Position.z)
                end
            end

            local NumSlider_YPosition = CreateNumSlider(Panel_PTexture, "Y Position", -200, 200, 1)
            NumSlider_YPosition:SetValue(e.Data.ProjectedTexture.Position.y)
            NumSlider_YPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Position = Vector(l.Data.ProjectedTexture.Position.x, value, l.Data.ProjectedTexture.Position.z)
                end
            end

            local NumSlider_ZPosition = CreateNumSlider(Panel_PTexture, "Z Position", -200, 200, 1)
            NumSlider_ZPosition:SetValue(e.Data.ProjectedTexture.Position.z)
            NumSlider_ZPosition.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Position = Vector(l.Data.ProjectedTexture.Position.x, l.Data.ProjectedTexture.Position.y, value)
                end
            end

            CreateCategory(Panel_PTexture, Color(255, 255, 255), "Angle")

            local NumSlider_XAngle = CreateNumSlider(Panel_PTexture, "X Angle", -180, 180, 0)
            NumSlider_XAngle:SetValue(e.Data.ProjectedTexture.Angle.x)
            NumSlider_XAngle.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Angle = Angle(math.floor(value), l.Data.ProjectedTexture.Angle.y, l.Data.ProjectedTexture.Angle.z)
                end
            end

            local NumSlider_YAngle = CreateNumSlider(Panel_PTexture, "Y Angle", -180, 180, 0)
            NumSlider_YAngle:SetValue(e.Data.ProjectedTexture.Angle.y)
            NumSlider_YAngle.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Angle = Angle(l.Data.ProjectedTexture.Angle.x, math.floor(value), l.Data.ProjectedTexture.Angle.z)
                end
            end

            local NumSlider_ZAngle = CreateNumSlider(Panel_PTexture, "Z Angle", -180, 180, 0)
            NumSlider_ZAngle:SetValue(e.Data.ProjectedTexture.Angle.z)
            NumSlider_ZAngle.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Angle = Angle(l.Data.ProjectedTexture.Angle.x, l.Data.ProjectedTexture.Angle.y, math.floor(value))
                end
            end

            CreateCategory(Panel_PTexture, Color(255, 255, 255), "Color")

            local ColorMixer = vgui.Create("DColorMixer", Panel_PTexture)
            ColorMixer:Dock(TOP)
            ColorMixer:SetSize(0, 69)
            ColorMixer:SetPalette(false)
            ColorMixer:SetAlphaBar(false)
            ColorMixer:SetWangs(true)
            ColorMixer:SetColor(e.Data.ProjectedTexture.Color)
            ColorMixer.ValueChanged = function(self, color)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Color = color
                end
            end

            CreateCategory(Panel_PTexture, Color(255, 255, 255), "Others")

            local NumSlider_Size = CreateNumSlider(Panel_PTexture, "Size", 0, 2000)
            NumSlider_Size:SetValue(e.Data.ProjectedTexture.Size)
            NumSlider_Size.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.Size = math.floor(value)
                end
            end

            local NumSlider_FOV = CreateNumSlider(Panel_PTexture, "FOV", 0, 360)
            NumSlider_FOV:SetValue(e.Data.ProjectedTexture.FOV)
            NumSlider_FOV.OnValueChanged = function(self, value)
                for _, l in ipairs(LightList:GetSelected()) do
                    l.Data.ProjectedTexture.FOV = math.floor(value)
                end
            end
        end
    end

    return Panel
end

local function CreateSoundsPanel(veh, data)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    local function CreateComboBox(panel, choices)
        local ComboBox = vgui.Create("DComboBox", panel)
        ComboBox:Dock(TOP)
        ComboBox:DockMargin(10, 0, 10, 5)
        ComboBox:SetSize(0, 25)
        ComboBox:SetValue("")
        for _, c in ipairs(choices) do
            ComboBox:AddChoice(c)
        end

        return ComboBox
    end

    CreateCategory(Panel, Color(255, 255, 255), "Blinkers")

    local ComboBox_BlinkerSound = CreateComboBox(Panel, { "light", "normal" })
    ComboBox_BlinkerSound:SetValue(data.Sounds.Blinkers or "normal")
    ComboBox_BlinkerSound.OnSelect = function(self, _, value)
        data.Sounds.Blinkers = value
    end

    CreateCategory(Panel, Color(255, 255, 255), "Horn")

    local ComboBox_HornSound = CreateComboBox(Panel, { "light", "normal", "heavy" })
    ComboBox_HornSound:SetValue(data.Sounds.Horn or "normal")
    ComboBox_HornSound.OnSelect = function(self, _, value)
        data.Sounds.Horn = value
    end

    CreateCategory(Panel, Color(255, 255, 255), "Reversing")

    local ComboBox_ReversingSound = CreateComboBox(Panel, { "", "normal" })
    ComboBox_ReversingSound:SetValue(data.Sounds.ReversingSound or "")
    ComboBox_ReversingSound.OnSelect = function(self, _, value)
        data.Sounds.ReversingSound = value
    end

    CreateCategory(Panel, Color(255, 255, 255), "Siren")

    local ComboBox_ReversingSound = CreateComboBox(Panel, { "", "french_police", "french_firetruck", "french_ambulance" })
    ComboBox_ReversingSound:SetValue(data.Sounds.Siren or "")
    ComboBox_ReversingSound.OnSelect = function(self, _, value)
        data.Sounds.Siren = value
    end

    return Panel
end

local function CreateFuelPanel(veh, fuel)
    local Panel = vgui.Create("DPanel")
    Panel:SetDrawBackground(false)

    local function CreateNumSlider(panel, name, min, max)
        local NumSlider = vgui.Create("DNumSlider", panel)
        NumSlider:Dock(TOP)
        NumSlider:DockMargin(10, 0, 0, 0)
        NumSlider:SetSize(0, 25)
        NumSlider:SetText(name)
        NumSlider:SetMin(min)
        NumSlider:SetMax(max)
        NumSlider:SetDecimals(1)
        NumSlider:SetValue(0)

        return NumSlider
    end

    CreateCategory(Panel, Color(255, 255, 255), "Fuel")

    NumSlider_Capacity = CreateNumSlider(Panel, "Capacity (L)", 0, 110)
    NumSlider_Capacity:SetValue(fuel.Capacity or 60)

    NumSlider_Consumption = CreateNumSlider(Panel, "Consumption (L / 100 km)", 0, 30)
    NumSlider_Consumption:SetValue(fuel.Consumption or 5)

    return Panel
end

function SVMOD:Editor_Open(model)
    -- if not game.SinglePlayer() then
    --     notification.AddLegacy("You must be in singleplayer to use the editor.", NOTIFY_ERROR, 5)
    --     return
    -- end

    net.Start("SV_Editor_Open")
    net.WriteString(model)
    net.SendToServer()
end

net.Receive("SV_Editor_Open", function()
    local Vehicle = net.ReadEntity()
    
    if not Vehicle.SV_Data then
        SVMOD.Data[string.lower(Vehicle:GetModel())] = {
            Author = {},
            Seats = {},
            Parts = {},
            Sounds = {},
            Headlights = {},
            Back = {
                BrakeLights = {},
                ReversingLights = {}
            },
            Blinkers = {
                LeftLights = {},
                RightLights = {}
            },
            FlashingLights = {},
            Fuel = {}
        }

        SVMOD:LoadVehicle(Vehicle)
    end

    if not Vehicle.SV_Data.Parts then
        Vehicle.SV_Data.Parts = {}
    end
    if not Vehicle.SV_Data.Sounds then
        Vehicle.SV_Data.Sounds = {}
    end
    if not Vehicle.SV_Data.FlashingLights then
        Vehicle.SV_Data.FlashingLights = {}
    end

    local Width, Height = 500, 510

    local Frame = vgui.Create("DFrame")
    Frame:SetSize(Width, Height)
    Frame:SetPos(50, 50)
    Frame:SetDraggable(true)
    Frame:ShowCloseButton(false)
    Frame:SetTitle("SVMod Editor")

    Frame.Think = function()
        if input.IsKeyDown(KEY_F2) then
            Frame:MakePopup()
        elseif input.IsKeyDown(KEY_F3) then
            Frame:SetMouseInputEnabled(false)
            Frame:SetKeyBoardInputEnabled(false)
        end
    end

    Frame.OnRemove = function()
        net.Start("SV_Editor_Close")
        net.WriteEntity(Vehicle)
        net.SendToServer()
    end

    local PropertySheet = vgui.Create("DPropertySheet", Frame)
    PropertySheet:Dock(FILL)
    PropertySheet:AddSheet("Informations", CreateInformationsPanel(Vehicle, Frame, Vehicle.SV_Data.Author), "icon16/information.png")
    PropertySheet:AddSheet("Seats", CreateSeatPanel(Vehicle, Vehicle.SV_Data.Seats), "icon16/car.png")
    PropertySheet:AddSheet("Parts", CreatePartPanel(Vehicle, Vehicle.SV_Data.Parts), "icon16/connect.png")
    PropertySheet:AddSheet("Headlights", CreateLightsPanel(Vehicle, Vehicle.SV_Data.Headlights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Brake", CreateLightsPanel(Vehicle, Vehicle.SV_Data.Back.BrakeLights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Reversing", CreateLightsPanel(Vehicle, Vehicle.SV_Data.Back.ReversingLights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Left Blinker", CreateLightsPanel(Vehicle, Vehicle.SV_Data.Blinkers.LeftLights, Vehicle.SV_Data.Blinkers.RightLights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Right Blinker", CreateLightsPanel(Vehicle, Vehicle.SV_Data.Blinkers.RightLights, Vehicle.SV_Data.Blinkers.LeftLights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Flashing Lights", CreateLightsPanel(Vehicle, Vehicle.SV_Data.FlashingLights), "icon16/lightbulb.png")
    PropertySheet:AddSheet("Sounds", CreateSoundsPanel(Vehicle, Vehicle.SV_Data), "icon16/sound.png")
    PropertySheet:AddSheet("Fuel", CreateFuelPanel(Vehicle, Vehicle.SV_Data.Fuel), "icon16/database.png")

    PropertySheet.OnActiveTabChanged = function(self, old, new)
        net.Start("SV_Editor_ActiveTab")
        net.WriteEntity(Vehicle)
        net.WriteString(old:GetText())
        net.WriteString(new:GetText())
        net.SendToServer()

        timer.Simple(1, function()
            if IsValid(new) and new:GetText() == "Reversing" then
                timer.Remove("SV_DetectReversing_" .. Vehicle:EntIndex())
                Vehicle.SV_IsReversing = true
            end
        end)

        if new:GetText() == "Parts" then
            SVMOD.VehicleRenderedParts = Vehicle
        elseif old:GetText() == "Parts" then
            SVMOD.VehicleRenderedParts = nil
        end
    end
end)