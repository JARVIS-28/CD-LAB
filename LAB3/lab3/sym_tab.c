#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include "sym_tab.h" 
 
// Initialize the symbol table 
table* init_table() 
{ 
    table* t = (table*)malloc(sizeof(table)); 
    if (t == NULL) { 
        printf("Memory allocation failed for symbol table\n"); 
        exit(1); 
    } 
    t->head = NULL; 
    return t; 
} 
 
// Initialize a new symbol 
symbol* init_symbol(char* name, int size, int type, int lineno, int scope) 
{ 
    symbol* s = (symbol*)malloc(sizeof(symbol)); 
    if (s == NULL) { 
        printf("Memory allocation failed for symbol\n"); 
        exit(1); 
    } 
    
    s->name = strdup(name); 
    s->value = NULL;  // Initialize value as NULL 
    s->type = type; 
    s->size = size; 
    s->line = lineno; 
    s->scope = scope; 
    s->next = NULL; 
    
    return s; 
} 
 
// Insert a symbol into the table 
void insert_into_table(table* t, symbol* s) 
{ 
    if (t->head == NULL) { 
        t->head = s; 
        return; 
    } 
    
    symbol* current = t->head; 
    while (current->next != NULL) { 
        current = current->next; 
    } 
    current->next = s; 
} 
 
// Check if a symbol exists in the table 
int check_symbol_table(table* t, char* name) 
{ 
    if (t->head == NULL) { 
        return 0;  // Table is empty 
    } 
    
    symbol* current = t->head; 
    while (current != NULL) { 
        if (strcmp(current->name, name) == 0) { 
            return 1;  // Symbol found 
        } 
        current = current->next; 
    } 
    
    return 0;  // Symbol not found 
} 
 
// Insert/update value for a given symbol 
void insert_value_to_name(table* t, char* name, char* value) 
{ 
    if (value == NULL) { 
        return;  // Don't update if value is NULL 
    } 
    
    if (t->head == NULL) { 
        printf("Symbol table is empty, cannot insert value\n"); 
        return; 
    } 
    
    symbol* current = t->head; 
    while (current != NULL) { 
        if (strcmp(current->name, name) == 0) { 
            // Free old value if it exists 
            if (current->value != NULL) { 
                free(current->value); 
            } 
            current->value = strdup(value); 
            return; 
        } 
        current = current->next; 
    } 
    
    printf("Symbol %s not found in table\n", name); 
} 
 
// Display the entire symbol table 
void display_symbol_table(table* t) 
{ 
    if (t->head == NULL) { 
        printf("Symbol table is empty\n"); 
        return; 
    } 
    
    printf("\n%-15s %-15s %-10s %-10s %-10s %-10s\n", 
           "Name", "Value", "Type", "Size", "Line", "Scope"); 
    
printf("---------------------------------------------------------------------------\n"); 
    
    symbol* current = t->head; 
    while (current != NULL) { 
        printf("%-15s %-15s %-10d %-10d %-10d %-10d\n", 
               current->name, 
               (current->value != NULL) ? current->value : "NULL", 
               current->type, 
               current->size, 
               current->line, 
               current->scope); 
        current = current->next; 
    } 
    
printf("---------------------------------------------------------------------------\n"); 
} 
 
