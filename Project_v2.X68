
*-----------------------------------------------------------
* Title      :  ECE 441 Monitor Project
* Written by :  Andrew Mustea
* Date       :  11/30/2017
* Description:  
*-----------------------------------------------------------
    
* Set Strings in Memory

    ORG     $2500
CR          EQU     $0D             ; Set carriage return
LF          EQU     $0A             ; Set line feed
BUS         EQU     $5000
  
monitorString   DC.B    'MONITOR441> ',0                                        ; Load all messages
exitingString   DC.B    'Exiting',CR,LF,0                       
unknownString   DC.B    'Invalid Command, try using "HELP"',CR,LF,0
carriageReturn  DC.B    '',CR,LF,0
spaceString     DC.B    '    ',0
questionString  DC.B    '?',0
memtestString   DC.B    'Memory Test Passes',CR,LF,0
bschpassString  DC.B    'BSCH Passes',CR,LF,0
bschfailString  DC.B    'BSCH Fails',CR,LF,0

helpString      DC.B    'HELP',0        ; Command strings
mdspString      DC.B    'MDSP',0
sortwString     DC.B    'SORTW',0
mmString        DC.B    'MM',0
msString        DC.B    'MS',0
bfString        DC.B    'BF',0
bmovString      DC.B    'BMOV',0
btstString      DC.B    'BTST',0
bschString      DC.B    'BSCH',0
goString        DC.B    'GO',0
dfString        DC.B    'DF',0
exitString      DC.B    'EXIT',0
bswtchString    DC.B    'BSWTCH',0
s2hString       DC.B    'S2H',0

d0String        DC.B    'D0=',0
d1String        DC.B    'D1=',0
d2String        DC.B    'D2=',0
d3String        DC.B    'D3=',0
d4String        DC.B    'D4=',0
d5String        DC.B    'D5=',0
d6String        DC.B    'D6=',0
d7String        DC.B    'D7=',0
a0String        DC.B    'A0=',0
a1String        DC.B    'A1=',0
a2String        DC.B    'A2=',0
a3String        DC.B    'A3=',0
a4String        DC.B    'A4=',0
a5String        DC.B    'A5=',0
a6String        DC.B    'A6=',0
a7String        DC.B    'A7=',0


busException    DC.B    'Bus Error Exception',CR,LF,0               ; Exception Strings
adrException    DC.B    'Address Error Exception',CR,LF,0
illException    DC.B    'Illegal Instruction Exception',CR,LF,0
divException    DC.B    'Divide by Zero Exception',CR,LF,0
chkException    DC.B    'CHK_INST Exception',CR,LF,0
privException   DC.B    'Privledge Violation Exception',CR,LF,0
lineaException  DC.B    'Line A Exception',CR,LF,0
linefException  DC.B    'Line F Exception',CR,LF,0


; Help message that displays when "HELP" is typed
helpMessage     DC.B    'HELP: Displays this message',CR,LF,CR,LF                                           
                DC.B    'MDSP: Outputs Address And Memory Contents',CR,LF
                DC.B    'MDSP <address1> <address2> eq: MDSP $908 $90A<CR>',CR,LF,CR,LF
                DC.B    'SORTW: Sorts A Block Of Memory',CR,LF
                DC.B    'Default: Descending Order',CR,LF
                DC.B    ';A: Ascending Order',CR,LF
                DC.B    ';D: Decending Order',CR,LF
                DC.B    'SORTW <address1> <address2>[;order] eg: SORTW $904 $908 475A;A<CR>',CR,LF,CR,LF
                DC.B    'MM: Modifies Data In Memory',CR,LF
                DC.B    'Default: Displays Bytes',CR,LF
                DC.B    ';B: Displays One Byte',CR,LF
                DC.B    ';W: Displays One Word',CR,LF
                DC.B    ';L: Displays One Long Word',CR,LF
                DC.B    'Enter "." to exit back to monitor',CR,LF
                DC.B    'MM <address>[;size] eg: MCHG $904;W<CR>',CR,LF,CR,LF
                DC.B    'MS: Set data into the address specified',CR,LF
                DC.B    'Default: Hexadecimal',CR,LF
                DC.B    ';H: Hexadecimal',CR,LF
                DC.B    ';S: String',CR,LF
                DC.B    'MS <address>[;input type] <data> eg: MS $1000;H 33',CR,LF,CR,LF
                DC.B    'BF: Fills A Block Of Memory',CR,LF
                DC.B    'BF <address1> <address2> <word> eg: BFILL $904 $908 475A<CR>',CR,LF,CR,LF
                DC.B    'BMOV: Moves A Block Of Memory To Another Area',CR,LF
                DC.B    'BMOV <address1> <address2> <address3> eg: BMOV $908 $90B $909<CR>',CR,LF,CR,LF
                DC.B    'BTST: Tests a block of memory for memory problems',CR,LF
                DC.B    'BTST <address1> <address2> eg: BTST $908 $90B',CR,LF,CR,LF                  
                DC.B    'BSCH: Searches For A Literal String In The Memory',CR,LF
                DC.B    'BSCH <address1> <address2> "literal string" eq: BSCH $900 $908 475A<CR>',CR,LF,CR,LF
                DC.B    'GO: Starts Execution From a Given Address',CR,LF
                DC.B    'GO <address> eg: GO $900<CR>',CR,LF,CR,LF
                DC.B    'DF: Displays Formated Registers',CR,LF,CR,LF
                DC.B    'EXIT: Exit the monitor program eg: EXIT<CR>',CR,LF,CR,LF
                DC.B    'BSWTCH: Switch two blocks of memory',CR,LF
                DC.B    'BSWTCH <address1> <address2> <address3> eg: BSWTCH $908 $90B $909<CR>',CR,LF,CR,LF
                DC.B    'S2H: Convert Hex byte to String',CR,LF
                DC.B    'S2H <address1> eg: S2H $908<CR>',CR,LF,0


    ORG     $1000
START:
            MOVEA.L #$3000,A7           ; Set stack

            MOVEM.L D0-D7,-(A7)         ; Store registers
            MOVEM.L A0-A7,-(A7)            

            MOVEA.L #$2000,A2           ; A2 holds the input           

* Exception Vectors

            MOVE.L  #BUS_ERR,$8
            MOVE.L  #ADS_ERR,$C
            MOVE.L  #IL_INST,$10
            MOVE.L  #DIV_Z,$14
            MOVE.L  #CHK_INST,$18
            MOVE.L  #PRI_VIO,$20
            MOVE.L  #LINE_A,$28
            MOVE.L  #LINE_F,$2C
            
            
*-----------------------------------------------------------
* Monitor
*-----------------------------------------------------------

MONITOR     LEA     monitorString,A1    ; Print command line
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEA.L A2,A1               ; Get input from command line
            MOVE.B  #2,D0
            TRAP    #15

            CLR.L   D1                  ; D1 will be the character counter
            
OMIT_SPACES CMPI.B  #$20,(A2)           ; Check for leading spaces
            BNE     STORE_VAL
            ADDA.L  #1,A2               ; If found increment the input pointer and go back to check for more
            BRA     OMIT_SPACES
            
STORE_VAL   MOVE.L  A2,D2               ; D2 stores the input pointer with omitted preceding spaces
            
READ_LINE   ADDQ.L  #1,D1               ; Increment counter
            CMPI.B  #8,D1
            BGT     UNKNOWN             ; Check if counter is over 8, if so go to UNKNOWN
            CMPI.B  #$00,(A2)           
            BEQ     PARSE_HELP          ; Check if end of string, if so go to command parsing
            CMPI.B  #$20,(A2)       
            BEQ     PARSE_HELP          ; Check if theres a space, if so go to command parsing
            ADDA.L  #1,A2
            BRA     READ_LINE           ; Increment the string and read the next character at READ_LINE
            
*-----------------------------------------------------------            
* Command Parsing
*-----------------------------------------------------------

* HELP Parsing

PARSE_HELP  ADDA.L  #1,A2
            LEA     helpString,A3       ; Load the help string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
HELP_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_MDSP          ; If the characters dont match, move to the next parser
            CMPI.B  #4,D1
            BLE     HELP_LOOP
            BRA     HELP                ; Go to the help subroutine
            
            
* MDSP Parsing

PARSE_MDSP  LEA     mdspString,A3       ; Load the mdsp string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
MDSP_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_SORTW         ; If the characters dont match, move to the next parser
            CMPI.B  #4,D1
            BEQ     MDSP                ; Go to the MDSP subroutine if length matches
            BRA     MDSP_LOOP           ; Branch back to MDSP_LOOP
            
            
* SORTW Parsing
            
PARSE_SORTW LEA     sortwString,A3      ; Load the sortw string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
SORTW_LOOP  ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_MM            ; If the characters dont match, move to the next parser
            CMPI.B  #5,D1
            BEQ     SORTW               ; Go to the SORTW subroutine if length matches 
            BRA     SORTW_LOOP          ; Branch back to SORTW_LOOP        


* MM Parsing   
            
PARSE_MM    LEA     mmString,A3         ; Load the mm string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
MM_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_MS            ; If the characters dont match, move to the next parser
            CMPI.B  #2,D1
            BEQ     MM                  ; Go to the MM subroutine if length matches 
            BRA     MM_LOOP             ; Branch back to MM_LOOP
            
            
* MS Parsing            
            
PARSE_MS    LEA     msString,A3         ; Load the ms string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
MS_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_BF            ; If the characters dont match, move to the next parser
            CMPI.B  #2,D1
            BEQ     MS                  ; Go to the MS subroutine if length matches 
            BRA     MS_LOOP             ; Branch back to MS_LOOP
            
            
* BF Parsing
            
PARSE_BF    LEA     bfString,A3         ; Load the bf string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
BF_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_BMOV          ; If the characters dont match, move to the next parser
            CMPI.B  #2,D1
            BEQ     BF                  ; Go to the BF subroutine if length matches 
            BRA     BF_LOOP             ; Branch back to BF_LOOP
            
            
* BMOV Parsing
            
PARSE_BMOV  LEA     bmovString,A3       ; Load the bmov string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
BMOV_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_BTST          ; If the characters dont match, move to the next parser
            CMPI.B  #4,D1
            BEQ     BMOV                ; Go to the BMOV subroutine if length matches 
            BRA     BMOV_LOOP           ; Branch back to BMOV_LOOP
            
            
* BTST Parsing
            
PARSE_BTST  LEA     btstString,A3       ; Load the btst string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
BTST_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_BSCH          ; If the characters dont match, move to the next parser
            CMPI.B  #4,D1
            BEQ     BTST                ; Go to the BTST subroutine if length matches 
            BRA     BTST_LOOP           ; Branch back to BTST_LOOP
            
            
* BSCH Parsing
            
PARSE_BSCH  LEA     bschString,A3       ; Load the bsch string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
BSCH_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_GO            ; If the characters dont match, move to the next parser
            CMPI.B  #4,D1
            BEQ     BSCH                ; Go to the BTST subroutine if length matches 
            BRA     BSCH_LOOP           ; Branch back to BSCH_LOOP
           
 
* GO Parsing

PARSE_GO    LEA     goString,A3         ; Load the go string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
GO_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_DF            ; If the characters dont match, move to the next parser
            CMPI.B  #2,D1
            BEQ     GO                  ; Go to the GO subroutine if length matches 
            BRA     GO_LOOP             ; Branch back to GO_LOOP
            
            
* DF Parsing
            
PARSE_DF    LEA     dfString,A3         ; Load the df string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
DF_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_EXIT          ; If the characters dont match, move to the next parser
            CMPI.B  #2,D1
            BEQ     DF                  ; Go to the DF subroutine if length matches 
            BRA     DF_LOOP             ; Branch back to DF_LOOP
            
            
* EXIT Parsing
            
PARSE_EXIT  LEA     exitString,A3       ; Load the exit string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
EXIT_LOOP   ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_BS            ; If the characters dont match, move 
            CMPI.B  #4,D1
            BEQ     EXIT                ; Go to the EXIT subroutine if length matches 
            BRA     EXIT_LOOP           ; Branch back to EXIT_LOOP
            
            
* BSWTCH Parsing

PARSE_BS    LEA     bswtchString,A3     ; Load the exit string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
BS_LOOP     ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     PARSE_S2H           ; If the characters dont match, move
            CMPI.B  #5,D1
            BEQ     BSWTCH              ; Go to the subroutine if length matches 
            BRA     BS_LOOP             ; Branch back 

* S2H Parsing

PARSE_S2H   LEA     s2hString,A3        ; Load the exit string to be compared to
            MOVEA.L D2,A4   
            CLR.L   D1                  ; Set counter to 0
S2H_LOOP    ADDQ.L  #1,D1               ; Increment counter
            CMPM.B  (A3)+,(A4)+
            BNE     UNKNOWN             ; If the characters dont match, move
            CMPI.B  #3,D1
            BEQ     S2H                 ; Go to the subroutine if length matches 
            BRA     S2H_LOOP            ; Branch back             
            
* UNKNOWN

UNKNOWN     LEA     unknownString,A1    ; Can't understand command, try again
            MOVE.B  #14,D0
            TRAP    #15
            
UNKWN_LOOP  CMPI.B  #$FF,(A2)           ; Make sure that the A2 value isnt overrighting any values
            BEQ     MONITOR
            ADDA.L  #1,A2
            BRA     UNKWN_LOOP
            
            
*-----------------------------------------------------------            
* Command Subroutines
*-----------------------------------------------------------

* HELP            

HELP        LEA     helpMessage,A1      ; Print help message
            MOVE.B  #14,D0
            TRAP    #15
            BRA     MONITOR             ; Return to monitor
            
            
* MDSP
            
MDSP        MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #4,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 and D4 will hold the addresses
            CLR.L   D4
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
MDSP_ADR1   CMPI.B  #$00,(A2)           ; If end of string, go to MDSP_16
            BEQ     MDSP_16
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to MDSP_NEXT
            BEQ     MDSP_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     MDSP_ADR1           ; Branch back to MDSP_ADR1
            
MDSP_NEXT   ADDA.L  #1,A2             
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
MDSP_ADR2   CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to MDSP_PRINT
            BEQ     MDSP_PRINT
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     MDSP_ADR2           ; Branch back to MDSP_ADR2
            
MDSP_16     ADDA.L  #1,A2               ; If only one address was provided, output the next 16 bits after the first address
            MOVE.L  D3,D4
            ADDI.L  #16,D4

MDSP_PRINT  MOVEA.L D3,A3               ; Store the value in D3 to A3 so we can get the stored values
            CMP     A3,D4               ; Check if D4 is larger than A3
            BLT     UNKNOWN             ; If not, go to UNKNOWN
            
MDSP_READ   MOVE.L  #15,D0              ; Print the address in base 16
            MOVE.L  A3,D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     spaceString,A1      ; Print spaces
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.L  #15,D0
            CLR.L   D1                  ; Print the contents at (A3) and increment
            MOVE.B  (A3)+,D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            CMP     A3,D4
            BEQ     MONITOR             ; If A3 reaches D4, go back to MONITOR
            BRA     MDSP_READ           ; Else, return to MDSP_READ
            
            
* SORTW

SORTW       MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #5,A2               ; Add 5 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 and D4 will hold the addresses
            CLR.L   D4
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
SORTW_ADR1  CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to SORTW_NEXT
            BEQ     SORTW_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     SORTW_ADR1           ; Branch back to SORTW_ADR1
            
SORTW_NEXT  ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN
            
SORTW_ADR2  CMPI.B  #$3B,(A2)           ; Check if there is a semi-colon, if so go to SORTW_ORDR
            BEQ     SORTW_ORDR
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to SORTW_DSCND
            BEQ     SORTW_AUTO
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     SORTW_ADR2          ; Branch back to SORTW_ADR2
            
SORTW_ORDR  ADDA.L  #1,A2
            CMPI.B  #$41,(A2)           ; If the desired order letter is A
            BEQ     SORTW_ASCND         ; Branch to SORTW_ASCND
            CMPI.B  #$44,(A2)           ; If the desired order letter is D
            BEQ     SORTW_DSCND         ; Branch to SORTW_DSCND
            BRA     UNKNOWN             ; Else go to UNKNOWN
            
            
SORTW_ASCND ADDA.L  #1,A2               ; Begin bubble sort in ascending order
            CMPI.B  #$00,(A2)           ; Check if end of command
            BNE     UNKNOWN             ; If not, go to UNKNOWN
            
            CLR.L   D1                  ; D1 = i
            CLR.L   D7                  ; D7 = temp
            MOVE.L  D4,D0
            SUB.L   D3,D0               
            SUBQ.L  #2,D0               ; D0 = n-2
            
SORTW_ASC1  CLR.L   D2                  ; D2 = j = 0
            MOVE.L  D0,D5               ; D5 = n-i-2
            SUB     D1,D5
            
            CMP.L   D1,D0               ; for (int i=0; i<n-1; i++)
            BGE     SORTW_ASC2          
            BRA     MONITOR             ; end of sort
            
SORTW_BACKA ADDI.L  #2,D1
            BRA     SORTW_ASC1
               
SORTW_ASC2  CMP.L   D2,D5               ; for (int j=0; j<n-i-1; i++)
            BLT     SORTW_BACKA
            
            MOVEA.L D2,A3               ; Compare
            MOVEA.L D2,A4               
            ADDA.L  #2,A4
            ADDA.L  D3,A3               ; A3
            ADDA.L  D3,A4               ; A4 = A3+2
            MOVE.W  (A4),D7
            CMP.W   (A3),D7
            BGE     SORTW_AL2
            MOVE.W  (A3),(A4)
            MOVE.W  D7,(A3)
            
SORTW_AL2   ADDI.L  #2,D2               ; j++
            BRA     SORTW_ASC2             
            
SORTW_DSCND ADDA.L  #1,A2               ; Begin bubble sort in descending order
            CMPI.B  #$00,(A2)           ; Check if end of command
            BNE     UNKNOWN             ; If not, go to UNKNOWN
            
SORTW_AUTO  MOVE.L  D4,D0
            SUB.L   D3,D0               
            SUBQ.L  #2,D0               ; D0 = n-2
            CLR.L   D1                  ; D1 = i
            CLR.L   D7                  ; D7 = temp

SORTW_DSC1  CLR.L   D2                  ; D2 = j = 0
            MOVE.L  D0,D5               ; D5 = n-i-2
            SUB     D1,D5
            
            CMP.L   D1,D0               ; for (int i=0; i<n-1; i++)
            BGE     SORTW_DSC2          
            BRA     MONITOR             ; end of sort

SORTW_BACKD ADDI.L  #2,D1
            BRA     SORTW_DSC1

SORTW_DSC2  CMP.L   D2,D5               ; for (int j=0; j<n-i-1; i++)
            BLT     SORTW_BACKD
            
            MOVEA.L D2,A3               ; Compare
            MOVEA.L D2,A4               
            ADDA.L  #2,A4
            ADDA.L  D3,A3               ; A3
            ADDA.L  D3,A4               ; A4 = A3+2
            MOVE.W  (A4),D7
            CMP.W   (A3),D7
            BLE     SORTW_DL2
            MOVE.W  (A3),(A4)
            MOVE.W  D7,(A3)

SORTW_DL2   ADDI.L  #2,D2               ; j++
            BRA     SORTW_DSC2  


* MM

MM          MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #2,A2               ; Add 2 to A2 to start reading the addresses
            
            CLR.L   D3                  ; D3 will hold the address
            CLR.L   D5                  ; D5 holds the increment amount
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

MM_ADR      CMPI.B  #$00,(A2)           ; If end of string, go to MM_NEXT
            BEQ     MM_BYTE
            CMPI.B  #$3B,(A2)           ; Check if theres a space. If so, go to MM_NEXT
            BEQ     MM_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D4
            SUBI.L  #$30,D4                            
            ADD.B   D4,D3               
            BRA     MM_ADR              ; Branch back to MM_ADR
            
MM_NEXT     ADDA.L  #1,A2
            CMPI.B  #$42,(A2)           ; Check if byte (B)
            BEQ     MM_BYTE
            CMPI.B  #$57,(A2)           ; Check if word (W)
            BEQ     MM_WORD
            CMPI.B  #$4C,(A2)           ; Check if longword (L)
            BEQ     MM_LONG
            BRA     UNKNOWN             ; Go to UNKNOWN, can't understand input
            
MM_BYTE     ADDA.L  #2,A2               ; Increment to next location
            MOVEA.L D3,A3
            
MM_BLOOP    MOVE.L  #15,D0              ; Print the address in base 16
            MOVE.L  A3,D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     spaceString,A1      ; Print spaces
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.L  #15,D0
            CLR.L   D1                  ; Print the contents at (A3)
            MOVE.B  (A3),D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     questionString,A1   ; Print question mark
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEA.L A2,A1               ; Get input from command line
            MOVE.B  #2,D0
            TRAP    #15
                        
            CMPI.B  #$2E,(A2)           ; If '.' is inputted, go back to MONITOR
            BEQ     MONITOR   
            
            CLR.L   D6                  ; D6 will be the counter for reading
            CLR.L   D5                  ; D5 will be a temporary holder
            CLR.L   D7                  ; D7 will hold the value
MM_BREAD    CMPI.B  #$00,(A2)           ; If the end of the string, go to MM_BWRITE
            BEQ     MM_BWRITE
            CMPI.L  #2,D6               ; If the counter has reached 2, jump to MM_BWRITE
            BEQ     MM_BWRITE        
            ROL.L   #4,D7
            MOVE.B  (A2)+,D5            ; D5 holds the temporary value
            
            CMPI.B  #$41,D5             ; Convert to hex with numbers 0-9, or letters A-F
            BLT     MM_BNUM
            SUBI.B  #55,D5              
            BRA     MM_BHEX

MM_BNUM     SUBI.B  #$30,D5             ; D5 coverts to hex for integers

MM_BHEX     ADD.B   D5,D7               ; D7 holds the final value and shifts when a new value is entered
            ADDQ.L  #1,D6
            BRA     MM_BREAD            ; Branch back to MM_BREAD
            
MM_BWRITE   MOVE.B  D7,(A3)             ; Store the read value in memory
            
MM_BINC     ADDA.L  #1,A2
            ADDA.L  #1,A3               ; Increment by a byte and go back to MM_BLOOP
            BRA     MM_BLOOP
            

MM_WORD     ADDA.L  #2,A2               ; Increment to next location    
            MOVEA.L D3,A3
         
MM_WLOOP    MOVE.L  A2,D2               ; Check if address is even
            ANDI.L  #1,D2               ; If not, add 1
            BEQ     MM_WEVEN            ; Else skip to MM_WEVEN
            ADDA.L  #1,A2
            
MM_WEVEN    MOVE.L  #15,D0              ; Print the address in base 16
            MOVE.L  A3,D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     spaceString,A1      ; Print spaces
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.L  #15,D0
            CLR.L   D1                  ; Print the contents at (A3)
            MOVE.W  (A3),D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     questionString,A1   ; Print question mark
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEA.L A2,A1               ; Get input from command line
            MOVE.B  #2,D0
            TRAP    #15
                        
            CMPI.B  #$2E,(A2)           ; If '.' is inputted, go back to MONITOR
            BEQ     MONITOR   
            
            CLR.L   D6                  ; D6 will be the counter for reading
            CLR.L   D5                  ; D5 will be a temporary holder
            CLR.L   D7                  ; D7 will hold the value
MM_WREAD    CMPI.B  #$00,(A2)         ; If the end of the string, go to MM_WWRITE
            BEQ     MM_WWRITE
            CMPI.L  #4,D6               ; If the counter has reached 4, jump to MM_WWRITE
            BEQ     MM_WWRITE        
            ROL.L   #4,D7
            MOVE.B  (A2)+,D5            ; D5 holds the temporary value       
            CMPI.B  #$41,D5             ; Convert to hex with numbers 0-9, or letters A-F
            BLT     MM_WNUM
            SUBI.B  #55,D5              
            BRA     MM_WHEX
MM_WNUM     SUBI.B  #$30,D5             ; D5 coverts to hex for integers
MM_WHEX     ADD.B   D5,D7               ; D7 holds the final value and shifts when a new value is entered
            ADDQ.L  #1,D6
            BRA     MM_WREAD            ; Branch back to MM_WREAD
            
MM_WWRITE   MOVE.W  D7,(A3)             ; Store the read value in memory
            
MM_WINC     ADDA.L  #2,A2
            ADDA.L  #2,A3               ; Increment by a word and go back to MM_WLOOP
            BRA     MM_WLOOP


MM_LONG     ADDA.L  #2,A2               ; Increment to next location    
            MOVEA.L D3,A3
         
MM_LLOOP    MOVE.L  A2,D2               ; Check if address is even
            ANDI.L  #1,D2               ; If not, add 1
            BEQ     MM_LEVEN            ; Else skip to MM_LEVEN
            ADDA.L  #1,A2

MM_LEVEN    MOVE.L  #15,D0              ; Print the address in base 16
            MOVE.L  A3,D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     spaceString,A1      ; Print spaces
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.L  #15,D0
            CLR.L   D1                  ; Print the contents at (A3)
            MOVE.L  (A3),D1
            MOVE.L  #16,D2
            TRAP    #15
            
            LEA     questionString,A1   ; Print question mark
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEA.L A2,A1               ; Get input from command line
            MOVE.B  #2,D0
            TRAP    #15
                        
            CMPI.B  #$2E,(A2)           ; If '.' is inputted, go back to MONITOR
            BEQ     MONITOR   
            
            CLR.L   D6                  ; D6 will be the counter for reading
            CLR.L   D5                  ; D5 will be a temporary holder
            CLR.L   D7                  ; D7 will hold the value
MM_LREAD    CMPI.B  #$00,(A2)           ; If the end of the string, go to MM_LWRITE
            BEQ     MM_LWRITE
            CMPI.L  #8,D6               ; If the counter has reached 8, jump to MM_LWRITE
            BEQ     MM_LWRITE        
            ROL.L   #4,D7
            MOVE.B  (A2)+,D5            ; D5 holds the temporary value       
            CMPI.B  #$41,D5             ; Convert to hex with numbers 0-9, or letters A-F
            BLT     MM_LNUM
            SUBI.B  #55,D5              
            BRA     MM_LHEX
MM_LNUM     SUBI.B  #$30,D5             ; D5 coverts to hex for integers
MM_LHEX     ADD.B   D5,D7               ; D7 holds the final value and shifts when a new value is entered
            ADDQ.L  #1,D6
            BRA     MM_LREAD            ; Branch back to MM_LREAD
            
MM_LWRITE   MOVE.L  D7,(A3)             ; Store the read value in memory
           
MM_LINC     ADDA.L  #4,A2
            ADDA.L  #4,A3               ; Increment by a longword and go back to MM_WLOOP
            BRA     MM_LLOOP          


*MS

MS          MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #2,A2               ; Add 2 to A2 to start reading the addresses
            
            CLR.L   D3                  ; D3 will hold the address
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

MS_ADR      CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; If theres a space, go to MS_SKIP
            BEQ     MS_SKIP
            CMPI.B  #$3B,(A2)           ; Check if theres a space. If so, go to MS_NEXT
            BEQ     MS_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D4
            SUBI.L  #$30,D4                                    
            ADD.B   D4,D3               
            BRA     MS_ADR              ; Branch back to MS_ADR

MS_NEXT     ADDA.L  #1,A2
            CMPI.B  #$48,(A2)           ; Check if hex
            BEQ     MS_HEX
            CMPI.B  #$53,(A2)           ; Check if string
            BEQ     MS_STR
            BRA     UNKNOWN             ; If none of the above go to UNKNOWN             

MS_SKIP     SUBA.L  #1,A2               ; Decrement A2 before moving on 
            
MS_HEX      ADDA.L  #2,A2
            MOVEA.L D3,A3               ; A3 will be the address written to
            CLR.L   D5                  ; D5 will hold the temporary byte value
            CLR.L   D6                  ; D6 will be the counter
            
MS_HLOOP    CMPI.B  #$00,(A2)           ; If end of string. If so, go to MONITOR
            BEQ     MONITOR
            CMPI.L  #2,D6               ; If D6 reaches 2 continue, otherwise skip to MS_HNEXT
            BNE     MS_HNEXT
            CLR.L   D5                  ; Clear D5
            CLR.L   D6                  ; Clear D6
            ADDA.L  #1,A3               ; Increment A3
MS_HNEXT    MOVE.B  (A2)+,D4            
            SUBI.L  #$30,D4 
            ROL.L   #4,D5 
            ADD.B   D4,D5
            MOVE.B  D5,(A3)
            ADDI.L  #1,D6
            BRA     MS_HLOOP            ; Branch back to MS_HLOOP
            

MS_STR      ADDA.L  #2,A2
            MOVEA.L D3,A3               ; A3 will be the address written to

MS_SLOOP    CMPI.B  #$00,(A2)           ; If end of string. If so, go to MONITOR
            BEQ     MONITOR
            MOVE.B  (A2)+,(A3)+         ; Move the value in (A3) and increment both  
            BRA     MS_SLOOP            ; Branch back to MS_HLOOP         


* BF

BF          MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #2,A2               ; Add 2 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 and D4 will hold the addresses
            CLR.L   D4
            CLR.L   D7                  ; D7 will hold the word value
            CLR.L   D6                  ; D6 will be the counter
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
BF_ADR1     CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to BF_NEXT
            BEQ     BF_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     BF_ADR1             ; Branch back to BF_ADR1
            
BF_NEXT     ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN
            
BF_ADR2     CMPI.B  #$20,(A2)           ; Check if there is a space, if so go to BF_NEXT2
            BEQ     BF_NEXT2
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to UNKNOWN
            BEQ     UNKNOWN 
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     BF_ADR2             ; Branch back to BF_ADR2
            
BF_NEXT2    ADDA.L  #1,A2      

BF_VALUE    CMPI.L  #$4,D6              ; If end of word, go to BF_NEXT2
            BEQ     BF_NEXT3
            CMPI.B  #$00,(A2)           ; If end of line, go to BF_NEXT2
            BEQ     BF_NEXT3
            ROL.L   #4,D7               ; Shift D7 to the left
            CLR.L   D5 
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                         
            ADD.B   D5,D7               ; Move shifted hex value into D7
            ADDQ.L  #1,D6
            BRA     BF_VALUE            ; Branch back to BF_VALUE


BF_NEXT3    MOVEA.L D3,A3               ; Move addresses into A3 and A4
            MOVEA.L D4,A4
            
            ANDI.L  #1,D3               ; Check if D3 is even
            BNE     UNKNOWN
            ANDI.L  #1,D4               ; Check if D4 is even
            BNE     UNKNOWN      
            CMPA.L  A3,A4               ; If A4 is less than A3, go to UNKNOWN
            BLT     UNKNOWN
            
BF_WRITE    CMPA.L  A3,A4               ; If A3 reaches the end, go back to MONITOR
            BLT     MONITOR
            MOVE.W  D7,(A3)+            ; Move value into (A3) and increment
            BRA     BF_WRITE            ; Branch back to BF_WRITE

* BMOV

BMOV        MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #4,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3, D4, and D6 will hold the addresses
            CLR.L   D4
            CLR.L   D6

            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

BMOV_ADR1   CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to BMOV_NEXT
            BEQ     BMOV_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            CLR.L   D5
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     BMOV_ADR1           ; Branch back to BMOV_ADR1
            
BMOV_NEXT   ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN
            
BMOV_ADR2   CMPI.B  #$20,(A2)           ; Check if there is a space, if so go to BMOV_NEXT2
            BEQ     BMOV_NEXT2
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to UNKNOWN
            BEQ     UNKNOWN 
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     BMOV_ADR2           ; Branch back to BMOV_ADR2

BMOV_NEXT2  ADDA.L  #1,A2 
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN

BMOV_ADR3   CMPI.B  #$00,(A2)           ; Check if there is a space, if so go to BMOV_NEXT3
            BEQ     BMOV_MOVE
            ROL.L   #4,D6               ; Shift D6 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D6               
            BRA     BMOV_ADR3           ; Branch back to BMOV_ADR3

BMOV_MOVE   CMP.L   D3,D4               ; Check if the address range is valid
            BLT     UNKNOWN
            
            MOVEA.L D3,A3
            MOVEA.L D6,A6
            
BMOV_MLOOP  CMP.L   A3,D4               ; Reading from (A3), put the value into (A6)
            BLT     MONITOR
            MOVE.B  (A3)+,(A6)+
            BRA     BMOV_MLOOP


* BTST      

BTST        MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #4,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 and D4 will hold the addresses
            CLR.L   D4

            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
BTST_ADR1   CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to BTST_NEXT
            BEQ     BTST_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            CLR.L   D5
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     BTST_ADR1           ; Branch back to BTST_ADR1

BTST_NEXT   ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN

BTST_ADR2   CMPI.B  #$20,(A2)           ; Check if there is a space, if so go to BTST_TEST
            BEQ     BTST_TEST
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to UNKNOWN
            BEQ     BTST_TEST 
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     BTST_ADR2           ; Branch back to BTST_ADR2

BTST_TEST   CMP.L   D3,D4               ; Check if the address range is valid
            BLT     UNKNOWN
            MOVEA.L D3,A3
            
BTST_BLOOP  CMP.L   A3,D4               ; Read then write data from every location
            BLT     BTST_PASS
            MOVE.B  (A3),D5
            MOVE.B  D5,(A3)+
            BRA     BTST_BLOOP
            

BTST_PASS   LEA     memtestString,A1    ; Print bus exception
            MOVE.B  #14,D0
            TRAP    #15
            BRA     MONITOR

* BSCH       

BSCH        MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #4,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 and D4 will hold the addresses
            CLR.L   D4
            CLR.L   D6                  ; D6 will hold string length
            CLR.L   D7                  ; D7 will determine whether the search has passed or failed

            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

BSCH_ADR1   CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to BSCH_NEXT
            BEQ     BSCH_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            CLR.L   D5
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     BSCH_ADR1           ; Branch back to BSCH_ADR1
            
BSCH_NEXT   ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN
            
BSCH_ADR2   CMPI.B  #$20,(A2)           ; Check if there is a space, if so go to BSCH_NEXT2
            BEQ     BSCH_NEXT2
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to UNKNOWN
            BEQ     UNKNOWN 
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     BSCH_ADR2           ; Branch back to BSCH_ADR2
            
BSCH_NEXT2  ADDA.L  #1,A2              
            MOVEA.L D3,A3               ; A3 holds the starting block address
            MOVEA.L D4,A4               ; A4 holds the ending block address
            MOVEA.L A2,A5               ; A5 is the temporary string address
            
BSCH_STRING CMPI.B  #$00,(A5)           ; Check if end of command. If so, go to BSCH_NEXT3
            BEQ     BSCH_NEXT3            
            ADDA.L  #1,A5               ; Increment address
            ADDI.L  #1,D6               ; Increment counter
            BRA     BSCH_STRING
            
BSCH_NEXT3  CLR.L   D5                  ; D5 will be the counter
            MOVEA.L A2,A5               ; A5 is the temporary string address
            MOVE.B  (A5),D0             ; D0 holds first character

BSCH_SEARCH CMP.L   A3,D4               ; Check if upper bound is reached
            BLT     BSCH_DONE           ; If so, go to BSCH_DONE
            CMP.B   (A3)+,D0            ; Compare characters
            BEQ     BSCH_NEXT4          ; If a match is found, go to BSCH_NEXT4
            BRA     BSCH_SEARCH         ; Otherwise go back to BSCH_SEARCH
            
BSCH_NEXT4  MOVEA.L A3,A6               
            
BSCH_S2     CMP.L   D5,D6               ; See if the length has reached its bounds
            BEQ     BSCH_PASS           ; If it has, go to BSCH_PASS
            CMPM.B  (A6)+,(A5)+         ; Check each byte
            BNE     BSCH_SEARCH         ; If any dont match, go back to BSCH_SEARCH
            ADDI.L  #1,D5               ; Increment the counter
            BRA     BSCH_S2             ; Branch back to BSCH_S2
            
BSCH_PASS   LEA     bschpassString,A1   ; Load and print the passing message
            MOVE.B  #14,D0
            TRAP    #15

            MOVE.L  #1,D7               ; Store passing bit
            
            MOVE.L  #15,D0
            CLR.L   D1                  ; Print the contents at A6 and increment
            MOVE.L  A6,D1
            MOVE.L  #16,D2
            TRAP    #15

            
            BRA BSCH_SEARCH
            
BSCH_DONE   CMP.L   #1,D7               ; If the search passed then go to MONITOR
            BEQ     MONITOR
            
            LEA     bschfailString,A1   ; Load and print the fail message
            MOVE.B  #14,D0
            TRAP    #15
            
            BRA     MONITOR
            
* GO          

GO          MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #2,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 will hold the address

            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN
            
GO_ADR      CMPI.B  #$00,(A2)           ; If end of string, go to GO_NEXT
            BEQ     GO_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            CLR.L   D5
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     GO_ADR              ; Branch back to GO_ADR
  
GO_NEXT     MOVEA.L #$2FE0,A6
            MOVE.L  D3,(A6)             ; Put into $2FE0
            JSR     (A6)                ; Jump to location

* DF         

DF          MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D0,D1               ; Print the contents at D0
            LEA     d0String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7              
            LEA     d1String,A1         ; Print the contents at D1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D2,D1               ; Print the contents at D2
            LEA     d2String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D3,D1               ; Print the contents at D3
            LEA     d3String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D4,D1               ; Print the contents at D4
            LEA     d4String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D5,D1               ; Print the contents at D5
            LEA     d5String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D6,D1               ; Print the contents at D6
            LEA     d6String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  D7,D1               ; Print the contents at D7
            LEA     d7String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A0,D1               ; Print the contents at A0
            LEA     a0String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7        
            MOVE.L  A1,D1               ; Print the contents at A1      
            LEA     a1String,A1         
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A2,D1               ; Print the contents at A2
            LEA     a2String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A3,D1               ; Print the contents at A3
            LEA     a3String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A4,D1               ; Print the contents at A4
            LEA     a4String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A5,D1               ; Print the contents at A5
            LEA     a5String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A6,D1               ; Print the contents at A6
            LEA     a6String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D7         ; Read registers
            MOVEM.L (A7)+,A0-A7
            MOVE.L  A7,D1               ; Print the contents at A7
            LEA     a7String,A1     
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  D0,D1               
            MOVE.L  #15,D0
            CLR.L   D1                  
            MOVE.L  #16,D2
            TRAP    #15
            LEA     carriageReturn,A1   ; Complete a carriage return
            MOVE.B  #14,D0
            TRAP    #15

            BRA     MONITOR     


* BSWTCH       

BSWTCH      MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #6,A2               ; Add 4 to A2 to start reading the addresses
            CLR.L   D3                  ; D3, D4, and D6 will hold the addresses
            CLR.L   D4
            CLR.L   D6

            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

BSWTCH_ADR1 CMPI.B  #$00,(A2)           ; If end of string, go to UNKNOWN
            BEQ     UNKNOWN
            CMPI.B  #$20,(A2)           ; Check if theres a space. If so, go to next
            BEQ     BSWTCH_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            CLR.L   D5
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     BSWTCH_ADR1          ; Branch back 

BSWTCH_NEXT ADDA.L  #1,A2        
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN
            
BSWTCH_ADR2 CMPI.B  #$20,(A2)           ; Check if there is a space, if so go to next
            BEQ     BSWTCH_NEX2
            CMPI.B  #$00,(A2)           ; Check if end of command. If so, go to UNKNOWN
            BEQ     UNKNOWN 
            ROL.L   #4,D4               ; Shift D4 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D4               
            BRA     BSWTCH_ADR2         ; Branch back 

BSWTCH_NEX2 ADDA.L  #1,A2 
            CMPI.B  #$24,(A2)+          ; Check if second address leads with a $, if not, go to UNKNOWN
            BNE     UNKNOWN

BSWTCH_ADR3 CMPI.B  #$00,(A2)           ; Check if string ends, if so go to next
            BEQ     BSWTCH_SWAP
            ROL.L   #4,D6               ; Shift D6 to the left
            MOVE.B  (A2)+,D5            
            SUBI.L  #$30,D5
            ADD.B   D5,D6               
            BRA     BSWTCH_ADR3         ; Branch back           

BSWTCH_SWAP CMP.L   D3,D4               ; Check if the address range is valid
            BLT     UNKNOWN
            
            MOVEA.L D3,A3
            MOVEA.L D6,A6
            
BSWTCH_SW2  CMP.L   A3,D4               ; Check if all values swapped
            BLT     MONITOR
            MOVE.B  (A3),D7             ; Swap (A3) and (A6)
            MOVE.B  (A6),(A3)
            MOVE.B  D7,(A6)
            ADDA.L  #1,A3               ; Increment A3 and A6
            ADDA.L  #1,A6
            BRA     BSWTCH_SW2          ; Branch back


* S2H         

S2H                
            MOVEA.L D2,A2               ; Restore the input pointer to A2
            ADDA.L  #3,A2               ; Add 2 to A2 to start reading the addresses
            CLR.L   D3                  ; D3 will hold the address
            CLR.L   D6                  ; D6 will be the counter
            
            CMPI.B  #$20,(A2)+          ; Check if first address leads with a space, if not, go to unknown
            BNE     UNKNOWN
            CMPI.B  #$24,(A2)+          ; Check if first address leads with a $, if not, go to unknown
            BNE     UNKNOWN

S2H_ADR    CMPI.B  #$00,(A2)           ; If end of string, go to next
            BEQ     S2H_NEXT
            ROL.L   #4,D3               ; Shift D3 to the left
            MOVE.B  (A2)+,D5
            SUBI.L  #$30,D5                            
            ADD.B   D5,D3               
            BRA     S2H_ADR             ; Branch back 

S2H_NEXT   MOVEA.L D3,A3
            MOVE.B  (A3),D4
            CMPI.B  #$41,D4             ; Convert to hex with numbers 0-9, or letters A-F
            BLT     S2H_NUM             ; Go to S2H_NUM if D4 is less than #$41
            SUBI.B  #55,D4              ; D4 coverts to hex for letters A-F
            MOVE.B  D4,(A3)             
            BRA     MONITOR 

S2H_NUM    SUBI.B  #$30,D4             ; D4 coverts to hex for integers 0-9
            BRA     MONITOR
               

 
            
*-----------------------------------------------------------            
* Exception Handling
*-----------------------------------------------------------

BUS_ERR     LEA     busException,A1    ; Print bus exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

ADS_ERR     LEA     adrException,A1    ; Print address exception
            MOVE.B  #14,D0
            TRAP    #15
            
            BRA     DF

IL_INST     LEA     illException,A1    ; Print illegal instruction exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

DIV_Z       LEA     divException,A1    ; Print divide by zero exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

CHK_INST    LEA     chkException,A1    ; Print CHK_INST exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

PRI_VIO     LEA     privException,A1    ; Print privledge violation exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

LINE_A      LEA     lineaException,A1  ; Print line a exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF

LINE_F      LEA     linefException,A1  ; Print line f exception
            MOVE.B  #14,D0
            TRAP    #15

            BRA     DF
            
            
            
*-----------------------------------------------------------            
* Exit
*-----------------------------------------------------------

EXIT        LEA     exitingString,A1    ; Print ending line
            MOVE.B  #14,D0
            TRAP    #15
            END    START      


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
