{- | Este módulo define funções comuns do ModoZombie do trabalho prático.

O ModoZombie funciona por rondas e só está previsto para 2 jogadores manuais.

Existem múltiplos zombies que precorrem o mapa atravesando paredes a uma determinada velocidade.
Á medida que as rondas vão aumentanto o número de zombies também aumenta.
-}
module Zombies where

import DataStruct
import Functions
import MapEditor
import Physics1
import Physics2


repoeFacadas :: Estado -> Estado
repoeFacadas (Estado m ((Jogador pj0 dj0 vj0 lj0 cj0 Strike):(Jogador pj1 dj1 vj1 lj1 cj1 Strike):t) ld) = (Estado m ((Jogador pj0 dj0 vj0 lj0 cj0 Faca):(Jogador pj1 dj1 vj1 lj1 cj1 Faca):t) ld)
repoeFacadas (Estado m ((Jogador pj0 dj0 vj0 lj0 cj0 Strike):t) ld) = (Estado m ((Jogador pj0 dj0 vj0 lj0 cj0 Faca):t) ld)
repoeFacadas (Estado m (x:(Jogador pj1 dj1 vj1 lj1 cj1 Strike):t) ld) = (Estado m (x:(Jogador pj1 dj1 vj1 lj1 cj1 Faca):t) ld)
repoeFacadas e = e

-- * Função principal do ModoZombie

{- | Função que altera o estado no ModoZombie a cada ronda

Neste função temos :

 * Sempre que os zombies deixem de existir então há alterção na quantidade de vida dos jogadores e há mudança da ronda do jogo.
 * Sempre que ainda haja jogadores no estado então verifica-se se os jogadores estão em risco de serem atingidos pelos zombies.
-}
tickZombies :: Ronda -- ^ A ronda a que diz respeito o jogo
            -> Int -- ^ indicador de alteração de velocidade dos zombies
            -> Estado -- ^ O 'Estado' para o qual o ro'bot' deve tomar uma decisão.
            -> Estado -- ^ Uma possível 'Jogada' a efetuar pelo ro'bot'.
tickZombies rz i e@(Estado m (j1:j2:j3:j4@(Jogador _ _ jg0 _ _ _):j5@(Jogador _ _ jg1 _ _ _):[]) ld) = (Estado m ((aumentaVidas j1 jg0):(aumentaVidas j2 jg1):j3:j4:j5:(mudaRonda rz)) ld)
tickZombies rz i e@(Estado m (j1:j2:j3:j4:j5:z) ld) = if mod i velocidadeZombie /= 0 then aplicaBadges (tick (Estado m ((mataJogadores j1 z):(mataJogadores j2 z):(atualizaPontuacao j3 z ld):j4:j5:(atualizaZombie z ld)) (atualizaDisparosZ z ld))) else aplicaBadges (tickBot i (tick e))

{-
tickZombies rz i (Estado m (p0@(Jogador a b 0 c d a0):x:y:(Jogador e f g h 1 a1):t) ld) = (Estado m ((Jogador a b 25 c d a0):x:y:(Jogador e f 0 0 0 Pistol):t) ld)
tickZombies rz i (Estado m (x:p1@(Jogador a b 0 c d a0):y:z:(Jogador e f g h 1 a1):t) ld) = (Estado m (x:(Jogador a b 25 c d a0):y:z:(Jogador e f 0 0 0 Pistol):t) ld)
tickZombies rz i (Estado m (p0@(Jogador a b 0 c d a0):x:y:(Jogador e f g h 0 a1):t) ld) = (Estado m ((Jogador a b 0 c d a0):x:y:(Jogador e f 0 0 0 Pistol):t) ld)
tickZombies rz i (Estado m (x:p1@(Jogador a b 0 c d a0):y:z:(Jogador e f g h 0 a1):t) ld) = (Estado m (x:(Jogador a b 0 c d a0):y:z:(Jogador e f 0 0 0 Pistol):t) ld)
tickZombies rz i (Estado m (p0@(Jogador a b c 0 d a0):x:y:(Jogador e f g 1 h a1):t) ld) = (Estado m ((carregar p0):x:y:(Jogador e f g 1 h a1):t) ld)
tickZombies rz i (Estado m (x:p1@(Jogador a b c 0 d a0):y:z:(Jogador e f g 1 h a1):t) ld) = (Estado m (x:(carregar p1):y:z:(Jogador e f g 1 h a1):t) ld)
-}
-- ** Funções auxiliares tickZombies

aplicaBadges :: Estado -> Estado
aplicaBadges (Estado m (p0@(Jogador a b c 0 d a0):x:y:(Jogador e f g 1 h a1):t) ld) = (Estado m ((carregar a0 p0):x:y:(Jogador e f g 1 h a1):t) ld)
aplicaBadges (Estado m (x:p1@(Jogador a b c 0 d a0):y:z:(Jogador e f g 1 h a1):t) ld) = (Estado m (x:(carregar a1 p1):y:z:(Jogador e f g 1 h a1):t) ld)
aplicaBadges (Estado m (p0@(Jogador a b 0 c d a0):x:(Jogador pj2 dj2 vj2 lj2 cj2 aj2):(Jogador e f g h 1 a1):t) ld) = (Estado m ((Jogador a b 25 c d a0):x:(Jogador pj2 dj2 0 lj2 cj2 aj2):(Jogador e f 0 0 0 Pistol):t) ld)
aplicaBadges (Estado m (x:p1@(Jogador a b 0 c d a0):(Jogador pj2 dj2 vj2 lj2 cj2 aj2):z:(Jogador e f g h 1 a1):t) ld) = (Estado m (x:(Jogador a b 25 c d a0):(Jogador pj2 dj2 vj2 lj2 cj2 Pistol):z:(Jogador e f 0 0 0 Pistol):t) ld)
aplicaBadges (Estado m (p0@(Jogador a b 0 c d a0):x:(Jogador pj2 dj2 vj2 lj2 cj2 aj2):(Jogador e f g h 0 a1):t) ld) = (Estado m ((Jogador a b 0 c d a0):x:(Jogador pj2 dj2 0 lj2 cj2 aj2):(Jogador e f 0 0 0 Pistol):t) ld)
aplicaBadges (Estado m (x:p1@(Jogador a b 0 c d a0):(Jogador pj2 dj2 vj2 lj2 cj2 aj2):z:(Jogador e f g h 0 a1):t) ld) = (Estado m (x:(Jogador a b 0 c d a0):(Jogador pj2 dj2 vj2 lj2 cj2 Pistol):z:(Jogador e f 0 0 0 Pistol):t) ld)
aplicaBadges e = e

-- | Velocidade de movimento do Zombie
velocidadeZombie :: Int
velocidadeZombie = 20

-- | Adiciona vidas ao jogador 
--
-- Quando este tem mais que 95 vidas entao o jogador passa a ter 100 vidas.
-- Se o jogador tiver menos de 95 as vidas passam a mais 5 do que aquelas que já tinha.
aumentaVidas :: Jogador -> Int -> Jogador
aumentaVidas (Jogador pj dj vj l c a) 0 = if vj > 95 then (Jogador pj dj 100 l c a) else (Jogador pj dj (vj+5) l c a)
aumentaVidas (Jogador pj dj vj l c a) 1 = if vj > 190 then (Jogador pj dj 100 l c a) else (Jogador pj dj (vj+10) l c a)                                 

{- | Muda de ronda do jogo

Sempre que á mudança de ronda os zombies passam a ser cada vez mais. Essa criação é dada por 'criaZombies1' 'criaZombies2'.
-}
mudaRonda :: Ronda -> [Jogador]
mudaRonda 0 = criaZombies1 1 16 2 ++ criaZombies2 16 1 2 ++ criaZombies2 (-2) 1 2 ++ criaZombies1 (-2) 16 2   
mudaRonda 1 = criaZombies1 1 16 5 ++ criaZombies2 16 1 5 ++ criaZombies2 (-2) 1 5 ++ criaZombies1 (-2) 16 5
mudaRonda 2 = criaZombies1 1 16 5 ++ criaZombies2 16 1 5 ++ criaZombies2 (-2) 1 5 ++ criaZombies1 (-2) 16 5 ++  criaZombies1 1 18 5 ++ criaZombies2 18 1 5 ++ criaZombies2 (-4) 1 5 ++ criaZombies1 (-4) 16 5
mudaRonda 3 = criaZombies1 1 49 10 ++ criaZombies1 1 (-2) 10 ++ criaZombies2 (-2) 1 10 ++ criaZombies2 49 1 10   
mudaRonda 4 = criaZombies1 1 49 20 ++ criaZombies1 1 (-2) 20 ++ criaZombies2 (-2) 1 20 ++ criaZombies2 49 1 20
mudaRonda 5 = criaZombies1 1 49 30 ++ criaZombies1 1 (-2) 30 ++ criaZombies2 (-2) 1 30 ++ criaZombies2 49 1 30  
mudaRonda 6 = criaZombies1 1 49 40 ++ criaZombies1 1 (-2) 40 ++ criaZombies2 (-2) 1 40 ++ criaZombies2 49 1 40
mudaRonda 7 = criaZombies1 1 49 25 ++ criaZombies1 1 (-2) 25 ++ criaZombies2 (-2) 1 25 ++ criaZombies2 49 1 25 ++ criaZombies1 1 53 25 ++ criaZombies1 1 (-5) 25 ++ criaZombies2 (-5) 1 25 ++ criaZombies2 53 1 25
mudaRonda 8 = criaZombies1 1 49 26 ++ criaZombies1 1 (-2) 26 ++ criaZombies2 (-2) 1 26 ++ criaZombies2 49 1 26 ++ criaZombies1 1 53 26 ++ criaZombies1 1 (-5) 26 ++ criaZombies2 (-5) 1 26 ++ criaZombies2 53 1 26
mudaRonda 9 = criaZombies1 1 49 27 ++ criaZombies1 1 (-2) 27 ++ criaZombies2 (-2) 1 27 ++ criaZombies2 49 1 27 ++ criaZombies1 1 53 27 ++ criaZombies1 1 (-5) 27 ++ criaZombies2 (-5) 1 27 ++ criaZombies2 53 1 27
mudaRonda 10 = criaZombies1 1 49 28 ++ criaZombies1 1 (-2) 28 ++ criaZombies2 (-2) 1 25 ++ criaZombies2 49 1 28 ++ criaZombies1 1 53 28 ++ criaZombies1 1 (-5) 28 ++ criaZombies2 (-5) 1 28 ++ criaZombies2 53 1 28
mudaRonda 11 = criaZombies1 1 49 25 ++ criaZombies1 1 (-2) 25 ++ criaZombies2 (-2) 1 25 ++ criaZombies2 49 1 25 ++ criaZombies1 1 53 25 ++ criaZombies1 1 (-5) 25 ++ criaZombies2 (-5) 1 25 ++ criaZombies2 53 1 25 ++ criaZombies1 1 56 25 ++ criaZombies1 1 (-8) 25 ++ criaZombies2 (-8) 1 25 ++ criaZombies2 56 1 25
mudaRonda 12 = criaZombies1 1 49 30 ++ criaZombies1 1 (-2) 30 ++ criaZombies2 (-2) 1 30 ++ criaZombies2 49 1 30 ++ criaZombies1 1 53 30 ++ criaZombies1 1 (-5) 30 ++ criaZombies2 (-5) 1 30 ++ criaZombies2 53 1 30 ++ criaZombies1 1 56 30 ++ criaZombies1 1 (-8) 30 ++ criaZombies2 (-8) 1 30 ++ criaZombies2 56 1 30
mudaRonda i = criaZombies1 1 111 (30 +(i-12)) ++ criaZombies1 1 (-2) (30 +(i-12)) ++ criaZombies2 (-2) 1 (30 +(i-12)) ++ criaZombies2 73 1 (30 +(i-12)) ++ criaZombies1 1 114 (30 +(i-12)) ++ criaZombies1 1 (-5) (30 +(i-12)) ++ criaZombies2 (-5) 1 (30 +(i-12)) ++ criaZombies2 76 1 (30 +(i-12)) ++ criaZombies1 1 117 (30 +(i-12)) ++ criaZombies1 1 (-8) (30 +(i-12)) ++ criaZombies2 (-8) 1 (30 +(i-12)) ++ criaZombies2 79 1 (30 +(i-12))
mudaRonda _ = [(Jogador (50,7) C  1 1 99 Pistol)]

-- | Cria zombies nas linhas
criaZombies1 :: Int -> Int -> Int -> [Jogador]
criaZombies1 l c 0 = []
criaZombies1 l c nz =  (Jogador (l,c) C 1 1 99 Pistol):(criaZombies1 (l+2) c (nz-1))

-- | Cria zombies nas colunas
criaZombies2 :: Int -> Int -> Int -> [Jogador]
criaZombies2 l c 0 = []
criaZombies2 l c nz =  (Jogador (l,c) C 1 1 99 Pistol):(criaZombies2 l (c+2) (nz-1))

{- | Função que atualiza os jogadores quando estes estão proximos dos zombies

Sempre que um zombie se aproxima de um jogador este perde vidas.
Para isso utilizou-se várias funções auxiliares como é o caso da 'matajogadores', 'atualizaPontuacao', 'verificaPosicaoJogador' 
-}
tickBot :: Int -> Estado -> Estado
tickBot i (Estado m (j1:j2:j3:j4:j5:z) ld) = (Estado m ((mataJogadores j1 z):(mataJogadores j2 z):(atualizaPontuacao j3 z ld):j4:j5:(verificaPosicaoJogador i (j1:j2:[]) z ld)) ld)

{- | Função que verifica se o jogador e o zombie estão próximos

Se ambos estiverem proximos então o jogador perde uma vida
Se não matém-se como estava.

__Nota:__ Utilizou-se funções auxiliares como a 'areaImpactoTank' da 'Tarefa5_ticks' e a 'posicoesZombies'.
-}
mataJogadores :: Jogador -> [Jogador] -> Jogador
mataJogadores j [] = j
mataJogadores j@(Jogador _ _ 0 _ _ _) _ = j
mataJogadores j@(Jogador (a,b) dj vj l c a0) z | comparaPosicoes (posicoesZombies z) (areaImpactoTank j) = (Jogador (a,b) dj (vj-1) l c a0)
                                               | otherwise = j

-- | Função que dá as diversas posições dos zombies
posicoesZombies :: [Jogador] -> PosicoesGrelha
posicoesZombies [] = []
posicoesZombies ((Jogador pj _ _ _ _ _):t) = pj:(posicoesZombies t)

{- | Função que faz com que os zombies peresigam os jogadores

Através da verificação tanto da posição do jogador como do zombie e da distancia que os separa ('dis') o zombie vai ao encontro daquele que se encontra mais perto
Esta verificação é dada por funções auxiliares como 'ataca'.

É nesta função também que há uma verificação se existem disparos que atingem um zombie. 
Para isso guarda-se todas as posições dos disparos ('guardaPosicoesCanhao') e a area do zombie ('areaImpactoTank') para posterior comparação 

__Nota:__ Sempre que um jogador não tem vidas então os zombies vão passar sempre a atacar o outro jogador
-}
verificaPosicaoJogador :: Int -> [Jogador] -> [Jogador] -> [Disparo] -> [Jogador]
verificaPosicaoJogador _ _ [] _ = []
verificaPosicaoJogador i lj (z:zs) ld | comparaPosicoes (guardaPosicoesCanhao ld) (areaImpactoTank z) = verificaPosicaoJogador (i+1) lj zs ld 
verificaPosicaoJogador i [p1@(Jogador pj1 _ _ _ _ _),p2@(Jogador pj2 _ 0 _ _ _)] (p3@(Jogador pj3 _ _ _ _ _):t) ld = ataca i p3 p1 : (verificaPosicaoJogador (i+1) (p1:p2:[]) t ld)
verificaPosicaoJogador i [p1@(Jogador pj1 _ 0 _ _ _),p2@(Jogador pj2 _ _ _ _ _)] (p3@(Jogador pj3 _ _ _ _ _):t) ld = ataca i p3 p2 : (verificaPosicaoJogador (i+1) (p1:p2:[]) t ld)    
verificaPosicaoJogador i [p1@(Jogador pj1 _ _ _ _ _),p2@(Jogador pj2 _ _ _ _ _)] (p3@(Jogador pj3 _ _ _ _ _):t) ld = if dist pj1 pj3 >= dist pj2 pj3
                                                                                                               then ataca i p3 p2 : (verificaPosicaoJogador (i+1) (p1:p2:[]) t ld)
                                                                                                               else ataca i p3 p1 : (verificaPosicaoJogador (i+1) (p1:p2:[]) t ld)

-- | Função que verifica as posiçoes dos disparos e as dos zombies e comparar para decidir se estão a atingir os zombies ou não, para eliminar os zombies atingidos do estado
atualizaZombie :: [Jogador] -> [Disparo] -> [Jogador]
atualizaZombie [] _ = []
atualizaZombie ljs [] = ljs
atualizaZombie (z:zs) ld | comparaPosicoes (guardaPosicoesCanhao ld) (areaImpactoTank z) = atualizaZombie zs ld
                         | otherwise = z : (atualizaZombie zs) ld

-- | Função que verifica as posiçoes dos disparos e as dos zombies e comparar para decidir se estão a atingir os zombies ou não, para eliminar os disparos que atingiram zombies ou jogadores do mapa
atualizaDisparosZ :: [Jogador] -> [Disparo] -> [Disparo]
atualizaDisparosZ _ [] = []
atualizaDisparosZ [] ld = ld
atualizaDisparosZ lz (h:t) | comparaPosicoes (guardaPosicoesCanhao [h]) (areaImpactoTanks lz) = atualizaDisparosZ lz t
                           | otherwise = h : (atualizaDisparosZ lz t)

-- | Função que aumenta a pontuação do jogador sempre que um disparo dele atinga um zombie. 
atualizaPontuacao :: Jogador -> [Jogador] -> [Disparo] -> Jogador
atualizaPontuacao j _ [] = j
atualizaPontuacao j@(Jogador pj dj v l c a) lz (d@(DisparoCanhao n _ _):t) | n == 0 && comparaPosicoes (guardaPosicoesCanhao [d]) (areaImpactoTanks lz) = atualizaPontuacao (Jogador pj dj v (l+10) c a) lz t
                                                                         | n == 1 && comparaPosicoes (guardaPosicoesCanhao [d]) (areaImpactoTanks lz) = atualizaPontuacao (Jogador pj dj v l (c+10) a) lz t
                                                                         | otherwise = atualizaPontuacao j lz t

-- | Função que guarda todas posiçoes de impacto de cada um dos zombies 
areaImpactoTanks :: [Jogador] -> PosicoesGrelha
areaImpactoTanks [] = []
areaImpactoTanks (h:t) = areaImpactoTank h ++ areaImpactoTanks t

-- | Função que cacula a distancia entre uas posiçoes bidimencionais
dist :: PosicaoGrelha -> PosicaoGrelha -> Float
dist (x1,y1) (x2,y2) = sqrt(dx^2+dy^2)
    where
    dx = realToFrac (x2-x1)
    dy = realToFrac (y2-y1)

-- | Função que segundo posiçoes relativas entre jogador e zombie decide ou não atacar, ou seja, avançar
ataca :: Int -> Jogador -> Jogador -> Jogador
ataca i (Jogador (a,b) _ _ _ _ _) (Jogador (a2,b2) d v l c a0) | b == b2 = if a == (a2+1) || b == (a2-1) then (Jogador (a,b) d v l c a0)
                                                                                                    else if a < a2 then (Jogador (a+1,b) B v l c a0)
                                                                                                                   else (Jogador (a-1,b) C v l c a0)
                                                               | a == a2 = if b == (b2+1) || b == (b2-1) then (Jogador (a,b) d v l c a0)
                                                                                                  else if b < b2 then (Jogador (a,b+1) D v l c a0)
                                                                                                                 else (Jogador (a,b-1) E v l c a0)                                                         
ataca i (Jogador (a,b) _ _ _ _ _) (Jogador (a2,b2) d v l c a0) | mod i 3 == 0 && a < a2 = (Jogador (a+1,b) B v l c a0)
                                                               | mod i 3 == 0 && otherwise = (Jogador (a-1,b) C v l c a0)
ataca i (Jogador (a,b) _ _ _ _ _) (Jogador (a2,b2) d v l c a0) | b > b2 = (Jogador (a,b-1) E v l c a0)
                                                               | otherwise = (Jogador (a,b+1) D v l c a0)