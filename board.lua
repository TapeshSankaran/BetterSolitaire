
local Deck = require "deck"
local Pile = require "pile"

Board = {}

local cardBuffer = {}

function Board:new()
  local board = {}
  local metadata = {__index = Board}
  setmetatable(board, metadata)
  
  cardBuffer = {}
  self.deck = Deck:new(width*0.036, foundPosY)
  self.deck:shuffle()
  
  self.action_stack = {}
  
  self.cardWaste = Pile:new(width*0.036, foundPosY + 125)
  
  self.piles = {}
  for i=1,7,1 do
    local pile = Pile:new(width*0.125+width*0.1*i, cardPosY)
    table.insert(self.piles, pile)
  end
  
  for i, suit in ipairs(suits) do
    local pile = Foundation_Pile:new(width*0.425+width*0.1*i, foundPosY, suit)
    table.insert(self.piles, pile)
  end
  
  for num, pile in ipairs(self.piles) do
    if (PILE_TYPES[num] == TorF.TABLEAU) then
      for i=1,num,1 do
        if #pile.cards > 0 then
          pile.cards[#pile.cards].faceUp = false
        end
        pile:add(self.deck:deal())
      end
    end
  end
  
  return self
end

-- PULL CARDS FROM DECK --
function Board:pull_from_deck()
  
  -- Put cards into a buffer and reset cardWaste --
  local cT = self.cardWaste.cards
  self.cardWaste.cards = {}
  -- Move cards into official buffer after some settings changes --
  for _, card in ipairs(cT) do
    card.position = Vector(-100, -100)
    card.draggable = false
    table.insert(cardBuffer, card)
  end
  -- Deals cards to waste pile. If there are no more cards, does not enter the waste pile --
  for i=1,3,1 do
    local card = self.deck:deal()
    if card ~= nil then
      self.cardWaste:add(card)
      self.cardWaste.cards[#self.cardWaste.cards].draggable = false
    end
  end
  -- If no cards entered the waste pile, put all cards back into deck --
  if #self.cardWaste.cards == 0 then
    table.insert(self.action_stack, {cardBuffer, cT})
    for _, card in ipairs(cardBuffer) do
      self.deck:floor(card)
    end
    cardBuffer = {}
    shuffle_SFX:play()
  else -- If there are cards in waste pile, set top card to draggable --
    table.insert(self.action_stack, {cT})
    self.cardWaste.cards[#self.cardWaste.cards].draggable = true
    draw_SFX:play()
  end
end

-- UNDO ACTION --
function Board:undo()
  
  -- If undo was initiated with no actions to revert to, return --
  if #self.action_stack == 0 then 
    return
  end
  
  -- Take actions from stack --
  local action = table.remove(self.action_stack)
  
  -- Determines what action is being reverted --
  if #action == A_T.CARD_TRANSFER then
    
    -- Pulls card back to original position --
    -- Action Layout: {Card being returned, Pile to return to, Card before main card's face side} --
    action[1]:transfer(action[2], action[3])
  
  elseif #action == A_T.DECK_REFRESH then
    
    -- Unrefreshes the deck (returns cards to buffer and waste pile) --
    -- Action Layout: {All cards in prev state's buffer, Prev state's waste pile} --
    self:undo_deck_refresh(action[1], action[2])
  
  elseif #action == A_T.DRAW_CARDS then
    
    -- Returns cards to deck from waste pile, then returns cards to waste pile from buffer --
    -- Action Layout: {Prev state's waste pile} --
    self:undo_card_pull(action[1])
  
  end
end

-- UNDO THE RESTAGING OF DECK --
function Board:undo_deck_refresh(action_one, action_two)
  for i, card in ipairs(action_one) do
    if i > #action_one-3 then
      self.cardWaste:add(card)
    else
      card.position = Vector(-100, -100)
      card.draggable = false
      card.faceUp = true
      table.insert(cardBuffer, card)
    end
  end
  if #self.cardWaste.cards > 0 then
    self.cardWaste.cards[#self.cardWaste.cards].draggable = true
  end
  self.deck.cards = {}
  shuffle_SFX:play()
end

-- UNDO PULLING CARDS FROM DECK --
function Board:undo_card_pull(action)
  for i=1,#self.cardWaste.cards do
    self.deck:stage(self.cardWaste:remove())
  end
  for _, card in ipairs(action) do
    table.remove(cardBuffer)
    self.cardWaste:add(card)
  end
  if #self.cardWaste.cards > 0 then
    self.cardWaste.cards[#self.cardWaste.cards].draggable = true
  end
  draw_SFX:play()
end

-- RESET BOARD --
function Board:reset()
  seed = os.time()
  math.randomseed(seed)
  board = Board:new()
end

-- WIN CONDITION --
function Board:is_won()
  for i, pile in ipairs(self.piles) do
    if PILE_TYPES[i] == TorF.FOUNDATION then
      if pile.cards[#pile.cards].rank == 0 then 
        return false
      end
      
      if ranks[pile.cards[#pile.cards].rank] ~= "K" then
        return false
      end
    end
  end
  return true
end

-- DRAW BOARD BACKGROUND --
function Board:draw_background()
  
  -- Draw the background of the board --
  love.graphics.setColor(COLORS.DARK_GREEN)
  love.graphics.rectangle("fill", 0, 0, width*0.15, height)
  love.graphics.rectangle("fill", 0, height*0.98, width, height*0.02)
  love.graphics.rectangle("fill", width*0.97, 0, width*0.03, height)      

  -- Draw empty slot for each pile --
  love.graphics.draw(emptyCard, width*0.225, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.325, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.425, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.525, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.625, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.725, cardPosY, 0, 1.5, 1.5)
  love.graphics.draw(emptyCard, width*0.825, cardPosY, 0, 1.5, 1.5)
  
  -- Draw the top rectangle for the title --
  love.graphics.setColor(COLORS.DARKER_GREEN)
  love.graphics.rectangle("fill", 0, 0, width, height*0.24)    
  love.graphics.draw(emptyCard, self.deck.position.x, self.deck.position.y, 0, 1.5, 1.5)
  
  -- Draw the title --
  love.graphics.setColor(COLORS.WHITE)
  love.graphics.draw(solitaire, width*0.3, height*0.05, 0, 0.3, 0.3)
  love.graphics.draw(reset_img, reset_x, reset_y, 0, reset_scale, reset_scale)
  love.graphics.draw(undo_img, undo_x, undo_y, 0, undo_scale, undo_scale)
  
  -- Draw the deck --
  self.deck:draw()
  
  -- Draw mute button --
  if master_volume == 1 then
    love.graphics.setColor(COLORS.GREEN)
  end
  love.graphics.draw(mute_img, mute_x, mute_y, 0, mute_scale, mute_scale)
  love.graphics.setColor(COLORS.WHITE)
end

return Board
