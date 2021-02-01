local Values

local Controls = {
    ["CATEGORY"] = function(panel, name, color, description)
        local Label_Category = vgui.Create("DLabel", panel)
        Label_Category:Dock(TOP)
        Label_Category:DockMargin(5, 5, 0, 5)
        Label_Category:SetFont("DermaDefaultBold")
        Label_Category:SetTextColor(color)
        Label_Category:SetText(name)
        Label_Category:SizeToContents()

        local Panel_Separator = vgui.Create("DPanel", panel)
        Panel_Separator:Dock(TOP)
        Panel_Separator:DockMargin(0, 0, 0, 10)
        Panel_Separator.Paint = function(self, width, height)
            surface.SetDrawColor(color.r, color.g, color.b, 255)
            surface.DrawRect(0, 0, width, height)
        end
        Panel_Separator:SetSize(0, 1)

        if description then
            local Label_Description = vgui.Create("DLabel", panel)
            Label_Description:Dock(TOP)
            Label_Description:DockMargin(5, 0, 0, 10)
            Label_Description:SetText(description)
            Label_Description:SizeToContents()
        end
    end,
    ["STATUS"] = function(panel, icon, text)
        local Panel = vgui.Create("DPanel", panel)
        Panel:Dock(TOP)
        Panel:DockMargin(4, 0, 0, 0)
        Panel:SetSize(0, 22)
        Panel:SetDrawBackground(false)

        local Mat = vgui.Create("Material", Panel)
        Mat:Dock(LEFT)
        Mat:SetSize(16, 16)
        Mat:SetMaterial("icon16/" .. icon .. ".png")

        local Label_Enabled = vgui.Create("DLabel", Panel)
        Label_Enabled:Dock(FILL)
        Label_Enabled:DockMargin(8, 0, 0, 6)
        Label_Enabled:SetText(text)
        Label_Enabled:SizeToContents()

        return Panel, Mat, Label_Enabled
    end,
    ["CHECKBOX"] = function(panel, name, defaultValue, onChangeFun)
        local CheckBoxLabel = vgui.Create("DCheckBoxLabel", panel)
        CheckBoxLabel:Dock(TOP)
        CheckBoxLabel:DockMargin(5, 0, 0, 5)
        CheckBoxLabel:SetText(name)
        CheckBoxLabel:SetChecked(defaultValue)
        if onChangeFun then
            CheckBoxLabel.OnChange = onChangeFun
        end

        return CheckBoxLabel
    end,
    ["NUMSLIDER"] = function(panel, name, min, max, decimal, defaultValue, onChangeFun)
        local NumSlider = vgui.Create("DNumSlider", panel)
        NumSlider:Dock(TOP)
        NumSlider:DockMargin(5, -5, 0, 5)
        NumSlider:SetText(name)
        NumSlider:SetMin(min)
        NumSlider:SetMax(max)
        NumSlider:SetDecimals(decimal)
        NumSlider:SetValue(defaultValue)
        if onChangeFun then
            NumSlider.OnValueChanged = onChangeFun
        end

        return NumSlider
    end,
    ["COMBOBOX"] = function(panel, defaultValue, values, onChangeFun)
        local ComboBox = vgui.Create("DComboBox", panel)
        ComboBox:Dock(TOP)
        ComboBox:DockMargin(5, 0, 5, 5)
        ComboBox:SetValue(defaultValue)
        for _, v in ipairs(values) do
            ComboBox:AddChoice(v.Value, v.Data)
        end
        if onChangeFun then
            ComboBox.OnSelect = onChangeFun
        end

        return ComboBox
    end,
    ["SAVE"] = function(panel, saveFun, resetFun)
        local Panel_Bottom = vgui.Create("DPanel", panel)
        Panel_Bottom:Dock(BOTTOM)
        Panel_Bottom:SetSize(0, 25)
        Panel_Bottom:SetDrawBackground(false)

        local Button_Save = vgui.Create("DButton", Panel_Bottom)
        Button_Save:SetSize(100, 25)
        Button_Save:SetPos(170, 0)
        Button_Save:SetText("Save")
        Button_Save:SetTextColor(Color(12, 135, 0))
        Button_Save.DoClick = saveFun

        local Button_Reset = vgui.Create("DButton", Panel_Bottom)
        Button_Reset:SetSize(100, 25)
        Button_Reset:SetPos(280, 0)
        Button_Reset:SetText("Reset")
        Button_Reset:SetTextColor(Color(255, 0, 0))
        Button_Reset.DoClick = resetFun
    end
}

local function CreateSavePanel(panel, saveFun, resetFun)
    local Panel_Bottom = vgui.Create("DPanel", panel)
    Panel_Bottom:Dock(BOTTOM)
    Panel_Bottom:SetSize(0, 25)
    Panel_Bottom:SetDrawBackground(false)

    local Button_Save, Button_Reset

    if saveFun then
        Button_Save = vgui.Create("DButton", Panel_Bottom)
        Button_Save:SetSize(100, 25)
        Button_Save:SetPos(300, 0)
        Button_Save:SetText(SVMOD:GetLanguage("Save"))
        Button_Save:SetTextColor(Color(12, 135, 0))
        Button_Save.DoClick = saveFun
    end

    if resetFun then
        Button_Reset = vgui.Create("DButton", Panel_Bottom)
        Button_Reset:SetSize(100, 25)
        Button_Reset:SetPos(300, 0)
        Button_Reset:SetText(SVMOD:GetLanguage("Reset"))
        Button_Reset:SetTextColor(Color(255, 0, 0))
        Button_Reset.DoClick = resetFun
    end

    if saveFun and resetFun then
        Button_Save:SetPos(200, 0)
        Button_Reset:SetPos(310, 0)
    end
end

--[[---------------------------------------------------------
   Name: SVMOD:OpenReportMenu(string model, number timestamp)
   Type: Client
   Desc: Sets the horn state of the vehicle driven by the
         player.
-----------------------------------------------------------]]
function SVMOD:OpenReportMenu(model, timestamp)
    local Frame = vgui.Create("DFrame")
    Frame:SetSize(300, 224)
    Frame:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 112)
    Frame:SetTitle(SVMOD:GetLanguage("Report menu"))
    Frame:MakePopup()

    local TextEntry_Model = vgui.Create("DTextEntry", Frame)
    TextEntry_Model:Dock(TOP)
    TextEntry_Model:DockMargin(2, 0, 2, 2)
    TextEntry_Model:SetSize(0, 25)
    TextEntry_Model:SetEditable(false)
    TextEntry_Model:SetText(model)

    local TextEntry_Timestamp = vgui.Create("DTextEntry", Frame)
    TextEntry_Timestamp:Dock(TOP)
    TextEntry_Timestamp:DockMargin(2, 0, 2, 2)
    TextEntry_Timestamp:SetSize(0, 25)
    TextEntry_Timestamp:SetEditable(false)
    TextEntry_Timestamp:SetText(os.date("%d/%m/%Y - %H:%M", timestamp))

    local TextEntry_Message = vgui.Create("DTextEntry", Frame)
    TextEntry_Message:Dock(TOP)
    TextEntry_Message:DockMargin(2, 0, 2, 2)
    TextEntry_Message:SetSize(0, 100)
    TextEntry_Message:SetMultiline(true)
    TextEntry_Message:SetPlaceholderText(SVMOD:GetLanguage("Enter your message to understand the report."))

    local Button = vgui.Create("DButton", Frame)
    Button:Dock(BOTTOM)
    Button:DockMargin(2, 0, 2, 2)
    Button:SetSize(0, 30)
    Button:SetText(SVMOD:GetLanguage("Send"))
end

function SVMOD:GUI_Open()
    net.Start("SV_Menu_Open")
    net.SendToServer()
end

local function CreatePanel(frame, saveButton, resetButton, categories)
    local Panel = vgui.Create("DPanel", PropertySheet)
    Panel:SetDrawBackground(false)

    local ControlsCreated = {}

    for _, category in ipairs(categories) do
        if category.Name then
            Controls["CATEGORY"](Panel, SVMOD:GetLanguage(category.Name), category.Color, SVMOD:GetLanguage(category.Description))
        end

        if isfunction(category.Controls) then
            category.Controls(Panel, CreateSavePanel)
        else
            for _, control in ipairs(category.Controls) do
                local Table = control.Read()

                local Control

                if control.Type == "STATUS" then
                    Control = Controls["STATUS"](Panel, Table.Icon, Table.Text)
                elseif control.Type == "CHECKBOX" then
                    Control = Controls["CHECKBOX"](Panel, SVMOD:GetLanguage(Table.Name), Table.DefaultValue, Table.OnChangeFun)
                elseif control.Type == "NUMSLIDER" then
                    Control = Controls["NUMSLIDER"](Panel, SVMOD:GetLanguage(Table.Name), Table.Min, Table.Max, Table.Decimal, Table.DefaultValue, Table.OnChangeFun)
                elseif control.Type == "COMBOBOX" then
                    Control = Controls["COMBOBOX"](Panel, Table.DefaultValue, Table.Values, Table.OnChangeFun)
                end

                ControlsCreated[Control] = control
            end
        end
    end

    local function SaveFun()
        for k, v in pairs(ControlsCreated) do
            if v.Category then
                net.Start("SV_Editor_Set")
                net.WriteString(v.Category)
                net.WriteString(v.Name)

                if k:GetName() == "DCheckBoxLabel" then
                    net.WriteUInt(0, 2)
                    net.WriteBool(k:GetChecked())
                elseif k:GetName() == "DNumSlider" then
                    net.WriteUInt(1, 2)
                    net.WriteFloat(k:GetValue())
                end
                
                net.SendToServer()
            end
        end

        notification.AddLegacy("Saved.", NOTIFY_GENERIC, 3)
    end

    local function ResetFun()
        for k, v in pairs(ControlsCreated) do
            if k:GetValue() ~= v.ResetValue then
                k:SetValue(v.ResetValue)
            end
        end

        SaveFun()
    end

    if saveButton and resetButton then
        CreateSavePanel(Panel, SaveFun, ResetFun)
    elseif saveButton then
        CreateSavePanel(Panel, SaveFun, nil)
    elseif resetButton then
        CreateSavePanel(Panel, nil, ResetFun)
    end

    return Panel
end

net.Receive("SV_Menu_Open", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(650, 570)
    frame:Center()
    frame:SetTitle("Simple Vehicle: SVMod Menu")
    frame:MakePopup()

    local PropertySheet = vgui.Create("DPropertySheet", frame)
    PropertySheet:Dock(FILL)

    for _, m in ipairs(SVMOD.Menu) do
        if not m.SuperAdminOnly or LocalPlayer():IsSuperAdmin() then
            PropertySheet:AddSheet(SVMOD:GetLanguage(m.Name), CreatePanel(frame, m.SaveButton, m.ResetButton, m.Categories), "icon16/" .. m.Icon .. ".png")
        end
    end
end)

concommand.Add("sv_menu", function()
    SVMOD:GUI_Open()
end)

concommand.Add("svmenu", function()
    SVMOD:GUI_Open()
end)

concommand.Add("svmod", function()
    SVMOD:GUI_Open()
end)