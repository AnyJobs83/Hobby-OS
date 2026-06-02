@echo off

:: assemble the bootloader
nasm -f bin boot.asm -o boot.bin || goto :error

:: all kernel c and asm files, compile them to object files
nasm -f elf32 kernel_setup.asm -o kernel_setup.o || goto :error
nasm -f elf32 kernel.asm -o kernel.o || goto :error
gcc -m32 -c kmain.c -o kmain.o || goto :error

:: Link the kernel object files into an ELF executable
i686-elf-ld -m elf_i386 -T linker.ld -o kernel.elf kernel_setup.o kernel.o kmain.o || goto :error
::i686-elf-objdump -d -j .setup -m i8086 kernel.elf
::goto :end

:: Strip to flat binary
i686-elf-objcopy -O binary --set-start 0x7E00 kernel.elf final_kernel.bin || goto :error

:: pad the kernel binary to 1MB
fsutil file setEOF final_kernel.bin 1048576 || goto :error
::certutil -dump final_kernel.bin | more

:: combine the bootloader and kernel into a single image
copy /b boot.bin + final_kernel.bin hard_drive.img || goto :error

:: give the image to QEMU
 qemu-system-x86_64.exe -drive format=raw,file=hard_drive.img || goto :error
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