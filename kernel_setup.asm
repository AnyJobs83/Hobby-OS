section .setup

GLOBAL _start
EXTERN _kmain
EXTERN _kernel_stack_top

BITS 16

_start:
_kernel_init_real:
    cli                         ; disable interupts

    mov ah, 0x0E
    mov al, 'h'
    int 0x10

    ; set up stack before any calls
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00              ; set a temporary kernel stack at 0x7C00, gets set later in 32 bit mode
    
    lgdt [_gdt_descriptor]      ; link gdt table, need to fix the tss parts

    call _enable_a20            ; enable a20 mode

    mov eax, cr0
    or  eax, 1
    mov cr0, eax                ; turn on protected mode

    jmp 0x08: _kernel_init_protected

_enable_a20:
    mov     ax, 0x2402              ; Get A20 gate status
    int     0x15
    jc      a20_failed              ; Couldn't get status
    test    ah, ah
    jnz     a20_failed              ; Couldn't get status
    test    al, al
    jnz     a20_activated           ; AL = 1, A20 gate is already activated

    mov     ax, 0x2401              ; Activate A20 gate
    int     0x15
    jc      a20_failed              ; Couldn't activate the gate
    test    ah, ah
    jnz     a20_failed              ; Couldn't activate the gate

    a20_activated:
        ret
    a20_failed:
        mov ah, 0x0E
        mov al, 'E'
        int 0x10
        _hang:
            jmp _hang

_gdt_descriptor:
    dw _gdt_end - _gdt_start - 1
    dd _gdt_start

_gdt_start:
    _gdt_null:
        dq 0x0000000000000000
    _gdt_kernel_code:       ; relative address from _gdt_start: 0x08
        dw 0xFFFF           ; limit to 4 mb
        dw 0x0000           ; base
        db 0x00             ; more base
        db 10011010b        ; access byte, saying this is code
        db 11001111b        ; flags, plus four more bits of the limit
        db 0x00             ; more more base
    _gdt_kernel_data:       ; relative address from _gdt_start: 0x10
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 10010010b
        db 11001111b
        db 0x00
    _gdt_user_code:         ; relative address from _gdt_start: 0x18
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 11111010b
        db 11001111b
        db 0x00
    _gdt_user_data:         ; relative address from _gdt_start: 0x20
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 11110010b
        db 11001111b
        db 0x00
    _gdt_tss:
        dw _tss_end - _tss_start - 1    ; limit
        dw 0x0000                       ; base 15:0   ← patched at runtime
        db 0x00                         ; base 23:16  ← patched at runtime
        db 10001001b
        db 00000000b
        db 0x00                         ; base 31:24  ← patched at runtime
_gdt_end:

_tss_start:
    dd 0x00000000       ; previous TSS link (unused)
    dd 0x00000000       ; _kernel_stack_top ← patched at runtime
    dd 0x00000010       ; points to _gdt_kernel_data
    times 22 dd 0
_tss_end:

BITS 32
_kernel_init_protected:
    mov ax, 0x10                ; set all the segment registers
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, _kernel_stack_top  ; set the kernel stack pointer

    call _fix_gdt_and_tss

    call _kmain

    ; _kmain should not ever return and get back to this address, but if it does, hang
    jmp $

_fix_gdt_and_tss:
    ; fix the gdt_tss
    mov eax, _tss_start
    mov word [_gdt_tss + 2], ax
    shr eax, 16
    mov byte [_gdt_tss + 4], al
    shr eax, 8
    mov byte [_gdt_tss + 7], al

    ; fix tss
    mov dword [_tss_start + 0x04], _kernel_stack_top

    ; load TSS
    mov ax, 0x28
    ltr ax

    ret