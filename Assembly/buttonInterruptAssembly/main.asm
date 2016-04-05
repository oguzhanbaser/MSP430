;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

			bis.b	#01h, &P1DIR		;P1.0 ledi ��k�� olarak y�nlendirildi
			bis.b	#080h, &P4DIR		;P4.7 ledi ��k�� olarak y�nlendirildi

			bic.b	#02h, &P2DIR		;P2.1 butonu giri� olarak y�nlendirildi
			bis.b	#02h, &P2OUT		;P2.1 giri� Pull Up voltaj� verildi
			bis.b	#02h, &P2REN		;P2.1 giri� Pull Up direnci aktif edildi

			bis.b	#02h, &P2IE			;P2.1 interrupt u atif edildi
			bis.b	#02h, &P2IES		;P2.1 i�in interrupt d��en kenar olarak ayarland�
			bic.b	#02h, &P2IFG		;P2.1 i�in interrupt bayra�� temizlendi

			nop
			eint						;genel interruptlar aktif edildi

tekrar		xor.b	#01h, &P1OUT		;P1.0 ledi i�in
			call 	#bekle				;ledin s�rekli yan�p s�nme k�sm�
			xor.b	#01h, &P1OUT
			call 	#bekle
			jmp		tekrar

bekle		mov		#050000, r5			;delay k�sm�
m1			dec		r5
			jnz		m1
			ret


;-------------------------------------------------------------------------------
; Interrupt

P2_ISR		;TOGGLE LED
;-------------------------------------------------------------------------------
			xor.b	#080h, &P4OUT
			bic.b	#02h, &P2IFG
			reti
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect	".int42"				;port 2 interrupt vect�r�
            .short	P2_ISR
            
