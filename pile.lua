
local Card = require "card"

Pile = {}

-- CREATE NEW PILE --
function Pile:new(x, y)
  local metatable = {__index = Pile}
  local cards = {}
  local pile = {
    cards = cards,
    position = Vector(x or 0, y or 0)
  }
  
  setmetatable(pile, metatable)
  return pile
end

-- ADD CARD TO PILE --
function Pile:add(card, undo_action)
  undo_action = undo_action or false
  
  if undo_action and #self.cards > 0 then
    self.cards[#self.cards].draggable = false
    if self ~= board.cardWaste then
      self.cards[#self.cards].faceUp = false
    end
  end
  
  card.faceUp = true
  card.pile = self
  card.position = Vector(self.position.x, self.position.y+(#self.cards)*height*0.03)
  card.anchor = Vector(self.position.x, self.position.y+(#self.cards)*height*0.03)

  table.insert(self.cards, card)
end

-- REMOVE CARD FROM PILE --
function Pile:remove()
  local card = table.remove(self.cards)
  card.pile = nil
  if #self.cards > 0 then
    self.cards[#self.cards].faceUp = true
    self.cards[#self.cards].draggable = true
  end
  return card
end

-- CHECK IF PILE IS EMPTY --
function Pile:isEmpty()
  return #self.cards == 0 and true or false
end

-- REMOVE ALL CARDS AFTER A CERTAIN POINT --
function Pile:removeI(card)
  local cT = {}
  for i=1,#self.cards,1 do
    if self.cards[i] == card then
      for j=i,#self.cards,0 do
        if self.cards[j] == nil then break end
        self.cards[j].pile = nil
        table.insert(cT, table.remove(self.cards, j))
      end
    end
  end
  if #self.cards > 0 then
    self.cards[#self.cards].faceUp = true
    self.cards[#self.cards].draggable = true

  end
  return cT
end

-- DRAW PILE --
function Pile:draw()
  for y, card in ipairs(self.cards) do
    card:draw()
  end
end

-- SPECIAL PILE: FOUNDATION PILE--
-- CHANGES: CREATES A VISUAL STACK RATHER THAN --
-- A DOWNWARD SLIDING STYLE. 
Foundation_Pile = {}
setmetatable(Foundation_Pile, {__index = Pile})

function Foundation_Pile:new(x, y, suit)
  local self = setmetatable({}, {__index = Foundation_Pile})
  local cards = {Card:new(
        0, 
        suit, 
        love.graphics.newImage("Sprites/" .. suit.s .. " " .. "A" .. ".png"), 
        true, 
        x,
        y
    )}
  cards[1].draggable = false
  self.cards = cards
  self.position = Vector(x, y)
  
  return self
end

-- ADD CARD FROM PILE --
function Foundation_Pile:add(card)
  card.faceUp = true
  card.pile = self
  card.position = Vector(self.position.x, self.position.y)
  card.anchor = Vector(self.position.x, self.position.y)

  table.insert(self.cards, card)
end

-- REMOVE CARD FROM PILE --
function Pile:remove()
  local card = table.remove(self.cards)
  card.pile = nil
  if #self.cards > 1 then
    self.cards[#self.cards].faceUp = true
    self.cards[#self.cards].draggable = true
  end
  return card
end

-- DRAW PILE --
function Foundation_Pile:draw()
  love.graphics.setColor(COLORS.DARK_GREEN)
  self.cards[1]:draw()
  love.graphics.setColor(COLORS.WHITE)
  for i=2,#self.cards,1 do
    self.cards[i]:draw()
  end
end

return Pile
