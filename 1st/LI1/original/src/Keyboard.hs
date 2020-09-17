module Keyboard where

import DataStruct
import Functions
import Physics1
import MapEditor
import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Interface.Pure.Game

reageEvento :: Event -> Bool -> Estado ->  Estado
reageEvento (EventKey (Char '1') Down _ _) b e = jogada b 0 (Dispara Canhao) e
reageEvento (EventKey (Char '2') Down _ _) b e = jogada b 0 (Dispara Laser) e
reageEvento (EventKey (Char '3') Down _ _) b e = jogada b 0 (Dispara Choque) e 
reageEvento (EventKey (Char '4') Down _ _) b e = jogada b 1 (Dispara Canhao) e
reageEvento (EventKey (Char '5') Down _ _) b e = jogada b 1 (Dispara Laser) e
reageEvento (EventKey (Char '6') Down _ _) b e = jogada b 1 (Dispara Choque) e
reageEvento (EventKey (Char '7') Down _ _) b e = jogada b 2 (Dispara Canhao) e
reageEvento (EventKey (Char '8') Down _ _) b e = jogada b 2 (Dispara Laser) e
reageEvento (EventKey (Char '9') Down _ _) b e = jogada b 2 (Dispara Choque) e
reageEvento (EventKey (Char ',') Down _ _) b e = jogada b 3 (Dispara Canhao) e
reageEvento (EventKey (Char '.') Down _ _) b e = jogada b 3 (Dispara Laser) e
reageEvento (EventKey (Char '-') Down _ _) b e = jogada b 3 (Dispara Choque) e
reageEvento _ _ s = s -- ignora qualquer outro evento

{- | Função que reage aos comandos dados pelo o utilizador

Esta função baseia-se nas mesmas ideias que o 'reageEvento', só que aplicado a 2 jogadores
-}
reageEvento2 :: Event -> Bool -> Estado -> Estado
reageEvento2 (EventKey (Char '1') Down _ _) b e = jogada b 0 (Dispara Canhao) e
reageEvento2 (EventKey (Char '2') Down _ _) b e = jogada b 0 (Dispara Laser) e
reageEvento2 (EventKey (Char '3') Down _ _) b e = jogada b 0 (Dispara Choque) e
reageEvento2 (EventKey (Char ',') Down _ _) b e = jogada b 1 (Dispara Canhao) e
reageEvento2 (EventKey (Char '.') Down _ _) b e = jogada b 1 (Dispara Laser) e
reageEvento2 (EventKey (Char '-') Down _ _) b e = jogada b 1 (Dispara Choque) e
reageEvento2 _ _ s = s -- ignora qualquer outro evento

{- | Função que reage aos comandos dados pelo o utilizador

Esta função baseia-se nas mesmas ideias que o 'reageEvento', só que aplicado a 3 jogadores
-}
reageEvento3 :: Event -> Bool -> Estado -> Estado
reageEvento3 (EventKey (Char '1') Down _ _) b e = jogada b 0 (Dispara Canhao) e
reageEvento3 (EventKey (Char '2') Down _ _) b e = jogada b 0 (Dispara Laser) e
reageEvento3 (EventKey (Char '3') Down _ _) b e = jogada b 0 (Dispara Choque) e
reageEvento3 (EventKey (Char ',') Down _ _) b e = jogada b 1 (Dispara Canhao) e
reageEvento3 (EventKey (Char '.') Down _ _) b e = jogada b 1 (Dispara Laser) e
reageEvento3 (EventKey (Char '-') Down _ _) b e = jogada b 1 (Dispara Choque) e
reageEvento3 (EventKey (Char '7') Down _ _) b e = jogada b 2 (Dispara Canhao) e
reageEvento3 (EventKey (Char '8') Down _ _) b e = jogada b 2 (Dispara Laser) e
reageEvento3 (EventKey (Char '9') Down _ _) b e = jogada b 2 (Dispara Choque) e
reageEvento3 _ _ s = s -- ignora qualquer outro evento

{- | Função que reage aos comandos dados pelo o utilizador

Esta função baseia-se nas mesmas ideias que o 'reageEvento', só que aplicado ao modoZombie, isto devido á alterção das jogadas possiveis de se fazer no modoZombie como carregar e comprar.
-}
reageEventoZ :: Event -> Bool -> Estado -> Estado
reageEventoZ (EventKey (Char '1') Down _ _) b e@(Estado m ((Jogador _ _ _ _ _ Faca):t) ld) = jogadaZ b 0 (Facada) e
reageEventoZ (EventKey (Char '1') Down _ _) b e@(Estado m ((Jogador _ _ _ _ _ Pistol):t) ld) = jogadaZ b 0 (Dispara Canhao) e
reageEventoZ (EventKey (Char '1') Down _ _) b e@(Estado m ((Jogador _ _ _ _ _ M8A1):t) ld) = jogadaZ b 0 (Dispara Canhao) e
reageEventoZ (EventKey (Char '2') Down _ _) b e = jogadaZ b 0 (Carregar) e
reageEventoZ (EventKey (Char '3') Down _ _) b e@(Estado m (x:y:z:(Jogador _ _ 1 _ _ _):t) ld) = jogadaZ True 0 (Comprar) e
reageEventoZ (EventKey (Char '3') Down _ _) b e = jogadaZ False 0 (Comprar) e
reageEventoZ (EventKey (Char '4') Down _ _) b e = jogadaZ b 0 (MudarArma) e
reageEventoZ (EventKey (Char ',') Down _ _) b e@(Estado m (x:(Jogador _ _ _ _ _ Faca):t) ld) = jogadaZ b 1 (Facada) e
reageEventoZ (EventKey (Char ',') Down _ _) b e@(Estado m (x:(Jogador _ _ _ _ _ Pistol):t) ld) = jogadaZ b 1 (Dispara Canhao) e
reageEventoZ (EventKey (Char ',') Down _ _) b e@(Estado m (x:(Jogador _ _ _ _ _ M8A1):t) ld) = jogadaZ b 1 (Dispara Canhao) e
reageEventoZ (EventKey (Char '.') Down _ _) b e = jogadaZ b 1 (Carregar) e
reageEventoZ (EventKey (Char '-') Down _ _) b e@(Estado m (x:y:z:a:(Jogador _ _ 1 _ _ _):t) ld) = jogadaZ True 1 (Comprar) e
reageEventoZ (EventKey (Char '-') Down _ _) b e = jogadaZ False 1 (Comprar) e
reageEventoZ (EventKey (Char 'm') Down _ _) b e = jogadaZ b 1 (MudarArma) e
reageEventoZ _ _ s = s -- ignora qualquer outro event

removeKey :: Key -- ^ Recebe uma key 
          -> [Key] -- ^ Recebe uma lista de Keys
          -> [Key] -- ^ Lista de Keys sem o primeiro elemento
removeKey a (h:t) | a == h = t
                  | otherwise = h : removeKey a t
removeKey _ _ = []                  


-- | Função que com a função aplicaKey transforma uma lista de keys num estado 
aplicaListaKey :: [Key] -- ^ Recebe lista de keys
               -> Bool 
               -> Estado -- ^ Recebe um estado inicial
               -> Estado -- ^ Estado resultante da alteração efetuada pelas várias keys
aplicaListaKey [] _ e = e
aplicaListaKey (h:t) b e = aplicaListaKey t b (aplicaKey h b e) 

-- | Função que aplica uma determinada Key a um estado 
aplicaKey :: Key -- ^ Key Pressionada
          -> Bool 
          -> Estado -- ^ Estado atual 
          -> Estado -- ^ Estado alterado pelo evento 
aplicaKey (SpecialKey KeyUp) b e = jogada True 3 (Movimenta C) e
aplicaKey (SpecialKey KeyDown) b e  = jogada True 3 (Movimenta B) e 
aplicaKey (SpecialKey KeyLeft) b e  = jogada True 3 (Movimenta E) e 
aplicaKey (SpecialKey KeyRight) b e = jogada True 3 (Movimenta D) e 
aplicaKey (Char 'w') b e = jogada True 0 (Movimenta C) e
aplicaKey (Char 's') b e = jogada True 0 (Movimenta B) e
aplicaKey (Char 'a') b e = jogada True 0 (Movimenta E) e
aplicaKey (Char 'd') b e = jogada True 0 (Movimenta D) e
aplicaKey (Char 't') b e = jogada True 1 (Movimenta C) e
aplicaKey (Char 'g') b e = jogada True 1 (Movimenta B) e
aplicaKey (Char 'f') b e = jogada True 1 (Movimenta E) e
aplicaKey (Char 'h') b e = jogada True 1 (Movimenta D) e
aplicaKey (Char 'i') b e = jogada True 2 (Movimenta C) e
aplicaKey (Char 'k') b e = jogada True 2 (Movimenta B) e
aplicaKey (Char 'j') b e = jogada True 2 (Movimenta E) e
aplicaKey (Char 'l') b e = jogada True 2 (Movimenta D) e
aplicaKey _ _ e = e

-- | Função que com a função aplicaKey transforma uma lista de keys num estado 
aplicaListaKeyZ :: [Key] -- ^ Recebe lista de keys
               -> Bool 
               -> Estado -- ^ Recebe um estado inicial
               -> Estado -- ^ Estado resultante da alteração efetuada pelas várias keys
aplicaListaKeyZ [] _ e = e
aplicaListaKeyZ (h:t) b e = aplicaListaKeyZ t b (aplicaKeyZ h b e) 

-- | Função que aplica uma determinada Key a um estado 
aplicaKeyZ :: Key -- ^ Key Pressionada
          -> Bool 
          -> Estado -- ^ Estado atual 
          -> Estado -- ^ Estado alterado pelo evento 
aplicaKeyZ (SpecialKey KeyUp) b e = jogadaZ True 1 (Movimenta C) e
aplicaKeyZ (SpecialKey KeyDown) b e  = jogadaZ True 1 (Movimenta B) e 
aplicaKeyZ (SpecialKey KeyLeft) b e  = jogadaZ True 1 (Movimenta E) e 
aplicaKeyZ (SpecialKey KeyRight) b e = jogadaZ True 1 (Movimenta D) e 
aplicaKeyZ (Char 'w') b e = jogadaZ True 0 (Movimenta C) e
aplicaKeyZ (Char 's') b e = jogadaZ True 0 (Movimenta B) e
aplicaKeyZ (Char 'a') b e = jogadaZ True 0 (Movimenta E) e
aplicaKeyZ (Char 'd') b e = jogadaZ True 0 (Movimenta D) e
aplicaKeyZ (Char '1') b e@(Estado m ((Jogador _ _ _ _ _ AK47):t) ld) = jogadaZ True 0 (Dispara Canhao) e
aplicaKeyZ (Char ',') b e@(Estado m (x:(Jogador _ _ _ _ _ AK47):t) ld) = jogadaZ True 1 (Dispara Canhao) e
aplicaKeyZ _ _ e = e

aplicaListaEditor :: [Key] -- ^ Recebe lista de keys 
                  -> Editor -- ^ Recebe um estado inicial
                  -> Editor -- ^ Estado resultante da alteração efetuada pelas várias keys
aplicaListaEditor [] e = e
aplicaListaEditor (h:t) e = aplicaListaEditor t (aplicaKeyEditor h e) 

-- | Função que aplica uma determinada Key a um estado 
aplicaKeyEditor :: Key -- ^ Key Pressionada
                -> Editor -- ^ Estado atual 
                -> Editor -- ^ Estado alterado pelo evento 
aplicaKeyEditor (Char 'w') e = instrucao (Move C) e
aplicaKeyEditor (Char 's') e  = instrucao (Move B) e
aplicaKeyEditor (Char 'a') e  = instrucao (Move E) e 
aplicaKeyEditor (Char 'd') e = instrucao (Move D) e 
aplicaKeyEditor _ e = e

eventToKey1 :: Event -> [Key] ->[Key]
eventToKey1 (EventKey key@(Char 'w') Down _ _) k = (key:k)
eventToKey1 (EventKey key@(Char 'd') Down _ _) k = (key:k)
eventToKey1 (EventKey key@(Char 's') Down _ _) k = (key:k)
eventToKey1 (EventKey key@(Char 'a') Down _ _) k = (key:k)
eventToKey1 (EventKey key Up  _ _) k = removeKey key k
eventToKey1 _ k = k

eventToKey :: Event -> [Key] ->[Key]
eventToKey (EventKey (Char 'w') Down _ _) k = ((Char 'w'):k)
eventToKey (EventKey (Char 's') Down _ _) k = ((Char 's'):k)
eventToKey (EventKey (Char 'a') Down _ _) k = ((Char 'a'):k)
eventToKey (EventKey (Char 'd') Down _ _) k = ((Char 'd'):k)
eventToKey (EventKey (Char 't') Down _ _) k = ((Char 't'):k)
eventToKey (EventKey (Char 'g') Down _ _) k = ((Char 'g'):k)
eventToKey (EventKey (Char 'f') Down _ _) k = ((Char 'f'):k)
eventToKey (EventKey (Char 'h') Down _ _) k = ((Char 'h'):k)
eventToKey (EventKey (Char 'i') Down _ _) k = ((Char 'i'):k)
eventToKey (EventKey (Char 'k') Down _ _) k = ((Char 'k'):k)
eventToKey (EventKey (Char 'j') Down _ _) k = ((Char 'j'):k)
eventToKey (EventKey (Char 'l') Down _ _) k = ((Char 'l'):k)
eventToKey (EventKey (SpecialKey KeyUp) Down _ _) k = ((SpecialKey KeyUp):k)
eventToKey (EventKey (SpecialKey KeyDown) Down _ _) k = ((SpecialKey KeyDown):k)
eventToKey (EventKey (SpecialKey KeyLeft) Down _ _) k = ((SpecialKey KeyLeft):k)
eventToKey (EventKey (SpecialKey KeyRight) Down _ _) k = ((SpecialKey KeyRight):k)
eventToKey (EventKey key Up  _ _) k = removeKey key k
eventToKey _ k = k

eventToKeyZ :: Event -> [Key] ->[Key]
eventToKeyZ (EventKey (Char 'w') Down _ _) k = ((Char 'w'):k)
eventToKeyZ (EventKey (Char 's') Down _ _) k = ((Char 's'):k)
eventToKeyZ (EventKey (Char 'a') Down _ _) k = ((Char 'a'):k)
eventToKeyZ (EventKey (Char 'd') Down _ _) k = ((Char 'd'):k)
eventToKeyZ (EventKey (Char '1') Down _ _) k = ((Char '1'):k)
eventToKeyZ (EventKey (Char ',') Down _ _) k = ((Char ','):k)
eventToKeyZ (EventKey (SpecialKey KeyUp) Down _ _) k = ((SpecialKey KeyUp):k)
eventToKeyZ (EventKey (SpecialKey KeyDown) Down _ _) k = ((SpecialKey KeyDown):k)
eventToKeyZ (EventKey (SpecialKey KeyLeft) Down _ _) k = ((SpecialKey KeyLeft):k)
eventToKeyZ (EventKey (SpecialKey KeyRight) Down _ _) k = ((SpecialKey KeyRight):k)
eventToKeyZ (EventKey key Up  _ _) k = removeKey key k
eventToKeyZ _ k = k