;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Mac OS X ppc)
;--------------------------------------------------------
	.module main
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _update_fault_led
	.globl _update_sensor_led
	.globl _short_circuit_detected
	.globl _sensor_connected_not_sensing
	.globl _object_detected
	.globl _sensor_break_detected
	.globl _fault_led_enabled
	.globl _reverse_mode_enabled
	.globl _read_adc_average
	.globl _read_adc_ch0
	.globl _adc_init
	.globl _gpio_init
	.globl _delay_loop_small
	.globl _P03
	.globl _P12
	.globl _P11
	.globl _P10
	.globl _P01
	.globl _P00
	.globl _AINDIDS
	.globl _ADCRH
	.globl _ADCRL
	.globl _ADCCON0
	.globl _ADCCON1
	.globl _P3M2
	.globl _P3M1
	.globl _P1M2
	.globl _P1M1
	.globl _P0M2
	.globl _P0M1
	.globl _CKDIV
	.globl _P3
	.globl _P1
	.globl _P0
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_P1	=	0x0090
_P3	=	0x00b0
_CKDIV	=	0x0095
_P0M1	=	0x00b1
_P0M2	=	0x00b2
_P1M1	=	0x00b3
_P1M2	=	0x00b4
_P3M1	=	0x00ac
_P3M2	=	0x00ad
_ADCCON1	=	0x00e1
_ADCCON0	=	0x00e8
_ADCRL	=	0x00c2
_ADCRH	=	0x00c3
_AINDIDS	=	0x00f6
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P00	=	0x0080
_P01	=	0x0081
_P10	=	0x0090
_P11	=	0x0091
_P12	=	0x0092
_P03	=	0x0083
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_adc_avg:
	.ds 2
_update_fault_led_fault_blink_state_10000_46:
	.ds 1
_update_fault_led_fault_blink_count_10000_46:
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; uninitialized external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; initialized external ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
; restartable atomic support routines
	.ds	5
sdcc_atomic_exchange_rollback_start::
	nop
	nop
sdcc_atomic_exchange_pdata_impl:
	movx	a, @r0
	mov	r3, a
	mov	a, r2
	movx	@r0, a
	sjmp	sdcc_atomic_exchange_exit
	nop
	nop
sdcc_atomic_exchange_xdata_impl:
	movx	a, @dptr
	mov	r3, a
	mov	a, r2
	movx	@dptr, a
	sjmp	sdcc_atomic_exchange_exit
sdcc_atomic_compare_exchange_idata_impl:
	mov	a, @r0
	cjne	a, ar2, .+#5
	mov	a, r3
	mov	@r0, a
	ret
	nop
sdcc_atomic_compare_exchange_pdata_impl:
	movx	a, @r0
	cjne	a, ar2, .+#5
	mov	a, r3
	movx	@r0, a
	ret
	nop
sdcc_atomic_compare_exchange_xdata_impl:
	movx	a, @dptr
	cjne	a, ar2, .+#5
	mov	a, r3
	movx	@dptr, a
	ret
sdcc_atomic_exchange_rollback_end::

sdcc_atomic_exchange_gptr_impl::
	jnb	b.6, sdcc_atomic_exchange_xdata_impl
	mov	r0, dpl
	jb	b.5, sdcc_atomic_exchange_pdata_impl
sdcc_atomic_exchange_idata_impl:
	mov	a, r2
	xch	a, @r0
	mov	dpl, a
	ret
sdcc_atomic_exchange_exit:
	mov	dpl, r3
	ret
sdcc_atomic_compare_exchange_gptr_impl::
	jnb	b.6, sdcc_atomic_compare_exchange_xdata_impl
	mov	r0, dpl
	jb	b.5, sdcc_atomic_compare_exchange_pdata_impl
	sjmp	sdcc_atomic_compare_exchange_idata_impl
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
;------------------------------------------------------------
;Allocation info for local variables in function 'update_fault_led'
;------------------------------------------------------------
;fault_blink_state Allocated with name '_update_fault_led_fault_blink_state_10000_46'
;fault_blink_count Allocated with name '_update_fault_led_fault_blink_count_10000_46'
;------------------------------------------------------------
;	main.c:358: static uint8_t fault_blink_state = LED_OFF;
	mov	_update_fault_led_fault_blink_state_10000_46,#0x00
;	main.c:359: static uint8_t fault_blink_count = 0U;
	mov	_update_fault_led_fault_blink_count_10000_46,#0x00
;	main.c:98: static uint16_t adc_avg = 0U;
	clr	a
	mov	_adc_avg,a
	mov	(_adc_avg + 1),a
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'delay_loop_small'
;------------------------------------------------------------
;i             Allocated to registers r6 r7 
;------------------------------------------------------------
;	main.c:105: void delay_loop_small(void)
;	-----------------------------------------
;	 function delay_loop_small
;	-----------------------------------------
_delay_loop_small:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	main.c:109: for (i = 0; i < 300; i++)
	mov	r6,#0x2c
	mov	r7,#0x01
00104$:
;	main.c:111: __asm__("nop");
	nop
	dec	r6
	cjne	r6,#0xff,00115$
	dec	r7
00115$:
;	main.c:109: for (i = 0; i < 300; i++)
	mov	a,r6
	orl	a,r7
	jnz	00104$
;	main.c:113: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'gpio_init'
;------------------------------------------------------------
;	main.c:120: void gpio_init(void)
;	-----------------------------------------
;	 function gpio_init
;	-----------------------------------------
_gpio_init:
;	main.c:123: P1M1 &= ~(1U << 0);
	anl	_P1M1,#0xfe
;	main.c:124: P1M2 |=  (1U << 0);
	orl	_P1M2,#0x01
;	main.c:127: P1M1 &= ~(1U << 2);
	anl	_P1M1,#0xfb
;	main.c:128: P1M2 |=  (1U << 2);
	orl	_P1M2,#0x04
;	main.c:131: P1M1 |=  (1U << 7);
	orl	_P1M1,#0x80
;	main.c:132: P1M2 &= ~(1U << 7);
	anl	_P1M2,#0x7f
;	main.c:135: P0M1 |=  (1U << 0);
	orl	_P0M1,#0x01
;	main.c:136: P0M2 &= ~(1U << 0);
	anl	_P0M2,#0xfe
;	main.c:139: P0M1 |=  (1U << 3);
	orl	_P0M1,#0x08
;	main.c:140: P0M2 &= ~(1U << 3);
	anl	_P0M2,#0xf7
;	main.c:143: AINDIDS |= 0x01U;
	orl	_AINDIDS,#0x01
;	main.c:145: P10 = LED_OFF;
;	assignBit
	clr	_P10
;	main.c:146: P12 = LED_OFF;
;	assignBit
	clr	_P12
;	main.c:147: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'adc_init'
;------------------------------------------------------------
;	main.c:154: void adc_init(void)
;	-----------------------------------------
;	 function adc_init
;	-----------------------------------------
_adc_init:
;	main.c:157: ADCCON1 |= 0x01U;
	orl	_ADCCON1,#0x01
;	main.c:160: ADCCON0 &= ~0x80U;
	anl	_ADCCON0,#0x7f
;	main.c:161: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'read_adc_ch0'
;------------------------------------------------------------
;result        Allocated to registers 
;------------------------------------------------------------
;	main.c:168: uint16_t read_adc_ch0(void)
;	-----------------------------------------
;	 function read_adc_ch0
;	-----------------------------------------
_read_adc_ch0:
;	main.c:173: ADCCON0 &= 0xF0U;
	anl	_ADCCON0,#0xf0
;	main.c:174: ADCCON0 |= 0x00U;
	mov	_ADCCON0,_ADCCON0
;	main.c:177: ADCCON0 &= ~0x80U;
	anl	_ADCCON0,#0x7f
;	main.c:178: ADCCON0 |=  0x40U;
	orl	_ADCCON0,#0x40
;	main.c:180: while ((ADCCON0 & 0x80U) == 0U)
00101$:
	mov	a,_ADCCON0
	jnb	acc.7,00101$
;	main.c:184: result = ((uint16_t)ADCRH << 4) |
	mov	r6,_ADCRH
	clr	a
	xch	a,r6
	swap	a
	xch	a,r6
	xrl	a,r6
	xch	a,r6
	anl	a,#0xf0
	xch	a,r6
	xrl	a,r6
	mov	r7,a
;	main.c:185: (ADCRL & 0x0FU);
	mov	r4,_ADCRL
	anl	ar4,#0x0f
	mov	r5,#0x00
	mov	a,r6
	orl	ar4,a
	mov	a,r7
	orl	ar5,a
	mov	dpl,r4
	mov	dph,r5
;	main.c:187: return result;
;	main.c:188: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'read_adc_average'
;------------------------------------------------------------
;i             Allocated to registers r5 
;sample        Allocated to registers r3 r4 
;sum           Allocated to registers r6 r7 
;------------------------------------------------------------
;	main.c:195: void read_adc_average(void)
;	-----------------------------------------
;	 function read_adc_average
;	-----------------------------------------
_read_adc_average:
;	main.c:201: sum = 0U;
	mov	r6,#0x00
	mov	r7,#0x00
;	main.c:203: for (i = 0; i < ADC_WINDOW_SAMPLES; i++)
	mov	r5,#0x10
00104$:
;	main.c:205: sample = read_adc_ch0();
	push	ar7
	push	ar6
	push	ar5
	lcall	_read_adc_ch0
	mov	r3, dpl
	mov	r4, dph
	pop	ar5
	pop	ar6
	pop	ar7
;	main.c:206: sum += sample;
	mov	a,r3
	add	a, r6
	mov	r6,a
	mov	a,r4
	addc	a, r7
	mov	r7,a
;	main.c:203: for (i = 0; i < ADC_WINDOW_SAMPLES; i++)
	djnz	r5,00104$
;	main.c:209: adc_avg = sum / ADC_WINDOW_SAMPLES;
	mov	a,r7
	swap	a
	xch	a,r6
	swap	a
	anl	a,#0x0f
	xrl	a,r6
	xch	a,r6
	anl	a,#0x0f
	xch	a,r6
	xrl	a,r6
	xch	a,r6
	mov	r7,a
	mov	_adc_avg,r6
	mov	(_adc_avg + 1),r7
;	main.c:210: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'reverse_mode_enabled'
;------------------------------------------------------------
;	main.c:217: uint8_t reverse_mode_enabled(void)
;	-----------------------------------------
;	 function reverse_mode_enabled
;	-----------------------------------------
_reverse_mode_enabled:
;	main.c:223: if (P00 == 0U)
	jb	_P00,00102$
;	main.c:225: return REVERSE_MODE_ON;
	mov	dpl, #0x01
	ret
00102$:
;	main.c:228: return REVERSE_MODE_OFF;
	mov	dpl, #0x00
;	main.c:229: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'fault_led_enabled'
;------------------------------------------------------------
;	main.c:232: uint8_t fault_led_enabled(void)
;	-----------------------------------------
;	 function fault_led_enabled
;	-----------------------------------------
_fault_led_enabled:
;	main.c:238: if (P03 == 0U)
	jb	_P03,00102$
;	main.c:240: return FAULT_LED_DISABLED;
	mov	dpl, #0x00
	ret
00102$:
;	main.c:243: return FAULT_LED_ENABLED;
	mov	dpl, #0x01
;	main.c:244: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sensor_break_detected'
;------------------------------------------------------------
;	main.c:251: uint8_t sensor_break_detected(void)
;	-----------------------------------------
;	 function sensor_break_detected
;	-----------------------------------------
_sensor_break_detected:
;	main.c:253: if (adc_avg <= ADC_BREAK_MAX)
	mov	r6,_adc_avg
	mov	r7,(_adc_avg + 1)
	clr	c
	mov	a,#0x10
	subb	a,r6
	clr	a
	subb	a,r7
	jc	00102$
;	main.c:255: return 1U;
	mov	dpl, #0x01
	ret
00102$:
;	main.c:258: return 0U;
	mov	dpl, #0x00
;	main.c:259: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'object_detected'
;------------------------------------------------------------
;	main.c:262: uint8_t object_detected(void)
;	-----------------------------------------
;	 function object_detected
;	-----------------------------------------
_object_detected:
;	main.c:264: if ((adc_avg >= ADC_SENSE_MIN) &&
	mov	r6,_adc_avg
	mov	r7,(_adc_avg + 1)
	clr	c
	mov	a,r6
	subb	a,#0x19
	mov	a,r7
	subb	a,#0x00
;	main.c:265: (adc_avg <= ADC_SENSE_MAX))
	jc	00102$
	mov	a,#0xc2
	subb	a,r6
	mov	a,#0x01
	subb	a,r7
	jc	00102$
;	main.c:267: return 1U;
	mov	dpl, #0x01
	ret
00102$:
;	main.c:270: return 0U;
	mov	dpl, #0x00
;	main.c:271: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sensor_connected_not_sensing'
;------------------------------------------------------------
;	main.c:274: uint8_t sensor_connected_not_sensing(void)
;	-----------------------------------------
;	 function sensor_connected_not_sensing
;	-----------------------------------------
_sensor_connected_not_sensing:
;	main.c:276: if ((adc_avg >= ADC_CONNECTED_MIN) &&
	mov	r6,_adc_avg
	mov	r7,(_adc_avg + 1)
	clr	c
	mov	a,r6
	subb	a,#0xc3
	mov	a,r7
	subb	a,#0x01
;	main.c:277: (adc_avg <= ADC_CONNECTED_MAX))
	jc	00102$
	mov	a,#0xcc
	subb	a,r6
	mov	a,#0x04
	subb	a,r7
	jc	00102$
;	main.c:279: return 1U;
	mov	dpl, #0x01
	ret
00102$:
;	main.c:282: return 0U;
	mov	dpl, #0x00
;	main.c:283: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'short_circuit_detected'
;------------------------------------------------------------
;	main.c:286: uint8_t short_circuit_detected(void)
;	-----------------------------------------
;	 function short_circuit_detected
;	-----------------------------------------
_short_circuit_detected:
;	main.c:288: if (adc_avg >= ADC_SHORT_MIN)
	mov	r6,_adc_avg
	mov	r7,(_adc_avg + 1)
	clr	c
	mov	a,r6
	subb	a,#0xcd
	mov	a,r7
	subb	a,#0x04
	jc	00102$
;	main.c:290: return 1U;
	mov	dpl, #0x01
	ret
00102$:
;	main.c:293: return 0U;
	mov	dpl, #0x00
;	main.c:294: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'update_sensor_led'
;------------------------------------------------------------
;reverse_mode  Allocated to registers r7 
;------------------------------------------------------------
;	main.c:301: void update_sensor_led(void)
;	-----------------------------------------
;	 function update_sensor_led
;	-----------------------------------------
_update_sensor_led:
;	main.c:305: reverse_mode = reverse_mode_enabled();
	lcall	_reverse_mode_enabled
	mov	r7, dpl
;	main.c:309: if (short_circuit_detected() != 0U)
	push	ar7
	lcall	_short_circuit_detected
	mov	a, dpl
	pop	ar7
	jz	00117$
;	main.c:311: P10 = LED_OFF;
;	assignBit
	clr	_P10
	ret
00117$:
;	main.c:313: else if (sensor_break_detected() != 0U)
	push	ar7
	lcall	_sensor_break_detected
	mov	a, dpl
	pop	ar7
	jz	00114$
;	main.c:315: P10 = LED_OFF;
;	assignBit
	clr	_P10
	ret
00114$:
;	main.c:317: else if (object_detected() != 0U)
	push	ar7
	lcall	_object_detected
	mov	a, dpl
	pop	ar7
	jz	00111$
;	main.c:319: if (reverse_mode != 0U)
	mov	a,r7
	jz	00102$
;	main.c:322: P10 = LED_OFF;
;	assignBit
	clr	_P10
	ret
00102$:
;	main.c:327: P10 = LED_ON;
;	assignBit
	setb	_P10
	ret
00111$:
;	main.c:330: else if (sensor_connected_not_sensing() != 0U)
	push	ar7
	lcall	_sensor_connected_not_sensing
	mov	a, dpl
	pop	ar7
	jz	00108$
;	main.c:332: if (reverse_mode != 0U)
	mov	a,r7
	jz	00105$
;	main.c:335: P10 = LED_ON;
;	assignBit
	setb	_P10
	ret
00105$:
;	main.c:340: P10 = LED_OFF;
;	assignBit
	clr	_P10
	ret
00108$:
;	main.c:347: P10 = LED_OFF;
;	assignBit
	clr	_P10
;	main.c:349: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'update_fault_led'
;------------------------------------------------------------
;fault_blink_state Allocated with name '_update_fault_led_fault_blink_state_10000_46'
;fault_blink_count Allocated with name '_update_fault_led_fault_blink_count_10000_46'
;------------------------------------------------------------
;	main.c:356: void update_fault_led(void)
;	-----------------------------------------
;	 function update_fault_led
;	-----------------------------------------
_update_fault_led:
;	main.c:363: if (fault_led_enabled() == FAULT_LED_DISABLED)
	lcall	_fault_led_enabled
	mov	a, dpl
;	main.c:365: fault_blink_count = 0U;
;	main.c:366: fault_blink_state = LED_OFF;
	jnz	00102$
	mov	_update_fault_led_fault_blink_count_10000_46,a
	mov	_update_fault_led_fault_blink_state_10000_46,a
;	main.c:367: P12 = LED_OFF;
;	assignBit
	clr	_P12
;	main.c:368: return;
	ret
00102$:
;	main.c:371: if (short_circuit_detected() != 0U)
	lcall	_short_circuit_detected
	mov	a, dpl
	jz	00113$
;	main.c:374: if (fault_blink_count < FAULT_BLINK_WINDOWS)
	mov	a,#0x100 - 0x50
	add	a,_update_fault_led_fault_blink_count_10000_46
	jc	00107$
;	main.c:376: fault_blink_count++;
	inc	_update_fault_led_fault_blink_count_10000_46
	sjmp	00108$
00107$:
;	main.c:380: fault_blink_count = 0U;
	mov	_update_fault_led_fault_blink_count_10000_46,#0x00
;	main.c:382: if (fault_blink_state == LED_OFF)
	mov	a,_update_fault_led_fault_blink_state_10000_46
	jnz	00104$
;	main.c:384: fault_blink_state = LED_ON;
	mov	_update_fault_led_fault_blink_state_10000_46,#0x01
	sjmp	00108$
00104$:
;	main.c:388: fault_blink_state = LED_OFF;
	mov	_update_fault_led_fault_blink_state_10000_46,#0x00
00108$:
;	main.c:392: P12 = fault_blink_state;
;	assignBit
	mov	a,_update_fault_led_fault_blink_state_10000_46
	add	a,#0xff
	mov	_P12,c
	ret
00113$:
;	main.c:394: else if (sensor_break_detected() != 0U)
	lcall	_sensor_break_detected
	mov	a, dpl
	jz	00110$
;	main.c:397: fault_blink_count = 0U;
	mov	_update_fault_led_fault_blink_count_10000_46,#0x00
;	main.c:398: fault_blink_state = LED_OFF;
	mov	_update_fault_led_fault_blink_state_10000_46,#0x00
;	main.c:400: P12 = LED_ON;
;	assignBit
	setb	_P12
	ret
00110$:
;	main.c:405: fault_blink_count = 0U;
	mov	_update_fault_led_fault_blink_count_10000_46,#0x00
;	main.c:406: fault_blink_state = LED_OFF;
	mov	_update_fault_led_fault_blink_state_10000_46,#0x00
;	main.c:408: P12 = LED_OFF;
;	assignBit
	clr	_P12
;	main.c:410: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;	main.c:417: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c:419: gpio_init();
	lcall	_gpio_init
;	main.c:420: adc_init();
	lcall	_adc_init
;	main.c:422: P10 = LED_OFF;
;	assignBit
	clr	_P10
;	main.c:423: P12 = LED_OFF;
;	assignBit
	clr	_P12
;	main.c:425: while (1)
00102$:
;	main.c:427: read_adc_average();
	lcall	_read_adc_average
;	main.c:429: update_sensor_led();
	lcall	_update_sensor_led
;	main.c:430: update_fault_led();
	lcall	_update_fault_led
;	main.c:432: delay_loop_small();
	lcall	_delay_loop_small
;	main.c:434: }
	sjmp	00102$
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
