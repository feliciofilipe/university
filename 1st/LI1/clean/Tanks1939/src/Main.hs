
module Main where

-- (0) Imports -----------------------------------------------------------------

import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Interface.Pure.Game
import View

-- (1) Main --------------------------------------------------------------------

fr = 25

dm = FullScreen

time _ s = s

event _ s = s  

textures = "../images/textures/"
tanks    = "../images/tanks/"

main = do
       tx0 <- loadBMP $ textures ++ "tx0.bmp"
       tx1 <- loadBMP $ textures ++ "tx1.bmp"
       tx2 <- loadBMP $ textures ++ "tx2.bmp"
       tx3 <- loadBMP $ textures ++ "tx3.bmp"
       tx4 <- loadBMP $ textures ++ "tx4.bmp"
       let txs = [tx0,tx1,tx2,tx3,tx4]
       tank0 <- loadBMP $ tanks ++ "tank0.bmp"
       tank1 <- loadBMP $ tanks ++ "tank1.bmp"
       tank2 <- loadBMP $ tanks ++ "tank2.bmp"
       tank3 <- loadBMP $ tanks ++ "tank3.bmp"
       let tanks = [tank0,tank1,tank2,tank3]
       play dm
            black
            fr
            (test [txs,tanks])
            draw
            event
            time
