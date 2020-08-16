#include <stdio.h>
#include <stdlib.h>
#include "estado.h"
#include "functions.h"
#include "jogar.h"
#include "bot.h"
#include "stack.h"

/**
 * Executa uma jogada segundo o bot minmax (nivel 3)
 * @param e - ESTADO
 * @param pointer - apontador para a STACK de ESTADOS
 */
void bot_minmax(ESTADO *e,STACK *pointer){
    int i,j;
    Ltpl aux = posicoes_possiveis(e);
    coordenadas minmax_xy = minmax(e,aux);
    i = minmax_xy.x;
    j = minmax_xy.y;
    i++;
    j++;
    executa_jogada(e, i, j,pointer);
}
/**
 * Executa uma jogada segundo o bot minmax para o campeonato
 * @param e - ESTADO
 */
void bot_minmax_campeonato(ESTADO *e){
    int i,j;
    Ltpl aux = posicoes_possiveis(e);
    coordenadas minmax_xy = minmax(e,aux);
    i = minmax_xy.x;
    j = minmax_xy.y;
    i++;
    j++;
    executa_jogada_campeonato(e, i, j);
}

/**
 * Conta o numero de jogadas que foram efetuadas no tabuleiro do Estado
 * @param e - ESTADO
 * @return numero de jogadas efetuadas
 */
int nmr_jogadas(ESTADO *e) {
    int res = -4;
    int i,j;
    for(i = 0; i < 8; i++) {
        for(j = 0; j < 8; j++) {
            if (e->grelha[i][j] != VAZIA)
                res++;
        }
    }
    return res;
}

/**
 * Executa uma jogada segundo o bot de nivel 2
 * @param e - ESTADO
 * @param pointer - apontador para a STACK de ESTADOS
 */
void bot_medio(ESTADO *e,STACK *pointer){
    Ltpl aux = posicoes_possiveis(e);
    int i,j;
    if(nmr_jogadas(e)%2 == 0) {
        coordenadas minmax_xy = minmax(e, aux);
        i = minmax_xy.x;
        j = minmax_xy.y;
    } else {
        i = aux->valor.x;
        j = aux->valor.y;
    }
    i++;
    j++;
    executa_jogada(e, i, j, pointer);
}

/**
 * Executa uma jogada segundo o bot de nivel 3
 * @param e - ESTADO
 * @param pointer - apontador para a STACK de ESTADOS
 */
void bot_facil(ESTADO *e,STACK *pointer){
    Ltpl aux = posicoes_possiveis(e);
    int i,j;
    if(nmr_jogadas(e)%4 == 0) {
        coordenadas minmax_xy = minmax(e, aux);
        i = minmax_xy.x;
        j = minmax_xy.y;
    } else {
        i = aux->valor.x;
        j = aux->valor.y;
    }
    i++;
    j++;
    executa_jogada(e, i, j, pointer);
}

/**
 * Funcao campeonato
 * @param path - caminho do ficheiro
 */
void CAMPEONATO (ESTADO *e,char *path) {
    FILE *file;
    file = fopen(path, "r");
    if (file != NULL) {
        loadgame(e,path);
        fclose(file);
        file = fopen(path, "w");
        bot_minmax_campeonato(e);
        savegame(e,path);
        fclose(file);
    } else {
        file = fopen(path, "w");
        if (file != NULL) {
            fputs("A X 3\n", file);
            fputs("- - - - - - - -\n", file);
            fputs("- - - - - - - -\n", file);
            fputs("- - - - - - - -\n", file);
            fputs("- - - X O - - -\n", file);
            fputs("- - - O X - - -\n", file);
            fputs("- - - - - - - -\n", file);
            fputs("- - - - - - - -\n", file);
            fputs("- - - - - - - -\n", file);
            fclose(file);
            file = fopen(path, "r");
            loadgame(e,path);
            fclose(file);
            file = fopen(path, "w");
            bot_minmax_campeonato(e);
            savegame(e,path);
            fclose(file);
        } else {
            printf("Erro ao criar o ficheiro %s. Certifique-se que tem permissões.\n", path);
        }
    }
}