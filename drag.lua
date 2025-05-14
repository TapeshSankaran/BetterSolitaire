
local Config = "conf"

-- Checks if mouse is pressed --
local mousePressed = false
-- Card currently being dragged --
local draggableCard = nil
-- Checker for mute state --
local is_muted = false
-- Checker for win state --
local not_won = true

-- UPDATE FUNCTION --
function love.update(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  
  -- Update card position of card being dragged --
  if draggableCard then
    draggableCard:update(dt, mouseX, mouseY)
  end
  
  -- Set volume of audio --
  master_volume = is_muted and 0 or 1
  win_SFX:setVolume(master_volume * 0.5)
  shuffle_SFX:setVolume(master_volume * 0.5)
  move_SFX:setVolume(master_volume * 0.25)
  draw_SFX:setVolume(master_volume * 0.5)
  
  -- Check win state --
  if board:is_won() and not_won then
    win_SFX:play()
    not_won = false
    for i, pile in ipairs(board.piles) do
      if PILE_TYPES[i] == TorF.FOUNDATION then
        pile.cards[#pile.cards].draggable = false
      end
    end
  end
end

-- WHEN MOUSE PRESSED --
function love.mousepressed(x, y, button, istouch, presses)
  
  -- If left click and no card already being dragged --
  if button == 1 and draggableCard == nil then
    start_drag(x, y)
  end
  
  -- Deck click functionality --
  if button == 1 and board.deck:isMouseOver(x, y) and not mousePressed then
    board:pull_from_deck()
  end

  -- Reset click functionality --
  if button == 1 and reset_button_isOver(x, y) and not mousePressed then
    board:reset()
  end
  
  -- Undo click functionality --
  if button == 1 and undo_button_isOver(x, y) and not mousePressed then
    board:undo()
  end

  -- Mute click functionality --
  if button == 1 and mute_button_isOver(x, y) and not mousePressed then
    if is_muted then
      is_muted = false
    else
      is_muted = true
    end
  end
  mousePressed = true
end

-- WHEN MOUSE RELEASED --
function love.mousereleased(x, y, button, istouch, releases)
  if button == 1 and draggableCard then
    stop_drag(x, y)
  end
  mousePressed = false
end

-- START DRAGGING CARD --
function start_drag(x, y)
  
  for _, card in ipairs(board.deck.cardTable) do
    if card.draggable and card.faceUp and card:isMouseOver(x, y) then
      draggableCard = card
      draggableCard:startDrag(x, y)
      break
    end
  end
end

-- WHEN STOP DRAGGING CARD --
function stop_drag(x, y)
    draggableCard:stopDrag(x, y)
    draggableCard = nil  
end

-- DRAWING DRAGGED CARD --
function dragged_card_draw() 
  love.graphics.setColor(COLORS.GOLD)
  if draggableCard ~= nil then
    draggableCard:draw()
  end
end

-- DRAW WIN ICON --
function win_screen_draw()
  if not_won == false then
    love.graphics.draw(win_img, width*0.02, height*0.15, 0, 0.75, 0.75)
  end
end

-- CHECK IF OVER RESET BUTTON -- 
function reset_button_isOver(mouseX, mouseY)
  local reset_sx = reset_img:getWidth() * reset_scale
  local reset_sy = reset_img:getHeight() * reset_scale
  
  return mouseX > reset_x and mouseX < reset_x + reset_sx and
           mouseY > reset_y and mouseY < reset_y + reset_sy
end

-- CHECK IF OVER UNDO BUTTON --
function undo_button_isOver(mouseX, mouseY)
  local undo_sx = undo_img:getWidth() * undo_scale
  local undo_sy = undo_img:getHeight() * undo_scale
  
  return mouseX > undo_x and mouseX < undo_x + undo_sx and
           mouseY > undo_y and mouseY < undo_y + undo_sy
end

-- CHECK IF OVER MUTE BUTTON --
function mute_button_isOver(mouseX, mouseY)
  local mute_sx = mute_img:getWidth()  * mute_scale
  local mute_sy = mute_img:getHeight() * mute_scale
  
  return mouseX > mute_x and mouseX < mute_x + mute_sx and
         mouseY > mute_y and mouseY < mute_y + mute_sy
end