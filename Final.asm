include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    MAXTEXTSIZE equ 50
    __flags dw ? 
    __descar dd ? 
    oldcw dw ? 
    __auxConc db MAXTEXTSIZE dup (?), '$'
    __resultConc db MAXTEXTSIZE dup (?), '$'
    msgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'
    _newLine db 0Dh, 0Ah,'$'
vtext db 100 dup('$')
 
;Declaracion de variables de usuario
    @a  dd  ?
    @d  dd  ?
    @b  dd  ?
    @c  dd  ?
    @pri    db  MAXTEXTSIZE dup (?),'$'
    @_0p12  dd  0.120
    @_1 dd  1.000
    @_12p1  dd  12.100
    @_escribir_en_pantalla  db  'Escribir en pantalla','$',29 dup (?)
    @_hola  db  'Hola','$',45 dup (?)
    @_2 dd  2.000
    @_4 dd  4.000
    @_6 dd  6.000
    @aux    DD 0.0

.CODE
START:

    MOV AX, @DATA

    MOV DS, AX

    MOV ES, AX


;Comienzo codigo de usuario

    fld @_0p12
    fstp @a
    fld @_1
    fstp @b
    fld @_12p1
    fstp @d

    LEA DX, @_escribir_en_pantalla 
    MOV AH, 9
    INT 21H
    newline
    MOV SI, OFFSET @_hola
    MOV DI, OFFSET @pri
    call COPIAR

    LEA DX, @pri 
    MOV AH, 9
    INT 21H
    newline
    displayFloat @a, 2
    newline
    displayFloat @b, 2
    newline
    displayFloat @d, 2
    newline
    fstp @aux
    fld @_2
    fld @aux
    fadd St(0),St(1)
    fstp @aux
    fld @_4
    fld @aux
    fadd St(0),St(1)
    fstp @aux
    fld @_6
    fld @aux
    fadd St(0),St(1)
    fstp @aux
    fld @aux
    fdiv St(0),St(1)
    fstp @aux
    fstp @a
    displayFloat @a, 2
    newline

;finaliza el asm
    mov ah,4ch
    mov al,0
    int 21h

STRLEN PROC NEAR
    mov BX,0

STRL01:
    cmp BYTE PTR [SI+BX],'$'
    je STREND
    inc BX
    jmp STRL01

STREND:
    ret

STRLEN ENDP

COPIAR PROC NEAR
    call STRLEN
    cmp BX,MAXTEXTSIZE
    jle COPIARSIZEOK
    mov BX,MAXTEXTSIZE

COPIARSIZEOK:
    mov CX,BX
    cld
    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al
    ret

COPIAR ENDP

CONCAT PROC NEAR
    push ds
    push si
    call STRLEN
    mov dx,bx
    mov si,di
    push es
    pop ds
    call STRLEN
    add di,bx
    add bx,dx
    cmp bx,MAXTEXTSIZE
    jg CONCATSIZEMAL

CONCATSIZEOK:
    mov cx,dx
    jmp CONCATSIGO

CONCATSIZEMAL:
    sub bx,MAXTEXTSIZE
    sub dx,bx
    mov cx,dx

CONCATSIGO:
    push ds
    pop es
    pop si
    pop ds
    cld
    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al
    ret

CONCAT ENDP
END START; final del archivo. 
