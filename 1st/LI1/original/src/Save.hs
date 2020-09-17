{-| Este módulo define funções comuns da Tarefa 3 do trabalho prático.

__Introdução__

Esta tarefa do trabalho prático tinha como objetivo comprimir e descomprimir um 'Estado' de jogo.

A tarefa foi realizada em 2 partes. A primeira parte em que se comprimia um 'Estado' e uma segunda parte em que se descomprimia esse 'Estado'.
O grande objetivo foi obter o máximo de compressão possivel, para depois obter uma taxa de compressão média em percentagem no site da displina.
Foi criado nesse site uma tabela com as taxas de compressão de cada grupo e a sua devida classificação.

__Objetivos/Desenvolvimento__

Apartir do título /Funções principais da Tarefa 3/ encontram-se as funções criadas e utilizadas como forma de criar a compressão e descompressão do 'Estado' seguidas da sua análise e explicação.

__Discução/Conclusão__

Os resultados obtidos inicialmente não foram esperados com vários testes da tabela de classificação a dar erro. 
Contudo após a melhoria a taxa de compressão passou para 96% o que deu de nota final de 70%.
Contudo o resultado final após a melhoria atingiu os objetivos esperados.
-}

module Save where

import DataStruct
import Functions
import MapEditor

-- * Testes

{- | Testes unitários da Tarefa 3.

Os testes utilizados tiveram como função testar a capacidade de compressão/descompressão no terminal.

Cada teste é um 'Estado'.
-}
testesT3 :: [Estado]
testesT3 = [(Estado m listaJ listaD)]
         where m = constroi [Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move E,Move C,Move C,Move C,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move C,Move D,Move D,Move D,Move D,Move D,Move D,Move D,Move C,Move C,Move C,Move B,Move E,Move E,Move E,Desenha,Move B,Move B,Move B,Move B,Move B,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move B,Desenha,Move B,Move B,Desenha,Move E,Move C,Move C,Desenha,Move E,Desenha,Desenha,Move E,Desenha,Move E,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Desenha,Move E,Move E,Desenha]
               listaJ = [(Jogador (1,1) B 1 1 1),(Jogador (3,6) D 2 3 2),(Jogador (6,2) C 1 3 2),(Jogador (6,6) E 2 1 1)]
               listaD = [(DisparoCanhao 0 (1,4) D),(DisparoLaser 1 (3,4) D),(DisparoLaser 3 (3,2) C),(DisparoChoque 2 5)]

            
-- * Funções principais da Tarefa 3.

-- ** Compressão

{- | Comprime um 'Estado' para formato textual.

Esta função inicial é a principal função na primeira parte da tarefa - Compressão.

Se o estado em questão não possui nenhum mapa, lista de jogadores nem lista de disparos então a compressão é uma string vazia.
Caso contrário conmprime-se cada um dos parâmetros atraves de funções auxilares.

 * Para comprir o mapa utiliza-se a função 'auxComprimeM'.
 * Para comprimir a lista de jogadores utilizou-se a 'comprimeJogadores'.
 * Para comprimir a lista de disparos utiliza-se a 'comprimeDisparos'.

Adiciona-se cada uma das compressões numa única string, separadas pelo o simpolo "&".
-}
comprime :: Estado -> String
comprime (Estado [] [] []) = ""
comprime (Estado m je de) = auxComprimeM m ++ "&" ++ comprimeJogadores je ++ "&" ++ comprimeDisparos de

-- *** Funções para a compressão da lista de disparos

{- | Função que comprime a lista de disparos

Tal como aconteceu na função 'comprime', quando a lista de disparos é vazia então a copressão é uma string vazia
Caso contrário utilizou-se 2 funções auxiliares:

 * Numa primeira estância comprime-se a lista dos disparos através da função 'auxComprimeDisparos'
 * Numa segunda e última estância remove-se os elemento que são dispensáveis o que faz com que se consiga comprimir mais essa lista e obter maior taxe de compressão. Utiliza-se para isso a função 'removeDesnecessarios'.
-} 
comprimeDisparos :: [Disparo] -> String
comprimeDisparos [] = ""
comprimeDisparos l = removeDesnecessarios (auxComprimeDisparos l)

{- | Função que cria uma string que representa a lista de disparos

Esta função percorre a lista dos disparos e vai comprimindo cada elemento da lista recursivamente. Para isso utiliza a função do prelud 'show'.

Como forma de identificar cada um dos 3 disparos distintos colocou-se no incio de cada disparo comprimido um simbolo para sua posterior identificação na descompressão.
-} 
auxComprimeDisparos :: [Disparo] -> String
auxComprimeDisparos [] = ""
auxComprimeDisparos [x] = case x of 
                            (DisparoCanhao jd pd dd) -> "!" ++ show pd ++ show dd ++ show jd ++ " "
                            (DisparoLaser jd pd dd) -> "?" ++ show pd ++ show dd ++ show jd ++ " "
                            (DisparoChoque jd ti) -> show jd ++ "," ++ show ti ++ " "
auxComprimeDisparos (h:t) = case h of 
                              (DisparoCanhao jd pd dd) -> "!" ++ show pd ++ show dd ++ show jd ++ " " ++ auxComprimeDisparos t
                              (DisparoLaser jd pd dd) -> "?" ++ show pd ++ show dd ++ show jd ++ " " ++ auxComprimeDisparos t
                              (DisparoChoque jd ti) -> show jd ++ "," ++ show ti ++ " " ++ auxComprimeDisparos t 

{- | Função que remove simbolos dispensàveis à compressão 

Esta função tem como principal objetivo aumentar a taxa de compressão eliminando elementos que são desnecessarios á descompressão.

A função retira á lista em questão os "( )"
-}
removeDesnecessarios :: String -> String
removeDesnecessarios "" = ""
removeDesnecessarios xs = [ x | x <- xs, not (x `elem` "()") ]

-- *** Função para a compressão da lista de jogadores

{- | Função que comprime a lista dos jogadores

Esta função foi realizada segundo esta ordem:

 * Comprime-se cada um dos jogadores atraves da função map e da função 'comprimeJogador' que torna a lista dos jogadores numa lista de strings.
 * Para tornar essa lista de strings numa string com os elementos (jogadores) separados, utiliza-se a função do prelud 'unwords' que separa cada um dos jogadores comprimidos numa string.
 * Para além disso, tal como aconteceu na função 'auxComprimeDisparos' também se utilizou a função 'removeDesnecesarios'. 
-}
comprimeJogadores :: [Jogador] -> String
comprimeJogadores [] = " "
comprimeJogadores l = removeDesnecessarios (unwords(map (comprimeJogador) l))
    where
    comprimeJogador :: Jogador -> String
    comprimeJogador (Jogador pj dj vj lj cj)  = show pj ++ show dj ++ show vj ++ "," ++ show lj ++ "," ++ show cj

-- *** Funções para a compressão do mapa

{- | Função que comprime o mapa do 'Estado'

Melhor é a taxa de compressão quanto mais estiver comprimido o mapa do estado. Por isso com esse mesmo intuito criou-se esta função com a seguinte estrutura:

 * Começa-se por retira a borda ao mapa através da função 'removeBorda', uma vez que é escusado comprimir um mapa com borda pois todos os mapas tem bordas iguais, com paredes indestrutiveis.
 * Comprime-se o mapa atraves da função 'comprimeMapa', obtendo-se uma longa string.
 * De forma a reduzir a string obtida no passo anterior, utiliza-se a função 'juntaSeguidos'.
 * Finalmente transforma-se a lista de strings obtida numa string atraves da função 'comprimeSeguidos'.

__Nota:__ Como é obtida uma longa string na compressão do mapa perde-se a dimenção deste e por isso, determina-se o número de colunas que o mapa possui sem a borda, atraves da função 'numeroColuna'.  
-} 
auxComprimeM :: Mapa -> String
auxComprimeM [] = ""
auxComprimeM m = show (numeroColunas (removeBorda m)) ++ "#" ++ comprimeSeguidos(juntaSeguidos (comprimeMapa (removeBorda m)))

-- | Função que determina o numero de colunas do mapa.
numeroColunas :: Matriz a -> Int
numeroColunas m = snd(dimensaoMatriz m)

{- | Função que remove as bordas do mapa

Para remover as bordas do mapa, basta remover as últimas colunas/linhas e remover a primeira coluna e ignorar a primeira linha.
-}
removeBorda :: Matriz a -> Matriz a
removeBorda (h:t) = tirarUltLinha(tirar1Coluna (tirarUltColuna t))
    where
    tirar1Coluna :: Matriz a -> Matriz a
    tirar1Coluna m = map (drop 1) m
    tirarUltLinha :: Matriz a -> Matriz a
    tirarUltLinha m = inverteMatrizV (tail(inverteMatrizV m))
    tirarUltColuna :: Matriz a -> Matriz a
    tirarUltColuna m = inverteMatrizH (map (drop 1) (inverteMatrizH m))

{- | Função que comprime linha a linha o mapa do estado

Atraves da recursividade comprime cada linha do mapa sendo que:

 * v - Vazia 
 * d - Bloco Destrutivel 
 * i - Bloco Indestrutivel
-}
comprimeMapa :: Mapa -> String
comprimeMapa [] = []
comprimeMapa (h:t) = comprimeLinha  h ++ comprimeMapa t 
    where
    comprimeLinha :: [Peca] -> String
    comprimeLinha [] = []
    comprimeLinha (h:t)| h == Vazia = 'v' : (comprimeLinha t)
                       | h == Bloco Destrutivel = 'd' : (comprimeLinha t)
                       | otherwise = 'i' :(comprimeLinha t)

{- | Função que agrupa partes seguidas e iguais do mapa comprimido 

Transforma uma string numa lista de strings sendo cada elemento dessa lista uma string com os elementos seguidos da string original (mapa comprimido), seguindo o exemplo.

=== Exemplo:
@
 juntaSeguidos "vvvvvviiiddvvv" -- ^ mapa comprimido
 ["vvvvvv", "iii", "dd", "vvv"] -- ^ resultado obido
@
-} 
juntaSeguidos :: String -> [String]
juntaSeguidos (h:t) = auxJuntaSeguidos [h] t
    where
    auxJuntaSeguidos :: String -> String -> [String]
    auxJuntaSeguidos hs [] = [hs]
    auxJuntaSeguidos hs (x:xs) = if x == head hs then auxJuntaSeguidos (hs++[x]) xs else hs : auxJuntaSeguidos [x] xs

{- | Função que determina o numero de repetições de partes seguidas e iguais no mapa.

Reduz a lista de strings obtida na função 'juntaSeguidos' numa string seguindo o exemplo:

=== Exemplo:
@
 comprimeSeguidos ["vvvvvv", "iii", "dd", "vvv"]
 "6v3i2d3v"
@
-}
comprimeSeguidos :: [String] -> String
comprimeSeguidos [] = ""
comprimeSeguidos (x:y) = show (length x) ++ [head x] ++ comprimeSeguidos y

-- ** Descompressão

{- | Descomprime um 'Estado' no formato textual utilizado pela função 'comprime'.

Esta função inicial é a principal função da segunda parte da tarefa - Descompressão.

Se a string em questão for vazia, então o 'Estado' não possui nenhum mapa, lista de jogadores nem lista de disparos.
Caso contrário descomprime-se a string para cada um dos parâmetros do estado atraves de funções auxiliares.

Para descomprimir o mapa:
 * Sabe-se que na string de compressão o mapa vai até ao primeiro "&". As duas funções auxiliares 'separaStringFinal' e 'listaStringParaPar' vão obter a string com únicamente o mapa comprimido.
 * Posteriormente descomprime-se a string obtida no mapa atraves da função 'auxDescomprimeM'   

Para descomprimir a lista de jogadores:

 * Sabe-se que na string de compressão a lista de jogadores estava entre o 1 e o 2 "&". As duas funções auxiliares 'separaStringFinal' e 'listaStringParaPar' vão obter a string com únicamente os jogadores comprimidos.
 * Posteriormente descomprime-se a string obtida na lista dos jogadores atraves da função 'descomprimeJogadores'

Para descomprimir a lista de disparos:

 * Sabe-se que na string de compressão a lista dos disparos depois do 2 "&". A função auxiliar 'recuperaUltimoFinal' vai obter a string com únicamente a lisda dos disparos comprimidos.
 * Posteriormente descomprime-se a string obtida na lista dos disparos atraves da função 'descomprimeDisparos'
-}
descomprime :: String -> Estado
descomprime "" = (Estado [] [] [])
descomprime (h:t) = (Estado (auxDescomprimeM (fst(listaStringParaPar (separaStringFinal [h] t)))) 
                            (descomprimeJogadores (snd(listaStringParaPar(separaStringFinal [h] t))))
                            (descomprimeDisparos (recuperaUltimoFinal (h:t))))
  
-- *** Funções auxiliares para a descompressão do mapa e da lista de jogadores

{- | Descomprime as listas de caracteres

Esta função avalia a posição dos "&" que na função 'comprime' separavam os vários parâmetros do estado.

Assim obtem-se desta função uma lista de strings com 2 elementos. 
O primeiro elemento é uma string que representa o mapa do estado comprimido.
O segundo elemento é uma string que representa a lista de jogadores comprimido.
-} 
separaStringFinal :: String -> String -> [String]
separaStringFinal hs (x1:x2:xs) = if x1 == '&' then hs : separaStringFinal [x2] xs else separaStringFinal (hs++[x1]) (x2:xs)
separaStringFinal hs [x] = if x == '&' then [hs] else []
separaStringFinal _ _ = []

{- | Divide a String num Par

Desta forma não há perda de informação quando tanto a lista dos jogadores como o mapa é vazia.
-}
listaStringParaPar :: [String] -> (String,String)
listaStringParaPar (x:[]) = (x,"")
listaStringParaPar (x:t) = (x, (head t))

-- *** Funções para a descompressão da lista dos disparos  

{- | Função que encontra lista de disparos comprimida na string de compressão

Através da função do prelud 'reverse' quando a função encontrar o primeiro "&" então tudo o que estava para trás era a lista dos diaparos comprimida.
Isso é conseguido através de uma outra função do prelud 'take'.
-}
recuperaUltimoFinal :: String -> String
recuperaUltimoFinal s = reverse(retiraPrimeiroFinal 0 (reverse s) (reverse s))
    where
    retiraPrimeiroFinal :: Int -> String -> String -> String
    retiraPrimeiroFinal i (h:t) s = if h == '&' then take i s else retiraPrimeiroFinal (i+1) t s 

{- | Função que descomprime a lista dos disparos

Nesta função utilizam-se 2 funções auxiliares 'auxDescomprimeDisparos' e 'discomprimeDisparos'.

 * Na primeira cria-se uma lista de strings cujos elementos da lista são cada um disparos do estado.
 * Na segunda descomprime-se essa lista de strin para uma lista de disparos. 
-} 
descomprimeDisparos :: String -> [Disparo]
descomprimeDisparos "" = []
descomprimeDisparos s = descomprimeDisparo(auxDescomprimeDisparos s)

{- | Função auxiliar da 'descomprimeDisparos'

-- Atraves da string com os disparos cria uma lista de strings cujo cada elemento é um disparo, para mais fácil descompressão.
-- Utiliza como funções auxiliares a 'separaString' e a 'recuperaUltimo'.
-}
auxDescomprimeDisparos :: String -> [String]
auxDescomprimeDisparos "" = []
auxDescomprimeDisparos (h:t) = separaString [h] t ++ [recuperaUltimo (h:t)]

-- | Função que vai tornar cada disparo num elemento de uma lista de string
--
-- Basea-se na verificação da posição do " " (espaço entre caracteres) 
separaString :: String -> String -> [String]
separaString hs (x1:x2:xs) = if x1 == ' ' then hs : separaString  [x2] xs else separaString (hs++[x1]) (x2:xs)
separaString hs [x] = if x == ' ' then [hs] else []
separaString _ _ = []

-- | Função que recupera o último da lista de disparos 
recuperaUltimo :: String -> String
recuperaUltimo s = reverse(retiraPrimeiro 0 (reverse s) (reverse s))
    where
    retiraPrimeiro :: Int -> String -> String -> String
    retiraPrimeiro i [] s = []
    retiraPrimeiro i (h:t) s = if h == ' ' then take i s else retiraPrimeiro (i+1) t s

-- | Função que descomprime uma string na lista de disparos
--
-- Utilizando a função do prelud 'map', esta vai aplicar a descompressão dada pela função 'auxDescomprimeDisparo' a todos os elementos da lista.
-- Sendo que essa lista com strings vazias removidas atraves da função 'removeStringVazias'.
descomprimeDisparo :: [String] -> [Disparo]
descomprimeDisparo s = map (auxDescomprimeDisparo) (removeStringVazias s)

-- | Função que remove de uma lista de strings os elementos que são vazio
removeStringVazias :: [String] -> [String]
removeStringVazias [] = []
removeStringVazias (h:t) = if h == "" then (removeStringVazias t) else h:(removeStringVazias t)

{- | Função que descomprime um disparo

Função que baseada na indicação dada na compressão (função 'auxComprimeDisparos'), descomprime cada um dos disparos. Utiliza para isso diversas funções auxiliares:

 * 'descomprimeResto' com 'retira3'
 * 'descomprimePosGre' 
 * 'descomprimeDirecao' com 'retira1'
 * 'retira2' e 'retira4' no disparo choque

__Nota:__ É também utilizada uma função do prelud 'read' que faz o oposto do 'show'.
É de notar que as funções retira são usadas como forma de irem sempre reduzindo a string para posterior descompressão.
-}     
auxDescomprimeDisparo :: String -> Disparo
auxDescomprimeDisparo (h:t) = case h of 
                                  '!' -> (DisparoCanhao (descomprimeResto(retira3 0 t t)) (descomprimePosGre t) (descomprimeDirecao(retira1 0 t t)))
                                  '?' -> (DisparoLaser (descomprimeResto(retira3 0 t t)) (descomprimePosGre t) (descomprimeDirecao(retira1 0 t t)))                                     
                                  otherwise -> (DisparoChoque (read(retira2 0 (h:t) (h:t)) :: Int) (read(retira4 0 (h:t) (h:t)) :: Int))

-- | Função que descomprime a posição do disparo/jogador, baseando-se na forma de separação dos caracteres imposto na compressão
descomprimePosGre :: String -> PosicaoGrelha
descomprimePosGre l = read ("(" ++ (auxDescomprimePosGre l) ++ ")") :: PosicaoGrelha
    where
    auxDescomprimePosGre :: String -> String
    auxDescomprimePosGre (h:t) = if h == 'C' || h == 'B' || h == 'D' || h == 'E' then [] else h:(auxDescomprimePosGre t)

-- | Função que descomprime a direção do disparo/jogador, baseando-se na forma de separação dos caracteres imposto na compressão
descomprimeDirecao :: String -> Direcao
descomprimeDirecao (h:t) =  read [h] :: Direcao

-- | Função que descomprime os inteiros da string para o diaparo/jogador, baseando-se na forma de separação dos caracteres imposto na compressão
descomprimeResto :: String -> Int
descomprimeResto (h:t) = if t == [] then read [h] :: Int else read (h:t) :: Int
    where
    auxDescomprimeResto :: String -> String
    auxDescomprimeResto (h:t) = if h == ',' then [] else (h:(auxDescomprimeResto t))

-- *** Funções para a descompressão da lista dos jogadores

{- | Função que descomprime a lista dos jogadores

Utiliza as mesmas bases que o 'descomprimeDisparo' só que aplicadas ao jogador. As funções auxiliares são: 'descomprimeJogador' e 'auxDescomprimeJogadores'.
-}
descomprimeJogadores :: String -> [Jogador]
descomprimeJogadores "" = []
descomprimeJogadores s = map (descomprimeJogador) (auxDescomprimeJogadores s) 

-- | Função auxiliar da 'descomprimeJogadores'
--
-- Tem por base as mesmas funções e ideias que a 'auxDescomprimeDisparo'. 
auxDescomprimeJogadores :: String -> [String]
auxDescomprimeJogadores [] = []
auxDescomprimeJogadores (h:t) = separaString [h] t ++ [recuperaUltimo (h:t)]

{- | Função que descomprime um só jogador

Função que descomprime cada um dos jogadores. Utiliza para isso diversas funções auxiliares:

 * 'descomprimeResto'
 * 'descomprimePosGre' 
 * 'descomprimeDirecao' 
 * 'retira1', 'retira2', 'retira3', 'retira4'

__Nota:__ É de notar que as funções retira são usadas como forma de irem sempre reduzindo a string para posterior descompressão.
-}
descomprimeJogador :: String -> Jogador
descomprimeJogador l = (Jogador (descomprimePosGre l)  
                       (descomprimeDirecao(retira1 0 l l)) 
                       (descomprimeResto(retira2 0 (retira3 0 l l) (retira3 0 l l))) 
                       (descomprimeResto(retira2 0 ((retira4 0 (retira3 0 l l) (retira3 0 l l))) ((retira4 0 (retira3 0 l l) (retira3 0 l l))))) 
                       (descomprimeResto(retira4 0 ((retira4 0 (retira3 0 l l) (retira3 0 l l))) ((retira4 0 (retira3 0 l l) (retira3 0 l l))))))

-- | Função que retira da string o que está antes da virgula incluindo
retira4 :: Int -> String -> String -> String
retira4 i l (h:t) = if h == ',' then drop (i+1) l else retira4 (i+1) l t

-- | Função que retira da tudo o que está antes da direção incluindo
retira3 :: Int -> String -> String -> String
retira3 i l (h:t) = if h == 'C' || h == 'B' || h == 'D' || h == 'E' then drop (i+1) l else retira3 (i+1) l t

-- | Função do qual se obtem tudo o que está a atrás da virgula incluindo
retira2 :: Int -> String -> String -> String
retira2 i l (h:t) = if h == ',' then take i l else retira2 (i+1) l t 

-- | Função que retira da string o que está antes da direção 
retira1 :: Int -> String -> String -> String
retira1 i l (h:t) = if h == 'C' || h == 'B' || h == 'D' || h == 'E' then drop i l else retira1 (i+1) l t

-- *** Funções para a descompressão do mapa

{- | Função que descomprime o mapa do Estado

Função que recebe uma string com o mapa comprimido e transforma no mapa do estado.

Nesta função são utilizadas outras funções auxiliares tais como:

 * 'retiraNoColunas' e 'retiraMapa' -- ^ funções que vão buscar á string o número de colunas do mapa original e o mapa comprimido, respetivamente.
 * 'divideMapaLinhas' -- ^ atraves do número obtido em 'retiraNoColuna' devide se o mapa já descomprimido nas suas linhas e colunas.
 * 'descomprimeMapa' e 'auxDescomprimeMapa'.
 * 'acrescentaBorda' --^ que acrescenta borda ao mapa já descomprimido.

__Nota:__ Foi utilizado a função do prelud 'read' para ler o número da coluna.
-} 
auxDescomprimeM :: String -> Mapa
auxDescomprimeM "" = []
auxDescomprimeM s = acrescentaBorda (read (retiraNoColunas 0 s s) :: Int) (divideMapaLinhas (read (retiraNoColunas 0 s s) :: Int) (descomprimeMapa (auxDescomprimeMapa (retiraMapa 0 s s))))

-- | Função que retira da String o numero de colunas
--
-- Baseado na separação feita entre o mapa comprimido e o número de colunas na função 'auxComprimeM'.
-- O número de colunas encontra-se á frente da separação dada por "#", enquanto que o mapa comprimido fica depois dessa separação.
retiraNoColunas :: Int -> String -> String -> String
retiraNoColunas i (h:t) s = if h == '#' then take i s else retiraNoColunas (i+1) t s

-- | Função que divide o mapa nas varias linhas basendo-se no número de colunas
divideMapaLinhas :: Int -> [Peca] -> Mapa
divideMapaLinhas _ [] = []
divideMapaLinhas c l = take c l : (divideMapaLinhas c (drop c l))

-- | Função que retira da String o mapa comprimido
--
-- Baseado na separação feita entre o mapa comprimido e o número de colunas na função 'auxComprimeM'.
-- O número de colunas encontra-se á frente da separação dada por "#", enquanto que o mapa comprimido fica depois dessa separação.
retiraMapa :: Int -> String -> String -> String
retiraMapa i (h:t) s = if h == '#' then drop (i+1) s else retiraMapa (i+1) t s

{-| Função que descomprime a string do mapa comprimido numa outra mais descomprimida

Função que realiza o processo inverso do realizado nas funções 'comprimeSeguidos' e 'juntaSeguidos'.

=== Exemplo:
@
  auxDescomprimeMapa "6v3i2d3v"
  "vvvvvviiiddvvv"
@
-}
auxDescomprimeMapa :: String -> String
auxDescomprimeMapa "" = ""
auxDescomprimeMapa s = separaMapa 0 s s
    where
    separaMapa :: Int -> String -> String -> String
    separaMapa _ _ "" = ""
    separaMapa i s (h:t)  | h == 'v' = replicate (read (take i s) :: Int) 'v' ++ auxDescomprimeMapa t
                          | h == 'i' = replicate (read (take i s) :: Int) 'i' ++ auxDescomprimeMapa t
                          | h == 'd' = replicate (read (take i s) :: Int) 'd' ++ auxDescomprimeMapa t
                          | otherwise = separaMapa (i+1) s t

{-| Função que descomprime a string numa lista de Pecas

Função que transforma:

 * 'v' em Vazia
 * 'd' em Bloco Destrutivel
 * 'i' em Bloco Indestrutivel
-}
descomprimeMapa :: String -> [Peca]
descomprimeMapa "" = []
descomprimeMapa (h:t) | h == 'v' = Vazia : (descomprimeMapa t)
                      | h == 'd' = Bloco Destrutivel : (descomprimeMapa t)
                      | otherwise = Bloco Indestrutivel : (descomprimeMapa t)

{- | Função que acrescenta a borda retirada na compresão do mapa

Acrescenta ao mapa já com dimenções as colunas/linhas retiradas na compressão. Para isso usa diversas funções auxiliares.

 * 'acrescenta1Linha' e 'acrescentaUltLinha' --^ baseadas no múmero de colunas do mapa
 * 'acrescenta1Coluna' e 'acrescentaUltColuna'
 
Todo este processo é o inverso ao criado na função 'removeBorda'
-}
acrescentaBorda :: Int -> Mapa -> Mapa
acrescentaBorda c m = acrescentaUltColuna (acrescenta1Coluna (acrescentaUltLinha c (acrescenta1Linha c m)))

-- | Função que acrescenta a primeira linha ao mapa descomprimido
acrescenta1Linha :: Int -> Mapa -> Mapa
acrescenta1Linha c m = replicate c (Bloco Indestrutivel) : m 

-- | Função que acrescenta a última coluna ao mapa descomprimido
acrescenta1Coluna :: Mapa -> Mapa
acrescenta1Coluna m = map (acrescenta1Elem) m
    where
    acrescenta1Elem :: [Peca] -> [Peca]
    acrescenta1Elem l = (Bloco Indestrutivel) : l

-- | Função que acrescenta a ultima linha ao mapa descomprimido
acrescentaUltLinha :: Int -> Mapa -> Mapa
acrescentaUltLinha c m = inverteMatrizV (replicate c (Bloco Indestrutivel) : (inverteMatrizV m)) 

-- | Função que acrescenta a ultima coluna ao mapa descomprimido
acrescentaUltColuna :: Mapa -> Mapa
acrescentaUltColuna m = map (acrescentaUltElem) m
    where
    acrescentaUltElem :: [Peca] -> [Peca]
    acrescentaUltElem l = reverse (Bloco Indestrutivel : (reverse l))

