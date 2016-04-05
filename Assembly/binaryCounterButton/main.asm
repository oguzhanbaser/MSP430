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


;          !!!!!!!!!!!!!!!!!!MSP430F5529 için yazılmıştır!!!!!!!!!!!!!!!

;P2.1 butonuna basınca binary sayıcıyı arttırıp
;P1.1 butonuna basınca binary sayıcıyı azaltan uygulama örneği


	        mov.b   #0fh, &P6DIR		;P6 portunun ilk 4 bitini çıkış olarak atadık

	        bic.b	#02h, &P2DIR		;P2.1 i giriş olarak ayarlaryıp
	        bis.b	#02h, &P2IES		;interrupt' ı aktif ettik
	        bis.b	#02h, &P2IE
	        bic.b	#02h, &P2IFG
	        bis.b	#02h, &P2REN
	        bis.b	#02h, &P2OUT

	        bic.b	#02h, &P1DIR		;P1.1 portunu giriş olarak ayarlayıp
	        bis.b	#02h, &P1IE 		;interrupt' ı aktif ettik
	        bis.b	#02h, &P1IES
	        bic.b	#02h, &P1IFG
	        bis.b	#02h, &P1REN
	        bis.b	#02h, &P1OUT

	        nop
	        eint 						;genel interruptları aktif ettik

	        clr.b   &P6OUT				;P6 çıkışını temizledik
	        mov.b	#01h, r6			;sayaç olarak kullanacağımız r6 adresine 1 atadık

basla   	mov.b   r6, &P6OUT			;r6 yı çıkışa atadık
	        jmp     basla

;-------------------------------------------------------------------------------
;Interrupt
;-------------------------------------------------------------------------------
P2_ISR		inc		r6					;P2.1 butonuna basılmışsa sayacı 1 arttır
	        cmp		#010h, r6			;Eğer sayaç değeri 0f olmuşsa 
	        jnz		m1					;sayacı 0 yap
	        mov		#01h, r6			;olmamışsa devam et
m1	        nop
			bic.b	#02h, P2IFG
			reti

;-------------------------------------------------------------------------------
;Interrupt
;-------------------------------------------------------------------------------
P1_ISR		dec		r6					;P1.1 butonuna basılmışsa sayacı 1 azalt
	        cmp		#0h, r6				;Eğer sayaç değeri 00 olmuşsa
	        jnz		m2 					;sayacı 0f yap
	        mov		#0fh, r6 			;olmamışsa devam et
m2	        nop
			bic.b	#02h, P1IFG
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
            .sect	".int42"				;port 2 interrup adresi
            .short	P2_ISR					;port 2 interrup etiketi
            .sect	".int47"				;port 1 interrupt adresi
            .short	P1_ISR					;port 1 interrup etiketi
            

