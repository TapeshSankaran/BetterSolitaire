
local Deck   = require "deck"
local Pile   = require "pile"
local Config = require "conf"

Board = {}

function Board:new()
  local board ={}
  local metadata = {__index = Board}
  setmetatable(board, metadata)
  
  self.deck = Deck:new(width*0.036, foundPosY)
  self.deck:shuffle()
  
  self.cardWaste = Pile:new(width*0.036, foundPosY + 125)
  
  self.piles = {}
  self.tableau = {}
  self.foundation = {}
  for i=1,7,1 do
    local pile = Pile:new(width*0.125+width*0.1*i, cardPosY)
    table.insert(self.piles, pile)
    table.insert(self.tableau, pile)
  end
  
  for i, suit in ipairs(suits) do
    local pile = Foundation_Pile:new(width*0.425+width*0.1*i, foundPosY, suit)
    table.insert(self.piles, pile)
    table.insert(self.foundation, pile)
  end
  
  for num, pile in ipairs(self.tableau) do
    for i=1,num,1 do
      if #pile.cards > 0 then
        pile.cards[#pile.cards].faceUp = false
      end
      pile:add(self.deck:deal())
    end
  end
  
  return self
end


function Board:pull_from_deck() 
  local cT = self.cardWaste.cards
  self.cardWaste.cards = {}
  for _, card in ipairs(cT) do
    card.position = Vector(-100, -100)
    card.draggable = false
    table.insert(cardBuffer, card)
  end
  for i=1,3,1 do
    local card = self.deck:deal()
    if card ~= nil then
      self.cardWaste:add(card)
      self.cardWaste.cards[#cardWaste.cards].draggable = false
    end
  end
  if #self.cardWaste.cards == 0 then
    for _, card in ipairs(cardBuffer) do
      self.deck:stage(card)
    end
    cardBuffer = {}
  else
    self.cardWaste.cards[#cardWaste.cards].draggable = true
  end
end


function Board:draw_background()
  
  love.graphics.setColor(COLORS.DARK_GREEN)
  love.graphics.rectangle("fill", 0, 0, width*0.15, height)
  love.graphics.rectangle("fill", 0, height*0.98, width, height*0.02)
  love.graphics.rectangle("fill", width*0.97, 0, width*0.03, height)      

  love.graphics.draw(emptyCard, width*0.225, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.325, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.425, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.525, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.625, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.725, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.825, cardPosY, 0, 1.5, 1.5)
  
  love.graphics.setColor(COLORS.DARKER_GREEN)
  love.graphics.rectangle("fill", 0, 0, width, height*0.24)    
  love.graphics.draw(emptyCard, self.deck.position.x, self.deck.position.y, 0, 1.5, 1.5)
  
  love.graphics.setColor(COLORS.WHITE)
  love.graphics.draw(solitaire, width*0.3, height*0.05, 0, 0.3, 0.3)
  
  self.deck:draw()
end

return Board
