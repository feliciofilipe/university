-- | Este módulo define os tipos de dados comuns a todos os alunos, tal como descrito e utilizado no enunciado do trabalho prático. 
module DataStruct where

-- * Tipos de dados auxiliares.


-- | Uma sequência de instruções que dão origem a um mapa.
type Instrucoes = [Instrucao]

-- | Uma instrução dada a um editor de mapas.
data Instrucao
    = Move Direcao  -- ^ Move o cursor numa dada 'Direcao'.
    | Roda          -- ^ Roda o 'Tetromino' 90º no sentido dos ponteiros do relógio.
    | MudaTetromino -- ^ Muda para o próximo tipo de 'Tetromino'.
    | MudaParede    -- ^ Muda para o próximo tipo de 'Parede'.
    | Desenha       -- ^ Desenha o 'Tetromino' com as propriedades actuais.
  deriving (Read,Show,Eq)

-- | Uma direção num mundo a duas dimensões.
data Direcao
    = C -- ^ Cima.
    | D -- ^ Direita.
    | B -- ^ Baixo.
    | E -- ^ Esquerda.
  deriving (Read,Show,Eq,Enum,Bounded)

-- | O estado interno de um editor de mapas.
data Editor = Editor
    { posicaoEditor :: Posicao     -- ^ 'Posicao' do cursor, dada como o canto superior esquerdo do @Tetromino@ actual.
    , direcaoEditor :: Direcao     -- ^ 'Direcao' do 'Tetromino' actual.
    , tetrominoEditor :: Tetromino -- ^ Tipo do 'Tetrimino' actual.
    , paredeEditor :: Parede       -- ^ Tipo de 'Parede' actual.
    , mapaEditor :: Mapa           -- ^ 'Mapa' actual.
    }         
  deriving (Read,Show,Eq)

-- | Uma posição no mapa dada no referencial (/linha/,/colunha/).
-- As coordenadas são dois números naturais e começam com (0,0) no canto superior esquerdo, com as linhas incrementando para baixo e as colunas incrementando para a direita:
--
-- <<http://oi64.tinypic.com/2yz0f9f.jpg posicao>>
type Posicao = (Int,Int)

data ArmaZ = Faca | AK47 | Strike | Pistol | M8A1
  deriving (Read,Show,Eq,Enum,Bounded)  

-- | Os 7 tetrominos uniláteros.
--
-- <<https://i.stack.imgur.com/XteR3.gif tetrominos>>
data Tetromino = I | J | L | O | S | T | Z
  deriving (Read,Show,Eq,Enum,Bounded)

-- | Tipo de parede do mapa.
data Parede = Indestrutivel | Destrutivel | TNT | Arbusto | Agua
  deriving (Read,Show,Eq,Enum,Bounded)

-- | Um mapa é uma matriz de blocos (colunas de linhas). 
type Mapa = [[Peca]]

-- | Uma peça unitária do mapa.
data Peca
    = Bloco Parede -- ^ Uma 'Peca' de 'Parede'.
    | Vazia        -- ^ Uma 'Peca' 'Vazia'.    
    | Porta
    | VMJuggernog
    | V0
    | VMSpeedCola
    | V1
    | VMMunicao
    | V2
    | VMMedkit
    | V3
    | VMSelfRevive
    | V4
    | VMDoubleTap
    | V5
    | VMAK47
    | V6
    | VMM8A1
    | V7
  deriving (Read,Show,Eq)

-- | A dimensão de um mapa dada como um par (/número de linhas/,/número de colunhas/).
type Dimensao = (Int,Int)

-- | Uma posição na grelha do mapa dada como um par (/linha/,/colunha/).
--
-- <<http://oi67.tinypic.com/2zrgkdj.jpg posicaogrelha>>
type PosicaoGrelha = (Int,Int)

-- | Estado do jogo.
data Estado = Estado
    { mapaEstado      :: Mapa        -- ^ 'Mapa' do jogo.
    , jogadoresEstado :: [Jogador]   -- ^ Lista de 'Jogador'es, com identificador igual ao índice na lista.
    , disparosEstado  :: [Disparo]   -- ^ Lista 'Disparo's em curso (a ordem não é relevante).
    }
  deriving (Read,Show,Eq)

-- | Um zombie do jogo
type Zombie = Jogador

-- | Uma Ronda do modo Zombies
type Ronda = Int

-- | Um jogador do jogo.
data Jogador = Jogador
    { posicaoJogador :: PosicaoGrelha   -- ^ 'Posicao' actual do jogador.
    , direcaoJogador :: Direcao         -- ^ 'Direcao' actual do jogador.
    , vidasJogador   :: Int             -- ^ Número de vidas que o jogador tem (>= 0).
    , lasersJogador  :: Int             -- ^ Número de munições de 'Laser's que o jogador tem (>= 0).
    , choquesJogador :: Int             -- ^ Número de munições de 'Choque's que o jogador tem (>= 0).
    , armaJogador :: ArmaZ               -- ^ Arma do jogador (relevante apenas no Modo Zombie)
    }
  deriving (Read,Show,Eq)

-- | Um disparo em curso no jogo.
data Disparo
    = DisparoCanhao
        { jogadorDisparo :: Int                 -- ^ Identificador do 'Jogador' que disparou.
        , posicaoDisparo :: PosicaoGrelha       -- ^ Posição da bala.
        , direcaoDisparo :: Direcao             -- ^ 'Direcao' da bala.
        }
    | DisparoLaser
        { jogadorDisparo :: Int                 -- ^ Identificador do 'Jogador' que disparou.
        , posicaoDisparo :: PosicaoGrelha       -- ^ Posição da bala.
        , direcaoDisparo :: Direcao             -- ^ 'Direcao' da bala.
        }
    | DisparoChoque
        { jogadorDisparo :: Int                 -- ^ Identificador do 'Jogador' que disparou.
        , tempoDisparo   :: Ticks               -- ^ Tempo restante (> 0 e <= 5).
        }
  deriving (Read,Show,Eq)

-- | Uma arma do jogo.
data Arma = Canhao | Laser | Choque
  deriving (Read,Show,Eq,Enum,Bounded)

-- | Instantes de tempo do jogo.
type Ticks = Int

-- | Uma jogada feita por um 'Jogador'.
data Jogada
    = Movimenta Direcao  -- ^ Move o jogador numa dada 'Direcao'.
    | Dispara Arma      -- ^ Dispara uma 'Arma'.
    | Carregar
    | Comprar
    | MudarArma
    | Facada
    | None
  deriving (Read,Show,Eq)

-- * Funções auxiliares dadas para a Tarefa 1.

-- | Dimensão do mapa a usar para uma sequência de 'Instrucoes'.
dimensaoInicial :: Instrucoes -> Dimensao
dimensaoInicial = fst . isI

-- | Posicao inicial do editor a usar para uma sequência de 'Instrucoes'.
posicaoInicial :: Instrucoes -> Posicao
posicaoInicial = snd . isI

-- | Função auxiliar, premeditadamente ofuscada.
--
-- __Este não é um exemplo de boa programação em Haskell!__
isI :: Instrucoes -> (Dimensao, Posicao)
isI is = ((lH - lL + 2, cH - cL + 2), (succ $ max 0 (-lL), succ $ max 0 (-cL)))
 where
  (ps, _)          = foldl iI ([(0, 0),(4,4)], 0) is
  (lL, lH, cL, cH) = foldl
    (\(xL, xH, yL, yH) (x,y) -> (min xL x, max xH x, min yL y, max yH y))
    (0, 0, 0, 0)
    ps
  iI (p:ps,t) (Move d)       = let p' = xx (+) (+) (dP d) p in (p' : np p' t : p : ps, t)
  iI (p:ps,t) MudaTetromino  = let t' = mod (t + 1) 7 in (p:np p t':ps, t')
  iI x        i              = x
  np p t = xx (+) (+) p ((\x -> (x, x)) $ tns !! t)
  dP d = rP (-pi * realToFrac (fromEnum d) / 2)
  rP a = (-round (cos a), -round (sin a))
  xx f g (a, b) (c, d) = (f a c, g b d)
  tns = [4, 3, 3, 2, 3, 3, 3]
    
    
    

