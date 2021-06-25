include("shared.lua")

function SWEP:DrawHUD()
	local xCenter = ScrW() / 2
	local yCenter = ScrH() / 2

	surface.SetDrawColor(18, 25, 31, 200)
	surface.DrawRect(xCenter - 250, yCenter - 50, 500, 100)

	draw.DrawText("LEFT CLICK to ADD a fuel pump", "DermaLarge", xCenter, yCenter - 48, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText("RELOAD to EDIT the price", "DermaLarge", xCenter, yCenter - 16, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	draw.DrawText("RIGHT CLICK to DELETE a fuel pump", "DermaLarge", xCenter, yCenter + 16, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end