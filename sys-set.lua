
require "conf"

function System_Set() 
  -- Set Title of Window --
  love.window.setTitle("Better Solitaire")
  
  -- Set Filter for Clearness --
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  -- Set Dimentions for Window --
  love.window.setMode(width, height)
  
  -- Set Color --
  love.graphics.setBackgroundColor(COLORS.GREEN)
  
  -- SET RANDOM SEED --
  math.randomseed(seed)
end
