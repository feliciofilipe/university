
module Hextuple where

import Cp

get0 (a,b,c,d,e,f) = a
get1 (a,b,c,d,e,f) = b
get2 (a,b,c,d,e,f) = c
get3 (a,b,c,d,e,f) = d
get4 (a,b,c,d,e,f) = e
get5 (a,b,c,d,e,f) = f

toPair00 = split (get0) (get0)
toPair01 = split (get0) (get1)
toPair02 = split (get0) (get2)
toPair03 = split (get0) (get3)
toPair04 = split (get0) (get4)
toPair05 = split (get0) (get5)
toPair10 = split (get1) (get0)
toPair11 = split (get1) (get1)
toPair12 = split (get1) (get2)
toPair13 = split (get1) (get3)
toPair14 = split (get1) (get4)
toPair15 = split (get1) (get5)
toPair20 = split (get2) (get0)
toPair21 = split (get2) (get1)
toPair22 = split (get2) (get2)
toPair23 = split (get2) (get3)
toPair24 = split (get2) (get4)
toPair25 = split (get2) (get5)
toPair30 = split (get3) (get0)
toPair31 = split (get3) (get1)
toPair32 = split (get3) (get2)
toPair33 = split (get3) (get3)
toPair34 = split (get3) (get4)
toPair35 = split (get3) (get5)
toPair40 = split (get4) (get0)
toPair41 = split (get4) (get1)
toPair42 = split (get4) (get2)
toPair43 = split (get4) (get3)
toPair44 = split (get4) (get4)
toPair45 = split (get4) (get5)
toPair50 = split (get5) (get0)
toPair51 = split (get5) (get1)
toPair52 = split (get5) (get2)
toPair53 = split (get5) (get3)
toPair54 = split (get5) (get4)
toPair55 = split (get5) (get5)

set0 x (a,b,c,d,e,f) = (x,b,c,d,e,f)
set1 x (a,b,c,d,e,f) = (a,x,c,d,e,f)
set2 x (a,b,c,d,e,f) = (a,b,x,d,e,f)
set3 x (a,b,c,d,e,f) = (a,b,c,x,e,f)
set4 x (a,b,c,d,e,f) = (a,b,c,d,x,f)
set5 x (a,b,c,d,e,f) = (a,b,c,d,e,x)

ap0 f tuple = set0 (f tuple) tuple
ap1 f tuple = set1 (f tuple) tuple
ap2 f tuple = set2 (f tuple) tuple
ap3 f tuple = set3 (f tuple) tuple
ap4 f tuple = set4 (f tuple) tuple
ap5 f tuple = set5 (f tuple) tuple
