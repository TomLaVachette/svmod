surface.CreateFont("HudHintTextLarge40", {
	font = "HudHintTextLarge",
	size = 40
})

-- local color_white = color_white

-- local function SV_HUDPaint()
-- 	local Vehicle = LocalPlayer():GetVehicle()
-- 	if not SVMOD:IsVehicle(Vehicle) then return end

-- 	local sW, sH = ScrW(), ScrH()
-- 	local Width, Height = 250, 80

-- 	local Speed = Vehicle:SV_GetCachedSpeed()
-- 	local PercentSpeed = math.min(Speed / 150, 1)

-- 	surface.SetDrawColor(0, 0, 0, 200)
-- 	surface.DrawRect(sW / 2 - Width / 2, sH - Height, Width, Height)

-- 	surface.SetDrawColor(0, 93, 255, 25)
-- 	surface.DrawRect(sW / 2 - Width / 2, sH - Height, Width * PercentSpeed, Height)

-- 	draw.DrawText(Speed .. " km/h", "HudHintTextLarge40", sW / 2, sH - Height * 0.75, color_white, TEXT_ALIGN_CENTER)

-- 	surface.SetDrawColor(0, 93, 255)
-- 	surface.DrawRect(sW / 2 - Width / 2, sH - Height - 2, Width * Vehicle:SV_GetPercentFuel() / 100, 2)
-- end

-- hook.Add("SV_PlayerEnteredVehicle", "SV_EnableHUD", function()
-- 	hook.Add("HUDPaint", "SV_HUDPaint", SV_HUDPaint)
-- end)

-- hook.Add("SV_PlayerLeaveVehicle", "SV_DisableHUD", function()
-- 	hook.Remove("HUDPaint", "SV_HUDPaint")
-- end)