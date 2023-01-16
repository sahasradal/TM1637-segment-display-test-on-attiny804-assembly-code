;
; 804DISPLAYTM1637.asm
;
; Created: 01/05/2022 22:48:37
; Author : Manama
; PA1 DATA
; PA2 CLOCK


.def data = r19
.def temp = r16
.equ fclk = 10000000
.equ displayon = 0b10001001		; command 0x80 + display on = 8 + brightness 1 =0x89
.equ displayoff = 0b10000001
.equ address1 = 0xC2
.equ address2 = 0xC1
.equ address3 = 0xC0
.equ address4 = 0xC5
.equ address5 = 0xC4
.equ address6 = 0xC3

.macro micros					; macro for delay in us
ldi temp,@0
rcall delayTx1uS
.endm

.macro millis					; macro for delay in ms
ldi YL,low(@0)
ldi YH,high(@0)
rcall delayYx1mS
.endm

.macro command2
ldi data,@0
rcall spitx
;ret
.endm

.macro datatx
ldi data,@0
rcall spitx
rcall stop
ret
.endm


.dseg
minussign: .byte 1
firstdigit:.byte 1
seconddigit: .byte 1
thirddigit: .byte 1
firstposition: .byte 1
secposition: .byte 1

.cseg





rcall PROT_WRITE
ldi r16,0b00000110
sts VPORTA_DIR,r16
sts VPORTA_OUT,r16

ldi r16,'-'
sts minussign,r16
ldi r16,'1'
sts firstdigit,r16
ldi r16,'2'
sts seconddigit,r16
ldi r16,'8'
sts thirddigit,r16
ldi r16,'3'
sts firstposition,r16
ldi r16,'C'
sts secposition,r16

/*
mainloop:
	ldi data,0x40		;0x40 commannd for automatic address increment,0x44 for fixed address mode (address has to be supplied for each digit)
	rcall spitx
	rcall stop			;a stop has to be issued as per data sheet for data command setting (0x40 or 0x44 above)
	ldi data,0xc0		;address set command, we used data set 0x40 so we start at lower address 0xc0 , address will auto increment till 0xC6
	rcall spitx
	ldi data,0x3f	
	rcall spitx			;0 0x3f -3
	ldi data,0x06
	rcall spitx			;1 0x06 -2
	ldi data,0x5b
	rcall spitx			;2 0x5b -1
	ldi data,0x4f
	rcall spitx			;3 0x4f -6
	ldi data,0x66
	rcall spitx			;4 0x66 -5
	ldi data,0xed
	rcall spitx			;5 0x6d  -4, to diplay decimal point at this location ,OR char value with 0x80, 0x6d OR 0x80 = 0xed  which displays 5 and decimal
	rcall stop
	ldi data,displayon	;(load display command) 0x80 OR 0x01(brightness value bit0 to bit2,we use 1) OR 0x08(display on) = 0x89
	rcall spitx
	rcall stop
	millis 1000

	rjmp mainloop
*/
/*

mainloop:
	ldi data,0x44		;0x40 commannd for automatic address increment,0x44 for fixed address mode (address has to be supplied for each digit)
	rcall spitx
	rcall stop			;a stop has to be issued as per data sheet for data command setting (0x40 or 0x44 above)
	ldi data,0xc2		;address set command, we used data set 0x44 so we start at 0xc2 address which is leftmost , address will not auto increment till 0xC6
	rcall spitx
	ldi data,0x3f	
	rcall spitx			;0 0x3f		-3
	rcall stop
	ldi data,0xc1		;address set command, we used data set 0x44 so we set address of next digit which is 0xc1 address which is 2nd leftmost
	rcall spitx			
	ldi data,0x06
	rcall spitx			;1 0x06		-2
	rcall stop
	ldi data,0xc0		;address set command, we used data set 0x44 so we set address of next digit which is 0xc0 address which is 3rd leftmost
	rcall spitx				
	ldi data,0x5b
	rcall spitx			;2 0x5b		-1
	rcall stop
	ldi data,0xc5		;address set command, we used data set 0x44 so we set address of next digit which is 0xc3 address which is 4th leftmost
	rcall spitx	
	ldi data,0xCf
	rcall spitx			;3 0x4f		-6
	rcall stop
	ldi data,0xc4		;address set command, we used data set 0x44 so we set address of next digit which is 0xc4 address which is 5th leftmost
	rcall spitx	
	ldi data,0x66
	rcall spitx			;4 0x66		-5
	rcall stop
	ldi data,0xc3		;address set command, we used data set 0x44 so we set address of next digit which is 0xc3 address which is 4th leftmost
	rcall spitx	
	ldi data,0x6d
	rcall spitx			;5 0x6d  -4, to diplay decimal point at this location ,OR char value with 0x80, 0x6d OR 0x80 = 0xed  which displays 5 and decimal
	rcall stop
	ldi data,displayon	;(load display command) 0x80 OR 0x01(brightness value bit0 to bit2,we use 1) OR 0x08(display on) = 0x89
	rcall spitx
	rcall stop
	millis 1000

	rjmp mainloop
	*/

mainloop:
	ldi YL,low(minussign)
	ldi YH,high(minussign)
	ldi r27,6
	rcall command1
	command2 address1
	ld r16,Y+
	rcall printchar
	dec r27
	command2 address2
	ld r16,Y+
	rcall printchar
	dec r27
	command2 address3
	ld r16,Y+
	rcall printchar
	dec r27
	command2 address4
	ld r16,Y+
	rcall printchar
	dec r27
	command2 address5
	ld r16,Y+
	rcall printchar
	dec r27
	command2 address6
	ld r16,Y+
	rcall printchar
	dec r27
	rcall command3
	rjmp mainloop


command1:
	ldi data,0x44		;0x40 commannd for automatic address increment,0x44 for fixed address mode (address has to be supplied for each digit)
	rcall spitx
	rcall stop			;a stop has to be issued as per data sheet for data command setting (0x40 or 0x44 above)
	ret
command3:
	ldi data,displayon	;(load display command) 0x80 OR 0x01(brightness value bit0 to bit2,we use 1) OR 0x08(display on) = 0x89
	rcall spitx
	rcall stop
	ret

start:
	sbi VPORTA_OUT,1
	sbi VPORTA_OUT,2
	rcall delay10uS
	cbi VPORTA_OUT,1
	rcall delay10uS
	cbi VPORTA_OUT,2
	rcall delay10us
	ret
stop:
	cbi VPORTA_OUT,1
	cbi VPORTA_OUT,2
	rcall delay10uS
	sbi VPORTA_OUT,2
	rcall delay10us
	sbi VPORTA_OUT,1
	rcall delay10us
	ret
/*
SPI:
	ldi r18,8
tx:
	lsl data
	brcs hi
	cbi VPORTA_OUT,1
	rcall delay10us
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	rcall delay10us
	dec r18
	brne tx
	cbi VPORTA_OUT,1
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	ret
hi:
	sbi VPORTA_OUT,1
	rcall delay10us
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	rcall delay10us
	dec r18
	brne tx
	cbi VPORTA_OUT,1
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	ret
	
spitx:
	rcall start
	rcall SPI
	ret
*/

SPI:
	ldi r18,8
tx:
	lsr data
	brcs hi
	cbi VPORTA_OUT,1
	rcall delay10us
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	rcall delay10us
	dec r18
	brne tx
	sbi VPORTA_OUT,1
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,1
	cbi VPORTA_OUT,2
	ret
hi:
	sbi VPORTA_OUT,1
	rcall delay10us
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,2
	rcall delay10us
	dec r18
	brne tx
	sbi VPORTA_OUT,1
	sbi VPORTA_OUT,2
	rcall delay10us
	cbi VPORTA_OUT,1
	cbi VPORTA_OUT,2
	ret
	
spitx:
	rcall start
	rcall SPI
	ret


; ============================== Time Delay Subroutines =====================
; Name:     delayYx1mS
; Purpose:  provide a delay of (YH:YL) x 1 mS
; Entry:    (YH:YL) = delay data
; Exit:     no parameters
; Notes:    the 16-bit register provides for a delay of up to 65.535 Seconds
;           requires delay1mS

delayYx1mS:
    rcall    delay1mS                        ; delay for 1 mS
    sbiw    YH:YL, 1                        ; update the the delay counter
    brne    delayYx1mS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret
; ---------------------------------------------------------------------------
; Name:     delayTx1mS
; Purpose:  provide a delay of (temp) x 1 mS
; Entry:    (temp) = delay data
; Exit:     no parameters
; Notes:    the 8-bit register provides for a delay of up to 255 mS
;           requires delay1mS

delayTx1mS:
    rcall    delay1mS                        ; delay for 1 mS
    dec     temp                            ; update the delay counter
    brne    delayTx1mS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret

; ---------------------------------------------------------------------------
; Name:     delay1mS
; Purpose:  provide a delay of 1 mS
; Entry:    no parameters
; Exit:     no parameters
; Notes:    chews up fclk/1000 clock cycles (including the 'call')

delay1mS:
    push    YL                              ; [2] preserve registers
    push    YH                              ; [2]
    ldi     YL, low(((fclk/1000)-18)/4)     ; [1] delay counter              (((fclk/1000)-18)/4)
    ldi     YH, high(((fclk/1000)-18)/4)    ; [1]                            (((fclk/1000)-18)/4)

delay1mS_01:
    sbiw    YH:YL, 1                        ; [2] update the the delay counter
    brne    delay1mS_01                     ; [2] delay counter is not zero

; arrive here when delay counter is zero
    pop     YH                              ; [2] restore registers
    pop     YL                              ; [2]
    ret                                     ; [4]

; ---------------------------------------------------------------------------
; Name:     delayTx1uS
; Purpose:  provide a delay of (temp) x 1 uS with a 16 MHz clock frequency
; Entry:    (temp) = delay data
; Exit:     no parameters
; Notes:    the 8-bit register provides for a delay of up to 255 uS
;           requires delay1uS

delayTx1uS:
    rcall    delay10uS                        ; delay for 1 uS
    dec     temp                            ; decrement the delay counter
    brne    delayTx1uS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret

; ---------------------------------------------------------------------------
; Name:     delay10uS
; Purpose:  provide a delay of 1 uS with a 16 MHz clock frequency ;MODIFIED TO PROVIDE 10us with 1200000cs chip by Sajeev
; Entry:    no parameters
; Exit:     no parameters
; Notes:    add another push/pop for 20 MHz clock frequency

delay10uS:
    ;push    temp                            ; [2] these instructions do nothing except consume clock cycles
    ;pop     temp                            ; [2]
    ;push    temp                            ; [2]
    ;pop     temp                            ; [2]
    ;ret                                     ; [4]
     nop
     nop
     nop
     ret

; ============================== End of Time Delay Subroutines ==============
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROTECTED WRITE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROT_WRITE:
		ldi r16,0Xd8
		out CPU_CCP,r16
		ldi r16,0x01						; clk prescaler of 2, 20Mhz/2 = 10Mhz
		STS CLKCTRL_MCLKCTRLB,R16
		RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

// XGFEDCBA
font0: .db   0b00111111    // 0
font1: .db   0b00000110    // 1
font2: .db   0b01011011    // 2
font3: .db   0b01001111    // 3
font4: .db   0b01100110    // 4
font5: .db   0b01101101    // 5
font6: .db   0b01111101    // 6
font7: .db   0b00000111    // 7
font8: .db   0b01111111    // 8
font9: .db   0b01101111    // 9
fonta: .db   0b01110111    // A
fontb: .db   0b01111100    // b
fontc: .db   0b00111001    // C
fontd: .db   0b01011110    // d
fonte: .db   0b01111001    // E
fontf: .db   0b01110001    // F
fontminus: .db  0b01000000    // -
fontspace: .db  0b00000000


pointer:
ldi ZL,low(2*font0)
ldi ZH,high(2*font0)
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;printchar ;;;prints characters to OLED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printchar:
	cpi r16,'-'		; minus
	breq minus
	cpi r16,'C'
	breq letterC
	cpi r16,' '
	breq space
	rjmp printnum
minus:
	ldi ZL,low(2*fontminus)
	ldi ZH,high(2*fontminus)
	rjmp load0

letterC:
	ldi ZL,low(2*fontC)
	ldi ZH,high(2*fontC)
	rjmp load0
space:
	ldi ZL,low(2*fontspace)
	ldi ZH,high(2*fontspace)
	rjmp load0
printnum:
	ldi ZL,low(2*font0)
	ldi ZH,high(2*font0)
	ldi r26,0x30   				; load 0x30 in r26
	sub r16,r26					; compare value in r16 to r26
	breq load0					; if equal/0 branch to load0 label which lods font data from font0 label, Z pointer set to font0 at the begining of 'printnum'
	clr r26						; if subtraction is not equal to 0 , need to calculate address, clear r26. the value in this register after calculation decides address
multiply:
	subi r30,low(-2)			; add 16 to  Z low	
	sbci r31,high(-2)			; add with carry to Z high
	inc r26						; increase r26 which indicates how many times 16 was added
	cp r26,r16					; compare the value in r26 after addition to r16 r16 holds the difference between the font 0 and required font
	brne multiply				; if value differ again add until bot r16 and r26 are same
load0:
	lpm data,Z					; call routine font_write which prints font on LCD
	cpi r27,3					; this number decides where the decimal point will be placed , 3 means decimal will be placed on 4th digit
	breq adddecimal				; if equal to 3 branch to adddecimal label to OR with 0x80 which will turn on the decimal point
	rcall spitx
	rcall stop
	ret
adddecimal:
	ori data,0x80
	rcall spitx
	rcall stop
	ret


