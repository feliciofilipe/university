{-| __Introdução__

Esta tarefa do trabalho prático tinha como objetivo criar a parte gráfica/visual do jogo implementado.

Esta tarefa trouxe uma liberdade de criação e imaginação no que toca ao tema escolhido e á intrepretação desse tema pelo grupo. O tema escolhido foi a Segunda Guerra Mundial, tendo como base dos mapas as batalhas e acontecimentos que se desenrolaram nessa altura.

Durante a realização do trabalho foram criadas outras ferramentas que apoiam o tema escolhido. Uma dessas novas criações foi o 'ModoZombie', que se baseia na criação de um jogador automático (zombies) que jogam contra 2 jogadores manuais.
Para além desta criação foram também indroduzidos novos elementos no código de 'LI11819' como foi o caso da indrodução de novas jogadas como carregar e comprar que premitem ao jogador carregar a sua armar ou então comprar munições, respetivamente.
Também foi introduzido novas peças no mapa utilizadas nos niveis de multiplos jogadores:

 * arbustos - que fazem com que o jogador consiga esconder-se dos outros jogadores.
 * água - que reduz a velocidade de movimento do jogador quando lá passa.
 * TNT - que funciona como uma bomba.

Foram também introduzidas novas peças no mapa utilizadas exclusivamente no 'ModoZombie':

 * Porta - funciona como meio de passagem para a ronda seguinte
 * VMJuggernog - premite ter o dobro das vidas que já possuis
 * VMSpeedCola - premite carregar á arma automaticamente
 * VMSelfRevive - premite voltar a viver mesmo sem vidas
 * VMMedKit - dá te mais vidas do que a que já tens

Todos estes parâmetros em cima surgem com um aviso de compra (V0, V1, V2, V3, V4) exceto a porta quando surge quando o jogador se apróxima desta.

Houve também a criação de uma 'Tarefa5_ticks' que tem os mesmos objetivos que a 'Tarefa4_2018li1g159', a única diferença são que a tarefa5.ticks funciona á base das alterações feitas no código de 'LI11819' enquanto que a tarefa4 funciona á base do código original.
Finalmente foi alterada o comportamento de uma das armas. Neste caso foi o disparo choque, que segundo o jogo original impedia os jogadores das proximidades ao choque de se moverem. Contudo podiam disparar e mudar de direção. 
A alterção feita nesse disparo impossibilitou o jogador de disparar e de se mover, simplesmente pode mudar de direção. Torna-se assim uma arma muito mais forte do que originalmente, permitindo ao jogador que lançou o choque de atingir o jogador preso nesse choque sem que ele seja atingido por este.

__Objetivos/Desenvolvimento__

Apartir do título /Funções principais da Tarefa 5/ encontram-se as funções criadas a parte gráfica/visula do jogo seguidas da sua análise e explicação. 
Para além disso, no 'ModoZombie' também pode ser encontrado a explicação e análise das suas funções.

__Discução/Conclusão__

O resultado final apos a crianção desta Tarefa foi positivo, já que foi obtido um jogo com diferentes mapas e niveis e bastante interativo com o jogador manual. 
As alterações feitas também criaram a possibiliade de haver 2 modos de jogo. Um deles que se joga contra vários jogadores automático ('ModoZombie') e outro que se joga contra diferentes jogadres individuais. 
-}

module Main where

import DataStruct
import Functions
import MapEditor
import Physics1
import Physics2
import Bot
import Keyboard
import Zombies
import Maps
import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Interface.Pure.Game

-- * Os diferentes estados do jogo 

type PosicaoGloss = (Float,Float)


-- * Funções principais da Tarefa 5

-- | Posição relativa do mapa
l :: Float
l = 25

-- | Posição relativa do mapa
l2 :: Float
l2 = 2*l

-- | Posição relativa do mapa (ModoZombie)
lz :: Float
lz = (0.5)*l

-- | Função que dá a altura do mapa num float
heigth :: Float
heigth = 350 

-- | Função que dá a largura do mapa num float
width :: Float
width = (-550)

-- | Função que dá a altura do mapa do modoZombie num float
heigthz :: Float
heigthz = 525

-- | Função que dá a largura do mapa do modoZombie num float
widthz :: Float
widthz = (-940)

-- | Função que posiciona os elementos no mapa
--
-- Posiciona segundo as linhas
p0 :: Int -> Float -> Int -> Float
p0 0 ld a = width + ((realToFrac (a+1))*ld)
p0 1 ld a = widthz + ((realToFrac (a+1))*ld)

-- | Função que posiciona os elementos no mapa
--
-- Posiciona segundo as colunas
p1 :: Int -> Float -> Int -> Float 
p1 0 ld b = heigth - ((realToFrac b)*ld)
p1 1 ld b = heigthz - ((realToFrac b)*ld)

blocoVazia :: Picture
blocoVazia = Color black (Polygon [(0,0),(l,0),(l,l),(0,l),(0,0)])

blocoVazia2 :: Picture
blocoVazia2 = Color black (Polygon [(0,0),(l2,0),(l2,l2),(0,l2),(0,0)])

blocoVazia3 :: Picture
blocoVazia3 = Color black (Polygon [(0,0),(lz,0),(lz,lz),(0,lz),(0,0)])

-- ** Contrução do mapa em imagens

{- | Controi em imagens o estado do jogo

Esta função recebe um indicador do estado a construir que varia entre 0 e 19, ou seja dos 20 mapas e estados pre-defenidos.
Recebe também um indicador 99 que constroi o estado pré-defenido do modoZombie.

A construção do mapa é baseada na recursividade das funções e na escala das imagens em relação do tamanho do mapa

 * Cada imagem que posteriormente será uma peça do mapa será multiplicada pelo compriemento e largura do mapa pre-defenido atraves das funções 'constroiLinha', 'constroiLinha2' e 'controiLinha3'.
 * As imagens dos disparos passaram pelo mesmo processo se estas se encontrarem no estado naquele tick atraves do 'constroiDisparos'
 * Os jogadores formaram 4 imagens que se vão alterando á medida das várias direções atraves da função 'constroiJogadores'

Todas estas imagens seram colocadas numa longa lista de imagens e seram posteriormente usadas do 'desenhaEstado'.

__Nota:__ No modo Zombie para além de se desenhar o mapa, os disparos e os jogadores é necessario taém serem introduzidas as imagens para os zombies, logo criou-se a função 'constroiZombies' que realiza isso mesmo. 
-}
constroiMapa :: Int -> Float -> Estado -> [Picture] -> [Picture] -> [Picture]
constroiMapa _ y (Estado [] lj ld) _ _ = []
constroiMapa 99 y (Estado (h:t) lj@(j1:j2:j3:j4:j5:zs) ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha3 widthz y h tx ++ (constroiMapa 99 (y-lz) (Estado t [] []) li tx) ++ (constroiJogadoresZ 2 1 lz (h:t) (j1:j2:[]) (tz:tz0:tz1:tz2:tz3:[])) ++ constroiZombies lz (h:t) zs z ++ constroiDisparos 1 lz (h:t) lj ld ((Scale 0.25 0.25 ca0):(Scale 0.25 0.25 ca1):(Scale 0.25 0.25 ca2):(Scale 0.25 0.25 ca3):(Scale 0.25 0.25 lz7):(Scale 0.25 0.25 lz1):(Scale 0.25 0.25 lz2):(Scale 0.25 0.25 lz3):(Scale 0.25 0.25 ch7):(Scale 0.25 0.25 ch1):(Scale 0.25 0.25 ch2):(Scale 0.25 0.25 ch3):[])
constroiMapa 99 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha3 widthz y h tx ++ (constroiMapa 99 (y-lz) (Estado t [] []) li tx) 
constroiMapa 19 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 19 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t10):(Scale 0.5 0.5 t5):(Scale 0.5 0.5 t19):(Scale 0.5 0.5 t8):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch1):[]))
constroiMapa 18 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 18 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t5):(Scale 0.5 0.5 t19):(Scale 0.5 0.5 t18):(Scale 0.5 0.5 t8):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch1):[]))
constroiMapa 17 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 17 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(Scale 0.5 0.5 t0):(Scale 0.5 0.5 t17):(Scale 0.5 0.5 t11):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch1):[]))
constroiMapa 16 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 16 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(Scale 0.5 0.5 t0):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch1):[]))
constroiMapa 15 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 15 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t10):(Scale 0.5 0.5 t5):(Scale 0.5 0.5 t6):(Scale 0.5 0.5 t1):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch7):[]))
constroiMapa 14 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 14 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t0):(Scale 0.5 0.5 t1):(Scale 0.5 0.5 t12):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch5):[]))
constroiMapa 13 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 13 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t0):(Scale 0.5 0.5 t8):(Scale 0.5 0.5 t16):(Scale 0.5 0.5 t15):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch2):(Scale 0.5 0.5 ch5):[]))
constroiMapa 12 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha2 width y h tx ++ (constroiMapa 12 (y-l2) (Estado t [] []) li tx) ++ (constroiJogadores 0 l2 (h:t) lj (t1:t0:[])) ++ (constroiDisparos 0 l2 (h:t) lj ld (ca7:ca0:ca2:ca3:lz7:lz0:lz2:lz3:ch7:ch0:ch2:ch3:[]))
constroiMapa 11 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 11 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(Scale 0.5 0.5 t4):(scale 0.5 0.5 t5):(scale 0.5 0.5 t10):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch4):[]))
constroiMapa 10 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 10 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(Scale 0.5 0.5 t4):(scale 0.5 0.5 t5):(scale 0.5 0.5 t6):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):[]))
constroiMapa 9 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha2 width y h tx ++ (constroiMapa 9 (y-l2) (Estado t [] []) li tx) ++ (constroiJogadores 0 l2 (h:t) lj (a5:a0:[])) ++ (constroiDisparos 0 l2 (h:t) lj ld (ca4:ca1:ca2:ca3:lz4:lz1:lz2:lz3:ch4:ch1:ch2:ch3:[]))
constroiMapa 8 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 8 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((scale 0.5 0.5 t6):(scale 0.5 0.5 t5):(Scale 0.5 0.5 t1):(scale 0.5 0.5 t14):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch2):[]))
constroiMapa 7 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 7 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t0):(Scale 0.5 0.5 t1):(scale 0.5 0.5 t12):(Scale 0.5 0.5 t4):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch6):[]))
constroiMapa 6 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 6 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(scale 0.5 0.5 t11):(Scale 0.5 0.5 t0):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca3):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz3):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch6):[]))
constroiMapa 5 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha2 width y h tx ++ (constroiMapa 5 (y-l2) (Estado t [] []) li tx) ++ (constroiJogadores 0 l2 (h:t) lj (a2:a4:a3:a1:[])) ++ (constroiDisparos 0 l2 (h:t) lj ld (ca4:ca0:ca7:ca6:lz4:lz0:lz7:lz6:ch4:ch0:ch7:ch6:[]))
constroiMapa 4 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha2 width y h tx ++ (constroiMapa 4 (y-l2) (Estado t [] []) li tx) ++ (constroiJogadores 0 l2 (h:t) lj (t7:t8:t9:[])) ++ (constroiDisparos 0 l2 (h:t) lj ld (ca0:ca1:ca4:ca3:lz0:lz1:lz4:lz3:ch0:ch1:ch4:ch3:[]))
constroiMapa 3 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 3 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t0):(Scale 0.5 0.5 t1):(Scale 0.5 0.5 t4):(scale 0.5 0.5 t13):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch2):[]))
constroiMapa 2 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 2 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t10):(Scale 0.5 0.5 t5):(Scale 0.5 0.5 t6):(Scale 0.5 0.5 t1):[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch7):[]))
constroiMapa 1 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha2 width y h tx ++ (constroiMapa 1 (y-l2) (Estado t [] []) li tx) ++ (constroiJogadores 0 l2 (h:t) lj (b0:a0:[])) ++ (constroiDisparos 0 l2 (h:t) lj ld (ca4:ca1:ca4:ca3:lz4:lz1:lz4:lz3:ch4:ch1:ch4:ch3:[]))
constroiMapa 0 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = constroiLinha width y h tx ++ (constroiMapa 0 (y-l) (Estado t [] []) li tx) ++ (constroiJogadores 0 l (h:t) lj ((Scale 0.5 0.5 t1):(Scale 0.5 0.5 t0):t2:t3:[])) ++ (constroiDisparos 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 ca3):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 lz3):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch2):(Scale 0.5 0.5 ch3):[]))

constroiJogadoresZ :: Int -> Int -> Float -> Mapa -> [Jogador] -> [Picture] -> [Picture]
constroiJogadoresZ 0 _ _ _ _ _ = []
constroiJogadoresZ n i ld m ((Jogador (x,y) dj v l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) | v < 0 = (constroiJogadoresZ (n-1) i ld m t la)
constroiJogadoresZ n i ld m ((Jogador (x,y) dj 0 l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) = (constroiJogadoresZ (n-1) i ld m t la)
constroiJogadoresZ n i ld m ((Jogador (x,y) B v l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) = (Translate (p0 i ld y) (p1 i ld x) (armaToPic a la)) : (constroiJogadoresZ (n-1) i ld m t la)
constroiJogadoresZ n i ld m ((Jogador (x,y) E v l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 (armaToPic a la))) : (constroiJogadoresZ (n-1) i ld m t la)
constroiJogadoresZ n i ld m ((Jogador (x,y) C v l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 (armaToPic a la))) : (constroiJogadoresZ (n-1) i ld m t la)
constroiJogadoresZ n i ld m ((Jogador (x,y) D v l c a):t) la@(tz:tz0:tz1:tz2:tz3:[]) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 (armaToPic a la))) : (constroiJogadoresZ (n-1) i ld m t la)

armaToPic :: ArmaZ -> [Picture] -> Picture
armaToPic Pistol (tz:tz0:tz1:tz2:tz3:[]) = tz
armaToPic AK47 (tz:tz0:tz1:tz2:tz3:[]) = tz0
armaToPic Faca (tz:tz0:tz1:tz2:tz3:[]) = tz1
armaToPic Strike (tz:tz0:tz1:tz2:tz3:[]) = tz2
armaToPic M8A1 (tz:tz0:tz1:tz2:tz3:[]) = tz3

constroiArbustos4 :: Float -> Float -> Estado -> [Picture] -> Picture
constroiArbustos4 x y e tx = Scale 0.6 0.6 (Pictures (constroiArbustos3 x y e tx))

constroiArbustos3 :: Float -> Float -> Estado -> [Picture] -> [Picture]
constroiArbustos3 _ _ (Estado [] _ _) _ = [] 
constroiArbustos3 x y (Estado (h:t) lj ld) tx = (constroiArbusto3 x y h tx) ++ (constroiArbustos3 x (y-l2) (Estado t lj ld) tx)

constroiArbusto3 :: Float -> Float -> [Peca] -> [Picture] -> [Picture]
constroiArbusto3 _ _ [] _ = [] 
constroiArbusto3 x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Arbusto = (Translate (x+25) (y+25) lt) : (constroiArbusto3 (x+l2) y t tx)
                                                   | otherwise = constroiArbusto3 (x+l2) y t tx

constroiArbustos2 :: Float -> Float -> Estado -> [Picture] -> Picture
constroiArbustos2 x y e tx = Scale 0.6 0.6 (Pictures (constroiArbustos x y e tx))

constroiArbustos :: Float -> Float -> Estado -> [Picture] -> [Picture]
constroiArbustos _ _ (Estado [] _ _) _ = [] 
constroiArbustos x y (Estado (h:t) lj ld) tx = (constroiArbusto x y h tx) ++ (constroiArbustos x (y-l) (Estado t lj ld) tx)

constroiArbusto :: Float -> Float -> [Peca] -> [Picture] -> [Picture]
constroiArbusto _ _ [] _ = [] 
constroiArbusto x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Arbusto = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 lt)) : (constroiArbusto (x+l) y t tx)
                                                  | otherwise = constroiArbusto (x+l) y t tx


{-
constroiArbustos2 :: Float -> Float -> [Peca] -> [Picture] -> Picture
constroiArbustos2 _ _ [] _ = [] 
constroiArbustos2 x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Arbusto = Pictures(Translate (x+25) (y+25) lt) : (constroiArbustos (x+l2) y t tx)
                                                    | otherwise = Pictures(constroiArbustos (x+l2) y t tx)
-}
-- *** Funções auxiliares na construção de imagens do estado

{- | Função que constroi uma linha de imagens no mapa

Esta função vai construir uma linha do mapa que possua elementos como arbustos, água e TNT.
Constroi também mapas com uma dimensão igual e diferente dos mapas que usam a função 'constroiLinha2'.
-}
constroiLinha :: Float -> Float -> [Peca] -> [Picture] -> [Picture]  
constroiLinha _ _ [] _ = []
constroiLinha x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Destrutivel = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 ct)) : (constroiLinha (x+l) y t tx)
                                                | h == Bloco Indestrutivel = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 wt)) : (constroiLinha (x+l) y t tx)
                                                | h == Bloco Agua = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 at)) : (constroiLinha (x+l) y t tx)
                                                | h == Bloco TNT = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 tnt)) : (constroiLinha (x+l) y t tx)
                                                | otherwise = (Translate x y blocoVazia) : (constroiLinha (x+l) y t tx)

constroiLinhaEditor :: Float -> Float -> [Peca] -> [Picture] -> [Picture]  
constroiLinhaEditor _ _ [] _ = []
constroiLinhaEditor x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Destrutivel = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 ct)) : (constroiLinha (x+l) y t tx)
                                                      | h == Bloco Indestrutivel = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 wt)) : (constroiLinha (x+l) y t tx)
                                                      | h == Bloco Agua = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 at)) : (constroiLinha (x+l) y t tx)
                                                      | h == Bloco TNT = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 tnt)) : (constroiLinha (x+l) y t tx)
                                                      | h == Bloco Arbusto = (Translate (x+12.5) (y+12.5) (Scale 0.5 0.5 at)) : (constroiLinha (x+l) y t tx)
                                                      | otherwise = (Translate x y blocoVazia) : (constroiLinha (x+l) y t tx)

{- | Função que constroi uma linha de imagens no mapa

Esta função vai construir uma linha do mapa que possua elementos como arbustos, água e TNT.
Constroi também mapas com uma dimensão igual e diferente dos mapas que usam a função 'constroiLinha'.
-}                                                
constroiLinha2 :: Float -> Float -> [Peca] -> [Picture] -> [Picture]  
constroiLinha2 _ _ [] _ = []
constroiLinha2 x y (h:t) tx@(lt:at:wt:ct:tnt:[]) | h == Bloco Destrutivel = (Translate (x+25) (y+25) ct) : (constroiLinha2 (x+l2) y t tx)
                                                 | h == Bloco Indestrutivel = (Translate (x+25) (y+25) wt) : (constroiLinha2 (x+l2) y t tx)
                                                 | h == Bloco Agua = (Translate (x+25) (y+25) at) : (constroiLinha2 (x+l2) y t tx)
                                                 | h == Bloco TNT = (Translate (x+25) (y+25) tnt) : (constroiLinha2 (x+l2) y t tx)
                                                 | otherwise = (Translate x y blocoVazia2) : (constroiLinha2 (x+l2) y t tx)

{- | Função que constroi uma linha de imagens no mapa

Esta função vai construir uma linha do mapa que possua elementos como V0, VMMunicao, VMSelfRevive, entre outros .
Constroi o mapa referente ao modoZombie.
-}                                                   
constroiLinha3 :: Float -> Float -> [Peca] -> [Picture] -> [Picture]  
constroiLinha3 _ _ [] _ = []
constroiLinha3 x y (h:t) tx@(vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:lt:at:wt:ct:tnt:[]) | h == Porta = (Translate (x+6.25) (y+6.25) (Scale 0.25 0.25 ct)) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == Bloco Indestrutivel = (Translate (x+6.25) (y+6.25) (Scale 0.25 0.25 wt)) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == Bloco Arbusto = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V0 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V1 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V2 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V3 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V4 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V5 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V6 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == V7 = (Translate x y Blank) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == Bloco Agua = (Translate (x+6.25) (y+6.25) (Scale 0.25 0.25 at)) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == Bloco TNT = (Translate (x+6.25) (y+6.25) (Scale 0.25 0.25 tnt)) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMJuggernog = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm0) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMSpeedCola = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm1) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMDoubleTap = (Translate x (y-12.5) blocoVazia) : (Translate (x+12.5) y vm2) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMMedkit = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm3) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMSelfRevive = (Translate x (y-12.5) blocoVazia) : (Translate (x+12.5) y vm4) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMMunicao = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm5) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMAK47 = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm6) : (constroiLinha3 (x+lz) y t tx)
                                                                             | h == VMM8A1 = (Translate x (y-12.5) blocoVazia) :  (Translate (x+12.5) y vm7) : (constroiLinha3 (x+lz) y t tx)
                                                                             | otherwise = (Translate x y blocoVazia3) : (constroiLinha3 (x+lz) y t tx)

{- | Função que constroi as imagens dos Zombies

Esta função vai construir os zombies, sendo que toda a estrutura desta função é bastante parecida com o 'constroiJogadores'.
-}                                                                      
constroiZombies :: Float -> Mapa -> [Jogador] -> Picture -> [Picture]
constroiZombies _ _ [] _ = []
constroiZombies ld m ((Jogador (x,y) dj v l c a):t) z | v < 0 = (constroiZombies ld m t z)
constroiZombies ld m ((Jogador (x,y) dj 0 l c a):t) z = (constroiZombies ld m t z)
constroiZombies ld m ((Jogador (x,y) B v l c a):t)  z = (Translate (p0 1 ld y) (p1 1 ld x) z) : (constroiZombies ld m t z)
constroiZombies ld m ((Jogador (x,y) E v l c a):t)  z = (Translate (p0 1 ld y) (p1 1 ld x) (Rotate 90 z)) : (constroiZombies ld m t z)
constroiZombies ld m ((Jogador (x,y) C v l c a):t)  z = (Translate (p0 1 ld y) (p1 1 ld x) (Rotate 180 z)) : (constroiZombies ld m t z)
constroiZombies ld m ((Jogador (x,y) D v l c a):t)  z = (Translate (p0 1 ld y) (p1 1 ld x) (Rotate 270 z)) : (constroiZombies ld m t z)

{- | Função que constroi as imagens dos jogadores

Esta função vai construir os jogadores, tendo como principal preocupação a direção que este possui, ja que á medida que a direção do jogador se altera o utilizador vê diferentes lados do avatar.
Para além disso, uma outra preocupação foi quando o jogador possui vidas igua a 0, sendo assim a imagem passa a separecer da lista de imagens.
-} 
constroiJogadores :: Int -> Float -> Mapa -> [Jogador] -> [Picture] -> [Picture]
constroiJogadores _ _ _ [] _ = []
constroiJogadores i ld m ((Jogador (x,y) dj v l c a):t) (im:is) | v < 0 = (constroiJogadores i ld m t is)
constroiJogadores i ld m ((Jogador (x,y) dj 0 l c a):t) (im:is) = (constroiJogadores i ld m t is)
constroiJogadores i ld m ((Jogador (x,y) B v l c a):t) (im:is) = (Translate (p0 i ld y) (p1 i ld x) im) : (constroiJogadores i ld m t is)
constroiJogadores i ld m ((Jogador (x,y) E v l c a):t) (im:is) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 im)) : (constroiJogadores i ld m t is)
constroiJogadores i ld m ((Jogador (x,y) C v l c a):t) (im:is) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 im)) : (constroiJogadores i ld m t is)
constroiJogadores i ld m ((Jogador (x,y) D v l c a):t) (im:is) = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 im)) : (constroiJogadores i ld m t is)
constroiJogadores _ _ _ _ _ = []

{- | Função que constroi as imagens dos disparos

Esta função vai construir os disparos, tomando em conta o tipo do disparo e quem o lançou. 
No desenho do disparo laser foi utilizado uma função auxiliar 'desenhaLaser'.

__Nota:__ É necessário saber quem lançou o disparo pois é necessario saber a direção e posição a tomar pelo disparo (laser e canhao) ou só pela posição (choque)
-} 
constroiDisparos :: Int -> Float -> Mapa -> [Jogador] -> [Disparo] ->[Picture] -> [Picture]
constroiDisparos _ _ _ _ [] _ = []
constroiDisparos i ld m lj (d@(DisparoLaser 0 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (desenhaLaser i 0 ld m (Rotate 90 (Scale 2 2 i4)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == C = (desenhaLaser i 0 ld m (Rotate 270 (Scale 2 2 i4)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == E = (desenhaLaser i 0 ld m (Rotate 180 (Scale 2 2 i4)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == D = (desenhaLaser i 0 ld m (Scale 2 2 i4) d) ++ (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj (d@(DisparoLaser 1 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (desenhaLaser i 0 ld m (Rotate 90 (Scale 2 2 i5)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == C = (desenhaLaser i 0 ld m (Rotate 270 (Scale 2 2 i5)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == E = (desenhaLaser i 0 ld m (Rotate 180 (Scale 2 2 i5)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == D = (desenhaLaser i 0 ld m (Scale 2 2 i5) d) ++ (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj (d@(DisparoLaser 2 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (desenhaLaser i 0 ld m (Rotate 90 (Scale 2 2 i6)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == C = (desenhaLaser i 0 ld m (Rotate 270 (Scale 2 2 i6)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == E = (desenhaLaser i 0 ld m (Rotate 180 (Scale 2 2 i6)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == D = (desenhaLaser i 0 ld m (Scale 2 2 i6) d) ++ (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj (d@(DisparoLaser 3 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (desenhaLaser i 0 ld m (Rotate 90 (Scale 2 2 i7)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == C = (desenhaLaser i 0 ld m (Rotate 270 (Scale 2 2 i7)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == E = (desenhaLaser i 0 ld m (Rotate 180 (Scale 2 2 i7)) d) ++ (constroiDisparos i ld m lj t li)
                                                                                                         | dd == D = (desenhaLaser i 0 ld m (Scale 2 2 i7) d) ++ (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj ((DisparoCanhao 0 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 i0)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == C = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 i0)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == E = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 i0)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == D = (Translate (p0 i ld y) (p1 i ld x) i0) : (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj ((DisparoCanhao 1 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 i1)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == C = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 i1)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == E = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 i1)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == D = (Translate (p0 i ld y) (p1 i ld x) i1) : (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj ((DisparoCanhao 2 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 i2)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == C = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 i2)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == E = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 i2)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == D = (Translate (p0 i ld y) (p1 i ld x) i2) : (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj ((DisparoCanhao 3 (x,y) dd):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) | dd == B = (Translate (p0 i ld y) (p1 i ld x) (Rotate 90 i3)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == C = (Translate (p0 i ld y) (p1 i ld x) (Rotate 270 i3)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == E = (Translate (p0 i ld y) (p1 i ld x) (Rotate 180 i3)) : (constroiDisparos i ld m lj t li)
                                                                                                        | dd == D = (Translate (p0 i ld y) (p1 i ld x) i3) : (constroiDisparos i ld m lj t li)
constroiDisparos i ld m lj (_:t) li = constroiDisparos i ld m lj t li

desenhaChoque :: Int -> [Picture] -> Estado -> Picture
desenhaChoque 2001 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 0 heigth e l )))
desenhaChoque 2011 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 4 heigth e l )))
desenhaChoque 2021 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 6 heigth e l )))
desenhaChoque 2031 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 8 heigth e l )))
desenhaChoque 2041 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 5 heigth e l )))
desenhaChoque 2051 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 7 heigth e l )))
desenhaChoque 2061 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 1 heigth e l )))
desenhaChoque 2071 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 14 heigth e l)))
desenhaChoque 2081 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 18 heigth e l)))
desenhaChoque 2091 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 3 heigth e l )))
desenhaChoque 2101 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 15 heigth e l)))
desenhaChoque 2111 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 9 heigth e l )))
desenhaChoque 2121 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 10 heigth e l)))
desenhaChoque 2131 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 16 heigth e l)))
desenhaChoque 2141 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 2 heigth e l )))
desenhaChoque 2151 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 17 heigth e l)))
desenhaChoque 2161 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 11 heigth e l)))
desenhaChoque 2171 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 12 heigth e l)))
desenhaChoque 2181 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 13 heigth e l)))
desenhaChoque 2191 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiChoque 19 heigth e l)))
desenhaChoque i (lt:at:wt:ct:tnt:l) e = Pictures(constroiChoque i heigth e l)

constroiChoque :: Int -> Float -> Estado -> [Picture] -> [Picture]
constroiChoque 19 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch1):[])
constroiChoque 18 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch1):[])
constroiChoque 17 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch1):[])
constroiChoque 16 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch1):[])
constroiChoque 15 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch7):[])
constroiChoque 14 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch5):[])
constroiChoque 13 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch2):(Scale 0.5 0.5 ch5):[])
constroiChoque 12 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l2 (h:t) lj ld (ca7:ca0:ca2:ca3:lz7:lz0:lz2:lz3:ch7:ch0:ch2:ch3:[])
constroiChoque 11 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch4):[])
constroiChoque 10 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):[])
constroiChoque 9 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l2 (h:t) lj ld (ca4:ca1:ca2:ca3:lz4:lz1:lz2:lz3:ch4:ch1:ch2:ch3:[])
constroiChoque 8 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch2):[])
constroiChoque 7 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch6):[])
constroiChoque 6 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca1):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca3):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz1):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz3):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch6):[])
constroiChoque 5 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l2 (h:t) lj ld (ca4:ca0:ca7:ca6:lz4:lz0:lz7:lz6:ch4:ch0:ch7:ch6:[])
constroiChoque 4 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l2 (h:t) lj ld (ca0:ca1:ca4:ca3:lz0:lz1:lz4:lz3:ch0:ch1:ch4:ch3:[])
constroiChoque 3 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca6):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz6):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch6):(Scale 0.5 0.5 ch2):[])
constroiChoque 2 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca4):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca5):(Scale 0.5 0.5 ca7):(Scale 0.5 0.5 lz4):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz5):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 ch4):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch5):(Scale 0.5 0.5 ch7):[])
constroiChoque 1 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l2 (h:t) lj ld (ca4:ca1:ca4:ca3:lz4:lz1:lz4:lz3:ch4:ch1:ch4:ch3:[])
constroiChoque 0 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) = auxConstroiChoque 0 l (h:t) lj ld ((Scale 0.5 0.5 ca7):(Scale 0.5 0.5 ca0):(Scale 0.5 0.5 ca2):(Scale 0.5 0.5 ca3):(Scale 0.5 0.5 lz7):(Scale 0.5 0.5 lz0):(Scale 0.5 0.5 lz2):(Scale 0.5 0.5 lz3):(Scale 0.5 0.5 ch7):(Scale 0.5 0.5 ch0):(Scale 0.5 0.5 ch2):(Scale 0.5 0.5 ch3):[])
 
auxConstroiChoque :: Int -> Float -> Mapa -> [Jogador] -> [Disparo] ->[Picture] -> [Picture]
auxConstroiChoque _ _ _ _ [] _ = []
auxConstroiChoque i ld m lj@((Jogador (x,y) dj v l c a):js) ((DisparoChoque 0 tick):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) = (Translate (p0 i ld y) (p1 i ld x) (Scale 1.5 1.5 i8)) : (auxConstroiChoque i ld m lj t li)
auxConstroiChoque i ld m lj@(a0:(Jogador (x,y) dj v l c a):js) ((DisparoChoque 1 tick):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is)= (Translate (p0 i ld y) (p1 i ld x) (Scale 1.5 1.5 i9)) : (auxConstroiChoque i ld m lj t li)
auxConstroiChoque i ld m lj@(a0:b1:(Jogador (x,y) dj v l c a):js) ((DisparoChoque 2 tick):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) = (Translate (p0 i ld y) (p1 i ld x) (Scale 1.5 1.5 i10)) : (auxConstroiChoque i ld m lj t li)
auxConstroiChoque i ld m lj@(a0:b1:c2:(Jogador (x,y) dj v l c a):[]) ((DisparoChoque 3 tick):t) li@(i0:i1:i2:i3:i4:i5:i6:i7:i8:i9:i10:i11:is) = (Translate (p0 i ld y) (p1 i ld x) (Scale 1.5 1.5 i11)) : (auxConstroiChoque i ld m lj t li)
auxConstroiChoque i ld m lj (_:t) li = auxConstroiChoque i ld m lj t li

{- | Função que constroi as imagens dos disparos laser

Esta função vai construir os disparos laser, uma vez que este precorrer todo o mapa até atingirem paredes destrutiveis. Isto é os laser num só momento possam por várias posições seguindas.
A listas das várias posições do laser é dada pela função auxiliar 'posicoesLaser' criada em 'Tarefa5_ticks'

constroiChoque 19 y (Estado (h:t) lj ld) li@(ca0:ca1:ca2:ca3:ca4:ca5:ca6:ca7:lz0:lz1:lz2:lz3:lz4:lz5:lz6:lz7:ch0:ch1:ch2:ch3:ch4:ch5:ch6:ch7:t0:t1:t2:t3:t4:t5:t6:t7:t8:t9:t10:t11:t12:t13:t14:t15:t16:t17:t18:t19:tz:tz0:tz1:tz2:tz3:a0:a1:a2:a3:a4:a5:b0:z:[]) tx = 
Esta função vai verificar as diversas posições dessa lista e desenhar em cada uma delas a imagem do laser. 
-} 
desenhaLaser :: Int -> Int -> Float -> Mapa -> Picture -> Disparo -> [Picture]
desenhaLaser i0 0 ld m pic d@(DisparoLaser jd pd dd) = (desenhaLaser i0 1 ld m pic (DisparoLaser jd (auxMove pd dd) dd))
desenhaLaser i0 i ld m pic d@(DisparoLaser jd pd dd) = if (posicoesLasers m [d]) == [] then [Blank]
                                                     else (Translate (p0 i0 ld (snd(head(posicoesLasers m [d])))) (p1 i0 ld (fst(head(posicoesLasers m [d])))) pic) : (desenhaLaser i0 (i+1) ld m pic (DisparoLaser jd (auxMove pd dd) dd)) 

-- ** Funções reagem ao tempo ou a outros elementos

{- | Função que constroi as imagens de um estado numa imagem unica

Esta função utiliza a função auxiliar 'constroiMapa' de que se obtem uma lista de imagens que criam o estado.
Nesta função essa lista de imagens passa a ser um única imagem. Essa única imagem está em constante alteração devido á reação do tempo.
-}                                                    
desenhaEstado :: Int -> [Picture] -> Estado -> Picture
desenhaEstado 99 (vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:lt:at:wt:ct:tnt:l) e = Pictures(constroiMapa 99 heigthz e l (vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:lt:at:wt:ct:tnt:[]))
desenhaEstado 2001 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 0 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2011 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 4 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2021 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 6 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2031 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 8 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2041 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 5 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2051 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 7 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2061 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 1 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2071 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 14 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2081 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 18 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2091 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 3 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2101 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 15 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2111 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 9 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2121 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 10 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2131 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 16 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2141 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 2 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2151 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 17 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2161 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 11 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2171 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 12 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2181 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 13 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado 2191 (lt:at:wt:ct:tnt:l) e = Scale 0.6 0.6 (Translate w2 h2 (Pictures(constroiMapa 19 heigth e l (lt:at:wt:ct:tnt:[]))))
desenhaEstado i (lt:at:wt:ct:tnt:l) e = Pictures(constroiMapa i heigth e l (lt:at:wt:ct:tnt:[]))

w2 :: Float
w2 = 950

h2 :: Float
h2 = 100

{- | Função que reage aos comandos dados pelo o utilizador

Esta função cria uma jogada num especifico jogador dependendo da tecla que o utilizador presiona.
Esta função é utilizada em estados que possuam 4 jogadores

=== Exemplo:
@
  Se utilizador presionar a tecla 'W' então a jogada obtida é:
  0 (Movimenta C) e --^ Vai movimentar para cima o jogador com indice 0 e devolver ainda o estado atual do jogo antes do movimento.  
@

__Nota:__ As teclas utilizadas são escolhidas pelo grupo, contudo as que foram escolhidas são baseadas nas já pre-defenidas no jogo original dos professores.
-}
jogadorExiste :: Int -> [Jogador] -> Bool
jogadorExiste x [] = False
jogadorExiste 0 l = True
jogadorExiste x (h:t) = jogadorExiste (x-1) t


{- | Função que cria o sistema de perda de vidas

Esta função mostra a perda de vidas através de uma pequena animação interativa com o jogo.

Tem como base uma rectângulo verde que á medida que esse jogador perde vidas vai transformando-se em vermelho. 
-}
sistemaVida :: Estado -> [Picture]
sistemaVida (Estado _ [] _) = []
sistemaVida (Estado m ((Jogador pj dj v l c _):t) ld) | v < 0 = sv5 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 5 l c _):t) ld) = sv5 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 4 l c _):t) ld) = sv4 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 3 l c _):t) ld) = sv3 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 2 l c _):t) ld) = sv2 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 1 l c _):t) ld) = sv1 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m ((Jogador pj dj 0 l c _):t) ld) = sv0 : (sistemaVida (Estado m t ld))
sistemaVida (Estado m (h:t) ld) = (sistemaVida (Estado m t ld))

-- | Função que dá o rectangulo verde utilizado em 'sistemaVidas'
sv5 :: Picture
sv5 = Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color green (rectangleSolid 220 25))]

sv4 :: Picture
sv4 = Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color green (rectangleSolid 220 25)),(Translate 88 0 (Color red (rectangleSolid 44 25)))]


sv3 :: Picture
sv3 = Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color green (rectangleSolid 220 25)),(Translate 66 0 (Color red (rectangleSolid 88 25)))]

-- | Função que dá o rectangulo verde utilizado em 'sistemaVidas'
sv2 :: Picture
sv2 = Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color green (rectangleSolid 220 25)),(Translate 44 0 (Color red (rectangleSolid 132 25)))]

-- | Função que dá o rectangulo verde utilizado em 'sistemaVidas'
sv1 :: Picture  
sv1 = Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color green (rectangleSolid 220 25)),(Translate 22 0 (Color red (rectangleSolid 176 25)))]

-- | Função que dá o rectangulo vermelho utilizado em 'sistemaVidas'
sv0 :: Picture
sv0 = (Pictures[(Color (greyN 0.5) (rectangleSolid 225 30)),(Color red ((rectangleSolid 220 25)))])

-- | Função que torna uma lista de imagens que formam o sistema de vidas numa imagem única
--
-- Utiliza como função auxiliar a 'sistemaVida' 
sistemaVidaM :: Int -> Float -> Float -> [Picture] -> Picture
sistemaVidaM 0 _ _ _ = Blank
sistemaVidaM _ _ _ [] = Blank
sistemaVidaM i x y (h:t) = Pictures([(Translate x y h)]++[(sistemaVidaM (i-1) x (y-200) t)])

-- | Função que cria o sistema de vidas no 'ModoZombie'
--
-- Apartir de um estado cria uma lista de imagens ligadas ao sistema de vidas que formam parte desse estado.
sistemaVidaZ :: Estado -> [Picture]
sistemaVidaZ (Estado _ [] _) = []
sistemaVidaZ (Estado m ((Jogador pj dj v l c a):x:y:z@(Jogador _ _ 1 _ _ _):t) ld) = (Pictures[(Color (greyN 0.5) (rectangleSolid 355 55)),(Color red (rectangleSolid 350 50)),(Translate (pz0 v) 0 (Color green (rectangleSolid (1.75*(realToFrac v)) 50)))]) : (sistemaVidaZ (Estado m (x:y:z:t) ld))
sistemaVidaZ (Estado m ((Jogador pj dj v l c a):t) ld) = (Pictures[(Color (greyN 0.5) (rectangleSolid 355 55)),(Color red (rectangleSolid 350 50)),(Translate (pz v) 0 (Color green (rectangleSolid (3.5*(realToFrac v)) 50)))]) : (sistemaVidaZ (Estado m t ld))

-- | Função que torna uma lista de imagens que formam o sistema de vidas numa imagem única
--
-- Utiliza como função auxiliar a 'sistemaVidaZ' 
sistemaVidaMZ :: Int -> Float -> Float -> [Picture] -> Picture
sistemaVidaMZ 0 _ _ _ = Blank
sistemaVidaMZ _ _ _ [] = Blank
sistemaVidaMZ i x y (h:t) = Pictures([(Translate x y h)]++[(sistemaVidaMZ (i-1) (x+625) y t)])

-- | Função que posiciona os elementos no mapa do modoZombie
--
-- Posiciona segundo as linhas
pz0 :: Int -> Float
pz0 i = (-0.875)*(200-(realToFrac i))

-- | Função que posiciona os elementos no mapa do modoZombie
--
-- Posiciona segundo as colunas
pz :: Int -> Float
pz i = (-1.75)*(100-(realToFrac i))

-- | Função que cria uma imagem quando o jogador morre
--
-- Esta função implementa uma imagem em cima da imagem do jogador quando este possui vidas igual a 0
animacaoMorte :: Float -> Float -> Estado -> Picture -> [Picture]
animacaoMorte _ _ (Estado m [] ld) _ = [Blank]
animacaoMorte x y (Estado m ((Jogador pj d v l c a):t) ld) ad = if v <= 0 then ((Translate x y (scale 0.81 0.75 ad)):(animacaoMorte x (y-200) (Estado m t ld) ad))
                                                              else animacaoMorte x (y-200) (Estado m t ld) ad

{- | Função que anima o sistema de perda de vidas aqueles que estão sobe o efeito do choque 

Esta função cria uma imagem sobreposta á do jogador quando este está sobre o efeito do choque
Para além disso também cria uma animação em que uma imagem pisca intermenitente quando estes estão sobre o efeito do disparo choque.

Para isso utilizou-se uma função auxiliar a 'eGouhl' que determina se o jogador está ou não sobre o efeito do choque 
-}                                                             
animacaoGhoul :: Int -> Float -> Float -> Estado -> Picture -> [Picture]
animacaoGhoul _ _ _ (Estado m [] ld) _ = [Blank]
animacaoGhoul _ _ _ (Estado m lj []) _ = [Blank]
animacaoGhoul 0 x y (Estado m ((Jogador pj d 0 l c a):t) ld) ad = animacaoGhoul 1 x (y-200) (Estado m t ld) ad
animacaoGhoul 1 x y (Estado m (v:(Jogador pj d 0 l c a):t) ld) ad = animacaoGhoul 2 x (y-200) (Estado m t ld) ad
animacaoGhoul 2 x y (Estado m (v:r:(Jogador pj d 0 l c a):t) ld) ad = animacaoGhoul 3 x (y-200) (Estado m t ld) ad
animacaoGhoul 3 x y (Estado m (v:r:z:(Jogador pj d 0 l c a):[]) ld) ad = [Blank]
animacaoGhoul 0 x y e@(Estado m ((Jogador pj d vi l c a):t) ld) ad = if eGhoul 0 pj e then ((Translate x y (scale 0.75 0.75 ad)):(animacaoGhoul 1 x (y-200) e ad)) else (animacaoGhoul 1 x (y-200) e ad) 
animacaoGhoul 1 x y e@(Estado m (v:(Jogador pj d vi l c a):t) ld) ad = if eGhoul 1 pj e then ((Translate x y (scale 0.75 0.75 ad)):(animacaoGhoul 2 x (y-200) e ad)) else (animacaoGhoul 2 x (y-200) e ad)
animacaoGhoul 2 x y e@(Estado m (v:r:(Jogador pj d vi l c a):t) ld) ad = if eGhoul 2 pj e then ((Translate x y (scale 0.75 0.75 ad)):(animacaoGhoul 3 x (y-200) e ad)) else (animacaoGhoul 3 x (y-200) e ad)
animacaoGhoul 3 x y e@(Estado m (v:r:z:(Jogador pj d vi l c a):[]) ld) ad = if eGhoul 3 pj e then (Translate x y (scale 0.75 0.75 ad):[]) else []
animacaoGhoul _ _ _ _ _ = [] 

{- | Função que anima o sistema de perda de vidas aqueles que estão sobe o efeito do choque 

Esta função que possui as mesmas bases que o 'animacaoGhoul', so que as animações e imagens colocadas estão a uma escala e tamanho diferente, dependendo do mapa em questão.
-} 
animacaoN :: Bool -> Int -> Float -> Float -> Estado -> Picture -> [Picture]
animacaoN True _ _ _ _ _ = [Blank]
animacaoN _ _ _ _ (Estado m [] ld) _ = [Blank]
animacaoN _ _ _ _ (Estado m lj []) _ = [Blank]
animacaoN b 0 x y (Estado m ((Jogador pj d 0 l c a):t) ld) ad = animacaoN b 1 x (y-200) (Estado m t ld) ad
animacaoN b 1 x y (Estado m (v:(Jogador pj d 0 l c a):t) ld) ad = animacaoN b 2 x (y-200) (Estado m t ld) ad
animacaoN b 2 x y (Estado m (v:r:(Jogador pj d 0 l c a):t) ld) ad = animacaoN b 3 x (y-200) (Estado m t ld) ad
animacaoN b 3 x y (Estado m (v:r:z:(Jogador pj d 0 l c a):[]) ld) ad = [Blank]
animacaoN b 0 x y e@(Estado m ((Jogador pj d vi l c a):t) ld) ad = if eGhoul 0 pj e then ((Translate x y (scale 0.40 0.40 ad)):(animacaoN b 1 x (y-200) e ad)) else (animacaoN b 1 x (y-200) e ad) 
animacaoN b 1 x y e@(Estado m (v:(Jogador pj d vi l c a):t) ld) ad = if eGhoul 1 pj e then ((Translate x y (scale 0.40 0.40 ad)):(animacaoN b 2 x (y-200) e ad)) else (animacaoN b 2 x (y-200) e ad)
animacaoN b 2 x y e@(Estado m (v:ŕ:(Jogador pj d vi l c a):t) ld) ad = if eGhoul 2 pj e then ((Translate x y (scale 0.40 0.40 ad)):(animacaoN b 3 x (y-200) e ad)) else (animacaoN b 3 x (y-200) e ad)
animacaoN b 3 x y e@(Estado m (v:r:z:(Jogador pj d vi l c a):[]) ld) ad = if eGhoul 3 pj e then (Translate x y (scale 0.40 0.40 ad):[]) else [] 
animacaoN _ _ _ _ _ _ = []                                                              

-- | Função que verifica se existe um disparo choque no estado                                                                 
eGhoul :: Int -> PosicaoGrelha -> Estado -> Bool
eGhoul nj _ (Estado _ _ []) = False
eGhoul nj pj e@(Estado m lj (h:t)) = case h of
                                          (DisparoChoque nd _) -> auxEGhoul nj nd pj e
                                          otherwise -> eGhoul nj pj (Estado m lj t)

-- | Função auxiliar de 'eGhoul' que verifica se o jogador está ou não envolvido no choque
auxEGhoul :: Int -> Int -> PosicaoGrelha -> Estado -> Bool
auxEGhoul 0 0 _ _ = False
auxEGhoul 1 1 _ _ = False 
auxEGhoul 2 2 _ _ = False
auxEGhoul 3 3 _ _ = False
auxEGhoul nj 0 pj (Estado m lj@((Jogador p dj v l c a):js) (h:t)) = verificaChoque pj p
auxEGhoul nj 1 pj (Estado m lj@(j0:(Jogador p dj v l c a):js) (h:t)) =  verificaChoque pj p
auxEGhoul nj 2 pj (Estado m lj@(j0:j1:(Jogador p dj v l c a):js) (h:t)) = verificaChoque pj p
auxEGhoul nj 3 pj (Estado m lj@(j0:j1:j2:(Jogador p dj v l c a):js) (h:t)) = verificaChoque pj p
auxEGhoul _ _ _ _ = False

-- | Verifica se a posiçãofoi atingida pelo choque comparando com a posição do jogador que lançou o choque
verificaChoque :: PosicaoGrelha-> PosicaoGrelha -> Bool
verificaChoque (l,c) (a,b) = elem l [a-3..a+3] && elem c [b-3..b+3]


-- | Função que faz com que o estado reage ao tempo (tick)                        
reageTempo :: Float -> Estado -> Estado
reageTempo n e = tick e

-- | Função que faz com que o estado reage ao tempo (tick), no modoZombie   
reageTempoZ :: Float -> Int -> Int -> Estado -> Estado
reageTempoZ n rz i e = tickZombies rz i (repoeFacadas e)

-- | Função que dá as frames do jogo (animação)
fr :: Int
fr = 20


-- | Função que dá o modo do ecrâ, neste caso fullScreen
dm :: Display
dm = FullScreen

-- ** Criação dos vários estados em Gloss e estrura do jogo

type ListaBots = (Bool,Bool,Bool,Bool)

listaInicial :: ListaBots
listaInicial = (True,True,True,True)

-- | O EstadoGloss engloba não só as animações e imagens do estado como também todas as animações fora desse estado, mas ligadas ao nível em questão
type EstadoGloss = (Int,Bool,Estado,[Picture],Int,Ronda,[Key],Editor,ListaBots)

-- | Utiliza a lista de imagens que criam o estado zombie e transforma-lo num 'EstadoGloss' 
estadoGlossModoZombie :: [Picture] -> EstadoGloss
estadoGlossModoZombie li = (99,True,estadoModoZombie,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss' 
estadoGlossGCE :: [Picture] -> EstadoGloss
estadoGlossGCE li = (1,True,estadoGCE,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss' 
estadoGloss2001 :: [Picture] -> EstadoGloss
estadoGloss2001 li = (2001,True,estadoGCE,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossPH :: [Picture] -> EstadoGloss
estadoGlossPH li = (2,True,estadoPH,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2061 :: [Picture] -> EstadoGloss
estadoGloss2061 li = (2061,True,estadoPH,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossDD :: [Picture] -> EstadoGloss
estadoGlossDD li = (3,True,estadoDD,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2141 :: [Picture] -> EstadoGloss
estadoGloss2141 li = (2141,True,estadoDD,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossBE :: [Picture] -> EstadoGloss
estadoGlossBE li = (4,True,estadoBE,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2091:: [Picture] -> EstadoGloss
estadoGloss2091 li = (2091,True,estadoBE,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossMP :: [Picture] -> EstadoGloss
estadoGlossMP li = (5,True,estadoMP,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2011 :: [Picture] -> EstadoGloss
estadoGloss2011 li = (2011,True,estadoMP,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossBB :: [Picture] -> EstadoGloss
estadoGlossBB li = (6,True,estadoBB,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2041 :: [Picture] -> EstadoGloss
estadoGloss2041 li = (2041,True,estadoBB,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossIP :: [Picture] -> EstadoGloss
estadoGlossIP li = (7,True,estadoIP,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2021 :: [Picture] -> EstadoGloss
estadoGloss2021 li = (2021,True,estadoIP,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossOB :: [Picture] -> EstadoGloss
estadoGlossOB li = (8,True,estadoOB,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2051 :: [Picture] -> EstadoGloss
estadoGloss2051 li = (2051,True,estadoOB,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossBF :: [Picture] -> EstadoGloss
estadoGlossBF li = (9,True,estadoBF,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2031 :: [Picture] -> EstadoGloss
estadoGloss2031 li = (2031,True,estadoBF,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossMD :: [Picture] -> EstadoGloss
estadoGlossMD li = (10,True,estadoPH,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2111 :: [Picture] -> EstadoGloss
estadoGloss2111 li = (2111,True,estadoPH,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossEA :: [Picture] -> EstadoGloss
estadoGlossEA li = (11,True,estadoEA,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2121 :: [Picture] -> EstadoGloss
estadoGloss2121 li = (2121,True,estadoEA,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossMC :: [Picture] -> EstadoGloss
estadoGlossMC li = (12,True,estadoMC,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2161 :: [Picture] -> EstadoGloss
estadoGloss2161 li = (2161,True,estadoMC,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossFB :: [Picture] -> EstadoGloss
estadoGlossFB li = (13,True,estadoFB,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2171 :: [Picture] -> EstadoGloss
estadoGloss2171 li = (2171,True,estadoFB,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossOAS :: [Picture] -> EstadoGloss
estadoGlossOAS li = (14,True,estadoOAS,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossBM :: [Picture] -> EstadoGloss
estadoGlossBM li = (15,True,estadoBM,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2071 :: [Picture] -> EstadoGloss
estadoGloss2071 li = (2071,True,estadoBM,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossOT :: [Picture] -> EstadoGloss
estadoGlossOT li = (16,True,estadoOT,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2101 :: [Picture] -> EstadoGloss
estadoGloss2101 li = (2101,True,estadoOT,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossBK :: [Picture] -> EstadoGloss
estadoGlossBK li = (17,True,estadoBK,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2131 :: [Picture] -> EstadoGloss
estadoGloss2131 li = (2131,True,estadoBK,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossOBA :: [Picture] -> EstadoGloss
estadoGlossOBA li = (18,True,estadoOBA,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2181 :: [Picture] -> EstadoGloss
estadoGloss2181 li = (2181,True,estadoOAS,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2151 :: [Picture] -> EstadoGloss
estadoGloss2151 li = (2151,True,estadoOBA,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossFS :: [Picture] -> EstadoGloss
estadoGlossFS li = (19,True,estadoFS,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2081 :: [Picture] -> EstadoGloss
estadoGloss2081 li = (2081,True,estadoFS,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o estado de um determinado nível e transforma-lo num 'EstadoGloss'
estadoGlossAB :: [Picture] -> EstadoGloss
estadoGlossAB li =(20,True,estadoAB,li,0,0,[],editorInicial [],listaInicial)

estadoGloss2191 :: [Picture] -> EstadoGloss
estadoGloss2191 li =(2191,True,estadoAB,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam o menu inicial e transforma-lo num 'EstadoGloss'
estadoGlossMenu :: [Picture] -> EstadoGloss
estadoGlossMenu li = (-2,True,estadoInicial,li,0,0,[],editorInicial [],listaInicial)

-- | Utiliza a lista de imagens que criam um segundo menu e transforma-lo num 'EstadoGloss'
estadoGlossMenu2 :: [Picture] -> EstadoGloss
estadoGlossMenu2 li = (200,True,estadoInicial,li,0,0,[],editorInicial [],listaInicial)

estadoEditor :: [Picture] -> EstadoGloss
estadoEditor li = (300,True,estadoInicial,li,0,0,[],(Editor (2,2) C O (Destrutivel) (mapaInicial (29,41))),listaInicial)


{- | Função que recebe um 'EstadoGloss' e tranforma-lo numa imagem única

Esta função vai receber um indicador entre 1 e 20, cuja a indicação representa o estado dos niveis pre-defenidos que se encontra em cada 'EstadoGloss'

__Nota:__ Esta função também é utilizada não só para criar uma imagem do modoZombie como também utiliza para criar os diferentes menus do jogo.
-}
desenhaEstadoGloss :: EstadoGloss -> Picture
desenhaEstadoGloss (999,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f1,(sistemaTeclas (-560) 280 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p0), Translate (-875) (-100) (scale 0.75 0.75 p2), Translate (-875) (-300) (scale 0.75 0.75 p3),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 0 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 0 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (1,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f1,(sistemaTeclas (-560) 280 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p0), Translate (-875) (-100) (scale 0.75 0.75 p2), Translate (-875) (-300) (scale 0.75 0.75 p3),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 0 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 0 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (2,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f2,(sistemaTeclas (-570) 300 2 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p5), Translate (-875) 100 (scale 0.75 0.75 p6),sistemaVidaM 2 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 1 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 1 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)                                                                                                                                                                                                                                                                                          
desenhaEstadoGloss (3,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures([Translate 0 0 f3,(sistemaTeclas (-570) 300 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p5), Translate (-875) 100 (scale 0.75 0.75 p7), Translate (-875) (-100) (scale 0.75 0.75 p8), Translate (-875) (-300) (scale 0.75 0.75 p1),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 2 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 2 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (4,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f4,(sistemaTeclas (-570) 300 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p0), Translate (-875) 100 (scale 0.75 0.75 p1), Translate (-875) (-100) (scale 0.75 0.75 p4),Translate (-875) (-300) (scale 0.75 0.75 p14),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 3 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 3 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (5,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f5,(sistemaTeclas (-570) 300 3 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p9), Translate (-875) 100 (scale 0.75 0.75 p6), Translate (-875) (-100) (scale 0.75 0.75 p10),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 4 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 4 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (6,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f6,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p7), Translate (-875) 100 (scale 0.75 0.75 p11), Translate (-875) (-100) (scale 0.75 0.75 p1), Translate (-875) (-300) (scale 0.75 0.75 p4),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 5 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 5 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (7,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f7,(sistemaTeclas (-690) 340 3 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p12), Translate (-875) (-100) (scale 0.75 0.75 p0),sistemaVidaM 3 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 6 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 6 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (8,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f8,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p0), Translate (-875) 100 (scale 0.75 0.75 p1), Translate (-875) (-100) (scale 0.75 0.75 p13), Translate (-875) (-300) (scale 0.75 0.75 p4),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 7 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 7 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (9,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f9,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p8), Translate (-875) 100 (scale 0.75 0.75 p7), Translate (-875) (-100) (scale 0.75 0.75 p1), Translate (-875) (-300) (scale 0.75 0.75 p15),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 8 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 8 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (10,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f10,(sistemaTeclas (-690) 340 2 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p5), Translate (-875) 100 (scale 0.75 0.75 p6),sistemaVidaM 2 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 9 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 9 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (11,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f11,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p4), Translate (-875) (-100) (scale 0.75 0.75 p7), Translate (-875) (-300) (scale 0.75 0.75 p8),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 10 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 10 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (12,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f12,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p4), Translate (-875) (-100) (scale 0.75 0.75 p7), Translate (-875) (-300) (scale 0.75 0.75 p5),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 11 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 11 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (13,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f13,(sistemaTeclas (-690) 340 2 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p0),sistemaVidaM 2 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 12 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos3 width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 12 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (14,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f14,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p0), Translate (-875) 100 (scale 0.75 0.75 p6), Translate (-875) (-100) (scale 0.75 0.75 p17), Translate (-875) (-300) (scale 0.75 0.75 p16),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 13 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 13 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (15,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f15,(sistemaTeclas (-690) 340 3 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p0), Translate (-875) 100 (scale 0.75 0.75 p1), Translate (-875) (-100) (scale 0.75 0.75 p13),sistemaVidaM 3 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 14 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 14 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (16,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f16,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p5), Translate (-875) 100 (scale 0.75 0.75 p7), Translate (-875) (-100) (scale 0.75 0.75 p8), Translate (-875) (-300) (scale 0.75 0.75 p1),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 15 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 15 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (17,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f17,(sistemaTeclas (-690) 340 2 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p0),sistemaVidaM 2 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 16 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 16 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (18,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f18,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p1), Translate (-875) 100 (scale 0.75 0.75 p0), Translate (-875) (-100) (scale 0.75 0.75 p18), Translate (-875) (-300) (scale 0.75 0.75 p12),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 17 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 17 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (19,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f19,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p7), Translate (-875) 100 (scale 0.75 0.75 p11), Translate (-875) (-100) (scale 0.75 0.75 p19), Translate (-875) (-300) (scale 0.75 0.75 p6), sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 18 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 18 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)
desenhaEstadoGloss (20,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 f20,(sistemaTeclas (-690) 340 4 e (teclas4:teclas3:teclas2:[])), Translate (-875) 300 (scale 0.75 0.75 p5), Translate (-875) 100 (scale 0.75 0.75 p7), Translate (-875) (-100) (scale 0.75 0.75 p11), Translate (-875) (-300) (scale 0.75 0.75 p6),sistemaVidaM 4 (-690) 340 (sistemaVida e), Translate 800 (-400) quit] ++ [desenhaEstado 19 (lt:at:wt:ct:tnt:t) e] ++ constroiArbustos width heigth e (lt:at:wt:ct:tnt:[]) ++ [desenhaChoque 19 (lt:at:wt:ct:tnt:t) e] ++ animacaoGhoul 0 (-875) 300 e g ++ animacaoN b 0 (-610) 275 e n ++ animacaoMorte (-875) 300 e d)                                                                                                                                                                                                                                           
desenhaEstadoGloss (99,b,e@(Estado m (x1:x2:(Jogador _ _ _ pp0 pp1 _):j4:j5:z) ld),li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures ([Translate 0 0 fz,Translate (-850) (-450) p0,Translate (-225) (-450) p1,sistemaVidaMZ 2 (-550) (-400) (sistemaVidaZ e), Translate 800 (-400) quit,(Translate (-730) (-475) (sistemaMunicao x1 inf)),Translate (-100) (-475) (sistemaMunicao x2 inf),Translate 340 (-500) (Color white (Text (show rz))),Translate (-490) (-475) (Scale 0.35 0.35 (Color white (Text (show pp0)))),Translate 130 (-475) (Scale 0.35 0.35 (Color white (Text (show pp1))))] ++ [desenhaEstado 99 (vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:lt:at:wt:ct:tnt:t) e] ++ [desenhaCompras m x1 (bp0:bm0:ba0:bs0:bj0:br0:bd0:bk0:bb0:[]), desenhaCompras m x2 (bp1:bm1:ba1:bs1:bj1:br1:bd1:bk1:bb1:[]),desenhaBadges (j4:j5:[]) (jnb:scb:qrb:dtb:[]),(Translate (-550) (-460) (sistemaArma x1 (weapon0:weapon1:weapon2:weapon3:[]))),Translate (80) (-460) (sistemaArma x2 (weapon0:weapon1:weapon2:weapon3:[]))])                                                                                  
desenhaEstadoGloss (-2,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures[(Translate 0 0 f0),(animacaoM (-2) (op2:g:op0:sg:[]))]
desenhaEstadoGloss (-1,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures[(Translate 0 0 f0),(animacaoM (-1) (op2:g:op0:sg:[]))]
desenhaEstadoGloss (0,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures[(Translate 0 0 f0),(animacaoM 0 (op2:g:op0:sg:[]))]
desenhaEstadoGloss (100,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:t),i,rz,_,_,_) = (Translate 0 0 f100)
desenhaEstadoGloss (300,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,editor@(Editor pe de te we me),_) = Pictures([Translate 0 0 e0,Translate 200 400 (Scale 0.12 0.12 (Color white (Text (show (fst pe))))),Translate 250 400 (Scale 0.12 0.12 (Color white (Text (show (snd pe)))))]++(frameEditor i editor heigth (lt:at:wt:ct:tnt:[])) ++ (constroiArbustos width heigth e (lt:at:wt:ct:tnt:[])))
desenhaEstadoGloss (301,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,editor@(Editor pe de te we me),_) = Pictures([Translate 0 0 e1,Translate 200 400 (Scale 0.12 0.12 (Color white (Text (show (fst pe))))),Translate 250 400 (Scale 0.12 0.12 (Color white (Text (show (snd pe)))))]++(frameEditor i editor heigth (lt:at:wt:ct:tnt:[])) ++ (constroiArbustos width heigth e (lt:at:wt:ct:tnt:[])))
desenhaEstadoGloss (302,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,editor@(Editor pe de te we me),_) = Pictures([Translate 0 0 e2,Translate 200 400 (Scale 0.12 0.12 (Color white (Text (show (fst pe))))),Translate 250 400 (Scale 0.12 0.12 (Color white (Text (show (snd pe)))))]++(frameEditor i editor heigth (lt:at:wt:ct:tnt:[])) ++ (constroiArbustos width heigth e (lt:at:wt:ct:tnt:[])))
desenhaEstadoGloss (303,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,editor@(Editor pe de te we me),_) = Pictures([Translate 0 0 e3,Translate 200 400 (Scale 0.12 0.12 (Color white (Text (show (fst pe))))),Translate 250 400 (Scale 0.12 0.12 (Color white (Text (show (snd pe)))))]++(frameEditor i editor heigth (lt:at:wt:ct:tnt:[])) ++ (constroiArbustos width heigth e (lt:at:wt:ct:tnt:[])))
desenhaEstadoGloss (2001,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b1a] ++ [desenhaEstado 2001 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2001 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2002,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b1b] ++ [desenhaEstado 2001 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2001 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2003,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b1c] ++ [desenhaEstado 2001 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2001 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2004,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b1d] ++ [desenhaEstado 2001 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2001 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2011,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b2a] ++ [desenhaEstado 2011 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2011 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2012,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b2b] ++ [desenhaEstado 2011 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2011 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2013,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b2c] ++ [desenhaEstado 2011 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2011 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2021,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b3a] ++ [desenhaEstado 2021 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2021 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2022,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b3b] ++ [desenhaEstado 2021 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2021 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2023,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b3c] ++ [desenhaEstado 2021 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2021 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2031,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b4a] ++ [desenhaEstado 2031 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2031 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2032,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b4b] ++ [desenhaEstado 2031 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2031 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2033,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b4c] ++ [desenhaEstado 2031 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2031 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2034,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b4d] ++ [desenhaEstado 2031 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2031 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2041,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b5a] ++ [desenhaEstado 2041 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2041 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2042,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b5b] ++ [desenhaEstado 2041 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2041 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2043,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b5c] ++ [desenhaEstado 2041 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2041 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2044,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b5d] ++ [desenhaEstado 2041 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2041 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2051,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b6a] ++ [desenhaEstado 2051 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2051 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2052,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b6b] ++ [desenhaEstado 2051 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2051 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2053,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b6c] ++ [desenhaEstado 2051 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2051 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2054,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b6d] ++ [desenhaEstado 2051 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2051 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2061,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b7a] ++ [desenhaEstado 2061 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2061 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2062,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b7b] ++ [desenhaEstado 2061 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2061 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2071,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b8a] ++ [desenhaEstado 2071 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2071 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2072,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b8b] ++ [desenhaEstado 2071 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2071 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2073,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b8c] ++ [desenhaEstado 2071 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2071 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2081,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b9a] ++ [desenhaEstado 2081 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2081 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2082,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b9b] ++ [desenhaEstado 2081 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2081 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2083,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b9c] ++ [desenhaEstado 2081 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2081 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2084,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b9d] ++ [desenhaEstado 2081 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2081 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2091,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b10a] ++ [desenhaEstado 2091 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2091 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2092,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b10b] ++ [desenhaEstado 2091 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2091 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2093,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b10c] ++ [desenhaEstado 2091 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2091 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2094,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b10d] ++ [desenhaEstado 2091 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2091 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2101,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b11a] ++ [desenhaEstado 2101 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2101 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2102,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b11b] ++ [desenhaEstado 2101 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2101 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2103,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b11c] ++ [desenhaEstado 2101 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2101 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2104,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b11d] ++ [desenhaEstado 2101 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2101 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2111,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b12a] ++ [desenhaEstado 2111 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2111 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2112,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b12b] ++ [desenhaEstado 2111 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2111 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2121,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b13a] ++ [desenhaEstado 2121 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2121 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2122,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b13b] ++ [desenhaEstado 2121 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2121 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2123,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b13c] ++ [desenhaEstado 2121 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2121 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2124,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b13d] ++ [desenhaEstado 2121 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2121 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2131,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b14a] ++ [desenhaEstado 2131 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2131 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2132,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b14b] ++ [desenhaEstado 2131 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2131 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2141,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b15a] ++ [desenhaEstado 2141 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2141 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2142,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b15b] ++ [desenhaEstado 2141 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2141 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2143,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b15c] ++ [desenhaEstado 2141 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2141 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2144,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b15d] ++ [desenhaEstado 2141 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2141 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2151,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b16a] ++ [desenhaEstado 2151 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2151 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2152,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b16b] ++ [desenhaEstado 2151 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2151 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2153,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b16c] ++ [desenhaEstado 2151 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2151 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2154,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b16d] ++ [desenhaEstado 2151 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2151 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2161,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b17a] ++ [desenhaEstado 2161 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2161 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2162,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b17b] ++ [desenhaEstado 2161 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2161 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2163,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b17c] ++ [desenhaEstado 2161 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2161 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2164,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b17d] ++ [desenhaEstado 2161 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2161 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2171,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b18a] ++ [desenhaEstado 2171 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos4 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2171 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2172,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b18b] ++ [desenhaEstado 2171 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos4 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2171 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2181,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b19a] ++ [desenhaEstado 2181 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2181 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2182,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b19b] ++ [desenhaEstado 2181 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2181 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2183,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b19c] ++ [desenhaEstado 2181 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2181 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2184,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b19d] ++ [desenhaEstado 2181 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2181 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2191,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b20a] ++ [desenhaEstado 2191 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2191 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2192,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b20b] ++ [desenhaEstado 2191 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2191 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2193,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b20c] ++ [desenhaEstado 2191 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2191 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (2194,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) =  Pictures([Translate 0 0 b20d] ++ [desenhaEstado 2191 (lt:at:wt:ct:tnt:t) e] ++ [(constroiArbustos2 (width+w2) (heigth+h2) e (lt:at:wt:ct:tnt:[]))] ++ [desenhaChoque 2191 (lt:at:wt:ct:tnt:t) e])
desenhaEstadoGloss (i0,b,e,li@(e0:e1:e2:e3:b1a:b1b:b1c:b1d:b2a:b2b:b2c:b3a:b3b:b3c:b4a:b4b:b4c:b4d:b5a:b5b:b5c:b5d:b6a:b6b:b6c:b6d:b7a:b7b:b8a:b8b:b8c:b9a:b9b:b9c:b9d:b10a:b10b:b10c:b10d:b11a:b11b:b11c:b11d:b12a:b12b:b13a:b13b:b13c:b13d:b14a:b14b:b15a:b15b:b15c:b15d:b16a:b16b:b16c:b16d:b17a:b17b:b17c:b17d:b18a:b18b:b19a:b19b:b19c:b19d:b20a:b20b:b20c:b20d:inf:weapon0:weapon1:weapon2:weapon3:teclas4:teclas3:teclas2:quit:jnb:scb:qrb:dtb:bp0:bp1:bm0:bm1:ba0:ba1:bs0:bs1:bj0:bj1:br0:br1:bd0:bd1:bk0:bk1:bb0:bb1:vm0:vm1:vm2:vm3:vm4:vm5:vm6:vm7:tnt:op0:sg:op2:at:lt:wt:ct:f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:f0:f1:f2:f3:f4:f5:f6:f7:f8:f9:f10:f11:f12:f13:f14:f15:f16:f17:f18:f19:f20:f100:fz:fb:p0:p1:p2:p3:p4:p5:p6:p7:p8:p9:p10:p11:p12:p13:p14:p15:p16:p17:p18:p19:d:g:n:t),i,rz,_,_,_) = Pictures ([Translate 0 0 (encontraIndiceLista (i0-200) (f201:f202:f203:f204:f205:f206:f207:f208:f209:f210:f211:f212:f213:f214:f215:f216:f217:f218:f219:f220:[]))])                     

frameEditor :: Int -> Editor -> Float -> [Picture] -> [Picture]
frameEditor i (Editor pe de te we me) y tx = if mod i 3 == 0 then desenhaEditor y (auxDesenha pe de te (Bloco we) me) tx
                                             else desenhaEditor y me tx

desenhaEditor :: Float -> Mapa -> [Picture] -> [Picture]
desenhaEditor y (h:t) tx = constroiLinhaEditor width y h tx ++ desenhaEditor (y-l) t tx
desenhaEditor _ _ _ = []

--constroiJogadores i ld m ((Jogador (x,y) B v l c):t) (im:is) = (Translate (p0 i ld y) (p1 i ld x) im) : (constroiJogadores i ld m t is)

meteTetronimo :: Mapa -> Editor -> Mapa
meteTetronimo m (Editor pe de te we me) = (auxDesenha pe de te (Bloco Destrutivel) me)

sistemaTeclas :: Float -> Float -> Int -> Estado -> [Picture] -> Picture
sistemaTeclas l c 4 e (x:y:z:[]) = Pictures [x,sistemaTeclas l c 0 e []]
sistemaTeclas l c 3 e (x:y:z:[]) = Pictures [y,sistemaTeclas l c 0 e []]
sistemaTeclas l c 2 e (x:y:z:[]) = Pictures [z,sistemaTeclas l c 0 e []]
sistemaTeclas l c 0 e@(Estado m ((Jogador pj dj vj l0 c0 _):t) ld) [] = Pictures [Translate c l (Scale 0.12 0.12 (Color white (Text (show l0)))),Translate (c+50) l (Scale 0.12 0.12 (Color white (Text (show c0)))),(sistemaTeclas c (l-10) 0 (Estado m t ld) [])]
sistemaTeclas _ _ _ _ _ = Blank


-- | Função utilizada no modoZombie que aumenta os desenhos dos zombies a cada ronda
desenhaBadges :: [Jogador] -> [Picture] -> Picture
desenhaBadges ((Jogador _ _ a0 b0 c0 arma0):(Jogador _ _ a1 b1 c1 arma1):[]) (x:y:z:v:[]) = Pictures [desenha1 a0 x,desenha2 b0 y,desenha3 c0 z,desenha4 a1 x,desenha5 b1 y,desenha6 c1 z,desenha7 arma0 v,desenha8 arma1 v]

-- | Função que desenha os zombies no mapa na ronda 1
desenha1 :: Int -> Picture -> Picture
desenha1 1 x = Translate (-705) (-510) (Scale 0.7 0.7 x)
desenha1 _ _ = Blank

-- | Função que desenha os zombies no mapa na ronda 2
desenha2 :: Int -> Picture -> Picture
desenha2 1 y = Translate (-645) (-510) (Scale 0.7 0.7 y)
desenha2 _ _ = Blank

-- | Função que desenha os zombies no mapa na ronda 3
desenha3 :: Int -> Picture -> Picture
desenha3 1 z = Translate (-585) (-510) (Scale 0.7 0.7 z)
desenha3 _ _ = Blank

-- | Função que desenha os zombies no mapa na ronda 4
desenha4 :: Int -> Picture -> Picture
desenha4 1 x = Translate (-75) (-510) (Scale 0.7 0.7 x)
desenha4 _ _ = Blank

-- | Função que desenha os zombies no mapa na ronda 5
desenha5 :: Int -> Picture -> Picture
desenha5 1 y = Translate (-15) (-510) (Scale 0.7 0.7 y)
desenha5 _ _ = Blank

-- | Função que desenha os zombies no mapa na ronda 6
desenha6 :: Int -> Picture -> Picture
desenha6 1 z = Translate 45 (-510) (Scale 0.7 0.7 z)
desenha6 _ _ = Blank

desenha7 :: ArmaZ -> Picture -> Picture
desenha7 Faca v = Translate (-525) (-510) (Scale 0.7 0.7 v)
desenha7 _ _ = Blank

desenha8 :: ArmaZ -> Picture -> Picture
desenha8 Faca v = Translate 105 (-510) (Scale 0.7 0.7 v)
desenha8 _ _ = Blank 

-- | Função que desenha a jogada compras no modoZombie
desenhaCompras :: Mapa -> Jogador -> [Picture] -> Picture
desenhaCompras m (Jogador pj@(x,y) dj v l c a) (bp:bm:ba:bs:bj:br:bd:bk:bb:[]) | caraJogador m pj dj (Porta) = (Translate (p0 1 lz y) (p1 1 lz x) bp)
                                                                               | caraJogador m pj dj (V3) = (Translate (p0 1 lz y) (p1 1 lz x) bm)
                                                                               | caraJogador m pj dj (V2) = (Translate (p0 1 lz y) (p1 1 lz x) ba)
                                                                               | caraJogador m pj dj (V1) = (Translate (p0 1 lz y) (p1 1 lz x) bs)
                                                                               | caraJogador m pj dj (V0) = (Translate (p0 1 lz y) (p1 1 lz x) bj)
                                                                               | caraJogador m pj dj (V4) = (Translate (p0 1 lz y) (p1 1 lz x) br)
                                                                               | caraJogador m pj dj (V5) = (Translate (p0 1 lz y) (p1 1 lz x) bd)
                                                                               | caraJogador m pj dj (V6) = (Translate (p0 1 lz y) (p1 1 lz x) bk)
                                                                               | caraJogador m pj dj (V7) = (Translate (p0 1 lz y) (p1 1 lz x) bb)
                                                                               | otherwise = Blank


sistemaArma :: Jogador -> [Picture] -> Picture
sistemaArma (Jogador _ _ _ _ _ Pistol) (a:b:c:d:[]) = (Scale 0.5 0.5 a)
sistemaArma (Jogador _ _ _ _ _ AK47) (a:b:c:d:[]) = (Scale 0.3 0.5 c)
sistemaArma (Jogador _ _ _ _ _ M8A1) (a:b:c:d:[]) = (Scale 0.3 0.5 d)
sistemaArma _ (a:b:c:d:[]) = (Scale 0.5 0.75 b)

-- | Função que desenha o sistema de munições do modoZombie
sistemaMunicao :: Jogador -> Picture -> Picture
sistemaMunicao (Jogador _ _ _ _ _ Faca) pic = (Translate 65 20 (Scale 0.7 0.5 pic))
sistemaMunicao (Jogador _ _ _ _ _ Strike) pic = (Translate 65 20 (Scale 0.7 0.5 pic))
sistemaMunicao (Jogador _ _ _ 0 0 _) pic = Scale 0.35 0.35 (Pictures[(Color red (Text "0")),(Color white (Text " |")),(Color red (Text "  0"))])
sistemaMunicao (Jogador _ _ _ l 0 _) pic = if l == 10 then Scale 0.35 0.35 (Pictures[(Color white (Text (show l ++ " |"))),(Color red (Text " 0"))]) else Scale 0.35 0.35 (Pictures[(Color white (Text (show l ++ "|"))),(Color red (Text " 0"))])
sistemaMunicao (Jogador _ _ _ 0 c _) pic = Scale 0.35 0.35 (Pictures[(Color red (Text "0")),(Color white (Text (" |" ++ show c)))])
sistemaMunicao (Jogador _ _ _ l c _) pic = Scale 0.35 0.35 (Color white (Text (show l ++ "|" ++ show c)))

-- | Função que desenha a animação na seleção de menu, logo na página inicial do jogo
animacaoM :: Int -> [Picture] -> Picture
animacaoM (-2) (a:b:c:d:[]) = (Translate (-845) 155 a)
animacaoM (-1) (a:b:c:d:[]) = (Translate (-845) 45 a)
animacaoM 0 (a:b:c:d:[]) = (Translate (-845) (-65) a)


botFrame :: Int -> Int -> Int -> Bool -> Estado -> ListaBots -> Estado
botFrame x y z b e@(Estado _ (j0:j1:j2:j3:[]) _) (True,True,True,True) = jogada b 0 (bot 0 e) (jogada b 1 (bot 1 e) (jogada b 2 (bot 2 e) (jogada b 3 (bot 3 e) e)))
botFrame x y z b e@(Estado _ (j0:j1:j2:[]) _) (True,True,True,True) = (jogada b 0 (bot 0 e) (jogada b 1 (bot 1 e) (jogada b 2 (bot 2 e) e)))
botFrame x y z b e@(Estado _ (j0:j1:[]) _) (True,True,True,True) = jogada b 0 (bot 0 e) (jogada b 1 (bot 1 e) e)
botFrame x y z b e@(Estado _ (j0:j1:j2:j3:[]) _) (False,True,True,True) = jogada b 1 (bot 1 e) (jogada b 2 (bot 2 e) (jogada b 3 (bot 3 e) e))
botFrame x y z b e@(Estado _ (j0:j1:j2:[]) _) (False,True,True,True) = jogada b 1 (bot 1 e) (jogada b 2 (bot 2 e) e)
botFrame x y z b e@(Estado _ (j0:j1:[]) _) (False,True,True,True) = jogada b 1 (bot 1 e) e
botFrame x y z b e@(Estado _ (j0:j1:j2:j3:[]) _) (False,False,True,True) = jogada b 2 (bot 2 e) (jogada b 3 (bot 3 e) e)
botFrame x y z b e@(Estado _ (j0:j1:j2:[]) _) (False,False,True,True) = jogada b 2 (bot 2 e) e
botFrame x y z b e@(Estado _ (j0:j1:j2:j3:[]) _) (False,False,False,True) = jogada b 3 (bot 3 e) e
botFrame _ _ _ _ e _ = e


-- | Função que altera o 'EstadoGloss' á medida que este reage ao tempo
reageTempoGloss :: Float -> EstadoGloss -> EstadoGloss
reageTempoGloss t (300,b,e,li,i,rz,k,editor,lb) = (300,b,e,li,i,rz,k,(aplicaListaEditor k editor),lb)
reageTempoGloss t e@(99,b,(Estado m ((Jogador _ _ 0 _ _ _):(Jogador _ _ 0 _ _ _):x:(Jogador _ _ _ _ 0 _):(Jogador _ _ _ _ 0 _):z) ld),li,i,rz,k,editor,lb) = e
reageTempoGloss t (99,True,e@(Estado m (x:y:z:a:b:[]) ld),li,i,rz,k,editor,lb) = (99,False,reageTempoZ t rz i (aplicaListaKeyZ k False e),li,i+1,rz+1,k,editor,lb)
reageTempoGloss t (99,True,e,li,i,rz,k,editor,lb) = (99,False,reageTempoZ t rz i (aplicaListaKeyZ k False e),li,i+1,rz,k,editor,lb)
reageTempoGloss t (99,False,e@(Estado m (x:y:z:a:b:[]) ld),li,i,rz,k,editor,lb) = (99,True,reageTempoZ t rz i (aplicaListaKeyZ k True e),li,i+1,rz+1,k,editor,lb)
reageTempoGloss t (99,False,e,li,i,rz,k,editor,lb) = (99,True,reageTempoZ t rz i (aplicaListaKeyZ k True e),li,i+1,rz,k,editor,lb)
reageTempoGloss t (n,b,e,li,i,rz,k,editor,lb) = if mod i 2 == 0 then (n,(not b),reageTempo t (aplicaListaKey k (not b) (botFrame 1 1 1 (not b) e lb)),li,i+1,rz,k,editor,lb) else (n,(not b),reageTempo t e,li,i+1,rz,k,editor,lb) 

{- | Função que reage a um comando do utilizador quando este muda de mapa, modo ou menu

Esta função cria um 'EstadoGloss' dependendo da tecla que o utilizador percione.
Á medida que perciona na tecla a função utiliza as funções auxiliares do estadoGloss. A função auxiliar que é utilizada depende do estado que se seguirá ao estado atual.   
-}
mudaMenu :: Event -> EstadoGloss -> EstadoGloss
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (-2,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (-1,b,e,li,i,rz,_,editor,lb) = estadoGlossModoZombie li
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (0,b,e,li,i,rz,_,editor,lb) = estadoEditor li
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (200,b,e,li,i,rz,_,editor,lb) = estadoGloss2001 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2001,b,e,li,i,rz,k,editor,lb) = (2002,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2002,b,e,li,i,rz,k,editor,lb) = (2003,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2003,b,e,li,i,rz,k,editor,lb) = (2004,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2004,b,e,li,i,rz,k,editor,lb) = (2003,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2003,b,e,li,i,rz,k,editor,lb) = (2002,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2002,b,e,li,i,rz,k,editor,lb) = (2001,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2001,b,e,li,i,rz,k,editor,lb) =  (200,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2002,b,e,li,i,rz,k,editor,lb) =  (200,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2003,b,e,li,i,rz,k,editor,lb) =  (200,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2004,b,e,li,i,rz,k,editor,lb) =  (200,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2001,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossGCE li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2002,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossGCE li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2003,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossGCE li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2004,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossGCE li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (201,b,e,li,i,rz,_,editor,lb) = estadoGloss2011 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2011,b,e,li,i,rz,k,editor,lb) = (2012,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2012,b,e,li,i,rz,k,editor,lb) = (2013,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2013,b,e,li,i,rz,k,editor,lb) = (2012,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2012,b,e,li,i,rz,k,editor,lb) = (2011,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2011,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMP li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2012,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMP li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2013,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMP li) (False,False,False,True)
mudaMenu (EventKey (Char 'q') Down _ _) (2011,b,e,li,i,rz,k,editor,lb) =  (201,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2012,b,e,li,i,rz,k,editor,lb) =  (201,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2013,b,e,li,i,rz,k,editor,lb) =  (201,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (202,b,e,li,i,rz,_,editor,lb) = estadoGloss2021 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2021,b,e,li,i,rz,k,editor,lb) = (2022,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2022,b,e,li,i,rz,k,editor,lb) = (2023,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2023,b,e,li,i,rz,k,editor,lb) = (2022,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2022,b,e,li,i,rz,k,editor,lb) = (2021,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2021,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossIP li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2022,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossIP li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2023,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossIP li) (False,False,True,True)
mudaMenu (EventKey (Char 'q') Down _ _) (2021,b,e,li,i,rz,k,editor,lb) =  (202,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2022,b,e,li,i,rz,k,editor,lb) =  (202,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2023,b,e,li,i,rz,k,editor,lb) =  (202,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (203,b,e,li,i,rz,_,editor,lb) = estadoGloss2031 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2031,b,e,li,i,rz,k,editor,lb) = (2032,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2032,b,e,li,i,rz,k,editor,lb) = (2033,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2033,b,e,li,i,rz,k,editor,lb) = (2034,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2034,b,e,li,i,rz,k,editor,lb) = (2033,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2033,b,e,li,i,rz,k,editor,lb) = (2032,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2032,b,e,li,i,rz,k,editor,lb) = (2031,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2031,b,e,li,i,rz,k,editor,lb) =  (203,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2032,b,e,li,i,rz,k,editor,lb) =  (203,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2033,b,e,li,i,rz,k,editor,lb) =  (203,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2034,b,e,li,i,rz,k,editor,lb) =  (203,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2031,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBF li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2032,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBF li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2033,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBF li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2034,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBF li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (204,b,e,li,i,rz,_,editor,lb) = estadoGloss2041 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2041,b,e,li,i,rz,k,editor,lb) = (2042,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2042,b,e,li,i,rz,k,editor,lb) = (2043,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2043,b,e,li,i,rz,k,editor,lb) = (2044,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2044,b,e,li,i,rz,k,editor,lb) = (2043,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2043,b,e,li,i,rz,k,editor,lb) = (2042,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2042,b,e,li,i,rz,k,editor,lb) = (2041,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2041,b,e,li,i,rz,k,editor,lb) =  (204,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2042,b,e,li,i,rz,k,editor,lb) =  (204,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2043,b,e,li,i,rz,k,editor,lb) =  (204,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2044,b,e,li,i,rz,k,editor,lb) =  (204,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2041,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBB li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2042,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBB li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2043,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBB li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2044,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBB li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (205,b,e,li,i,rz,_,editor,lb) = estadoGloss2051 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2051,b,e,li,i,rz,k,editor,lb) = (2052,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2052,b,e,li,i,rz,k,editor,lb) = (2053,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2053,b,e,li,i,rz,k,editor,lb) = (2054,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2054,b,e,li,i,rz,k,editor,lb) = (2053,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2053,b,e,li,i,rz,k,editor,lb) = (2052,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2052,b,e,li,i,rz,k,editor,lb) = (2051,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2051,b,e,li,i,rz,k,editor,lb) =  (205,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2052,b,e,li,i,rz,k,editor,lb) =  (205,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2053,b,e,li,i,rz,k,editor,lb) =  (205,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2054,b,e,li,i,rz,k,editor,lb) =  (205,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2051,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOB li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2052,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOB li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2053,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOB li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2054,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOB li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (206,b,e,li,i,rz,_,editor,lb) = estadoGloss2061 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2061,b,e,li,i,rz,k,editor,lb) = (2062,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2062,b,e,li,i,rz,k,editor,lb) = (2061,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2061,b,e,li,i,rz,k,editor,lb) =  (206,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2062,b,e,li,i,rz,k,editor,lb) =  (206,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2061,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossPH li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2062,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossPH li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (207,b,e,li,i,rz,_,editor,lb) = estadoGloss2071 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2071,b,e,li,i,rz,k,editor,lb) = (2072,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2072,b,e,li,i,rz,k,editor,lb) = (2073,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2073,b,e,li,i,rz,k,editor,lb) = (2072,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2072,b,e,li,i,rz,k,editor,lb) = (2071,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2071,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBM li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2072,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBM li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2073,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBM li) (False,False,False,True)
mudaMenu (EventKey (Char 'q') Down _ _) (2071,b,e,li,i,rz,k,editor,lb) =  (207,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2072,b,e,li,i,rz,k,editor,lb) =  (207,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2073,b,e,li,i,rz,k,editor,lb) =  (207,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (208,b,e,li,i,rz,_,editor,lb) = estadoGloss2081 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2081,b,e,li,i,rz,k,editor,lb) = (2082,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2082,b,e,li,i,rz,k,editor,lb) = (2083,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2083,b,e,li,i,rz,k,editor,lb) = (2084,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2084,b,e,li,i,rz,k,editor,lb) = (2083,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2083,b,e,li,i,rz,k,editor,lb) = (2082,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2082,b,e,li,i,rz,k,editor,lb) = (2081,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2081,b,e,li,i,rz,k,editor,lb) =  (208,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2082,b,e,li,i,rz,k,editor,lb) =  (208,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2083,b,e,li,i,rz,k,editor,lb) =  (208,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2084,b,e,li,i,rz,k,editor,lb) =  (208,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2081,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFS li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2082,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFS li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2083,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFS li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2084,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFS li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (209,b,e,li,i,rz,_,editor,lb) = estadoGloss2091 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2091,b,e,li,i,rz,k,editor,lb) = (2092,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2092,b,e,li,i,rz,k,editor,lb) = (2093,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2093,b,e,li,i,rz,k,editor,lb) = (2094,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2094,b,e,li,i,rz,k,editor,lb) = (2093,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2093,b,e,li,i,rz,k,editor,lb) = (2092,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2092,b,e,li,i,rz,k,editor,lb) = (2091,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2091,b,e,li,i,rz,k,editor,lb) =  (209,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2092,b,e,li,i,rz,k,editor,lb) =  (209,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2093,b,e,li,i,rz,k,editor,lb) =  (209,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2094,b,e,li,i,rz,k,editor,lb) =  (209,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2091,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBE li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2092,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBE li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2093,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBE li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2094,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBE li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (210,b,e,li,i,rz,_,editor,lb) = estadoGloss2101 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2101,b,e,li,i,rz,k,editor,lb) = (2102,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2102,b,e,li,i,rz,k,editor,lb) = (2103,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2103,b,e,li,i,rz,k,editor,lb) = (2104,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2104,b,e,li,i,rz,k,editor,lb) = (2103,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2103,b,e,li,i,rz,k,editor,lb) = (2102,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2102,b,e,li,i,rz,k,editor,lb) = (2101,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2101,b,e,li,i,rz,k,editor,lb) =  (210,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2102,b,e,li,i,rz,k,editor,lb) =  (210,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2103,b,e,li,i,rz,k,editor,lb) =  (210,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2104,b,e,li,i,rz,k,editor,lb) =  (210,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2101,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOT li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2102,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOT li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2103,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOT li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2104,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOT li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (211,b,e,li,i,rz,_,editor,lb) = estadoGloss2111 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2111,b,e,li,i,rz,k,editor,lb) = (2112,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2112,b,e,li,i,rz,k,editor,lb) = (2111,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2111,b,e,li,i,rz,k,editor,lb) =  (211,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2112,b,e,li,i,rz,k,editor,lb) =  (211,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2111,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMD li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2112,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMD li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (212,b,e,li,i,rz,_,editor,lb) = estadoGloss2121 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2121,b,e,li,i,rz,k,editor,lb) = (2122,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2122,b,e,li,i,rz,k,editor,lb) = (2123,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2123,b,e,li,i,rz,k,editor,lb) = (2124,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2124,b,e,li,i,rz,k,editor,lb) = (2123,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2123,b,e,li,i,rz,k,editor,lb) = (2122,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2122,b,e,li,i,rz,k,editor,lb) = (2121,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2121,b,e,li,i,rz,k,editor,lb) =  (212,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2122,b,e,li,i,rz,k,editor,lb) =  (212,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2123,b,e,li,i,rz,k,editor,lb) =  (212,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2124,b,e,li,i,rz,k,editor,lb) =  (212,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2121,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossEA li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2122,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossEA li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2123,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossEA li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2124,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossEA li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (213,b,e,li,i,rz,_,editor,lb) = estadoGloss2131 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2131,b,e,li,i,rz,k,editor,lb) = (2132,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2132,b,e,li,i,rz,k,editor,lb) = (2131,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2131,b,e,li,i,rz,k,editor,lb) =  (213,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2132,b,e,li,i,rz,k,editor,lb) =  (213,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2131,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBK li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2132,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossBK li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (214,b,e,li,i,rz,_,editor,lb) = estadoGloss2141 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2141,b,e,li,i,rz,k,editor,lb) = (2142,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2142,b,e,li,i,rz,k,editor,lb) = (2143,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2143,b,e,li,i,rz,k,editor,lb) = (2144,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2144,b,e,li,i,rz,k,editor,lb) = (2143,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2143,b,e,li,i,rz,k,editor,lb) = (2142,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2142,b,e,li,i,rz,k,editor,lb) = (2141,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2141,b,e,li,i,rz,k,editor,lb) =  (214,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2142,b,e,li,i,rz,k,editor,lb) =  (214,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2143,b,e,li,i,rz,k,editor,lb) =  (214,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2144,b,e,li,i,rz,k,editor,lb) =  (214,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2141,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossDD li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2142,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossDD li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2143,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossDD li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2144,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossDD li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (215,b,e,li,i,rz,_,editor,lb) = estadoGloss2151 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2151,b,e,li,i,rz,k,editor,lb) = (2152,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2152,b,e,li,i,rz,k,editor,lb) = (2153,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2153,b,e,li,i,rz,k,editor,lb) = (2154,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2154,b,e,li,i,rz,k,editor,lb) = (2153,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2153,b,e,li,i,rz,k,editor,lb) = (2152,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2152,b,e,li,i,rz,k,editor,lb) = (2151,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2151,b,e,li,i,rz,k,editor,lb) =  (215,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2152,b,e,li,i,rz,k,editor,lb) =  (215,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2153,b,e,li,i,rz,k,editor,lb) =  (215,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2154,b,e,li,i,rz,k,editor,lb) =  (215,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2151,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOBA li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2152,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOBA li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2153,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOBA li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2154,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOBA li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (216,b,e,li,i,rz,_,editor,lb) = estadoGloss2161 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2161,b,e,li,i,rz,k,editor,lb) = (2162,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2162,b,e,li,i,rz,k,editor,lb) = (2163,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2163,b,e,li,i,rz,k,editor,lb) = (2164,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2164,b,e,li,i,rz,k,editor,lb) = (2163,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2163,b,e,li,i,rz,k,editor,lb) = (2162,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2162,b,e,li,i,rz,k,editor,lb) = (2161,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2161,b,e,li,i,rz,k,editor,lb) =  (216,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2162,b,e,li,i,rz,k,editor,lb) =  (216,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2163,b,e,li,i,rz,k,editor,lb) =  (216,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2164,b,e,li,i,rz,k,editor,lb) =  (216,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2161,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMC li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2162,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMC li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2163,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMC li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2164,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossMC li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (217,b,e,li,i,rz,_,editor,lb) = estadoGloss2171 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2171,b,e,li,i,rz,k,editor,lb) = (2172,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2172,b,e,li,i,rz,k,editor,lb) = (2171,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2171,b,e,li,i,rz,k,editor,lb) =  (217,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2172,b,e,li,i,rz,k,editor,lb) =  (217,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2171,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFB li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2172,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossFB li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (218,b,e,li,i,rz,_,editor,lb) = estadoGloss2181 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2181,b,e,li,i,rz,k,editor,lb) = (2182,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2182,b,e,li,i,rz,k,editor,lb) = (2183,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2183,b,e,li,i,rz,k,editor,lb) = (2184,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2184,b,e,li,i,rz,k,editor,lb) = (2183,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2183,b,e,li,i,rz,k,editor,lb) = (2182,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2182,b,e,li,i,rz,k,editor,lb) = (2181,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2181,b,e,li,i,rz,k,editor,lb) =  (218,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2182,b,e,li,i,rz,k,editor,lb) =  (218,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2183,b,e,li,i,rz,k,editor,lb) =  (218,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2184,b,e,li,i,rz,k,editor,lb) =  (218,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2181,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOAS li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2182,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOAS li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2183,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOAS li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2184,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossOAS li) (False,False,False,False)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (219,b,e,li,i,rz,_,editor,lb) = estadoGloss2191 li
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2191,b,e,li,i,rz,k,editor,lb) = (2192,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2192,b,e,li,i,rz,k,editor,lb) = (2193,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyRight) Down _ _) (2193,b,e,li,i,rz,k,editor,lb) = (2194,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2194,b,e,li,i,rz,k,editor,lb) = (2193,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2193,b,e,li,i,rz,k,editor,lb) = (2192,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyLeft) Down _ _) (2192,b,e,li,i,rz,k,editor,lb) = (2191,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2191,b,e,li,i,rz,k,editor,lb) =  (219,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2192,b,e,li,i,rz,k,editor,lb) =  (219,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2193,b,e,li,i,rz,k,editor,lb) =  (219,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (Char 'q') Down _ _) (2194,b,e,li,i,rz,k,editor,lb) =  (219,b,e,li,i,rz,k,editor,lb)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2191,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossAB li) (False,True,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2192,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossAB li) (False,False,True,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2193,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossAB li) (False,False,False,True)
mudaMenu (EventKey (SpecialKey KeyEnter) Down _ _) (2194,b,e,li,i,rz,_,editor,lb) = aplicaBotEstadoGloss (estadoGlossAB li) (False,False,False,False)
mudaMenu (EventKey (Char 'q') Down _ _) (1,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (2,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (3,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (4,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (5,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (6,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (7,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (8,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (9,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (10,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (11,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (12,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (13,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (14,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (15,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (16,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (17,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (18,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (19,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (20,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu2 li
mudaMenu (EventKey (Char 'q') Down _ _) (99,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (200,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (201,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (202,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (203,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (204,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (205,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (206,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (207,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (208,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (209,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (210,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (211,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (212,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (213,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (214,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (215,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (216,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (217,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (218,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (219,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu (EventKey (Char 'q') Down _ _) (100,b,e,li,i,rz,_,editor,lb) = estadoGlossMenu li
mudaMenu _ i = i

{- | Função que muda entre estados,_

Esta função altera os bools para fazer animações e por exemplo que o movimento abrande quando jogador estiver na água
-}
reageEventoGloss :: Event -> EstadoGloss -> EstadoGloss
reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (300,b,e,li,i,rz,k,editor,lb)  = (999,b,(Estado (auxConstroi editor) [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] []),li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (301,b,e,li,i,rz,k,editor,lb)  = (999,b,(Estado (auxConstroi editor) [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] []),li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (302,b,e,li,i,rz,k,editor,lb)  = (999,b,(Estado (auxConstroi editor) [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] []),li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (303,b,e,li,i,rz,k,editor,lb)  = (999,b,(Estado (auxConstroi editor) [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] []),li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (300,b,e,li,i,rz,k,editor,(False,True,True,True)) = (301,b,e,li,i,rz,k,editor,(False,False,True,True))
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (301,b,e,li,i,rz,k,editor,(False,False,True,True)) = (302,b,e,li,i,rz,k,editor,(False,False,False,True))
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (302,b,e,li,i,rz,k,editor,(False,False,False,True)) = (303,b,e,li,i,rz,k,editor,(False,False,False,False))
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (301,b,e,li,i,rz,k,editor,(False,False,True,True)) = (300,b,e,li,i,rz,k,editor,(False,True,True,True))
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (302,b,e,li,i,rz,k,editor,(False,False,False,True)) = (301,b,e,li,i,rz,k,editor,(False,False,True,True))
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (303,b,e,li,i,rz,k,editor,(False,False,False,False)) = (302,b,e,li,i,rz,k,editor,(False,False,False,True))
reageEventoGloss ev (300,b,e,li,i,rz,k,editor,lb) = reageEventoEditor ev (300,b,e,li,i,rz,eventToKey1 ev k,editor,lb)
reageEventoGloss ev (301,b,e,li,i,rz,k,editor,lb) = reageEventoEditor ev (301,b,e,li,i,rz,eventToKey1 ev k,editor,lb)
reageEventoGloss ev (302,b,e,li,i,rz,k,editor,lb) = reageEventoEditor ev (302,b,e,li,i,rz,eventToKey1 ev k,editor,lb)
reageEventoGloss ev (1,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (1,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (2,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (2,b,reageEvento2 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (3,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (3,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (4,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (4,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (5,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (5,b,reageEvento3 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (6,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (6,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (7,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (7,b,reageEvento3 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (8,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (8,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (9,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (9,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (10,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (10,b,reageEvento2 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (11,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (11,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (12,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (12,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (13,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (13,b,reageEvento2 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (14,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (14,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (15,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (15,b,reageEvento3 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (16,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (16,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (17,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (17,b,reageEvento2 ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (18,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (18,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (19,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (19,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (20,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (20,b,reageEvento ev b e,li,i,rz,eventToKey ev k,editor,lb)
reageEventoGloss ev (99,b,e,li,i,rz,k,editor,lb) = mudaMenu ev (99,b,reageEventoZ ev b e,li,i,rz,eventToKeyZ ev k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2001,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2002,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2003,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2004,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2011,b,e,li,i,rz,k,editor,lb) = estadoGloss2001 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2012,b,e,li,i,rz,k,editor,lb) = estadoGloss2001 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2013,b,e,li,i,rz,k,editor,lb) = estadoGloss2001 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2011,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2012,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2013,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2021,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2022,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2023,b,e,li,i,rz,k,editor,lb) = estadoGloss2011 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2021,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2022,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2023,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2031,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2032,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2033,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2034,b,e,li,i,rz,k,editor,lb) = estadoGloss2021 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2031,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2032,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2033,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2034,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2041,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2042,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2043,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2044,b,e,li,i,rz,k,editor,lb) = estadoGloss2031 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2041,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2042,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2043,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2044,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2051,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2052,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2053,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2054,b,e,li,i,rz,k,editor,lb) = estadoGloss2041 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2051,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2052,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2053,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2054,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2061,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2062,b,e,li,i,rz,k,editor,lb) = estadoGloss2051 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2061,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2062,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2071,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2072,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2073,b,e,li,i,rz,k,editor,lb) = estadoGloss2061 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2071,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2072,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2073,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2081,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2082,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2083,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2084,b,e,li,i,rz,k,editor,lb) = estadoGloss2071 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2081,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2082,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2083,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2084,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2091,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2092,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2093,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2094,b,e,li,i,rz,k,editor,lb) = estadoGloss2081 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2091,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2092,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2093,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2094,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2101,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2102,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2103,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2104,b,e,li,i,rz,k,editor,lb) = estadoGloss2091 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2101,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2102,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2103,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2104,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2111,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2112,b,e,li,i,rz,k,editor,lb) = estadoGloss2101 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2111,b,e,li,i,rz,k,editor,lb) = estadoGloss2121 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2112,b,e,li,i,rz,k,editor,lb) = estadoGloss2121 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2121,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2122,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2123,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2124,b,e,li,i,rz,k,editor,lb) = estadoGloss2111 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2121,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2122,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2123,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2124,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2131,b,e,li,i,rz,k,editor,lb) = estadoGloss2121 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2132,b,e,li,i,rz,k,editor,lb) = estadoGloss2121 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2131,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2132,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2141,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2142,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2143,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2144,b,e,li,i,rz,k,editor,lb) = estadoGloss2131 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2141,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2142,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2143,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2144,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2151,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2152,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2153,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2154,b,e,li,i,rz,k,editor,lb) = estadoGloss2141 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2151,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2152,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2153,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2154,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2161,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2162,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2163,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2164,b,e,li,i,rz,k,editor,lb) = estadoGloss2151 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2161,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2162,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2163,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2164,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2171,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2172,b,e,li,i,rz,k,editor,lb) = estadoGloss2161 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2171,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2172,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2181,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2182,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2183,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2184,b,e,li,i,rz,k,editor,lb) = estadoGloss2171 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2181,b,e,li,i,rz,k,editor,lb) = estadoGloss2191 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2182,b,e,li,i,rz,k,editor,lb) = estadoGloss2191 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2183,b,e,li,i,rz,k,editor,lb) = estadoGloss2191 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (2184,b,e,li,i,rz,k,editor,lb) = estadoGloss2191 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2191,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2192,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2193,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (2194,b,e,li,i,rz,k,editor,lb) = estadoGloss2181 li
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) ((-2),b,e,li,i,rz,k,editor,lb) = ((-1),b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) ((-1),b,e,li,i,rz,k,editor,lb) = ((-2),b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) ((-1),b,e,li,i,rz,k,editor,lb) = (0,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (0,b,e,li,i,rz,k,editor,lb) = ((-1),b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (200,b,e,li,i,rz,k,editor,lb) = (201,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (201,b,e,li,i,rz,k,editor,lb) = (200,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (201,b,e,li,i,rz,k,editor,lb) = (202,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (202,b,e,li,i,rz,k,editor,lb) = (201,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (202,b,e,li,i,rz,k,editor,lb) = (203,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (203,b,e,li,i,rz,k,editor,lb) = (202,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (203,b,e,li,i,rz,k,editor,lb) = (204,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (204,b,e,li,i,rz,k,editor,lb) = (203,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (204,b,e,li,i,rz,k,editor,lb) = (205,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (205,b,e,li,i,rz,k,editor,lb) = (204,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (205,b,e,li,i,rz,k,editor,lb) = (206,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (206,b,e,li,i,rz,k,editor,lb) = (205,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (206,b,e,li,i,rz,k,editor,lb) = (207,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (207,b,e,li,i,rz,k,editor,lb) = (206,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (207,b,e,li,i,rz,k,editor,lb) = (208,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (208,b,e,li,i,rz,k,editor,lb) = (207,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (208,b,e,li,i,rz,k,editor,lb) = (209,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (209,b,e,li,i,rz,k,editor,lb) = (208,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (209,b,e,li,i,rz,k,editor,lb) = (210,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (210,b,e,li,i,rz,k,editor,lb) = (209,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (210,b,e,li,i,rz,k,editor,lb) = (211,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (211,b,e,li,i,rz,k,editor,lb) = (210,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (211,b,e,li,i,rz,k,editor,lb) = (212,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (212,b,e,li,i,rz,k,editor,lb) = (211,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (212,b,e,li,i,rz,k,editor,lb) = (213,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (213,b,e,li,i,rz,k,editor,lb) = (212,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (213,b,e,li,i,rz,k,editor,lb) = (214,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (214,b,e,li,i,rz,k,editor,lb) = (213,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (214,b,e,li,i,rz,k,editor,lb) = (215,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (215,b,e,li,i,rz,k,editor,lb) = (214,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (215,b,e,li,i,rz,k,editor,lb) = (216,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (216,b,e,li,i,rz,k,editor,lb) = (215,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (216,b,e,li,i,rz,k,editor,lb) = (217,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (217,b,e,li,i,rz,k,editor,lb) = (216,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (217,b,e,li,i,rz,k,editor,lb) = (218,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (218,b,e,li,i,rz,k,editor,lb) = (217,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyDown) Down _ _) (218,b,e,li,i,rz,k,editor,lb) = (219,b,e,li,i,rz,k,editor,lb)
reageEventoGloss (EventKey (SpecialKey KeyUp) Down _ _) (219,b,e,li,i,rz,k,editor,lb) = (218,b,e,li,i,rz,k,editor,lb)
reageEventoGloss ev e = mudaMenu ev e


aplicaBotEstadoGloss :: EstadoGloss -> ListaBots -> EstadoGloss
aplicaBotEstadoGloss (n,b,e,li,i,rz,k,editor,_) lb = (n,b,e,li,i,rz,k,editor,lb)

reageEventoEditor :: Event -> EstadoGloss -> EstadoGloss
reageEventoEditor (EventKey (Char '1') Down _ _) (302,b,e,li,i,rz,k,editor,lb) = (302,b,e,li,i,rz,k,(instrucao MudaTetromino editor),lb) 
reageEventoEditor (EventKey (Char '2') Down _ _) (302,b,e,li,i,rz,k,editor,lb) = (302,b,e,li,i,rz,k,(instrucao MudaParede editor),lb)  
reageEventoEditor (EventKey (Char '3') Down _ _) (302,b,e,li,i,rz,k,editor,lb) = (302,b,e,li,i,rz,k,(instrucao Roda editor),lb) 
reageEventoEditor (EventKey (Char '4') Down _ _) (302,b,e,li,i,rz,k,editor,lb) = (302,b,e,li,i,rz,k,(instrucao Desenha editor),lb)
reageEventoEditor (EventKey (Char 'q') Down _ _) (302,b,e,li,i,rz,k,editor,lb) = estadoGlossMenu li
reageEventoEditor (EventKey (Char '1') Down _ _) (301,b,e,li,i,rz,k,editor,lb) = (301,b,e,li,i,rz,k,(instrucao MudaTetromino editor),lb) 
reageEventoEditor (EventKey (Char '2') Down _ _) (301,b,e,li,i,rz,k,editor,lb) = (301,b,e,li,i,rz,k,(instrucao MudaParede editor),lb)  
reageEventoEditor (EventKey (Char '3') Down _ _) (301,b,e,li,i,rz,k,editor,lb) = (301,b,e,li,i,rz,k,(instrucao Roda editor),lb) 
reageEventoEditor (EventKey (Char '4') Down _ _) (301,b,e,li,i,rz,k,editor,lb) = (301,b,e,li,i,rz,k,(instrucao Desenha editor),lb)
reageEventoEditor (EventKey (Char 'q') Down _ _) (301,b,e,li,i,rz,k,editor,lb) = estadoGlossMenu li
reageEventoEditor (EventKey (Char '1') Down _ _) (300,b,e,li,i,rz,k,editor,lb) = (300,b,e,li,i,rz,k,(instrucao MudaTetromino editor),lb) 
reageEventoEditor (EventKey (Char '2') Down _ _) (300,b,e,li,i,rz,k,editor,lb) = (300,b,e,li,i,rz,k,(instrucao MudaParede editor),lb)  
reageEventoEditor (EventKey (Char '3') Down _ _) (300,b,e,li,i,rz,k,editor,lb) = (300,b,e,li,i,rz,k,(instrucao Roda editor),lb) 
reageEventoEditor (EventKey (Char '4') Down _ _) (300,b,e,li,i,rz,k,editor,lb) = (300,b,e,li,i,rz,k,(instrucao Desenha editor),lb)
reageEventoEditor (EventKey (Char 'q') Down _ _) (300,b,e,li,i,rz,k,editor,lb) = estadoGlossMenu li
reageEventoEditor _ e = e

-- ** Função Principal

-- | Função que carrega para o ecrã todas as imagens necessárias.
main :: IO ()
main = do
    z <- loadBMP "images/zombies/zombie.bmp"
    Just e0 <- loadJuicy "images/menus/editor0.png"
    Just e1 <- loadJuicy "images/menus/editor1.png"
    Just e2 <- loadJuicy "images/menus/editor2.png"
    Just e3 <- loadJuicy "images/menus/editor3.png"
    Just b20a <- loadJuicy "images/battlelogs/btl20a.png"
    Just b20b <- loadJuicy "images/battlelogs/btl20b.png"
    Just b20c <- loadJuicy "images/battlelogs/btl20c.png"
    Just b20d <- loadJuicy "images/battlelogs/btl20d.png"
    Just b19a <- loadJuicy "images/battlelogs/btl19a.png"
    Just b19b <- loadJuicy "images/battlelogs/btl19b.png"
    Just b19c <- loadJuicy "images/battlelogs/btl19c.png"
    Just b19d <- loadJuicy "images/battlelogs/btl19d.png"
    Just b18a <- loadJuicy "images/battlelogs/btl18a.png"
    Just b18b <- loadJuicy "images/battlelogs/btl18b.png"
    Just b17a <- loadJuicy "images/battlelogs/btl17a.png"
    Just b17b <- loadJuicy "images/battlelogs/btl17b.png"
    Just b17c <- loadJuicy "images/battlelogs/btl17c.png"
    Just b17d <- loadJuicy "images/battlelogs/btl17d.png"
    Just b16a <- loadJuicy "images/battlelogs/btl16a.png"
    Just b16b <- loadJuicy "images/battlelogs/btl16b.png"
    Just b16c <- loadJuicy "images/battlelogs/btl16c.png"
    Just b16d <- loadJuicy "images/battlelogs/btl16d.png"
    Just b15a <- loadJuicy "images/battlelogs/btl15a.png"
    Just b15b <- loadJuicy "images/battlelogs/btl15b.png"
    Just b15c <- loadJuicy "images/battlelogs/btl15c.png"
    Just b15d <- loadJuicy "images/battlelogs/btl15d.png"
    Just b14a <- loadJuicy "images/battlelogs/btl14a.png"
    Just b14b <- loadJuicy "images/battlelogs/btl14b.png"
    Just b13a <- loadJuicy "images/battlelogs/btl13a.png"
    Just b13b <- loadJuicy "images/battlelogs/btl13b.png"
    Just b13c <- loadJuicy "images/battlelogs/btl13c.png"
    Just b13d <- loadJuicy "images/battlelogs/btl13d.png"
    Just b12a <- loadJuicy "images/battlelogs/btl12a.png"
    Just b12b <- loadJuicy "images/battlelogs/btl12b.png"
    Just b11a <- loadJuicy "images/battlelogs/btl11a.png"
    Just b11b <- loadJuicy "images/battlelogs/btl11b.png"
    Just b11c <- loadJuicy "images/battlelogs/btl11c.png"
    Just b11d <- loadJuicy "images/battlelogs/btl11d.png"
    Just b10a <- loadJuicy "images/battlelogs/btl10a.png"
    Just b10b <- loadJuicy "images/battlelogs/btl10b.png"
    Just b10c <- loadJuicy "images/battlelogs/btl10c.png"
    Just b10d <- loadJuicy "images/battlelogs/btl10d.png"
    Just b9a <- loadJuicy "images/battlelogs/btl9a.png"
    Just b9b <- loadJuicy "images/battlelogs/btl9b.png"
    Just b9c <- loadJuicy "images/battlelogs/btl9c.png"
    Just b9d <- loadJuicy "images/battlelogs/btl9d.png"
    Just b8a <- loadJuicy "images/battlelogs/btl8a.png"
    Just b8b <- loadJuicy "images/battlelogs/btl8b.png"
    Just b8c <- loadJuicy "images/battlelogs/btl8c.png"
    Just b7a <- loadJuicy "images/battlelogs/btl7a.png"
    Just b7b <- loadJuicy "images/battlelogs/btl7b.png"
    Just b6a <- loadJuicy "images/battlelogs/btl6a.png"
    Just b6b <- loadJuicy "images/battlelogs/btl6b.png"
    Just b6c <- loadJuicy "images/battlelogs/btl6c.png"
    Just b6d <- loadJuicy "images/battlelogs/btl6d.png"
    Just b5a <- loadJuicy "images/battlelogs/btl5a.png"
    Just b5b <- loadJuicy "images/battlelogs/btl5b.png"
    Just b5c <- loadJuicy "images/battlelogs/btl5c.png"
    Just b5d <- loadJuicy "images/battlelogs/btl5d.png"
    Just b4a <- loadJuicy "images/battlelogs/btl4a.png"
    Just b4b <- loadJuicy "images/battlelogs/btl4b.png"
    Just b4c <- loadJuicy "images/battlelogs/btl4c.png"
    Just b4d <- loadJuicy "images/battlelogs/btl4d.png"
    Just b3a <- loadJuicy "images/battlelogs/btl3a.png"
    Just b3b <- loadJuicy "images/battlelogs/btl3b.png"
    Just b3c <- loadJuicy "images/battlelogs/btl3c.png"
    Just b2a <- loadJuicy "images/battlelogs/btl2a.png"
    Just b2b <- loadJuicy "images/battlelogs/btl2b.png"
    Just b2c <- loadJuicy "images/battlelogs/btl2c.png"
    Just b1a <- loadJuicy "images/battlelogs/btl1a.png"
    Just b1b <- loadJuicy "images/battlelogs/btl1b.png"
    Just b1c <- loadJuicy "images/battlelogs/btl1c.png"
    Just b1d <- loadJuicy "images/battlelogs/btl1d.png"
    Just fz <- loadJuicy "images/maps/mapaZ.png"
    Just f201 <- loadJuicy "images/menus/menu20.png"
    Just f202 <- loadJuicy "images/menus/menu21.png"
    Just f203 <- loadJuicy "images/menus/menu22.png"
    Just f204 <- loadJuicy "images/menus/menu23.png"
    Just f205 <- loadJuicy "images/menus/menu24.png"
    Just f206 <- loadJuicy "images/menus/menu25.png"
    Just f207 <- loadJuicy "images/menus/menu26.png"
    Just f208 <- loadJuicy "images/menus/menu27.png"
    Just f209 <- loadJuicy "images/menus/menu28.png"
    Just f210 <- loadJuicy "images/menus/menu29.png"
    Just f211 <- loadJuicy "images/menus/menu30.png"
    Just f212 <- loadJuicy "images/menus/menu31.png"
    Just f213 <- loadJuicy "images/menus/menu32.png"
    Just f214 <- loadJuicy "images/menus/menu33.png"
    Just f215 <- loadJuicy "images/menus/menu34.png"
    Just f216 <- loadJuicy "images/menus/menu35.png"
    Just f217 <- loadJuicy "images/menus/menu36.png"
    Just f218 <- loadJuicy "images/menus/menu37.png"
    Just f219 <- loadJuicy "images/menus/menu38.png"
    Just f220 <- loadJuicy "images/menus/menu39.png"
    Just f100 <- loadJuicy "images/menus/lore.png"
    Just f20 <- loadJuicy "images/maps/mapa19.png"
    Just f19 <- loadJuicy "images/maps/mapa18.png"
    Just f18 <- loadJuicy "images/maps/mapa17.png"
    Just f17 <- loadJuicy "images/maps/mapa16.png"
    Just f16 <- loadJuicy "images/maps/mapa15.png"
    Just f15 <- loadJuicy "images/maps/mapa14.png"
    Just f14 <- loadJuicy "images/maps/mapa13.png"
    Just f13 <- loadJuicy "images/maps/mapa12.png"
    Just f12 <- loadJuicy "images/maps/mapa11.png"
    Just f11 <- loadJuicy "images/maps/mapa10.png"
    Just f10 <- loadJuicy "images/maps/mapa9.png"
    Just f9 <- loadJuicy "images/maps/mapa8.png"
    Just f8 <- loadJuicy "images/maps/mapa7.png"
    Just f7 <- loadJuicy "images/maps/mapa6.png"
    Just f6 <- loadJuicy "images/maps/mapa5.png" 
    Just f5 <- loadJuicy "images/maps/mapa4.png"
    Just f4 <- loadJuicy "images/maps/mapa3.png"
    Just f3 <- loadJuicy "images/maps/mapa2.png"
    Just f2 <- loadJuicy "images/maps/mapa1.png"
    Just f1 <- loadJuicy "images/maps/mapa0.png"
    f0 <- loadBMP "images/menus/fundoH.bmp"
    ct <- loadBMP "images/textures/ct.bmp"
    wt <- loadBMP "images/textures/w.bmp"
    lt <- loadBMP "images/textures/arbusto.bmp"
    at <- loadBMP "images/textures/at.bmp"
    --st <- loadBMP "images/textures/st.bmp"
    logo <- loadBMP "images/other/logo.bmp"
    fb <- loadBMP "images/other/falloutboy.bmp"
    d <- loadBMP "images/other/dead.bmp"
    g <- loadBMP "images/other/ghoul.bmp"
    n <- loadBMP "images/other/nuclear.bmp"
    p0 <- loadBMP "images/characters/stalin.bmp"
    p1 <- loadBMP "images/characters/hitler.bmp"
    p2 <- loadBMP "images/characters/ff.bmp"
    p3 <- loadBMP "images/characters/ma.bmp"
    p4 <- loadBMP "images/characters/mussolini.bmp"
    p5 <- loadBMP "images/characters/fdr.bmp"
    p6 <- loadBMP "images/characters/ht.bmp"
    p7 <- loadBMP "images/characters/wc.bmp"
    p8 <- loadBMP "images/characters/dg.bmp"
    p9 <- loadBMP "images/characters/mao.bmp"
    p10 <- loadBMP "images/characters/ks.bmp"
    p11 <- loadBMP "images/characters/wk.bmp"
    p12 <- loadBMP "images/characters/ws.bmp"
    p13 <- loadBMP "images/characters/fm.bmp"
    p14 <- loadBMP "images/characters/ia.bmp"
    Just p15 <- loadJuicy "images/characters/hp.png" 
    p16 <- loadBMP "images/characters/mong.bmp"
    p17 <- loadBMP "images/characters/ml.bmp"
    p18 <- loadBMP "images/characters/br.bmp"
    p19 <- loadBMP "images/characters/jc.bmp"
    t0 <- loadBMP "images/tanks/tank0.bmp"
    t1 <- loadBMP "images/tanks/tank1.bmp"
    t2 <- loadBMP "images/tanks/tank2.bmp"
    t3 <- loadBMP "images/tanks/tank3.bmp"
    t4 <- loadBMP "images/tanks/tank4.bmp"
    t5 <- loadBMP "images/tanks/tank5.bmp"
    t6 <- loadBMP "images/tanks/tank6.bmp"
    t7 <- loadBMP "images/tanks/tank7.bmp"
    t8 <- loadBMP "images/tanks/tank8.bmp"
    t9 <- loadBMP "images/tanks/tank9.bmp"
    t10 <- loadBMP "images/tanks/tank10.bmp"
    t11 <- loadBMP "images/tanks/tank11.bmp"
    t12 <- loadBMP "images/tanks/tank12.bmp"
    t13 <- loadBMP "images/tanks/tank13.bmp"
    t14 <- loadBMP "images/tanks/tank14.bmp"
    t15 <- loadBMP "images/tanks/tank15.bmp"
    t16 <- loadBMP "images/tanks/tank16.bmp"
    t17 <- loadBMP "images/tanks/tank17.bmp"
    t18 <- loadBMP "images/tanks/tank18.bmp"
    t19 <- loadBMP "images/tanks/tank19.bmp"
    tz <- loadBMP "images/zombies/tz.bmp"
    tz0 <- loadBMP "images/zombies/tz0.bmp"
    tz1 <- loadBMP "images/zombies/tz1.bmp"
    tz2 <- loadBMP "images/zombies/tz2.bmp"
    tz3 <- loadBMP "images/zombies/tz3.bmp"
    a0 <- loadBMP "images/tanks/aviao0.bmp"
    a1 <- loadBMP "images/tanks/aviao1.bmp"
    a2 <- loadBMP "images/tanks/aviao2.bmp"
    a3 <- loadBMP "images/tanks/aviao3.bmp"
    a4 <- loadBMP "images/tanks/aviao4.bmp"
    Just a5 <- loadJuicy "images/tanks/aviao5.png"
    b0 <- loadBMP "images/tanks/usanavy.bmp" 
    dc0 <- loadBMP "images/ammo/dcanhao0.bmp"
    dc1 <- loadBMP "images/ammo/dcanhao1.bmp"
    dc2 <- loadBMP "images/ammo/dcanhao2.bmp"
    dc3 <- loadBMP "images/ammo/dcanhao3.bmp"
    dc4 <- loadBMP "images/ammo/dcanhao4.bmp"
    dc5 <- loadBMP "images/ammo/dcanhao5.bmp"
    dc6 <- loadBMP "images/ammo/dcanhao6.bmp"
    dc7 <- loadBMP "images/ammo/dcanhao7.bmp"
    s0 <- loadBMP "images/ammo/smoke0.bmp"
    s1 <- loadBMP "images/ammo/smoke1.bmp"
    s2 <- loadBMP "images/ammo/smoke2.bmp"
    s3 <- loadBMP "images/ammo/smoke3.bmp"
    s4 <- loadBMP "images/ammo/smoke4.bmp"
    s5 <- loadBMP "images/ammo/smoke5.bmp"
    s6 <- loadBMP "images/ammo/smoke6.bmp"
    s7 <- loadBMP "images/ammo/smoke7.bmp"
    l0 <- loadBMP "images/ammo/l0.bmp"
    l1 <- loadBMP "images/ammo/l1.bmp"
    l2 <- loadBMP "images/ammo/l2.bmp"
    l3 <- loadBMP "images/ammo/l3.bmp"
    l4 <- loadBMP "images/ammo/l4.bmp"
    l5 <- loadBMP "images/ammo/l5.bmp"
    l6 <- loadBMP "images/ammo/l6.bmp"
    l7 <- loadBMP "images/ammo/l7.bmp"    
    op2 <- loadBMP "images/tanks/tank1.bmp"
    sg <- loadBMP "images/other/sg.bmp"
    op0 <- loadBMP "images/other/op0.bmp"
    tnt <- loadBMP "images/textures/tnt.bmp"
    vm0 <- loadBMP "images/zombies/vm0.bmp"
    vm1 <- loadBMP "images/zombies/vm1.bmp"
    vm2 <- loadBMP "images/zombies/vm2.bmp"
    vm3 <- loadBMP "images/zombies/vm3.bmp"
    vm4 <- loadBMP "images/zombies/vm4.bmp"
    vm5 <- loadBMP "images/zombies/vm5.bmp"
    vm6 <- loadBMP "images/zombies/vm6.bmp"
    vm7 <- loadBMP "images/zombies/vm7.bmp"
    Just bp0 <- loadJuicy "images/zombies/bp0.png"
    Just bp1 <- loadJuicy "images/zombies/bp1.png"
    Just bm0 <- loadJuicy "images/zombies/bm0.png"
    Just bm1 <- loadJuicy "images/zombies/bm1.png"
    Just ba0 <- loadJuicy "images/zombies/ba0.png"
    Just ba1 <- loadJuicy "images/zombies/ba1.png"
    Just bs0 <- loadJuicy "images/zombies/bs0.png"
    Just bs1 <- loadJuicy "images/zombies/bs1.png"
    Just bj0 <- loadJuicy "images/zombies/bj0.png"
    Just bj1 <- loadJuicy "images/zombies/bj1.png"
    Just br0 <- loadJuicy "images/zombies/br0.png"
    Just br1 <- loadJuicy "images/zombies/br1.png"
    Just bd0 <- loadJuicy "images/zombies/bd0.png"
    Just bd1 <- loadJuicy "images/zombies/bd1.png"
    Just bk0 <- loadJuicy "images/zombies/bk0.png"
    Just bk1 <- loadJuicy "images/zombies/bk1.png"
    Just bb0 <- loadJuicy "images/zombies/bb0.png"
    Just bb1 <- loadJuicy "images/zombies/bb1.png"
    jnb <- loadBMP "images/zombies/jnb.bmp"
    scb <- loadBMP "images/zombies/scb.bmp"
    qrb <- loadBMP "images/zombies/qrb.bmp"
    dtb <- loadBMP "images/zombies/dtb.bmp"
    quit <- loadBMP "images/other/quit.bmp"
    teclas4 <- loadBMP "images/other/teclas4.bmp"
    teclas3 <- loadBMP "images/other/teclas3.bmp"
    teclas2 <- loadBMP "images/other/teclas2.bmp"
    weapon0 <- loadBMP "images/zombies/weapon0.bmp"
    weapon1 <- loadBMP "images/zombies/weapon1.bmp"
    weapon2 <- loadBMP "images/zombies/weapon2.bmp"
    weapon3 <- loadBMP "images/zombies/weapon3.bmp"
    Just inf <- loadJuicy "images/zombies/inf.png" 
    play dm                       -- janela onde irá correr o jogo
        black                     -- côr do fundo da janela
        fr                        -- frame rate
        (estadoGlossMenu [e0,e1,e2,e3,b1a,b1b,b1c,b1d,b2a,b2b,b2c,b3a,b3b,b3c,b4a,b4b,b4c,b4d,b5a,b5b,b5c,b5d,b6a,b6b,b6c,b6d,b7a,b7b,b8a,b8b,b8c,b9a,b9b,b9c,b9d,b10a,b10b,b10c,b10d,b11a,b11b,b11c,b11d,b12a,b12b,b13a,b13b,b13c,b13d,b14a,b14b,b15a,b15b,b15c,b15d,b16a,b16b,b16c,b16d,b17a,b17b,b17c,b17d,b18a,b18b,b19a,b19b,b19c,b19d,b20a,b20b,b20c,b20d,inf,weapon0,weapon1,weapon2,weapon3,teclas4,teclas3,teclas2,quit,jnb,scb,qrb,dtb,bp0,bp1,bm0,bm1,ba0,ba1,bs0,bs1,bj0,bj1,br0,br1,bd0,bd1,bk0,bk1,bb0,bb1,vm0,vm1,vm2,vm3,vm4,vm5,vm6,vm7,tnt,op0,sg,op2,at,lt,wt,ct,f201,f202,f203,f204,f205,f206,f207,f208,f209,f210,f211,f212,f213,f214,f215,f216,f217,f218,f219,f220,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f100,fz,fb,p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,d,g,n,dc0,dc1,dc2,dc3,dc4,dc5,dc6,dc7,l0,l1,l2,l3,l4,l5,l6,l7,s0,s1,s2,s3,s4,s5,s6,s7,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,tz,tz0,tz1,tz2,tz3,a0,a1,a2,a3,a4,a5,b0,z]) -- estado inicial
        desenhaEstadoGloss        -- desenha o estado do jogo
        reageEventoGloss          -- reage a um evento
        reageTempoGloss           -- reage ao passar do tempo