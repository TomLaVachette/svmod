net.Receive("SV_WelcomeGUI", function()
	local frame = SVMOD:CreateFrame("WELCOME")
	frame:MakePopup()

	local leftPanel = frame:GetLeftPanel()
	leftPanel:SetSize(250, 0)

	local centerPanel = frame:GetCenterPanel()

	local function createLabel(text)
		local label = vgui.Create("DLabel", centerPanel)
		label:Dock(TOP)
		label:SetFont("SV_Calibri18")
		label:SetText(text)
		label:SetAutoStretchVertical(true)
		label:SetWrap(true)

		return label
	end

	SVMOD:CreateTitle(centerPanel, language.GetPhrase("svmod.welcome.thank_you_title"))

	createLabel(language.GetPhrase("svmod.welcome.thank_you_description"))

	local title = SVMOD:CreateTitle(centerPanel, language.GetPhrase("svmod.welcome.where_start_title"))
	title:DockMargin(0, 30, 0, 0)

	createLabel(language.GetPhrase("svmod.welcome.where_start_description"))

	local title = SVMOD:CreateTitle(centerPanel, language.GetPhrase("svmod.welcome.where_contributors_title"))
	title:DockMargin(0, 30, 0, 0)

	createLabel(language.GetPhrase("svmod.welcome.where_contributors_description"))

	local title = SVMOD:CreateTitle(centerPanel, language.GetPhrase("svmod.welcome.message_title"))
	title:DockMargin(0, 30, 0, 0)

	createLabel(language.GetPhrase("svmod.welcome.message_description"))


	local icon = vgui.Create("DImage", leftPanel)
	icon:SetImage("materials/vgui/svmod/icon.png")
	icon:SetSize(613 / 2.5, 567 / 2.5)
	icon:SetPos(0, 100)

	frame:CreateMenuButton(language.GetPhrase("svmod.close"), BOTTOM, function()
		frame:Remove()
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.welcome.discord"), BOTTOM, function()
		gui.OpenURL("https://discord.svmod.com/")
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.welcome.contributor"), BOTTOM, function()
		gui.OpenURL("https://svmod.com/pricing.php")
	end)
end)