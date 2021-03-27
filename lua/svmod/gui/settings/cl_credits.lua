function SVMOD:GUI_Credits(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.credits"))

	local function addLabel(authors, text)
		local creditPanel = vgui.Create("DPanel", panel)
		creditPanel:Dock(TOP)
		creditPanel:DockMargin(0, 4, 0, 4)
		creditPanel:SetSize(0, 30)
		creditPanel:SetPaintBackground(false)

		for i, author in ipairs(authors) do
			local authorPanel = vgui.Create("DPanel", creditPanel)
			authorPanel:Dock(LEFT)
			authorPanel:SetPaintBackground(false)

			local name = author.Name
			if i > 1 then
				name = ", " .. author.Name
			end

			local leftLabel = vgui.Create("DLabel", authorPanel)
			leftLabel:SetPos(2, 4)
			leftLabel:SetFont("SV_Calibri18")
			leftLabel:SetText(name)
			leftLabel:SizeToContents()

			surface.SetFont("SV_Calibri18")
			local width = surface.GetTextSize(name)

			if author.SteamID64 then
				local steamButton = vgui.Create("DImageButton", authorPanel)
				steamButton:SetPos(2 + width + 5, 5)
				if author.IsFemale then
					steamButton:SetMaterial("materials/icon16/user_female.png")
				else
					steamButton:SetMaterial("materials/icon16/user.png")
				end
				steamButton:SetSize(16, 16)
				steamButton.DoClick = function()
					gui.OpenURL("http://steamcommunity.com/profiles/" .. author.SteamID64)
				end

				authorPanel:SetSize(width + 16 + 5, 0)
			else
				authorPanel:SetSize(width + 5, 0)
			end
		end

		surface.SetFont("SV_Calibri18")
		local width = surface.GetTextSize(text)

		local rightLabel = vgui.Create("DLabel", creditPanel)
		rightLabel:SetPos(2, 4)
		rightLabel:SetFont("SV_Calibri18")
		rightLabel:SetText(text)
		rightLabel:SizeToContents()

		timer.Simple(FrameTime(), function()
			rightLabel:SetPos(creditPanel:GetSize() - width - 5, 4)
		end)
	end

	addLabel({
		{
			Name = "TomLaVachette",
			SteamID64 = "76561198061601582",
			IsFemale = false,
		}
	}, "Lua Developer")

	addLabel({
		{
			Name = "wow",
			SteamID64 = "76561198084178846",
			IsFemale = false,
		}
	}, "Web Developer")

	addLabel({
		{
			Name = "Hertinox",
			SteamID64 = "76561198250792770",
			IsFemale = false,
		}
	}, "Vehicle Editor Tester")

	addLabel({
		{
			Name = "Nelna",
			SteamID64 = "76561198195818413",
			IsFemale = true,
		}
	}, "Vehicle Editor Tester")

	addLabel({
		{
			Name = "Kaesar",
			SteamID64 = "76561197995988196",
			IsFemale = false,
		}
	}, "Gasoline pistol modeller")

	addLabel({
		{
			Name = "jycxed",
			SteamID64 = "76561198119106746",
			IsFemale = false,
		}
	}, "UI Helper")

	addLabel({
		{
			Name = "SmOkEwOw",
			SteamID64 = "76561198080832770",
			IsFemale = false,
		},
		{
			Name = "Azzen",
			SteamID64 = "76561198065129936",
			IsFemale = false,
		}
	}, "Documentation tool (gdocs)")
end