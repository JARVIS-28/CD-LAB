#!/bin/bash

# lex lexer.l
# yacc -d parser.y
flex lexer.l
bison -d parser.y
gcc -g y.tab.c lex.yy.c -ll

rm lex.yy.c
rm y.tab.c
rm y.tab.h

./a.out < test_input_1.c
./a.out < test_input_2.c

gcc -g parser.tab.c lex.yy.c C:/GnuWin32/lib/libfl.a -o parser.exe