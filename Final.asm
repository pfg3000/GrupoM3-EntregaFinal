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
    @_12p1  dd  12.100
    @_7p0   dd  7.000
    @_3p0   dd  3.000
    @_inlist_con_expresiones    db  'INLIST con expresiones','$',27 dup (?)
    @_1 dd  1.000
    @_2 dd  2.000
    @_4p0   dd  4.000
    @_4 dd  4.000
    @_5 dd  5.000
    @_encontrado    db  'encontrado','$',39 dup (?)
    @_no_encontrado db  'no encontrado','$',36 dup (?)
    @aux    DD 0.0
    @___aux0    DD 0.0
    @___aux1    DD 1.0
    @___aux2    DD 1.0
    @___aux3    DD 1.0
    @___aux4    DD 1.0
    @___aux5    DD 1.0
    @___aux6    DD 1.0

.CODE
START:

    MOV AX, @DATA

    MOV DS, AX

    MOV ES, AX


;Comienzo codigo de usuario

    fld @_0p12
    fstp @a
    fld @_12p1
    fstp @d
    fld @_7p0
    fstp @b
    fld @_3p0
    fstp @c

    LEA DX, @_inlist_con_expresiones 
    MOV AH, 9
    INT 21H
    newline
    fld @___aux0
    fstp @aux
    fld @_1
    fcomp @b
    fstsw AX
    sahf
    JNZ @@etiq1
    fld @___aux1
    fstp @aux
@@etiq1:
    fld @_2
    fcomp @b
    fstsw AX
    sahf
    JNZ @@etiq2
    fld @___aux2
    fstp @aux
@@etiq2:
    fld @c
    fld @_4p0
    fadd St(0),St(1)
    fcomp @b
    fstsw AX
    sahf
    JNZ @@etiq3
    fld @___aux3
    fstp @aux
@@etiq3:
    fld @_4
    fcomp @b
    fstsw AX
    sahf
    JNZ @@etiq4
    fld @___aux4
    fstp @aux
@@etiq4:
    fld @_5
    fcomp @b
    fstsw AX
    sahf
    JNZ @@etiq5
    fld @___aux5
    fstp @aux
@@etiq5:
    fld @aux
    fcomp @___aux6
    fstsw AX
    sahf
    JNZ @@etiq6

    LEA DX, @_encontrado 
    MOV AH, 9
    INT 21H
    newline
    jmp @@etiq7
@@etiq6:

    LEA DX, @_no_encontrado 
    MOV AH, 9
    INT 21H
    newline
@@etiq7:

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
