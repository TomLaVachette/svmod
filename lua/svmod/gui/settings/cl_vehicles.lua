function SVMOD:GUI_Vehicles(panel, data)
	panel:Clear()

	local function createHorizontalLine(dock)
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

	local function createTitle(name)
		local headerPanel = vgui.Create("DPanel", panel)
		headerPanel:Dock(TOP)
		headerPanel:SetSize(0, 20)
		headerPanel:SetDrawBackground(false)
	
		local titleLabel = vgui.Create("DLabel", headerPanel)
		titleLabel:SetPos(0, 0)
		titleLabel:SetFont("SV_CalibriLight22")
		titleLabel:SetColor(Color(178, 95, 245))
		titleLabel:SetText(name)
		titleLabel:SizeToContents()
	
		createHorizontalLine()
	end

	createTitle(SVMOD:GetLanguage("VEHICLES"))

	local listView = vgui.Create("DListView", panel)
	listView:Dock(FILL)
	listView:AddColumn(SVMOD:GetLanguage("Name"))
	listView:AddColumn(SVMOD:GetLanguage("Category"))
	listView:AddColumn(SVMOD:GetLanguage("Author"))
	listView:AddColumn(SVMOD:GetLanguage("Last edition"))
	listView.Paint = function(self, w, h)
		surface.SetDrawColor(12, 22, 24)
		surface.DrawRect(0, 0, w, h)
	end

	listView.OnRowRightClick = function(_, _, panel)
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

	for _, p in ipairs(listView.Columns) do
		p.Header.Paint = function(self, w, h)
			draw.SimpleText(self:GetText(), "SV_CalibriLight18", w / 2, h / 2, Color(230, 230, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end

	local function updateVehicleList()
		if not IsValid(listView) then return end

		listView:Clear()

		if not SVMOD.Data then return end

		for _, veh in ipairs(SVMOD:GetVehicleList()) do
			local vehicleData = SVMOD:GetData(veh.Model)
			local line
			if vehicleData then
				line = listView:AddLine(veh.Name, veh.Category, vehicleData.Author.Name, os.date("%d/%m/%Y - %H:%M", vehicleData.Timestamp))
				line.Data = vehicleData
			else
				line = listView:AddLine(veh.Name, veh.Category, "-", "-")
			end
			line.Model = veh.Model

			line:SetTall(40)

			for _, c in ipairs(line.Columns) do
				c:SetFont("SV_Calibri18")
				c:SetColor(Color(160, 160, 160))
			end
			
		end
	end
	updateVehicleList()

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetDrawBackground(false)

	createHorizontalLine(BOTTOM)

	local buttonText = SVMOD:GetLanguage("Update")

	local button = vgui.Create("DButton", bottomPanel)
	button:Dock(RIGHT)
	button:DockMargin(8, 0, 0, 0)
	button:SetSize(125, 0)
	button:SetText("")
	button.DoClick = function(self)
		SVMOD:Data_Update()

		panel:GetParent():Remove()
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

		draw.SimpleText(buttonText, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end