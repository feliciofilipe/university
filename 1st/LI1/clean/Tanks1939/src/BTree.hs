{-# OPTIONS_GHC -XNPlusKPatterns #-}

-- (c) MP-I (1998/9-2006/7) and CP (2005/6-2019/20)

module BTree where

import Cp
import Data.List
import Data.Monoid

-- (1) Datatype definition -----------------------------------------------------

data BTree a = Empty | Node(a, (BTree a, BTree a)) deriving Show

inBTree :: Either () (b,(BTree b,BTree b)) -> BTree b
inBTree = either (const Empty) Node

outBTree :: BTree a -> Either () (a,(BTree a,BTree a))
outBTree Empty              = Left ()
outBTree (Node (a,(t1,t2))) = Right(a,(t1,t2))

baseBTree g f = id -|- g >< (f >< f)

-- (2) Ana + cata + hylo -------------------------------------------------------

recBTree f = baseBTree id f

cataBTree g = g . (recBTree (cataBTree g)) . outBTree

anaBTree g = inBTree . (recBTree (anaBTree g) ) . g

hyloBTree f g = cataBTree f . anaBTree g

-- (3) Map ---------------------------------------------------------------------

instance Functor BTree
         where fmap f = cataBTree ( inBTree . baseBTree f id )

-- equivalent to:
--       where fmap f = anaBTree ( baseBTree f id . outBTree )

-- (4) Examples ----------------------------------------------------------------

-- (4.1) Inversion (mirror) ----------------------------------------------------

mirrorBTree = cataBTree (inBTree . (id -|- id >< swap))

-- (4.2) Count and depth -------------------------------------------------------

countBTree = cataBTree (either (const 0) (succ . (uncurry (+)) . p2))

depthBTree = cataBTree (either zero (succ.umax.p2))

-- (4.3) Serialization ---------------------------------------------------------

inordt = cataBTree inord     -- in-order traversal

preordt = cataBTree preord  -- pre-order traversal

postordt = cataBTree posord -- post-order traversal

-- where

preord = either nil f where f(x,(l,r))=x:l++r
inord  = either nil f where f(x,(l,r))=l++[x]++r
posord = either nil f where f(x,(l,r))=l++r++[x]

-- (4.4) Quicksort -------------------------------------------------------------

qSort :: Ord a => [a] -> [a]
qSort = hyloBTree inord qsep -- the same as (cataBTree inord) . (anaBTree qsep)

-- where

qsep []    = i1 ()
qsep (h:t) = i2 (h,(s,l)) where (s,l) = part (<h) t

part:: (a -> Bool) -> [a] -> ([a], [a])
part p []                = ([],[])
part p (h:t) | p h       = let (s,l) = part p t in (h:s,l)
     | otherwise = let (s,l) = part p t in (s,h:l)

{-- pointwise versions:
qSort [] = []
qSort (h:t) = let (t1,t2) = part (<h) t
      in  qSort t1 ++ [h] ++ qSort t2

or, using list comprehensions:

qSort [] = []
qSort (h:t) = qSort [ a | a <- t , a < h ] ++ [h] ++ 
      qSort [ a | a <- t , a >= h ]

--}

-- (4.5) Traces ----------------------------------------------------------------

traces :: Eq a => BTree a -> [[a]]
traces = cataBTree (either (const [[]]) tunion)
   where tunion(a,(l,r)) = union (map (a:) l) (map (a:) r) 

-- (4.6) Towers of Hanoi -------------------------------------------------------

-- pointwise:
-- hanoi(d,0) = []
-- hanoi(d,n+1) = (hanoi (not d,n)) ++ [(n,d)] ++ (hanoi (not d, n))

hanoi = hyloBTree present strategy

--- where

present = inord -- same as in qSort

strategy(d,0) = Left ()
strategy(d,n+1) = Right ((n,d),((not d,n),(not d,n)))

{--
    The Towers of Hanoi problem comes from a puzzle marketed in 1883
    by the French mathematician Édouard Lucas, under the pseudonym
    Claus. The puzzle is based on a legend according to which
    there is a temple, apparently in Bramah rather than in Hanoi as
    one might expect, where there are three giant poles fixed in the
    ground. On the first of these poles, at the time of the world's
    creation, God placed sixty four golden disks, each of different
    size, in decreasing order of size. The Bramin monks were given
    the task of moving the disks, one per day, from one pole to another
    subject to the rule that no disk may ever be above a smaller disk.
    The monks' task would be complete when they had succeeded in moving
    all the disks from the first of the poles to the second and, on
    the day that they completed their task the world would come to
    an end!
    
    There is a well­known inductive solution to the problem given
    by the pseudocode below. In this solution we make use of the fact
    that the given problem is symmetrical with respect to all three
    poles. Thus it is undesirable to name the individual poles. Instead
    we visualize the poles as being arranged in a circle; the problem
    is to move the tower of disks from one pole to the next pole in
    a specified direction around the circle. The code defines H n d
    to be a sequence of pairs (k,d') where n is the number of disks,
    k is a disk number and d and d' are directions. Disks are numbered
    from 0 onwards, disk 0 being the smallest. (Assigning number 0
    to the smallest rather than the largest disk has the advantage
    that the number of the disk that is moved on any day is independent
    of the total number of disks to be moved.) Directions are boolean
    values, true representing a clockwise movement and false an anti­clockwise
    movement. The pair (k,d') means move the disk numbered k from
    its current position in the direction d'. The semicolon operator
    concatenates sequences together, [] denotes an empty sequence
    and [x] is a sequence with exactly one element x. Taking the pairs
    in order from left to right, the complete sequence H n d prescribes
    how to move the n smallest disks one­by­one from one pole to the
    next pole in the direction d following the rule of never placing
    a larger disk on top of a smaller disk.
    
    H 0     d = [],
    H (n+1) d = H n ¬d ; [ (n, d) ] ; H n ¬d.
    
    (excerpt from R. Backhouse, M. Fokkinga / Information Processing
    Letters 77 (2001) 71--76)
    
--}

-- (5) Depth and balancing (using mutual recursion) --------------------------

balBTree = p1.baldepth

baldepthBTree = p2.baldepth

baldepth = cataBTree g where
     g = either (const(True,1)) (h.(id><f))
     h(a,((b1,b2),(d1,d2))) = (b1 && b2 && abs(d1-d2)<=1,1+max d1 d2)
     f((b1,d1),(b2,d2)) = ((b1,b2),(d1,d2))

-- (6) Going polytipic -------------------------------------------------------

-- natural transformation from base functor to monoid
tnat :: Monoid c => (a -> c) -> Either () (a,(c, c)) -> c
tnat f = either (const mempty) (theta . (f >< theta))
         where theta = uncurry mappend

-- monoid reduction 

monBTree f = cataBTree (tnat f)

-- alternative to (4.2) serialization ----------------------------------------

preordt' = monBTree singl

-- alternative to (4.1) counting ---------------------------------------------

countBTree' = monBTree (const (Sum 1))

-- (7) Zipper ----------------------------------------------------------------

data Deriv a = Dr Bool a (BTree a)

type Zipper a = [ Deriv a ]

plug :: Zipper a -> BTree a -> BTree a
plug [] t = t
plug ((Dr False a l):z) t = Node (a,(plug z t,l))
plug ((Dr True  a r):z) t = Node (a,(r,plug z t))

---------------------------- end of library ----------------------------------
