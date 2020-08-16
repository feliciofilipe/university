module ListUtils where


-- create a singleton list
-- 
singleton :: a -> [a]
singleton x = [x]


-- create a list of length n
-- 
--replicate :: Int -> a -> [a]
--replicate n x = take n (repeat x)


-- apply a function to the nth element of a list
-- 
onNth :: Int -> (a -> a) -> [a] -> [a]
-- onNth n f xs | n<1 = xs
-- onNth 1 f (x:xs)   = f x:xs
-- onNth n f (x:xs)   = x:onNth (n-1) f xs

onNth n f xs | n<1 = xs
onNth n f xs = case splitAt (n-1) xs of
                 (ys,[])    -> ys
                 (ys,z:zs') -> ys++f z:zs' 
