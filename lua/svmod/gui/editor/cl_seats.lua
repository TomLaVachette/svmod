function SVMOD:EDITOR_Seats(panel, veh)
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

    local addSeat

    local addButton = SVMOD:CreateButton(bottomPanel, "Add", function()
        addSeat(Vector(0, 0, 0), Angle(0, 0, 0))
    end)
    addButton:Dock(RIGHT)

    -- -------------------
    --  FUNCTIONS
    -- -------------------

    addSeat = function(position, angles)
		local max = 0
		for _, line in pairs(listView:GetLines()) do
			local index = tonumber(line:GetColumnText(1))
			if index > max then
				max = index
			end
		end

		local line = listView:AddLine(max + 1)
		line.Seat = SVMOD:CreateCSSeat(veh)
		line.Seat:SetParent(veh)
		line.Seat:SetLocalPos(position)
		line.Seat:SetLocalAngles(angles)
	end

	local function removeSeat(index)
		local line = listView:GetLine(index)
		columnText = tonumber(line:GetColumnText(1))
		if IsValid(line.Seat) then
			line.Seat:Remove()
		end

		for _, v in pairs(listView:GetLines()) do
			local index = tonumber(v:GetColumnText(1))
			if index > columnText then
				v:SetColumnText(1, index - 1)
			end
		end

		listView:RemoveLine(index)
	end

	local function upSeat(index)
		local line = listView:GetLine(index)
		lineIndex = tonumber(line:GetColumnText(1))

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = tonumber(v:GetColumnText(1))
			if IsValid(v.Seat) and tempIndex == lineIndex - 1 then
				line.Seat, v.Seat = v.Seat, line.Seat
				break
			end
		end
	end

	local function downSeat(index)
		local line = listView:GetLine(index)
		lineIndex = tonumber(line:GetColumnText(1))

		for _, v in pairs(listView:GetLines()) do
			local tempIndex = tonumber(v:GetColumnText(1))
			if IsValid(v.Seat) and tempIndex == lineIndex + 1 then
				line.Seat, v.Seat = v.Seat, line.Seat
				break
			end
		end
	end

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

    -- -------------------
    --  HOOKS
    -- -------------------

    hook.Add("PreDrawHalos", "SV_Editor_Halo", function()
        local seats = {}

		local _, line = listView:GetSelectedLine()
		if line and IsValid(line.Seat) then
			table.insert(seats, line.Seat)
		end

        halo.Add(seats, Color(255, 0, 0), 2, 2, 1, true, true)
	end)

	listView.OnRemove = function()
		for _, line in pairs(listView:GetLines()) do
			local index = tonumber(line:GetColumnText(1))
			if IsValid(line.Seat) then
				veh.SV_Data.Seats[index] = {
					Position = line.Seat:GetLocalPos(),
					Angle = line.Seat:GetLocalAngles()
				}
				line.Seat:Remove()
			end
		end

		hook.Remove("PreDrawHalos", "SV_Editor_Halo")
	end

	listView.OnRowRightClick = function(_, index, e)
		local menu = DermaMenu()

		menu:AddOption("Up", function()
			upSeat(index)
		end):SetIcon("icon16/arrow_up.png")

		menu:AddOption("Down", function()
			downSeat(index)
		end):SetIcon("icon16/arrow_down.png")

		menu:AddOption("Symmetric", function()
			for _, line in pairs(listView:GetSelected()) do
				local pos = line.Seat:GetLocalPos()
				pos.x = -pos.x
				addSeat(pos, line.Seat:GetLocalAngles())
			end
		end):SetIcon("icon16/arrow_refresh.png")

		menu:AddOption("Delete", function()
			removeSeat(index)
		end):SetIcon("icon16/cross.png")

		menu:Open()
	end

	-- -------------------
    --  PANELS
    -- -------------------

    for _, seat in ipairs(veh.SV_Data.Seats) do
		addSeat(seat.Position, seat.Angle)
	end

    SVMOD:CreateTitle(panel, "LOCAL POSITIONS")

	local xPositionNumSlider = createNumSlidePanel(panel, "X Position", 0, -200, 200)
	local yPositionNumSlider = createNumSlidePanel(panel, "Y Position", 0, -200, 200)
	local zPositionNumSlider = createNumSlidePanel(panel, "Z Position", 0, -200, 200)

	local title = SVMOD:CreateTitle(panel, "ANGLES")
	title:DockMargin(0, 30, 0, 0)

	local xAngleNumSlider = createNumSlidePanel(panel, "X Angle", 0, -180, 180)
	local yAngleNumSlider = createNumSlidePanel(panel, "Y Angle", 0, -180, 180)
	local zAngleNumSlider = createNumSlidePanel(panel, "Z Angle", 0, -180, 180)

	listView.OnRowSelected = function(_, _, e)
		local currentPos = e.Seat:GetLocalPos()
		
		xPositionNumSlider:SetFunction(function(val)
			local pos = e.Seat:GetLocalPos()
			e.Seat:SetLocalPos(Vector(val, pos.y, pos.z))
		end)
		xPositionNumSlider:SetValue(math.Round(currentPos.x))
		
		yPositionNumSlider:SetFunction(function(val)
			local pos = e.Seat:GetLocalPos()
			e.Seat:SetLocalPos(Vector(pos.x, val, pos.z))
		end)
		yPositionNumSlider:SetValue(math.Round(currentPos.y))
		
		zPositionNumSlider:SetFunction(function(val)
			local pos = e.Seat:GetLocalPos()
			e.Seat:SetLocalPos(Vector(pos.x, pos.y, val))
		end)
		zPositionNumSlider:SetValue(math.Round(currentPos.z))

		local currentAng = e.Seat:GetLocalAngles()

		xAngleNumSlider:SetFunction(function(val)
			local ang = e.Seat:GetLocalAngles()
			e.Seat:SetLocalAngles(Angle(math.floor(val), ang.y, ang.z))
		end)
		xAngleNumSlider:SetValue(math.Round(currentAng.x))

		yAngleNumSlider:SetFunction(function(val)
			local ang = e.Seat:GetLocalAngles()
			e.Seat:SetLocalAngles(Angle(ang.x, math.floor(val), ang.z))
		end)
		yAngleNumSlider:SetValue(math.Round(currentAng.y))

		zAngleNumSlider:SetFunction(function(val)
			local ang = e.Seat:GetLocalAngles()
			e.Seat:SetLocalAngles(Angle(ang.x, ang.y, math.floor(val)))
		end)
		zAngleNumSlider:SetValue(math.Round(currentAng.z))
	end

	listView:SelectFirstItem()
end