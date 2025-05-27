%{
    #include "y.tab.h"
    #include <stdio.h>
    
    int yylineno = 1;
    void yyerror(const char*);
%}
digit [0-9]
id [a-zA-Z_][a-zA-Z0-9_]*
number {digit}+|{digit}*\.{digit}+
char '.'|'\\n'|'\\t'|'\\r'|'\\0'

%%
"/*"([^*]|\*+[^/])*"*/"       { /* ignore multi-line comments */ }
"//".*                         { /* ignore single-line comments */ }
"=="                           { return TOKEN_EQUAL; }
"!="                           { return TOKEN_NOT_EQUAL; }
">="                           { return TOKEN_GREATER_EQUAL; }
"<="                           { return TOKEN_LESS_EQUAL; }
"||"                           { return TOKEN_LOGICAL_OR; }
"&&"                           { return TOKEN_LOGICAL_AND; }
">"                            { return TOKEN_GREATER_THAN; }
"<"                            { return TOKEN_LESS_THAN; }
"="                            { return TOKEN_ASSIGN; }
"!"                            { return TOKEN_LOGICAL_NOT; }
"+"                            { return TOKEN_PLUS; }
"-"                            { return TOKEN_MINUS; }
"*"                            { return TOKEN_MULTIPLY; }
"/"                            { return TOKEN_DIVIDE; }
"%"                            { return TOKEN_MODULO; }
"("                            { return TOKEN_LEFT_PAREN; }
")"                            { return TOKEN_RIGHT_PAREN; }
"{"                            { return TOKEN_LEFT_BRACE; }
"}"                            { return TOKEN_RIGHT_BRACE; }
"["                            { return TOKEN_LEFT_BRACKET; }
"]"                            { return TOKEN_RIGHT_BRACKET; }
","                            { return TOKEN_COMMA; }
";"                            { return TOKEN_SEMICOLON; }
":"                            { return TOKEN_COLON; }
"int"                         { return TOKEN_INT; }
"main"                        { return TOKEN_MAIN; }
"char"                        { return TOKEN_CHAR; }
"double"                      { return TOKEN_DOUBLE; }
"float"                       { return TOKEN_FLOAT; }
"return"                      { return TOKEN_RETURN; }
"break"                       { return TOKEN_BREAK; }
"continue"                    { return TOKEN_CONTINUE; }
"switch"                      { return TOKEN_SWITCH; }
"case"                        { return TOKEN_CASE; }
"while"                       { return TOKEN_WHILE; }
"do"                          { return TOKEN_DO; }
"if"                          { return TOKEN_IF; }
"for"                         { return TOKEN_FOR; }
"else"                        { return TOKEN_ELSE; }
"default"                     { return TOKEN_DEFAULT; }
{char}                        { yylval.char_val = yytext[1]; return TOKEN_CHAR_LITERAL; }
{number}                      { yylval.float_val = atof(yytext); return TOKEN_NUMBER; }
{id}                          { yylval.int_val = 0; /* Or assign something meaningful */ return TOKEN_IDENTIFIER; }
\n                            { yylineno++; }
[ \t]+                        { /* ignore whitespace */ }
.                             { printf("Unexpected character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
}
