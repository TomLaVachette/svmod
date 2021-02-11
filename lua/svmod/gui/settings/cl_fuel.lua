function SVMOD:GUI_Fuel(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("FUEL"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable fuel consumption on vehicles"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
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
			Name = SVMOD:GetLanguage("Disable"),
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

	local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Fuel consumption multiplier"), function(val)
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

	local title = SVMOD:CreateTitle(panel, SVMOD:GetLanguage("GAS PUMP"))
	title:DockMargin(0, 30, 0, 0)

	-- local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Price"), function(val)
	-- 	net.Start("SV_Settings")
	-- 	net.WriteString("Fuel")
	-- 	net.WriteString("Price")
	-- 	net.WriteUInt(1, 2) -- float
	-- 	net.WriteFloat(val)
	-- 	net.SendToServer()
	-- end)
	-- slide:SetValue(data.FuelPrice)
	-- slide:SetMaxValue(300)
	-- slide:SetUnit("u")

	local pumpList = SVMOD:CreateListView(panel)
	pumpList:AddColumn("ID"):SetWidth(10)
	pumpList:AddColumn("Model")
	pumpList:AddColumn("MapCreationID")
	pumpList:AddColumn("Position")
	pumpList:AddColumn("Angle"):SetWidth(20)
	pumpList:AddColumn("Price"):SetWidth(10)

	pumpList.OnRowRightClick = function(self, lineID, line)
		local menu = DermaMenu()

		menu:AddOption("Set entity", function()
			local ent = LocalPlayer():GetEyeTrace().Entity

			if IsValid(ent) then
				net.Receive("SV_Settings_GetMapCreationID", function()
					local isCompiled = net.ReadBool()

					line:SetColumnText(2, ent:GetModel())

					if isCompiled then
						local mapCreationID = net.ReadUInt(16)

						line:SetColumnText(3, mapCreationID)
						line:SetColumnText(4, "0, 0, 0")
						line:SetColumnText(5, "0, 0, 0")
					else
						local pos = ent:GetPos()
						local ang = ent:GetAngles()
						line:SetColumnText(3, "-1")
						line:SetColumnText(4, math.Round(pos.x) .. ", " .. math.Round(pos.y) .. ", " .. math.Round(pos.z))
						line:SetColumnText(5, math.Round(ang.x) .. ", " .. math.Round(ang.y) .. ", " .. math.Round(ang.z))
					end
				end)

				net.Start("SV_Settings_GetMapCreationID")
				net.WriteEntity(ent)
				net.SendToServer()
			end
		end):SetIcon("icon16/package.png")

		menu:AddOption("Edit price", function()
			local frame = vgui.Create("DFrame")
			frame:SetSize(300, 110)
			frame:Center()
			frame:ShowCloseButton(false)
			frame:SetTitle("")
			frame.Paint = function(self, w, h)
				surface.SetDrawColor(18, 25, 31)
				surface.DrawRect(0, 0, w, h)
		
				surface.SetDrawColor(178, 95, 245)
				surface.DrawRect(0, 0, w, 4)
			end
			frame:MakePopup()

			local slide = SVMOD:CreateNumSlidePanel(frame, SVMOD:GetLanguage("Price"), function(val)
				line:SetColumnText(6, math.Round(val))
			end)
			slide:SetValue(tonumber(line:GetColumnText(6)))
			slide:SetMaxValue(300)
			slide:SetUnit("u")

			local button = SVMOD:CreateButton(frame, SVMOD:GetLanguage("CLOSE"), function()
				frame:Close()
			end)
			button:Dock(BOTTOM)
			button:SetSize(0, 30)
		end):SetIcon("icon16/money.png")

		menu:AddOption("Delete", function()
			self:RemoveLine(lineID)
		end):SetIcon("icon16/cross.png")

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

	pumpList.OnRemove = function(self)
		local count = table.Count(pumpList:GetLines())

		net.Start("SV_Settings_SetFuelPump")

		net.WriteUInt(count, 5) -- max: 31

		for i = 1, count do
			local line = pumpList:GetLine(i)
			local position = string.Split(line:GetColumnText(4), ", ")
			local angle = string.Split(line:GetColumnText(5), ", ")

			net.WriteString(line:GetColumnText(2))
			net.WriteBool(tonumber(line:GetColumnText(3)) >= 0)
			net.WriteUInt(tonumber(line:GetColumnText(3)), 16) -- max: 65535
			net.WriteVector(Vector(position[1], position[2], position[3]))
			net.WriteAngle(Angle(angle[1], angle[2], angle[3]))
			net.WriteUInt(tonumber(line:GetColumnText(6)), 16) -- max: 65535
		end

		net.SendToServer()
	end

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetDrawBackground(false)

	SVMOD:CreateHorizontalLine(panel, BOTTOM)

	local button = SVMOD:CreateButton(bottomPanel, SVMOD:GetLanguage("Add"), function()
		if table.Count(pumpList:GetLines()) < 30 then
			pumpList:AddLine(table.Count(pumpList:GetLines()) + 1, "?", -1, "0, 0, 0", "0, 0, 0", 0)
		end
	end)
	button:Dock(RIGHT)
	button:SetSize(125, 0)
end