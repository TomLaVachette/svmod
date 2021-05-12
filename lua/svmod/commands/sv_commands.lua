concommand.Add("sv_givewrench", function(ply)
	CAMI.PlayerHasAccess(ply, "SV_UseCommands", function(hasAccess)
		if hasAccess then
			ply:Give("sv_wrench")
		end
	end)
end)

concommand.Add("sv_lock", function(ply)
	CAMI.PlayerHasAccess(ply, "SV_UseCommands", function(hasAccess)
		if hasAccess then
			local veh = ply:GetEyeTrace().Entity
			if not SVMOD:IsVehicle(veh) then
				return
			end

			veh:SV_Lock()
		end
	end)
end)

concommand.Add("sv_unlock", function(ply)
	CAMI.PlayerHasAccess(ply, "SV_UseCommands", function(hasAccess)
		if hasAccess then
			local veh = ply:GetEyeTrace().Entity
			if not SVMOD:IsVehicle(veh) then
				return
			end

			veh:SV_Unlock()
		end
	end)
end)