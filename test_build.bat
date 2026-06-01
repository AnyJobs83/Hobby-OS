@echo off

:: assemble the bootloader
nasm -f bin boot.asm -o boot.bin || goto :error

:: all kernel c and asm files, compile them to object files
nasm -f bin testy.asm -o testy.bin || goto :error

:: pad the kernel binary to 1MB
fsutil file setEOF testy.bin 1048576 || goto :error
::certutil -dump final_kernel.bin | more

:: combine the bootloader and kernel into a single image
copy /b boot.bin + testy.bin hard_drive.img || goto :error

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