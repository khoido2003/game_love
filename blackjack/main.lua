---@class Card
---@field suit string
---@field rank integer

--- @type Card[]
local deck = {}

--- @type Card[]
local playerHand = {}

function love.load()
	for suitIndex, suit in ipairs({ "club", "diamond", "heart", "spade" }) do
		for rank = 1, 13 do
			table.insert(deck, { suit = suit, rank = rank })
		end
	end

	-- Add new card to player
	table.insert(playerHand, table.remove(deck, love.math.random(#deck)))

	table.insert(playerHand, table.remove(deck, love.math.random(#deck)))
end

function love.draw()
	love.graphics.print("Total number of cards in deck: " .. #deck, 10, 10)
	for cardIndex, card in ipairs(playerHand) do
		love.graphics.print("suit: " .. card.suit .. ", rank: " .. card.rank, 10, cardIndex * 10 + 30)
	end
end
