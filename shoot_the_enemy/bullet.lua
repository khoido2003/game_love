--- @class Bullet
--- @field image love.Image
--- @field x number
--- @field y number
--- @field speed number
--- @field width number
--- @field height number
--- @field dead boolean
local Bullet = {}

---@param x number
---@param y number
function Bullet:new(x, y)
	local obj = setmetatable({}, { __index = self })
	obj.image = love.graphics.newImage("assets/PNG/Lasers/laserBlue01.png")
	obj.x = x
	obj.y = y
	obj.speed = 700
	obj.width = obj.image:getWidth()
	obj.height = obj.image:getHeight()
	return obj
end

--- @param dt number
function Bullet:update(dt)
	self.y = self.y + self.speed * dt

	if self.y > love.graphics.getHeight() then
		--Restart the game
		love.load()
	end
end

function Bullet:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

--- @param obj Enemy
function Bullet:checkCollision(obj)
	local self_left = self.x
	local self_right = self.x + self.width
	local self_top = self.y
	local self_bottom = self.y + self.height

	local obj_left = obj.x
	local obj_right = obj.x + obj.width
	local obj_top = obj.y
	local obj_bottom = obj.y + obj.height

	if self_right > obj_left and self_left < obj_right and self_bottom > obj_top and self_top < obj_bottom then
		self.dead = true

		--Increase enemy speed
		if obj.speed > 0 then
			obj.speed = obj.speed + 50
		else
			obj.speed = obj.speed - 50
		end
	end
end

return Bullet
