
-- (c) MP-I (1998/9-2006/7) and CP (2005/6-2019/20)

module List where

import Cp
import Nat hiding (fac)

-- (1) Datatype definition -----------------------------------------------------

--- Haskell lists are already defined, so the following is a dummy, informal declaration:
--- data [a] = [] | (a : [a])

inList = either nil cons

outList []    = i1 ()
outList (a:x) = i2(a,x)

baseList g f = id -|- g >< f

-- (2) Ana + cata + hylo -------------------------------------------------------

recList  f   = id -|- id >< f                   -- this is F f for this data type

cataList g   = g . recList (cataList g) . outList   

anaList  g   = inList . recList (anaList g) . g

hyloList f g = cataList f . anaList g

-- (3) Map ---------------------------------------------------------------------
-- NB: already in the Haskell Prelude

-- (4) Examples ----------------------------------------------------------------

-- (4.01) (!!) -----------------------------------------------------------------

(!!!) x = (uncurry (!!)) . (curry swap x)

-- (4.02) replace --------------------------------------------------------------

replace x y = cataList $ either nil  (cons . ((cond (==x) (const y) id) >< id))

-- (4.03) update ---------------------------------------------------------------

update 0 x = (curry cons x) . tail
update i x = cons . split head (update (i-1) x)


-- (4.04) apply ---------------------------------------------------------------

ap f i0 l = [if i1 == i0 then f x else x | (i1, x) <- zip [1..] l]

-- (4.1) number representation (base b) evaluator ------------------------------

eval b = cataList (either zero (add.(id><(b*))))

-- eval b [] = 0
-- eval b (x:xs) = x + b * (eval b xs)

-- (4.2) inversion -------------------------------------------------------------

reverse' = cataList (either nil snoc) where snoc(a,l) = l ++ [a]

-- alternatively: snoc = conc . swap . (singl >< id)
--                       where singl a = [a]
--                             conc = uncurry (++)

-- (4.3) Look-up function ------------------------------------------------------

lookup :: Eq a => a -> [(a,b)] -> Maybe b
lookup k = cataList (either nothing aux)
           where nothing = const Nothing
                 aux((a,b),r)
                    | a == k    = Just b
                    | otherwise = r

-- (4.4) Insertion sort --------------------------------------------------------

iSort :: Ord a => [a] -> [a]
iSort =  cataList (either nil insert)
         where insert(x,[])              = [x]
               insert(x,a:l) | x < a     = [x,a]++l
                             | otherwise = a:(insert(x,l))

-- also iSort = hyloList (either (const []) insert) outList

-- (4.5) take (cf GHC.List.take) -----------------------------------------------

utake = anaList aux
         where aux(0,_) = i1()
               aux(_,[]) = i1()
               aux(n,x:xs) = i2(x,(n-1,xs))

-- pointwise version:
-- take 0 _ = []
-- take _ [] = []
-- take (n+1) (x:xs) = x : take n xs

-- (4.6) Factorial--------------------------------------------------------------

fac :: Integer -> Integer
fac = hyloList (either (const 1) mul) natg

natg = (id -|- (split succ id)) . outNat

-- (4.6.1) Factorial (alternative) ---------------------------------------------

fac' = hyloList (either (const 1) (mul . (succ >< id)))
                 ((id -|- (split id id)) . outNat)

{-- cf:

fac' = hyloList (either (const 1) g) natg'
       where g(n,m) = (n+1) * m
             natg' 0 = i1 ()
             natg' (n+1) = i2 (n,n)
--}

-- (4.7) Square function -------------------------------------------------------

sq = hyloList summing oddd

summing = either (const 0) add

evens = anaList evend

odds  = anaList oddd

evend = (id -|- (split (2*) id)) . outNat

oddd  = (id -|- (split odd id)) . outNat
       where odd n = 2*n+1

{-- pointwise:
sq 0 = 0
sq (n+1) = 2*n+1 + sq n

cf. Newton's binomial: (n+1)^2 = n^2 + 2n + 1
--}

-- (4.7.1) Square function reusing anaList of factorial ----------------------------

sq' = (cataList summing) . fmap (\n->2*n-1) . (anaList natg)

-- (4.8) Prefixes and suffixes -------------------------------------------------

prefixes :: Eq a => [a] -> [[a]]
prefixes = cataList (either (const [[]]) scan)
           where scan(a,l) = [[]] ++ (map (a:) l)

suffixes = anaList g
           where g = (id -|- (split cons p2)).outList

diff :: Eq a => [a] -> [a] -> [a]
diff x l = cataList (either nil (g l)) x
           where g l (a,x) = if (a `elem` l) then x else (a:x)

-- (4.9) Grouping --------------------------------------------------------------

chunksOf' :: Int -> [a] -> [[a]]
chunksOf' n = anaList (g n) where
          g 0 = i1 . (!)
          g n = i2 . split (take n) (drop n)

nest = chunksOf'

-- (4.10) Relationship with foldr, foldl ----------------------------------------

myfoldr :: (a -> b -> b) -> b -> [a] -> b
myfoldr f u = cataList (either (const u) (uncurry f))

myfoldl :: (a -> b -> a) -> a -> [b] -> a
myfoldl f u = cataList' (either (const u) (uncurry f . swap))
              where cataList' g   = g . recList (cataList' g) . outList'   
                    outList' [] = i1()
                    outList' x =i2(last x, blast x)
                    blast = tail . reverse

-- (4.11) No repeats ------------------------------------------------------------

nr :: Eq a => [a] -> Bool
nr = p2 . aux where
     aux = cataList (either f (split g h))
     f _ = ([],True)
     g(a,(t,b)) = a:t
     h(a,(t,b)) = not(a `elem` t) && b

-- (4.12) Advanced --------------------------------------------------------------

-- (++) as a list catamorphism ------------------------------------------------

ccat :: [a] -> [a] -> [a]
ccat = cataList (either (const id) compose). map (:) where
       -- compose(f,g) = f.g
       compose =  curry(Cp.ap.(id><Cp.ap).assocr)

-- monadic map
mmap f = cataList $ either (return.nil)(fmap cons.dstr.(f><id))

-- distributive law
lam  :: Strong m => [m a] -> m [a]
lam = cataList ( either (return.nil)(fmap cons.dstr) )

-- monadic catas

mcataList :: Strong ff => (Either () (b, c) -> ff c) -> [b] -> ff c
mcataList g = g .! (dl . recList (mcataList g) . outList)   

dl :: Strong m => Either () (b, m a) -> m (Either () (b, a))
dl = either (return.i1)(fmap i2. lstr)

--lam' = mcataList (either (return.nil)(fmap cons.rstr))

-- streaming -------------------------------------------------------------------

stream f g c x = case f c of
   Just (b, c') -> b : stream f g c' x
   Nothing      ->  case x of
                      a:x' -> stream f g (g c a) x'
                      []   -> []

-- heterogeneous lists ---------------------------------------------------------

join :: ([a], [b]) -> [Either a b]
join (a, b) = map i1 a ++ map i2 b
sep = split s1 s2 where
   s1 []=[]; s1(Left a:x) = a:s1 x; s1(Right b:x)=s1 x
   s2 []=[]; s2(Left a:x) = s2 x; s2(Right b:x)=b:s2 x
---- end of List.hs ------------------------------------------------------------
