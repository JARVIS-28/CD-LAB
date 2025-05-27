#ifndef SYM_TAB_H 
#define SYM_TAB_H 
 
// Symbol structure for each entry in the symbol table 
typedef struct symbol { 
    char* name;       // Name of the symbol 
    char* value;      // Value of the symbol (stored as string) 
    int type;         // Type of the symbol (int, float, etc.) 
    int size;         // Size of the symbol 
    int line;         // Line number where the symbol is declared 
    int scope;        // Scope level of the symbol 
    struct symbol* next;  // Pointer to the next symbol 
} symbol; 
 
// Symbol table structure 
typedef struct table { 
    struct symbol* head;  // Pointer to the first symbol 
} table; 
 
// Function prototypes 
table* init_table(); 
symbol* init_symbol(char* name, int size, int type, int lineno, int 
scope); 
void insert_into_table(table* t, symbol* s); 
int check_symbol_table(table* t, char* name); 
void insert_value_to_name(table* t, char* name, char* value); 
void display_symbol_table(table* t); 
 
#endif /* SYM_TAB_H */