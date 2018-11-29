@echo off
del y.output
del intermedia.txt
del Final.exe
del Final.asm
del Final.obj

c:\GnuWin32\bin\bison -dyv sintactico.y
c:\GnuWin32\bin\flex lexico.l

c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o segunda.exe
segunda.exe prueba.txt
@echo off
del segunda.exe
del lex.yy.c
del y.tab.c

pause

