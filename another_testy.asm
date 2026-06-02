BITS 16
ORG 0x10000

%macro enable_a20 0
    mov     ax, 0x2402
    int     0x15
    jc      %%failed
    test    ah, ah
    jnz     %%failed
    test    al, al
    jnz     %%activated

    mov     ax, 0x2401
    int     0x15
    jc      %%failed
    test    ah, ah
    jnz     %%failed

    %%activated:
        jmp %%done
    %%failed:
        mov ah, 0x0E
        mov al, 'E'
        int 0x10
    %%hang:
        jmp %%hang
    %%done:
%endmacro

_start:
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x8000

    enable_a20

    cli
    lgdt [_gdt_descriptor]

    mov eax, cr0
    or  eax, 1
    mov cr0, eax
    jmp dword 0x08:_protected_mode

BITS 32
_protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    mov byte [0xB8000], 'P'
    mov byte [0xB8001], 0x0F

    hlt

_gdt_descriptor:
    dw _gdt_end - _gdt_start - 1
    dd _gdt_start

_gdt_start:
    _gdt_null:
        dq 0x0000000000000000
    _gdt_kernel_code:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 10011010b
        db 11001111b
        db 0x00
    _gdt_kernel_data:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 10010010b
        db 11001111b
        db 0x00
    _gdt_user_code:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 11111010b
        db 11001111b
        db 0x00
    _gdt_user_data:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 11110010b
        db 11001111b
        db 0x00
    _gdt_tss:
        dw _tss_end - _tss_start - 1
        dw 0x0000
        db 0x00
        db 10001001b
        db 00000000b
        db 0x00
_gdt_end:

_tss_start:
    dd 0x00000000
    dd 0x00000000
    dd 0x00000010
    times 22 dd 0
_tss_end:

_kernel_stack:
    resb 16384
_kernel_stack_top: