function SVMOD:GUI_Vehicles(panel, data)
	panel:Clear()

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

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.vehicles.vehicles"))

	local listView =  SVMOD:CreateListView(panel)
	listView:AddColumn(language.GetPhrase("svmod.vehicles.name"))
	listView:AddColumn(language.GetPhrase("svmod.vehicles.category"))
	listView:AddColumn(language.GetPhrase("svmod.vehicles.author"))
	listView:AddColumn(language.GetPhrase("svmod.vehicles.last_edition"))

	listView.OnRowRightClick = function(_, _, panel)
		if panel:GetColumnText(3) == "-" then
			if SVMOD.CFG.Contributor.IsEnabled then
				local Menu = DermaMenu()

				Menu:AddOption(language.GetPhrase("svmod.vehicles.create"), function()
					net.Start("SV_Editor_Open")
					net.WriteString(panel.Model)
					net.SendToServer()
					panel:GetParent():GetParent():GetParent():GetParent():Remove()
				end):SetIcon("icon16/pencil.png")

				Menu:Open()
			end
		else
			local Menu = DermaMenu()

			if SVMOD.CFG.Contributor.IsEnabled then
				Menu:AddOption(language.GetPhrase("svmod.vehicles.edit"), function()
					net.Start("SV_Editor_Open")
					net.WriteString(panel.Model)
					net.SendToServer()
					panel:GetParent():GetParent():GetParent():GetParent():Remove()
				end):SetIcon("icon16/pencil.png")
			end

			Menu:AddOption(language.GetPhrase("svmod.vehicles.author_profile"), function()
				gui.OpenURL("http://steamcommunity.com/profiles/" .. panel.Data.Author.SteamID64)
			end):SetIcon("icon16/user.png")

			-- Menu:AddOption(language.GetPhrase("Report"), function()
			-- 	SVMOD:OpenReportMenu(panel.Model, panel.Data.Timestamp)
			-- end):SetIcon("icon16/exclamation.png")

			Menu:Open()
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
		end
	end
	updateVehicleList()

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetDrawBackground(false)

	SVMOD:CreateHorizontalLine(panel, BOTTOM)

	local button = SVMOD:CreateButton(bottomPanel, language.GetPhrase("svmod.update"), function()
		SVMOD:Data_Update()

		panel:GetParent():Remove()
	end)
	button:Dock(RIGHT)
	button:SetSize(125, 0)
end