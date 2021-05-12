function SVMOD:GUI_Others(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.others.hud"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.others.enable_hud"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.IsHUDEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Others")
				net.WriteString("IsHUDEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.IsHUDEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Others")
				net.WriteString("IsHUDEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.others.hud_position_x"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Others")
		net.WriteString("HUDPositionX")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.HUDPositionX * 100)
	slide:SetMinValue(0)
	slide:SetMaxValue(100)
	slide:SetUnit("")

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.others.hud_position_y"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Others")
		net.WriteString("HUDPositionY")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.HUDPositionY * 100)
	slide:SetMinValue(0)
	slide:SetMaxValue(100)
	slide:SetUnit("")

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.others.hud_size"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Others")
		net.WriteString("HUDSize")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.HUDSize)
	slide:SetMinValue(50)
	slide:SetMaxValue(200)
	slide:SetUnit("")

	local colorPanel = vgui.Create("DPanel", panel)
	colorPanel:Dock(TOP)
	colorPanel:DockMargin(0, 4, 0, 4)
	colorPanel:SetSize(0, 68)
	colorPanel:SetPaintBackground(false)

	local label = vgui.Create("DLabel", colorPanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(language.GetPhrase("svmod.others.hud_color"))
	label:SizeToContents()

	local colorMixer = vgui.Create("DColorMixer", colorPanel)
	colorMixer:Dock(RIGHT)
	colorMixer:SetSize(205, 0)
	colorMixer:SetColor(data.HUDColor)
	colorMixer:SetPalette(false)
	colorMixer:SetAlphaBar(false)
	colorMixer.ValueChanged = function(_, colorTable)
		net.Start("SV_Settings")
		net.WriteString("Others")
		net.WriteString("HUDColor")
		net.WriteUInt(3, 2) -- float
		net.WriteColor(Color(colorTable.r, colorTable.g, colorTable.b))
		net.SendToServer()
	end

	local title = SVMOD:CreateTitle(panel, language.GetPhrase("svmod.others.wheels"))
	title:DockMargin(0, 10, 0, 0)

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.others.custom_suspension"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Others")
		net.WriteString("CustomSuspension")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.CustomSuspension)
	slide:SetMinValue(-10)
	slide:SetMaxValue(10)
	slide:SetUnit("")
end