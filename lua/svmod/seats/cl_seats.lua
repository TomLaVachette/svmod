hook.Add("PlayerBindPress", "SV_EnterExitVehicle", function(ply, bind, pressed)
	-- Return if the player does not attempt to use something
	if not pressed or bind ~= "+use" then return end

	if ply:InVehicle() then

		-- |
		-- EXIT VEHICLE
		-- |

		-- Return if not a SVMod vehicle
		if not SVMOD:IsVehicle(ply:GetVehicle()) then return end

		-- Check if shortcut is not in cooldown
		if CurTime() >= SVMOD.ShortcutTime then
			net.Start("SV_ExitVehicle")
			net.SendToServer()

			SVMOD.ShortcutTime = CurTime() + SVMOD.FCFG.ShortcutTime
		end

	else

		-- |
		-- ENTER VEHICLE
		-- |

		-- Get the vehicle
		local veh = ply:GetEyeTrace().Entity

		-- Return if not a vehicle
		if not SVMOD:IsVehicle(veh) then
			return -- DO NOT RETURN TRUE HERE!
		end

		-- Return if the vehicle is picked up from the physgun
		if veh.SV_PhysgunPickup then
			return true
		end

		-- Return if too far
		if ply:GetShootPos():DistToSqr(veh:GetPos()) > 30000 then
			return true
		end

		-- Check if shortcut is not in cooldown
		if CurTime() >= SVMOD.ShortcutTime then
			net.Start("SV_EnterVehicle")
			net.SendToServer()

			SVMOD.ShortcutTime = CurTime() + SVMOD.FCFG.ShortcutTime
		end

	end

	-- Prevent the bind
	return true
end)

hook.Add("PlayerBindPress", "SV_SwitchSeat", function(ply, bind, pressed)
	local veh = ply:GetVehicle()
	if not SVMOD:IsVehicle(veh) then
		return
	end

	-- Return if the player does not attempt to switch seat
	if not pressed or not string.match(bind, "slot") then
		return
	end

	local SeatIndex = tonumber(string.Replace(bind, "slot", ""))
	if not isnumber(SeatIndex) then return end

	-- Check if shortcut is not in cooldown
	if CurTime() >= SVMOD.ShortcutTime then
		if veh:SV_IsDriverSeat() and ply:KeyDown(IN_WALK) then
			net.Start("SV_KickSeat")
			net.WriteUInt(SeatIndex, 4) -- max: 15
			net.SendToServer()

			SVMOD.SV_PlayerKickedFromSeat = true
		else
			net.Start("SV_SwitchSeat")
			net.WriteUInt(SeatIndex, 4) -- max: 15
			net.SendToServer()
		end

		SVMOD.ShortcutTime = CurTime() + SVMOD.FCFG.ShortcutTime
	end

	-- Prevent the bind
	return true
end)

function SVMOD:CreateCSSeat(veh)
	local seat = ents.CreateClientProp()
	seat:SetModel("models/nova/jeep_seat.mdl")
	seat:SetParent(veh)
	seat:SetLocalPos(Vector(0, 0, 0))
	seat:SetLocalAngles(Angle(0, 0, 0))
	seat:Spawn()

	return seat
end

hook.Add("PhysgunPickup", "SV_DisableEnterOnPhysgunPickup", function(ply, ent)
	if SVMOD:IsVehicle(ent) then
		ent.SV_PhysgunPickup = true
	end
end)

hook.Add("PhysgunDrop", "SV_DisableEnterOnPhysgunDrop", function(ply, ent)
	if SVMOD:IsVehicle(ent) then
		ent.SV_PhysgunPickup = false
	end
end)