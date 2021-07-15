.text
.global main

//switch and led addresses
.set LED_CTL, 0x41210000
.set SW_DATA, 0x41220000
.set BTN_DATA, 0x41200000

main:
	ldr r1,=SW_DATA				//switch address in r1
	ldr r2,=BTN_DATA			//button address in r2
	ldr r3,=LED_CTL				//led address in r3

loop:
	ldr r5, [r2]				//load button data into r5
	ldr r6, [r1]				//load switch data into r6

	and r5, #0x3				//mask buttons 3 and 4
	and r6, #0xFF

	cmp r5, #0b1				//if first button is pressed latch switch values to leds
	beq loop_latch

	cmp r5, #0b10				//if second button is pressed clear latched value
	beq loop_clear

	b loop						//goto loop

@second button clears all leds
loop_clear:
	mov r6, #0x0				//mov 0 into r6
	str r6, [r3]				//store 0 to the led address to turn off all leds
	b loop						//goto loop

@first button latches switch values to the leds
loop_latch:
	str r6, [r3]				//store current switch values into the led address
	b loop						//goto loop

.end
