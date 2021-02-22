SHELL = cmd
countLED.hex: countLED.elf
		avr-objcopy -j .text -j .data -O ihex countLED.elf countLED.hex

countLED.elf: countLED.S
		avr-gcc -mmcu=atmega328p countLED.S -o countLED.elf
		
install: countLED.hex
		avrdude -p atmega328p -c usbtiny -U flash:w:countLED.hex:i
		
clean:
		del *.o *.elf *.hex *.lst*