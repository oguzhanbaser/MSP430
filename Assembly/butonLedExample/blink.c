//***************************************************************************************
//  MSP430 Blink the LED Demo - Software Toggle P1.0
//
//  Description; Toggle P1.0 by xor'ing P1.0 inside of a software loop.
//  ACLK = n/a, MCLK = SMCLK = default DCO
//
//                MSP430x5xx
//             -----------------
//         /|\|              XIN|-
//          | |                 |
//          --|RST          XOUT|-
//            |                 |
//            |             P1.0|-->LED
//
//  J. Stevenson
//  Texas Instruments, Inc
//  July 2011
//  Built with Code Composer Studio v5
//***************************************************************************************

#include <msp430.h>
volatile int a, b;

#define BUTTON BIT1
#define LED BIT0

int main(void) {
	WDTCTL = WDTPW | WDTHOLD;		// Stop watchdog timer

	P1DIR |= LED;
	P1OUT |= 0x00;

	P2DIR |= BUTTON;
	P2REN |= BUTTON;
	P2OUT |= BUTTON;

	for(;;) {
		a = P2IN;
		b = (P2IN & 0x02);
		if(!(P2IN & 0x02))
		{
			P1OUT = 0xFF;
		}
		else
			P1OUT = 0x00;
	}
	
	return 0;
}
