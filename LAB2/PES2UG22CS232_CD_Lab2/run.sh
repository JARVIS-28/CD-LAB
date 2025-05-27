#!/bin/bash

# Enable error handling
set -e  # Exit if any command fails

echo "Running Flex..."
flex lexer.l || { echo "Flex failed"; exit 1; }

echo "Running Bison..."
bison -d parser.y || { echo "Bison failed"; exit 1; }

echo "Compiling with GCC..."
gcc -c lex.yy.c -o lex.yy.o || { echo "Compiling lex.yy.c failed"; exit 1; }
gcc -c parser.tab.c -o parser.tab.o || { echo "Compiling parser.tab.c failed"; exit 1; }
gcc -c sym_tab.c -o sym_tab.o || { echo "Compiling sym_tab.c failed"; exit 1; }

echo "Linking..."
gcc lex.yy.o parser.tab.o sym_tab.o -lfl -o parser || { echo "Linking failed"; exit 1; }

echo "Cleaning up object files..."
rm -f lex.yy.o parser.tab.o sym_tab.o

echo "Running Parser on sample_input1.c..."
./parser < sample_input1.c > output1.txt || { echo "Parser execution failed"; exit 1; }

echo "Execution completed. Check output1.txt."
