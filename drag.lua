
local Config = "conf"

local mousePressed = false
local draggableCard = nil

function love.update(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  
  if draggableCard then
    print("12")
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
  mousePressed = true
end

function love.mousereleased(x, y, button, istouch, releases)
  if button == 1 and draggableCard then
    stop_drag(x, y)
  end
  mousePressed = false
end

function start_drag(x, y)
  
  for _, card in ipairs(board.deck.cardTable) do
    if card.draggable and card.faceUp and card:isMouseOver(x, y) then
      print("hello")
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
