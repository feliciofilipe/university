-- | Este módulo define funções comuns da Tarefa 4 do trabalho prático.
module Physics2 where

import DataStruct
import Functions
import MapEditor

type PosicoesGrelha = [PosicaoGrelha]
type ImpactoDisparo = (Posicao,Posicao)
 
-- * Funções principais da Tarefa 4.

-- | Avança o 'Estado' do jogo um 'Tick' de tempo.
--
-- __NB:__ Apenas os 'Disparo's afetam o 'Estado' do jogo com o passar do tempo.
--
-- __NB:__ Deve chamar as funções 'tickChoques', 'tickCanhoes' e 'tickLasers' pela ordem definida.
tick :: Estado -- ^ O 'Estado' anterior.
     -> Estado -- ^ O 'Estado' após um 'Tick'.
tick = tickChoques . tickCanhoes . tickLasers

-- | Avança o 'Estado' do jogo um 'Tick' de tempo, considerando apenas os efeitos dos tiros de 'Laser' disparados.
tickLasers :: Estado -> Estado
tickLasers (Estado m je de) = (Estado (atualizaMapa m (guardaDisparosLaser de))
                                      (removeVidas m (guardaDisparosLaser de) je)
                                      (atualizaDisparosLaser m de de))

guardaDisparosLaser :: [Disparo] -> [Disparo]
guardaDisparosLaser [] = []
guardaDisparosLaser (h@(DisparoLaser jd pd dd):t) = (DisparoLaser jd pd dd) : (guardaDisparosLaser t)
guardaDisparosLaser (h:t) = guardaDisparosLaser t 

atualizaMapa :: Mapa -> [Disparo] -> Mapa
atualizaMapa [] _ = []
atualizaMapa m [] = m
atualizaMapa m (h:t) = atualizaParede (atualizaMapa m t) h
    where
    atualizaParede :: Mapa -> Disparo -> Mapa
    atualizaParede [] _ = []
    atualizaParede m (DisparoChoque jd td) = m
    atualizaParede m (DisparoCanhao jd pd dd) | eTNT m (impactoDisparo pd dd) = (atualizaParede (atualizaParede (atualizaParede (atualizaParede (destroiTNT m (impactoTNT dd pd)) (DisparoCanhao jd (auxMove pd C) dd)) (DisparoCanhao jd (auxMove pd D) dd)) (DisparoCanhao jd (auxMove pd E) dd)) (DisparoCanhao jd (auxMove pd B) dd))
                                              | eBlocoDestrutivel m (impactoDisparo pd dd) == 2 = 
                                                atualizaPosicaoMatriz (fst(impactoDisparo pd dd)) Vazia (atualizaPosicaoMatriz (snd(impactoDisparo pd dd)) Vazia m)
                                              | eBlocoDestrutivel m (impactoDisparo pd dd) == 11 = 
                                                atualizaPosicaoMatriz (fst(impactoDisparo pd dd)) Vazia m
                                              | eBlocoDestrutivel m (impactoDisparo pd dd) == 12 = 
                                                atualizaPosicaoMatriz (snd(impactoDisparo pd dd)) Vazia m
                                              | otherwise = m 
    atualizaParede m (DisparoLaser jd pd dd) | eTNT m (impactoDisparo pd dd) = atualizaParede (destroiTNT m (impactoTNT dd pd)) (DisparoLaser jd (auxMove pd dd) dd)
                                             | eBlocoDestrutivel m (impactoDisparo pd dd) == 2 = 
                                               atualizaParede (atualizaPosicaoMatriz (fst(impactoDisparo pd dd)) Vazia (atualizaPosicaoMatriz (snd(impactoDisparo pd dd)) Vazia m)) (DisparoLaser jd (auxMove pd dd) dd)
                                             | eBlocoDestrutivel m (impactoDisparo pd dd) == 11 = 
                                               atualizaParede (atualizaPosicaoMatriz (fst(impactoDisparo pd dd)) Vazia m) (DisparoLaser jd (auxMove pd dd) dd)
                                             | eBlocoDestrutivel m (impactoDisparo pd dd) == 12 = 
                                               atualizaParede (atualizaPosicaoMatriz (snd(impactoDisparo pd dd)) Vazia m) (DisparoLaser jd (auxMove pd dd) dd)
                                             | eBlocoIndestrutivel m (impactoDisparo pd dd) = m
                                             | otherwise = atualizaParede m (DisparoLaser jd (auxMove pd dd) dd)

eBlocoIndestrutivel :: Mapa -> ImpactoDisparo -> Bool
eBlocoIndestrutivel m (a,b) = (encontraPosicaoMatriz a m) == Bloco Indestrutivel || (encontraPosicaoMatriz b m) == Bloco Indestrutivel || (encontraPosicaoMatriz a m) == Porta || (encontraPosicaoMatriz b m) == Porta || (encontraPosicaoMatriz a m) == V0 || (encontraPosicaoMatriz b m) == V0 || (encontraPosicaoMatriz a m) == V1 || (encontraPosicaoMatriz b m) == V1  || (encontraPosicaoMatriz a m) == V2 || (encontraPosicaoMatriz b m) == V2  || (encontraPosicaoMatriz a m) == V3 || (encontraPosicaoMatriz b m) == V3  || (encontraPosicaoMatriz a m) == V4 || (encontraPosicaoMatriz b m) == V4 || (encontraPosicaoMatriz a m) == V5 || (encontraPosicaoMatriz b m) == V5 || (encontraPosicaoMatriz a m) == V6 || (encontraPosicaoMatriz b m) == V6 || (encontraPosicaoMatriz a m) == V7 || (encontraPosicaoMatriz b m) == V7     
 
eBlocoDestrutivel :: Mapa -> ImpactoDisparo -> Int
eBlocoDestrutivel [] _ = 0
eBlocoDestrutivel m (a,b) | (encontraPosicaoMatriz a m) == Bloco Destrutivel && 
                            (encontraPosicaoMatriz b m) == Bloco Destrutivel = 2
                          | (encontraPosicaoMatriz a m) == Bloco Destrutivel = 11
                          | (encontraPosicaoMatriz b m) == Bloco Destrutivel = 12
                          | otherwise = 0

eTNT :: Mapa -> ImpactoDisparo -> Bool
eTNT [] _ = False
eTNT m (a,b) = (encontraPosicaoMatriz a m) == Bloco TNT || (encontraPosicaoMatriz b m) == Bloco TNT


destroiTNT :: Mapa -> PosicoesGrelha -> Mapa
destroiTNT m [] = m
destroiTNT m (h:t) | (encontraPosicaoMatriz h m) == Bloco Destrutivel = atualizaPosicaoMatriz h Vazia (destroiTNT m t)
                   | (encontraPosicaoMatriz h m) == Bloco TNT = atualizaPosicaoMatriz h Vazia (destroiTNT m t) 
                   | otherwise = destroiTNT m t


impactoTNT :: Direcao -> PosicaoGrelha -> PosicoesGrelha
impactoTNT D (a,b) = auxImpactoTNT (a,b+1)
impactoTNT C (a,b) = auxImpactoTNT (a-1,b)
impactoTNT _ (a,b) = auxImpactoTNT (a,b)

auxImpactoTNT :: PosicaoGrelha -> PosicoesGrelha
auxImpactoTNT (a,b) = [(a-1,b-1),(a-1,b),(a-1,b+1),
                       (a,b-1),(a,b),(a,b+1),
                       (a+1,b-1),(a+1,b),(a+1,b+1)]

impactoDisparo :: PosicaoGrelha -> Direcao -> ImpactoDisparo
impactoDisparo (a,b) d = case d of
                           C -> ((a,b),(a,b+1))
                           D -> ((a,b+1),(a+1,b+1))
                           B -> ((a+1,b),(a+1,b+1))
                           E -> ((a,b),(a+1,b))

removeVidas :: Mapa -> [Disparo] -> [Jogador] -> [Jogador]
removeVidas m [] lj = lj 
removeVidas m (h:t) lj = case h of
                              (DisparoChoque jd td) -> removeVidas m t lj
                              otherwise -> auxRemoveVidas m (removeVidas m t lj) h
    where
    auxRemoveVidas :: Mapa -> [Jogador] -> Disparo -> [Jogador]
    auxRemoveVidas m lj d = map (removeVida m d) lj


removeVida :: Mapa -> Disparo -> Jogador -> Jogador
removeVida m dl@(DisparoLaser jd pd dd) j@(Jogador pj dj 0 l c a)  = j
removeVida m (DisparoCanhao jd pd dd) j@(Jogador pj dj 0 l c a)  = j
removeVida m dl@(DisparoLaser jd pd dd) j@(Jogador pj dj v l c a) = if comparaPosicoes (tail(posicoesLasers m [dl])) (areaImpactoTank j)
                                                                    then (Jogador pj dj (v-1) l c a)  
                                                                    else (Jogador pj dj v l c a)
removeVida m (DisparoCanhao jd pd dd) j@(Jogador pj dj v l c a) = if elem pd (areaImpactoTank j) && naoETiroProprio pd dd j
                                                                  then (Jogador pj dj (v-1) l c a)  
                                                                  else if estaExplosao (eTNT m (impactoDisparo pd dd)) (areaImpactoTank j) (impactoTNT dd pd) && naoETiroProprio pd dd j
                                                                        then (Jogador pj dj (v-1) l c a)
                                                                        else (Jogador pj dj v l c a)

estaExplosao :: Bool -> PosicoesGrelha -> PosicoesGrelha -> Bool
estaExplosao True [] _ = True
estaExplosao True (h:t) l = if elem h t then estaExplosao True t l else False
estaExplosao _ _ _ = False


naoETiroProprio :: Posicao -> Direcao -> Jogador -> Bool
naoETiroProprio (a,b) C (Jogador (x,y) d v l c _) = (a,b) /= (x-1,y)
naoETiroProprio (a,b) D (Jogador (x,y) d v l c _) = (a,b) /= (x,y+1)
naoETiroProprio (a,b) E (Jogador (x,y) d v l c _) = (a,b) /= (x,y-1)
naoETiroProprio (a,b) B (Jogador (x,y) d v l c _) = (a,b) /= (x+1,y)

comparaPosicoes :: PosicoesGrelha -> PosicoesGrelha -> Bool
comparaPosicoes [] _ = False
comparaPosicoes (h:t) at = if elem h at then True else comparaPosicoes t at 


areaImpactoTank :: Jogador -> PosicoesGrelha
areaImpactoTank (Jogador _ _ 0 _ _ _) = []
areaImpactoTank (Jogador (a,b) dj v l c _) = [(a-1,b-1),(a-1,b),(a-1,b+1),
                                            (a,b-1),(a,b),(a,b+1),
                                            (a+1,b-1),(a+1,b),(a+1,b+1)]


atualizaDisparosLaser :: Mapa -> [Disparo] -> [Disparo] -> [Disparo]
atualizaDisparosLaser m [] ld = []
atualizaDisparosLaser m (h@(DisparoCanhao jd pd dd):t) ld = if elem pd (posicoesLasers m ld)
                                                            then atualizaDisparosLaser m t ld
                                                            else h : atualizaDisparosLaser m t ld
atualizaDisparosLaser m (h@(DisparoLaser jd pd dd):t) ld = atualizaDisparosLaser m t ld                                   
atualizaDisparosLaser m (h:t) ld = h : atualizaDisparosLaser m t ld
                                   


posicoesLasers :: Mapa -> [Disparo] -> PosicoesGrelha
posicoesLasers m ((DisparoLaser jd pd dd):t) = if eBlocoIndestrutivel m (impactoDisparo pd dd)
                                               then posicoesLasers m t
                                               else pd : posicoesLasers m ((DisparoLaser jd (auxMove pd dd) dd):t)
posicoesLasers m (h:t) = posicoesLasers m t
posicoesLasers _ _ = []                                               

-- | Avança o 'Estado' do jogo um 'Tick' de tempo, considerando apenas os efeitos das balas de 'Canhao' disparadas.
tickCanhoes :: Estado -> Estado
tickCanhoes (Estado m je de) = (Estado (atualizaMapa m (guardaDisparosCanhao de))
                                       (removeVidas m (guardaDisparosCanhao de) je)
                                       (atualizaDisparosCanhao m de je))


guardaDisparosCanhao :: [Disparo] -> [Disparo]
guardaDisparosCanhao [] = []
guardaDisparosCanhao (h@(DisparoCanhao jd pd dd):t) = (DisparoCanhao jd pd dd) : (guardaDisparosCanhao t)
guardaDisparosCanhao (h:t) = guardaDisparosCanhao t

atualizaDisparosCanhao :: Mapa -> [Disparo] -> [Jogador] -> [Disparo]
atualizaDisparosCanhao m [] lj = []
atualizaDisparosCanhao m (h@(DisparoCanhao jd pd dd):t) lj | eTiroAtras (pd,dd) (zip (guardaPosicoesCanhao t) (removeDirecoesCanhao t)) =
                                                             atualizaDisparosCanhao m (removeTirosAtras (pd,dd) t) lj
                                                           | eTiroCanhao pd (guardaPosicoesCanhao t) =
                                                             atualizaDisparosCanhao m (removeTirosCanhao pd t) lj
                                                           | eBlocoIndestrutivel m (impactoDisparo pd dd) ||
                                                             eTNT m (impactoDisparo pd dd) || 
                                                             eBlocoDestrutivel m (impactoDisparo pd dd) /= 0 ||
                                                             eJogador lj pd dd = atualizaDisparosCanhao m t lj
                                                           | otherwise = (DisparoCanhao jd (auxMove pd dd) dd) : (atualizaDisparosCanhao m t lj)
atualizaDisparosCanhao m (h:t) lj = h : (atualizaDisparosCanhao m t lj)


eJogador :: [Jogador] -> PosicaoGrelha -> Direcao -> Bool
eJogador [] _ _ = False
eJogador ((Jogador _ _ 0 _ _ _):t) pp dd = eJogador t pp dd
eJogador (h:t) pp dd = if auxEJogador h pp && naoETiroProprio pp dd h then True else eJogador t pp dd

auxEJogador :: Jogador -> PosicaoGrelha -> Bool
auxEJogador j p = or (map (==p) (areaImpactoTank j))

eTiroCanhao :: PosicaoGrelha -> PosicoesGrelha -> Bool
eTiroCanhao pd pds = elem pd pds

removeTirosCanhao :: PosicaoGrelha -> [Disparo] -> [Disparo]
removeTirosCanhao pd [] = []
removeTirosCanhao pd (h:t) | [pd] == (guardaPosicoesCanhao [h]) = removeTirosCanhao pd t
                           | otherwise = h:(removeTirosCanhao pd t)

removeTirosAtras :: (PosicaoGrelha,Direcao) -> [Disparo] -> [Disparo]
removeTirosAtras (p,d) [] = []
removeTirosAtras (p,d) (h@(DisparoCanhao jd pd dd):t) | auxETiroAtras (p,d) (pd,dd) = removeTirosAtras (p,d) t
                                                      | otherwise = h:(removeTirosAtras (p,d) t)
removeTirosAtras _ _ = []                                                      

eTiroAtras :: (PosicaoGrelha,Direcao) -> [(Posicao,Direcao)] -> Bool
eTiroAtras x xs = or (map (auxETiroAtras x) xs)

auxETiroAtras :: (PosicaoGrelha,Direcao) -> (PosicaoGrelha,Direcao) -> Bool
auxETiroAtras ((x1,y1),C) ((x2,y2),d2) = d2 == B && (x2,y2) == (x1-1,y1)
auxETiroAtras ((x1,y1),D) ((x2,y2),d2) = d2 == E && (x2,y2) == (x1,y1-1)
auxETiroAtras ((x1,y1),B) ((x2,y2),d2) = d2 == C && (x2,y2) == (x1+1,y1)
auxETiroAtras ((x1,y1),E) ((x2,y2),d2) = d2 == D && (x2,y2) == (x1,y1+1)

removeDirecoesCanhao :: [Disparo] -> [Direcao]
removeDirecoesCanhao [] = []
removeDirecoesCanhao ((DisparoCanhao jd pd dd):t) = dd : (removeDirecoesCanhao t)
removeDirecoesCanhao (h:t) = removeDirecoesCanhao t

guardaPosicoesCanhao :: [Disparo] -> PosicoesGrelha
guardaPosicoesCanhao [] = []
guardaPosicoesCanhao ((DisparoCanhao jd pd dd):t) = pd : (guardaPosicoesCanhao t)
guardaPosicoesCanhao (h:t) = guardaPosicoesCanhao t

-- | Avança o 'Estado' do jogo um 'Tick' de tempo, considerando apenas os efeitos dos campos de 'Choque' disparados.
tickChoques :: Estado -> Estado
tickChoques (Estado m je de) = (Estado m je (atualizaDisparosChoque de))

atualizaDisparosChoque :: [Disparo] -> [Disparo]
atualizaDisparosChoque [] = []
atualizaDisparosChoque (h:t) = case h of
                                    (DisparoChoque jd td) -> if td == 0
                                                             then atualizaDisparosChoque t
                                                             else (DisparoChoque jd (td-1)) : (atualizaDisparosChoque t)
                                    otherwise -> h:(atualizaDisparosChoque t)