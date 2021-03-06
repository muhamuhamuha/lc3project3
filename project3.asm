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
LEA R0, PPROMPT             ; display prompt
PUTS
LD R0, FORTYEIGHT           ; display "PLAYER1"
ADD R0, R0 #1
OUT
LD R0, NEWLINE
OUT
LEA R0, BEGINPROMPT
PUTS
LD R0, NEWLINE
OUT

; validate P1 input
; input testers, -48 and -57 in R6, R5
; leave R0 untouched to print out if bad
LD R6, FORTYEIGHT           ; if CC is PZ we're good
NOT R6, R6
ADD R6, R6 #1
LD R5, MINUS57              ; if CC is NZ we're good

GETC                        ; get input
ADD R2, R0 #0               ; store input into R2
ADD R7, R2 R6               ; check CC P1 input > 48
BRn BADP1
ADD R7, R2 R5               ; check CC P1 input < 57
BRp BADP1

GETC                        ; get the second digit
ADD R3, R0 #0               ; store input input into R3
ADD R7, R3 R5               ; check CC
BRp BADP1                   

ADD R7, R3 R6
BRn BADP1

; save P1 input
ST R2, P1ONE
ST R3, P1TWO
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

; set game counter
AND R6, R6 #0               ; clear R6
ADD R6, R6 #5               ; 5 guesses
BRnzp SKIPFIRST             ; if this is your first time here, don't go to invalid message

BADP2
OUT                         ; spit out P2's bad input
LEA R0, INVALID             ; alert them that they input something wrong
PUTS
LD R0, NEWLINE
OUT

BADGUESS
LEA R0, TRYAGAIN
PUTS
LD R0, NEWLINE
OUT
ADD R6, R6 #-1              ; decrement guess
BRz P1WIN

SKIPFIRST
; clear registers for peace of mind except R1 := P1 input and R6 := guesses
AND R0, R0 #0
AND R2, R2 #0
AND R3, R3 #0
AND R4, R4 #0
AND R5, R6 #0
AND R7, R7 #0


LEA R0, PPROMPT
PUTS
LD R0, FORTYEIGHT
ADD R0, R0 #2
OUT
LD R0, NEWLINE
OUT
LEA R0, GAMEPROMPT
PUTS
LD R0, NEWLINE
OUT
LEA R0, BEGINPROMPT
PUTS
LD R0, NEWLINE
OUT

; check if P2 input is valid
; input testers, -48 and -57 in R6, R5
; leave R0 untouched to print out if bad
LD R4, FORTYEIGHT           ; if CC is PZ we're good
NOT R4, R4
ADD R4, R4 #1
LD R5, MINUS57              ; if CC is NZ we're good

GETC                        ; get P2 input
ADD R2, R0 #0               ; store input into R2
ADD R7, R2 R4               ; check CC P1 input > 48
BRn BADP2
ADD R7, R2 R5               ; check CC P1 input < 57
BRp BADP2

GETC                        ; get the second digit
ADD R3, R0 #0               ; store input input into R3
ADD R7, R3 R5               ; check CC
BRp BADP2                   

ADD R7, R3 R4
BRn BADP2

; clean P2 input
AND R2, R2 #15              ; clean 1st digit
AND R3, R3 #15              ; clean 2nd digit

; reset registers
AND R4, R4 #0               ; clear R4
AND R5, R5 #0               ; clear R5
AND R7, R7 #0               ; clear R7

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
LD R0, NEWLINE
OUT
BRnzp BADGUESS

LOW
LEA R0, TOOLOW
PUTS
LD R0, NEWLINE
OUT
BRnzp BADGUESS

WON                         ; sent here if P2 won
AND R0, R0 #0               ; clear R0 to display # of guesses
ADD R0, R6 #-5              
NOT R0, R0
ADD R0, R0 #1               ; negated
LD R7, FORTYEIGHT           
ADD R0, R0 R7               ; convert guesses to ascii
OUT
LEA R0, WIN2
PUTS
LEA R0, PPROMPT
PUTS
LD R0, FORTYEIGHT
ADD R0, R0 #2
OUT
LEA R0, WINS
PUTS
LD R0, NEWLINE
OUT
BRnzp GAMEOVER

P1WIN
AND R0, R0 #2               ; check if P1 input is single digit
BRz SINGLEDIGIT             

LD R0, P1ONE                ; load stored P1 input data, first digit
OUT
LD R0, P1TWO                ; load stored P1 input data, second digit
OUT
BRnzp P1PROMPT              ; don't worry about single digit

SINGLEDIGIT
LD R0, FORTYEIGHT           ; for ASCIIing
ADD R0, R1 R0               ; R1 := P1 input
OUT

P1PROMPT
LEA R0, WIN1                ; display winner prompt
PUTS
LEA R0, PPROMPT
PUTS
LD R0, FORTYEIGHT
ADD R0, R0 #1
OUT
LEA R0, WINS
PUTS
LD R0, NEWLINE
OUT


GAMEOVER
LEA R0, DONEPROMPT          ; check if user wants to play again
PUTS
GETC
OUT

LD R1, TESTAGAIN            ; check if players want to play again
ADD R0, R0 R1
BRz REZERO

HALT
P1ONE           .FILL       #0
P1TWO           .FILL	    #0
NEWLINE         .FILL       x000A
MINUS57         .FILL       #-57
TESTAGAIN       .FILL       #-121
FORTYEIGHT      .FILL       #48

PPROMPT         .STRINGZ	"\nPLAYER"
BEGINPROMPT     .STRINGZ	"Enter TWO digits between 0-99, e.g. input 01 for 1."
GAMEPROMPT      .STRINGZ    "GUESS WHAT P1 ENTERED NOW!"
INVALID         .STRINGZ	"? THAT'S INVALID INPUT! COME ON NOW!"
TRYAGAIN        .STRINGZ    "YOU'VE USED UP A GUESS P2!"
TOOHIGH         .STRINGZ    "Too big"
TOOLOW          .STRINGZ    "Too small"
WINS            .STRINGZ    " Wins"  ; no newline
WIN1            .STRINGZ	" was the correct answer"
WIN2            .STRINGZ	" guess(es) used."
DONEPROMPT      .STRINGZ    "Game over! Enter 'y' to play again"

.END