
;====================================================
; Main Program Flow
; 1. Initialize 8255
; 2. Clear display registers
; 3. Main loop:
;       - Check key press
;       - If pressed → decode → shift → update
;       - Refresh display
;====================================================



;====================================================
; 8051 Keypad & 7-Segment Calculator
; Author: Ofek Witkon
;====================================================

;==============================
; 1. Bit Definitions / Equates
;==============================
RDpin equ 0B3h ;p3.3 
WRpin equ 0B2h ;p3.2
A0pin equ 0B5h ;p3.5
A1pin equ 0B4h ;p3.4
 ;-------------------------------------
row4bit equ R6;-used when a keypress is detected 
collom4bit equ R5
;--------------------------------

org 8000h 

;==============================
;  Program Start
;==============================
start:  
setb A0pin
setb A1pin
setb WRpin
setb RDPIN
mov p1,#00h; configure p1 as output
mov p1,#81h;control word to configure the 8255
lcall write

; clear digit registers (just to be on safe side)
clear:acall clearReg
	ljmp display

mainloop:;---------------------------------------------------------------------------------------------------------------------------------
clr c ;-- make sure carry is 0
;----------------------------------------------------read input-----------------------------------------

mov p1,#0ffh; set all rows high
acall portC
acall write
nop
clr rdpin;----read from keypad matrix
nop
mov A,p1
setb rdpin
nop
anl A,#0Fh;check if any button been pressed
jnz pressed
sjmp display;if no press update display-------------branch no-press goto update display---------------------




;----------------------------if press detected------------
pressed:
 
mov collom4bit,a; if there was a press sperate the values of the of collomes and rows

;-------------------------------------------------
mov a,#10h
mov p1,a
iterate:
acall portC
acall write
clr rdpin;----read from keypad matrix
nop
mov A,p1
setb rdpin
nop
mov R7,A
anl A,#0Fh;check if any button been pressed
;----------------------------------------------------------------
jnz continue
mov a,r7
rl a ;check next row
mov p1,a ;checks next row
sjmp iterate
;-------------------------------------------------------------------
;not suppose to ever occur unless there is bouncing or a key press shorter than our loop
continue:
mov a,r7
anl a,#0f0h
mov row4bit,a
acall movreg ;------ rotate the registers value left r0->r1->r2->r3, after that we can decode the keypress and update r0 accordingly 
seven_segment_decoder:;----this part decode the input from the keypad to the appropriate value for 7 segmets display
indexrows:
mov r4,#4
mov a,row4bit
shiftright:rr a
djnz r4,shiftright
acall convert2index
mov b,#4
mul ab

indexcolloms:
push a
mov a,collom4bit
acall convert2index
mov r7,a
pop a
add a,r7

;-- at this point a is conting the index of colloms plus the index of rows 
mov dptr,#kcode0
movc A,@A+DPTR;----look up value-----
mov r0,a
xrl a,#71h;-----check if the value was the F key
jz clear ;--- if F was pressed branch to clear registers and update display 

acall ldelay

verify: 
mov p1,#0ffh; set all rows high
acall portC
acall write
nop
clr rdpin;----read from keypad matrix
nop
mov A,p1
setb rdpin
nop
anl A,#0Fh;check if any button been pressed
jnz verify
;----elsejnc update the display-------
display:
 acall portA
 mov A,R0
 mov P1,A ;load digit first in port
 acall write

 acall portB
 mov p1,#00000001b
 acall write ;write digit 0 position 0

 acall sdelay

 acall portA
 mov A,R1
 mov P1,A ;load digit second in port
 acall write

 acall portB
 mov p1,#00000010b
 acall write ;write digit 1 position 1

 acall sdelay
 
 acall portA
 mov A,R2
 mov P1,A ;load digit third in port
 acall write

 acall portB
 mov p1,#00000100b
 acall write ;write digit 2 position 2  

 acall sdelay

 acall portA
 mov A,R3
 mov P1,A ;load digit forth in port
 acall write

 acall portB
 mov p1,#00001000b
 acall write ;write digit 3 position  3
 acall sdelay

 acall portB;
 mov p1, #00h;
 acall write

 ljmp mainloop
;----- End Display Subroutine ------- 

;----- 8255 WRITE Subroutine ------- 

;used once address and data lines setup 
write: 
 clr WRpin 
 nop 
 setb WRpin 
 nop 
 ret 
;----- End WRITE Subroutine -------
;----read subrutine
Read:
clr RDpin
nop
setb RDpin
nop
ret

;---clear register subrutine--
clearReg:
mov R0,#00h 
mov R1,#00h 
mov R2,#00h 
mov R3,#00h
ret
;-------------------


;----------------------

movReg: 
push a
mov A,R2
mov R3,A
mov A,R1
mov R2,A
mov A,R0
mov R1,A
pop a
ret
;need to update R0 based on the key stroke
;---------------
portA:
clr A0PIN
clr A1PIN
ret
;------------------
portB:
clr A1PIN
setb A0PIN
ret
;----------------
portC:
setb A1pin
clr A0pin
ret
;-----------------

ldelay:
mov r4,#0ffh
outer1:
mov R7,#0FFh
inner1:
djnz R7,inner1
djnz r4,outer1
ret

sdelay:
mov r7,#0ffh
loop:djnz r7,loop
ret 

convert2index: 
mov r4,#00h
again:
rrc a
inc r4
jnc again
clr c
dec r4
mov a,r4
ret


org 8500h 

;==============================
; Lookup Tables
;==============================


;(1-8000h,2-8001h,3-8002h,F-8003h,
; 4-8004h,5-8005h,6-8006h,E-8007h,
; 7-8008h,8-8009h,9-800Ah,D-800Bh,
; A-800Ch,O-800Dh,B-800Eh,C-800Fh)


KCODE0: db 06h,5Bh,4Fh,71h 
KCODE1: db 66h,6Dh,7Dh,79h 
KCODE2: db 07h,7Fh,67h,5Eh 
KCODE3: db 77H,3Fh,7Ch,58h 


end
