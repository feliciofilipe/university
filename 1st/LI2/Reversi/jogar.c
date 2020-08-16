#include <stdio.h>
#include <stdlib.h>
#include "estado.h"
#include "functions.h"
#include "jogar.h"
#include "stack.h"

/**
 * Cria o Estado e inicia um novo jogo no modo Manual
 * @param e - ESTADO
 * @param peca - peça selecionada
 */
void newgame (ESTADO *e,VALOR peca) {
    reset_tabuleiro(e);
    e->acabou = 0;
    e->nivel = 0;
    e->modo = '0';
    e->peca_bot = VALOR_X;
    inicia_tabuleiro(e);
    e->peca = peca;
    printe(e);
}

/**
 * Cria o Estado e inicia um novo jogo no modo Automatico
 * @param e - ESTADO
 * @param peca - peca que o jogador deseja controlar
 * @param nivel - nivel de dificuldade (1 a 3)
 * @param pointer - apontador para a STACK de ESTADOS
 */
void newgamebot(ESTADO *e,VALOR peca, char nivel,STACK *pointer) {
    reset_tabuleiro(e);
    e->acabou = 0;
    e->nivel = nivel;
    e->modo = '1';
    e->peca = VALOR_X;
    if(peca == VALOR_X)
        e->peca_bot = VALOR_O;
    else e->peca_bot = VALOR_X;
    inicia_tabuleiro(e);
    printe(e);
    if(e->peca_bot == VALOR_X){
        aplica_nivel(e,pointer);
        printf("\n");
        printe(e);
    }
}

/**
 * Atualiza o tabuleiro do Estado para a situacao inicial
 * @param e - ESTADO
 */
void inicia_tabuleiro(ESTADO *e){
    e->grelha[3][4] = VALOR_X;
    e->grelha[4][3] = VALOR_X;
    e->grelha[3][3] = VALOR_O;
    e->grelha[4][4] = VALOR_O;
}

/**
 * Atualiza o tabuleiro do Estado para VAZIA em todas as posições
 * @param e - ESTADO
 */
void reset_tabuleiro(ESTADO *e){
    for (int i=0;i!=8;i++)
        for (int j=0;j!=8;j++)
            (e->grelha[i][j])=VAZIA;
}

/**
 * Frame para executar uma jogada
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 * @param pointer - apontador para a STACK de ESTADOS
 */
void jogar(ESTADO *e, int i, int j, STACK *pointer){
    i--;
    j--;
    coordenadas jogada = {i,j};
    if (elemT(jogada,posicoes_possiveis(e)) == 1){
        i++;
        j++;
        executa_jogada(e, i, j, pointer);
        printe(e);
        if(e->modo == '1'){
            aplica_nivel(e,pointer);
            printf("\n");
            printe(e);
        }
    } else {
        printf("ERRO - jogada nao valida\n");
    }
}

/**
 * Executa no tabuleiro uma jogada e muda o jogador
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 * @param pointer - apontador para a STACK de ESTADOS
 */
void executa_jogada(ESTADO *e, int i, int j, STACK *pointer){
    i--;
    j--;
    e->grelha[i][j] = e->peca;
    virapecas(e,i,j);
    muda_jogador(e);
    *pointer = push(*pointer,*e);
}

/**
 * Executa no tabuleiro uma jogada e muda o jogador no campenato
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 */
void executa_jogada_campeonato(ESTADO *e, int i, int j){
    i--;
    j--;
    e->grelha[i][j] = e->peca;
    virapecas(e,i,j);
    muda_jogador(e);
}

/**
 * Atualiza o ESTADO numa direcao da jogada
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 * @param inc_i - incremento linha
 * @param inc_j - incremento coluna
 * @param direcao - codigo de direcao (0 a 8)
 */
void viralinha(ESTADO *e, int i, int j, int inc_i, int inc_j, int direcao){
    if(verificadirecao(e,i,j,direcao) == 1) {
        i += inc_i;
        j += inc_j;
        while (e->grelha[i][j] != e->peca && e->grelha[i][j] != VAZIA) {
            e->grelha[i][j] = e->peca;
            i += inc_i;
            j += inc_j;
        }
    }
}

/**
 * atualiza o tabuleiro de acordo com a jogada
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 */
void virapecas(ESTADO *e, int i, int j){
    viralinha(e, i, j, -1, 0, 0);
    viralinha(e, i, j, -1, 1, 1);
    viralinha(e, i, j, 0, 1, 2);
    viralinha(e, i, j, 1, 1, 3);
    viralinha(e, i, j, 1, 0, 4);
    viralinha(e, i, j, 1, -1, 5);
    viralinha(e, i, j, 0, -1, 6);
    viralinha(e, i, j, -1, -1, 7);
}
/**
 * Verifica se existe uma peça do jogador numa direcao
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 * @param inc_i - incremento da linha
 * @param inc_j - incremento da coluna
 * @return BOOL (0 ou 1)
 */
int verifica(ESTADO *e, int i, int j, int inc_i, int inc_j){
    int bool = 0;
    i += inc_i;
    j += inc_j;
    while(e->grelha[i][j] != VAZIA){
        if(e->grelha[i][j] == e->peca) bool = 1;
        i += inc_i;
        j += inc_j;
    }
    return bool;
}

/**
 * Frame para chamar a função que verifica se existe uma peça do jogador numa dada direcao
 * @param e - ESTADO
 * @param i - linha
 * @param j - coluna
 * @param direcao - codigo de direcao (0 a 8)
 * @return BOOL (0 ou 1)
 */
int verificadirecao(ESTADO *e, int i, int j, int direcao){
    int bool = 0;
    switch (direcao){
        case 0: //Norte (i--)
            bool = verifica(e, i, j, -1, 0);
            break;
        case 1: //Nordeste (i-- & j++)
            bool = verifica(e, i, j, -1, 1);
            break;
        case 2: //Este (j++)
            bool = verifica(e, i, j, 0, 1);
            break;
        case 3: //Sudeste (i++ & j++)
            bool = verifica(e, i, j, 1, 1);
            break;
        case 4: //Sul (i++)
            bool = verifica(e, i, j, 1, 0);
            break;
        case 5: //Sudoeste (i++ & j--)
            bool = verifica(e, i, j, 1, -1);
            break;
        case 6: //Oeste (j--)
            bool = verifica(e, i, j, 0, -1);
            break;
        case 7: //Noroeste (i-- & j--)
            bool = verifica(e, i, j, -1, -1);
            break;
    }
    return bool;
}


/**
 * inicializa uma lista de tuplos
 * @param xy - par de coordenadas
 * @return lista de tuplos
 */
Ltpl iniTupl(coordenadas xy){
    Ltpl h = (Ltpl)malloc(sizeof(nodo));
    h->valor.x = xy.x;
    h->valor.y = xy.y;
    h->next = NULL;
    return h;
}


/**
 * Adiciona um elemento à cabeça de uma lista de Tuplos
 * @param l - lista de tuplos
 * @param xy - par de coordenadas
 * @return lista de tuplos atualizada
 */
Ltpl consT (Ltpl l,coordenadas xy){
    Ltpl h = (Ltpl)malloc(sizeof(nodo));
    if (l == NULL)
        h = iniTupl(xy);
    else {
        h->valor = xy;
        h->next = l;
    }
    return h;
}

/**
 * Verifica se um tuplo pertence à lista de Tuplos
 * @param xy - par de coordenadas
 * @param l - lista de tuplos
 * @return BOOL(0 ou 1)
 */
int elemT (coordenadas xy, Ltpl l){
    int res = 0;
    while (l != NULL && res == 0) {
        if (xy.x == l->valor.x && xy.y == l->valor.y) res = 1;
        l = l->next;
    }
    return res;
}

/**
 * Percorre uma direcao com base numa peca do jogador e guarda uma posicao para jogar, se ela existir
 * @param e - ESTADO
 * @param pos - posicao a ser avaliada
 * @param listaPos - Lista de posicoes validas
 * @param x - incremento de x
 * @param y - incremento de y
 * @return Lista de Tuplos atualizada
 */
Ltpl percorreDir(ESTADO *e, coordenadas pos, Ltpl listaPos, int x, int y){
    coordenadas vetor = {x,y};
    coordenadas xy;
    xy.x = pos.x;
    xy.y = pos.y;
    VALOR compare;
    if (e->peca == VALOR_X) {
        compare = VALOR_O;
    } else
        compare = VALOR_X;
    while ((e->grelha[xy.x+vetor.x][xy.y+vetor.y] == compare) && xy.x+vetor.x <= 7 && xy.y+vetor.y <= 7 && xy.x+vetor.x >= 0 && xy.y+vetor.y >= 0){
        xy.x += vetor.x;
        xy.y += vetor.y;
    }
    if  (xy.x+vetor.x <= 7 && xy.y+vetor.y <= 7 && xy.x+vetor.x >= 0 && xy.y+vetor.y >= 0) {
        if ((e->grelha[xy.x + vetor.x][xy.y + vetor.y] == VAZIA) && (xy.x != pos.x || xy.y != pos.y)) {
            xy.x += vetor.x;
            xy.y += vetor.y;
            listaPos = consT(listaPos,xy);
        }
    }
    return listaPos;
}

/**
 * Devolve uma Lista de Tuplos com todas as posicoes onde o jogador pode colocar uma peca
 * @param e - ESTADO
 * @return Lista de Tuplos
 */
Ltpl posicoes_possiveis (ESTADO *e){
    Ltpl l = (Ltpl)malloc(sizeof(nodo));
    l = NULL;
    int i,j;
    struct pair coord;
    for(i = 0; i <= 7; i++){
        for(j = 0; j <= 7; j++){
            if (e->grelha[i][j] == e->peca) {
                coord.x = i,coord.y = j;
                l = percorreDir(e,coord,l,0,1);
                l = percorreDir(e,coord,l,1,1);
                l = percorreDir(e,coord,l,1,0);
                l = percorreDir(e,coord,l,1,-1);
                l = percorreDir(e,coord,l,0,-1);
                l = percorreDir(e,coord,l,-1,0);
                l = percorreDir(e,coord,l,-1,-1);
                l = percorreDir(e,coord,l,-1,1);
            }
        }
    }
    return l;
}

/**
 * Conta o numero de pecas que serão viradas numa dada direcao
 * @param e - ESTADO
 * @param pos - posicao a ser avaliada
 * @param x - incremento do x
 * @param y - incremento do y
 * @return numero de pecas
 */
int numero_convertidos_aux (ESTADO *e, coordenadas pos,int x, int y){
    coordenadas vetor = {x,y};
    coordenadas xy;
    int res = 0;
    xy.x = pos.x;
    xy.y = pos.y;
    VALOR compare;
    if (e->peca == VALOR_X) {
        compare = VALOR_O;
    } else
        compare = VALOR_X;
    while ((e->grelha[xy.x+vetor.x][xy.y+vetor.y] == compare) && xy.x+vetor.x <= 7 && xy.y+vetor.y <= 7 && xy.x+vetor.x >= 0 && xy.y+vetor.y >= 0) {
        xy.x += vetor.x;
        xy.y += vetor.y;
        res++;
    }
    if (e->grelha[xy.x+vetor.x][xy.y+vetor.y] != e->peca) res = 0;
    return res;
}

/**
 * Conta o numero de pecas que serão viradas em todas as direcoes de uma jogada possivel
 * @param e - ESTADO
 * @param pos - posicao a ser avaliada
 * @return numero de pecas
 */
int numeros_convertidos (ESTADO *e, coordenadas pos){
    int res = 0;
    res += numero_convertidos_aux (e,pos,0,1);
    res += numero_convertidos_aux (e,pos,1,0);
    res += numero_convertidos_aux (e,pos,1,1);
    res += numero_convertidos_aux (e,pos,0,-1);
    res += numero_convertidos_aux (e,pos,-1,-1);
    res += numero_convertidos_aux (e,pos,-1,0);
    res += numero_convertidos_aux (e,pos,-1,1);
    res += numero_convertidos_aux (e,pos,1,-1);
    return res;
}

/**
 * Devolve o maior numero de pecas viradas pela melhor jogada inimiga das jogadas possiveis do inimigo
 * @param e - ESTADO
 * @param jogadas_possiveis - lista de jogadas possiveis do inimigo
 * @return numero de pecas
 */
int melhorJogadaInimiga(ESTADO *e, Ltpl jogadas_possiveis){
    int resultado;
    if (jogadas_possiveis != NULL) {
        resultado = numeros_convertidos(e,jogadas_possiveis->valor);
        jogadas_possiveis = jogadas_possiveis->next;
    }
    while (jogadas_possiveis != NULL){
        int teste = numeros_convertidos(e,jogadas_possiveis->valor);
        if (teste > resultado) resultado = teste;
        jogadas_possiveis = jogadas_possiveis->next;
    }
    return resultado;
}

/**
 * Inicializa as variaveis temporarias do minMaz para comparacao das posicoes em que o jogador pode jogar
 * @param res - retorno do algoritmo minMax
 * @param acc - acumulador
 * @param resultado - jogada resultante do algoritmo
 * @param e - ESTADO
 * @param jogadas_possiveis
 * @param posicao - primeira posicao da lista
 * @param stack - STACK para dar input ao play
 */
void minmax_inicializacao (int *res, int *acc,coordenadas *resultado, ESTADO *e, Ltpl jogadas_possiveis, coordenadas *posicao, STACK stack){
    Ltpl jogadas_possiveis_2;
    *res = numeros_convertidos(e,jogadas_possiveis->valor);
    *posicao = jogadas_possiveis->valor;
    executa_jogada(e,++(*posicao).x,++(*posicao).y,&stack);
    jogadas_possiveis_2 = posicoes_possiveis(e);
    *res -= melhorJogadaInimiga(e,jogadas_possiveis_2);
    *acc = *res;
    *resultado = jogadas_possiveis->valor;
}

/**
 * Percorrida a lista de possiveis e escolhe a mais favoravel de acordo com a aristica minMax
 * @param res - retorno do algoritmo minMax
 * @param acc - acumulador
 * @param resultado - jogada resultante do algoritmo
 * @param e - ESTADO
 * @param jogadas_possiveis
 * @param posicao - primeira posicao da lista
 * @param stack - STACK para dar input ao play
 */
void minmax_loop (int *res, int *acc,coordenadas *resultado, coordenadas *posicao, ESTADO *e, Ltpl jogadas_possiveis,STACK stack){
    Ltpl jogadas_possiveis_2;
    *res = numeros_convertidos(e,jogadas_possiveis->valor);
    *posicao = jogadas_possiveis->valor;
    executa_jogada(e,++(*posicao).x,++(*posicao).y,&stack);
    jogadas_possiveis_2 = posicoes_possiveis(e);
    *res -= melhorJogadaInimiga(e,jogadas_possiveis_2);
    if (*res > *acc){
        *acc = *res;
        *resultado = jogadas_possiveis->valor;
    }

}

/**
 * Algoritmo minMax
 * @param e - ESTADO
 * @param jogadas_possiveis
 * @return retorna a melhor jogada de acordo com o algoritmo minMax
 */
coordenadas minmax (ESTADO *e, Ltpl jogadas_possiveis){
    STACK stack;
    struct estado inicial = *e;
    int acc,res;
    coordenadas resultado,posicao;
    minmax_inicializacao(&res,&acc,&resultado,e,jogadas_possiveis,&posicao,stack);
    resultado = jogadas_possiveis->valor;
    *e = inicial;
    if (jogadas_possiveis != NULL)
        jogadas_possiveis = jogadas_possiveis->next;
    while (jogadas_possiveis != NULL){
        minmax_loop(&res,&acc,&resultado,&posicao,e,jogadas_possiveis,stack);
        *e = inicial;
        jogadas_possiveis = jogadas_possiveis->next;
    }
    return resultado;
}
/**
 * Aplica o Bot ao estado de acordo com o nivel selecionado
 * @param e - ESTADO
 * @param pointer - apontador para a STACK de ESTADOS
 */
void aplica_nivel(ESTADO *e, STACK *pointer){
    switch(e->nivel) {
        case '1':
            bot_facil(e, pointer);
            break;
        case '2':
            bot_medio(e, pointer);
            break;
        case '3':
            bot_minmax(e, pointer);
            break;
        default:
            printf("nivel nao existente\n");
    }
}

/**
 * Muda a vez do jogador que vai jogar
 * @param e - ESTADO
 */
void muda_jogador(ESTADO *e){
    if(e->peca == VALOR_O)
        e->peca = VALOR_X;
    else e->peca = VALOR_O;
}
/**
 * Atualiza o estado no caso em que um jogador nao tem jogadas
 * @param e - ESTADO
 */
void sem_jogadas(ESTADO *e){
    if(e->grelha[3][4] != VAZIA) {
        muda_jogador(e);
        if(posicoes_possiveis(e)){
            printf("Nao ha jogada possivel - vez do jogador seguinte\n");
            printe(e);
            printf("\n");
        } else{
            verifica_vencedor(e);
            e->acabou = 1;
        }
    } else{
        printf("Tabuleiro vazio, comece um novo jogo\n");
    }
}

/**
 * Contabiliza o número de peças não vazias no tabuleiro
 * @param e - ESTADO
 * @return número de pecas nao vazias
 */
int conta_pecas(ESTADO *e){
    int res = 0;
    int i, j;
    for(i = 0; i < 8; i++) {
        for(j = 0; j < 8; j++) {
            if (e->grelha[i][j] != VAZIA)
                res++;
        }
    }
    return res;
}

/**
 * Contabiliza o número de peças que o jogador X tem
 * @param e - ESTADO
 * @return número de pecas X
 */
int contaX(ESTADO *e){
    int res = 0;
    int i, j;
    for(i = 0; i < 8; i++) {
        for(j = 0; j < 8; j++) {
            if (e->grelha[i][j] == VALOR_X)
                res++;
        }
    }
    return res;
}

/**
 * Contabiliza o número de peças que o jogador O tem
 * @param e - ESTADO
 * @return número de pecas O
 */
int contaO(ESTADO *e){
    int res = 0;
    int i, j;
    for(i = 0; i < 8; i++) {
        for(j = 0; j < 8; j++) {
            if (e->grelha[i][j] == VALOR_O)
                res++;
        }
    }
    return res;
}

/**
 * Avalia se o jogo está concluido e atualiza o Estado de acordo
 * @param e - ESTADO
 */
void bool_fim_do_jogo(ESTADO *e){
    if(conta_pecas(e) == 64){
        verifica_vencedor(e);
        e->acabou = 1;
    } else{
        if(posicoes_possiveis(e) == NULL)
            sem_jogadas(e);
    }
}

/**
 * Verifica qual dos jogadores tem mais pecas e dita o vencedor de acordo
 * @param e - ESTADO
 */
void verifica_vencedor(ESTADO*e){
        if(contaO(e) > contaX(e))
            printf("O Vencedor e: O\n");
        else if (contaX(e) > contaO(e))
            printf("O Vencedor e: X\n");
        else printf("Empate\n");
}