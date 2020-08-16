module Show where

showL :: Show a => Int -> a -> String
showL n x = s++rep (n-length s) ' '
            where s=show x

showR :: Show a => Int -> a -> String
showR n x = rep (n-length s) ' '++s
            where s=show x

--showP :: Float -> String
--showP f =  showR 3 (round (f*100))++"%"

rep :: Int -> a -> [a]
rep n x = take n (repeat x)

