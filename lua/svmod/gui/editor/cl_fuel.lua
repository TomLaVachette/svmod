function SVMOD:EDITOR_Fuel(panel, veh, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.fuel.fuel"))

	local capacityNumSlider = SVMOD:CreateNumSlidePanel(panel, "Capacity", function(val)
		data.Capacity = val
	end)
	capacityNumSlider:SetMaxValue(110)
	capacityNumSlider:SetValue(data.Capacity or 60)
	capacityNumSlider:SetUnit("L")

	local consumptionNumSlider = SVMOD:CreateNumSlidePanel(panel, "Consumption", function(val)
		data.Consumption = val
	end)
	consumptionNumSlider:SetMaxValue(30)
	consumptionNumSlider:SetValue(data.Consumption or 5)
	consumptionNumSlider:SetUnit("L / 100 km")

	SVMOD:CreateHorizontalLine(panel)

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

	local addFuel

	local addButton = SVMOD:CreateButton(leftPanel, "ADD", function()
		local index = table.insert(data.GasTank, {
			GasHole = {
				Position = Vector(0, 0, 0),
				Angles = Angle(0, 0, 0)
			},
			GasolinePistol = {
				Position = Vector(0, 0, 0),
				Angles = Angle(0, 0, 0)
			}
		})
		addFuel(data.GasTank[index])
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

	addFuel = function(data)
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

	local function removeFuel(lineID, line)
		local index = line:GetIndex()

		table.remove(data.GasTank, index)

		for _, v in pairs(listView:GetLines()) do
			local i = v:GetIndex()
			if i > index then
				v:SetColumnText(1, i - 1)
			end
		end

		listView:RemoveLine(lineID)
	end

	local function upFuel(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex - 1 then
				data.GasTank[lineIndex], data.GasTank[tempIndex] = data.GasTank[tempIndex], data.GasTank[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex)
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex)
				break
			end
		end
	end

	local function downFuel(index)
		local line = listView:GetLine(index)
		lineIndex = line:GetIndex()

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = v:GetIndex()
			if tempIndex == lineIndex + 1 then
				data.GasTank[lineIndex], data.GasTank[tempIndex] = data.GasTank[tempIndex], data.GasTank[lineIndex]
				line.Data, v.Data = v.Data, line.Data
				listView:GetLine(tempIndex):SetColumnText(1, tempIndex)
				listView:GetLine(lineIndex):SetColumnText(1, lineIndex)
				break
			end
		end
	end

	for _, v in ipairs(data.GasTank) do
		addFuel(v)
	end

	listView.OnRowRightClick = function(_, lineID, line)
		local menu = DermaMenu()

		menu:AddOption("Up", function()
			upFuel(lineID)
		end):SetIcon("icon16/arrow_up.png")

		menu:AddOption("Down", function()
			downFuel(lineID)
		end):SetIcon("icon16/arrow_down.png")

		menu:AddOption("Symmetric", function()
			local index = table.insert(data.GasTank, SVMOD:DeepCopy(line.Data))
			local tab = addFuel(data.GasTank[index])
			tab.Data.GasHole.Position.x = -line.Data.GasHole.Position.x
			tab.Data.GasHole.Angles.y = line.Data.GasHole.Angles.y - 180
			if tab.Data.GasHole.Angles.y < -180 then
				tab.Data.GasHole.Angles.y = 180 - (tab.Data.GasHole.Angles.y + 180)
			end
			tab.Data.GasHole.Angles.z = line.Data.GasHole.Angles.z + 90
			if tab.Data.GasHole.Angles.z > 180 then
				tab.Data.GasHole.Angles.z = -180 + (tab.Data.GasHole.Angles.z - 180)
			end

			tab.Data.GasolinePistol.Position.x = -line.Data.GasolinePistol.Position.x
			tab.Data.GasolinePistol.Angles.y = tab.Data.GasolinePistol.Angles.y + 180
			if tab.Data.GasolinePistol.Angles.y > 180 then
				tab.Data.GasolinePistol.Angles.y = -180 + (tab.Data.GasolinePistol.Angles.y - 180)
			end
		end):SetIcon("icon16/arrow_refresh.png")

		menu:AddOption("Delete", function()
			removeFuel(lineID, line)
		end):SetIcon("icon16/cross.png")

		menu:Open()
	end

	listView.OnRowSelected = function(_, _, e)
		centerPanel:Clear()

		local gasolinePistol = ClientsideModel("models/kaesar/kaesar_weapons/w_petrolgun.mdl")

		local title = SVMOD:CreateTitle(centerPanel, "GAS TANK HUD POSITION")
		title:DockMargin(0, 5, 0, 0)
		local button = SVMOD:CreateButton(title, "EyePos", function()
			local trace = LocalPlayer():GetEyeTrace()

			if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
				e.Data.GasHole.Position = trace.Entity:WorldToLocal(trace.HitPos)

				xPositionNumSlider:SetValue(e.Data.GasHole.Position.x)
				yPositionNumSlider:SetValue(e.Data.GasHole.Position.y)
				zPositionNumSlider:SetValue(e.Data.GasHole.Position.z)
			end
		end)
		button:Dock(RIGHT)

		xPositionNumSlider = createNumSlidePanel("X Position", e.Data.GasHole.Position.x, -200, 200)
		xPositionNumSlider:SetFunction(function(val)
			e.Data.GasHole.Position.x = val
		end)

		yPositionNumSlider = createNumSlidePanel("Y Position", e.Data.GasHole.Position.y, -200, 200)
		yPositionNumSlider:SetFunction(function(val)
			e.Data.GasHole.Position.y = val
		end)

		zPositionNumSlider = createNumSlidePanel("Z Position", e.Data.GasHole.Position.z, -200, 200)
		zPositionNumSlider:SetFunction(function(val)
			e.Data.GasHole.Position.z = val
		end)

		local title = SVMOD:CreateTitle(centerPanel, "GAS TANK HUD ANGLE")
		title:DockMargin(0, 30, 0, 0)

		local xAngleNumSlider = createNumSlidePanel("Y Angle", e.Data.GasHole.Angles.x, -180, 180)
		xAngleNumSlider:SetFunction(function(val)
			e.Data.GasHole.Angles.x = val
		end)

		local yAngleNumSlider = createNumSlidePanel("P Angle", e.Data.GasHole.Angles.y, -180, 180)
		yAngleNumSlider:SetFunction(function(val)
			e.Data.GasHole.Angles.y = val
		end)

		local zAngleNumSlider = createNumSlidePanel("R Angle", e.Data.GasHole.Angles.z, -180, 180)
		zAngleNumSlider:SetFunction(function(val)
			e.Data.GasHole.Angles.z = val
		end)

		local xPistolPositionNumSlider, yPistolPositionNumSlider, zPistolPositionNumSlider

		local title = SVMOD:CreateTitle(centerPanel, "GASOLINE PISTOL POSITION")
		title:DockMargin(0, 30, 0, 0)
		local button = SVMOD:CreateButton(title, "EyePos", function()
			local trace = LocalPlayer():GetEyeTrace()

			if IsValid(trace.Entity) and trace.Entity:IsVehicle() then
				e.Data.GasolinePistol.Position = trace.Entity:WorldToLocal(trace.HitPos)

				xPistolPositionNumSlider:SetValue(e.Data.GasolinePistol.Position.x)
				yPistolPositionNumSlider:SetValue(e.Data.GasolinePistol.Position.y)
				zPistolPositionNumSlider:SetValue(e.Data.GasolinePistol.Position.z)

				gasolinePistol:SetPos(veh:LocalToWorld(e.Data.GasolinePistol.Position))
			end
		end)
		button:Dock(RIGHT)

		xPistolPositionNumSlider = createNumSlidePanel("X Position", e.Data.GasolinePistol.Position.x, -200, 200)
		xPistolPositionNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Position.x = val
			gasolinePistol:SetPos(veh:LocalToWorld(e.Data.GasolinePistol.Position))
		end)

		yPistolPositionNumSlider = createNumSlidePanel("Y Position", e.Data.GasolinePistol.Position.y, -200, 200)
		yPistolPositionNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Position.y = val
			gasolinePistol:SetPos(veh:LocalToWorld(e.Data.GasolinePistol.Position))
		end)

		zPistolPositionNumSlider = createNumSlidePanel("Z Position", e.Data.GasolinePistol.Position.z, -200, 200)
		zPistolPositionNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Position.z = val
			gasolinePistol:SetPos(veh:LocalToWorld(e.Data.GasolinePistol.Position))
		end)

		local title = SVMOD:CreateTitle(centerPanel, "GASOLINE PISTOL ANGLE")
		title:DockMargin(0, 30, 0, 0)

		local xAngleNumSlider = createNumSlidePanel("Y Angle", e.Data.GasolinePistol.Angles.x, -180, 180)
		xAngleNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Angles.x = val
			gasolinePistol:SetAngles(veh:LocalToWorldAngles(e.Data.GasolinePistol.Angles))
		end)

		local yAngleNumSlider = createNumSlidePanel("P Angle", e.Data.GasolinePistol.Angles.y, -180, 180)
		yAngleNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Angles.y = val
			gasolinePistol:SetAngles(veh:LocalToWorldAngles(e.Data.GasolinePistol.Angles))
		end)

		local zAngleNumSlider = createNumSlidePanel("R Angle", e.Data.GasolinePistol.Angles.z, -180, 180)
		zAngleNumSlider:SetFunction(function(val)
			e.Data.GasolinePistol.Angles.z = val
			gasolinePistol:SetAngles(veh:LocalToWorldAngles(e.Data.GasolinePistol.Angles))
		end)

		title.OnRemove = function()
			gasolinePistol:Remove()
		end

		gasolinePistol:SetPos(veh:LocalToWorld(e.Data.GasolinePistol.Position))
		gasolinePistol:SetAngles(veh:LocalToWorldAngles(e.Data.GasolinePistol.Angles))
	end

	veh:SV_ShowFillingHUD()

	centerPanel.OnRemove = function()
		veh:SV_HideFillingHUD()
	end
end