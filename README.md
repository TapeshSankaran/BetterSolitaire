# Solitaire
 A recreation of the classic game, Solitaire.

**Programming Patterns** 

Use of more custom dataTypes: I reused the vector datatype and made the deck datatype, which holds the main deck of the game, a pile datatype, and a card datatype. The overall structure and pattern of the code is that the deck datatype is build with all cards, shuffled, then distributed between 7 piles. The remaining cards remain in the deck for further use with the waste pile. The foundation piles (win conditions) have their own datatype derived from the pile one. 

Dragging cards uses the update function to change positions and an offset variable to maintain the location where it was clicked instead of teleporting its corner of the card into the pointer. The conditions on whether a card gets transferred to a different pile when dropped is located in the 'stopDrag()' function, where it checks whether they were dropped in the same spot, whether they were a king dropped on an empty spot, whether the card they were landing on were of opposite color and descending rank, or if they were being put in the proper order in the foudation pile. If the card is in the middle of a pile(and face up), the card, along with all other cards after, are moved to the other stack using for loops for each action(removing and adding the cards).

**Postmortem**

My code from the last project was very sloppy, with poor spacing, a lack of comments, not enough enumerables, long if statements, and more. The biggest pain point was that it was hard to find content within a file. This is likely because the lack of files to spread code out, a lack of comments, and poor spacing. A lack of an overarching datatype caused main.lua to be cluttered with uneeded code, and a lack of a seperate grabber-like datatype further caused cluttering within main.lua. Another big issue was the short variable and function names that didn't define what it held well. For example, a function called fadd() cannot be understood. Is is a fad? add with an f? What would f stand for then? For clarification f stood for foundation.

Some of the changes that occurred with refactoring was the inclusion of more enumerables. I added color enums, file location enums, pile type enums, and more. Furthermore, I moved all enumerables to a new file called conf.lua(short for configuration). I also moved many of the main.lua functions to various other places. These places were split between 3 seperate new files called board.lua, drag.lua, and sys-set.lua. board.lua held the main table funcitonality, and the reasons for this change was neatness and an easier implementation of reset and undo features. drag.lua held the main interaction functionality within the game. All button-pressing, card-dragging, and deck drawing happened here. sys-set simply held the window settings and the randomseed creation. To fix variable names, I did a number of things. I moved to the more general formatting for variables like foundation_pile, and wasn't afraid of longer names. I also created a new foundation_pile class that represented foundation piles. This was directly derived from the pile class which already existed. This allowed me to remove the fadd() and fdraw() functions and just make it the add and draw function of the foundation pile class.

---

**Sources**
- Solitaire Title, Win Notice, and All Buttons(Undo, Reset, Mute): [TextStudio](https://www.textstudio.com/logo/luxury-text-effect-2057)
- Batch Editor(for cropping all cards): [Pixlr](https://pixlr.com/batch/)
- Card Assets: [Elvgames](https://elvgames.itch.io/playing-cards-pixelart-asset-pack)
- Audio(Win Sound, Shuffle, Draw, Move Card): [Pixabay(royalty-free audio)](https://pixabay.com/sound-effects/search/cards/)
- Everything else was made by me.