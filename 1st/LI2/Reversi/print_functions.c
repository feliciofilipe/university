#include "functions.h"
#include "estado.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "stack.h"

/**
 * Imprime um Estado
 * @param e - ESTADO
 */
void printe (ESTADO *e) {
    if(e->modo == '0')
        printf("M ");
    else printf("A ");
    if(e->modo == '0') {
        if (e->peca == VALOR_O)
            printf("O\n");
        else printf("X\n");
    } else{
        if (e->peca == VALOR_O)
            printf("O ");
        else printf("X ");
        printf("%c\n",e->nivel);
    }
    printf("   1 2 3 4 5 6 7 8\n");
    printtabuleiro(e);
    printf("X - %d    O - %d\n",contaX(e),contaO(e));
}

/**
 * Imprime um Tabuleiro
 * @param e - ESTADO
 */
void printtabuleiro(ESTADO *e){
    int linha = 1;
    for (int i=0;i!=8;i++) {
        printf("%d  ", linha);
        linha++;
        for (int j = 0; j != 8; j++) {
            if (e->grelha[i][j] == VALOR_O) {
                printf("O ");
            } else if (e->grelha[i][j] == VALOR_X) {
                printf("X ");
            } else if (e->grelha[i][j] == POSSIVEL) {
                printf(". ");
            } else printf("- ");
            if (j == 7) printf("\n");
        }
    }
}

/**
 * Imprime um Estado com uma sugestao de jogada
 * @param e - ESTADO
 * @param x - linha da jogada
 * @param y - coluna da jogada
 */
void printefe (ESTADO *e,int x, int y) {

    int linha = 1;

    printf("   1 2 3 4 5 6 7 8\n");

    for (int i = 0; i != 8; i++) {
        printf("%d  ", linha);
        linha++;
        for (int j = 0; j != 8; j++) {
            if (e->grelha[i][j] == VALOR_O)
                printf("O ");
            else if (e->grelha[i][j] == VALOR_X)
                printf("X ");
            else if (x == i && j == y)
                printf("? ");
            else if (e->grelha[i][j] == POSSIVEL)
                printf(". ");
            else printf("- ");
            if (j == 7) printf("\n");
        }
    }
    printf("\n");
}