{- | Este módulo define funções comuns da Tarefa 6 do trabalho prático.

__Introdução__

Esta tarefa do trabalho prático tinha como objetivo criar um jogador automático (bot) que ao analisar o estado do jogo atual decidia a jogada a implementar. 

A analise do estado do jogo e a jogada tomada foi feita de forma a que o bot eliminasse o maior número de coisas, ou seja, vidas dos jogadores oponentes e paredes destrutíveis, uma vez que os torneios implementados pelos professores eram baseados em pontos conseguidos atraves dessa mesma eliminação.

O resultado obtido foi positivo, já que o bot consegue movimentar-se por qualquer mapa e em certos casos ir ao encontro de locais que possuam mais paredes destrutíveis e jogadores para eliminar.

__Objetivos / Desenvolvimento__

Apartir do título /Funções principais da Tarefa 6/ encontram-se as funções criadas e utilizadas como forma de implementar o jogo automático a um respetivo bot seguidas da sua análise e explicação.

__Discução/Conclusão__

Após a realização da Tarefa6 conseguiu-se obter um bot que se movimenta num mapa sem quaisquer limitações, que decide a direção a tomar de acordo com os locais que possuam mais elementos para destruir (jogadores/paredes destrutíveis), que tome a decisão de que 'Arma' usar dependendo do 'Estado' do jogo e que ainda consiga evitar ser atingido pelos disparos. 
-}

module Bot where

import DataStruct
import Functions
import MapEditor
import Data.List 

-- * Funções principais da Tarefa 6.

{- | Define um ro'bot' capaz de jogar autonomamente o jogo.

Esta função inicial é a principal da tarefa e tem como objetivo encontrar e verificar os parametros do jogador que se será utilizado como bot, ou seja que jogará como automático.
Para encontar esse jogador utilizou-se uma função da 'Tarefa0_2018li1g159.hs' - 'encontraIndiceLista' .
Verifica-se, de seguida, se este jogador possui vidas. Se não possuir o jogador não realiza nenhum movimento - Nothing. Se possuir avança para a análise do estado do jogo, neste caso para a verificação de disparos no mapa atraves da função 'verificaDisparos'.
-}
bot :: Int          -- ^ O identificador do 'Jogador' associado ao ro'bot'.
    -> Estado       -- ^ O 'Estado' para o qual o ro'bot' deve tomar uma decisão.
    -> Jogada -- ^ Uma possível 'Jogada' a efetuar pelo ro'bot'.
bot n (Estado m je de) | vj == 0 = None
                       | otherwise = verificaDisparos (Estado m je de) (Jogador pj dj vj lj cj a) n de
                       where (Jogador pj dj vj lj cj a) = encontraIndiceLista n je

-- ** Função para a verificação dos disparos

{- | Verifica a existencia de disparos no estado e a jogada a implementar em cada caso
 
Para cada um dos disparos utilizou-se funções auxiliares distintas.
 
Para o disparo canhao a análise foi seguindo esta ordem.

 * Quando a 'contaCanhao'  e a 'contaCanhaoN' forem ambas maior ou igual a 1 ou seja quando os canhoes estiverem constantemente a lançar canhoes um contra o outro o bot, lança um laser para eliminar as filas de canhoes e tirar vidas ao outro jogador.
 * Se não houver nenhuma fila de canhoes verifica-se se o canhao encontrado na lista dos disparos está dirijido para o bot atraves da função 'auxVerificaDisp'.
 * Se tiver dirijido para o bot então verifica-se a jogada a implementar no 'auxCanhao'. 

Para disparo choque a análise foi seguindo esta ordem.

 * Verifica-se se o jogador que lançou o bot foi o mesmo que o bot.
 * Se não foi o mesmo então verifica-se a jogada a implementar no 'auxChoque'. 

Para disparo laser a análise foi seguindo esta ordem.

 * Verifica se o laser encontrado na lista dos disparos está dirijido para o bot atraves da função 'auxVerificaDisp'.
 * Se tiver dirijido para o bot então verifica-se a jogada a implementar no 'auxLaser'.

Quando já não houver disparos para verificar, avança-se para a verificação dos jogadores através da função 'verificaJogadores'.
-}
verificaDisparos :: Estado -> Jogador -> Int -> [Disparo] -> Jogada
verificaDisparos (Estado m je []) jogador n de = verificaJogadores (Estado m je de) jogador je
verificaDisparos (Estado m je (h:t)) j@(Jogador (l,c) dj vj lj _ _) n de = case h of
 (DisparoCanhao jd pd dd) -> if x >= 1 && y >= 1
                                    then if (lj == 0)
                                          then (Dispara Canhao)
                                          else (Dispara Laser)
                                    else if auxVerificaDisp (l,c) pd dd
                                          then verificaDisparos (Estado m je t) j n de
                                          else  auxCanhao (Estado m je t) j h n de
 (DisparoChoque jd td) -> if jd == n 
                              then verificaDisparos (Estado m je t) j n de
                              else auxChoque (Estado m je t) j h n de
 (DisparoLaser jd pd dd) -> if auxVerificaDisp (l,c) pd dd
                              then verificaDisparos (Estado m je t) j n de
                              else auxLaser (Estado m je t) j h n de
 where y = contaCanhaoN (h:t) n 0
       x = contaCanhao (h:t) dj (l,c) 0

-- *** Função auxiliar para disparo canhao e laser

{- | Verifica se o disparo está em risco de atintir o bot

Atraves das posições do bot, do disparo e da direção deste, mede-se a distancia a que o disparo está do bot e a mesma distancia no tick seguinte.
Se a distancia no tick seguinte for maior que a distancia no tick atual então o disparo está se a afastar e por isso não corre risco de atingir o bot.
-}
auxVerificaDisp :: Posicao -> Posicao -> Direcao -> Bool
auxVerificaDisp (l,c) (l1,c1) dd = distancia2 > distancia1
                                    where distancia1 = (l1-l)^2 + (c1-c)^2
                                          (a,b) = auxMove (l1,c1) dd
                                          distancia2 = (a-l)^2 + (b-c)^2 

-- *** Funções auxiliares para o disparo canhao

{- | Função conta o número de canhoes que estão dirijidos para o tank

Como forma de resolver o problema em que dois bots ficam a dispar um contra o outro sem parar foi criada esta função.
Esta função conta o número de canhoes existentes no estado que estejam na mesma linha ou coluna que o bot, dirijidos para o mesmo e que coloquem o bot em risco de ser atingido.
-} 
contaCanhao :: [Disparo] -> Direcao -> Posicao -> Int -> Int
contaCanhao [] dj (l,c) ls  = ls
contaCanhao (h:t) dj (l,c) ls = case h of
 (DisparoCanhao jd (x,y) dd) -> if (x == l || y == c) && dd == rodaOposto dj && auxVerificaDisp (l,c) (x,y) dd == False
                                    then contaCanhao t dj (l,c) (ls+1)
                                    else contaCanhao t dj (l,c) ls
 otherwise -> contaCanhao t dj (l,c) ls 

{- | Função conta o número de canhoes lançados pelo o bot

Como forma de resolver o mesmo problema da função 'contaCanhao' criou-se esta função que conta o número de canhoes lançados pelo o própro bot.
-}
contaCanhaoN :: [Disparo] -> Int -> Int -> Int
contaCanhaoN [] n ls  = ls
contaCanhaoN (h:t) n ls = case h of
 (DisparoCanhao jd pd dd) -> if n == jd 
                              then contaCanhaoN t n (ls+1)
                              else contaCanhaoN t n ls
 otherwise -> contaCanhaoN t n ls 

{- | Implementa a jogada de acordo com as distacias e a posição do disparo ao bot

Baseando nas posições do disparo e do bot implementam-se jogadas distintas.

Se o disparo estiver na mesma linha ou coluna que o bot.

 * Verifica-se se o bot está também este dirigido para o disparo.

  ** Se sim, então verifica-se que jogada tomar de acordo com a função 'auxCanhaoIndice'.
  ** Se não, movimenta-se o bot de forma a dirigi-lo para o disparo de acordo com a função 'rodaOposto'.

Se o disparo se encontrar numa das bordas do bot de forma a atingi-lo nos cantos então dependerá de cada um dos cantos.

 * Verifica-se se existe parede indestrutivel encostada ao bot no lado de mais facil escape atraves da função 'auxMapa'.

  ** Se sim, então este vai se movimentar pelo o mesmo lado que vem o disparo.
  ** Se não, movimenta-se pelo o lado de mais facil escape.
-}
auxCanhao :: Estado -> Jogador -> Disparo -> Int -> [Disparo] -> Jogada
auxCanhao (Estado m je de) j@(Jogador (l,c) dj _ _ _ _) d@(DisparoCanhao jd (l1,c1) dd) n ld 
 | (l == l1) ||(c == c1) = if (dj == rodaOposto dd)
                              then auxCanhaoIndice (Estado m je de) j d n ld 
                              else (Movimenta (rodaOposto dj))
 | (c1 == c+1) && (dd /= E) = if auxMapa E (l,c) m >= 1
                              then (Movimenta E)
                              else (Movimenta D)
 | (c1 == c-1) && (dd /= D) = if auxMapa D (l,c) m >= 1
                              then (Movimenta D)
                              else (Movimenta E)
 | (l1 == l+1) && (dd /= C) = if auxMapa C (l,c) m >= 1
                              then (Movimenta C)
                              else (Movimenta B)
 | (l1 == l-1) && (dd /= B) = if auxMapa B (l,c) m >= 1
                              then (Movimenta B)
                              else (Movimenta C)
 | otherwise = verificaDisparos (Estado m je de) j n ld

{- | Verifica-se existe uma parede indestrutivel entre o canhao e o bot

Como forma de evitar jogadas desnecessarias criou-se esta função que baseada numa outra função - 'auxMapa' - e na distacia do bot ao disparo, verifica se a parede indestrutivel que está mais próxima do bot está mais perto deste do que o disparo.
Se sim, então avança com a análise dos disparos no mapa. Se não, o bot dispara um canhão como forma de anular o outro disparo.
-}     
auxCanhaoIndice :: Estado -> Jogador -> Disparo -> Int -> [Disparo] -> Jogada
auxCanhaoIndice (Estado m je de) j@(Jogador (l,c) dj _ _ _ _) (DisparoCanhao jd (l1,c1) dd) n ld
 | distanciaDisparo <= (indice^2) = (Dispara Canhao)
 | otherwise = verificaDisparos (Estado m je de) j n ld
 where indice = auxMapa dj (l,c) m
       distanciaDisparo = (l-l1)^2 + (c-c1)^2

-- *** Funções auxiliares do disparo choque

{- | Aplica uma jogada dependo da posição e distancia do jogador ao jogador que lançou o choque

Baseado na mesma ideia do 'auxCanhao' segundo as posições e distancias temos:

Se o bot estiver dentro do choque e posicionado na linhas de fogo do jogador que lançou o choque.

 * Verifica-se se o bot está dirigido para o jogador, para se aproveitar da sua condição de estar impedido de se movimentar e disparar contra o jogador.

  ** Se sim,  implementação da jogada atraves da função do 'auxContaDisparo'.
  ** Se não, movimenta-se o bot para uma direção de forma a este estar dirijido para o jogador.

Se o bot estiver dentro do choque, mas fora das linhas de fogo do jogador, o bot não faz qualquer tipo de jogada - Nothing.

Se o bot estiver fora do choque, então vai evitar entrar dentro dessas linhas de choque.
Atraves do 'auxMovimenta', o bot vai movimentar-se para uma das direções diferentes da aquela a onde se encontra o choque, mais especificamente para aquela que possua mais objetos tem para destruir.
-} 
auxChoque :: Estado -> Jogador -> Disparo -> Int -> [Disparo] -> Jogada
auxChoque (Estado m je de) j@(Jogador (l,c) dj _ _ _ _) (DisparoChoque jd _) n ld 
 | (l == a) && distancia <= 9 =  auxChoqueLC (Estado m je de) j (a,b) n ld 1
 | (l == a+1 || l == a-1) && distancia <= 10 = auxChoqueLC (Estado m je de) j (a,b) n ld 1
 | (c == b) && distancia <= 9 = auxChoqueLC (Estado m je de) j (a,b) n ld 0
 | (c == b+1 || c == b-1) && distancia <= 10 = auxChoqueLC (Estado m je de) j (a,b) n ld 0
 | (l == a+4 || l == a-4) && elem c [b-3..b+3] = auxChoqueLC (Estado m je de) j (a,b) n ld 3
 | (c == b+4 || c == b-4) && elem l [a-3..a+3] = auxChoqueLC (Estado m je de) j (a,b) n ld 2
 | (l == a+2 || l == a-2 || c == b-2 || c == b+2) && distancia == 8 = None
 | (c == b+3 || c == b-3 || l == a-3 || l == a+3) && distancia == 13 = None
 | otherwise = verificaDisparos (Estado m je de) j n ld
 where (Jogador (a,b) dj1 vj1 lj1 cj1 a1) = encontraIndiceLista jd je
       distancia = (l-a)^2 + (c-b)^2

{- | Função criada para tornar o código mais legivél

Análise e explicação da função na 'auxChoque'.
-}
auxChoqueLC ::  Estado -> Jogador -> Posicao -> Int -> [Disparo] -> Int -> Jogada
auxChoqueLC (Estado m je de) j@(Jogador (l,c) dj _ _ _ _) (a,b) n ld i
 | i == 1 = if (c < b) 
            then if dj == D
                  then auxContaDisparo (Estado m je de) j n ld limite
                  else (Movimenta D) 
            else if (dj == E)
                  then auxContaDisparo (Estado m je de) j n ld limite
                  else (Movimenta E)
 | i == 0 = if (l < a)
            then if (dj == B) 
                  then auxContaDisparo (Estado m je de) j n ld limite 
                  else (Movimenta B)
            else if (dj == C)
                  then auxContaDisparo (Estado m je de) j n ld limite
                  else (Movimenta C)
 | i == 2 = if (c < b) 
            then if dj == D
                  then (Movimenta (auxMovimenta ls (l,c) dj m je [] 0))
                  else (Movimenta (auxMovimenta ls (l,c) dj m je [] 1))
            else if dj == E
                  then (Movimenta (auxMovimenta ls1 (l,c) dj m je [] 0))
                  else (Movimenta (auxMovimenta ls1 (l,c) dj m je [] 1))
 | i == 3 = if (l < a) 
            then if dj == B
                  then (Movimenta (auxMovimenta ls2 (l,c) dj m je [] 0))
                  else (Movimenta (auxMovimenta ls2 (l,c) dj m je [] 1))
            else if dj == C
                  then (Movimenta (auxMovimenta ls3 (l,c) dj m je [] 0))
                  else (Movimenta (auxMovimenta ls3 (l,c) dj m je [] 1))
 where limite = auxMapa dj (l,c) m
       ls = [E,C,B]
       ls1 = [D,C,B]
       ls2 = [E,D,C]
       ls3 = [E,D,B]

{- | Verifica a quantidade de objetos entre o bot e o jogador do choque

Atraves da função 'auxConta' verifica-se se existem objetos (paredes destrutiveis e/ou jogadores) entre o bot e o jogador (a contar com este).

 * Se exitir então dispara canhao, retirando vidas ao jogador.
 * Se não existir, quer dizer que há uma parede indestrutivel entre ambos e por isso nao resliza nenhuma jogada - Nothing.
-}        
auxContaDisparo :: Estado -> Jogador -> Int -> [Disparo] -> Int -> Jogada
auxContaDisparo (Estado m je de) j@(Jogador (l,c) dj _ _ _ _) n ld limite = if auxConta dj limite (l,c) m je >= 1
                                                                         then (Dispara Canhao)
                                                                         else None

-- *** Funções auxiliares para o disparo laser

{-| Função que implementa jogada dependendo da posição e direção do laser

Como o laser é o disparo mais dificil de prever e evitar, a análise feita foi a seguinte.

Se o laser estiver numa das linhas de fogo do bot e se a direção do bot for oposta á do laser.
Verifica se existe parede destrutivel entre o bot e o disparo o mesmo que acontece no 'auxCanhaoIndice' atraves da função 'auxLaserIndice'.

Se o laser não estiver nas linhas de fogo ou se a direção do bot não for oposta á do laser, avança com a verificação para o resto dos disparos.
-}
auxLaser :: Estado -> Jogador -> Disparo -> Int -> [Disparo] -> Jogada
auxLaser (Estado m je de) j@(Jogador (l,c) dj vj lj _ _) d@(DisparoLaser jd (l1,c1) dd) n ld
 | (elem l1 [(l-1)..(l+1)] || elem c1 [(c-1)..(c+1)]) && (dj == rodaOposto dd) = auxLaserIndice (Estado m je de) j d n ld
 | otherwise = verificaDisparos (Estado m je de) j n ld

{- | Verifica-se existe uma parede indestrutivel entre o laser e o bot
 
Tem o mesmo objetivo e explicação ao 'auxCanhaoIndice' só que aplicado ao laser.
-}
auxLaserIndice :: Estado -> Jogador -> Disparo -> Int -> [Disparo] -> Jogada
auxLaserIndice (Estado m je de) j@(Jogador (l,c) dj vj lj _ _) (DisparoLaser jd (l1,c1) dd) n ld
 | distanciaDisparo <= (indice^2) && (lj /= 0) = (Dispara Laser) 
 | otherwise = verificaDisparos (Estado m je de) j n ld
 where indice = auxMapa dj (l,c) m
       distanciaDisparo = (l-l1)^2 + (c-c1)^2

-- ** Função para a verificação dos jogadores

{- | Verifica certos parâmetros dos jogadores para obter uma jogada

Nesta função começa-se por percorrer a lista dos jogadores e verificar se o jogador da lista tem vidas e se este está na mesma posição que o bot (se estiver quer dizer que é o bot).
Se não partilhar nenhum destes parâmetros então verifica-se a jogada a ter dada pela função 'auxJogador'.

Quando já não houver jogadores para verificar, avança para a verificação dos jogadores através da função 'verificaMJ'.
-} 
verificaJogadores :: Estado -> Jogador-> [Jogador] -> Jogada
verificaJogadores (Estado m [] de) jogador je = verificaMJ (Estado m je de) jogador
verificaJogadores (Estado m (p@(Jogador (l1,c1) dj1 vj1 _ _ _):t) de) j@(Jogador (l,c) dj vj lj cj _) je 
 | vj1 == 0 = verificaJogadores (Estado m t de) j je
 | l == l1 && c == c1 = verificaJogadores (Estado m t de) j je
 | otherwise = auxJogador (Estado m t de) p j je 

-- *** Funções Axuliares para a verificação dos jogadores

{- | Função que através de distancias e da posição do jogador implementa uma certa jogada

Cada verificação das distancias e da posição varia com a direção do bot, mas em geral resume-se da seguinte forma:

 * Se o jogador estiver numa linha|coluna de fogo com o bot e a distancia a este for menor ou igual a 5 linhas|colunas então a jogada é dada pela função 'auxColunaLinha'.
 * Se o jogador estiver a 2 linhas e a 2 colunas do bot então a jogada é dada por 'auxColunaChoque'.
 * Caso nenhum destes parametros se realize então continua-se a verificação para o resto dos jogadores
 
__Nota:__ As distancias usadas foram definidas como forma de impossibilitar a hipotese para que o bot não fique continuamente a disparar contra um jogador.
-}
auxJogador :: Estado -> Jogador -> Jogador -> [Jogador] -> Jogada
auxJogador (Estado m t de) (Jogador (l1,c1) _ _ _ _ _) j@(Jogador (l,c) C vj lj cj _) je 
 | c1 == c  && l1 < l && (distancia <= 25) = auxColunaLinha (Estado m t de) j je limite
 | (c1 == c+1 || c1 == c-1) && l1 < l && (distancia <= 29) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+2 || l1 == l-2) && (c1 == c+2 || c1 == c-2) = auxColunaChoque (Estado m t de) j je 
 | otherwise = verificaJogadores (Estado m t de) j je
 where distancia = (l1-l)^2 + (c1-c)^2
       limite = auxMapa C (l,c) m
auxJogador (Estado m t de) (Jogador (l1,c1) _ _ _ _ _) j@(Jogador (l,c) B vj lj cj _) je 
 | c1 == c  && l1 > l && (distancia <= 25) = auxColunaLinha (Estado m t de) j je limite
 | (c1 == c+1 || c1 == c-1) && l1 > l && (distancia <= 29) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+2 || l1 == l-2) && (c1 == c+2 || c1 == c-2) = auxColunaChoque (Estado m t de) j je 
 | otherwise = verificaJogadores (Estado m t de) j je
 where distancia = (l1-l)^2 + (c1-c)^2
       limite = auxMapa B (l,c) m
auxJogador (Estado m t de) (Jogador (l1,c1) _ _ _ _ _) j@(Jogador (l,c) D vj lj cj _) je 
 | l1 == l  && c1 > c && (distancia <= 25) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+1 || l1 == l-1) && c1 > c && (distancia <= 29) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+2 || l1 == l-2) && (c1 == c+2 || c1 == c-2) = auxColunaChoque (Estado m t de) j je
 | otherwise = verificaJogadores (Estado m t de) j je
 where distancia = (l1-l)^2 + (c1-c)^2
       limite = auxMapa D (l,c) m
auxJogador (Estado m t de) (Jogador (l1,c1) _ _ _ _ _) j@(Jogador (l,c) E vj lj cj _) je 
 | l1 == l  && c1 < c && (distancia <= 25) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+1 || l1 == l-1) && c1 < c && (distancia <= 29) = auxColunaLinha (Estado m t de) j je limite
 | (l1 == l+2 || l1 == l-2) && (c1 == c+2 || c1 == c-2) = auxColunaChoque (Estado m t de) j je    
 | otherwise = verificaJogadores (Estado m t de) j je
 where distancia = (l1-l)^2 + (c1-c)^2
       limite = auxMapa E (l,c) m

{- | Função que analisa o mapa e verifica se o bot encontra-se numa posição que possa atingir o jogador

Atraves da função 'auxConta' que analisa se existe algo entre o bot e o jogador temos que:

 * Se houver 6 ou mais objetos entre o bot e o jogador nas 2 linhas/colunas que o bot ocupa então dispara laser.
 * Se houver entre 1 a 5 objetos dispara canhao.
 * Se não houver nenhum objeto então significa que existe uma parede entre o bot e o jogador e por isso avança com a verificação para o resto dos jogadores da lista.

__Nota:__ A quantidade de objetos definida, deveu-se ao facto de que em certas alturas é mais necessario a utilização de laser do que canhao.
Contudo noutras ocasiões evita-se gastar um laser quando a quantidade de coisas a eliminar são reduzidas, ou então quando não existe a possibilidade de usar laser.
-}
auxColunaLinha :: Estado -> Jogador -> [Jogador] -> Int -> Jogada
auxColunaLinha (Estado m t de) j@(Jogador (l,c) dj vj lj cj _) je limite 
 | (auxConta dj limite (l,c) m je) >= 6 = if (lj == 0)
                                          then (Dispara Canhao)
                                          else (Dispara Laser)
 | otherwise = if elem (auxConta dj limite (l,c) m je) [1..5]
                  then (Dispara Canhao)
                  else verificaJogadores (Estado m t de) j je

{- | Função que determina o uso de choque

Nesta função analisa-se o parametro de se puder ou não usar o disparo choque. Sendo que este só é usado quando os jogadores oponentes encontram-se a 2 linhas e 2 colunas do bot.

 * Quando o a quantidade do choques existentes no bot for diferente de 0 então este lança um choque.
 * Se não avança com a verificação para o resto dos jogadores da lista.
-}
auxColunaChoque :: Estado -> Jogador -> [Jogador] -> Jogada
auxColunaChoque (Estado m t de) j@(Jogador (l,c) dj vj lj cj _) je 
 | cj == 0 = verificaJogadores (Estado m t de) j je
 | otherwise = (Dispara Choque)

-- ** Função para a verificação do mapa

{- | Função que verifica o mapa e implementa uma jogada

Após a verificação dos disparos e do jogadores, se o bot ainda não realizou nenhuma jogada significa que não existe nenhum disparo em risco de o atingir nem nenhum jogador que valhe disparar contra.
Sendo assim o bot tem como solução movimentar-se pelo mapa.

Nesta função a implementação da jogada do bot depende da direção que este se encontra.

 * Se a direção for baixo ou direita então a implementação da jogada é dada pela função 'auxVerifica2'
 * Caso contrário é dada por 'auxVerifica1'

__Nota:__ A posição do bot em relação á posição mapa é dada pelo bloco em cima á esquerda dos 4 blocos que um bot/tank ocupam. 
Por isso quando se quer verificar se na direção do bot existe peças vazias, dependerá da direção e posição deste.

 * Quando a direção é baixo ou direita então vai-se verificar se existem peças vazias, 2 posições á frente seguindo a direção.
 * Quando a direção é cima ou esquerda então vai-se verificar se existem peças vazias, 1 posição á frente seguindo a direção.    
-}
verificaMJ :: Estado -> Jogador -> Jogada
verificaMJ (Estado m je de) j@(Jogador pj dj vj lj cj _) | dj == B || dj == D = auxVerifica2 (Estado m je de) j
                                                       | otherwise = auxVerifica1 (Estado m je de) j

-- *** Funções auxiliares na verificação do mapa

{- | Verifica se existem paredes destrutiveis/indestrutiveis ou peças vazias na posição para onde o bot se movimentará

Nesta função verifica-se o que é que se encontra no mapa na posição dos dois blocos a frente do bot:

 * Se ambos os dois blocos forem vazios então o bot movimenta-se segundo a direção dada pela função 'auxMovimenta'.
 * Se um dos blocos for indestrutivel então o bot movimenta-se segundo a direção dada pela função 'auxMovimenta'. É de notar que não se pode movimentar na direção atual pois existem paredes indestrutiveis a bloquear caminho. Por isso as melhores direções a tomar seriam as direções laterias á direção atual ou quanto muito a direção oposta á atual.
 * Caso contrario então vai se verificar tal como aconteceu na função 'auxColunaLinha' quantos objetos existem nessa direção que se consigam eliminar atraves da função 'auxConta'.

  ** Se o número de objetos for maior que 6 entao dispara-se laser.
  ** Se número de objetos estiver entre 1 a 5 então dispara-se canhão.
  ** Se não houver nada para eliminar então este movimenta-se com a direção dada pelo 'auxMovimenta'.
-}                                                     
auxVerifica2 :: Estado -> Jogador -> Jogada
auxVerifica2 (Estado m je de) j@(Jogador pj dj vj lj cj _)
 | (encontraPosicaoMatriz (l,c) m == Bloco Agua && encontraPosicaoMatriz (l1,c1) m == Bloco Agua) = (Movimenta x) 
 | (encontraPosicaoMatriz (l,c) m == Vazia || encontraPosicaoMatriz (l,c) m == Bloco Arbusto || encontraPosicaoMatriz (l,c) m == Bloco Agua) && (encontraPosicaoMatriz (l1,c1) m == Vazia || (encontraPosicaoMatriz (l1,c1) m == Bloco Arbusto || encontraPosicaoMatriz (l1,c1) m == Bloco Agua)) = (Movimenta x)
 | (encontraPosicaoMatriz (l,c) m == Bloco Indestrutivel) || (encontraPosicaoMatriz (l1,c1) m == Bloco Indestrutivel) = (Movimenta y)
 | otherwise = if (auxConta dj limite pj m je) >= 6 
                  then if (lj == 0)
                        then (Dispara Canhao)
                        else (Dispara Laser)
                  else if elem (auxConta dj limite pj m je) [1..5]
                        then (Dispara Canhao)
                        else (Movimenta x)
 where (l,c) = (auxMove (auxMove pj dj) dj)
       (l1,c1) = if dj == B then (l,c+1) else (l+1,c)
       limite = auxMapa dj pj m
       y = auxMovimenta ld pj dj m je [] 0
       x = auxMovimenta ld pj dj m je [] 1
       ld = [D,E,B,C]
 
{- | Verifica se existem paredes destrutiveis/indestrutiveis ou peças vazias na posição para onde o bot se movimentará

Esta função tem os mesmo objetivos que a 'auxVerifica2', a única diferença são as posições verificadas no mapa segundo aquilo que já se tinha sido expresso na nota da função 'verificaMJ'.
Com a criação destas 2 funções distintas reduziu-se tamanho do código e tornou-se este mais legível.
-}       
auxVerifica1 :: Estado -> Jogador -> Jogada
auxVerifica1 (Estado m je de) j@(Jogador pj dj vj lj cj _)
 | (encontraPosicaoMatriz (l,c) m == Bloco Agua && encontraPosicaoMatriz (l1,c1) m == Bloco Agua) = (Movimenta x)  
 | (encontraPosicaoMatriz (l,c) m == Vazia || (encontraPosicaoMatriz (l,c) m == Bloco Arbusto || encontraPosicaoMatriz (l,c) m == Bloco Agua)) && (encontraPosicaoMatriz (l1,c1) m == Vazia || (encontraPosicaoMatriz (l1,c1) m == Bloco Arbusto || encontraPosicaoMatriz (l1,c1) m == Bloco Agua)) = (Movimenta x)
 | (encontraPosicaoMatriz (l,c) m == Bloco Indestrutivel) || (encontraPosicaoMatriz (l1,c1) m == Bloco Indestrutivel) = (Movimenta y)
 | otherwise = if (auxConta dj limite pj m je) >= 6 
                  then if (lj == 0)
                        then (Dispara Canhao)
                        else (Dispara Laser)
                  else if elem (auxConta dj limite pj m je) [1..5]
                        then (Dispara Canhao)
                        else (Movimenta x)
 where (l,c) = auxMove pj dj
       (l1,c1) = if dj == C then (l,c+1) else (l+1,c)
       limite = auxMapa dj pj m
       y = auxMovimenta ld pj dj m je [] 0
       x = auxMovimenta ld pj dj m je [] 1
       ld = [D,E,B,C]

{- | Função que determina a posição relativa da parede indestrutivel mais próxima do bot

Esta função determina um indice relativo da posição da parede mais próxima do bot dependendo da direção e posição deste.

 === Exemplo:
 @ 
   Se o indice obtido atraves de um direção específica for 0 então quer dizer que nessa  direção o bot está encostado a uma parede indestrutivel.
   Se o indice obtido for 5 quer dizer que a parede indestrutivel está a 6 linhas/colunas (dependendo da direção) do bot.
 @
 
Esse indice é encontrado atraves de 2 funções.

 * Se a direção for horizontal (direita, esquerda) utiliza-se a função 'encontraIndiceLista' da linha que está á frente do bot no mapa. Posteriormente encontra-se através da função 'encontraBI' a parede indestrutivel mais proxima do bot.
 * Caso contrário utiliza-se a função 'encontraColuna' da colunaá frente do bot no mapa

__Nota:__ Não só se encontra a linha/coluna no mapa referente á posição do bot como também á do bloco adjacente do mapa.
Ambos os indices (indice do blocos adjacentes e do bloco do bot) são comparados para o mais próximo do bot.  
-}
auxMapa :: Direcao -> Posicao -> Mapa -> Int
auxMapa dj (l,c) m 
 | dj == D = if indiceD <= indiceD1 
             then indiceD
             else indiceD1
 | dj == E = if indiceE <= indiceE1
             then indiceE 
             else indiceE1 
 | dj == C = if indiceC <= indiceC1
             then indiceC 
             else indiceC1 
 | dj == B = if indiceB <= indiceB1
             then indiceB 
             else indiceB1
 where indiceD = encontraBI (drop (c+2) (encontraIndiceLista l m)) 0
       indiceD1 = encontraBI (drop (c+2) (encontraIndiceLista (l+1) m)) 0
       indiceE = encontraBI (reverse (take c (encontraIndiceLista l m))) 0
       indiceE1 = encontraBI (reverse (take c (encontraIndiceLista (l+1) m))) 0
       indiceB = encontraBI (drop (l+2) (encontraColuna c m)) 0
       indiceB1 = encontraBI (drop (l+2) (encontraColuna (c+1) m)) 0
       indiceC = encontraBI (reverse (take l (encontraColuna c m))) 0
       indiceC1 = encontraBI (reverse (take l (encontraColuna (c+1) m))) 0  

-- | Encontra numa lista a primeira parede indestrutivel
encontraBI :: [Peca] -> Int -> Int
encontraBI [] n = n
encontraBI (h:t) n = case h of
                        Bloco Indestrutivel -> n
                        otherwise -> encontraBI t (n+1)

-- | Encontra a coluna com um determinado número no mapa
encontraColuna :: Int -> Mapa -> [Peca]
encontraColuna c [] = []
encontraColuna c ((h:t):hs) = [encontraIndiceLista c (h:t)] ++ encontraColuna c hs

{- | Função que conta o número de objetos que sejam possiveis eliminar (jogadores e destrutiveis) entre determinadas variaveis de limite

Esta função utiliza um outra função já analisada - 'auxMapa' - que contribui uma das variaveis de limite para esta função.
Esta função soma o número de paredes destrutiveis com o número de jogadores.

 * A contagem das paredes destrutiveis é feita atraves da função 'contaDestrutiveis' que para além de contar as destrutiveis na linha/coluna do bot, conta tambem na linha/coluna adjacente mesma ideia usada da função 'auxMapa' só que em vez de determinar um indice conta o número de destrutiveis.
 * A contagem dos jogadores é feita atraves da função 'contajogadores' que utiliza o indice obtido no 'auxMapa' e a posição do bot como forma de limitar a posição dos jogadores para que estes se encontrem nas linhas/colunas de fogo do bot e á frente deste.
-}
auxConta :: Direcao -> Int -> Posicao -> Mapa -> [Jogador] -> Int
auxConta D max (l,c) m je = blocosDL + blocosDL1 + jogadores
                              where blocosDL = contaDestrutiveis (take max (drop (c+2) (encontraIndiceLista l m)))
                                    blocosDL1 = contaDestrutiveis (take max (drop (c+2) (encontraIndiceLista (l+1) m)))
                                    jogadores = contaJogadores je (c+1) (max+c) (l-1) (l+1)
auxConta E min (l,c) m je = blocosCDL + blocosCDL1 + jogadores
                              where blocosCDL = contaDestrutiveis (take min (reverse (take c (encontraIndiceLista l m))))
                                    blocosCDL1 = contaDestrutiveis (take min (reverse (take c (encontraIndiceLista (l+1) m))))
                                    jogadores = contaJogadores je (c-(min+1)) (c-1) (l-1) (l+1)
auxConta B max (l,c) m je = blocosD + blocosD1 + jogadores 
                              where blocosD = contaDestrutiveis (take max (drop (l+2) (encontraColuna c m)))
                                    blocosD1 = contaDestrutiveis (take max (drop (l+2) (encontraColuna (c+1) m)))
                                    jogadores = contaJogadores je  (c-1) (c+1) (l+1) (max+l)
auxConta C min (l,c) m je = blocosCD + blocosCD1 + jogadores 
                              where blocosCD = contaDestrutiveis (take min (reverse (take l (encontraColuna c m))))
                                    blocosCD1 = contaDestrutiveis (take min (reverse (take l (encontraColuna (c+1) m))))
                                    jogadores = contaJogadores je (c-1) (c+1) (l-(min+1)) (l-1) 

{- | Função que conta o número de paredes destrutiveis numa determinada linha/coluna do mapa

Sempre que encontra uma parede indestrutivel a contagem acaba com a soma de 0 á contagem existente.
-}                                    
contaDestrutiveis :: [Peca] -> Int
contaDestrutiveis [] = 0 
contaDestrutiveis (h:t) = case h of
                              Bloco TNT -> 1 + contaDestrutiveis t
                              Bloco Destrutivel -> 1 + contaDestrutiveis t
                              Bloco Indestrutivel -> 0
                              otherwise -> contaDestrutiveis t

{- | Função que conta o número de jogadores existentes em determinadas posições

O primeiro parâmetro a ser verificado é se o jogador possui vidas. Se sim verifica-se se a posição deste encontra-se dentro dos limites determinados.
-}
contaJogadores :: [Jogador] -> Int -> Int -> Int -> Int -> Int
contaJogadores [] _ _ _ _ = 0
contaJogadores ((Jogador (x,y) dj vj _ _ _):t) cmin cmax lmin lmax 
 | vj == 0 = contaJogadores t cmin cmax lmin lmax 
 | otherwise = if elem y [cmin..cmax] && elem x [lmin..lmax]
               then 1 + contaJogadores t cmin cmax lmin lmax
               else contaJogadores t cmin cmax lmin lmax 

{- | Função que determina a direção que o bot devia seguir

Esta função recebe uma lista de direções e vai determinar o que cada uma dessas direções possui em termos de elementos para destruir atraves da função 'auxConta'. Aquela que possuir mais elementos é a direção que o bot vai tomar atraves da função 'auxDirecao'.
Se as direções não tiverem nada para destruir, a direção fica determinada pelo indicador (n) que pode ser 1 ou 0.

 * Se n == 1 então a direção a tomar é a direção atual do bot.
 * Se n == 0 então a direção a tomar é uma das direções laterias á atual e aquela que tem mais caminho por onde movimentar. Se ambas não tiverem caminho o bot avança para a posição oposta á atual.
 
__Nota:__ A determinação do indicador fica ao cargo de cada uma das funções que utilizam esta com auxiliar.
-}               
auxMovimenta :: [Direcao] -> Posicao -> Direcao -> Mapa -> [Jogador] -> [(Direcao, Int)] -> Int -> Direcao
auxMovimenta [] pj dj m je [] n | n == 1 = dj 
                                | otherwise = if di == 0 && di1 == 0
                                              then (rodaOposto dj)
                                              else if di >= di1
                                                   then d
                                                   else d1
                                where d = rodaTank dj
                                      d1 = rodaTank (rodaOposto dj)
                                      di = auxMapa d pj m
                                      di1 = auxMapa d1 pj m
auxMovimenta [] pj dj m je l n = auxDirecao l
auxMovimenta (h:t) pj dj m je l n 
 | h == D = if (d == 0)
            then auxMovimenta t pj dj m je l n
            else auxMovimenta t pj dj m je ((D,d):l) n
 | h == B = if (b == 0)
            then auxMovimenta t pj dj m je l n
            else auxMovimenta t pj dj m je ((B,b):l) n
 | h == E = if (e == 0)
            then auxMovimenta t pj dj m je l n
            else auxMovimenta t pj dj m je ((E,e):l) n
 | h == C = if (c == 0)
            then auxMovimenta t pj dj m je l n
            else auxMovimenta t pj dj m je ((C,c):l) n
 where d = auxConta D (auxMapa D pj m) pj m je
       b = auxConta B (auxMapa B pj m) pj m je
       e = auxConta E (auxMapa E pj m) pj m je
       c = auxConta C (auxMapa C pj m) pj m je

-- | Função que avalia qual das direções tem uma contagem de objetos a eliminar maior, devolvendo essa direção
auxDirecao :: [(Direcao, Int)] -> Direcao
auxDirecao ((d,i):[]) = d
auxDirecao ((d,i):(dj,n):t) | i >= n = auxDirecao ((d,i):t)
                            | otherwise = auxDirecao ((dj,n):t)

-- ** Funções Extras

-- | Função que muda a direção (roda o bot) pelo lado contrário aos ponteiros do relágio
rodaTank :: Direcao -> Direcao
rodaTank B = D
rodaTank D = C
rodaTank C = E
rodaTank E = B

-- | Função de muda a direção para a direção oposta
rodaOposto :: Direcao -> Direcao
rodaOposto B = C
rodaOposto D = E
rodaOposto E = D
rodaOposto C = B

-- *** Funções utilizadas para testar código no terminal

{- | Função que desenha mapa

Função também utilizada na 'Tarefa5_2018li1g159.hs'
-}
-- | Função que dá um mapa                
