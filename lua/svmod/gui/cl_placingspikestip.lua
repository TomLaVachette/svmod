net.Receive("SV_PlacingSpikeStrip", function()
    local delay = net.ReadUInt(5) -- max: 31
    local endtime = CurTime() + delay

    local width, height = 400, 40
    local border = 8
    local x = ScrW() / 2 - width / 2
    local y = ScrH() / 2 - height / 2
    hook.Add("HUDPaint", "SV_PlacingSpikeStrip", function()
		surface.SetDrawColor(18, 25, 31)
        surface.DrawRect(x, y, width, height)

		surface.SetDrawColor(178, 95, 245)
        surface.DrawRect(x + border / 2, y + border / 2, (width - border) * (1 - ((endtime - CurTime()) / delay)), height - border)

        draw.DrawText(tostring(math.floor(endtime - CurTime() + 1)), "SVModFont", x + width / 2, y + 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    end)

    timer.Simple(delay, function()
        hook.Remove("HUDPaint", "SV_PlacingSpikeStrip")
    end)
end)