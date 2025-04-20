--- @class Enemy
--- @field image love.Image
--- @field x number
--- @field y number
--- @field speed number
--- @field width number
--- @field height number
local Enemy = {}

function Enemy:new()
	self.image = love.graphics.newImage("assets/PNG/Enemies/enemyBlack1.png")
	self.x = 325
	self.y = 450
	self.speed = 100
	self.width = self.image:getWidth()
    self.height = self.image:getHeight()

	self.__index = self
	return self
end

function Enemy:update(dt)
	self.x = self.x + self.speed * dt
	local window_width = love.graphics.getWidth()

	if self.x < 0 then
		self.x = 0
		self.speed = -self.speed
	elseif self.x + self.width > window_width then
		self.x = window_width - self.width
		self.speed = -self.speed
	end
end

function Enemy:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

return Enemy
