
#ifndef SYM_TAB_H
#define SYM_TAB_H

#define CHAR 1
#define INT 2
#define FLOAT 3
#define DOUBLE 4

// Define the exprval struct first
struct exprval {
    int type;
    union {
        int ival;
        float fval;
        char cval;
        double dval;
    } val;
};

typedef struct symbol //data structure of items in the list
{
    char* name; //identifier name
    int size; //storage size of identifier name
    int type; //identifier type
    char* val; //value of the identifier
    int line; //declared line number
    int scope; //scope of the variable
    struct symbol* next;
}symbol;

typedef struct table //keeps track of the start of the list
{
    symbol* head;
}table;

extern table* t;
table* init_table(void); //allocate space for start of table
symbol* init_symbol(char* name, int size, int type, int lineno, int scope);
void insert_into_table(symbol* s);
void insert_value_to_name(char* name, char* value);
int check_symbol_table(char* name);
void display_symbol_table(void);
symbol* lookup_symbol(char* name);
void update_symbol_value(char* id, struct exprval value);
struct exprval get_symbol_value(char* id);
symbol* get_symbol(char* name);


#endif