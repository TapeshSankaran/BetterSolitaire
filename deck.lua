
local Card = require "card"
local Vector = require "vector"

local Deck = {}
Deck.__index = Deck

function Deck:new(x, y)
  
  
  local cards = {}
  local cardRef = {}

  
  for _, suit in pairs(suits) do
    for i, rank in ipairs(ranks) do
      table.insert(
        cards, 
        Card:new(
          i, 
          suit, 
          love.graphics.newImage("Sprites/" .. suit.s .. " " .. rank .. ".png"),
          false,
          x, y
        )
      )
      table.insert(cardRef, cards[#cards])
    end
  end
  
  local deck = {
    cards = cards,
    cardTable = cardRef,
    position = Vector(x, y)
  }
  
  setmetatable(deck, self)
  return deck
end

function Deck:shuffle()
  for i = #self.cards, 2, -1 do
    local j = math.random(i)
    self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
  end
end

function Deck:deal()
  return table.remove(self.cards)
end

function Deck:stage(card)
  card.faceUp = false
  card.position = self.position
  table.insert(self.cards, card)
end

function Deck:floor(card)
  card.faceUp = false
  card.position = self.position
  table.insert(self.cards, 1, card)
end

function Deck:isMouseOver(mouseX, mouseY)
  local width = faceDown:getWidth() * scale
  local height = faceDown:getHeight() * scale
  return mouseX > self.position.x and mouseX < self.position.x + width and
           mouseY > self.position.y and mouseY < self.position.y + height
end

function Deck:draw()
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end

return Deck
