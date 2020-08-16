//
// Created by Filipe on 5/2/2019.
//

#ifndef PROJ_MENU_OPTIONS_H
#define PROJ_MENU_OPTIONS_H

#include "estado.h"
#include "jogar.h"

void validplays_option(ESTADO *e);
void bot_option(ESTADO *e, char nivel, char opcao, char peca, char *buffer,STACK *pointer, ESTADO empty);
void savegame_option(ESTADO *e, char opcao, char *buffer, char *path);
void loadgame_option(ESTADO *e, char opcao, char *buffer, char *path);
void jogar_option(ESTADO *e, char opcao, char i, char j, int ni, int nj, char *buffer, STACK *pointer);
void undo_option(ESTADO *e, STACK *pointer);
void newgame_option(ESTADO *e, char *buffer, char opcao, char peca, STACK *pointer, ESTADO empty);
void help_option(ESTADO *e);
void campeonato_option(ESTADO *e, char opcao, char *buffer, char *path);

#endif //PROJ_MENU_OPTIONS_H

