function SVMOD:GUI_Fuel(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.fuel.fuel"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.fuel.enable_fuel"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.FuelIsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Fuel")
				net.WriteString("IsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.FuelIsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Fuel")
				net.WriteString("IsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.fuel.consumption_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Fuel")
		net.WriteString("Multiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.FuelMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local title = SVMOD:CreateTitle(panel, language.GetPhrase("svmod.fuel.gas_pump"))
	title:DockMargin(0, 30, 0, 0)

	local pumpList = SVMOD:CreateListView(panel)
	pumpList:AddColumn("ID"):SetWidth(10)
	pumpList:AddColumn(language.GetPhrase("svmod.fuel.model"))
	pumpList:AddColumn("MapCreationID")
	pumpList:AddColumn(language.GetPhrase("svmod.fuel.position"))
	pumpList:AddColumn(language.GetPhrase("svmod.fuel.angles")):SetWidth(20)
	pumpList:AddColumn(language.GetPhrase("svmod.fuel.price")):SetWidth(10)

	pumpList.OnRowRightClick = function(self, _, line)
		local menu = DermaMenu()

		menu:AddOption(language.GetPhrase("svmod.fuel.goto"), function()
			net.Start("SV_Settings_GoToFuelPump")
			net.WriteUInt(tonumber(line:GetColumnText(1)), 5) -- max: 31
			net.SendToServer()
		end):SetIcon("icon16/arrow_in.png")

		menu:Open()
	end

	net.Start("SV_Settings_GetFuelPump")
	net.SendToServer()

	net.Receive("SV_Settings_GetFuelPump", function()
		local count = net.ReadUInt(5) -- max: 31
		for i = 1, count do
			local model = net.ReadString()
			local isCompiled = net.ReadBool()
			local mapCreationID = net.ReadUInt(16) -- max: 65535
			local position = net.ReadVector()
			local angle = net.ReadAngle()
			local price = net.ReadUInt(16) -- max: 65535

			if not isCompiled then
				mapCreationID = -1
			end

			pumpList:AddLine(
				table.Count(pumpList:GetLines()) + 1,
				model,
				mapCreationID,
				position.x .. ", " .. position.y .. ", " .. position.z,
				angle.x .. ", " .. angle.y .. ", " .. angle.z,
				price
			)
		end
	end)

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetPaintBackground(false)

	SVMOD:CreateHorizontalLine(panel, BOTTOM)

	local button = SVMOD:CreateButton(bottomPanel, language.GetPhrase("svmod.fuel.get_pistol"), function()
		net.Start("SV_Settings_GetFuelPumpCreatorPistol")
		net.SendToServer()
		panel:GetParent():Remove()
	end)
	button:Dock(RIGHT)
	button:SetSize(280, 0)
end