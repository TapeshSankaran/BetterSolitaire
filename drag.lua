
local Config = "conf"

local mousePressed = false
local draggableCard = nil

function love.update(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  
  if draggableCard then
    draggableCard:update(dt, mouseX, mouseY)
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 and draggableCard == nil then
    start_drag(x, y)
  end
  
  if button == 1 and board.deck:isMouseOver(x, y) and not mousePressed then
    board:pull_from_deck()
  end
  
  if button == 1 and reset_button_isOver(x, y) and not mousePressed then
    board:reset()
  end
  
    if button == 1 and undo_button_isOver(x, y) and not mousePressed then
    board:undo()
  end
  mousePressed = true
end

function love.mousereleased(x, y, button, istouch, releases)
  if button == 1 and draggableCard then
    stop_drag(x, y)
    move_SFX:play()
  end
  mousePressed = false
end

function start_drag(x, y)
  
  for _, card in ipairs(board.deck.cardTable) do
    if card.draggable and card.faceUp and card:isMouseOver(x, y) then
      draggableCard = card
      draggableCard:startDrag(x, y)
      break
    end
  end
end

function stop_drag(x, y)
    draggableCard:stopDrag(x, y)
    draggableCard = nil  
end

function dragged_card_draw() 
  love.graphics.setColor(COLORS.GOLD)
  if draggableCard ~= nil then
    draggableCard:draw()
  end
end

function reset_button_isOver(mouseX, mouseY)
  local reset_sx = reset_img:getWidth() * reset_scale
  local reset_sy = reset_img:getHeight() * reset_scale
  
  return mouseX > reset_x and mouseX < reset_x + reset_sx and
           mouseY > reset_y and mouseY < reset_y + reset_sy
end

function undo_button_isOver(mouseX, mouseY)
  local undo_sx = undo_img:getWidth() * undo_scale
  local undo_sy = undo_img:getHeight() * undo_scale
  
  return mouseX > undo_x and mouseX < undo_x + undo_sx and
           mouseY > undo_y and mouseY < undo_y + undo_sy
end