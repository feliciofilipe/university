#include "../headers/functions.h"
#include "../headers/estado.h"
#include "../headers/jogar.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "../headers/bot.h"

/**
 * Frame para dar uma sugestao de jogada
 * @param e - ESTADO
 */
void help_option(ESTADO *e){
    coordenadas posicaoSugerida;
    posicaoSugerida = minmax(e,posicoes_possiveis(e));
    printefe(e,posicaoSugerida.x,posicaoSugerida.y);
}

/**
 * Frame para dar as posicoes validas
 * @param e - ESTADO
 */
void validplays_option(ESTADO *e){
    posicoesvalidas(e,posicoes_possiveis(e));
}

/**
 * Frame para jogar contra o Bot
 * @param e - ESTADO
 * @param nivel - dificulade do bot
 * @param opcao - opcao
 * @param peca - peca escolhida pelo utilizador
 * @param buffer - buffer
 * @param pointer - apontador para a STACK de ESTADOS
 * @param empty - ESTADO vazio
 */
void bot_option(ESTADO *e, char nivel, char opcao, char peca, char *buffer,STACK *pointer, ESTADO empty){
    while(*pointer != NULL && (*pointer)->e.grelha[3][4] != VAZIA)
        *pointer=pop(*pointer);
    sscanf(buffer,"%c %c %c", &opcao, &peca,&nivel);
    if(('1' <= nivel && nivel <= '3') && (peca == 'X' || peca == 'O')) {
        char valor_peca;
        if (peca == 'X') {
            valor_peca = VALOR_X;
        } else valor_peca = VALOR_O;
        newgamebot(e, valor_peca, nivel, pointer);
        *pointer=push(*pointer,empty);
        *pointer=push(*pointer,*e);
    } else printf("Comando nao valido\n");
}

/**
 * Frame para chamar a funcao loadgame
 * @param e - ESTADO
 * @param opcao - opcao escolhida
 * @param buffer - buffer
 * @param path - caminho para o ficheiro
 */
void savegame_option(ESTADO *e, char opcao, char *buffer, char *path){
    sscanf(buffer, "%c %s", &opcao, path);
    savegame(e, path);
}

/**
 * Frame para chamar a funcao loadgame
 * @param e - ESTADO
 * @param opcao - opcao escolhida
 * @param buffer - buffer
 * @param path - caminho para o ficheiro
 */
void loadgame_option(ESTADO *e, char opcao, char *buffer, char *path){
    sscanf(buffer, "%c %s", &opcao, path);
    loadgame(e, path);
}

/**
 * Frame para chamar a funcao newgame
 * @param e - ESTADO
 * @param buffer - buffer
 * @param opcao - opcao do menu
 * @param peca - peca escolhida para comecar a jogar
 * @param pointer - apontador para a stack de ESTADOS
 * @param empty - Estado vazio
 */
void newgame_option(ESTADO *e, char *buffer, char opcao, char peca, STACK *pointer, ESTADO empty){
    while(*pointer != NULL && (*pointer)->e.grelha[3][4] != VAZIA)
        *pointer=pop(*pointer);
    sscanf(buffer,"%c %c",&opcao ,&peca);
    if (peca == 'X') {
        newgame(e, VALOR_X);
        *pointer=push(*pointer,empty);
        *pointer=push(*pointer,*e);
    }
    else if (peca == 'O') {
        newgame(e, VALOR_O);
        *pointer=push(*pointer,empty);
        *pointer=push(*pointer,*e);
    }
    else printf("Nao e uma opcao valida\n");
}

/**
 * Frame para chamar a função undo
 * @param e - ESTADO
 * @param pointer - apontador para a STACK de ESTADOS
 */
void undo_option(ESTADO *e, STACK *pointer){
    if (validstate(e)) {
        if(e->modo == '0')
            undo(pointer);
        else{
            undo(pointer);
            undo(pointer);
        }
        *e = (*pointer)->e;
    }
}

/**
 * Frame para chamar a função que joga
 * @param e - ESTADO
 * @param opcao - opcao
 * @param i - linha
 * @param j - coluna
 * @param ni - linha atualizada
 * @param nj - coluna atualizada
 * @param buffer - buffer
 */
void jogar_option(ESTADO *e, char opcao, char i, char j, int ni, int nj, char *buffer, STACK *pointer){
    if(e->acabou == 0) {
        if (posicoes_possiveis(e)) {
            sscanf(buffer, "%c %c %c", &opcao, &i, &j);
            ni = i - '0';
            nj = j - '0';
            jogar(e, ni, nj, pointer);
        }
    } else printf("O Jogo acabou, comece um novo por favor\n");
}


/**
 * Frame para chamar a funcao CAMPEONATO
 * @param e - ESTADO
 * @param opcao - opcao escolhida
 * @param buffer - buffer
 * @param path - caminho para o ficheiro
 */
void campeonato_option(ESTADO *e, char opcao, char *buffer, char *path){
    sscanf(buffer, "%c %s", &opcao, path);
    CAMPEONATO(e,path);
}
