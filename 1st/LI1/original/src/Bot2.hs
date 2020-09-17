module Bot2 where

import DataStruct
import Functions
import MapEditor
import Data.List 

bot :: Int    -- ^ O identificador do 'Jogador' associado ao ro'bot'.
    -> Estado -- ^ O 'Estado' para o qual o ro'bot' deve tomar uma decisão.
    -> Jogada -- ^ Uma possível 'Jogada' a efetuar pelo ro'bot'.
bot n e@(Estado m je de) | vj == 0 = None
                       	 | otherwise = decisão e j n de
                       	 where j@(Jogador pj dj vj lj cj) = encontraIndiceLista n je