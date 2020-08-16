
module Double where

-- (0) Imports -----------------------------------------------------------------

-- (1) Datatype definition -----------------------------------------------------


type Dimension    = (Int,Int)
type Position     = (Int,Int)
type GridPosition = (Int,Int)

type Vector       = (Float,Float)
type Coordinate   = (Float,Float)

-- (2) Vector Functions --------------------------------------------------------

sum (x0,y0) (x1,y1) = (x0+x1,y0+y1)

sub (x0,y0) (x1,y1) = (x0+x1,y0+y1)

(scalarMult) alpha (x,y) = (alpha*x,alpha*y)

rotate (l,c) = (c,-l)

reverseH (l,c) = (l,-c)

reverseV (l,c) = (-l,c)
