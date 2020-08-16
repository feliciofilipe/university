
module Tetromino where

-- (1) Datatype definition -----------------------------------------------------

-- | The 7 tetrominos.
data Tetromino = I | J | L | O | S | T | Z
  deriving (Read,Show,Eq,Enum,Bounded)

-- (2) Functions ---------------------------------------------------------------

next I = J
next J = L
next L = O
next O = S
next S = T
next T = Z
next Z = I

matrix I = [[False,True,False,False]
           ,[False,True,False,False]
           ,[False,True,False,False]
           ,[False,True,False,False]]

matrix J = [[False,True,False]
           ,[False,True,False]
           ,[True,True,False]]

matrix L = [[False,True,False]
           ,[False,True,False]
           ,[False,True,True]]

matrix O = [[True,True]
           ,[True,True]]

matrix S = [[False,True,True]
           ,[True,True,False]
           ,[False,False,False]]

matrix T = [[False,False,False]
           ,[True,True,True]
           ,[False,True,False]]

matrix Z = [[True,True,False]
           ,[False,True,True]
           ,[False,False,False]]  
