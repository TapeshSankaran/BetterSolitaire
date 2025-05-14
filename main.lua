
-- Tapesh Sankaran
-- CMPM 121
-- 4-14-2025

io.stdout:setvbuf("no")

local Config = require "conf"
local Sys    = require "sys-set"
local Board  = require "board" 
local Drag   = require "drag"

local cardBuffer = {}

-- LOAD FUNCTION --
function love.load()
  
  -- Set Window and Random Seed --
  --     (from sys-set.lua)     --
  System_Set()
  
  -- Create Board --
  board = Board:new()
end

-- DRAW FUNCTION --
function love.draw()
  
  -- Draw table's background --
  board:draw_background()

  -- Draw Tableaus and Foundations --
  for i, pile in ipairs(board.piles) do
    pile:draw()
  end
  
  -- Draw Card Waste --
  board.cardWaste:draw()
  
  -- Draw Selected Card --
  --  (from drag.lua)   --
  dragged_card_draw()
  
  -- Draw Win Screen --
  -- (from drag.lua) --
  win_screen_draw()
end