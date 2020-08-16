-- | Este módulo define funções comuns da Tarefa 1 do trabalho prático.
module MapEditor where

import DataStruct
import Functions

-- | Uma lista de 'Posicoes'
type Posicoes = [Posicao]

-- * Testes

-- | Testes unitários da Tarefa 1.
--
-- Cada teste é uma sequência de 'Instrucoes'.

-- * Funções principais da Tarefa 1.

-- | Aplica uma 'Instrucao' num 'Editor'.
--
--    * 'Move' - move numa dada 'Direcao'.
--
--    * 'MudaTetromino' - seleciona a 'Peca' seguinte (usar a ordem léxica na estrutura de dados),
--       sem alterar os outros parâmetros.
--
--    * 'MudaParede' - muda o tipo de 'Parede'.
--
--    * 'Desenha' - altera o 'Mapa' para incluir o 'Tetromino' atual, sem alterar os outros parâmetros.
--
--    * 'Roda' - Altera a Direcao do 'Tetromino' para a posicao seguinte na ordem do ponteiros dos relogios

instrucao :: Instrucao -- ^ A 'Instrucao' a aplicar.
          -> Editor    -- ^ O 'Editor' anterior.
          -> Editor    -- ^ O 'Editor' resultante após aplicar a 'Instrucao'.
instrucao (Move d) (Editor p dt t w m) = (Editor (auxMove2 t m p d) dt t w m)
instrucao MudaTetromino (Editor p dt t w m) = (Editor p dt (auxMudaTetromino t) w m)
instrucao MudaParede (Editor p dt t w m) = (Editor p dt t (auxMudaParede w) m)
instrucao Roda (Editor p dt t w m) = (Editor p (auxRoda dt) t w m)
instrucao Desenha (Editor p dt t w m) = (Editor p dt t w (auxDesenha p dt t (Bloco w) m))

-- = Funcoes auxiliares da Funcao 'instrucao'

-- | Função auxiliar do 'Move' que utiliza a função 'somaVetores' e a funcao 'somaVetores', recebe uma direcao 'd' e a posicao 'p' do 'Editor' anterior e dá uma posicao nova
auxMove :: Posicao -> Direcao -> Posicao
auxMove p d = somaVetores p (direcaoParaVetor d)

auxMove2 :: Tetromino -> Mapa -> Posicao -> Direcao -> Posicao
auxMove2 I m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 J m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 L m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 O m p d = if eBordaMatriz2(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 S m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 T m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)
auxMove2 Z m p d = if eBordaMatriz(somaVetores (direcaoParaVetor d) p) m then p else somaVetores p (direcaoParaVetor d)

-- | Função auxiliar do 'MudaTetromino' que recebe um 'tetromino' e muda para o 'tetromino' seguinte pela ordem lexical :: I -> J -> L -> O -> S -> T -> Z -> I 
auxMudaTetromino :: Tetromino -> Tetromino
auxMudaTetromino I = J
auxMudaTetromino J = L
auxMudaTetromino L = O
auxMudaTetromino O = S
auxMudaTetromino S = T
auxMudaTetromino T = Z
auxMudaTetromino Z = I

-- | Função auxiliar do 'MudaParede' que muda entre os dois tipos de Parede | Indestrutivel -> Destrutivel
auxMudaParede :: Parede -> Parede
auxMudaParede Indestrutivel = Destrutivel
auxMudaParede Destrutivel = TNT
auxMudaParede TNT = Arbusto
auxMudaParede Arbusto = Agua
auxMudaParede Agua = Indestrutivel 

-- | Função auxiliar de 'Roda' que altera a direcao do 'Tetromino' quando é rodade de 90º
auxRoda :: Direcao -> Direcao
auxRoda C = D
auxRoda D = B
auxRoda B = E
auxRoda E = C

-- | Função auxiliar de 'Desenha' que inclui o 'Tetromino' atual no 'Mapa', tornando Matriz de Bool em Matriz de Peça
auxDesenha :: Posicao -> Direcao -> Tetromino -> Peca -> Mapa -> Mapa
auxDesenha p dt t (Bloco w) m = atualizaPosicaoMapa (posicaoMatrizParaPosicaoMapa p (encontraTrueMatriz (0,0) (rodaDirecaoMatriz(tetrominoParaMatriz t) dt))) (Bloco w) m

-- == Funções auxiliares de 'auxDesenha'

-- | Função auxiliar de 'auxDesenha' que recebe 'Posicoes', uma 'Peca' e um 'Mapa' e atualiza o 'Mapa' com a 'Peca' nas dadas 'Posicoes' utilizando a funcao 'atualizaPosicaoMatriz'
atualizaPosicaoMapa :: Posicoes -> Peca -> Mapa -> Mapa
atualizaPosicaoMapa [] _ m = m
atualizaPosicaoMapa (h:t) (Bloco w) m = atualizaPosicaoMatriz h (Bloco w) (atualizaPosicaoMapa t (Bloco w) m) 

-- | Função auxiliar de 'auxDesenha' que recebe uma 'Posicao' referente à Posicao do 'Tetromino' no 'Mapa' e 'Posicoes' referente as entradas que correspondem a 'True' dentro da Matriz de Bools e retorna as 'Posicoes' dessas entradas no 'Mapa'  
posicaoMatrizParaPosicaoMapa :: Posicao -> Posicoes -> Posicoes
posicaoMatrizParaPosicaoMapa _ [] = []
posicaoMatrizParaPosicaoMapa (x,y) m = map (somaVetores (x,y)) m

-- | Função auxiliar de 'auxDesenha' que recebe uma 'Matriz' de Bools e devolve as 'Posicoes' onde tem entradas 'True' utilizando um acumulador 'Posicao' e utilizando uma função auxiliar 'encontraTrueLinha'
encontraTrueMatriz :: Posicao -> Matriz Bool -> Posicoes
encontraTrueMatriz _ [] = []
encontraTrueMatriz (a,b) (h:t) = encontraTrueLinha (a,b) h ++ encontraTrueMatriz (a+1,b) t
    where
    -- | Função auxiliar de 'encontraTrueMatriz' que recebe uma lista de 'Bools' e devolve os indices onde o elemento da lista é 'True' e formula Posicoes onde linha vem da função principal 'encontraTrueMatriz' e coluna corresponde ao indices devolvidos
    encontraTrueLinha :: Posicao -> [Bool] -> Posicoes
    encontraTrueLinha _ [] = []
    encontraTrueLinha (l,c) (h:t) | h = (l,c):(encontraTrueLinha (l,c+1) t)
                                  | otherwise = encontraTrueLinha (l,c+1) t 
-- | Função auxiliar de 'auxDesenha' que recebe uma Matriz e uma Direção e roda a matriz consoante a direção tomando por base a matriz com direcao C - virada para cima
rodaDirecaoMatriz :: Matriz a -> Direcao -> Matriz a
rodaDirecaoMatriz m C = m
rodaDirecaoMatriz m D = rodaMatriz m
rodaDirecaoMatriz m B = rodaMatriz (rodaMatriz m) 
rodaDirecaoMatriz m E = rodaMatriz (rodaMatriz (rodaMatriz m)) 


-- | Aplica uma sequência de 'Instrucoes' num 'Editor'.
--
-- __NB:__ Deve chamar a função 'instrucao'.
--
instrucoes :: Instrucoes -- ^ As 'Instrucoes' a aplicar.
           -> Editor     -- ^ O 'Editor' anterior.
           -> Editor     -- ^ O 'Editor' resultante após aplicar as 'Instrucoes'.
instrucoes [] (Editor p dt t w m) = (Editor p dt t w m)
instrucoes (x:y) (Editor p dt t w m) = instrucoes y (instrucao x (Editor p dt t w m))

-- | Cria um 'Mapa' inicial com 'Parede's nas bordas e o resto vazio.
mapaInicial :: Dimensao -- ^ A 'Dimensao' do 'Mapa' a criar.
            -> Mapa     -- ^ O 'Mapa' resultante com a 'Dimensao' dada.
mapaInicial (l,c) = auxMapaInicial (l,c) (retornaPosicoesBordaMatriz (posicoesMatriz (l,c) (0,0)) (criaMatriz (l,c) Vazia))

-- | Recebe uma 'Dimensao' e 'Posicoes' e atualiza uma Mapa com 'Bloco Indestrutivel' nas posicoes
auxMapaInicial :: Dimensao -> Posicoes -> Mapa
auxMapaInicial (l,c) ((a,b):[]) = atualizaPosicaoMatriz (a,b) (Bloco Indestrutivel) (criaMatriz (l,c) Vazia) 
auxMapaInicial (l,c) (h:t) = atualizaPosicaoMatriz h (Bloco Indestrutivel) (auxMapaInicial (l,c) t) 

-- | Guarda as 'Posicoes' da 'Matriz' que se encontram na Borda
retornaPosicoesBordaMatriz :: Posicoes -> Matriz a -> Posicoes
retornaPosicoesBordaMatriz [] _ = []
retornaPosicoesBordaMatriz _ [] = []
retornaPosicoesBordaMatriz (h:t) m | eBordaMatriz h m = h : (retornaPosicoesBordaMatriz t m)
                                   | otherwise = retornaPosicoesBordaMatriz t m

-- | Dada uma 'Dimensao' e uma 'Posicao' inicial de uma Matriz, retorna todas as posicoes da Matriz com essa 'Dimensao' 
posicoesMatriz :: Dimensao -> Posicao -> Posicoes
posicoesMatriz (0,0) (a,b) = [] 
posicoesMatriz (l,c) (a,b) | a == (l-1) && b == (c-1) = (a,b):[]
                           | b == (c-1) = (a,b): posicoesMatriz (l,c) ((a+1),0)
                           | otherwise = (a,b): posicoesMatriz (l,c) (a,(b+1))   

-- | Cria um 'Editor' inicial.
--
-- __NB:__ Deve chamar as funções 'mapaInicial', 'dimensaoInicial', e 'posicaoInicial'.
-- 
editorInicial :: Instrucoes  -- ^ Uma sequência de 'Instrucoes' de forma a poder calcular a  'dimensaoInicial' e a 'posicaoInicial'.
              -> Editor      -- ^ O 'Editor' inicial, usando a 'Peca' 'I' 'Indestrutivel' voltada para 'C'.
editorInicial is = (Editor (posicaoInicial is) C I Indestrutivel (mapaInicial(dimensaoInicial is)))


-- | Constrói um 'Mapa' dada uma sequência de 'Instrucoes'.
--
-- __NB:__ Deve chamar as funções 'Instrucoes' e 'editorInicial'.
constroi :: Instrucoes -- ^ Uma sequência de 'Instrucoes' dadas a um 'Editor' para construir um 'Mapa'.
         -> Mapa       -- ^ O 'Mapa' resultante.
constroi is = auxConstroi (instrucoes is (editorInicial is))

-- | Constrói uma 'Mapa' a partir de um editor.
auxConstroi :: Editor -> Mapa
auxConstroi (Editor p dt t w m) = m



