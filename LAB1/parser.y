%{
#include<stdio.h>
#include<stdlib.h>

void yyerror(const char *s);
int yylex();
%}

%token INT FLOAT CHAR ID NL

%%
P : S NL           { printf("Valid Declaration\n"); YYACCEPT; }
  ;

S : D              // Single declaration
  ;

D : Type List_Var ';' // Declaration with a type and variable list
  ;

Type : INT         // Data types
     | FLOAT
     | CHAR
     ;

List_Var : List_Var ',' ID // Variable list
         | ID
         ;
%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
    exit(1);
}

int main() {
    printf("Enter declarations (e.g., int a, b;):\n");
    if (!yyparse()) {
        printf("Parsing Successful\n");
    } else {
        printf("Parsing Unsuccessful\n");
    }
    return 0;
}
