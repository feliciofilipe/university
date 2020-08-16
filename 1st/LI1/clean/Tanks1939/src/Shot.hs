
module Shot where

-- (0) Imports -----------------------------------------------------------------

import Direction
import Triple
import Double

-- (1) Datatype definition -----------------------------------------------------

data Shot
    = NormalShot
        { shotPlayer   :: Int                 -- ^ 
        , shotPosition :: GridPosition        -- ^ 
        , shotDiretion :: Direction           -- ^ 
        }
    | LaserShot
        { shotPlayer   :: Int                 -- ^ 
        , shotPosition :: GridPosition        -- ^ 
        , shotDiretion :: Direction           -- ^ 
        }
    | GasShot
        { shotPlayer :: Int                   -- ^ 
        , shotTime   :: Ticks                 -- ^
        }
  deriving (Read,Show,Eq)

outNormal (NormalShot i p d) = (i,p,d)

inNormal (i,p,d) = (NormalShot i p d)

outLaser (LaserShot i p d) = (i,p,d)

inLaser (i,p,d) = (LaserShot i p d)

outGas (GasShot i t) = (i,t)

inGas (i,t) = (GasShot i t)

data Weapon = Normal | Laser | Gas
  deriving (Read,Show,Eq,Enum,Bounded)

type Ticks = Int
