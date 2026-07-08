BITS 16
ORG 0x7C00

_start:
    mov ah, 0x42
    mov si, _trampoline_dap
    mov dl, 0x80            ; reading from hard disk
    int 0x13                ; load kernel
    jc _error

    mov ah, 0x42
    mov si, _kernel_dap
    mov dl, 0x80
    int 0x13
    jc _error

    jmp 0x0000:0x8000   ; jump to trampoline

_error:
    mov ah, 0x0E
    mov al, 'a'
    int 0x10
    jmp _error

_trampoline_dap:
    db 16               ; how big the dap is
    db 0                ; just 0 for sum reason
    dw 64               ; how many sectors to read (max 127, or 63.5KB)
    dw 0x8000           ; destination offset
    dw 0x0000           ; destination segment
    dq 1                ; which sector to read from on disk

_kernel_dap:
    db 16               ; how big the dap is
    db 0                ; just 0 for sum reason
    dw 128              ; how many sectors to read (max 127, or 63.5KB)
    dw 0x0000           ; destination offset
    dw 0x4000           ; destination segment
    dq 65               ; which sector to read from on disk

times 510 - ($ - $$) db 0
dw 0xAA55