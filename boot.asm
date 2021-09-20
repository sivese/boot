bits 16         ; set 16 bit mode

mov ax, 0x7C0   ; ax = accumaltor for operator and data
mov ds, ax      ; ds = data segment
mov ax, 0x7E0
mov ss, ax      ; ss = stack segment register
mov sp, 0x2000  ; sp = stack pointer
qem
call clearscreen

push 0x0000
call movecursor
add sp, 2

push msg
call print
add sp, 2

cli
hlt

clearscreen:
    push bp     ; bp = base pointer
    mov bp, sp
    pusha

    mov ah, 0x00    ; scroll down window
    mov al, 0x00    ; clear
    mov bh, 0x07    ; set color
    mov cx, 0x00    ; set position
    mov dh, 0x18    ; rows
    mov dl, 0x4f    ; columns
    int 0x10        ; video interrupt

    popa
    mov sp, bp
    pop bp
    ret

movecursor:
    push bp
    mov bp, sp
    pusha

    mov dx, [bp+4]  ; get argument
    mov ah, 0x02    ; set cursor position
    mov bh, 0x00    ; page
    int 0x00

    popa
    mov sp, bp
    pop bp
    ret

msg: db "Bootloader test", 0

print:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]
    mov bh, 0x00
    mov bl, 0x00
    mov ah, 0x0E
.char:
    mov al, [si]
    add si, 1
    or al, 0
    je .return
    int 0x10
    jmp .char
.return:
    popa
    mov sp, bp
    pop bp
    ret

times 510-($-$$) db 0
dw 0xAA55