SHELL = cmd
walkLED.hex: walkLED.elf
		avr-objcopy -j .text -j .data -O ihex walkLED.elf walkLED.hex

walkLED.elf: walkLED.S
		avr-gcc -mmcu=atmega328p walkLED.S -o walkLED.elf
		
install: walkLED.hex
		avrdude -p atmega328p -c usbtiny -U flash:w:walkLED.hex:i
		
clean:
		del *.o *.elf *.hex *.lst*