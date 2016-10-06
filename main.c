/*
Copyright (c) 2016, Vinayak Kariappa Chettimada
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include "nrf.h"
#include "uart.h"
#include "nanobe.h"

void *nanobe_main_sp;
void *nanobe_0_sp;
void *nanobe_1_sp;

uint8_t nanobe_0_stack[256];
uint8_t nanobe_1_stack[256];

void nanobe_0(void)
{
	uart_tx_str("nanobe_0 init.\n");

	while(1) {
		uart_tx_str("nanobe_0.\n");
		_nanobe_switch(nanobe_1_sp, &nanobe_0_sp);
	}
}

void nanobe_1(void)
{
	uart_tx_str("nanobe_1 init.\n");

	while(1) {
		uart_tx_str("nanobe_1.\n");
		_nanobe_switch(nanobe_main_sp, &nanobe_1_sp);
	}
}

void nanobe_injection(void)
{
	uart_tx_str("injection.\n");
}

int main(void)
{
	uart_init(UART, 1);
	uart_tx_str("\nNanobe.\n");
	{
		extern void assert_print(void);

		assert_print();
	}

	nanobe_0_sp = _nanobe_init(nanobe_0,
				   nanobe_0_stack + sizeof(nanobe_0_stack));
	nanobe_1_sp = _nanobe_init(nanobe_1,
				   nanobe_1_stack + sizeof(nanobe_1_stack));

	NVIC_SetPriority(PendSV_IRQn, 0xFF);

	while (1) {
		uart_tx_str("nanobe main.\n");
		_nanobe_switch(nanobe_0_sp, &nanobe_main_sp);

		uart_tx_str("pendsv.\n");
		SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
	}
}
