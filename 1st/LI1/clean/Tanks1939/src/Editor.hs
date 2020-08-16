
module Editor where

-- (0) Imports -----------------------------------------------------------------

import Cp
import Direction
import Double
import Pentuple
import Map
import Matrix
import Tetromino

-- (1) Datatype definition -----------------------------------------------------

-- | The internal state of a map editor.
data Editor = Editor
    { editorPosition   :: Position  -- ^ cursor 'Position' given as the current Tetromino's top left corner. 
    , editorDirection  :: Direction -- ^ 'Direction' of the current 'Tetromino'.
    , editorTetromino  :: Tetromino -- ^ Type of the current 'Tetromino'.
    , editorBlock      :: Block     -- ^ Type of the current 'Wall'.
    , editorMap        :: Map       -- ^ Current 'Map'.
    }
  deriving (Read,Show,Eq)

outEditor (Editor p d t w m) = (p,d,t,w,m)

inEditor (p,d,t,b,m) = (Editor p d t b m)

baseEditor0 f = inEditor . ap0 f . outEditor
baseEditor1 f = inEditor . ap1 f . outEditor
baseEditor2 f = inEditor . ap2 f . outEditor
baseEditor3 f = inEditor . ap3 f . outEditor
baseEditor4 f = inEditor . ap4 f . outEditor

-- | A sequence of instructions give birth to a map.
type Instructions = [Instruction]

-- | An instruction given to an editor.
data Instruction
   = Move Direction  -- ^ Moves the cursor in a given 'Direction'
   | Rotate          -- ^ Rotates the 'Tetromino' clock-wise.
   | ChangeTetromino -- ^ Changes to the next type of 'Tetromino'.
   | ChangeBlock     -- ^ Changes to the next type of 'Block'.
   | Draw            -- ^ Draws the 'Tetromino' with the current features.
  deriving (Read,Show,Eq)

-- (2) Functions ---------------------------------------------------------------

instruction (Move d)        = baseEditor0 $ uncurry Double.sum 
                                          . (id >< vector) 
                                          . toPair01
instruction Rotate          = baseEditor1 $ Direction.rotate . get1
instruction ChangeTetromino = baseEditor2 $ Tetromino.next . get2
instruction ChangeBlock     = baseEditor3 $ Editor.next . get3
instruction Draw            = baseEditor4 $ draw

draw tuple = ( foldr (uncurry update) m4p                 -- Map
             . map ((Double.sum position)><(const block)) -- [((Int,Int),Block)]
             . filter (p2)                                -- [((Int,Int),Bool)]
             . uncurry zip                                -- [((Int,Int),Bool)]
             . split positions concat                     -- ([Int,Int],[Bool])
             . Editor.rotate diretion                     -- [[Bool]]
             . matrix                                     -- [[Bool]]
             . get2) tuple                                -- Tetromino
  where position  = get0 tuple
        diretion  = get1 tuple                        
        block     = get3 tuple
        m4p      = get4 tuple

rotate Up  = id
rotate Rgt = rotateR
rotate Dow = rotateR . rotateR
rotate Lft = rotateL

next (Wall Unbreakable) = (Wall Breakable)
next (Wall Breakable)   = Empty
next Empty              = Water
next Water              = Bush
next Bush               = (Wall Unbreakable)

instructions list editor = foldr instruction editor list

initialEditor = ( inEditor
                . uncurry ap4                  
                . (const >< id)                                 
                . curry swap ((0,0),Up,I,(Wall Unbreakable),[])
                . initialMap)                  

build :: Instructions -> Map
build = ( get4
        . outEditor
        . uncurry instructions
        . curry swap (initialEditor (5,5)))
