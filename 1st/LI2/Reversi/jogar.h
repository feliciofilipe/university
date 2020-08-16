//
// Created by Filipe on 4/4/2019.
//

#ifndef PROJ_JOGAR_H
#define PROJ_JOGAR_H
#include "estado.h"
#include "bot.h"
#include "stack.h"

/**
 * Estrutura de um par de coordenadas
 */
typedef struct pair{
    int x;
    int y;
}coordenadas;

/**
 * Estrutura de uma lista ligada de pares de coordenadas
 * denominada de listaTpl
 */
typedef struct listTpl *Ltpl;
typedef struct listTpl {
    struct pair valor;
    Ltpl next;
}nodo;

Ltpl iniTupl(coordenadas xy);
Ltpl consT (Ltpl l,coordenadas xy);
int elemT (coordenadas xy, Ltpl l);
Ltpl percorreDir(ESTADO *e, coordenadas pos, Ltpl listaPos, int x, int y);
Ltpl posicoes_possiveis (ESTADO *e);
void jogar(ESTADO *e, int ni, int nj, STACK *pointer);
void executa_jogada(ESTADO *e, int i, int j, STACK *pointer);
void virapecas(ESTADO *e, int i, int j);
int verificadirecao(ESTADO *e, int i, int j, int direcao);
int verifica(ESTADO *e, int i, int j, int inc_i, int inc_j);
void viralinha(ESTADO *e, int i, int j, int inc_i, int inc_j, int direcao);
int numeros_convertidos (ESTADO *e, coordenadas pos);
int numero_convertidos_aux (ESTADO *e, coordenadas pos,int x, int y);
int melhorJogadaInimiga(ESTADO *e, Ltpl jogadas_possiveis);
coordenadas minmax (ESTADO *e, Ltpl jogadas_possiveis);
void minmax_inicializacao (int *res, int *acc,coordenadas *resultado, ESTADO *e, Ltpl jogadas_possiveis, coordenadas *posicao, STACK stack);
void minmax_loop (int *res, int *acc,coordenadas *resultado, coordenadas *posicao, ESTADO *e, Ltpl jogadas_possiveis,STACK stack);
void aplica_nivel(ESTADO *e, STACK *pointer);
void inicia_tabuleiro(ESTADO *e);
void reset_tabuleiro(ESTADO *e);
void newgamebot(ESTADO *e,VALOR peca, char nivel,STACK *pointer);
void muda_jogador(ESTADO *e);
void sem_jogadas(ESTADO *e);
int conta_pecas(ESTADO *e);
int contaX(ESTADO *e);
int contaO(ESTADO *e);
void bool_fim_do_jogo(ESTADO *e);
void verifica_vencedor(ESTADO*e);
void executa_jogada_campeonato(ESTADO *e, int i, int j);
#endif //PROJ_JOGAR_H
