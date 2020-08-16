
module View where

-- (0) Imports -----------------------------------------------------------------

import Battlefields
import Cp
import Double as D
import Direction
import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Interface.Pure.Game
import Hextuple as H
import Map
import Matrix as M
import List as L
import Pentuple as P
import Player
import State
import Triple as T

-- (1) Datatype definition -----------------------------------------------------

type Bots = (Bool,Bool,Bool,Bool)

type ID = Int

type View = (State,[[Picture]])

test pics = (scw,pics)

side = 25

empty = Translate (-12.5) (-12.5)
        $ Color black 
        ( Polygon [(0,0),(side,0),(side,side),(0,side),(0,0)])

height = (-412.5) 

width = (-512.5)

-- (2) draw --------------------------------------------------------------------

quarter = Scale 0.5 0.5

draw view = picture          
  where picture   = Pictures (m4p ++ players)
        players   = ( map put1   -- [Picture]
                    . map swap   -- [(Player,Int)]
                    . zip [0..3] -- [(Int,Player)]
                    . T.get1   -- [Player]
                    . outState -- Triple
                    ) state    -- State
        put1      = uncurry             -- Picture
                    (uncurry Translate) -- Picture
                    . (grid >< tanks)   -- (Coordinate,Picture)  
                    . split             -- (Position,(Int,Direction,Picture)) 
                    (H.get0 . p1)
                    (trident (H.get2 . p1) (H.get1 . p1) p2)
                    . ( outPlayer ><    -- (Hextuple,Picture) 
                    ( uncurry (M.!!!)   -- (Player,Picture)
                    . curry swap pics   -- (Player,((Int,Int),[[Pictures]]))
                    . split one id))    -- (Player,(Int,Int))
        grid      = (D.sum (width,height) -- Coordinate
                    . scalarMult 25       -- Coordinate
                    . (float >< float)    -- Coordinate
                    . swap)               -- Position
        tanks     = cond ((<= 0) . T.get0)
                    (const Blank)                       -- Picture
                    ( uncurry Rotate                    -- Picture
                    . split (degree . T.get1) (T.get2)) -- (Float,Picture)
        m4p       = ( map put0      -- [Picture]
                    . zip positions -- [(Position,Block)]
                    . concat        -- [Block]
                    . T.get0        -- Map
                    . outState      -- Triple
                    ) state         -- State
        positions = ( M.positions -- [(Int,Int)] 
                    . T.get0      -- Map
                    . outState    -- Triple
                    ) state       -- State
        put0      = uncurry (uncurry Translate) -- Picture
                      . ((D.sum (width,height)  -- (Coordinate,Picture)
                      . scalarMult 25           -- (Coordinate,Picture)
                      . (float >< float)        -- (Coordinate,Picture)
                      . swap)                   -- (Position,Picture)
                      >< (quarter . textures))  -- (Position,Picture)
        textures  = uncurry texture  -- Picture
                    . curry swap     -- (Block,[Picture])
                    ((L.!!!) 0 pics) -- (Block,[Picture])
        float x   = fromIntegral x :: Float
        state     = p1 view -- State
        pics      = p2 view -- [[Picture]]

texture (Wall Unbreakable) = (L.!!!) 0
texture (Wall Breakable)   = (L.!!!) 1
texture (Water)            = (L.!!!) 2
texture (Bush)             = (L.!!!) 3
texture (TNT)              = (L.!!!) 4
texture (Empty)            = const View.empty
