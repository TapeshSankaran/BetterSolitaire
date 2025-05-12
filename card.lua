
Vector = require "vector"
Config = require "conf"  

local Card = {}
Card.__index = Card


-- Load all Images --
faceDown = love.graphics.newImage(CARD_LOCATIONS.FACEDOWN)
emptyCard = love.graphics.newImage(CARD_LOCATIONS.EMPTY)
solitaire = love.graphics.newImage(CARD_LOCATIONS.SOLITAIRE)


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
          piles[i]:add(self)
          self.isDragging = false
          return
        end
      end
    end
    self.position = Vector(self.anchor.x, self.anchor.y)
    self.isDragging = false
end

function Card:update(dt, mouseX, mouseY)
    print("wsg")
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
