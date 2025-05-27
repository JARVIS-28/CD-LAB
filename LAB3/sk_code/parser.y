parser.y



%{
	#include "sym_tab.h"
	
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "parser.tab.h"
	
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
    float fval;    // For floating point values
    char* sval;    // For strings (identifiers, literals, etc.)
    struct exprval exprval;   
}

%type <exprval> EXPR E T F

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

                if (check_symbol_table($1)) {
            printf("Error: Variable %s alreaFdy declared\n", $1);
            exit(1);
        }
        symbol* s = init_symbol($1, get_size_of_type(type), type, yylineno, scope);
        char buffer[64];
// Inside VAR: T_ID '=' EXPR block in parser.y
if ($3.type == 2) { // INT
    sprintf(buffer, "%d", $3.val.ival);
} else if ($3.type == 3) { // FLOAT
    sprintf(buffer, "%.6f", $3.val.fval);
} else if ($3.type == 4) { // DOUBLE
    sprintf(buffer, "%.6lf", $3.val.dval);
} else if ($3.type == 1) { // CHAR
    sprintf(buffer, "%c", $3.val.cval);
}
free(s->val);
s->val = strdup(buffer);
        insert_into_table(s);
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
ASSGN : T_ID '=' EXPR {
    if (!check_symbol_table($1)) {
        printf("Error: Variable %s not declared\n", $1);
        exit(1);
    }
    
    symbol* s = get_symbol($1);
    char buffer[64];

    if ($3.type == 2) {  // INT
        sprintf(buffer, "%d", $3.val.ival);
    } else if ($3.type == 3) {  // FLOAT
        sprintf(buffer, "%.6f", $3.val.fval);
    } else if ($3.type == 4) {  // DOUBLE
        sprintf(buffer, "%.6lf", $3.val.dval);
    } else if ($3.type == 1) {  // CHAR
        sprintf(buffer, "%c", $3.val.cval);
    }

    free(s->val);
    s->val = strdup(buffer);
}


EXPR : EXPR REL_OP E { $$ = $1; } 
      | E { $$ = $1; } 
      ;

E : E '+' T { 
      $$.type = $1.type > $3.type ? $1.type : $3.type; // Use higher precision type
      if ($$.type == 2) { // INT
          $$.val.ival = $1.val.ival + $3.val.ival;
      } else if ($$.type == 3) { // FLOAT
          $$.val.fval = ($1.type == 3 ? $1.val.fval : (float)$1.val.ival) + 
                      ($3.type == 3 ? $3.val.fval : (float)$3.val.ival);
      } else if ($$.type == 4) { // DOUBLE
          $$.val.dval = ($1.type == 4 ? $1.val.dval : ($1.type == 3 ? (double)$1.val.fval : (double)$1.val.ival)) + 
                      ($3.type == 4 ? $3.val.dval : ($3.type == 3 ? (double)$3.val.fval : (double)$3.val.ival));
      }
    }
    | E '-' T { 
      $$.type = $1.type > $3.type ? $1.type : $3.type; // Use higher precision type
      if ($$.type == 2) { // INT
          $$.val.ival = $1.val.ival - $3.val.ival;
      } else if ($$.type == 3) { // FLOAT
          $$.val.fval = ($1.type == 3 ? $1.val.fval : (float)$1.val.ival) - 
                      ($3.type == 3 ? $3.val.fval : (float)$3.val.ival);
      } else if ($$.type == 4) { // DOUBLE
          $$.val.dval = ($1.type == 4 ? $1.val.dval : ($1.type == 3 ? (double)$1.val.fval : (double)$1.val.ival)) - 
                      ($3.type == 4 ? $3.val.dval : ($3.type == 3 ? (double)$3.val.fval : (double)$3.val.ival));
      }
    }
    | T { $$ = $1; }
    ;

T : T '*' F { 
      $$.type = $1.type > $3.type ? $1.type : $3.type; // Use higher precision type
      if ($$.type == 2) { // INT
          $$.val.ival = $1.val.ival * $3.val.ival;
      } else if ($$.type == 3) { // FLOAT
          $$.val.fval = ($1.type == 3 ? $1.val.fval : (float)$1.val.ival) * 
                      ($3.type == 3 ? $3.val.fval : (float)$3.val.ival);
      } else if ($$.type == 4) { // DOUBLE
          $$.val.dval = ($1.type == 4 ? $1.val.dval : ($1.type == 3 ? (double)$1.val.fval : (double)$1.val.ival)) * 
                      ($3.type == 4 ? $3.val.dval : ($3.type == 3 ? (double)$3.val.fval : (double)$3.val.ival));
      }
    }
    | T '/' F { 
      $$.type = $1.type > $3.type ? $1.type : $3.type; // Use higher precision type
      if ($3.type == 2 && $3.val.ival == 0) {
          printf("Error: Division by zero\n");
          exit(1);
      }
      if ($$.type == 2) { // INT
          $$.val.ival = $1.val.ival / $3.val.ival;
      } else if ($$.type == 3) { // FLOAT
          $$.val.fval = ($1.type == 3 ? $1.val.fval : (float)$1.val.ival) / 
                      ($3.type == 3 ? $3.val.fval : (float)$3.val.ival);
      } else if ($$.type == 4) { // DOUBLE
          $$.val.dval = ($1.type == 4 ? $1.val.dval : ($1.type == 3 ? (double)$1.val.fval : (double)$1.val.ival)) / 
                      ($3.type == 4 ? $3.val.dval : ($3.type == 3 ? (double)$3.val.fval : (double)$3.val.ival));
      }
    }
    | F { $$ = $1; }
    ;

F : '(' EXPR ')' { $$ = $2; }
    | T_ID { 
        if (!check_symbol_table($1)) {
            printf("Error: Variable %s not declared\n", $1);
            exit(1);
        }
        $$ = get_symbol_value($1);  // Fetch stored value
    }
    | T_NUM {
        if (strchr($1, '.')) { 
        $$.type = 3; 
        $$.val.fval = atof($1);
    } else {
        $$.type = 2;  // INT
        $$.val.ival = atoi($1);
    }
    }
    | T_STRLITERAL {
        $$.type = 1;  // Assume char type
        $$.val.cval = $1[1];
    };

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
              | IF_ELSE  /* New Rule for if-else */
              ;
IF_ELSE : T_IF '(' COND ')' BLOCK 
        | T_IF '(' COND ')' BLOCK T_ELSE BLOCK 
        ;

BLOCK : '{' STMT '}';

COND : EXPR REL_OP EXPR 
     | '(' COND ')' 
     | T_ID REL_OP T_ID
     | T_ID REL_OP T_NUM
     | T_NUM REL_OP T_ID
     | T_NUM REL_OP T_NUM
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