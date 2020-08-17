#include <stdio.h>
#include <stdlib.h>
#include "../headers/estado.h"
#include "../headers/functions.h"
#include "../headers/jogar.h"

/**
 * Imprime um tabuleiro com as posicoes em que o jogador pode jogar
 * @param e - ESTADO
 * @param l - lista de jogadas possiveis
 */
void posicoesvalidas(ESTADO *e, Ltpl l){
    Ltpl aux = l;
    mudarparaponto(e,aux);
    printe(e);
    reporparatraco(e,aux);
}

/**
 * Muda a informação da grelha para distinguir a jogadas onde o jogador pode jogar
 * @param e - ESTADO
 * @param l - lista de jogadas possiveis
 */
void mudarparaponto(ESTADO *e, Ltpl l){
    int i, j;
    while(l != NULL){
        i = l->valor.x;
        j = l->valor.y;
        e->grelha[i][j] = POSSIVEL;
        l = l->next;
    }
}

/**
 * Repoem a informação da grelha removendo as distincoes das jogadas onde o jogador pode jogar
 * @param e - ESTADO
 * @param l - lista de jogadas possiveis
 */
void reporparatraco(ESTADO *e, Ltpl l){
    int i, j;
    while(l != NULL){
        i = l->valor.x;
        j = l->valor.y;
        e->grelha[i][j] = VAZIA;
        l = l->next;
    }
}
