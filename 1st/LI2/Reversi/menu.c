#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "estado.h"
#include "jogar.h"
#include "bot.h"
#include "menu_options.h"
#include "stack.h"
#include "functions.h"

/**
 * Estrutura do menu
 * @param e - ESTADO
 * @param buffer - buffer
 * @param pointer - apontador para a STACK de ESTADOS
 */
void menu(ESTADO *e, char *buffer, STACK *pointer) {
    ESTADO empty = {0};
    char opcao,peca,i,j;
    char *path;
    char nivel_bot,peca_bot;
    int ni = 0, nj = 0;
    path = malloc(100);
    switch (*buffer) {
        case 'N':
            newgame_option(e,buffer,opcao,peca,pointer,empty);
            break;
        case 'L':
            loadgame_option(e,opcao,buffer,path);
            break;
        case 'E':
            savegame_option(e,opcao,buffer,path);
            break;
        case 'J':
            jogar_option(e,opcao,i,j,ni,nj,buffer,pointer);
            break;
        case 'S':
            validplays_option(e);
            break;
        case 'H':
            help_option(e);
            break;
        case 'U':
            undo_option(e,pointer);
            break;
        case 'A':
            bot_option(e,nivel_bot,opcao,peca_bot,buffer,pointer,empty);
            break;
        case 'C':
            campeonato_option(e, opcao, buffer, path);
            break;
        case 'Q':
            break;
        default:
            printf("Nao e uma opcao\n");
            break;
    }
}