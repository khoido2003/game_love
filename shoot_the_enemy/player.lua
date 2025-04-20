local Bullet = require("bullet")

--- @class Player
--- @field x number X-coordinate of the player
--- @field y number Y-coordinate of the player
--- @field speed number Movement speed of the player
--- @field width number Width of the player sprite
--- @field height number Height of the player sprite
--- @field image love.Image The player's sprite image
local Player = {}

Player.image = love.graphics.newImage("assets/PNG/ufoGreen.png")

function Player:new(x, y, speed)
	local obj = {
		x = x or 300, -- Default to 300 if x is not provided
		y = y or 20, -- Default to 20 if y is not provided
		speed = speed or 500,
		width = Player.image:getWidth(),
		height = Player.image:getHeight(), -- Added for completeness
	}

	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Player:update(dt)
	if love.keyboard.isDown("left") then
		self.x = self.x - self.speed * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + self.speed * dt
	end

	local window_width = love.graphics.getWidth()

	if self.x + self.width > window_width then
		self.x = window_width - self.width
	elseif self.x < 0 then
		self.x = 0
	end
end

function Player:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

---@param key love.KeyConstant
---@param listOfBullets Bullet[]
function Player:keyPressed(key, listOfBullets)
	if key == "space" then
		table.insert(listOfBullets, Bullet:new(self.x, self.y))
	end
end

return Player
