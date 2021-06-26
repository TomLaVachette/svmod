include("shared.lua")

function SWEP:DrawHUD()
	local xCenter = ScrW() / 2
	local yCenter = ScrH() / 2

	surface.SetDrawColor(18, 25, 31, 200)
	surface.DrawRect(xCenter - 270, yCenter - 50, 540, 100)

	draw.DrawText(language.GetPhrase("svmod.creator_pistol.create"), "DermaLarge", xCenter, yCenter - 48, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText(language.GetPhrase("svmod.creator_pistol.edit"), "DermaLarge", xCenter, yCenter - 16, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText(language.GetPhrase("svmod.creator_pistol.remove"), "DermaLarge", xCenter, yCenter + 16, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end