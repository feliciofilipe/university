
-- | This module defines the game Data Structs.
module Map where

-- (0) Imports -----------------------------------------------------------------

import Cp

-- (1) Datatype definition -----------------------------------------------------

-- | A Map is a matrix of blocks.
type Map = [[Block]]

-- | A block unit of a map.
data Block
    = Wall WallType -- ^ A 'Block' of 'Wall'.
    | Empty         -- ^ A 'Block' of 'Empty'.
    | Water         -- ^ A 'Block' of 'Water'.
    | Bush          -- ^ A 'Block' of 'Bush'.
    | TNT           -- ^ A 'Block' of 'TNT'.
    | Door          -- ^ A 'Block' of 'Door'.
    | VM VMType     -- ^ A 'Block' of 'VM'.
    | V Int         -- ^ A 'Block' of 'V'.
  deriving (Read,Show,Eq)

-- | Types of a map wall.
data WallType = Unbreakable | Breakable
  deriving (Read,Show,Eq,Enum,Bounded)

-- | Types of a map VM.
data VMType = Juggernog
            | SpeedCola 
            | Ammo
            | MedKit
            | SelfRevive
            | DoubleTap
            | AK47
            | M8A1
  deriving (Read,Show,Eq)

-- (2.1) Initial Map -----------------------------------------------------------

initialMap (x,y) = ( curry cons (outside)
                   . reverse
                   . curry cons (outside)
                   . Prelude.replicate x) inside
  where outside = Prelude.replicate y (Wall Unbreakable)
        inside  = ( curry cons (Wall Unbreakable)
                  . reverse
                  . curry cons (Wall Unbreakable)
                  . Prelude.replicate (y-2)) (Empty)

