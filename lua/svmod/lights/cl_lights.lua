-- @class SVMOD
-- @clientside

local spriteMaterial = Material("sprites/light_ignorez")

local function rotateAroundAxis(ang1, ang2)
	ang1:RotateAroundAxis(ang1:Forward(), ang2.p)
	ang1:RotateAroundAxis(ang1:Right(), ang2.r)
	ang1:RotateAroundAxis(ang1:Up(), ang2.y)

	return ang1
end

local vehicleList = {}
local renderList = {}

hook.Add("SV_Enabled", "SV_InitRenderVehicle", function()
	vehicleList = {}
	renderList = {}

	hook.Add("PostDrawTranslucentRenderables", "SV_PostDrawVehicle", function()
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
	for _, veh in ipairs(renderList) do
		if not IsValid(veh) then return end

		if veh.SV_States.Headlights then
			self:RenderLights(veh, veh.SV_Data.Headlights)
		end

		local HazardLightsState = veh:SV_GetHazardLightsState()
		local LeftBlinkerLightsState = veh:SV_GetLeftBlinkerState()
		local RightBlinkerLightsState = veh:SV_GetRightBlinkerState()
		if HazardLightsState or LeftBlinkerLightsState or RightBlinkerLightsState then
			if not veh.SV_BlinkersTimer or CurTime() >= veh.SV_BlinkersTimer then
				if not veh.SV_BlinkersDrawn then
					veh.SV_BlinkersDrawn = true
					veh:EmitSound("svmod/blinker/" .. (veh.SV_Data.Sounds.Blinkers or "normal") .. "_turn_on.wav")
				else
					veh.SV_BlinkersDrawn = false
					veh:EmitSound("svmod/blinker/" .. (veh.SV_Data.Sounds.Blinkers or "normal") .. "_turn_off.wav")
				end
				veh.SV_BlinkersTimer = CurTime() + 0.5
			end

			if veh.SV_BlinkersDrawn then
				if HazardLightsState or LeftBlinkerLightsState then
					self:RenderLights(veh, veh.SV_Data.Blinkers.LeftLights)
				end

				if HazardLightsState or RightBlinkerLightsState then
					self:RenderLights(veh, veh.SV_Data.Blinkers.RightLights)
				end
			end
		end

		if veh.SV_States.BackLights then
			if not veh.SV_IsReversing then
				self:RenderLights(veh, veh.SV_Data.Back.BrakeLights)
			else
				-- TODO: Reversing sound
				self:RenderLights(veh, veh.SV_Data.Back.ReversingLights)
			end
		end

		if veh.SV_States.FlashingLights then
			self:RenderLights(veh, veh.SV_Data.FlashingLights)
		end
	end
end

local mathCos = math.cos
local mathSin = math.sin

function SVMOD:RenderLights(veh, lights)
	for _, v in ipairs(lights) do
		if v.Sprite then
			local sprite = v.Sprite
			sprite.Handler = veh:SV_DrawSprite(
				spriteMaterial,
				sprite.Position,
				sprite.Width,
				sprite.Height,
				sprite.Color,
				sprite.Handler
			)
		end

		if v.SpriteLine then
			local spriteLine = v.SpriteLine

			local A = spriteLine.Position1
			local B = spriteLine.Position2
			local C = spriteLine.Position3 or spriteLine.Position2

			for i = 0, spriteLine.Count do
				if not spriteLine.Handler then
					spriteLine.Handler = {}
				end

				local t = i * 1 / spriteLine.Count

				spriteLine.Handler[i] = veh:SV_DrawSprite(
					spriteMaterial,
					Vector(
						(1 - t)^2 * A.x + 2 * (1 - t) * t * B.x + t^2 * C.x,
						(1 - t)^2 * A.y + 2 * (1 - t) * t * B.y + t^2 * C.y,
						(1 - t)^2 * A.z + 2 * (1 - t) * t * B.z + t^2 * C.z
						-- A.x + (Vect.x / spriteLine.Count) * i,
						-- A.y + (Vect.y / spriteLine.Count) * i,
						-- A.z + (Vect.z / spriteLine.Count) * i
					),
					spriteLine.Width,
					spriteLine.Height,
					spriteLine.Color,
					spriteLine.Handler[i]
				)
			end
		end

		if v.SpriteCircle then
			local spriteCircle = v.SpriteCircle

			spriteCircle.CurrentAngle = ((spriteCircle.CurrentAngle or 0) % 360) + (spriteCircle.Speed / (1 / FrameTime()) * 60)

			local pos = Vector(
				spriteCircle.Position.x + mathCos(spriteCircle.CurrentAngle) * (spriteCircle.Radius / 5),
				spriteCircle.Position.y + mathSin(spriteCircle.CurrentAngle) * (spriteCircle.Radius / 5),
				spriteCircle.Position.z
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

		if v.ProjectedTexture then
			if SVMOD.CFG.Lights.DrawProjectedLights and not v.ProjectedTexture.Entity then
				v.ProjectedTexture.Entity = veh:SV_CreateProjectedTexture(
					v.ProjectedTexture.Position,
					v.ProjectedTexture.Angles,
					v.ProjectedTexture.Color,
					v.ProjectedTexture.Size,
					v.ProjectedTexture.FOV
				)
			end

			if v.ProjectedTexture.Entity then
				v.ProjectedTexture.Entity:SetAngles(rotateAroundAxis(veh:GetAngles(), v.ProjectedTexture.Angles or Angle(0, 0, 0)))
				v.ProjectedTexture.Entity:SetPos(veh:LocalToWorld(v.ProjectedTexture.Position or Vector(0, 0, 0)))
				v.ProjectedTexture.Entity:Update()
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

	local Position = self:LocalToWorld(position or Vector(0, 0, 0))

	local c = Color(
		color.r or 255,
		color.g or 255,
		color.b or 255,
		util.PixelVisible(Position, 1, handler) * color.a
	)

	render.SetMaterial(material)
	render.DrawSprite(
		Position,
		width or 20,
		height or 20,
		c
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

	PTexture:SetAngles(rotateAroundAxis(self:GetAngles(), angle or Angle(0, 0, 0)))
	PTexture:SetPos(self:LocalToWorld(position or Vector(0, 0, 0)))

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