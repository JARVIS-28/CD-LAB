%{ 
    #include "sym_tab.h" 
    #include <stdio.h> 
    #include <stdlib.h> 
    #include <string.h> 
    #define YYSTYPE char* 
     
    // Global variables for symbol table management 
    table* sym_table; 
    int current_scope = 0; 
    char current_type[20];  // To store the current declaration type 
    char temp_value[100];   // For expression evaluation 
     
    void yyerror(char* s); // error handling function 
    int yylex(); // declare the function performing lexical analysis 
    extern int yylineno; // track the line number 
     
    // Helper functions for expression evaluation and type checking 
    int get_type_size(char* type) { 
        if (strcmp(type, "int") == 0) return 4; 
        if (strcmp(type, "float") == 0) return 4; 
        if (strcmp(type, "double") == 0) return 8; 
        if (strcmp(type, "char") == 0) return 1; 
        return 0; 
    } 
     
    int get_symbol_type(char* type_str) { 
        if (strcmp(type_str, "int") == 0) return 1; 
        if (strcmp(type_str, "float") == 0) return 2; 
        if (strcmp(type_str, "double") == 0) return 3; 
        if (strcmp(type_str, "char") == 0) return 4; 
        return 0; 
    } 
     
    // Function to perform arithmetic operations 
    char* perform_arithmetic(char* op1, char* operator, char* op2) { 
        double num1 = atof(op1); 
        double num2 = atof(op2); 
        double result; 
         
        switch(*operator) { 
            case '+': result = num1 + num2; break; 
            case '-': result = num1 - num2; break; 
            case '*': result = num1 * num2; break; 
            case '/':  
                if(num2 == 0) { 
                    yyerror("Division by zero"); 
                    return strdup("0"); 
                } 
                result = num1 / num2;  
                break; 
            default: result = 0; 
        } 
         
        sprintf(temp_value, "%g", result); 
        return strdup(temp_value); 
    } 
%} 
 
%token T_INT T_CHAR T_DOUBLE T_WHILE T_INC T_DEC T_OROR T_ANDAND 
T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT 
T_PRINTLN T_STRING T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO 
T_INCLUDE T_HEADER T_MAIN T_ID T_NUM 
 
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
 
VAR: T_ID '=' EXPR     { 
                // Check if symbol is in the table 
                if (check_symbol_table(sym_table, $1)) { 
                    char err_msg[100]; 
                    sprintf(err_msg, "Redeclaration of variable '%s'", $1); 
                    yyerror(err_msg); 
                } else { 
                    // Create and insert the new symbol 
                    int type = get_symbol_type(current_type); 
                    int size = get_type_size(current_type); 
                    symbol* sym = init_symbol($1, size, type, yylineno, current_scope); 
                    insert_into_table(sym_table, sym); 
                    insert_value_to_name(sym_table, $1, $3); 
                } 
            } 
     | T_ID         { 
                // Check if symbol is in the table 
                if (check_symbol_table(sym_table, $1)) { 
                    char err_msg[100]; 
                    sprintf(err_msg, "Redeclaration of variable '%s'", $1); 
                    yyerror(err_msg); 
                } else { 
                    // Create and insert the new symbol (without value) 
                    int type = get_symbol_type(current_type); 
                    int size = get_type_size(current_type); 
                    symbol* sym = init_symbol($1, size, type, yylineno, current_scope); 
                    insert_into_table(sym_table, sym); 
                } 
            }      
 
//assign type here to be returned to the declaration grammar 
TYPE : T_INT     { strcpy(current_type, "int"); } 
       | T_FLOAT { strcpy(current_type, "float"); } 
       | T_DOUBLE { strcpy(current_type, "double"); } 
       | T_CHAR  { strcpy(current_type, "char"); } 
       ; 
     
/* Grammar for assignment */    
ASSGN : T_ID '=' EXPR     { 
            // Check if variable is declared in the table 
            if (!check_symbol_table(sym_table, $1)) { 
                char err_msg[100]; 
                sprintf(err_msg, "Undeclared variable '%s'", $1); 
                yyerror(err_msg); 
            } else { 
                insert_value_to_name(sym_table, $1, $3); 
            } 
            } 
    ; 
 
EXPR : EXPR REL_OP E { $$ = $1; /* Relational operations not implemented in this version */ } 
       | E     { $$ = $1; } 
       ; 
        
/* Expression Grammar */        
E : E '+' T     {  
            $$ = perform_arithmetic($1, "+", $3); 
        } 
    | E '-' T     {  
            $$ = perform_arithmetic($1, "-", $3); 
        } 
    | T { $$ = $1; } 
    ; 
     
     
T : T '*' F     {  
            $$ = perform_arithmetic($1, "*", $3); 
        } 
    | T '/' F     {  
            $$ = perform_arithmetic($1, "/", $3); 
        } 
    | F { $$ = $1; } 
    ; 
 
F : '(' EXPR ')' { $$ = $2; } 
    | T_ID     { 
            // Check if variable is in table 
            if (!check_symbol_table(sym_table, $1)) { 
                char err_msg[100]; 
                sprintf(err_msg, "Undeclared variable '%s'", $1); 
                yyerror(err_msg); 
                $$ = strdup("0"); 
            } else { 
                // Not checking for initialization in this simplified version 
                // In a full implementation, you'd check if value is NULL 
                symbol* current = sym_table->head; 
                while (current != NULL) { 
                    if (strcmp(current->name, $1) == 0) { 
                        if (current->value != NULL) { 
                            $$ = strdup(current->value); 
                        } else { 
                            char err_msg[100]; 
                            sprintf(err_msg, "Uninitialized variable '%s'", $1); 
                            yyerror(err_msg); 
                            $$ = strdup("0"); 
                        } 
                        break; 
                    } 
                    current = current->next; 
                } 
            } 
        } 
    | T_NUM     { 
                $$ = $1; 
        } 
    | T_STRLITERAL { 
                $$ = $1; 
        } 
    ; 
 
 
 
REL_OP :   T_LESSEREQ 
       | T_GREATEREQ 
       | '<'  
       | '>'  
       | T_EQCOMP 
       | T_NOTEQUAL 
       ;     
 
 
/* Grammar for main function */ 
MAIN : TYPE T_MAIN '(' EMPTY_LISTVAR ')' '{' { current_scope++; } STMT '}' { 
current_scope--; }; 
 
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
        
BLOCK : '{' { current_scope++; } STMT '}' { current_scope--; }; 
 
COND : EXPR  
       | ASSGN 
       ; 
 
 
%% 
 
 
/* error handling function */ 
void yyerror(char* s) 
{ 
    printf("Error: %s at line %d\n", s, yylineno); 
} 
 
 
int main(int argc, char* argv[]) 
{ 
    /* initialise table here */ 
    sym_table = init_table(); 
     
    yyparse(); 
     
    /* display final symbol table*/ 
    display_symbol_table(sym_table); 
     
    return 0; 
} 