
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IF = 258,
     ELSE = 259,
     WHILE = 260,
     DEFVAR = 261,
     ENDDEF = 262,
     WRITE = 263,
     READ = 264,
     AVG = 265,
     INLIST = 266,
     REAL = 267,
     BINA = 268,
     ENTERO = 269,
     BOOLEANO = 270,
     STRING_CONST = 271,
     ID = 272,
     FLOAT = 273,
     INT = 274,
     STRING = 275,
     BOOL = 276,
     P_A = 277,
     P_C = 278,
     C_A = 279,
     C_C = 280,
     L_A = 281,
     L_C = 282,
     PUNTO_Y_COMA = 283,
     D_P = 284,
     COMA = 285,
     OP_CONCAT = 286,
     OP_SUM = 287,
     OP_RES = 288,
     OP_DIV = 289,
     OP_MUL = 290,
     MOD = 291,
     DIV = 292,
     CMP_MAY = 293,
     CMP_MEN = 294,
     CMP_MAYI = 295,
     CMP_MENI = 296,
     CMP_DIST = 297,
     CMP_IGUAL = 298,
     ASIG = 299,
     AND = 300,
     OR = 301
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define WHILE 260
#define DEFVAR 261
#define ENDDEF 262
#define WRITE 263
#define READ 264
#define AVG 265
#define INLIST 266
#define REAL 267
#define BINA 268
#define ENTERO 269
#define BOOLEANO 270
#define STRING_CONST 271
#define ID 272
#define FLOAT 273
#define INT 274
#define STRING 275
#define BOOL 276
#define P_A 277
#define P_C 278
#define C_A 279
#define C_C 280
#define L_A 281
#define L_C 282
#define PUNTO_Y_COMA 283
#define D_P 284
#define COMA 285
#define OP_CONCAT 286
#define OP_SUM 287
#define OP_RES 288
#define OP_DIV 289
#define OP_MUL 290
#define MOD 291
#define DIV 292
#define CMP_MAY 293
#define CMP_MEN 294
#define CMP_MAYI 295
#define CMP_MENI 296
#define CMP_DIST 297
#define CMP_IGUAL 298
#define ASIG 299
#define AND 300
#define OR 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 196 "sintactico.y"

 char s[500];



/* Line 1676 of yacc.c  */
#line 150 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


