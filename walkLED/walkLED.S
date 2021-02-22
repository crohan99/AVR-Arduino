; Carson Rohan
; Version 2-19-2021
; walkLED.S
; Turns on LEDs in a row one after the other to
; simulate "walking" LEDs

.equ PINC, 0x06             ; IO register for Port C input
.equ DDRC, 0x07             ; IO register for pin directions           
.equ DDRD, 0x0a             ; IO register for pin directions 
.equ PORTD, 0x0b            ; IO register for Port D output

.text
.global main 
main:   
        cbi DDRC, 0         ; set pin PC0 as input pin
        ser r16             ; fill r16 with 1's
        out DDRD, r16       ; set pins PD0-PD7 as output pins
        ldi r17, 1          ; set r17 = 0000 0001 for masking
        ldi r18, 1          ; set r18 = 0000 0001 pattern

loop:
        ; PINC -> r19
        in r19, PINC        ; load PINC to r19
        and r19, r17        ; mask r19 except for the first bit (PC0)

        ; r18 -> PORTD
        out PORTD, r18      ; put bit pattern into PORTD (output to LEDs)
        call delay          ; wait

        cp r17, r19         ; compare PC0 to 1 or "on"
        breq descend        ; if PC0 = 1, descend

        cp r17, r19         ; compare PC0 to 0 or "off"
        brne ascend         ; if PC0 = 0, ascend

        jmp loop

ascend:
        lsl r18             ; shift pattern bit left
        cp r18, r1          ; compare r18 with 0
        breq resetA         ; if r18 becomes 0000 0000 with overflow, reset r18 back to 1
        jmp loop

descend:
        lsr r18             ; shift pattern bit right
        cp r18, r1          ; compare r18 with 0
        breq resetD         ; if r18 becomes 0000 0000 with underflow, reset r18 back to 128
        jmp loop

resetA:
        ldi r18, 1
        jmp loop

resetD:
        ldi r18, 128
        jmp loop


; Loop 65535 times to create a time delay
delay:
        ; load immediate
        ldi r31, 0x0f       ; Together registers r31 and r30 form a
        ldi r30, 0xff       ; 16 bit value 255*256 + 255*1 = 65535
        ldi r20, 1          ; (since each register is 8 bits)
        
delay1:
        call delay2

        ; subtract immediate word
        sbiw r30, 1         ; subtract 1 from r30/r31 register pair
        brne delay1         ; branch if result is not equal to zero

        ret                 ; return

delay2:
        nop                 ; do nothing
        dec r20             ; decrement r20
        brne delay2         ; branch if result is not equal to zero

        ret                 ; return
