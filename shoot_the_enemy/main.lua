local Player = require("player")
local Enemy = require("enemy")

--- @type Player
local player

--- @type Enemy
local enemy

--- @type Bullet[]
local listOfBullet

function love.load()
	player = Player:new(300, 20, 500)
	enemy = Enemy:new()
	listOfBullet = {}
end

function love.update(dt)
	player:update(dt)
	enemy:update(dt)
	for index, value in ipairs(listOfBullet) do
		value:update(dt)
		value:checkCollision(enemy)

		if value.dead then
			--Remove it from the list
			table.remove(listOfBullet, index)
		end
	end
end

function love.draw()
	player:draw()
	enemy:draw()
	for index, value in ipairs(listOfBullet) do
		value:draw()
	end
end

--- @param key love.KeyConstant
function love.keypressed(key)
	player:keyPressed(key, listOfBullet)
end
