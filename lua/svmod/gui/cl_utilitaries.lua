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

local crossMaterial = Material("materials/vgui/svmod/cross.png", "noclamp smooth")

function SVMOD:CreateFrame(name)
	local frame = vgui.Create("DFrame")
	frame:SetSize(900, 650)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(178, 95, 245)
		surface.DrawRect(0, 0, w, 4)
	end

	local closePanel = vgui.Create("DPanel", frame)
	closePanel:SetSize(24, 24)
	closePanel:SetPos(900 - 48, 11)
	closePanel.Paint = function(self, w, h)
		if self.isHovered then
			surface.SetDrawColor(237, 197, 255, 255)
		else
			surface.SetDrawColor(154, 128, 166, 255)
		end
		surface.SetMaterial(crossMaterial)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	closePanel.OnCursorEntered = function(self)
		self.isHovered = true
		self:SetCursor("hand")
	end
	closePanel.OnCursorExited = function(self)
		self.isHovered = false
	end
	closePanel.OnMousePressed = function(_)
		surface.PlaySound("garrysmod/ui_click.wav")
		if frame.CustomClose then
			frame:CustomClose()
		else
			frame:Remove()
		end
	end

	local title = vgui.Create("DLabel", frame)
	title:SetPos(15, 12)
	title:SetFont("SV_CalibriLight22")
	title:SetText(name)
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
	leftPanel:SetPaintBackground(false)

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
	centerPanel:SetPaintBackground(false)

	frame.GetCenterPanel = function()
		return centerPanel
	end

	frame.GetLeftPanel = function()
		return leftPanel
	end

	frame.CreateMenuButton = function(self, text, dock, fun)
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

	return frame
end

function SVMOD:CreateSettingPanel(panel, text, panels)
	local settingPanel = vgui.Create("DPanel", panel)
	settingPanel:Dock(TOP)
	settingPanel:DockMargin(0, 4, 0, 4)
	settingPanel:SetSize(0, 30)
	settingPanel:SetPaintBackground(false)

	local label = vgui.Create("DLabel", settingPanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(text)
	label:SizeToContents()

	for _, p in ipairs(panels) do
		local button = vgui.Create("DButton", settingPanel)
		button:Dock(RIGHT)
		button:DockMargin(8, 0, 0, 0)
		button:SetSize(100, 0)
		button:SetText("")
		button.DoClick = function(self)
			p.IsSelected = true

			p.DoClick()

			for _, t in ipairs(panels) do
				if t.Name ~= p.Name then
					t.IsSelected = false
				end
			end
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

				if p.IsSelected then
					color = p.HoverColor
				else
					color = Color(237, 197, 255)
				end
			else
				self.soundPlayed = false

				if p.IsSelected then
					color = p.Color
				else
					color = Color(154, 128, 166)
				end
			end

			surface.SetDrawColor(color.r, color.g, color.b)

			surface.DrawRect(3, 3, 7, 1)
			surface.DrawRect(3, 3, 1, 7)

			surface.DrawRect(w - 3 - 7, 3, 7, 1)
			surface.DrawRect(w - 3, 3, 1, 7)

			surface.DrawRect(3, h - 3, 7, 1)
			surface.DrawRect(3, h - 3 - 7, 1, 7)

			surface.DrawRect(w - 3 - 7, h - 3, 7, 1)
			surface.DrawRect(w - 3, h - 3 - 7, 1, 7)

			draw.SimpleText(p.Name, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	return settingPanel
end

function SVMOD:CreateButton(panel, text, fun)
	local button = vgui.Create("DButton", panel)
	button:Dock(LEFT)
	button:SetSize(100, 0)
	button:SetText("")
	button.DoClick = function(self)
		fun(self)
	end

	button.SetText = function(self, val)
		self.Text = val
	end
	button.GetText = function(self)
		return self.Text
	end
	button:SetText(text)

	button.Paint = function(self, w, h)
		surface.SetDrawColor(12, 22, 24)
		surface.DrawRect(0, 0, w, h)

		local color

		if self:IsHovered() then
			if not self.soundPlayed then
				surface.PlaySound("garrysmod/ui_hover.wav")
				self.soundPlayed = true
			end

			color = Color(237, 197, 255)
		else
			self.soundPlayed = false

			color = Color(154, 128, 166)
		end

		surface.SetDrawColor(color.r, color.g, color.b)

		surface.DrawRect(3, 3, 7, 1)
		surface.DrawRect(3, 3, 1, 7)

		surface.DrawRect(w - 3 - 7, 3, 7, 1)
		surface.DrawRect(w - 3, 3, 1, 7)

		surface.DrawRect(3, h - 3, 7, 1)
		surface.DrawRect(3, h - 3 - 7, 1, 7)

		surface.DrawRect(w - 3 - 7, h - 3, 7, 1)
		surface.DrawRect(w - 3, h - 3 - 7, 1, 7)

		draw.SimpleText(button:GetText(), "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	return button
end

function SVMOD:CreateNumSlidePanel(panel, text, fun)
	local numSlidePanel = vgui.Create("DPanel", panel)
	numSlidePanel:Dock(TOP)
	numSlidePanel:DockMargin(0, 4, 0, 4)
	numSlidePanel:SetSize(0, 30)
	numSlidePanel:SetPaintBackground(false)

	local label = vgui.Create("DLabel", numSlidePanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(text)
	label:SizeToContents()

	local numSlider = vgui.Create("DPanel", numSlidePanel)
	numSlider:Dock(RIGHT)
	numSlider:DockMargin(0, 5, 0, 5)
	numSlider:SetSize(205, 0)
	numSlider.SetValue = function(self, val)
		self.Value = math.Round(val, 1)
	end
	numSlider.GetValue = function(self, val)
		return self.Value or 0
	end
	numSlider.SetMinValue = function(self, val)
		self.MinValue = val
	end
	numSlider.GetMinValue = function(self, val)
		return self.MinValue or 0
	end
	numSlider.SetMaxValue = function(self, val)
		self.MaxValue = val
	end
	numSlider.GetMaxValue = function(self, val)
		return self.MaxValue or 100
	end
	numSlider.SetUnit = function(self, val)
		self.Unit = val
	end
	numSlider.GetUnit = function(self, val)
		return self.Unit or "%"
	end
	numSlider.SetRealTime = function(self, val)
		self.RealTime = val
	end
	numSlider.GetRealTime = function(self, val)
		return self.RealTime or false
	end
	numSlider.SetFunction = function(self, fun)
		self.Function = fun
	end
	numSlider.GetFunction = function(self, val)
		return self.Function or fun
	end

	numSlider.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(41, 56, 63)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(132, 84, 202)
		surface.DrawRect(1, 1, (w - 2) * (self:GetValue() - self:GetMinValue()) / (self:GetMaxValue() - self:GetMinValue()), h - 2)

		draw.SimpleText(self:GetValue() .. " " .. self:GetUnit(), "SV_Calibri18", w / 2, h / 2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	numSlider.OnMousePressed = function(self, keyCode)
		local width, _ = self:GetSize()

		if keyCode == MOUSE_LEFT then
			hook.Add("Think", "SV_NumSlider", function()
				if not input.IsMouseDown(MOUSE_LEFT) then
					hook.Remove("Think", "SV_NumSlider")

					self:GetFunction()(self:GetValue())
				else
					local cursorX, _ = self:LocalCursorPos()

					local cursor = math.Clamp(cursorX / width, 0, 1)

					local val = math.Round(cursor * (self:GetMaxValue() - self:GetMinValue()) + self:GetMinValue())

					if numSlider:GetRealTime() and numSlider:GetValue() ~= val then
						numSlider:GetFunction()(val)
					end
					numSlider:SetValue(val)
				end
			end)
		end
	end
	numSlider.OnMouseWheeled = function(self, scrollDelta)
		numSlider:SetValue(numSlider:GetValue() + 0.1 * scrollDelta)
		self:GetFunction()(self:GetValue())
	end

	return numSlider
end

function SVMOD:CreateHorizontalLine(panel, dock)
	if not dock then
		dock = TOP
	end

	local topHorizontalLine = vgui.Create("DPanel", panel)
	topHorizontalLine:Dock(dock)
	topHorizontalLine:DockMargin(0, 10, 0, 10)
	topHorizontalLine:SetSize(0, 1)
	topHorizontalLine.Paint = function(self, w, h)
		surface.SetDrawColor(39, 52, 58)
		surface.DrawRect(0, 0, w, h)
	end
end

function SVMOD:CreateTitle(panel, name)
	local headerPanel = vgui.Create("DPanel", panel)
	headerPanel:Dock(TOP)
	headerPanel:SetSize(0, 20)
	headerPanel:SetPaintBackground(false)

	local titleLabel = vgui.Create("DLabel", headerPanel)
	titleLabel:SetPos(0, 0)
	titleLabel:SetFont("SV_CalibriLight22")
	titleLabel:SetColor(Color(178, 95, 245))
	titleLabel:SetText(name)
	titleLabel:SizeToContents()

	SVMOD:CreateHorizontalLine(panel)

	return headerPanel
end

function SVMOD:CreateListView(panel)
	local listView = vgui.Create("DListView", panel)
	listView:Dock(FILL)
	listView.Paint = function(self, w, h)
		surface.SetDrawColor(12, 22, 24)
		surface.DrawRect(0, 0, w, h)
	end

	local addColumn = listView.AddColumn
	listView.AddColumn = function(...)
		local column = addColumn(...)

		column.Header.Paint = function(self, w, h)
			draw.SimpleText(self:GetText(), "SV_CalibriLight18", w / 2, h / 2, Color(230, 230, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		return column
	end

	local addLine = listView.AddLine
	listView.AddLine = function(...)
		local line = addLine(...)

		line:SetTall(40)

		for _, c in ipairs(line.Columns) do
			c:SetFont("SV_Calibri18")
			c:SetColor(Color(160, 160, 160))
		end

		line.GetIndex = function(self)
			return tonumber(string.Split(line:GetColumnText(1), " ")[1])
		end

		return line
	end

	return listView
end

function SVMOD:CreateTextboxPanel(panel, placeholder)
	local textEntry = vgui.Create("DTextEntry", panel)
	textEntry:Dock(RIGHT)
	textEntry:DockMargin(8, 0, 0, 0)
	textEntry:SetSize(300, 0)
	textEntry:SetPlaceholderText(placeholder)
	textEntry.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(41, 56, 63)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText(self:GetValue(), "SV_Calibri18", 8, h / 2, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	return textEntry
end