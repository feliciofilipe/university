#include "stack.h"
#include "functions.h"
#include <stdio.h>
#include <stdlib.h>

/**
 *  Verifica se um estado é valido
 * @param e - ESTADO
 * @return BOOL (1 ou 0)
 */
int validstate (ESTADO *e) {
    int i=0,j=0,r=0;
    for (i=0;i!=8;i++) {
        for (j=0;j!=8;j++) {
            if ((e->grelha[i][j])!=VAZIA) r++;
        }
    }
    if (r<4) return 0;
    else return 1;
}

/**
 * Recua para o ESTADO anterior e imprime o tabuleiro
 * @param pointer - apontador para a STACK de ESTADOS
 */
void undo (STACK *pointer) {
    *pointer=pop(*pointer);
    printe(&(*pointer)->e);
}

/**
 * Faz pop da STACK de ESTADOS
 * @param pointer - apontador para a STACK de ESTADOS
 * @return STACK atualizada
 */
STACK pop(STACK pointer) {
    STACK newpointer = pointer;
    if (pointer->prox!=NULL) {
        newpointer = pointer->prox;
        free(pointer);
    }
    return newpointer;
}

/**
 * Faz push da STACK de ESTADOS
 * @param pointer - apontador para a STACK de ESTADOS
 * @return STACK atualizada
 */
STACK push(STACK pointer,ESTADO new) {
    STACK newpointer = NULL;
    newpointer = malloc(sizeof(struct stack));
    newpointer->e=new;
    newpointer->prox=pointer;
    return newpointer;
}