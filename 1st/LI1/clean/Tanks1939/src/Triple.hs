
module Triple where

import Cp

get0 (a,b,c) = a
get1 (a,b,c) = b
get2 (a,b,c) = c

toPair00 = split (get0) (get0)
toPair01 = split (get0) (get1)
toPair02 = split (get0) (get2)
toPair10 = split (get1) (get0)
toPair11 = split (get1) (get1)
toPair12 = split (get1) (get2)
toPair20 = split (get2) (get0)
toPair21 = split (get2) (get1)
toPair22 = split (get2) (get2)

set0 x (a,b,c) = (x,b,c)
set1 x (a,b,c) = (a,x,c)
set2 x (a,b,c) = (a,b,x)

ap0 f tuple = set0 (f tuple) tuple
ap1 f tuple = set1 (f tuple) tuple
ap2 f tuple = set2 (f tuple) tuple

trident f g h x = (f x,g x,h x)

