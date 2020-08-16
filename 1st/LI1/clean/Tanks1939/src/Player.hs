
-- | This module defines a game's player.
module Player where

-- (0) Imports -----------------------------------------------------------------

import Cp
import Direction
import Double as D
import Hextuple
import Shot

-- (1) Datatype definition -----------------------------------------------------

-- | A game's player.
data Player = Player
    { playerPosition  :: GridPosition -- ^ Player's 'Position'.
    , playerDirection :: Direction    -- ^ Player's 'Direction'.
    , playerHealth    :: Int          -- ^ Player's Health.
    , playerLasers    :: Int          -- ^ Player's 'Laser's.
    , playerShocks    :: Int          -- ^ Player's 'Shock's.
    , playerGun       :: Gun          -- ^ Player's 'Gun'.
    }
  deriving (Read,Show,Eq)

outPlayer (Player p d h l g w) = (p,d,l,h,g,w)

inPlayer (p,d,l,h,g,w) = (Player p d h l g w)

basePlayer0 f = inPlayer . ap0 f . outPlayer
basePlayer1 f = inPlayer . ap1 f . outPlayer
basePlayer2 f = inPlayer . ap2 f . outPlayer
basePlayer3 f = inPlayer . ap3 f . outPlayer
basePlayer4 f = inPlayer . ap4 f . outPlayer
basePlayer5 f = inPlayer . ap5 f . outPlayer

data Gun = Faca | AK47 | Strike | Pistol | M8A1
  deriving (Read,Show,Eq,Enum,Bounded)  


data Play
    = Move Direction  -- ^ Move o jogador numa dada 'Direcao'.
    | Shoot Weapon    -- ^ Dispara uma 'Arma'.
    | Load
    | Buy
    | ChangeGun
    | Stab
    | None
  deriving (Read,Show,Eq)

-- (2) Functions ---------------------------------------------------------------

face Up  = split (D.sum (-1,0)) (D.sum (-1,1))
face Rgt = split (D.sum (0,2)) (D.sum (1,2))
face Dow = split (D.sum (2,0)) (D.sum (2,1))
face Lft = split (D.sum (0,-1)) (D.sum (1,-1))

