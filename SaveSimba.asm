;***********************************************************
; Programming Assignment 4
; Student Name: Paul Yi
; UT Eid: psy232
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_INITIAL
        TRAP  x22 
        LDI   R0,BLOCKS
        JSR   LOAD_JUNGLE
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_LOADED
        TRAP  x22                        ; output end message
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
  
;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE  ST R0, DJSaveR0
                ST R1, DJSaveR1
                ST R2, DJSaveR2
                ST R3, DJSaveR3
                ST R4, DJSaveR4
                ST R5, DJSaveR5
                ST R6, DJSaveR6
                LEA R0, ColumnHead
                TRAP x22
                LD R0, GridStart
                LD R1, Final
                LD R2, LineLength
                AND R6, R6, #0
                ADD R6, R6, #-1
DisplayLoop     ADD R4, R4, #1
                AND R5, R4, x0001
                ST R0, ColSave
                BRnp Odd
                LD R5, ASCII
                ADD R6, R6, #1
                ADD R5, R6, R5
                ADD R0, R5, #0
                TRAP x21
                LD R0, Space
                TRAP x21
                BRnzp EvenSkip
Odd             LD R0, Space
                TRAP x21
                TRAP x21
EvenSkip        LD R0, ColSave
                TRAP x22
                ST R0, ColSave
                LD R0, NewLine
                TRAP x21
                LD R0, ColSave
                ADD R0, R0, R2
                ADD R3, R0, R1
                BRnp DisplayLoop
                LD R0, DJSaveR0
                LD R1, DJSaveR1
                LD R2, DJSaveR2
                LD R3, DJSaveR3
                LD R4, DJSaveR4
                LD R5, DJSaveR5
                LD R6, DJSaveR6
                JMP R7
                TRAP x25
ColumnHead      .STRINGZ "\n   0 1 2 3 4 5 6 7\n" 
NewLine         .STRINGZ "\n"
Final           .FILL xBE2A
ASCII           .FILL x0030
Space           .FILL x0020
ColSave         .BLKW #1 
DJSaveR0        .BLKW #1
DJSaveR1        .BLKW #1
DJSaveR2        .BLKW #1
DJSaveR3        .BLKW #1
DJSaveR4        .BLKW #1
DJSaveR5        .BLKW #1
DJSaveR6        .BLKW #1

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE ST R0, LJSaveR0
            ST R1, LJSaveR1
            ST R2, LJSaveR2
            ST R3, LJSaveR3
            ST R4, LJSaveR4
            ST R5, LJSaveR5
            ADD R3, R0, #0
            BRz DoneLJ
LoopLJ      LDR R1, R3, #1
            LDR R2, R3, #2
            ST R7, LJSaveR7
            JSR GRID_ADDRESS
            LD R7, LJSaveR7
            LDR R4, R3, #3
            STR R4, R0, #0
            LD R5, Simba
            ADD R5, R5, R4
            BRnp SkipSimba
            ST R1, CURRENT_ROW
            ST R2, CURRENT_COL
            LD R5, Asterick
            STR R5, R0, #0
SkipSimba   LD R5, Home
            ADD R5, R5, R4
            BRnp SkipHome
            ST R1, HOME_ROW
            ST R2, HOME_COL
SkipHome    LDR R3, R3, #0
            BRnp LoopLJ
DoneLJ      LD R0, LJSaveR0
            LD R1, LJSaveR1
            LD R2, LJSaveR2
            LD R3, LJSaveR3
            LD R4, LJSaveR4
            LD R5, LJSaveR5
            JMP  R7
            TRAP x25
LJSaveR0    .BLKW #1
LJSaveR1    .BLKW #1
LJSaveR2    .BLKW #1
LJSaveR3    .BLKW #1
LJSaveR4    .BLKW #1
LJSaveR5    .BLKW #1
LJSaveR7    .BLKW #1
Simba       .FILL x-49
Asterick    .FILL x2A
Home        .FILL x-48

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS    AND R0, R0, #0
                ST R1, GASaveR1
                ST R2, GASaveR2
                ST R3, GASaveR3
                ST R4, GASaveR4
                LD R3, LineLength      
                ADD R4, R1, #0
                ADD R4, R4, R4
                ADD R4, R4, #1
MultLoop        ADD R0, R0, R3
                ADD R4, R4, #-1
                BRnp MultLoop
                AND R4, R4, #0
                ADD R4, R2, #0
                ADD R4, R4, R4
                ADD R4, R4, #1
                ADD R0, R4, R0
                LD R4, Gridstart
                ADD R0, R4, R0
                LD R1, GASaveR1
                LD R2, GASaveR2
                LD R3, GASaveR3
                LD R4, GASaveR4
                JMP R7
                TRAP x25
GASaveR1        .BLKW #1
GASaveR2        .BLKW #1
GASaveR3        .BLKW #1
GASaveR4        .BLKW #1
Gridstart       .FILL x40A4
LineLength      .FILL #18

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID  ST R0, IVsaveR0
                ST R1, IVsaveR1
                LD R1, i
                ADD R2, R0, R1 
                BRn outRange ; checks if the move is not in range of ijkl values
                LD R1, l
                ADD R2, R0, R1 
                BRp outRange ; checks if move is not in range of ijkl values
                AND R2, R2, #0
                BR DoneIV
outRange        AND R2, R2, #0
                ADD R2, R2, #-1; sets R2 to -1 for invalid input
DoneIV          LD R0, IVsaveR0
                LD R1, IVsaveR1
                JMP R7
i               .FILL x-69
j               .FILL x-6A
k               .FILL x-6B
l               .FILL x-6C
IVsaveR0        .BLKW x1
IVsaveR1        .BLKW x1

;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************

SAFE_MOVE   ST R0, SMsaveR0
            ST R3, SMsaveR3
            LD R1, CURRENT_ROW ; puts current simba row in R1
            LD R2, CURRENT_COL ; puts simba current col in R2
            LD R3, i
            ADD R3, R3, R0 
            BRnp notI ; checks if R0 is i
            ADD R1, R1, #-1 ; shift up
            BR isSafe
notI        LD R3, j; puts j hex into R3
            ADD R3, R3, R0 
            BRnp notJ ; checks if R0 is j
            ADD R2, R2, #-1 ; shift left
            BR isSafe
notJ        LD R3, k; puts i hex into R3
            ADD R3, R3, R0 
            BRnp notK ; checks if R0 is k
            ADD R1, R1, #1 ; shift down
            BR isSafe
notK        ADD R2, R2, #1 ;R0 is l so shift right
isSafe      BRzp isSafe2 ; checks if the shift moved the row or column to be negative
            AND R1, R1, #0
            ADD R1, R1, #-1
            BR DoneSM
isSafe2     AND R3, R3, #0
            ADD R3, R3 #-8
            ADD R0, R3, R1 ; subtract 8 from the row to check if its out of bounds
            BRnp isSafe3
            AND R1, R1, #0
            ADD R1, R1, #-1
            BR DoneSM
isSafe3     ADD R0, R3, R2 ; subtracts 8 from the column number to check if out of bounds
            BRnp isSafe4
            AND R1, R1, #0
            ADD R1, R1, #-1
            BR DoneSM
isSafe4     ST R7, SMSaveR7
            JSR GRID_ADDRESS
            LD R7, SMSaveR7
            LDR R3, R0, #0 ; puts contents of grid at the new row and column into R3
            LD R0, Hyena ; puts hex of # symbol x23 in R0
            ADD R3, R3, R0  
            BRnp DoneSM ; checks if hyena is in location
            AND R1, R1, #0
            ADD R1, R1, #-1
DoneSM      LD R0, SMsaveR0
            LD R3, SMsaveR3
            JMP R7
Hyena       .FILL x-23
SMsaveR0    .BLKW #1
SMsaveR3    .BLKW #1
SMsaveR7    .BLKW #1

;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|�s and -�s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE  ST R0, AMsaveR0
            ST R1, AMsaveR1
            ST R2, AMsaveR2
            ST R3, AMsaveR3
            ST R4, AMsaveR4
            ST R5, AMsaveR5
            ST R7, AMsaveR7
            LD R3, CURRENT_ROW 
            LD R4, CURRENT_COL
            JSR SAFE_MOVE
            ADD R1, R1, #0
            BRn Unsafe
            ST R1, CURRENT_ROW 
            ST R2, CURRENT_COL
            JSR GRID_ADDRESS
            LD R2, Asterick
            STR R2, R0, #0
            ADD R1, R3, #0
            ADD R2, R4, #0
            JSR GRID_ADDRESS
            LD R3, Space
            STR R3, R0, #0
            LD R1, eighteen
            LD R2, eighteen 
            NOT R1, R1
            ADD R1, R1, #1
            LD  R0, AMsaveR0
            LD R3, i
            ADD R3, R3, R0 
            BRnp notI2 
            ADD R0, R2, R0
            BR finished
notI2       LD R3, j
            ADD R3, R3, R0 
            BRnp notJ2 
            ADD R0, R0, #-1 
            BR finished
notJ2       LD R3, k
            ADD R3, R3, R0 
            BRnp notK2 
            ADD R0, R1, R0 
            BR finished
notK2       ADD R0, R0, #1 ; its l so R0-1
finished    LD R1, space ; puts space ascii in R1
            STR R1, R0, #0; puts space in address to get rid of wall
            
AMRet       LD R7, AMsaveR7
            LD R0, AMsaveR0
            LD R1, AMsaveR1
            LD R2, AMsaveR2
            LD R3, AMsaveR3
            LD R4, AMsaveR4
            LD R5, AMsaveR5
            JMP R7
Unsafe      LEA R0, ErrorMess
            TRAP x22
            BR AMRet
            
eighteen    .FILL #18
ErrorMess   .STRINGZ "\n\nUnsafe Move.\n"
AMsaveR0    .BLKW #1
AMsaveR1    .BLKW #1
AMsaveR2    .BLKW #1    
AMsaveR3    .BLKW #1
AMsaveR4    .BLKW #1    
AMsaveR5    .BLKW #1
AMsaveR7    .BLKW #1

            
;***********************************************************
; IS_SIMBA_HOME
; Checks to see if the Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
; 
;***********************************************************

IS_SIMBA_HOME   ST R0, SHsaveR0
                ST R1, SHsaveR1
                ST R3, SHsaveR3
                LDI R0, CurrentRowLOC
                LDI R1, CurrentColLOC
                LDI R2, HomeRowLOC
                LDI R3, HomeColLOC
                NOT R0, R0
                ADD R0, R0, #1 ; make current row negative 
                ADD R0, R2, R0 ; R2 - R0
                BRnp notHome
                NOT R1, R1
                ADD R1, R1, #1 ; make current col negative
                ADD R1, R1, R3 ; R3 -R1
                BRnp notHome
                AND R2, R2, #0; clear R2
                BR DoneSH
notHome         AND R2, R2, #0; clear R2
                ADD R2, R2, #-1; makes R2 be -1 for not home
DoneSH          LD R0, SHsaveR0
                LD R1, SHsaveR1
                LD R3, SHsaveR3
                JMP R7  
CurrentRowLOC   .FILL x41D6
CurrentColLOC   .FILL x41D7
HomeRowLOC      .FILL x41D8
HomeColLOC      .FILL x41D9
SHsaveR0        .BLKW #1
SHsaveR1        .BLKW #1
SHsaveR3        .BLKW #1

                .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)
	.ORIG	x5000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
	.FILL   #1
    .FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END
