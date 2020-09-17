-- | Este mÃ³dulo def 1g000 where

module Functions where

import DataStruct

-- * FunÃ§Ãµes nÃ£o-recursivas.

-- | Um 'Vetor' Ã© uma 'Posicao' em relaÃ§Ã£o Ã  origem.
type Vetor = Posicao
-- ^ <<http://oi64.tinypic.com/mhvk2x.jpg vetor>>

-- ** FunÃ§Ãµes sobre vetores

-- *** FunÃ§Ãµes gerais sobre 'Vetor'es.

-- | Soma dois 'Vetor'es.
somaVetores :: Vetor -> Vetor -> Vetor
somaVetores (l1,c1) (l2,c2) = (l1+l2,c1+c2) 

-- | Subtrai dois 'Vetor'es.
subtraiVetores :: Vetor -> Vetor -> Vetor
subtraiVetores (l1,c1) (l2,c2) = (l1-l2,c1-c2)  

-- | Multiplica um escalar por um 'Vetor'.
multiplicaVetor :: Int -> Vetor -> Vetor
multiplicaVetor x (l,c) = (x*l,x*c)

-- | Roda um 'Vetor' 90Âº no sentido dos ponteiros do relÃ³gio, alterando a sua direÃ§Ã£o sem alterar o seu comprimento (distÃ¢nciaa Ã  origem).
--
-- <<http://oi65.tinypic.com/2j5o268.jpg rodaVetor>>
rodaVetor :: Vetor -> Vetor
rodaVetor (l,c) = (c,-l)

-- | Espelha um 'Vetor' na horizontal (sendo o espelho o eixo vertical).
--
-- <<http://oi63.tinypic.com/jhfx94.jpg inverteVetorH>>
inverteVetorH :: Vetor -> Vetor
inverteVetorH (l,c) = (l,-c)

-- | Espelha um 'Vetor' na vertical (sendo o espelho o eixo horizontal).
--
-- <<http://oi68.tinypic.com/2n7fqxy.jpg inverteVetorV>>
inverteVetorV :: Vetor -> Vetor
inverteVetorV (l,c) = (-l,c)

-- *** FunÃ§Ãµes do trabalho sobre 'Vetor'es.

-- | Devolve um 'Vetor' unitÃ¡rio (de comprimento 1) com a 'Direcao' dada. 

direcaoParaVetor :: Direcao -> Vetor
direcaoParaVetor C = ((-1), 0)
direcaoParaVetor B = (1,0)
direcaoParaVetor D = (0,1)
direcaoParaVetor E = (0,(-1))

-- ** FunÃ§Ãµes sobre listas

-- *** FunÃ§Ãµes gerais sobre listas.
--
-- FunÃ§Ãµes nÃ£o disponÃ­veis no 'Prelude', mas com grande utilidade.

-- | Verifica se o indice pertence Ã  lista.

eIndiceListaValido :: Int -> [a] -> Bool
eIndiceListaValido x [] = False
eIndiceListaValido x (h:t) | x == 0 = True
                           | otherwise = eIndiceListaValido (x-1) t

-- ** FunÃ§Ãµes sobre matrizes.

-- *** FunÃ§Ãµes gerais sobre matrizes.

-- | Uma matriz Ã© um conjunto de elementos a duas dimensÃµes.
--
-- Em notaÃ§Ã£o matemÃ¡tica, Ã© geralmente representada por:
--
-- <<https://upload.wikimedia.org/wikipedia/commons/d/d8/Matriz_organizacao.png matriz>>
type Matriz a = [[a]]

-- | Calcula a dimensÃ£o de uma matriz.
dimensaoMatriz :: Matriz a -> Dimensao
dimensaoMatriz [] = (0,0)
dimensaoMatriz ([]:t) = (0,0) 
dimensaoMatriz m = (length m, length(head m))

-- | Verifica se a posiÃ§Ã£o pertence Ã  matriz.
ePosicaoMatrizValida :: Posicao -> Matriz a -> Bool 
ePosicaoMatrizValida _ [] = False
ePosicaoMatrizValida (l,c) (h:t) | l == 0 = eIndiceListaValido c h
                                 | otherwise = ePosicaoMatrizValida (l-1,c) t 

-- | Verifica se a posiÃ§Ã£o estÃ¡ numa borda da matriz.
eBordaMatriz :: Posicao -> Matriz a -> Bool
eBordaMatriz (l,c) [] = False
eBordaMatriz (l,c) m = l == 0 || c == 0 || l == (length m -1) || c == (length (head m) -1) 

eBordaMatriz2 :: Posicao -> Matriz a -> Bool
eBordaMatriz2 (l,c) [] = False
eBordaMatriz2 (l,c) m = l == 0 || c == 0 || l == (length m -2) || c == (length (head m) -2) 


-- *** FunÃ§Ãµes do trabalho sobre matrizes.

-- | Converte um 'Tetromino' (orientado para cima) numa 'Matriz' de 'Bool'.
--
-- <<http://oi68.tinypic.com/m8elc9.jpg tetrominos>>
tetrominoParaMatriz :: Tetromino -> Matriz Bool
tetrominoParaMatriz I = [[False,True,False,False],[False,True,False,False],[False,True,False,False],[False,True,False,False]]
tetrominoParaMatriz J = [[False,True,False],[False,True,False],[True,True,False]]
tetrominoParaMatriz L = [[False,True,False],[False,True,False],[False,True,True]]
tetrominoParaMatriz O = [[True,True],[True,True]] 
tetrominoParaMatriz S = [[False,True,True],[True,True,False],[False,False,False]]
tetrominoParaMatriz T = [[False,False,False],[True,True,True],[False,True,False]]
tetrominoParaMatriz Z = [[True,True,False],[False,True,True],[False,False,False]]  

-- * FunÃ§Ãµes recursivas.

-- ** FunÃ§Ãµes sobre listas.
--
-- FunÃ§Ãµes nÃ£o disponÃ­veis no 'Prelude', mas com grande utilidade.

-- | Devolve o elemento num dado Ã­ndice de uma lista.
encontraIndiceLista :: Int -> [a] -> a 
encontraIndiceLista 0 (h:t) = h
encontraIndiceLista x (h:t) = encontraIndiceLista (x-1) t

-- | Modifica um elemento num dado Ã­ndice.
--
-- __NB:__ Devolve a prÃ³pria lista se o elemento nÃ£o existir.
atualizaIndiceLista :: Int -> a -> [a] -> [a]
atualizaIndiceLista _ _ [] = []
atualizaIndiceLista 0 e (h:t) = (e:t)
atualizaIndiceLista p e (h:t) | p >= length (h:t) = (h:t)
                              | otherwise =  h : atualizaIndiceLista (p-1) e t                              
-- ** FunÃ§Ãµes sobre matrizes.

-- | Roda uma 'Matriz' 90Âº no sentido dos ponteiros do relÃ³gio.
--
-- <<http://oi68.tinypic.com/21deluw.jpg rodaMatriz>>
rodaMatriz :: Matriz a -> Matriz a
rodaMatriz [] = []
rodaMatriz ([]:_) = []
rodaMatriz ((h:t):[]) = [[h]] ++ rodaMatriz (t:[])
rodaMatriz m = (reverse (map head m)) : (rodaMatriz (map tail m))

-- | Inverte uma 'Matriz' na horizontal.
--
-- <<http://oi64.tinypic.com/iwhm5u.jpg inverteMatrizH>>

inverteMatrizH :: Matriz a -> Matriz a
inverteMatrizH [] = []
inverteMatrizH m = ((reverse(head m)) : inverteMatrizH (tail m))  

-- | Inverte uma 'Matriz' na vertical.
--
-- <<http://oi64.tinypic.com/11l563p.jpg inverteMatrizV>>
inverteMatrizV :: Matriz a -> Matriz a
inverteMatrizV [] = []
inverteMatrizV m = reverse m 

-- | Cria uma nova 'Matriz' com o mesmo elemento.
criaMatriz :: Dimensao -> a -> Matriz a
criaMatriz (a,b) x = (replicate a (replicate b x)) 


-- | Devolve o elemento numa dada 'Posicao' de uma 'Matriz'.
encontraPosicaoMatriz :: Posicao -> Matriz a -> a
encontraPosicaoMatriz (0,c) (h:t) = encontraIndiceLista c h
encontraPosicaoMatriz (l,c) (h:t) = encontraPosicaoMatriz (l-1,c) t

-- | Modifica um elemento numa dada 'Posicao'
--
-- __NB:__ Devolve a prÃ³pria 'Matriz' se o elemento nÃ£o existir.
atualizaPosicaoMatriz :: Posicao -> a -> Matriz a -> Matriz a
atualizaPosicaoMatriz _ _ [] = []
atualizaPosicaoMatriz (0,c) e m = (atualizaIndiceLista c e (head m)):(tail m)
atualizaPosicaoMatriz (l,c) e m = if l >= length m || c >= length(head m) then m else (head m):(atualizaPosicaoMatriz (l-1,c) e (tail m))