@echo off

:: assemble the bootloader
nasm -f bin test_boot.asm -o test_boot.bin || goto :error

:: assemble the kernel
nasm -f bin testy.asm -o final_kernel.bin || goto :error

:: pad the kernel to 1MB
fsutil file setEOF final_kernel.bin 16384 || goto :error

:: combine the bootloader and kernel into a single image
copy /b test_boot.bin + final_kernel.bin hard_drive.img || goto :error

:: give the image to QEMU
qemu-system-x86_64.exe -drive format=raw,file=hard_drive.img || goto :error
::qemu-system-x86_64.exe -d int,cpu_reset -no-reboot -drive format=raw,file=hard_drive.img 2>qemu_log.txt
goto :end

:error
    echo Error: Build failed.

:end
    del *.o
    del *.elf
    del *.bin
    del *.img