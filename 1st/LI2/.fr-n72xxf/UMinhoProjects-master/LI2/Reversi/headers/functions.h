

#ifndef PROJ_FUNCTIONS_H
#define PROJ_FUNCTIONS_H

#include "estado.h"
#include "jogar.h"
#include "stack.h"

void menu(ESTADO *e, char *buffer, STACK *pointer);
void newgame (ESTADO *e,VALOR v);
void loadgame(ESTADO *e,char *path);
void savegame(ESTADO *e,char *path);
void undo (STACK *pointer);
void posicoesvalidas(ESTADO *e, Ltpl l);
void mudarparaponto(ESTADO *e, Ltpl l);
void reporparatraco(ESTADO *e, Ltpl l);
int validstate (ESTADO *e);
void printe(ESTADO *e);
void printtabuleiro(ESTADO *e);
void printefe (ESTADO *e,int x, int y);

#endif //PROJ_FUNCTIONS_H
