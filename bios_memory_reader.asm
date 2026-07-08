BITS 16

GLOBAL _read_bios_e820

_read_bios_e820:
    push bp
    mov bp, sp

    push ebx
    push es
    push di

    mov ax, 0x0100          ; Destination segment
    mov es, ax

    mov ax, 0               ; Destination offset
    mov di, ax

    mov eax, 0xE820         ; Instruction type
    xor ebx, ebx            ; Continuation value
    mov ecx, 24             ; Returned struct size
    mov edx, 0x534D4150     ; 'SMAP' in ASCII

    _read:
        int 0x15

        jc _error           ; Test for error

        test ebx, ebx
        jz _finished        ; ebx is 0 when finished

        ; if not finished, reset and go again

        mov eax, 0xE820
        mov ecx, 24

        add di, 24          ; increment the buffer address

        jmp _read


    _finished:

    pop di
    pop es
    pop ebx

    pop bp
    ret

_error:
    mov ah, 0x0E
    mov al, 'a'
    int 0x10
    jmp _error  