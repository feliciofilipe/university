#ifndef CONFIG
#define CONFIG

#define NMONTHS 12
#define NUMBEROFBRANCHES 3
#define TYPESOFSALE 2
#define NLETTERS 26
#define LETTEROFFSET 65

#define CLIENTSFILEPATH "../Dados Iniciais/Clientes.txt"
#define PRODUCTSFILEPATH "../Dados Iniciais/Produtos.txt"
#define SALESFILEPATH "../Dados Iniciais/Vendas_1M.txt"

#define BRANCH_1 0
#define BRANCH_2 1
#define BRANCH_3 2

/* ID SIZES */
#define SIZEIDCLIENT 5
#define SIZEIDPRODUCT 6

/* MENU - OPTIONS */
#define NUMBER_OF_LINES_TO_PRINT 16
#define ROW_1 0
#define ROW_2 1
#define ROW_3 2
#define COLUMN_1 0
#define COLUMN_2 1
#define COLUMN_3 2
#define COLUMN_4 3
#define COLUMN_5 4
#define MENU_KILLER 'q'
#define MORE_OPTNS '+'
#define LESS_OPTNS '-'
#define UP 65
#define DOWN 66
#define RIGHT 67
#define LEFT 68
#define ENTER 13
#define CLEAN 127
#define ESC 666

#define LOWER_CASE_A 97
#define LOWER_CASE_Z 122
#define CASE_OFFSET 32
#define ZERO 48
#define NINE 57

/* UI TOOLS */
#define COLOR_N_PINK "\x1b[0;35m"
#define COLOR_N_CYAN "\x1b[0;36m"

#define COLOR_B_PINK "\x1b[1;35m"
#define COLOR_B_CYAN "\x1b[1;36m"

#define COLOR_RESET "\x1b[0m"

#define BLINK "\033[5m"
#define RESET "\033[0m"

#define HIDE_CURSOR "\x1B[?25l"
#define SHOW_CURSOR "\x1B[?25h"

#endif
