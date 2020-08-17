#include "../headers/functions.h"
#include "../headers/estado.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "../headers/stack.h"

/**
 * Carrega um Estado
 * @param e - ESTADO
 * @param path - caminho para um ficheiro
 */
void loadgame (ESTADO *e,char *path) {
    char peca,m,j,nivel;
    FILE *fptr = fopen(path,"r");
    fscanf(fptr,"%c %c %c",&m,&j,&nivel);
    if (m=='M') e->modo='0';
    else e->modo='1';
    if (j=='X') e->peca=VALOR_X;
    else e->peca=VALOR_O;
    e->nivel = nivel;
    fgetc(fptr);
    for (int i=0;i!=8;i++)
        for (int j=0;j!=8;j++) {
            fscanf(fptr," %c",&peca);
            if (peca=='O') e->grelha[i][j]=VALOR_O;
            else if (peca=='X') e->grelha[i][j]=VALOR_X;
            else e->grelha[i][j]=VAZIA;
            if (j==7) fgetc(fptr);
        }
    fclose(fptr);
    printe(e);
}

/**
 * Grava um Estado
 * @param e - ESTADO
 * @param path - caminho para um ficheiro
 */
void savegame (ESTADO *e,char *path) {
    FILE *fptr = fopen(path,"w");
    if (e->modo=='0') fprintf(fptr,"M ");
    else fprintf(fptr,"A ");
    if (e->peca==VALOR_X) fprintf(fptr," X");
    else fprintf(fptr," O");
    fprintf(fptr," %c\n",e->nivel);
    for (int i=0;i!=8;i++)
        for (int j=0;j!=8;j++) {
            if (e->grelha[i][j]==VALOR_O) fprintf(fptr,"O ");
            else if (e->grelha[i][j]==VALOR_X) fprintf(fptr,"X ");
            else fprintf(fptr,"- ");
            if (j==7) fprintf(fptr,"\n");
        }
    fclose(fptr);
    printe(e);
}
