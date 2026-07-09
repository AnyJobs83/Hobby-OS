@echo off

:: assemble the bootloader
nasm -f bin boot\boot.asm -o boot.bin || goto :error

:: compile all c and asm file in the trampoline / 2nd stage bootloader
nasm -f elf32 boot\kernel_setup.asm -o kernel_setup.o || goto :error
nasm -f elf32 boot\bios_memory_reader.asm -o bios_memory_reader.o || goto :error
i686-elf-gcc -m32 -ffreestanding -c mm\physical_mm.c -o physical_mm.o || goto :error

:: compile all c and asm files from the main kernel
nasm -f elf32 interrupts\idt.asm -o idt_asm.o || goto :error
i686-elf-gcc -m32 -ffreestanding -c interrupts\idt.c -o idt.o || goto :error
i686-elf-gcc -m32 -ffreestanding -c interrupts\isr_handlers.c -o isr_handlers.o || goto :error
i686-elf-gcc -m32 -ffreestanding -c kmain.c -o kmain.o || goto :error
i686-elf-gcc -m32 -ffreestanding -c helpers\vga_printer.c -o vga_printer.o || goto :error

:: Link up the trampoline
i686-elf-ld -m elf_i386 -T boot\trampoline.ld -o trampoline.elf kernel_setup.o bios_memory_reader.o physical_mm.o vga_printer.o || goto :error
i686-elf-objcopy -O binary trampoline.elf trampoline.bin || goto :error

:: Link the kernel object files into an ELF executable
i686-elf-ld -m elf_i386 -T boot\kernel.ld -o kernel.elf kmain.o vga_printer.o idt.o idt_asm.o isr_handlers.o || goto :error
i686-elf-objcopy -O binary kernel.elf kernel.bin || goto :error

:: check that the kernel binary isnt over 64 KiB, and the trampoline isnt over 32 KiB
call boot\checkfilesize.bat trampoline.bin 32768 || goto :error
call boot\checkfilesize.bat kernel.bin 65536 || goto :error

:: pad the kernel binary to 64 KiB, and the trampoline to 32 KiB
fsutil file setEOF trampoline.bin 32768 || goto :error
fsutil file setEOF kernel.bin 65536 || goto :error
::certutil -dump kernel.bin | more :: Show the binary and asm

:: combine the bootloader, trampoline, and kernel into a single image
copy /b boot.bin + trampoline.bin + kernel.bin hard_drive.img || goto :error

:: give the image to QEMU and run the OS
qemu-system-x86_64.exe -drive format=raw,file=hard_drive.img || goto :error
:: use -display curses to print to the terminal instead of a qemu window
::qemu-system-x86_64.exe -d int,cpu_reset -no-reboot -drive format=raw,file=hard_drive.img 2>qemu_log.txt
goto :end

:error
    echo Error: Build failed.
    pause

:end
    del *.o
    del *.elf
    del *.bin
    del *.img