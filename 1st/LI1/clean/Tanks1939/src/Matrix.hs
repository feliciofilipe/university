
module Matrix where

import Cp
import List

-- (1) Datatype definition -----------------------------------------------------

type Matrix a = [[a]]


-- (2) Ana + cata + hylo -------------------------------------------------------

cataMatrix g = cataList g

anaMatrix g = anaList g

hyloMatrix f g = cataMatrix f . anaMatrix g

-- (3) Functions ---------------------------------------------------------------

transpose []             = []
transpose ([]     : xss) = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:t) <- xss]) : transpose (xs : [t | (h:t) <- xss])

rotateR = transpose . reverse

rotateL = reverse . transpose

reverseH = cataMatrix $ either nil (cons . (reverse><id))

reverseV = reverse

replicate (x,y) = Prelude.replicate x . Prelude.replicate y

(!!!) (0,j) = (List.!!!) j . head
(!!!) (i,j) = (Matrix.!!!) (i-1,j) . tail

update (0,j) x = cons . split (List.update j x . head) tail
update (i,j) x = cons . split head (Matrix.update (i-1,j) x . tail)

size :: Matrix a -> (Int,Int)
size = split (length) (length.head)

positions m = [(i,j) | i <- [0..lines], j <- [0..collumns]]
  where lines = (p1 . size) m - 1
        collumns = (p2 . size) m - 1
