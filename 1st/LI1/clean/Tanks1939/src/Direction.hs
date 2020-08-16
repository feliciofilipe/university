

module Direction where

-- | A Direction in a 2D world.
data Direction
    = Up    -- ^ Up.
    | Rgt    -- ^ Right.
    | Dow    -- ^ Down.
    | Lft    -- ^ Left.
  deriving (Read,Show,Eq,Enum,Bounded)

vector Up  = (1,0)
vector Rgt = (0,1)
vector Dow = (-1,0)
vector Lft = (0,-1)

rotate Up  = Rgt
rotate Rgt = Dow
rotate Dow = Lft
rotate Lft = Up

degree Up = 180
degree Rgt = 270
degree Dow = 0
degree Lft = 90
