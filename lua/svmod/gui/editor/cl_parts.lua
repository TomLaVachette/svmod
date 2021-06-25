function SVMOD:EDITOR_Parts(panel, veh, data)
	panel:Clear()

	local leftPanel = vgui.Create("DPanel", panel)
	leftPanel:Dock(LEFT)
	leftPanel:DockPadding(0, 0, 10, 0)
	leftPanel:SetSize(100, 0)
	leftPanel:SetPaintBackground(false)

	local listView = SVMOD:CreateListView(leftPanel)
	listView:SetHideHeaders(true)
	listView:Dock(FILL)
	listView:AddColumn("ID")
	listView:SetMultiSelect(false)

	local addPart

	local addButton = SVMOD:CreateButton(leftPanel, "ADD", function()
		local index = table.insert(data, {
			Position = Vector(0, 0, 0),
			Angles = Angle(0, 0, 0),
			Type = "engine"
		})
		addPart(data[index])
	end)
	addButton:SetSize(0, 30)
	addButton:Dock(BOTTOM)

	local centerPanel = vgui.Create("DPanel", panel)
	centerPanel:Dock(FILL)
	centerPanel:SetPaintBackground(false)

	local function createNumSlidePanel(name, defaultValue, minValue, maxValue)
		local numSlider = SVMOD:CreateNumSlidePanel(centerPanel, name, function() end)
		numSlider:SetSize(400, 30)
		numSlider:SetValue(defaultValue)
		numSlider:SetMinValue(minValue)
		numSlider:SetMaxValue(maxValue)
		numSlider:SetUnit(" ")
		numSlider:SetRealTime(true)

		return numSlider
	end

	-- -------------------
	--  FUNCTIONS
	-- -------------------

	addPart = function(data)
		local max = 0
		for _, line in pairs(listView:GetLines()) do
			local index = line:GetIndex()
			if index > max then
				max = index
			end
		end

		local line = listView:AddLine(max + 1)
		line.Data = data

		return line
	end

	local function removePart(lineID, line)
		local index = line:GetIndex()

		table.remove(data, index)

		for _, v in pairs(listView:GetLines()) do
			local i = v:GetIndex()
			if i > index then
				v:SetColumnText(1, i - 1)
			end
		end

		listView:RemoveLine(lineID)
	end

	local function upPart(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex - 1 then
				data[lineIndex], data[tempIndex] = data[tempIndex], data[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex)
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex)
				break
			end
		end
	end

	local function downPart(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex + 1 then
				data[lineIndex], data[tempIndex] = data[tempIndex], data[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex)
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex)
				break
			end
		end
	end

	for _, v in ipairs(data) do
		addPart(v)
	end

	listView.OnRowRightClick = function(_, lineID, line)
		local menu = DermaMenu()

		menu:AddOption("Up", function()
			upPart(lineID)
		end):SetIcon("icon16/arrow_up.png")

		menu:AddOption("Down", function()
			downPart(lineID)
		end):SetIcon("icon16/arrow_down.png")

		menu:AddOption("Symmetric", function()
			local index = table.insert(data, {
				Position = Vector(-line.Data.Position.x, line.Data.Position.y, line.Data.Position.z),
				Angles = Angle(line.Data.Angles.x, line.Data.Angles.y, line.Data.Angles.z),
				Type = "engine"
			})

			addPart(data[index])

			newPart = data[index]

			newPart.Angles.z = line.Data.Angles.z - 180
			if newPart.Angles.z < -180 then
				newPart.Angles.z = 180 - (newPart.Angles.z + 180)
			end
		end):SetIcon("icon16/arrow_refresh.png")

		menu:AddOption("Delete", function()
			removePart(lineID, line)
		end):SetIcon("icon16/cross.png")

		menu:Open()
	end

	local lastRowSelected

	listView.OnRowSelected = function(_, _, e)
		centerPanel:Clear()

		e.Data.Health = 100
		if lastRowSelected and lastRowSelected.Data then
			lastRowSelected.Data.Health = 50
		end
		lastRowSelected = e

		local title = SVMOD:CreateTitle(centerPanel, "SETTINGS")
		title:DockMargin(0, 5, 0, 0)

		local wheelType

		SVMOD:CreateSettingPanel(centerPanel, "Part type", {
			{
				Name = "Engine",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = (e.Data.Type == "engine"),
				DoClick = function()
					wheelType:Hide()
					e.Data.Type = "engine"
				end
			},
			{
				Name = "Wheel",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = string.StartWith(e.Data.Type, "wheel"),
				DoClick = function()
					e.Data.Type = "wheel_fl"
					wheelType:Show()
				end
			}
		})

		wheelType = SVMOD:CreateSettingPanel(centerPanel, "Wheel type", {
			{
				Name = "Front Left",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = (not string.StartWith(e.Data.Type, "wheel")) or (e.Data.Type == "wheel_fl"),
				DoClick = function()
					e.Data.Type = "wheel_fl"
				end
			},
			{
				Name = "Front Right",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = (e.Data.Type == "wheel_fr"),
				DoClick = function()
					e.Data.Type = "wheel_fr"
				end
			},
			{
				Name = "Rear Left",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = (e.Data.Type == "wheel_rl"),
				DoClick = function()
					e.Data.Type = "wheel_rl"
				end
			},
			{
				Name = "Rear Right",
				Color = Color(59, 217, 85),
				HoverColor = Color(156, 255, 161),
				IsSelected = (e.Data.Type == "wheel_rr"),
				DoClick = function()
					e.Data.Type = "wheel_rr"
				end
			}
		})
		if not string.StartWith(e.Data.Type, "wheel") then
			wheelType:Hide()
		end

		title = SVMOD:CreateTitle(centerPanel, "LOCAL POSITIONS")
		title:DockMargin(0, 30, 0, 0)

		local button = SVMOD:CreateButton(title, "EyePos", function()
			local trace = LocalPlayer():GetEyeTrace()

			if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
				e.Data.Position = trace.Entity:WorldToLocal(trace.HitPos)

				xPositionNumSlider:SetValue(e.Data.Position.x)
				yPositionNumSlider:SetValue(e.Data.Position.y)
				zPositionNumSlider:SetValue(e.Data.Position.z)
			end
		end)
		button:Dock(RIGHT)

		xPositionNumSlider = createNumSlidePanel("X Position", e.Data.Position.x, -200, 200)
		xPositionNumSlider:SetFunction(function(val)
			e.Data.Position.x = val
		end)

		yPositionNumSlider = createNumSlidePanel("Y Position", e.Data.Position.y, -200, 200)
		yPositionNumSlider:SetFunction(function(val)
			e.Data.Position.y = val
		end)

		zPositionNumSlider = createNumSlidePanel("Z Position", e.Data.Position.z, -200, 200)
		zPositionNumSlider:SetFunction(function(val)
			e.Data.Position.z = val
		end)

		title = SVMOD:CreateTitle(centerPanel, "ANGLES")
		title:DockMargin(0, 30, 0, 0)

		local xAngleNumSlider = createNumSlidePanel("Y Angle", e.Data.Angles.x, -180, 180)
		xAngleNumSlider:SetFunction(function(val)
			e.Data.Angles.x = val
		end)

		local yAngleNumSlider = createNumSlidePanel("P Angle", e.Data.Angles.y, -180, 180)
		yAngleNumSlider:SetFunction(function(val)
			e.Data.Angles.y = val
		end)

		local zAngleNumSlider = createNumSlidePanel("R Angle", e.Data.Angles.z, -180, 180)
		zAngleNumSlider:SetFunction(function(val)
			e.Data.Angles.z = val
		end)
	end

	SVMOD.VehicleRenderedParts = veh

	centerPanel.OnRemove = function()
		SVMOD.VehicleRenderedParts = nil
	end

	for _, v in ipairs(data) do
		v.Health = 50
	end
end