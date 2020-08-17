//
// Created by pja on 27/02/2019.
//



#ifndef PROJ_ESTADO_H
#define PROJ_ESTADO_H



/**
estado.h
Definição do estado i.e. tabuleiro. Representação matricial do tabuleiro.
*/


// definição de valores possiveis no tabuleiro
typedef enum {VAZIA, VALOR_X, VALOR_O, POSSIVEL} VALOR;
/**
Estrutura que armazena o estado do jogo
*/
typedef struct estado {
    VALOR peca; // peça do jogador que vai jogar!
    VALOR peca_bot; //peca do bot
    VALOR grelha[8][8];
    char modo; // modo em que se está a jogar! 0-> manual, 1-> contra computador
    char nivel;//nivel do bot, 1 -> facil, 2 -> medio, 3 -> dificil
    int acabou; //BOOL 1 -> acabou, 0 -> ainda continua
} ESTADO;

#endif //PROJ_ESTADO_H