---@class Card
---@field suit string
---@field rank integer

--- @type Card[]
local deck = {}

--- @type Card[]
local playerHand = {}

--- @type Card[]
local dealerHand = {}

--- @type boolean
local roundOver = false

--- @type table<string|integer, love.Image>
local images = {}
local buttonY = 230
local buttonHeight = 25
local textOffsetY = 6
local buttonHit = {
	x = 10,
	y = buttonY,
	width = 53,
	height = buttonHeight,
	text = "Hit!",
	textOffsetX = 16,
	textOffsetY = textOffsetY,
}

local buttonStand = {
	x = 70,
	y = buttonY,
	width = 53,
	height = buttonHeight,
	text = "Stand",
	textOffsetX = 8,
	textOffsetY = textOffsetY,
}

local buttonPlayAgain = {
	x = 10,
	y = buttonY,
	width = 113,
	height = buttonHeight,
	text = "Play again",
	textOffsetX = 24,
	textOffsetY = textOffsetY,
}
-----------------------------------------------------------

-- Uitilities function

--- @param hand Card[]
local function takeCard(hand)
	if #deck == 0 then
		print("Deck is empty! Can't draw more cards.")
		return
	end
	table.insert(hand, table.remove(deck, love.math.random(#deck)))
end

local function reset()
	deck = {}
	for suitIndex, suit in ipairs({ "club", "diamond", "heart", "spade" }) do
		for rank = 1, 13 do
			table.insert(deck, { suit = suit, rank = rank })
		end
	end

	playerHand = {}
	takeCard(playerHand)
	takeCard(playerHand)

	dealerHand = {}
	takeCard(dealerHand)
	takeCard(dealerHand)

	roundOver = false
end

--- @param hand Card[]
local function getTotal(hand)
	local total = 0
	local hasAce = false

	for cardIndex, card in ipairs(hand) do
		if card.rank > 10 then
			total = total + 10
		else
			total = total + card.rank
		end

		if card.rank == 1 then
			hasAce = true
		end

		if hasAce and total <= 11 then
			total = total + 10
		end
	end

	return total
end

---comment
---@param thisHand Card[]
---@param otherHand Card[]
---@return boolean
local function hasHandWon(thisHand, otherHand)
	return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
end

---comment
---@param card Card
---@param x number
---@param y number
local function drawCard(card, x, y)
	local cardWidth = 53
	local cardHeight = 73
	local numberOffsetX = 3
	local numberOffsetY = 4

	local suitOffsetX = 3
	local suitOffsetY = 17
	local suitImage = images["mini_" .. card.suit]

	love.graphics.setColor(1, 1, 1)
	-- Draw card layout
	love.graphics.draw(images.card, x, y)

	-- Color the card based on the suit
	if card.suit == "heart" or card.suit == "diamond" then
		love.graphics.setColor(0.89, 0.06, 0.39)
	else
		love.graphics.setColor(0.2, 0.2, 0.2)
	end

	-- Draw top rank
	love.graphics.draw(images[card.rank], x + numberOffsetX, y + numberOffsetY)

	-- Draw bottom rank
	love.graphics.draw(images[card.rank], x + cardWidth - numberOffsetX, y + cardHeight - numberOffsetY, 0, -1)
	if card.rank > 10 then
		local faceImage

		if card.rank == 11 then
			faceImage = images.face_jack
		elseif card.rank == 12 then
			faceImage = images.face_queen
		elseif card.rank == 13 then
			faceImage = images.face_king
		end

		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(faceImage, x + 12, y + 12)
	else
		local yTop = 7
		local xMid = 21
		local xLeft = 11
		local yMid = 31
		local yThird = 19
		local yQtr = 23

		local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
			local pipImage = images["pip_" .. card.suit]
			local pipWidth = 11

			love.graphics.draw(pipImage, x + offsetX, y + offsetY)
			if mirrorX then
				love.graphics.draw(pipImage, x + cardWidth - offsetX - pipWidth, y + offsetY)
			end
			if mirrorY then
				love.graphics.draw(pipImage, x + offsetX + pipWidth, y + cardHeight - offsetY, 0, -1)
			end
			if mirrorX and mirrorY then
				love.graphics.draw(pipImage, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1)
			end
		end

		if card.rank == 1 then
			drawPip(xMid, yMid)
		elseif card.rank == 2 then
			drawPip(xMid, yTop, false, true)
		elseif card.rank == 3 then
			drawPip(xMid, yTop, false, true)
			drawPip(xMid, yMid)
		elseif card.rank == 4 then
			drawPip(xLeft, yTop, true, true)
		elseif card.rank == 5 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xMid, yMid)
		elseif card.rank == 6 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xLeft, yMid, true)
		elseif card.rank == 7 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xLeft, yMid, true)
			drawPip(xMid, yThird)
		elseif card.rank == 8 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xLeft, yMid, true)
			drawPip(xMid, yThird, false, true)
		elseif card.rank == 9 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xLeft, yQtr, true, true)
			drawPip(xMid, yMid)
		elseif card.rank == 10 then
			drawPip(xLeft, yTop, true, true)
			drawPip(xLeft, yQtr, true, true)
			drawPip(xMid, 16, false, true)
		end
	end

	-- Draw top suit
	love.graphics.draw(suitImage, x + suitOffsetX, y + suitOffsetY)

	-- Draw bottom suit
	love.graphics.draw(suitImage, x + cardWidth - suitOffsetX, y + cardHeight - suitOffsetY, 0, -1)
end

local function isMouseInButton(button)
	return love.mouse.getX() >= button.x
		and love.mouse.getX() < button.x + button.width
		and love.mouse.getY() >= button.y
		and love.mouse.getY() < button.y + button.height
end

------------------------------------------------------
function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)

	for nameIndex, name in ipairs({
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		"pip_heart",
		"pip_diamond",
		"pip_club",
		"pip_spade",
		"mini_heart",
		"mini_diamond",
		"mini_club",
		"mini_spade",
		"card",
		"card_face_down",
		"face_jack",
		"face_queen",
		"face_king",
	}) do
		images[name] = love.graphics.newImage("images/" .. name .. ".png")
	end

	for suitIndex, suit in ipairs({ "club", "diamond", "heart", "spade" }) do
		for rank = 1, 13 do
			table.insert(deck, { suit = suit, rank = rank })
		end
	end

    reset()
end

function love.draw()
	-- love.graphics.print("Total number of cards in deck: " .. #deck, 10, 10)

	local cardSpacing = 60
	local marginX = 10
	local output = {}

	-- table.insert(output, "Player hand:")
	-- for cardIndex, card in ipairs(playerHand) do
	-- 	table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
	-- end
	-- table.insert(output, "Total: " .. getTotal(playerHand))
	--
	-- table.insert(output, "")
	--
	-- table.insert(output, "Dealer hand:")
	-- for cardIndex, card in ipairs(dealerHand) do
	-- 	if not roundOver and cardIndex == 1 then
	-- 		table.insert(output, "(Card hidden)")
	-- 	else
	-- 		table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
	-- 	end
	-- end
	--
	-- if roundOver then
	-- 	table.insert(output, "Total: " .. getTotal(dealerHand))
	-- else
	-- 	table.insert(output, "Total: ?")
	-- end
	--
	-- if roundOver then
	-- 	table.insert(output, "")
	--
	-- 	if hasHandWon(playerHand, dealerHand) then
	-- 		table.insert(output, "Player wins")
	-- 	elseif hasHandWon(dealerHand, playerHand) then
	-- 		table.insert(output, "Dealer wins")
	-- 	else
	-- 		table.insert(output, "Draw")
	-- 	end
	-- end
	--
	-- love.graphics.print(table.concat(output, "\n"), 15, 30)

	-- Drawing card
	for cardIndex, card in ipairs(dealerHand) do
		local dealerMarginY = 30
		if not roundOver and cardIndex == 1 then
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
		else
			drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
		end
	end

	for cardIndex, card in ipairs(playerHand) do
		drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
	end

	if roundOver then
		love.graphics.print("Total: " .. getTotal(dealerHand), marginX, 10)

		local function drawWinner(message)
			love.graphics.print(message, marginX, 268)
		end

		if hasHandWon(playerHand, dealerHand) then
			drawWinner("Player wins")
		elseif hasHandWon(dealerHand, playerHand) then
			drawWinner("Dealer wins")
		else
			drawWinner("Draw")
		end
	else
		love.graphics.print("Total: ?", marginX, 10)
	end

	love.graphics.print("Total: " .. getTotal(playerHand), marginX, 120)

	local function drawButton(button)
		-- Removed: local buttonY = 230
		-- Removed: local buttonHeight = 25

		if isMouseInButton(button) then
			love.graphics.setColor(1, 0.8, 0.3)
		else
			love.graphics.setColor(1, 0.5, 0.2)
		end

		love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(button.text, button.x + button.textOffsetX, button.y + button.textOffsetY)
	end
	if not roundOver then
		drawButton(buttonHit)
		drawButton(buttonStand)
	else
		drawButton(buttonPlayAgain)
	end
end

--- @param key love.keypressed
function love.keypressed(key)
	if not roundOver then
		if key == "h" then
			takeCard(playerHand)
		elseif key == "s" then
			roundOver = true
		end

		if roundOver then
			while getTotal(dealerHand) < 17 do
				takeCard(dealerHand)
			end
		end
	else
		love.load()
	end
end

function love.mousereleased()
	if not roundOver then
		if isMouseInButton(buttonHit) then
			takeCard(playerHand)
			if getTotal(playerHand) >= 21 then
				roundOver = true
			end
		elseif isMouseInButton(buttonStand) then
			roundOver = true
		end

		if roundOver then
			while getTotal(dealerHand) < 17 do
				takeCard(dealerHand)
			end
		end
	elseif isMouseInButton(buttonPlayAgain) then
		reset()
	end
end
