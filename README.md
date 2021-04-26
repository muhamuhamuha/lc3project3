# LC-3 Project 3
#### Ahmed Muhammad
#### 20210426
<br>

## Overview 
This project demonstrates capturing input from a keyboard and outputing it to the console.
It is structured as a game where player 1 inputs a number and player 2 has five tries to guess what that number is.
If player 2's guessed number is bigger than what player 1 input, the game says "too big", and vice versa.
Inputs must be two numerical digits, if anything else is entered the program keeps asking for the desired input.
If the player is going to enter the number "96", they must enter the digit "9", followed by "6".
If they want to enter the number "3", they must first enter "0" and then "3".
At the end of the game, a prompt will display the winner with some brief metadata, and allow the user to play again if they input a lowercase "y".

## Code Breakdown
### Validating Input
The program prompts the user to enter two digits, but will "throw" an "error" if either of the two digits are 0-9.
To check the input (which is stored in R0 after the user hits the keyboard) the program determines if its ASCII value is greater than or equal to 48 but at the same time less than or equal to 57.
If the criteria is not fulfilled the user is asked to input two new digits.
If player 2 makes a mistake, it does count against them during the game, and they have one less guess to make before game over.

### Converting Numbers
Player 1's input digits are stored into memory after they've been read and validated.
Then both players' numbers' are cleaned of their ASCII data, the first digit is multiplied by 10, and then summed with the other digit to get the number that was input.

### Comparing Player-1 Input with Player-2 Input
We take player 2's input after its been converted and subtract it from player-1 input.
If the resulting number is greater than zero then we output a message saying the guess was too small, if it's bigger then the guess was too big.
If the difference is zero then player 2 wins, and we output how many guess it took them.
Otherwise if 5 turns are up then player 1 wins and we output what the number they input was.

### Extra Credit -- Loop and Restart Game
To implement this, I loaded the ASCII number for the lowercase letter "y", and if the user enters that at the end of the game it loops back to the start label.


