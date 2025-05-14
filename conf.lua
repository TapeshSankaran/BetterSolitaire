
-- Size of Display --
width  = 800
height = 600

-- Dimentions of Card Images --
img_width = 64
img_height = 40

-- Scale of Cards --
scale = 1.5

-- Set Random Seed --
seed = os.time() -- 3 for testing, os.time() for main use

-- _______________________________________________________________________ --

-- Dimensions of Reset Button --
reset_x = width*0.0125
reset_y = height*0.90
reset_scale = 0.1

-- Dimensions of Undo Button --
undo_x = width*0.0125
undo_y = height*0.80
undo_scale = 0.1

-- Dimensions of Mute Button --
mute_x = width*0.0125
mute_y = height*0.70
mute_scale = 0.1

-- Height of Tableau from Top --
cardPosY = height*0.46

-- Height of Foundation from Top --
foundPosY = cardPosY-125

-- Get Dimentions of Cards In-Game --
cardHeight = img_height * scale
cardWidth = img_width * scale

-- ENUMS -- 
CARD_COLORS = {RED = 0, BLACK = 1}
   -- Suits w/ Respective Colors --
suits = {{s = "Hearts", c = CARD_COLORS.RED}, {s = "Diamonds", c = CARD_COLORS.RED}, {s = "Clubs", c = CARD_COLORS.BLACK}, {s = "Spades", c = CARD_COLORS.BLACK}}

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
  {start = width*0.61, finish = width*0.7, y = foundPosY, endY = foundPosY + cardHeight},              -- foundation 2
  {start = width*0.71, finish = width*0.8, y = foundPosY, endY = foundPosY + cardHeight},              -- foundation 3
  {start = width*0.81, finish = width*0.9, y = foundPosY, endY = foundPosY + cardHeight}               -- foundation 4
}

   -- File Locations --
FILE_LOCATIONS = {
  FACEDOWN  = "Sprites/Card Back 1.png",
  EMPTY     = "Sprites/Card Back 2.png",
  SOLITAIRE = "Sprites/Solitaire.png",
  RESET     = "Sprites/Reset.png",
  UNDO      = "Sprites/Undo.png",
  MUTE      = "Sprites/Mute.png",
  VICTORY   = "Sprites/Win.png",
    -- Audio --
  WIN       = "SFX/Win.mp3",
  SHUFFLE   = "SFX/Shuffle.mp3",
  MOVE      = "SFX/Move2.mp3",
  DRAW      = "SFX/Draw.mp3",
}

   -- Colors --
COLORS = {
  WHITE        = {1, 1, 1},
  GREEN        = {.216, .396, .302},
  DARK_GREEN   = {.18, .302, .255},
  DARKER_GREEN = {.14, .255, .230},
  GOLD         = {1.00, 0.860, 0.25},
  LIGHT_GOLD   = {1.00, .922, .502},
}

   -- Pile Type --
TorF = {TABLEAU = 10, FOUNDATION = 20}
PILE_TYPES = {
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.TABLEAU,
  TorF.FOUNDATION,
  TorF.FOUNDATION,
  TorF.FOUNDATION,
  TorF.FOUNDATION
}

   -- Action Type --
A_T = {
  CARD_TRANSFER = 3,
  DECK_REFRESH  = 2,
  DRAW_CARDS    = 1,
}



-- GLOBAL VARS --

  -- Main Board --
board = {}

  -- Volume Control --
master_volume = 1