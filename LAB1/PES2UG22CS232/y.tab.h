
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
     TOKEN_NUMBER = 258,
     TOKEN_CHAR_LITERAL = 259,
     TOKEN_IDENTIFIER = 260,
     TOKEN_GREATER_THAN = 261,
     TOKEN_LESS_THAN = 262,
     TOKEN_EQUAL = 263,
     TOKEN_ASSIGN = 264,
     TOKEN_LESS_EQUAL = 265,
     TOKEN_GREATER_EQUAL = 266,
     TOKEN_LEFT_PAREN = 267,
     TOKEN_RIGHT_PAREN = 268,
     TOKEN_LEFT_BRACE = 269,
     TOKEN_RIGHT_BRACE = 270,
     TOKEN_LEFT_BRACKET = 271,
     TOKEN_RIGHT_BRACKET = 272,
     TOKEN_PLUS = 273,
     TOKEN_MINUS = 274,
     TOKEN_MULTIPLY = 275,
     TOKEN_DIVIDE = 276,
     TOKEN_MODULO = 277,
     TOKEN_COMMA = 278,
     TOKEN_SEMICOLON = 279,
     TOKEN_COLON = 280,
     TOKEN_INT = 281,
     TOKEN_CHAR = 282,
     TOKEN_DOUBLE = 283,
     TOKEN_FLOAT = 284,
     TOKEN_RETURN = 285,
     TOKEN_BREAK = 286,
     TOKEN_CONTINUE = 287,
     TOKEN_SWITCH = 288,
     TOKEN_CASE = 289,
     TOKEN_WHILE = 290,
     TOKEN_DO = 291,
     TOKEN_IF = 292,
     TOKEN_FOR = 293,
     TOKEN_ELSE = 294,
     TOKEN_DEFAULT = 295,
     TOKEN_MAIN = 296,
     TOKEN_LOGICAL_OR = 297,
     TOKEN_LOGICAL_AND = 298,
     TOKEN_NOT_EQUAL = 299,
     TOKEN_LOGICAL_NOT = 300,
     LOWER_THAN_ELSE = 301
   };
#endif
/* Tokens.  */
#define TOKEN_NUMBER 258
#define TOKEN_CHAR_LITERAL 259
#define TOKEN_IDENTIFIER 260
#define TOKEN_GREATER_THAN 261
#define TOKEN_LESS_THAN 262
#define TOKEN_EQUAL 263
#define TOKEN_ASSIGN 264
#define TOKEN_LESS_EQUAL 265
#define TOKEN_GREATER_EQUAL 266
#define TOKEN_LEFT_PAREN 267
#define TOKEN_RIGHT_PAREN 268
#define TOKEN_LEFT_BRACE 269
#define TOKEN_RIGHT_BRACE 270
#define TOKEN_LEFT_BRACKET 271
#define TOKEN_RIGHT_BRACKET 272
#define TOKEN_PLUS 273
#define TOKEN_MINUS 274
#define TOKEN_MULTIPLY 275
#define TOKEN_DIVIDE 276
#define TOKEN_MODULO 277
#define TOKEN_COMMA 278
#define TOKEN_SEMICOLON 279
#define TOKEN_COLON 280
#define TOKEN_INT 281
#define TOKEN_CHAR 282
#define TOKEN_DOUBLE 283
#define TOKEN_FLOAT 284
#define TOKEN_RETURN 285
#define TOKEN_BREAK 286
#define TOKEN_CONTINUE 287
#define TOKEN_SWITCH 288
#define TOKEN_CASE 289
#define TOKEN_WHILE 290
#define TOKEN_DO 291
#define TOKEN_IF 292
#define TOKEN_FOR 293
#define TOKEN_ELSE 294
#define TOKEN_DEFAULT 295
#define TOKEN_MAIN 296
#define TOKEN_LOGICAL_OR 297
#define TOKEN_LOGICAL_AND 298
#define TOKEN_NOT_EQUAL 299
#define TOKEN_LOGICAL_NOT 300
#define LOWER_THAN_ELSE 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 17 "parser.y"

    float float_val;
    int int_val;
    char char_val;



/* Line 1676 of yacc.c  */
#line 152 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


