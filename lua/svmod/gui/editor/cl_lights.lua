local lightType = {
    PROJECTEDTEXTURE = 1,
    SPRITE = 2,
    SPRITELINE = 3,
    SPRITECIRCLE = 4
}

local function createNumSlidePanel(panel, name, defaultValue, minValue, maxValue)
    local numSlider = SVMOD:CreateNumSlidePanel(panel, name, function() end)
    numSlider:SetSize(400, 30)
    numSlider:SetValue(defaultValue)
    numSlider:SetMinValue(minValue)
    numSlider:SetMaxValue(maxValue)
    numSlider:SetUnit(" ")
    numSlider:SetRealTime(true)

    return numSlider
end

local function projectedTexturePanel(panel, data)
    local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS")
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.Position = trace.Entity:WorldToLocal(trace.HitPos)
        end
    end)
    button:Dock(RIGHT)

    local xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.Position.x = val
    end)

    local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.Position.y = val
    end)

    local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.Position.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "ANGLES")
    title:DockMargin(0, 30, 0, 0)

    local xAngleNumSlider = createNumSlidePanel(panel, "Y Angle", data.Angle.x, -180, 180)
    xAngleNumSlider:SetFunction(function(val)
        data.Angle.x = val
    end)

    local yAngleNumSlider = createNumSlidePanel(panel, "P Angle", data.Angle.y, -180, 180)
    yAngleNumSlider:SetFunction(function(val)
        data.Angle.y = val
    end)

    local zAngleNumSlider = createNumSlidePanel(panel, "R Angle", data.Angle.z, -180, 180)
    zAngleNumSlider:SetFunction(function(val)
        data.Angle.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "OTHERS")
    title:DockMargin(0, 30, 0, 0)

    local colorMixer = vgui.Create("DColorMixer", panel)
    colorMixer:Dock(TOP)
    colorMixer:DockMargin(0, 0, 0, 10)
    colorMixer:SetSize(0, 69)
    colorMixer:SetPalette(false)
    colorMixer:SetAlphaBar(false)
    colorMixer:SetWangs(true)
    colorMixer:SetColor(data.Color)
    colorMixer.ValueChanged = function(self, color)
        -- for _, l in ipairs(LightList:GetSelected()) do
            data.Color = color
        -- end
    end

    local sizeNumSlider = createNumSlidePanel(panel, "Size", data.Size, 0, 2000)
    sizeNumSlider:SetFunction(function(val)
        data.Size = val
    end)

    local fovNumSlider = createNumSlidePanel(panel, "FOV", data.FOV, 0, 360)
    fovNumSlider:SetFunction(function(val)
        data.FOV = val
    end)
end

local function spritePanel(panel, data)
    local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS")
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.Position = trace.Entity:WorldToLocal(trace.HitPos)
        end
    end)
    button:Dock(RIGHT)

    local xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.Position.x = val
    end)

    local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.Position.y = val
    end)

    local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.Position.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "OTHERS")
    title:DockMargin(0, 30, 0, 0)

    local colorMixer = vgui.Create("DColorMixer", panel)
    colorMixer:Dock(TOP)
    colorMixer:DockMargin(0, 0, 0, 10)
    colorMixer:SetSize(0, 69)
    colorMixer:SetPalette(false)
    colorMixer:SetAlphaBar(false)
    colorMixer:SetWangs(true)
    colorMixer:SetColor(data.Color)
    colorMixer.ValueChanged = function(self, color)
        -- for _, l in ipairs(LightList:GetSelected()) do
            data.Color = color
        -- end
    end

    local widthNumSlider = createNumSlidePanel(panel, "Width", data.Width or 20, 0, 100)
    widthNumSlider:SetFunction(function(val)
        data.Width = val
    end)

    local heightNumSlider = createNumSlidePanel(panel, "Height", data.Height or 20, 0, 100)
    heightNumSlider:SetFunction(function(val)
        data.Height = val
    end)

    local title = SVMOD:CreateTitle(panel, "ANIMATIONS")
    title:DockMargin(0, 30, 0, 0)

    local activeTimeNumSlider = createNumSlidePanel(panel, "Active time", data.ActiveTime or 0, 0, 5)
    activeTimeNumSlider:SetFunction(function(val)
        data.ActiveTime = val
    end)

    local hiddenTimeNumSlider = createNumSlidePanel(panel, "Hidden time", data.HiddenTime or 0, 0, 5)
    hiddenTimeNumSlider:SetFunction(function(val)
        data.HiddenTime = val
    end)

    local offsetTimeNumSlider = createNumSlidePanel(panel, "Offset time", data.OffsetTime or 0, 0, 5)
    offsetTimeNumSlider:SetFunction(function(val)
        data.OffsetTime = val
    end)
end

local function spriteLinePanel(panel, data)
    local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS 1")
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.Position1 = trace.Entity:WorldToLocal(trace.HitPos)
        end
    end)
    button:Dock(RIGHT)

    local xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position1.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.Position1.x = val
    end)

    local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position1.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.Position1.y = val
    end)

    local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position1.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.Position1.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS 2")
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.Position2 = trace.Entity:WorldToLocal(trace.HitPos)
        end
    end)
    button:Dock(RIGHT)

    local xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position2.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.Position2.x = val
    end)

    local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position2.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.Position2.y = val
    end)

    local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position2.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.Position2.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "OTHERS")
    title:DockMargin(0, 30, 0, 0)

    local colorMixer = vgui.Create("DColorMixer", panel)
    colorMixer:Dock(TOP)
    colorMixer:DockMargin(0, 0, 0, 10)
    colorMixer:SetSize(0, 69)
    colorMixer:SetPalette(false)
    colorMixer:SetAlphaBar(false)
    colorMixer:SetWangs(true)
    colorMixer:SetColor(data.Color)
    colorMixer.ValueChanged = function(self, color)
        data.Color = color
    end

    local widthNumSlider = createNumSlidePanel(panel, "Width", data.Width or 20, 0, 100)
    widthNumSlider:SetFunction(function(val)
        data.Width = val
    end)

    local heightNumSlider = createNumSlidePanel(panel, "Height", data.Height or 20, 0, 100)
    heightNumSlider:SetFunction(function(val)
        data.Height = val
    end)

    local countNumSlider = createNumSlidePanel(panel, "Count", data.Count, 1, 100)
    countNumSlider:SetFunction(function(val)
        data.Count = val
    end)
end

local function spriteCirclePanel(panel, data)
    local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS")
    local button = SVMOD:CreateButton(title, "EyePos", function()
        local trace = LocalPlayer():GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
            data.Position = trace.Entity:WorldToLocal(trace.HitPos)
        end
    end)
    button:Dock(RIGHT)

    local xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position.x, -200, 200)
    xPositionNumSlider:SetFunction(function(val)
        data.Position.x = val
    end)

    local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position.y, -200, 200)
    yPositionNumSlider:SetFunction(function(val)
        data.Position.y = val
    end)

    local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position.z, -200, 200)
    zPositionNumSlider:SetFunction(function(val)
        data.Position.z = val
    end)

    local title = SVMOD:CreateTitle(panel, "OTHERS")
    title:DockMargin(0, 30, 0, 0)

    local colorMixer = vgui.Create("DColorMixer", panel)
    colorMixer:Dock(TOP)
    colorMixer:DockMargin(0, 0, 0, 10)
    colorMixer:SetSize(0, 69)
    colorMixer:SetPalette(false)
    colorMixer:SetAlphaBar(false)
    colorMixer:SetWangs(true)
    colorMixer:SetColor(data.Color)
    colorMixer.ValueChanged = function(self, color)
        -- for _, l in ipairs(LightList:GetSelected()) do
            data.Color = color
        -- end
    end

    local widthNumSlider = createNumSlidePanel(panel, "Width", data.Width or 20, 0, 100)
    widthNumSlider:SetFunction(function(val)
        data.Width = val
    end)

    local heightNumSlider = createNumSlidePanel(panel, "Height", data.Height or 20, 0, 100)
    heightNumSlider:SetFunction(function(val)
        data.Height = val
    end)

    local radiusNumSlider = createNumSlidePanel(panel, "Radius", data.Radius, 1, 100)
    radiusNumSlider:SetFunction(function(val)
        data.Radius = val
    end)

    local speedNumSlider = createNumSlidePanel(panel, "Speed", data.Speed, 0, 4)
    speedNumSlider:SetFunction(function(val)
        data.Speed = val
    end)

    local title = SVMOD:CreateTitle(panel, "ANIMATIONS")
    title:DockMargin(0, 30, 0, 0)

    local activeTimeNumSlider = createNumSlidePanel(panel, "Active time", data.ActiveTime or 0, 0, 5)
    activeTimeNumSlider:SetFunction(function(val)
        data.ActiveTime = val
    end)

    local hiddenTimeNumSlider = createNumSlidePanel(panel, "Hidden time", data.HiddenTime or 0, 0, 5)
    hiddenTimeNumSlider:SetFunction(function(val)
        data.HiddenTime = val
    end)

    local offsetTimeNumSlider = createNumSlidePanel(panel, "Offset time", data.OffsetTime or 0, 0, 5)
    offsetTimeNumSlider:SetFunction(function(val)
        data.OffsetTime = val
    end)
end

function SVMOD:EDITOR_Lights(panel, data)
	panel:Clear()

    local listView = SVMOD:CreateListView(panel)
    listView:SetWidth(100, 0)
    listView:SetHideHeaders(true)
    listView:Dock(LEFT)
    listView:DockMargin(0, 0, 20, 0)
    listView:AddColumn("ID")
	listView:SetMultiSelect(false)

    local bottomPanel = vgui.Create("DPanel", panel)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetSize(0, 30)
    bottomPanel:SetDrawBackground(false)

    local centerPanel = vgui.Create("DPanel", panel)
    centerPanel:Dock(FILL)
    centerPanel:SetDrawBackground(false)

    -- -------------------
    --  HOOKS
    -- -------------------

    -- -------------------
    --  FUNCTIONS
    -- -------------------

    local function addLight(data)
		local max = 0
		for _, line in pairs(listView:GetLines()) do
			local index = tonumber(line:GetColumnText(1))
			if index > max then
				max = index
			end
		end

        local index

		local line = listView:AddLine(max + 1)
        line.Data = data

        return line
	end

	local function removeLight(index)
		local line = listView:GetLine(index)
		columnText = tonumber(line:GetColumnText(1))

		table.RemoveByValue(data, line.Data)

		for _, v in pairs(listView:GetLines()) do
			local index = tonumber(v:GetColumnText(1))
			if index > columnText then
				v:SetColumnText(1, index - 1)
			end
		end

		listView:RemoveLine(index)
	end

	local function upLight(index)
		local line = listView:GetLine(index)
		lineIndex = tonumber(line:GetColumnText(1))

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = tonumber(v:GetColumnText(1))
			if tempIndex == lineIndex - 1 then
				line.Data, v.Data = v.Data, line.Data
				break
			end
		end
	end

	local function downLight(index)
		local line = listView:GetLine(index)
		lineIndex = tonumber(line:GetColumnText(1))

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = tonumber(v:GetColumnText(1))
			if tempIndex == lineIndex + 1 then
				line.Data, v.Data = v.Data, line.Data
				break
			end
		end
	end

	-- -------------------
    --  PANELS
    -- -------------------

    listView.OnRowRightClick = function(_, lineID, line)
		local menu = DermaMenu()

		menu:AddOption("Up", function()
			upLight(lineID)
		end):SetIcon("icon16/arrow_up.png")

		menu:AddOption("Down", function()
			downLight(lineID)
		end):SetIcon("icon16/arrow_down.png")

		local copyChild, copyParent = menu:AddSubMenu("Copy")
		copyParent:SetIcon("icon16/page_copy.png")

		for i, l in ipairs(listView:GetLines()) do
            copyChild:AddOption("From light #" .. l:GetColumnText(1), function()
                for i, v in ipairs(data) do
                    if v == line.Data then
                        data[i] = SVMOD:DeepCopy(l.Data)
                        line.Data = data[i]
                        listView:SelectItem(line)
                        break
                    end
                end
            end):SetIcon("icon16/lightbulb_off.png")
		end

		menu:AddOption("Symmetric", function()
            if line.Data.ProjectedTexture then
                local index = table.insert(data, {
                    ProjectedTexture = SVMOD:DeepCopy(line.Data.ProjectedTexture)
                })
                local tab = addLight(data[index])
                tab.Data.ProjectedTexture.Position.x = -line.Data.ProjectedTexture.Position.x
            end
    
            if line.Data.Sprite then
                local index = table.insert(data, {
                    Sprite = SVMOD:DeepCopy(line.Data.Sprite)
                })
                local tab = addLight(data[index])
                tab.Data.Sprite.Position.x = -line.Data.Sprite.Position.x
            end
    
            if line.Data.SpriteLine then
                local index = table.insert(data, {
                    SpriteLine = SVMOD:DeepCopy(line.Data.SpriteLine)
                })
                local tab = addLight(data[index])
                tab.Data.SpriteLine.Position1.x = -line.Data.SpriteLine.Position1.x
                tab.Data.SpriteLine.Position2.x = -line.Data.SpriteLine.Position2.x
            end
    
            if line.Data.SpriteCircle then
                local index = table.insert(data, {
                    SpriteCircle = SVMOD:DeepCopy(line.Data.SpriteCircle)
                })
                local tab = addLight(data[index])
                tab.Data.SpriteCircle.Position.x = -line.Data.SpriteCircle.Position.x
            end
		end):SetIcon("icon16/arrow_refresh.png")

        if line.Data.Sprite then
            menu:AddOption("Create Projected texture from Sprite", function()
                local pos = line.Data.Sprite.Position
                local index = table.insert(data, {
                    ProjectedTexture = {
                        Position = Vector(pos.x, pos.y, pos.z),
                        Angle = Angle(0, 90, 0),
                        Color = Color(255, 255, 255),
                        Size = 1000,
                        FOV = 110
                    }
                })
                addLight(data[index])
            end):SetIcon("icon16/lightbulb_add.png")
        end

		menu:AddOption("Delete", function()
            removeLight(lineID)
        end):SetIcon("icon16/cross.png")

		menu:Open()
	end

    local addButton = SVMOD:CreateButton(bottomPanel, "ADD", function()
        local menu = DermaMenu()

        menu:AddOption("Projected texture", function()
            local index = table.insert(data, {
                ProjectedTexture = {
                    Position = Vector(0, 0, 0),
                    Angle = Angle(0, 90, 0),
                    Color = Color(255, 255, 255),
                    Size = 1000,
                    FOV = 110
                }
            })
            addLight(data[index])
        end):SetIcon("icon16/lightbulb.png")
            
        menu:AddOption("Sprite", function()
            local index = table.insert(data, {
                Sprite = {
                    Position = Vector(0, 0, 0),
                    Color = Color(255, 255, 255),
                    Width = 25,
                    Height = 25,
                    ActiveTime = 0,
                    HiddenTime = 0,
                    OffsetTime = 0
                }
            })
            addLight(data[index])
        end):SetIcon("icon16/lightbulb.png")

        menu:AddOption("Sprite line", function()
            local index = table.insert(data, {
                SpriteLine = {
                    Position1 = Vector(0, 0, 0),
                    Position2 = Vector(0, 0, 0),
                    Color = Color(255, 255, 255),
                    Count = 10,
                    Width = 10,
                    Height = 10
                }
            })
            addLight(data[index])
        end):SetIcon("icon16/lightbulb.png")

        menu:AddOption("Sprite circle", function()
            local index = table.insert(data, {
                SpriteCircle = {
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
            })
            addLight(data[index])
        end):SetIcon("icon16/lightbulb.png")

        menu:Open()
    end)
    addButton:Dock(RIGHT)

    for _, light in ipairs(data) do
        if light.ProjectedTexture then
            local tab = addLight({
                ProjectedTexture = light.ProjectedTexture
            })
        end

        if light.Sprite then
            local tab = addLight({
                Sprite = light.Sprite
            })
        end

        if light.SpriteLine then
            local tab = addLight({
                SpriteLine = light.SpriteLine
            })
        end

        if light.SpriteCircle then
            local tab = addLight({
                SpriteCircle = light.SpriteCircle
            })
        end
	end

	listView.OnRowSelected = function(_, _, e)
        centerPanel:Clear()

        if e.Data.ProjectedTexture then
            projectedTexturePanel(centerPanel, e.Data.ProjectedTexture)
        elseif e.Data.Sprite then
            spritePanel(centerPanel, e.Data.Sprite)
        elseif e.Data.SpriteLine then
            spriteLinePanel(centerPanel, e.Data.SpriteLine)
        elseif e.Data.SpriteCircle then
            spriteCirclePanel(centerPanel, e.Data.SpriteCircle)
        end
	end
end