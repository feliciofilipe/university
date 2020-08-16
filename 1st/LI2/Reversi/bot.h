//
// Created by Filipe on 4/12/2019.
//

#ifndef PROJ_BOT_H
#define PROJ_BOT_H

#include "jogar.h"
#include "stack.h"

void bot_minmax(ESTADO *e,STACK *pointer);
int nmr_jogadas(ESTADO *e);
void bot_medio(ESTADO *e,STACK *pointer);
void bot_facil(ESTADO *e,STACK *pointer);
void CAMPEONATO (ESTADO *e,char *path);

#endif //PROJ_BOT_H

