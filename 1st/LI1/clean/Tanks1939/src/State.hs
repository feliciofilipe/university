
module State where

-- (0) Imports -----------------------------------------------------------------

import Cp
import Direction as Dir
import Double as D
import Hextuple as H
import List as L
import Map
import Matrix as M
import Player
import Triple as T
import Shot

-- (1) Datatype definition -----------------------------------------------------

-- | Game State.
data State = State
    { stateMap     :: Map      -- ^ Game's 'Map'.
    , statePlayers :: [Player] -- ^ Game's 'Player's.
    , stateShots   :: [Shot]   -- ^ Game's active 'Shot's. 
    }
  deriving (Read,Show,Eq)

outState (State m p s) = (m,p,s)

inState (m,p,s) = (State m p s)

baseState0 f = inState . T.ap0 f . outState
baseState1 f = inState . T.ap1 f . outState
baseState2 f = inState . T.ap2 f . outState

-- (2) Functions ---------------------------------------------------------------

-- (2.1) Play ------------------------------------------------------------------

play i (Move direction) = baseState1 
                        $ cond ((/= direction) -- Bool
                               . H.get1        -- Direction
                               . outPlayer     -- HexTuple
                               . (L.!!!) i     -- Player
                               . T.get1)       -- [Player]
                        (move i direction) (L.ap (basePlayer1
                                           (const direction)) i
                                           . T.get1)
play i (Shoot weapon)   = cond (hasAmmo    -- Bool
                               . outPlayer -- HexTuple
                               . (L.!!!) i -- Player
                               . T.get1    -- [Player]
                               . outState) -- Triple 
                               (shoot i weapon) id
  where hasAmmo = case weapon of
                    Laser  -> (> 0) . get3
                    Gas    -> (> 0) . get4
                    Normal -> const True

move i direction tuple = L.ap new i players
  where players     = T.get1 tuple
        new         = basePlayer0 (cond validMove translation H.get0)
        m4p         = (const . T.get0) tuple
        translation = D.sum (Dir.vector direction) . H.get0
        validMove   = uncurry (&&)                           -- Bool
                      . (validBlock >< validBlock)           -- (Bool,Bool)
                      . (uncurry (M.!!!) >< uncurry (M.!!!)) -- (Block,Block)
                      . (split id m4p >< split id m4p)       -- (Position,Map)^2
                      . face direction                       -- Position^2
                      . H.get0                               -- Position
        validBlock  = or                                        -- Bool
                      . (<*>) [(== Empty),(== Water),(== Bush)] -- [Bool]
                      . pure                                    -- f Block

shoot i weapon state = (players . shots) state
  where players   = case weapon of
                      Laser  -> baseState1 $ 
                                L.ap (basePlayer3 (pred . H.get3)) i
                                . T.get1
                      Gas    -> baseState1 $ 
                                      L.ap (basePlayer4 (pred . H.get4)) i
                                      . T.get1
                      Normal -> id
        shots     = baseState2 $ curry cons shot 
                               . T.get2
        shot      = case weapon of 
                      Laser  -> inLaser(i,position,direction)
                      Gas    -> inGas(i,time)
                      Normal -> inNormal(i,position,direction)
        position  = ( uncurry D.sum           -- Position
                    . (id >< Dir.vector)      -- GridPosition^2
                    . split (H.get0) (H.get1) -- (GridPosition,Direction)  
                    . outPlayer               -- HexTuple
                    . (L.!!!) i               -- Player
                    . T.get1                  -- [Player]
                    . outState                -- Triple
                    ) state                   -- State
        direction = ( H.get1        -- Direction  
                    . outPlayer     -- HexTuple
                    . (L.!!!) i     -- Player
                    . T.get1        -- [Player] 
                    . outState      -- Triple
                    ) state         -- State
        time      = 10
       
