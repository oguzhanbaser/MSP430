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
;          !!!!!!!!!!!!!!!!!!MSP430F5529 i�in yaz�lm��t�r!!!!!!!!!!!!!!!

;P2.1 butonuna bas�nca binary say�c�y� artt�r�p
;P1.1 butonuna bas�nca binary say�c�y� azaltan uygulama �rne�i

	        mov.b   #0fh, &P6DIR		;P6 portunun ilk 4 bitini ��k�� olarak atad�k

	        bic.b	#02h, &P2DIR		;P2.1 i giri� olarak ayarlary�p
	        bis.b	#02h, &P2IES		;interrupt' � aktif ettik
	        bis.b	#02h, &P2IE
	        bic.b	#02h, &P2IFG
	        bis.b	#02h, &P2REN
	        bis.b	#02h, &P2OUT

	        bic.b	#02h, &P1DIR		;P1.1 portunu giri� olarak ayarlay�p
	        bis.b	#02h, &P1IE 		;interrupt' � aktif ettik
	        bis.b	#02h, &P1IES
	        bic.b	#02h, &P1IFG
	        bis.b	#02h, &P1REN
	        bis.b	#02h, &P1OUT

	        eint						;genel interruptlar� aktif ettik
	        NOP

	        clr.b   &P6OUT				;p6 ��k�� portunu temizledik
	        mov.b	#01h, r6			;saya� olarak kullanaca��m�z adrese 01 atad�k
			mov		#01, &2400h			;2400h adresine kontrol i�in 01 yazd�rd�k
			mov		#01, &2402h			;2402h adresine kontrol i�in 01 yazd�rd�k

basla   	cmp		#01h, &2400h		;2400h adresinde de�er 01 ise saymaya devam et
			jnz		basla				;de�ilse ba�a d�n
			mov.b   r6, &P6OUT
	        call    #wait				;belli bir s�re bekle

	        cmp		#01h, &2402h		;2402h adresinde de�er 01 ise arttirmaya devam et
	        jnz		azalt				;de�ilse azaltmaya devam et
	        call	#arttir

	        jmp     basla

arttir		inc		r6					;2402h adresindeki de�er 01 ise
	        cmp		#010h, r6			;arttirma i�lemi yap
	        jnz		m2
	        mov		#01h, r6
m2	        ret

azalt		dec		r6					;2402h adersine de�er 01 de�ilse
	        cmp		#00h, r6			;azaltma i�lemi yap
	        jnz		m3
	        mov		#0fh, r6
m3	        jmp		basla

wait    	mov     #050000, r4			;belli bir s�re bekle
			mov		#05,	r5
lr5			nop
lr4     	dec     r4
        	jnz     lr4
        	dec		r5
        	jnz		lr5
        	ret

;-------------------------------------------------------------------------------
;Interrupt
;-------------------------------------------------------------------------------
P2_ISR		xor		#01h, &2402h		;P2.1 butonun bas�lm��sa 2402 deki de�eri
			bic.b	#02h, P2IFG			;xor la
			reti

;-------------------------------------------------------------------------------
;Interrupt
;-------------------------------------------------------------------------------
P1_ISR		xor		#01h, &2400h		;P1.1 butonuna bas�lm��sa 2400 deki de�eri
			bic.b	#02h, P1IFG			;xor la
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
            

