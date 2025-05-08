# Solitaire
 A recreation of the classic game, Solitaire.

**Programming Patterns** 

Use of more custom dataTypes: I reused the vector datatype and made the deck datatype, which holds the main deck of the game, a pile datatype, and a card datatype. The overall structure and pattern of the code is that the deck datatype is build with all cards, shuffled, then distributed between 7 piles. The remaining cards remain in the deck for further use with the waste pile. The foundation piles (win conditions) also use the pile datatype, except with a seperate add function called 'fadd()'. 

Dragging cards uses the update function to change positions and an offset variable to maintain the location where it was clicked instead of teleporting its corner of the card into the pointer. The conditions on whether a card gets transferred to a different pile when dropped is located in the 'stopDrag()' function, where it checks whether they were dropped in the same spot, whether they were a king dropped on an empty spot, whether the card they were landing on were of opposite color and descending rank, or if they were being put in the proper order in the foudation pile. If the card is in the middle of a pile(and face up), the card, along with all other cards after, are moved to the other stack using for loops for each action(removing and adding the cards).

**Postmortem**

I was very happy with how the project turned out. It acts as a real game, but I would add a win condition at the end. Any further changes would be to clean up the code, improve the look, add sound effects, and add animations if possible. Some possible programming patterns that could fit better would be a better use of the vectors, as I could have used the adding feature to simplify code.

**Sources**
- Solitaire Title: https://www.textstudio.com/logo/luxury-text-effect-2057
- Batch Editor(for cropping all cards): https://pixlr.com/batch/
- Card Assets: https://elvgames.itch.io/playing-cards-pixelart-asset-pack
- Everything else was made by me.