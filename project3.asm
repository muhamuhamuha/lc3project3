.ORIG x3000

REZERO
; clear registers for peace of mind
AND R0, R0 #0
AND R1, R1 #0
AND R2, R2 #0
AND R3, R3 #0
AND R4, R4 #0
AND R5, R6 #0
AND R6, R6 #0
AND R7, R7 #0
BRnzp GETP1                 ; skip BADP1

BADP1                       ; invalid P1 input
OUT
LEA R0, INVALID
PUTS


GETP1
LEA R0, P1PROMPT            ; display prompt
PUTS
LEA R0, BEGINPROMPT
PUTS


GETC                        ; get input
LD R7, MINUS48              ; if CC is PZ we're good
LD R5, MINUS57              ; if CC is NZ we're good
ADD R2, R0 #0               ; store input into R2
ADD R7, R0 R7               ; check CC
BRn BADP1
GETC                        ; get the second digit
ADD R3, R0 #0               ; store input input into R3
ADD R5, R0 R5               ; store input into R3
BRp BADP1                   ; check CC

; clean P1 input
AND R2, R2 #15              ; clean 1st digit
AND R3, R3 #15              ; clean 2nd digit


ADD R1, R1 #10              ; counter to multiply first digit by 10
MULTIPLYFIRST1              ; loop to multiply first digit by 10
ADD R4, R2 R4
ADD R1, R1 #-1
BRp MULTIPLYFIRST1

AND R1, R1 #0               ; clear R1
ADD R1 R3, R4               ; sum up the two characters

; resolve P2 input
AND R6, R6 #0               ; clear R6
ADD R6, R6 #5               ; 5 guesses
BRnzp SKIPFIRST             ; if this is your first time here, don't go to invalid message

BADINPUT
OUT                         ; spit out P2's bad input
LEA R0, INVALID             ; alert them that they input something wrong
PUTS

BADGUESS
LEA R0, TRYAGAIN
PUTS
ADD R6, R6 #-1              ; decrement guess
BRz GAMEOVER

SKIPFIRST
; clear registers for peace of mind except R1 := P1 input and R6 := guesses
AND R0, R0 #0
AND R2, R2 #0
AND R3, R3 #0
AND R4, R4 #0
AND R5, R6 #0
AND R7, R7 #0


LEA R0, P2PROMPT
PUTS
LEA R0, GAMEPROMPT
PUTS
LEA R0, BEGINPROMPT
PUTS
GETC                        ; get P2 input

; check if P2 input is valid
LD R7, MINUS48              ; if CC is PZ we're good
LD R5, MINUS57              ; if CC is NZ we're good
ADD R2, R0 #0               ; store input into R2
ADD R7, R0 R7               ; check CC
BRn BADINPUT
GETC                        ; get the second digit
ADD R3, R0 #0               ; store input input into R3
ADD R5, R0 R5               ; store input into R3
BRp BADINPUT                ; check CC

; clean P2 input
AND R2, R2 #15              ; clean 1st digit
AND R3, R3 #15              ; clean 2nd digit
AND R5, R5 #0               ; clear R5
ADD R5, R5 #10              ; set counter to multiply by 10

MULTIPLYFIRST2              ; multiply first digit into R4 by 10
ADD R4, R2 R4
ADD R5, R5 #-1
BRp MULTIPLYFIRST2
ADD R2, R4 R3               ; sum up inputs into R2

; check if number is bigger or smaller
NOT R3, R2
ADD R3, R3 #1               ; get negative of P1 input into R3

ADD R4, R1 R3               ; check CC code
BRz WON
BRp LOW

; too high
LEA R0, TOOHIGH
PUTS
BRnzp BADGUESS

LOW
LEA R0, TOOLOW
PUTS
BRnzp BADGUESS

WON                         ; sent here if P2 won
LEA R0, WINNER
PUTS


GAMEOVER
LEA R0, DONEPROMPT          ; check if user wants to play again
PUTS
GETC
OUT

LD R1, TESTAGAIN            ; check if players want to play again
ADD R0, R0 R1
BRz REZERO

LEA R0, GOODBYE             ; done for good
PUTS

HALT
MINUS48         .FILL       #-48
MINUS57         .FILL       #-57
TESTAGAIN       .FILL       #-121

P1PROMPT        .STRINGZ	"\nPLAYER1\n"
P2PROMPT        .STRINGZ	"PLAYER2!\n"
BEGINPROMPT     .STRINGZ	"Enter two digits between 0-99, e.g. input 01 for 1.\n"
GAMEPROMPT      .STRINGZ    "GUESS WHAT P1 ENTERED NOW!\n"
INVALID         .STRINGZ	"? THAT'S INVALID INPUT! COME ON NOW!\n"
TRYAGAIN        .STRINGZ    "YOU'VE USED UP A GUESS P2!\n"
TOOHIGH         .STRINGZ    "TOO HIGH!\n"
TOOLOW          .STRINGZ    "TOO LOW!\n"
WINNER          .STRINGZ	"You won!\n"
DONEPROMPT      .STRINGZ    "Game over! Enter 'y' to play again.\n"
GOODBYE         .STRINGZ	"Goodbye!"


.END