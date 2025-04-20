-- local test = require("example")
--
-- --- @type number
-- local x
-- local y
--
-- --- @type number
-- local last_dt
--
-- --- @type boolean
-- local move
--
-- --- @type table
-- local fruits = {}
--
-- --- @type table
-- local rect = {}
--
-- local Object = require("classic")
-- local Rectangle = require("rectangle")
-- local r1
-- local r2
--
-- local myImage = love.graphics.newImage("b-fly.png")
-- local width = myImage:getWidth()
-- local height = myImage:getHeight()
--
-- function love.load()
-- 	x = 100
-- 	y = 50
-- 	fruits = { "apple", "banana" }
-- 	rect["width"] = 70
-- 	rect.height = 90
-- 	r1 = Rectangle(100, 100, 200, 50)
-- 	r2 = Rectangle(350, 80, 25, 140)
-- end
--
-- --- @param dt number
-- function love.update(dt)
-- 	last_dt = dt
--
-- 	r1:update(dt)
-- 	r2:update(dt)
--
-- 	-- if love.keyboard.isDown("right") then
-- 	-- 	x = x + 100 * dt
-- 	-- elseif love.keyboard.isDown("left") then
-- 	-- 	x = x - 100 * dt
-- 	-- elseif love.keyboard.isDown("down") then
-- 	-- 	y = y + 100 * dt
-- 	-- elseif love.keyboard.isDown("up") then
-- 	-- 	y = y - 100 * dt
-- 	-- end
-- end
--
-- function love.draw()
-- 	r1:draw()
-- 	r2:draw()
-- 	love.graphics.draw(myImage, 100, 100, 0, 2, 2, width / 30, height / 30)
--
-- 	-- love.graphics.rectangle("line", x, y, rect["width"], rect.height)
-- 	-- love.graphics.print("dt: " .. (last_dt or 0), 10, 10)
-- 	--
-- 	-- for i = 1, #fruits do
-- 	-- 	love.graphics.print(fruits[i], 100, 100)
-- 	-- end
-- end

------------------------------------------------------------------

function love.load()
	--Create 2 rectangles
	r1 = {
		x = 10,
		y = 100,
		width = 100,
		height = 100,
	}

	r2 = {
		x = 250,
		y = 120,
		width = 150,
		height = 120,
	}
end

function love.update(dt)
	--Make one of rectangle move
	r1.x = r1.x + 100 * dt
end

function love.draw()
	love.graphics.rectangle("line", r1.x, r1.y, r1.width, r1.height)
	love.graphics.rectangle("line", r2.x, r2.y, r2.width, r2.height)
end

function checkCollison(a, b)
	local a_left = a.x
	local a_right = a.x + a.width
	local a_top = a.y
	local a_bottom = a.y + a.height

	local b_left = b.x
	local b_right = b.x + b.width
	local b_top = b.y
	local b_bottom = b.y + b.height

return  a_right > b_left
        and a_left < b_right
        and a_bottom > b_top
        and a_top < b_bottom
end
