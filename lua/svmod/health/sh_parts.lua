hook.Add("SV_LoadVehicle", "SV_LoadVehicle_Parts", function(veh)
	for _, p in ipairs(veh.SV_Data.Parts) do
		if p.Type == "engine" then
			p.GetHealth = function()
				return veh:SV_GetHealth()
			end
			p.SetHealth = function(_, value)
				veh:SV_SetHealth(value)
			end
		elseif p.Type == "wheel_fl" then
			p.WheelID = veh:SV_GetWheelID("wheel_fl")
			p.GetHealth = function()
				return veh:SV_GetWheelFLHealth()
			end
			p.SetHealth = function(_, value)
				veh:SV_SetWheelFLHealth(math.Clamp(value, 0, 100))
			end
		elseif p.Type == "wheel_fr" then
			p.WheelID = veh:SV_GetWheelID("wheel_fr")
			p.GetHealth = function()
				return veh:SV_GetWheelFRHealth()
			end
			p.SetHealth = function(_, value)
				veh:SV_SetWheelFRHealth(math.Clamp(value, 0, 100))
			end
		elseif p.Type == "wheel_rl" then
			p.WheelID = veh:SV_GetWheelID("wheel_rl")
			p.GetHealth = function()
				return veh:SV_GetWheelRLHealth()
			end
			p.SetHealth = function(_, value)
				veh:SV_SetWheelRLHealth(math.Clamp(value, 0, 100))
			end
		elseif p.Type == "wheel_rr" then
			p.WheelID = veh:SV_GetWheelID("wheel_rr")
			p.GetHealth = function()
				return veh:SV_GetWheelRRHealth()
			end
			p.SetHealth = function(_, value)
				veh:SV_SetWheelRRHealth(math.Clamp(value, 0, 100))
			end
		end
	end
end)