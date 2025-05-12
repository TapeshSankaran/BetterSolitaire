
-- Size of Display --
width  = 800
height = 600

-- Dimentions of Card Images --
img_width = 64
img_height = 40

-- Scale of Cards --
scale = 1.5

-- Set Random Seed --
seed = 3--os.time() -- 3 for testing, os.time() for main use

-- _______________________________________________________________________ --

-- Height of Tableau from Top --
cardPosY = height*0.46

-- Height of Foundation from Top --
foundPosY = cardPosY-125

-- Get Dimentions of Cards In-Game --
cardHeight = img_height * scale
cardWidth = img_width * scale

-- ENUMS -- 
COLORS = {RED = 0, BLACK = 1}
   -- Suits w/ Respective Colors --
suits = {{s = "Hearts", c = COLORS.RED}, {s = "Diamonds", c = COLORS.RED}, {s = "Clubs", c = COLORS.BLACK}, {s = "Spades", c = COLORS.BLACK}}

   -- Ranks --
ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}

   -- Columns to Drop Cards in --
regions = {
  {start = width*0.21, finish = width*0.3, y = cardPosY},                                              -- tableau 1
  {start = width*0.31, finish = width*0.4, y = cardPosY},                                              -- tableau 2
  {start = width*0.41, finish = width*0.5, y = cardPosY},                                              -- tableau 3
  {start = width*0.51, finish = width*0.6, y = cardPosY},                                              -- tableau 4
  {start = width*0.61, finish = width*0.7, y = cardPosY},                                              -- tableau 5
  {start = width*0.71, finish = width*0.8, y = cardPosY},                                              -- tableau 6
  {start = width*0.81, finish = width*0.9, y = cardPosY},                                              -- tableau 7
  {start = width*0.51, finish = width*0.6, y = foundPosY, endY = foundPosY + cardHeight},              -- foundation 1
  {start = width*0.61, finish = width*0.7 + cardWidth, y = foundPosY, endY = foundPosY + cardHeight},  -- foundation 2
  {start = width*0.71, finish = width*0.8, y = foundPosY, endY = foundPosY + cardHeight},              -- foundation 3
  {start = width*0.81, finish = width*0.9, y = foundPosY, endY = foundPosY + cardHeight}               -- foundation 4
}

   -- Card Locations --
CARD_LOCATIONS = {
  FACEDOWN  = "Sprites/Card Back 1.png",
  EMPTY     = "Sprites/Card Back 2.png",
  SOLITAIRE = "Sprites/Solitaire.png"
}

   -- Colors --
COLORS = {
  WHITE        = {1, 1, 1},
  GREEN        = {.216, .396, .302},
  DARK_GREEN   = {.18, .302, .255},
  DARKER_GREEN = {.14, .255, .230},
  GOLD         = {1.00, 0.860, 0.25},
}

-- Global Vars --
board = {}