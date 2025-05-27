%{
	#include "sym_tab.h"
	#include "parser.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	
	int scope=0;
	int type=-1;
	char* vval = "~";
	
	/*
		declare variables to help you keep track or store properties
		scope can be default value for this lab(implementation in the next lab)
	*/
	void yyerror(char* s); // error handling function
	int yylex(void); // declare the function performing lexical analysis
	extern int yylineno; // track the line number



	int get_size_of_type(int type) {
        switch(type) {
            case 1: return 1;  // CHAR
            case 2: return 2;  // INT
            case 3: return 4;  // FLOAT
            case 4: return 8;  // DOUBLE
            default: return 0;
        }
    }

%}

%union {
    int ival;      // For integers
    char* sval;    // For strings (identifiers, literals, etc.)
}

%token <sval> T_ID T_STRLITERAL T_NUM
%token T_INT T_CHAR T_DOUBLE T_WHILE T_INC T_DEC T_OROR T_ANDAND
%token T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT
%token T_RIGHTSHIFT T_PRINTLN T_STRING T_FLOAT T_BOOLEAN T_IF
%token T_ELSE T_DO T_INCLUDE T_HEADER T_MAIN

%start START


%%
START : PROG { printf("Valid syntax\n"); YYACCEPT; }	
        ;	
	  
PROG :  MAIN PROG				
	|DECLR ';' PROG 				
	| ASSGN ';' PROG 			
	| 					
	;
	 

DECLR : TYPE LISTVAR 
	;	


LISTVAR : LISTVAR ',' VAR 
	  | VAR
	  ;

VAR: T_ID '=' EXPR 	{
				/*
					to be done in lab 3
				*/
			}
     | T_ID 		{
				/*
                   			check if symbol is in table
                    			if it is then print error for redeclared variable
                    			else make an entry and insert into the table
                    			revert variables to default values:type
                    		*/
				if(check_symbol_table($1)) {
                    printf("Error: Variable %s already declared\n", $1);
                    exit(1);
                }
                symbol* s = init_symbol($1, get_size_of_type(type), type, yylineno, scope);
                insert_into_table(s);
			}	 

//assign type here to be returned to the declaration grammar
TYPE : T_INT     { type = 2; }
       | T_FLOAT    { type = 3; }
       | T_DOUBLE   { type = 4; }
       | T_CHAR     { type = 1; }
       ;
    
/* Grammar for assignment */   
ASSGN : T_ID '=' EXPR 	{
				/*
					to be done in lab 3
				*/
			}
	;

EXPR : EXPR REL_OP E
       | E 
       ;
	   
E : E '+' T
    | E '-' T
    | T 
    ;
	
	
T : T '*' F
    | T '/' F
    | F
    ;

F : '(' EXPR ')'
    | T_ID
    | T_NUM 
    | T_STRLITERAL 
    ;

REL_OP :   T_LESSEREQ
	   | T_GREATEREQ
	   | '<' 
	   | '>' 
	   | T_EQCOMP
	   | T_NOTEQUAL
	   ;	


/* Grammar for main function */
MAIN : TYPE T_MAIN '(' EMPTY_LISTVAR ')' '{' {scope++;} STMT '}' {scope--;};

EMPTY_LISTVAR : LISTVAR
		|	
		;

STMT : STMT_NO_BLOCK STMT
       | BLOCK STMT
       |
       ;


STMT_NO_BLOCK : DECLR ';'
       | ASSGN ';' 
       ;

BLOCK : '{' STMT '}';

COND : EXPR 
       | ASSGN
       ;


%%


/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


int main(int argc, char* argv[])
{
	/* initialise table here */
	t = init_table();
	if (t == NULL) {
        fprintf(stderr, "Failed to initialize symbol table\n");
        return 1;
    }
	if (yyparse() != 0) {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }
    
	/* display final symbol table*/
	display_symbol_table();

	return 0;

}
