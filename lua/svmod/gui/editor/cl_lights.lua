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

	local xAngleNumSlider = createNumSlidePanel(panel, "Y Angle", data.Angles.x, -180, 180)
	xAngleNumSlider:SetFunction(function(val)
		data.Angles.x = val
	end)

	local yAngleNumSlider = createNumSlidePanel(panel, "P Angle", data.Angles.y, -180, 180)
	yAngleNumSlider:SetFunction(function(val)
		data.Angles.y = val
	end)

	local zAngleNumSlider = createNumSlidePanel(panel, "R Angle", data.Angles.z, -180, 180)
	zAngleNumSlider:SetFunction(function(val)
		data.Angles.z = val
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

local function spritePanel(panel, data, hasAnim)
	local xPositionNumSlider, yPositionNumSlider, zPositionNumSlider

	local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS")
	local button = SVMOD:CreateButton(title, "EyePos", function()
		local trace = LocalPlayer():GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
			data.Position = trace.Entity:WorldToLocal(trace.HitPos)

			xPositionNumSlider:SetValue(data.Position.x)
			yPositionNumSlider:SetValue(data.Position.y)
			zPositionNumSlider:SetValue(data.Position.z)
		end
	end)
	button:Dock(RIGHT)

	xPositionNumSlider = createNumSlidePanel(panel, "X Position", data.Position.x, -200, 200)
	xPositionNumSlider:SetFunction(function(val)
		data.Position.x = val
	end)

	yPositionNumSlider = createNumSlidePanel(panel, "Y Position", data.Position.y, -200, 200)
	yPositionNumSlider:SetFunction(function(val)
		data.Position.y = val
	end)

	zPositionNumSlider = createNumSlidePanel(panel, "Z Position", data.Position.z, -200, 200)
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

	if hasAnim then
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
end

local function spriteLinePanel(panel, data)
	local xPositionNumSlider1, yPositionNumSlider1, zPositionNumSlider1
	local xPositionNumSlider2, yPositionNumSlider2, zPositionNumSlider2
	local xPositionNumSlider3, yPositionNumSlider3, zPositionNumSlider3

	local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS 1")
	local button = SVMOD:CreateButton(title, "EyePos", function()
		local trace = LocalPlayer():GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
			data.Position1 = trace.Entity:WorldToLocal(trace.HitPos)

			xPositionNumSlider1:SetValue(data.Position1.x)
			yPositionNumSlider1:SetValue(data.Position1.y)
			zPositionNumSlider1:SetValue(data.Position1.z)
		end
	end)
	button:Dock(RIGHT)

	xPositionNumSlider1 = createNumSlidePanel(panel, "X Position", data.Position1.x, -200, 200)
	xPositionNumSlider1:SetFunction(function(val)
		data.Position1.x = val
	end)

	yPositionNumSlider1 = createNumSlidePanel(panel, "Y Position", data.Position1.y, -200, 200)
	yPositionNumSlider1:SetFunction(function(val)
		data.Position1.y = val
	end)

	zPositionNumSlider1 = createNumSlidePanel(panel, "Z Position", data.Position1.z, -200, 200)
	zPositionNumSlider1:SetFunction(function(val)
		data.Position1.z = val
	end)

	local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS 2")
	title:DockMargin(0, 30, 0, 0)
	SVMOD:CreateButton(title, "EyePos", function()
		local trace = LocalPlayer():GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
			data.Position2 = trace.Entity:WorldToLocal(trace.HitPos)

			xPositionNumSlider2:SetValue(data.Position2.x)
			yPositionNumSlider2:SetValue(data.Position2.y)
			zPositionNumSlider2:SetValue(data.Position2.z)
		end
	end):Dock(RIGHT)
	SVMOD:CreateButton(title, "Align", function()
		local trace = LocalPlayer():GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
			local vect = data.Position3 - data.Position1
			data.Position2.x = data.Position1.x + (vect.x / 2)
			data.Position2.y = data.Position1.y + (vect.y / 2)
			data.Position2.z = data.Position1.z + (vect.z / 2)

			xPositionNumSlider2:SetValue(data.Position2.x)
			yPositionNumSlider2:SetValue(data.Position2.y)
			zPositionNumSlider2:SetValue(data.Position2.z)
		end
	end):Dock(RIGHT)

	xPositionNumSlider2 = createNumSlidePanel(panel, "X Position", data.Position2.x, -200, 200)
	xPositionNumSlider2:SetFunction(function(val)
		data.Position2.x = val
	end)

	yPositionNumSlider2 = createNumSlidePanel(panel, "Y Position", data.Position2.y, -200, 200)
	yPositionNumSlider2:SetFunction(function(val)
		data.Position2.y = val
	end)

	zPositionNumSlider2 = createNumSlidePanel(panel, "Z Position", data.Position2.z, -200, 200)
	zPositionNumSlider2:SetFunction(function(val)
		data.Position2.z = val
	end)

	local title = SVMOD:CreateTitle(panel, "LOCAL POSITIONS 3")
	title:DockMargin(0, 30, 0, 0)
	local button = SVMOD:CreateButton(title, "EyePos", function()
		local trace = LocalPlayer():GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
			data.Position3 = trace.Entity:WorldToLocal(trace.HitPos)

			xPositionNumSlider3:SetValue(data.Position3.x)
			yPositionNumSlider3:SetValue(data.Position3.y)
			zPositionNumSlider3:SetValue(data.Position3.z)
		end
	end)
	button:Dock(RIGHT)

	xPositionNumSlider3 = createNumSlidePanel(panel, "X Position", data.Position3.x, -200, 200)
	xPositionNumSlider3:SetFunction(function(val)
		data.Position3.x = val
	end)

	yPositionNumSlider3 = createNumSlidePanel(panel, "Y Position", data.Position3.y, -200, 200)
	yPositionNumSlider3:SetFunction(function(val)
		data.Position3.y = val
	end)

	zPositionNumSlider3 = createNumSlidePanel(panel, "Z Position", data.Position3.z, -200, 200)
	zPositionNumSlider3:SetFunction(function(val)
		data.Position3.z = val
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

local function spriteCirclePanel(panel, data, hasAnim)
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

	if hasAnim then
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
end

function SVMOD:EDITOR_Lights(panel, data, veh, hasAnim)
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
	bottomPanel:SetPaintBackground(false)

	local centerPanel = vgui.Create("DPanel", panel)
	centerPanel:Dock(FILL)
	centerPanel:SetPaintBackground(false)

	-- -------------------
	--  HOOKS
	-- -------------------

	-- -------------------
	--  FUNCTIONS
	-- -------------------

	local function getType(data)
		if data.ProjectedTexture then
			return " (projected)"
		elseif data.SpriteLine then
			return " (line)"
		elseif data.SpriteCircle then
			return " (circle)"
		end

		return ""
	end

	local function addLight(data)
		local max = 0
		for _, line in pairs(listView:GetLines()) do
			local index = line:GetIndex()
			if index > max then
				max = index
			end
		end

		local line = listView:AddLine(max + 1 .. getType(data))
		line.Data = data

		return line
	end

	local function removeLight(lineID, line)
		local index = line:GetIndex()

		if data[index].ProjectedTexture and IsValid(data[index].ProjectedTexture.Entity) then
			data[index].ProjectedTexture.Entity:Remove()
		end

		table.remove(data, index)

		for _, v in pairs(listView:GetLines()) do
			local i = v:GetIndex()
			if i > index then
				v:SetColumnText(1, i - 1 .. getType(v.Data))
			end
		end

		listView:RemoveLine(lineID)
	end

	local function upLight(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex - 1 then
				data[lineIndex], data[tempIndex] = data[tempIndex], data[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex .. getType(v.Data))
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex .. getType(line.Data))
				break
			end
		end
	end

	local function downLight(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex + 1 then
				data[lineIndex], data[tempIndex] = data[tempIndex], data[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex .. getType(v.Data))
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex .. getType(line.Data))
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

		menu:AddOption("Dupplicate", function()
			if line.Data.ProjectedTexture then
				local index = table.insert(data, {
					ProjectedTexture = SVMOD:DeepCopy(line.Data.ProjectedTexture)
				})
				addLight(data[index])
			end

			if line.Data.Sprite then
				local index = table.insert(data, {
					Sprite = SVMOD:DeepCopy(line.Data.Sprite)
				})
				addLight(data[index])
			end

			if line.Data.SpriteLine then
				local index = table.insert(data, {
					SpriteLine = SVMOD:DeepCopy(line.Data.SpriteLine)
				})
				addLight(data[index])
			end

			if line.Data.SpriteCircle then
				local index = table.insert(data, {
					SpriteCircle = SVMOD:DeepCopy(line.Data.SpriteCircle)
				})
				addLight(data[index])
			end
		end):SetIcon("icon16/page_copy.png")

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
				tab.Data.SpriteLine.Position3.x = -line.Data.SpriteLine.Position3.x
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
						Angles = Angle(0, 90, 0),
						Color = Color(255, 255, 255),
						Size = 1000,
						FOV = 110
					}
				})
				addLight(data[index])
			end):SetIcon("icon16/lightbulb_add.png")
		end

		menu:AddOption("Delete", function()
			removeLight(lineID, line)
		end):SetIcon("icon16/cross.png")

		menu:Open()
	end

	local addButton = SVMOD:CreateButton(bottomPanel, "ADD", function()
		local menu = DermaMenu()

		menu:AddOption("Projected texture", function()
			local index = table.insert(data, {
				ProjectedTexture = {
					Position = Vector(0, 0, 0),
					Angles = Angle(0, 90, 0),
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
					Position3 = Vector(0, 0, 0),
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

	local reloadButton = SVMOD:CreateButton(bottomPanel, "RELOAD ANIMATIONS", function()
		veh:SV_StopAlphaTimer()
		veh:SV_StartAlphaTimer()
	end)
	reloadButton:Dock(RIGHT)
	reloadButton:SetSize(180, 30)

	for _, light in ipairs(data) do
		if table.Count(light) > 1 then
			SVMOD:PrintConsole(SVMOD.LOG.Warning, "Light with multiple types, please report it!")
		end

		addLight(light)
	end

	listView.OnRowSelected = function(_, _, e)
		centerPanel:Clear()

		if e.Data.ProjectedTexture then
			projectedTexturePanel(centerPanel, e.Data.ProjectedTexture)
		elseif e.Data.Sprite then
			spritePanel(centerPanel, e.Data.Sprite, hasAnim)
		elseif e.Data.SpriteLine then
			if not e.Data.SpriteLine.Position3 then
				e.Data.SpriteLine.Position3 = Vector(0, 0, 0)
				e.Data.SpriteLine.Position3.x = e.Data.SpriteLine.Position2.x
				e.Data.SpriteLine.Position3.y = e.Data.SpriteLine.Position2.y
				e.Data.SpriteLine.Position3.z = e.Data.SpriteLine.Position2.z
			end
			spriteLinePanel(centerPanel, e.Data.SpriteLine)
		elseif e.Data.SpriteCircle then
			spriteCirclePanel(centerPanel, e.Data.SpriteCircle, hasAnim)
		end
	end
end