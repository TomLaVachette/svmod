-- @class SVMOD
-- @clientside

local spriteMaterial = Material("sprites/light_ignorez")

local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)

local drawColor = Color(255, 255, 255, 255)

local mathCos = math.cos
local mathSin = math.sin
local mathMax = math.max
local utilPixelVisible = util.PixelVisible
local renderDrawSprite = render.DrawSprite

local PROJECTED_TEXTURE_MAX_DIST_SQR = 2000 * 2000

local spriteLinePoints = setmetatable({}, {__mode = "k"})
local spriteCirclePos = setmetatable({}, {__mode = "k"})

local function rotateAroundAxis(ang1, ang2)
	ang1:RotateAroundAxis(ang1:Forward(), ang2.p)
	ang1:RotateAroundAxis(ang1:Right(), ang2.r)
	ang1:RotateAroundAxis(ang1:Up(), ang2.y)

	return ang1
end

local function getSpriteLinePoints(spriteLine, editMode)
	local points = spriteLinePoints[spriteLine]
	if points and not editMode then
		return points
	end

	local A = spriteLine.Position1
	local B = spriteLine.Position2
	local C = spriteLine.Position3 or B
	local count = mathMax(spriteLine.Count or 1, 1)

	points = {}
	for i = 0, count do
		local t = i / count
		local u = 1 - t
		local a, b, c = u * u, 2 * u * t, t * t

		points[i + 1] = Vector(
			a * A.x + b * B.x + c * C.x,
			a * A.y + b * B.y + c * C.y,
			a * A.z + b * B.z + c * C.z
		)
	end

	spriteLinePoints[spriteLine] = points

	return points
end

local vehicleList = {}
local renderList = {}

hook.Add("SV_Enabled", "SV_InitRenderVehicle", function()
	vehicleList = {}
	renderList = {}

	hook.Add("PostDrawTranslucentRenderables", "SV_PostDrawVehicle", function(bDrawingDepth, bDrawingSkybox)
		if bDrawingDepth or bDrawingSkybox then return end

		SVMOD:Render()
	end)

	timer.Create("SV_Render", 2, 0, function()
		local Position = LocalPlayer():GetPos()

		renderList = {}

		for _, v in ipairs(vehicleList) do
			if IsValid(v) then
				if v:WaterLevel() < 3 and v:GetPos():DistToSqr(Position) < 30000000 then
					table.insert(renderList, v)
					if not v.SV_IsRendered then
						v:SV_StartAlphaTimer()
						v.SV_IsRendered = true
					end
				elseif v.SV_IsRendered then
					v:SV_ClearProjectedTexture()
					v:SV_StopAlphaTimer()
					v.SV_IsRendered = false
				end
			end
		end
	end)
end)

hook.Add("SV_Disabled", "SV_DestroyRenderVehicle", function()
	hook.Remove("PostDrawTranslucentRenderables", "SV_PostDrawVehicle")

	timer.Remove("SV_Render")
end)

hook.Add("SV_LoadVehicle", "SV_AddDrawHook", function(veh)
	table.insert(vehicleList, veh)
end)

hook.Add("SV_UnloadVehicle", "SV_RemoveDrawHook", function(veh)
	table.RemoveByValue(vehicleList, veh)

	if veh.SV_IsRendered then
		veh:SV_ClearProjectedTexture()
		veh:SV_StopAlphaTimer()
		veh.SV_IsRendered = nil
	end
end)

function SVMOD:Render()
	local eyePos = EyePos()
	local curTime = CurTime()

	render.SetMaterial(spriteMaterial)

	for _, veh in ipairs(renderList) do
		if IsValid(veh) then
			local states = veh.SV_States
			local data = veh.SV_Data

			local pos = veh:GetPos()
			local ang = veh:GetAngles()
			local distSqr = pos:DistToSqr(eyePos)
			local moved = veh.SV_PTLastPos ~= pos or veh.SV_PTLastAng ~= ang

			if states.Headlights then
				self:RenderLights(veh, data.Headlights, distSqr, moved)
			end

			local HazardLightsState = states.HazardLights
			local LeftBlinkerLightsState = states.LeftBlinkers
			local RightBlinkerLightsState = states.RightBlinkers
			if HazardLightsState or LeftBlinkerLightsState or RightBlinkerLightsState then
				if not veh.SV_BlinkersTimer or curTime >= veh.SV_BlinkersTimer then
					if not veh.SV_BlinkersDrawn then
						veh.SV_BlinkersDrawn = true
						veh:EmitSound("svmod/blinker/" .. (data.Sounds.Blinkers or "normal") .. "_turn_on.wav")
					else
						veh.SV_BlinkersDrawn = false
						veh:EmitSound("svmod/blinker/" .. (data.Sounds.Blinkers or "normal") .. "_turn_off.wav")
					end
					veh.SV_BlinkersTimer = curTime + 0.5
				end

				if veh.SV_BlinkersDrawn then
					if HazardLightsState or LeftBlinkerLightsState then
						self:RenderLights(veh, data.Blinkers.LeftLights, distSqr, moved)
					end

					if HazardLightsState or RightBlinkerLightsState then
						self:RenderLights(veh, data.Blinkers.RightLights, distSqr, moved)
					end
				end
			end

			if states.BackLights then
				if not veh.SV_IsReversing then
					self:RenderLights(veh, data.Back.BrakeLights, distSqr, moved)
				else
					-- TODO: Reversing sound
					self:RenderLights(veh, data.Back.ReversingLights, distSqr, moved)
				end
			end

			if states.FlashingLights then
				self:RenderLights(veh, data.FlashingLights, distSqr, moved)
			end

			if moved then
				veh.SV_PTLastPos = pos
				veh.SV_PTLastAng = ang
			end
		end
	end
end

function SVMOD:RenderLights(veh, lights, distSqr, moved)
	local editMode = veh.SV_IsEditMode
	local frameTime = FrameTime()

	for _, v in ipairs(lights) do
		local sprite = v.Sprite
		if sprite and sprite.Color.a ~= 0 then
			sprite.Handler = veh:SV_DrawSprite(
				spriteMaterial,
				sprite.Position,
				sprite.Width,
				sprite.Height,
				sprite.Color,
				sprite.Handler
			)
		end

		local spriteLine = v.SpriteLine
		if spriteLine and spriteLine.Color.a ~= 0 then
			local points = getSpriteLinePoints(spriteLine, editMode)
			local handlers = spriteLine.Handler
			if not handlers then
				handlers = {}
				spriteLine.Handler = handlers
			end

			for i = 1, #points do
				handlers[i] = veh:SV_DrawSprite(
					spriteMaterial,
					points[i],
					spriteLine.Width,
					spriteLine.Height,
					spriteLine.Color,
					handlers[i]
				)
			end
		end

		local spriteCircle = v.SpriteCircle
		if spriteCircle then
			local angle = ((spriteCircle.CurrentAngle or 0) % 360) + spriteCircle.Speed * frameTime * 60
			spriteCircle.CurrentAngle = angle

			if spriteCircle.Color.a ~= 0 then
				local pos = spriteCirclePos[spriteCircle]
				if not pos then
					pos = Vector()
					spriteCirclePos[spriteCircle] = pos
				end

				local center = spriteCircle.Position
				local radius = spriteCircle.Radius / 5
				pos:SetUnpacked(
					center.x + mathCos(angle) * radius,
					center.y + mathSin(angle) * radius,
					center.z
				)

				spriteCircle.Handler = veh:SV_DrawSprite(
					spriteMaterial,
					pos,
					spriteCircle.Width,
					spriteCircle.Height,
					spriteCircle.Color,
					spriteCircle.Handler
				)
			end
		end

		local projectedTexture = v.ProjectedTexture
		if projectedTexture then
			local entity = projectedTexture.Entity

			if distSqr > PROJECTED_TEXTURE_MAX_DIST_SQR then
				if entity then
					entity:Remove()
					projectedTexture.Entity = nil
				end
			else
				if not entity and SVMOD.CFG.Lights.DrawProjectedLights then
					projectedTexture.Entity = veh:SV_CreateProjectedTexture(
						projectedTexture.Position,
						projectedTexture.Angles,
						projectedTexture.Color,
						projectedTexture.Size,
						projectedTexture.FOV
					)
				elseif entity and (moved or editMode) then
					entity:SetAngles(rotateAroundAxis(veh:GetAngles(), projectedTexture.Angles or angZero))
					entity:SetPos(veh:LocalToWorld(projectedTexture.Position or vecZero))
					entity:Update()
				end
			end
		end
	end
end

-- @class SV_Vehicle

-- Draw a sprite on a vehicle.
-- @tparam Material material Material
-- @tparam Vector position World coordinates
-- @tparam number width Width
-- @tparam number height Height
-- @tparam Color color Color
-- @tparam "pixelvis handle t" handler PixVis handle
-- @internal
function SVMOD.Metatable:SV_DrawSprite(material, position, width, height, color, handler)
	if not handler then
		handler = util.GetPixelVisibleHandle()
	end

	local Position = self:LocalToWorld(position or vecZero)

	drawColor.r = color.r or 255
	drawColor.g = color.g or 255
	drawColor.b = color.b or 255
	drawColor.a = utilPixelVisible(Position, 1, handler) * color.a

	renderDrawSprite(
		Position,
		width or 20,
		height or 20,
		drawColor
	)

	return handler
end

-- Creates a projected texture.
-- @tparam Vector position World coordinates
-- @tparam Angle angle Angle
-- @tparam Color color Color
-- @tparam number size Size
-- @tparam number fov Field of view
-- @internal
function SVMOD.Metatable:SV_CreateProjectedTexture(position, angle, color, size, fov)
	local PTexture = ProjectedTexture()

	PTexture:SetAngles(rotateAroundAxis(self:GetAngles(), angle or angZero))
	PTexture:SetPos(self:LocalToWorld(position or vecZero))

	PTexture:Update()

	PTexture:SetEnableShadows(SVMOD.CFG.Lights.DrawShadows)
	PTexture:SetColor(color)
	PTexture:SetFarZ(size or 600)
	PTexture:SetFOV(fov or 110)
	PTexture:SetNearZ(32) -- lower than this value decreases framerate!
	PTexture:SetTexture("effects/flashlight001")

	PTexture:Update()

	return PTexture
end

-- Cleans the projected textures related to the vehicle.
-- @internal
function SVMOD.Metatable:SV_ClearProjectedTexture()
	local function ClearProjectedTexture(tab)
		for _, l in ipairs(tab) do
			if l.ProjectedTexture and l.ProjectedTexture.Entity then
				l.ProjectedTexture.Entity:Remove()
				l.ProjectedTexture.Entity = nil
			end
		end
	end

	ClearProjectedTexture(self.SV_Data.Headlights)
	ClearProjectedTexture(self.SV_Data.Back.BrakeLights)
	ClearProjectedTexture(self.SV_Data.Back.ReversingLights)
	ClearProjectedTexture(self.SV_Data.Blinkers.LeftLights)
	ClearProjectedTexture(self.SV_Data.Blinkers.RightLights)
end

-- Starts all alpha timer for transitions.
-- @internal
function SVMOD.Metatable:SV_StartAlphaTimer()
	local hiddenTime

	local function activeTime(timerName, sprite)
		sprite.Color.a = 255

		timer.Create(timerName, sprite.ActiveTime, 1, function()
			hiddenTime(timerName, sprite)
		end)
	end

	function hiddenTime(timerName, sprite)
		sprite.Color.a = 0

		timer.Create(timerName, sprite.HiddenTime, 1, function()
			activeTime(timerName, sprite)
		end)
	end

	for i, v in ipairs(self.SV_Data.FlashingLights) do
		if v.Sprite and v.Sprite.ActiveTime and v.Sprite.ActiveTime ~= 0 then
			local firstTimer = v.Sprite.ActiveTime + (v.Sprite.OffsetTime or 0)

			timer.Create("SV_LightAlpha_" .. self:EntIndex() .. "_Sprite_" .. i, firstTimer, 1, function()
				activeTime("SV_LightAlpha_" .. self:EntIndex() .. "_Sprite_" .. i, v.Sprite)
			end)
		end

		if v.SpriteCircle and v.SpriteCircle.ActiveTime and v.SpriteCircle.ActiveTime ~= 0 then
			local firstTimer = v.SpriteCircle.ActiveTime + (v.SpriteCircle.OffsetTime or 0)

			timer.Create("SV_LightAlpha_" .. self:EntIndex() .. "_SpriteCircle_" .. i, firstTimer, 1, function()
				activeTime("SV_LightAlpha_" .. self:EntIndex() .. "_SpriteCircle_" .. i, v.SpriteCircle)
			end)
		end
	end
end

-- Stops all alpha timer for transitions.
-- @internal
function SVMOD.Metatable:SV_StopAlphaTimer()
	for _, l in ipairs(self.SV_Data.FlashingLights) do
		for i, v in ipairs(l) do
			if v.Sprite and v.Sprite.ActiveTime ~= 0 then
				timer.Remove("SV_LightAlpha_" .. self:EntIndex() .. "_Sprite_" .. i)
			end

			if v.SpriteCircle and v.SpriteCircle.ActiveTime ~= 0 then
				timer.Remove("SV_LightAlpha_" .. self:EntIndex() .. "_SpriteCircle_" .. i, 1)
			end
		end
	end
end
