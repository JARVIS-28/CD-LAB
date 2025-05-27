
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym_tab.h"



table* t = NULL;

table* init_table()	
{
	/*
        allocate space for table pointer structure eg (t_name)* t
        initialise head variable eg t->head
        return structure
    	*/
        
        t = (table*)malloc(sizeof(table));
        if (t == NULL) {
            fprintf(stderr, "Failed to allocate memory for symbol table\n");
            exit(1);
        }
        t->head = NULL;
        return t;
}

symbol* init_symbol(char* name, int size, int type, int lineno, int scope) //allocates space for items in the list
{
	/*
        allocate space for entry pointer structure eg (s_name)* s
        initialise all struct variables(name, value, type, scope, length, line number)
        return structure
    	*/
        symbol* s = (symbol*)malloc(sizeof(symbol));
        if (s == NULL) {
            fprintf(stderr, "Failed to allocate memory for symbol\n");
            exit(1);
        }
        
        s->name = strdup(name);
        if (s->name == NULL) {
            fprintf(stderr, "Failed to allocate memory for symbol name\n");
            free(s);
            exit(1);
        }
        
        s->size = size;
        s->type = type;
        s->val = strdup("~");
        if (s->val == NULL) {
            fprintf(stderr, "Failed to allocate memory for symbol value\n");
            free(s->name);
            free(s);
            exit(1);
        }
        
        s->line = lineno;
        s->scope = scope;
        s->next = NULL;
        return s;
}

void insert_into_table(symbol* s)/* 
 arguments can be the structure s_name already allocated before this function call
 or the variables to be sent to allocate_space_for_table_entry for initialisation        
*/
{
    /*
        check if table is empty or not using the struct table pointer
        else traverse to the end of the table and insert the entry
    */
    if(t->head == NULL) {
        t->head = s;
        return;
    }
    
    symbol* current = t->head;
    while(current->next != NULL) {
        current = current->next;
    }
    current->next = s;
}

int check_symbol_table(char* name) //return a value like integer for checking
{
    /*
        check if table is empty and return a value like 0
        else traverse the table
        if entry is found return a value like 1
        if not return a value like 0
    */
    if(t->head == NULL) {
        return 0;
    }
    
    symbol* current = t->head;
    while(current != NULL) {
        if(strcmp(current->name, name) == 0) {
            return 1;
        }
        current = current->next;
    }
    return 0;
}

void insert_value_to_name(char* name, char* value)
{
    /*
        if value is default value return back
        check if table is empty
        else traverse the table and find the name
        insert value into the entry structure
    */
    if(strcmp(value, "~") == 0) {
        return;
    }
    
    if(t->head == NULL) {
        return;
    }
    
    symbol* current = t->head;
    while(current != NULL) {
        if(strcmp(current->name, name) == 0) {
            current->val = strdup(value);
            return;
        }
        current = current->next;
    }
}

void display_symbol_table()
{
    /*
        traverse through table and print every entry
        with its struct variables
    */
    printf("Name\tsize\ttype\tlineno\tscope\tvalue\n");
    
    symbol* current = t->head;
    while(current != NULL) {
        printf("%s\t\t%d\t\t%d\t\t%d\t\t%d\t\t%s\n", 
               current->name, 
               current->size,
               current->type,
               current->line,
               current->scope,
               current->val);
        current = current->next;
    }
}

void update_symbol_value(char* name, struct exprval new_val) {
    symbol* s = lookup_symbol(name);
    if (!s) {
        printf("Error: Variable %s not declared\n", name);
        exit(1);
    }

    char buffer[64];  // Convert the value to string before storing

    if (s->type == 2) { // INT
        sprintf(buffer, "%d", new_val.val.ival);
    } else if (s->type == 3) { // FLOAT
        sprintf(buffer, "%.6f", new_val.val.fval);
    } else if (s->type == 4) { // DOUBLE
        sprintf(buffer, "%.6lf", new_val.val.dval);
    } else if (s->type == 1) { // CHAR
        sprintf(buffer, "%c", new_val.val.cval);
    }

    free(s->val);
    s->val = strdup(buffer);  // Store the updated value in symbol table
}


struct exprval get_symbol_value(char* id) {
    struct exprval result;
    symbol* current = t->head;
    while(current != NULL) {
        if(strcmp(current->name, id) == 0) {
            result.type = current->type;
            if (current->type == 2) { // INT
                result.val.ival = atoi(current->val);
            } else if (current->type == 3) { // FLOAT
                result.val.fval = atof(current->val);
            } else if (current->type == 4) { // DOUBLE
                result.val.dval = atof(current->val);
            } else if (current->type == 1) { // CHAR
                result.val.cval = current->val[0];
            }
            return result;
        }
        current = current->next;
    }
    printf("Error: Variable %s not found\n", id);
    exit(1);
}

symbol* lookup_symbol(char* name) {
    if(t->head == NULL) {
        return NULL;
    }
    
    symbol* current = t->head;
    while(current != NULL) {
        if(strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

symbol* get_symbol(char* name) {
    return lookup_symbol(name);  // If lookup_symbol does the same thing
}