
-- (c) MP-I and CP (1998/99-2016/17)

module St where

------------------------------------------------------------------
-- NB: This is a small, pointfree "summary" of Control.Monad.State
------------------------------------------------------------------

import Cp
import Control.Applicative

data St s a = St { st :: (s -> (a, s)) } -- St / st are the In / out of this type

inSt  = St
outSt = st

-- cf. with    data Func s a = F { func  ::  s -> a  }

-- NB: "values" of this monad are actions rather than states.
--     So this should be called the "action monad" and not the
--     "state monad".
--     (Unfortunately, it is to late to change terminology.)

instance Monad (St s) where
         return      = St . (curry id)
-- ie:   return a    = St (\s -> (a,s))

         (St x) >>= g = St (uncurry(st . g) . x )
{-- ie:
         (St x) >>= g = St (\s -> let (a,s') = x s
                                      St k   = g a
                                  in k s')
--}

instance Functor (St s) where
         fmap f t = do { a <- t ; return (f a) }  -- as in every monad
-- ie:   fmap f (St g) = St(\s -> let (a,s') = g s in (f a,s'))

instance Strong (St s)

instance Applicative (St s) where
   (<*>) = curry(fmap ap . dstr)
   pure  = return

-- action execution

exec :: St s  a -> s -> (a, s)
exec   (St g) s =  g s          -- splits evalState and execState

-- generic actions 

get   :: St s s                    -- as in class MonadState
get = St(split id id) 

modify :: (s -> s) -> St s ()
modify f = St(split (!) f)

put :: s -> St s ()                -- as in class MonadState
put s = modify (const s)

query :: (s -> a) -> St s a
query f = St(split f id)

trans :: (s -> s) -> (s -> a) -> St s a -- a simple transation
trans g f = do { modify g ; query f }

-- actions with input

meth :: ((a, s) -> (b, s)) -> a -> St s b
meth f = St.(curry f)  -- create "method" from function

-- update state, then query 

updfst :: (a -> s -> s) -> (a -> s -> b) -> a -> St s b
updfst g f a = St (split (f a) id . (g a))

-- updfst g f a = do { modify (g a) ; query (f a)}

-- example (ATM credit)

credit = updfst (+) (bal) 
           where bal a s = "credited= "++show a ++ ", bal= "++ show s

-- query state, then update

qryfst :: (a -> s -> s) -> (a -> s -> b) -> a -> St s b
qryfst g f a = St(split (f a) (g a))

-- qryfst g f a = do { b <- query (f a); modify (g a) ; return b }

-- example (pop)
pop_action = qryfst (\_ -> tail) (\_ -> head)

-- execute forever

loop :: Monad m => m a -> m b
loop x = do { x ; loop x }

