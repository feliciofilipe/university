-- | Este módulo define funções comuns da Tarefa 2 do trabalho prático.
module Physics1 where

import DataStruct
import Functions
import MapEditor
import Physics2

-- * Funções principais da Tarefa 2.

-- | Efetua uma jogada.
--
-- Em cada jogada pode-se movimentar o tank ou diparar com este.
jogadaZ :: Bool 
        -> Int -- ^ O identificador do 'Jogador' que efetua a jogada.
        -> Jogada -- ^ A 'Jogada' a efetuar.
        -> Estado -- ^ O 'Estado' anterior.
        -> Estado -- ^ O 'Estado' resultante após o jogador efetuar a jogada.      
jogadaZ b n (Movimenta d) (Estado m je de) = (Estado m (atualizaIndiceLista n playerNovo je) de) 
                                               where player = encontraIndiceLista n je
                                                     playerNovo = alteraJogadaZ player d (Estado m je de)
jogadaZ b 0 (Dispara Canhao) (Estado m (j0@(Jogador _ _ _ _ _ Pistol):j1:j2:j3@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m ((removeLaserJ j0):j1:j2:j3:t) (adDisparoZ m j0 de armaZ 0 Canhao))
jogadaZ b 1 (Dispara Canhao) (Estado m (j0:j1@(Jogador _ _ _ _ _ Pistol):j2:j3:j4@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m (j0:(removeLaserJ j1):j2:j3:j4:t) (adDisparoZ m j1 de armaZ 1 Canhao))
jogadaZ b 0 (Dispara Canhao) (Estado m (j0@(Jogador _ _ _ _ _ AK47):j1:j2:j3@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m ((removeLaserJ j0):j1:j2:j3:t) (adDisparoZ m j0 de armaZ 0 Canhao))
jogadaZ b 1 (Dispara Canhao) (Estado m (j0:j1@(Jogador _ _ _ _ _ AK47):j2:j3:j4@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m (j0:(removeLaserJ j1):j2:j3:j4:t) (adDisparoZ m j1 de armaZ 1 Canhao))
jogadaZ b 0 (Dispara Canhao) (Estado m (j0@(Jogador _ _ _ _ _ M8A1):j1:j2:j3@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m ((removeLaserJ j0):j1:j2:j3:t) (adDisparoZ m j0 de armaZ 0 Canhao))
jogadaZ b 1 (Dispara Canhao) (Estado m (j0:j1@(Jogador _ _ _ _ _ M8A1):j2:j3:j4@(Jogador _ _ _ _ _ armaZ):t) de) = (Estado m (j0:(removeLaserJ j1):j2:j3:j4:t) (adDisparoZ m j1 de armaZ 1 Canhao))
jogadaZ b 0 (Carregar) (Estado m (j0@(Jogador _ _ _ _ _ a):t) de) = (Estado m ((carregar a j0):t) de)
jogadaZ b 1 (Carregar) (Estado m (j0:j1@(Jogador _ _ _ _ _ a):t) de) = (Estado m (j0:(carregar a j1):t) de)
jogadaZ b 0 (Comprar) e@(Estado m ((Jogador pj dj v l ch _):t) de) | caraJogador m pj dj (Porta) = comprarPorta 0 e
                                                                   | caraJogador m pj dj (V2) = comprarMunicao 0 e
                                                                   | caraJogador m pj dj (V3) = comprarMedkit b 0 e
                                                                   | caraJogador m pj dj (V1) = comprarSpeedCola 0 e
                                                                   | caraJogador m pj dj (V0) = comprarJuggernog 0 e
                                                                   | caraJogador m pj dj (V4) = comprarSelfRevive 0 e
                                                                   | caraJogador m pj dj (V5) = comprarDoubleTap 0 e
                                                                   | caraJogador m pj dj (V6) = comprarAK47 0 e
                                                                   | caraJogador m pj dj (V7) = comprarM8A1 0 e
                                                                   | otherwise = e
jogadaZ b 1 (Comprar) e@(Estado m (x:(Jogador pj dj v l ch _):t) de) | caraJogador m pj dj (Porta) = comprarPorta 1 e 
                                                                     | caraJogador m pj dj (V0) = comprarJuggernog 1 e
                                                                     | caraJogador m pj dj (V1) = comprarSpeedCola 1 e
                                                                     | caraJogador m pj dj (V2) = comprarMunicao 1 e
                                                                     | caraJogador m pj dj (V3) = comprarMedkit b 1 e
                                                                     | caraJogador m pj dj (V4) = comprarSelfRevive 1 e
                                                                     | caraJogador m pj dj (V5) = comprarDoubleTap 1 e
                                                                     | caraJogador m pj dj (V6) = comprarAK47 1 e
                                                                     | caraJogador m pj dj (V7) = comprarM8A1 1 e
                                                                     | otherwise = e
jogadaZ b n (MudarArma) e = mudarArma n e
jogadaZ b 0 (Facada) e@(Estado m ((Jogador _ _ _ _ _ Faca):t) de) = darFacada 0 e
jogadaZ b 1 (Facada) e@(Estado m (j0:(Jogador _ _ _ _ _ Faca):t) de) = darFacada 1 e
jogadaZ _ _ _ e = e

darFacada :: Int -> Estado -> Estado
darFacada 0 (Estado m ((Jogador pj dj vj lj cj Faca):j1:j2:j3:j4:z) ld) = (Estado m ((Jogador pj dj vj lj cj Strike):j1:j2:j3:j4:(atualizaFacadaZ pj dj z)) ld)
darFacada 1 (Estado m (j0:(Jogador pj dj vj lj cj Faca):j2:j3:j4:z) ld) = (Estado m (j0:(Jogador pj dj vj lj cj Strike):j2:j3:j4:(atualizaFacadaZ pj dj z)) ld)

atualizaFacadaZ :: Posicao -> Direcao -> [Jogador] -> [Jogador]
atualizaFacadaZ _ _ [] = []
atualizaFacadaZ p@(a,b) C (z:zs) = if comparaPosicoes (areaImpactoTank z) [(a-1,b),(a-1,b+1)] then atualizaFacadaZ p C zs else z:(atualizaFacadaZ p C zs)
atualizaFacadaZ p@(a,b) D (z:zs) = if comparaPosicoes (areaImpactoTank z) [(a,b+2),(a+1,b+2)] then atualizaFacadaZ p D zs else z:(atualizaFacadaZ p D zs)
atualizaFacadaZ p@(a,b) B (z:zs) = if comparaPosicoes (areaImpactoTank z) [(a+2,b),(a+2,b+1)] then atualizaFacadaZ p B zs else z:(atualizaFacadaZ p B zs)
atualizaFacadaZ p@(a,b) E (z:zs) = if comparaPosicoes (areaImpactoTank z) [(a,b-1),(a+1,b-1)] then atualizaFacadaZ p E zs else z:(atualizaFacadaZ p E zs) 

mudarArma :: Int -> Estado -> Estado
mudarArma 0 e@(Estado _ ((Jogador _ _ 0 _ _ _):t) _) = e
mudarArma 1 e@(Estado _ (x:(Jogador _ _ 0 _ _ _):t) _) = e
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Pistol):j1:j2@(Jogador _ _ 1 _ _ _):t) ld) = (Estado m ((Jogador pj dj vj lj cj AK47):j1:j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj AK47):j1:j2@(Jogador _ _ 1 _ _ _):t) ld) = (Estado m ((Jogador pj dj vj lj cj Faca):j1:j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Faca):j1:j2@(Jogador _ _ 1 _ _ _):t) ld) = (Estado m ((Jogador pj dj vj lj cj Pistol):j1:j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj Pistol):j2@(Jogador _ _ _ _ _ AK47):t) ld) = (Estado m (j0:(Jogador pj dj vj lj cj AK47):j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj AK47):j2@(Jogador _ _ _ _ _ AK47):t) ld) = (Estado m (j0:(Jogador pj dj vj lj cj Faca):j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj Faca):j2@(Jogador _ _ _ _ _ AK47):t) ld) = (Estado m (j0:(Jogador pj dj vj lj cj Pistol):j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Pistol):j1:j2@(Jogador _ _ 2 _ _ _):t) ld) = (Estado m ((carregar M8A1 (Jogador pj dj vj lj cj M8A1)):j1:j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj M8A1):j1:j2@(Jogador _ _ 2 _ _ _):t) ld) = (Estado m ((Jogador pj dj vj lj cj Faca):j1:j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Faca):j1:j2@(Jogador _ _ 2 _ _ _):t) ld) = (Estado m ((Jogador pj dj vj lj cj Pistol):j1:j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj Pistol):j2@(Jogador _ _ _ _ _ M8A1):t) ld) = (Estado m (j0:(carregar M8A1 (Jogador pj dj vj lj cj M8A1)):j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj M8A1):j2@(Jogador _ _ _ _ _ M8A1):t) ld) = (Estado m (j0:(Jogador pj dj vj lj cj Faca):j2:t) ld)
mudarArma 1 (Estado m (j0:(Jogador pj dj vj lj cj Faca):j2@(Jogador _ _ _ _ _ M8A1):t) ld) = (Estado m (j0:(Jogador pj dj vj lj cj Pistol):j2:t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Pistol):t) ld) = (Estado m ((Jogador pj dj vj lj cj Faca):t) ld)
mudarArma 0 (Estado m ((Jogador pj dj vj lj cj Faca):t) ld) = (Estado m ((Jogador pj dj vj lj cj Pistol):t) ld)
mudarArma 1 (Estado m (x:(Jogador pj dj vj lj cj Pistol):t) ld) = (Estado m (x:(Jogador pj dj vj lj cj Faca):t) ld)
mudarArma 1 (Estado m (x:(Jogador pj dj vj lj cj Faca):t) ld) = (Estado m (x:(Jogador pj dj vj lj cj Pistol):t) ld)

comprarM8A1 :: Int -> Estado -> Estado
comprarM8A1 0 e@(Estado m ((Jogador pj dj v lj cj aj):j1:(Jogador a b g0 pp0 pp1 g1):t) de) | pp0 < 3000 = e
                                                                                            | v == 0 = e
                                                                                            | g0 == 2 = e
                                                                                            | caraJogador m pj dj (V7) = (Estado m ((carregar M8A1 (Jogador pj dj v lj cj M8A1)):j1:(Jogador a b 2 (pp0-3000) pp1 g1):t) de)  
                                                                                            | otherwise = e
comprarM8A1 1 e@(Estado m (j0:(Jogador pj dj v lj cj aj):(Jogador a b g0 pp0 pp1 g1):t) de)  | pp1 < 3000 = e
                                                                                             | v == 0 = e
                                                                                             | g1 == M8A1 = e
                                                                                             | caraJogador m pj dj (V7) = (Estado m (j0:(carregar M8A1 (Jogador pj dj v lj cj M8A1)):(Jogador a b g0 pp0 (pp1-3000) M8A1):t) de)
                                                                                             | otherwise = e

comprarAK47 :: Int -> Estado -> Estado
comprarAK47 0 e@(Estado m ((Jogador pj dj v lj cj aj):j1:(Jogador a b g0 pp0 pp1 g1):t) de) | pp0 < 3000 = e
                                                                                            | v == 0 = e
                                                                                            | g0 == 1 = e
                                                                                            | caraJogador m pj dj (V6) = (Estado m ((Jogador pj dj v lj cj AK47):j1:(Jogador a b 1 (pp0-3000) pp1 g1):t) de)  
                                                                                            | otherwise = e
comprarAK47 1 e@(Estado m (j0:(Jogador pj dj v lj cj aj):(Jogador a b g0 pp0 pp1 g1):t) de)  | pp1 < 3000 = e
                                                                                             | v == 0 = e
                                                                                             | g1 == AK47 = e
                                                                                             | caraJogador m pj dj (V6) = (Estado m (j0:(Jogador pj dj v lj cj AK47):(Jogador a b g0 pp0 (pp1-3000) AK47):t) de)
                                                                                             | otherwise = e


comprarDoubleTap :: Int -> Estado -> Estado
comprarDoubleTap 0 e@(Estado m (j0@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):(Jogador e0 f g h sc dt):t) de) | pp0 < 2000 = e
                                                                                                                         | v == 0 = e
                                                                                                                         | dt == Faca = e
                                                                                                                         | caraJogador m pj dj (V5) = (Estado m (j0:j1:(Jogador a b c (pp0-2000) d a1):(Jogador e0 f g h sc Faca):t) de)  
                                                                                                                         | otherwise = e
comprarDoubleTap 1 e@(Estado m (j0:j1@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):j4:(Jogador e0 f g h sc dt):t) de) | pp1 < 2000 = e
                                                                                                                             | v == 0 = e
                                                                                                                             | dt == Faca = e
                                                                                                                             | caraJogador m pj dj (V5) = (Estado m (j0:j1:(Jogador a b c d (pp1-2000) a1):j4:(Jogador e0 f g h sc Faca):t) de)
                                                                                                                             | otherwise = e

comprarSelfRevive :: Int -> Estado -> Estado
comprarSelfRevive 0 e@(Estado m (j0@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):(Jogador e0 f g h sc a2):t) de) | pp0 < 5000 = e
                                                                                                                          | v == 0 = e
                                                                                                                          | sc == 1 = e
                                                                                                                          | caraJogador m pj dj (V4) = (Estado m (j0:j1:(Jogador a b c (pp0-5000) d a1):(Jogador e0 f g h 1 a2):t) de)  
                                                                                                                          | otherwise = e
comprarSelfRevive 1 e@(Estado m (j0:j1@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):j4:(Jogador e0 f g h sc a2):t) de) | pp1 < 5000 = e
                                                                                                                             | v == 0 = e
                                                                                                                             | sc == 1 = e
                                                                                                                             | caraJogador m pj dj (V4) = (Estado m (j0:j1:(Jogador a b c d (pp1-5000) a1):j4:(Jogador e0 f g h 1 a2):t) de)
                                                                                                                             | otherwise = e

comprarJuggernog :: Int -> Estado -> Estado
comprarJuggernog 0 e@(Estado m (j0@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):(Jogador e0 f sc g h a2):t) de) | pp0 < 3000 = e
                                                                                                                         | v == 0 = e
                                                                                                                         | sc == 1 = e
                                                                                                                         | caraJogador m pj dj (V0) = (Estado m ((Jogador pj dj (v+100) l ch a0):j1:(Jogador a b c (pp0-3000) d a1):(Jogador e0 f 1 g h a2):t) de)  
                                                                                                                         | otherwise = e
comprarJuggernog 1 e@(Estado m (j0:j1@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):j4:(Jogador e0 f sc g h a2):t) de) | pp1 < 3000 = e
                                                                                                                            | v == 0 = e
                                                                                                                            | sc == 1 = e
                                                                                                                            | caraJogador m pj dj (V0) = (Estado m (j0:(Jogador pj dj (v+100) l ch a0):(Jogador a b c d (pp1-3000) a1):j4:(Jogador e0 f 1 g h a2):t) de)
                                                                                                                            | otherwise = e

comprarSpeedCola :: Int -> Estado -> Estado
comprarSpeedCola 0 e@(Estado m (j0@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):(Jogador e0 f g sc h a2):t) de) | pp0 < 2000 = e
                                                                                                                         | v == 0 = e
                                                                                                                         | sc == 1 = e
                                                                                                                         | caraJogador m pj dj (V1) = (Estado m (j0:j1:(Jogador a b c (pp0-2000) d a1):(Jogador e0 f g 1 h a2):t) de)  
                                                                                                                         | otherwise = e
comprarSpeedCola 1 e@(Estado m (j0:j1@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):j4:(Jogador e0 f g sc h a2):t) de) | pp1 < 2000 = e
                                                                                                                            | v == 0 = e
                                                                                                                            | sc == 1 = e
                                                                                                                            | caraJogador m pj dj (V1) = (Estado m (j0:j1:(Jogador a b c d (pp1-2000) a1):j4:(Jogador e0 f g 1 h a2):t) de)
                                                                                                                            | otherwise = e

comprarMedkit :: Bool -> Int -> Estado -> Estado
comprarMedkit True 0 e@(Estado m (x@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):t) de) | pp0 < 250 = e
                                                                                                 | v == 0 = e
                                                                                                 | v == 200 = e
                                                                                                 | v > 185 && caraJogador m pj dj (V3) = (Estado m ((Jogador pj dj 200 l ch a0):j1:(Jogador a b c (pp0-250) d a1):t) de)  
                                                                                                 | caraJogador m pj dj (V3) = (Estado m ((Jogador pj dj (v+15) l ch a0):j1:(Jogador a b c (pp0-250) d a1):t) de)
                                                                                                 | otherwise = e
comprarMedkit True 1 e@(Estado m (j0:y@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):t) de) | pp1 < 250 = e
                                                                                                 | v == 0 = e
                                                                                                 | v == 200 = e
                                                                                                 | v > 185 && caraJogador m pj dj (V3) = (Estado m (j0:(Jogador pj dj 200 l ch a0):(Jogador a b c d (pp1-250) a1):t) de)
                                                                                                 | caraJogador m pj dj (V3) = (Estado m (j0:(Jogador pj dj (v+15) l ch a0):(Jogador a b c d (pp1-250) a1):t) de)
                                                                                                 | otherwise = e
comprarMedkit False 0 e@(Estado m (x@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):t) de) | pp0 < 250 = e
                                                                                                  | v == 0 = e
                                                                                                  | v == 100 = e
                                                                                                  | v > 85 && caraJogador m pj dj (V3) = (Estado m ((Jogador pj dj 100 l ch a0):j1:(Jogador a b c (pp0-250) d a1):t) de)  
                                                                                                  | caraJogador m pj dj (V3) = (Estado m ((Jogador pj dj (v+15) l ch a0):j1:(Jogador a b c (pp0-250) d a1):t) de)
                                                                                                  | otherwise = e
comprarMedkit False 1 e@(Estado m (j0:y@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):t) de) | pp1 < 250 = e
                                                                                                  | v == 0 = e
                                                                                                  | v == 100 = e
                                                                                                  | v > 85 && caraJogador m pj dj (V3) = (Estado m (j0:(Jogador pj dj 100 l ch a0):(Jogador a b c d (pp1-250) a1):t) de)
                                                                                                  | caraJogador m pj dj (V3) = (Estado m (j0:(Jogador pj dj (v+15) l ch a0):(Jogador a b c d (pp1-250) a1):t) de)
                                                                                                  | otherwise = e

comprarPorta :: Int -> Estado -> Estado
comprarPorta 0 e@(Estado m (x@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):t) de) | pp0 < 200 = e
                                                                                     | v == 0 = e
                                                                                     | caraJogador m pj dj (Porta) = (Estado (atualizaPorta pj dj m) (x:j1:(Jogador a b c (pp0-200) d a1):t) de)
                                                                                     | otherwise = e
comprarPorta 1 e@(Estado m (j0:y@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):t) de) | pp1 < 200 = e
                                                                                     | v == 0 = e
                                                                                     | caraJogador m pj dj (Porta) = (Estado (atualizaPorta pj dj m) (j0:y:(Jogador a b c d (pp1-200) a1):t) de)
                                                                                     | otherwise = e

comprarMunicao :: Int -> Estado -> Estado
comprarMunicao 0 e@(Estado m (x@(Jogador pj dj v l ch a0):j1:(Jogador a b c pp0 d a1):t) de) | pp0 < 100 = e
                                                                                             | v == 0 = e
                                                                                             | caraJogador m pj dj (V2) = (Estado m ((Jogador pj dj v l (ch+50) a0):j1:(Jogador a b c (pp0-100) d a1):t) de)
                                                                                             | otherwise = e
comprarMunicao 1 e@(Estado m (j0:y@(Jogador pj dj v l ch a0):(Jogador a b c d pp1 a1):t) de) | pp1 < 100 = e
                                                                                             | v == 0 = e
                                                                                             | caraJogador m pj dj (V2) = (Estado m (j0:(Jogador pj dj v l (ch+50) a0):(Jogador a b c d (pp1-100) a1):t) de)
                                                                                             | otherwise = e

atualizaPorta :: PosicaoGrelha -> Direcao -> Mapa -> Mapa
atualizaPorta (a,b) C m = atualizaPosicaoMatriz (a-1,b) Vazia (atualizaPosicaoMatriz (a-1,b+1) Vazia m)
atualizaPorta (a,b) D m = atualizaPosicaoMatriz (a,b+2) Vazia (atualizaPosicaoMatriz (a+1,b+2) Vazia m)
atualizaPorta (a,b) B m = atualizaPosicaoMatriz (a+2,b) Vazia (atualizaPosicaoMatriz (a+2,b+1) Vazia m)
atualizaPorta (a,b) E m = atualizaPosicaoMatriz (a,b-1) Vazia (atualizaPosicaoMatriz (a+1,b-1) Vazia m) 

caraJogador :: Mapa -> PosicaoGrelha -> Direcao -> Peca -> Bool
caraJogador m (a,b) C p@(Bloco Indestrutivel) = encontraPosicaoMatriz (a-1,b) m == p || encontraPosicaoMatriz (a-1,b+1) m == p
caraJogador m (a,b) D p@(Bloco Indestrutivel) = encontraPosicaoMatriz (a,b+2) m == p || encontraPosicaoMatriz (a+1,b+2) m == p
caraJogador m (a,b) B p@(Bloco Indestrutivel) = encontraPosicaoMatriz (a+2,b) m == p || encontraPosicaoMatriz (a+2,b+1) m == p
caraJogador m (a,b) E p@(Bloco Indestrutivel) = encontraPosicaoMatriz (a,b-1) m == p || encontraPosicaoMatriz (a+1,b-1) m == p
caraJogador m (a,b) C p = encontraPosicaoMatriz (a-1,b) m == p && encontraPosicaoMatriz (a-1,b+1) m == p
caraJogador m (a,b) D p = encontraPosicaoMatriz (a,b+2) m == p && encontraPosicaoMatriz (a+1,b+2) m == p
caraJogador m (a,b) B p = encontraPosicaoMatriz (a+2,b) m == p && encontraPosicaoMatriz (a+2,b+1) m == p
caraJogador m (a,b) E p = encontraPosicaoMatriz (a,b-1) m == p && encontraPosicaoMatriz (a+1,b-1) m == p

carregar :: ArmaZ -> Jogador -> Jogador
carregar a (Jogador pd dd v l 0 Pistol) = (Jogador pd dd v l 0 Pistol)
carregar a (Jogador pd dd v l 0 AK47) = (Jogador pd dd v l 0 AK47)
carregar a (Jogador pd dd v l 0 M8A1) = (Jogador pd dd v l 0 M8A1)
carregar a (Jogador pd dd v l c Pistol) | c < 12 = (Jogador pd dd v (l+c) 0 Pistol)
                                        | l > 0 = (Jogador pd dd v 12 (c-(12-l)) Pistol)
                                        | otherwise = (Jogador pd dd v (l+12) (c-12) Pistol)
carregar a (Jogador pd dd v l c AK47) | c < 12 = (Jogador pd dd v (l+c) 0 AK47)
                                      | l > 0 = (Jogador pd dd v 12 (c-(12-l)) AK47)
                                      | otherwise = (Jogador pd dd v (l+12) (c-12) AK47)
carregar a (Jogador pd dd v l c M8A1) | c < 12 = (Jogador pd dd v (l+c) 0 M8A1)
                                      | l > 0 = (Jogador pd dd v 12 (c-(12-l)) M8A1)
                                      | otherwise = (Jogador pd dd v (l+12) (c-12) M8A1)                                      
carregar _ j = j

removeLaserJ :: Jogador -> Jogador
removeLaserJ j@(Jogador pj dj 0 l c a) = j
removeLaserJ j@(Jogador pj dj v 0 c a) = j
removeLaserJ (Jogador pj dj v l c M8A1) = (Jogador pj dj v (l-3) c M8A1)
removeLaserJ (Jogador pj dj v l c a) = (Jogador pj dj v (l-1) c a)

-- | Efetua uma jogada.
--
-- Em cada jogada pode-se movimentar o tank ou diparar com este.
jogada :: Bool
       -> Int -- ^ O identificador do 'Jogador' que efetua a jogada.
       -> Jogada -- ^ A 'Jogada' a efetuar.
       -> Estado -- ^ O 'Estado' anterior.
       -> Estado -- ^ O 'Estado' resultante após o jogador efetuar a jogada.      
jogada b n (Movimenta d) (Estado m je de) = (Estado m (atualizaIndiceLista n playerNovo je) de) 
                                              where player = encontraIndiceLista n je
                                                    playerNovo = alteraJogada b player d (Estado m je de)
jogada b n (Dispara Canhao) (Estado m je de) = temChoque (Estado m je de) player de Canhao n 
                                               where player = encontraIndiceLista n je
jogada b n (Dispara Laser) (Estado m je de) = temChoque (Estado m je de) player de Laser n
                                               where player = encontraIndiceLista n je
jogada b n (Dispara Choque) (Estado m je de) = temChoque (Estado m je de) player de Choque n
                                               where player = encontraIndiceLista n je
jogada _ _ _ e = e

-- * Funções Auxiliares para Movimentar Tank

alteraJogadaZ :: Jogador -> Direcao -> Estado -> Jogador
alteraJogadaZ (Jogador pj dj vj lj cj a) d (Estado m je de) | vj == 0 = (Jogador pj dj vj lj cj a) 
                                                          | otherwise = if dj == d then (Jogador (verificaPosParedeZ pj d (Estado m je de)) dj vj lj cj a)
                                                                        else (Jogador pj d vj lj cj a)

verificaPosParedeZ :: PosicaoGrelha -> Direcao -> Estado -> PosicaoGrelha
verificaPosParedeZ pj@(a,b) d (Estado m je de) = case d of
                                                     C -> if encontraPosicaoMatriz (a-1,b) m == Vazia && encontraPosicaoMatriz (a-1,b+1) m == Vazia
                                                          then (a-1,b) else pj
                                                     D -> if encontraPosicaoMatriz (a,b+2) m == Vazia && encontraPosicaoMatriz (a+1,b+2) m == Vazia
                                                          then (a,b+1) else pj
                                                     B -> if encontraPosicaoMatriz (a+2,b) m == Vazia && encontraPosicaoMatriz (a+2,b+1) m == Vazia
                                                          then (a+1,b) else pj
                                                     E -> if encontraPosicaoMatriz (a,b-1) m == Vazia && encontraPosicaoMatriz (a+1,b-1) m == Vazia 
                                                          then (a,b-1) else pj

-- | A função 'alteraJogada' altera a posição do jogador se este possuir vidas suficientes (vj != 0) para o fazer.
--
-- Foi utilizada nesta função uma cadeia de funções axiliares que verificam se o jogador está impedido de se movimentar devido á existencia de um tank, de uma parede ou um de um choque 
alteraJogada :: Bool -> Jogador -> Direcao -> Estado -> Jogador
alteraJogada False j@(Jogador pj dj vj lj cj a) d e@(Estado m je de) = if vj <= 0 then (Jogador pj d vj lj cj a) else alteraJogada True j d e
alteraJogada True (Jogador pj dj vj lj cj a) d (Estado m je de) | vj == 0 = (Jogador pj dj vj lj cj a) 
                                                              | otherwise = if dj == d then (Jogador (verificaPosParede pj d (Estado m je de)) dj vj lj cj a)
                                                                            else (Jogador pj d vj lj cj a)

estaAgua :: Mapa -> PosicaoGrelha -> Bool
estaAgua m (a,b) = or [(eAgua m (a,b)),(eAgua m (a,b+1)),(eAgua m (a+1,b)),(eAgua m (a+1,b+1))]

eAgua :: Mapa -> PosicaoGrelha -> Bool
eAgua [] pg = False
eAgua m pg = encontraPosicaoMatriz pg m ==  Bloco Agua

-- | A função 'verificaPosParede' verifica se existe uma parede na posição para onde o jogador tenciona a ir.
verificaPosParede :: PosicaoGrelha -> Direcao -> Estado -> PosicaoGrelha
verificaPosParede pj@(a,b) d (Estado m je de) = case d of
                                                     C -> if encontraPosicaoMatriz (a-1,b) m == Bloco Indestrutivel || encontraPosicaoMatriz (a-1,b+1) m == Bloco Indestrutivel || encontraPosicaoMatriz (a-1,b) m == Bloco Destrutivel || encontraPosicaoMatriz (a-1,b+1) m == Bloco Destrutivel || encontraPosicaoMatriz (a-1,b) m == Bloco TNT || encontraPosicaoMatriz (a-1,b+1) m == Bloco TNT    
                                                     then pj
                                                     else verificaPosChoque pj d (Estado m je de)
                                                     D -> if encontraPosicaoMatriz (a,b+2) m == Bloco Indestrutivel || encontraPosicaoMatriz (a+1,b+2) m == Bloco Indestrutivel || encontraPosicaoMatriz (a,b+2) m == Bloco Destrutivel || encontraPosicaoMatriz (a+1,b+2) m == Bloco Destrutivel || encontraPosicaoMatriz (a,b+2) m == Bloco TNT || encontraPosicaoMatriz (a+1,b+2) m == Bloco TNT
                                                     then pj 
                                                     else verificaPosChoque pj d (Estado m je de)
                                                     B -> if encontraPosicaoMatriz (a+2,b) m == Bloco Indestrutivel || encontraPosicaoMatriz (a+2,b+1) m == Bloco Indestrutivel || encontraPosicaoMatriz (a+2,b+1) m == Bloco Destrutivel || encontraPosicaoMatriz (a+2,b) m == Bloco Destrutivel || encontraPosicaoMatriz (a+2,b+1) m == Bloco TNT || encontraPosicaoMatriz (a+2,b) m == Bloco TNT
                                                     then pj
                                                     else verificaPosChoque pj d (Estado m je de)
                                                     E -> if encontraPosicaoMatriz (a,b-1) m == Bloco Indestrutivel || encontraPosicaoMatriz (a+1,b-1) m == Bloco Indestrutivel || encontraPosicaoMatriz (a,b-1) m == Bloco Destrutivel || encontraPosicaoMatriz (a+1,b-1) m == Bloco Destrutivel || encontraPosicaoMatriz (a,b-1) m == Bloco TNT || encontraPosicaoMatriz (a+1,b-1) m == Bloco TNT
                                                     then pj
                                                     else verificaPosChoque pj d (Estado m je de)

-- | A função 'verificaPosChoque' verifica se existe um campo de choque algures no mapa.
verificaPosChoque :: PosicaoGrelha -> Direcao -> Estado -> PosicaoGrelha
verificaPosChoque pj d (Estado m je []) = verificaPosTank pj d (Estado m je [])
verificaPosChoque pj d (Estado m je (h:t)) = case h of 
                                                  (DisparoChoque nd _) -> auxPosChoque pj d nd (Estado m je t)
                                                  otherwise -> verificaPosChoque pj d (Estado m je t)

-- | Função Auxiliar de 'verificaPosChoque'
--
-- A função baseia-se na ideia do quadrado que se forma com o choque de tamanho 6*6 e no limite das linhas e colunas que impedem o tank de se movimentar.   
auxPosChoque :: PosicaoGrelha -> Direcao -> Int -> Estado -> PosicaoGrelha
auxPosChoque (l,c) d nd (Estado m je de) | (l < (a-3) || l > (a+3)) || (c < (b-3) || c > (b+3)) =  verificaPosChoque (l,c) d (Estado m je de)
                                         | (l == a && c == b) = verificaPosChoque (l,c) d (Estado m je de)
                                         | otherwise = (l,c)
                                         where (Jogador (a,b) _ _ _ _ _) = encontraIndiceLista nd je

-- | A função 'verificaPosTank' verifica se existe um tank na nova posição do jogador.
verificaPosTank :: PosicaoGrelha -> Direcao -> Estado -> PosicaoGrelha
verificaPosTank pj d (Estado m [] de) = somaVetores pj (direcaoParaVetor d)
verificaPosTank pj d (Estado m ((Jogador pjj _ 0 _ _ _):t) de) = verificaPosTank pj d (Estado m t de)
verificaPosTank (a,b) d (Estado m ((Jogador (l,c) _ vj _ _ _):t) de) | elem distancia [1,2] = if (a == l && b == c) 
                                                                                            then verificaPosTank (a,b) d (Estado m t de) 
                                                                                            else (a,b) 
                                                                    | otherwise = verificaPosTank (a,b) d (Estado m t de)
                                                                    where distancia = (l-l1)^2 + (c-c1)^2
                                                                          (l1,c1) = somaVetores (a,b) (direcaoParaVetor d)

-- * Funcões Auxiliares para Disparar Tank

temChoque :: Estado -> Jogador -> [Disparo] -> Arma -> Int -> Estado
temChoque (Estado m je []) player de a n | a == Canhao = (Estado m je (adDisparo m player de n Canhao))
                                         | a == Laser = (Estado m (atualizaIndiceLista n playerLaser je) (adDisparo m player de n Laser))
                                         | otherwise = (Estado m (atualizaIndiceLista n playerChoque je) (adDisparo m player de n Choque))
                                         where playerLaser = altJog m player Laser 
                                               playerChoque = altJog m player Choque 
temChoque (Estado m je (h:t)) player de a n = case h of 
                                                  (DisparoChoque nd _) -> auxDispChoque (Estado m je t) player de a n nd
                                                  otherwise -> temChoque (Estado m je t) player de a n

auxDispChoque :: Estado -> Jogador -> [Disparo] -> Arma -> Int -> Int -> Estado
auxDispChoque (Estado m je t) j@(Jogador (l,c) dj vj lj cj a) de arma n nd | (l < (a-3) || l > (a+3)) || (c < (b-3) || c > (b+3)) = temChoque (Estado m je t) j de arma n
                                                                         | (l == a && c == b) = temChoque (Estado m je t) j de arma n
                                                                         | otherwise = (Estado m je de)
                                                                         where (Jogador (a,b) _ _ _ _ _) = encontraIndiceLista nd je

-- | A função 'adDisparo' adiciona o disparo em que7stão à lista dos disparos.
adDisparo :: Mapa -> Jogador -> [Disparo] -> Int -> Arma -> [Disparo]
adDisparo m j@(Jogador pj@(l,c) dj vj lj cj a0) [] n a | a == Canhao = if (vj == 0) then [] else [DisparoCanhao n pd dj]
                                                    | a == Laser = if (vj == 0) || (lj == 0) || eBlocoIndestrutivel m (impactoDisparo pd dj) then [] else [DisparoLaser n pd dj]
                                                    | otherwise = if (vj == 0) || (cj == 0) then [] else [DisparoChoque n 50]
                                                    where pd = somaVetores pj (direcaoParaVetor dj)
adDisparo m j@(Jogador pj@(l,c) dj vj lj cj a0) (h:t) n a | a == Canhao = if (vj == 0) then (h:t) else ((DisparoCanhao n pd dj):h:t)
                                                       | a == Laser = if (vj == 0) || (lj == 0) || eBlocoIndestrutivel m (impactoDisparo pd dj) then (h:t) else ((DisparoLaser n pd dj):h:t)
                                                       | otherwise = if (vj == 0) || (cj == 0) then (h:t) else ((DisparoChoque n 50):h:t)
                                                       where pd = somaVetores pj (direcaoParaVetor dj)

-- | A função 'adDisparoZ' adiciona o disparo em questão à lista dos disparos.
adDisparoZ :: Mapa -> Jogador -> [Disparo] -> ArmaZ -> Int -> Arma -> [Disparo]
adDisparoZ m (Jogador pj dj vj lj cj Pistol) [] Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj Pistol) (h:t) Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj Pistol) [] Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj,DisparoCanhao n pd2 dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
                                                             pd2 = somaVetores pd (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj Pistol) (h:t) Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):(DisparoCanhao n pd2 dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)                                                         
                                                                pd2 = somaVetores pd (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj AK47) [] Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj AK47) (h:t) Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj AK47) [] Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj,DisparoCanhao n pd2 dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
                                                             pd2 = somaVetores pd (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj AK47) (h:t) Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):(DisparoCanhao n pd2 dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)                                                         
                                                                pd2 = somaVetores pd (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj M8A1) [] Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj,DisparoCanhao n pd2 dj,DisparoCanhao n pd3 dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
                                                             pd2 = somaVetores pd (direcaoParaVetor dj)
                                                             pd3 = somaVetores pd2 (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj M8A1) (h:t) Pistol n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):(DisparoCanhao n pd2 dj):(DisparoCanhao n pd3 dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)
                                                                pd2 = somaVetores pd (direcaoParaVetor dj)
                                                                pd3 = somaVetores pd2 (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj M8A1) [] Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then [] else [DisparoCanhao n pd dj,DisparoCanhao n pd2 dj,DisparoCanhao n pd3 dj,DisparoCanhao n pd4 dj]
                                                       where pd = somaVetores pj (direcaoParaVetor dj)
                                                             pd2 = somaVetores pd (direcaoParaVetor dj)
                                                             pd3 = somaVetores pd2 (direcaoParaVetor dj)
                                                             pd4 = somaVetores pd3 (direcaoParaVetor dj)
adDisparoZ m (Jogador pj dj vj lj cj M8A1) (h:t) Faca n a = if (vj == 0) || (lj == 0) || caraJogador m pj dj (Bloco Indestrutivel) then (h:t) else ((DisparoCanhao n pd dj):(DisparoCanhao n pd2 dj):(DisparoCanhao n pd3 dj):(DisparoCanhao n pd4 dj):h:t)
                                                          where pd = somaVetores pj (direcaoParaVetor dj)                                                         
                                                                pd2 = somaVetores pd (direcaoParaVetor dj)
                                                                pd3 = somaVetores pd (direcaoParaVetor dj)
                                                                pd4 = somaVetores pd (direcaoParaVetor dj)
-- | A função 'altJog' utiliza o jogador e arma com que quer disparar e verifica se este tem munições para alterar os parametros do jogador.
altJog :: Mapa -> Jogador -> Arma -> Jogador
altJog m (Jogador pj dj vj lj cj a) arma | (arma == Laser) = if (vj == 0) || (lj == 0) || eBlocoIndestrutivel m (impactoDisparo pd dj) then (Jogador pj dj vj lj cj a) else (Jogador pj dj vj (lj-1) cj a)
                                       | otherwise = if (vj == 0) || (cj == 0) then (Jogador pj dj vj lj cj a) else (Jogador pj dj vj lj (cj-1) a)
                                       where pd = somaVetores pj (direcaoParaVetor dj)