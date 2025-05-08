
local Card = {}
Card.__index = Card

Vector = require "vector"

COLORS = {RED = 0, BLACK = 1}

suits = {{s = "Hearts", c = COLORS.RED}, {s = "Diamonds", c = COLORS.RED}, {s = "Clubs", c = COLORS.BLACK}, {s = "Spades", c = COLORS.BLACK}}
ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
draggableCard = nil

width  = 800
height = 600
cardPosY = height*0.46
foundPosY = cardPosY-125
scale = 1.5
faceDown = love.graphics.newImage("Sprites/Card Back 1.png")
emptyCard = love.graphics.newImage("Sprites/Card Back 2.png")

cardHeight = faceDown:getHeight() * scale
cardWidth = faceDown:getWidth() * scale


regions = {
  {start = width*0.21, finish = width*0.3, y = cardPosY},
  {start = width*0.31, finish = width*0.4, y = cardPosY},
  {start = width*0.41, finish = width*0.5, y = cardPosY},
  {start = width*0.51, finish = width*0.6, y = cardPosY},
  {start = width*0.61, finish = width*0.7, y = cardPosY},
  {start = width*0.71, finish = width*0.8, y = cardPosY},
  {start = width*0.81, finish = width*0.9, y = cardPosY},
  {start = width*0.51, finish = width*0.6, y = foundPosY, endY = foundPosY + cardHeight},
  {start = width*0.61, finish = width*0.7 + cardWidth, y = foundPosY, endY = foundPosY + cardHeight},
  {start = width*0.71, finish = width*0.8, y = foundPosY, endY = foundPosY + cardHeight},
  {start = width*0.81, finish = width*0.9, y = foundPosY, endY = foundPosY + cardHeight}
}

function Card:new(rank, suit, sprite, faceUp, x, y)
  local metatable = {__index = Card}
  local card = {
    rank = rank,
    suit = suit,
    sprite = sprite,
    faceUp = faceUp,
    position = Vector(x, y),
    isDragging = false,
    offsetX = 0,
    offsetY = 0,
    anchor = Vector(x, y),
    pile = nil,
    draggable = true,
  }
  setmetatable(card, metatable)
  return card
end

function Card:toString()
  return ranks[self.rank] .. " of " .. self.suit.s
end

function Card:flip()
  self.faceUp = not self.faceUp
end

function Card:draw()
  
  if self.draggable and self.faceUp and draggableCard == nil and self:isMouseOver(love.mouse.getX(), love.mouse.getY()) then
    love.graphics.setColor(1.00, .922, .502)
  end
  if self.faceUp == true then
    love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, scale, scale)
  else
    love.graphics.draw(faceDown, self.position.x, self.position.y, 0, scale, scale)
  end
  love.graphics.setColor(1, 1, 1)
end

function Card:startDrag(mouseX, mouseY)
    self.isDragging = true
    self.offsetX = mouseX - self.position.x
    self.offsetY = mouseY - self.position.y
end

function Card:transfer(pile)
  local cT = self.pile:removeI(self)
  for _,c in ipairs(cT) do
    pile:add(c)
  end
  self.isDragging = false
end
  
function Card:stopDrag(mouseX, mouseY)
    for i, region in ipairs(regions) do
      
      if mouseX > region.start and mouseX < region.finish and mouseY > region.y then
        --print(piles[i].cards[#piles[i].cards])
        if piles[i] == self.pile then break
        elseif #piles[i].cards == 0 then
          if ranks[self.rank] == "K" then
            self:transfer(piles[i])
            return
          end
        elseif piles[i].cards[#piles[i].cards].suit.c ~= self.suit.c and piles[i].cards[#piles[i].cards].rank == self.rank+1 then
          
          self:transfer(piles[i])
          
          return
        elseif i >= 8 and piles[i].cards[#piles[i].cards].suit.s == self.suit.s and piles[i].cards[#piles[i].cards].rank+1 == self.rank and self.pile.cards[#self.pile.cards] == self then
          self.pile:remove()
          piles[i]:Fadd(self)
          self.isDragging = false
          return
        end
      end
    end
    self.position = Vector(self.anchor.x, self.anchor.y)
    self.isDragging = false
end

function Card:update(dt, mouseX, mouseY)
    if self.isDragging and self.faceUp then
        self.position.x = mouseX - self.offsetX
        self.position.y = mouseY - self.offsetY
    end
end

function Card:isMouseOver(mouseX, mouseY)
    local width = self.sprite:getWidth() * scale
    local height = self == self.pile.cards[#self.pile.cards] and self.sprite:getHeight() * scale or height*0.03
    --local height = self.sprite:getHeight() * scale
    return mouseX > self.position.x and mouseX < self.position.x + width and
           mouseY > self.position.y and mouseY < self.position.y + height
end

return Card
