/*
Copyright (c) 2016, Vinayak Kariappa Chettimada
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
	.thumb

	.section .text
	.thumb_func
	.global _nanobe_init
	.type _nanobe_init, %function
_nanobe_init:
	push {r2-r6, lr}
	mov lr, r0
	mrs r0, psp
	msr psp, r1
	push {r2-r7, lr}
	mov r2, r8
	mov r3, r9
	mov r4, r10
	mov r5, r11
	mov r6, r12
	push {r2-r6}
	mrs r1, psp
	msr psp, r0
	mov r0, r1
	pop {r2-r6, pc}

	.section .text
	.thumb_func
	.global _nanobe_switch
	.type _nanobe_switch, %function
_nanobe_switch:
	push {r2-r7, lr}
	mov r2, r8
	mov r3, r9
	mov r4, r10
	mov r5, r11
	mov r6, r12
	push {r2-r6}
	mrs r2, psp
	str r2, [r1]
	msr psp, r0
	pop {r0-r4}
	mov r12, r4
	mov r11, r3
	mov r10, r2
	mov r9, r1
	mov r8, r0
	pop {r2-r7, pc}

	.section .text
	.thumb_func
	.global _nanobe_isr_inject
	.type _nanobe_isr_inject, %function
_nanobe_isr_inject:
	mov r2, #4
	mov r3, lr
	tst r2, r3
	beq __not_nanobe
	mrs r0, psp
	ldr r2, [r0, #24]
	ldr r3, =__syringe
	str r3, [r0, #24]
	ldr r3, =1
	add r3, r2
	sub r0, #4
	str r3, [r0]
	sub r0, #4
	str r1, [r0]
__not_nanobe:
	bx lr
__syringe:
	cpsid i
	push {r0}
	push {r0}
	push {r1}
	mov r0, sp
	add r0, #0xf
	ldr r1, =0xFFFFFFF8
	and r0, r1
	sub r0, #36
	ldr r1, [r0]
	str r1, [sp, #8]
	sub r0, #4
	ldr r1, [r0]
	cpsie i
	push {lr}
	blx r1
	pop {r0}
	mov lr, r0
	pop {r1}
	pop {r0}
	pop {pc}
