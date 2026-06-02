BITS 16
ORG 0x7C00

_start:
    mov ah, 0x42
    mov si, _dap
    mov dl, 0x80
    int 0x13            ; load kernel
    jc _error

    jmp 0x0000:0x7E00   ; jump to kernel

_error:
    mov ah, 0x0E
    mov al, 'a'
    int 0x10
    jmp _error

_dap:
    db 16               ; how big the dap is
    db 0                ; just 0 for sum reason
    dw 32               ; how many sectors kernel is (max 32, or 64KB)
    dw 0x7E00           ; destination offset
    dw 0x0000           ; destination segment
    dq 1                ; which sector to start from (always 1)

times 510 - ($ - $$) db 0
dw 0xAA55