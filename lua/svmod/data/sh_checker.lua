-- @class SVMOD
-- @shared

-- Checks the data types of the input.
-- @tparam table data Data to check
-- @treturn string result Error if problem found, nil if no problem found
-- @internal
function SVMOD:Data_Check(x)
	if not x then
		return "DATA"
	end
	local function checkLights(x)
		if not istable(x) then
			return ""
		end

		for i, v in ipairs(x) do
			if v.Sprite then
				if v.ActiveTime and not isnumber(v.ActiveTime) then
					return "Sprite[" .. i .. "].ActiveTime"
				elseif v.Color and (not v.Color.r or not v.Color.g or not v.Color.b or not v.Color.a) then
					return "Sprite[" .. i .. "].Color"
				elseif v.Height and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Height"
				elseif v.HiddenTime and not isnumber(v.HiddenTime) then
					return "Sprite[" .. i .. "].HiddenTime"
				elseif v.Position and not isvector(v.Position) then
					return "Sprite[" .. i .. "].Position"
				elseif v.Width and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Width"
				end
			elseif v.SpriteLine then
				if v.Color and (not v.Color.r or not v.Color.g or not v.Color.b or not v.Color.a) then
					return "Sprite[" .. i .. "].Color"
				elseif v.Width and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Height"
				elseif v.Count and not isnumber(v.Count) then
					return "Sprite[" .. i .. "].Count"
				elseif v.Position1 and not isvector(v.Position1) then
					return "Sprite[" .. i .. "].Position1"
				elseif v.Position2 and not isvector(v.Position2) then
					return "Sprite[" .. i .. "].Position2"
				elseif v.Position3 and not isvector(v.Position3) then
					return "Sprite[" .. i .. "].Position3"
				elseif v.Width and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Width"
				end
			elseif v.ProjectedTexture then
				if v.Angles and not isvector(v.Angles) then
					return "Sprite[" .. i .. "].Angles"
				elseif v.Color and (not v.Color.r or not v.Color.g or not v.Color.b or not v.Color.a) then
					return "Sprite[" .. i .. "].Color"
				elseif v.FOV and not isnumber(v.FOV) then
					return "Sprite[" .. i .. "].FOV"
				elseif v.Position and not isvector(v.Position) then
					return "Sprite[" .. i .. "].Position"
				elseif v.Size and not isnumber(v.Size) then
					return "Sprite[" .. i .. "].Size"
				end
			end
		end

		return nil
	end

	local function checkParts(x)
		if not istable(x) then
			return ""
		end

		for i, v in ipairs(x) do
			if v.Angles and not isangle(v.Angles) then
				return "Sprite[" .. i .. "].Angles"
			elseif v.Health and not isnumber(v.Health) then
				return "Sprite[" .. i .. "].Health"
			elseif v.LastLerp and not isnumber(v.LastLerp) then
				return "Sprite[" .. i .. "].LastLerp"
			elseif v.Position and not isvector(v.Position) then
				return "Sprite[" .. i .. "].Position"
			elseif v.StartLerp and not isnumber(v.StartLerp) then
				return "Sprite[" .. i .. "].StartLerp"
			end
		end

		return nil
	end

	local function checkSeats(x)
		if not istable(x) then
			return false
		end

		for i, v in ipairs(x) do
			if not isangle(v.Angles) then
				return "Sprite[" .. i .. "].Angles"
			elseif not isvector(v.Position) then
				return "Sprite[" .. i .. "].Position"
			end
		end

		return nil
	end

	if not x.Author then
		return "DATA.Author"
	else
		if not isstring(x.Author.Name) then
			return "DATA.Author.Name"
		elseif not isstring(x.Author.SteamID64) then
			return "DATA.Author.SteamID64"
		end
	end

	if not isnumber(x.Timestamp) then
		return "DATA.Timestamp"
	end

	if not x.Back then
		return "DATA.Back"
	else
		local brakeLights = checkLights(x.Back.BrakeLights)
		local reversingLights = checkLights(x.Back.ReversingLights)
		if brakeLights then
			return "DATA.Back.BrakeLights." .. brakeLights
		elseif reversingLights then
			return "DATA.Back.ReversingLights." .. reversingLights
		end
	end

	if not x.Blinkers then
		return "DATA.Blinkers"
	else
		local leftLights = checkLights(x.Blinkers.LeftLights)
		local rightLights = checkLights(x.Blinkers.RightLights)
		if leftLights then
			return "DATA.Blinkers.LeftLights." .. leftLights
		elseif rightLights then
			return "DATA.Blinkers.RightLights." .. rightLights
		end
	end

	if not x.FlashingLights then
		return "DATA.FlashingLights"
	else
		local flashingLights = checkLights(x.FlashingLights)
		if flashingLights then
			return "DATA.FlashingLights." .. flashingLights
		end
	end

	if not x.Fuel then
		return "DATA.Fuel"
	else
		if x.Fuel.Capacity and not isnumber(x.Fuel.Capacity) then
			return "DATA.Fuel.Capacity"
		elseif x.Fuel.Consumption and not isnumber(x.Fuel.Consumption) then
			return "DATA.Fuel.Consumption"
		elseif not istable(x.Fuel.GasTank) then
			return "DATA.Fuel.GasTank"
		end

		for i, v in ipairs(x.Fuel.GasTank) do
			if not istable(v.GasHole) then
				return "DATA.Fuel.GasTank.GasHole"
			elseif v.Position and not isvector(v.GasHole.Position) then
				return "DATA.Fuel.GasTank.GasHole.Position"
			elseif v.Angles and not isangle(v.GasHole.Angles) then
				return "DATA.Fuel.GasTank.GasHole.Angles"
			elseif not istable(v.GasolinePistol) then
				return "DATA.Fuel.GasTank.GasolinePistol"
			elseif v.GasolinePistol.Position and not isvector(v.GasolinePistol.Position) then
				return "DATA.Fuel.GasTank.GasolinePistol.Position"
			elseif v.GasolinePistol.Angles and not isangle(v.GasolinePistol.Angles) then
				return "DATA.Fuel.GasTank.GasolinePistol.Angles"
			end
		end
	end

	if not x.Headlights then
		return "DATA.Headlights"
	else
		local headlights = checkLights(x.Headlights)
		if headlights then
			return "DATA.Headlights." .. headlights
		end
	end

	if not x.Parts then
		return "DATA.Parts"
	else
		local parts = checkParts(x.Parts)
		if parts then
			return "DATA.Parts." .. parts
		end
	end

	if not x.Seats then
		return "DATA.Seats"
	else
		local seats = checkSeats(x.Seats)
		if seats then
			return "DATA.Seats." .. seats
		end
	end

	if not x.Sounds then
		return "DATA.Sounds"
	else
		if x.Sounds.Blinkers and not isstring(x.Sounds.Blinkers) then
			return "DATA.Sounds.Blinkers"
		elseif x.Sounds.Horn and not isstring(x.Sounds.Horn) then
			return "DATA.Sounds.Horn"
		elseif x.Sounds.Reversing and not isstring(x.Sounds.Reversing) then
			return "DATA.Sounds.Reversing"
		elseif x.Sounds.Siren and not isstring(x.Sounds.Siren) then
			return "DATA.Sounds.Siren"
		end
	end

	return nil
end