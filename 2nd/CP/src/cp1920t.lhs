\documentclass[a4paper]{article}
\usepackage[a4paper,left=3cm,right=2cm,top=2.5cm,bottom=2.5cm]{geometry}
\usepackage{palatino}
\usepackage[colorlinks=true,linkcolor=blue,citecolor=blue]{hyperref}
\usepackage{graphicx}
\usepackage{cp1920t}
\usepackage{subcaption}
\usepackage{adjustbox}
\usepackage{color}
%================= local x=====================================================%
\def\getGif#1{\includegraphics[width=0.3\textwidth]{cp1920t_media/#1.png}}
\let\uk=\emph
\def\aspas#1{``#1"}
%================= lhs2tex=====================================================%
%include polycode.fmt 
%format (div (x)(y)) = x "\div " y
%format succ = "\succ "
%format ==> = "\Longrightarrow "
%format map = "\map "
%format length = "\length "
%format fst = "\p1"
%format p1  = "\p1"
%format snd = "\p2"
%format p2  = "\p2"
%format Left = "i_1"
%format Right = "i_2"
%format i1 = "i_1"
%format i2 = "i_2"
%format >< = "\times"
%format >|<  = "\bowtie "
%format |-> = "\mapsto"
%format . = "\comp "
%format (kcomp (f)(g)) = f "\kcomp " g
%format -|- = "+"
%format conc = "\mathsf{conc}"
%format summation = "{\sum}"
%format (either (a) (b)) = "\alt{" a "}{" b "}"
%format (frac (a) (b)) = "\frac{" a "}{" b "}"
%format (uncurry f) = "\uncurry{" f "}"
%format (const f) = "\underline{" f "}"
%format TLTree = "\mathsf{TLTree}"
%format (lcbr (x)(y)) = "\begin{lcbr}" x "\\" y "\end{lcbr}"
%format (split (x) (y)) = "\conj{" x "}{" y "}"
%format (for (f) (i)) = "\for{" f "}\ {" i "}"
%format B_tree = "\mathsf{B}\mbox{-}\mathsf{tree} "
\def\ana#1{\mathopen{[\!(}#1\mathclose{)\!]}}
%format (cataA (f) (g)) = "\cata{" f "~" g "}_A"
%format (anaA (f) (g)) = "\ana{" f "~" g "}_A"
%format (cataB (f) (g)) = "\cata{" f "~" g "}_B"
%format (anaB (f) (g)) = "\ana{" f "~" g "}_B"
%format Either a b = a "+" b 
%format fmap = "\mathsf{fmap}"
%format NA   = "\textsc{na}"
%format NB   = "\textsc{nb}"
%format inT = "\mathsf{in}"
%format outT = "\mathsf{out}"
%format Null = "1"
%format (Prod (a) (b)) = a >< b
%format fF = "\fun F "
%format e1 = "e_1 "
%format e2 = "e_2 "
%format Dist = "\fun{Dist}"
%format IO = "\fun{IO}"
%format BTree = "\fun{BTree} "
%format LTree = "\mathsf{LTree}"
%format inNat = "\mathsf{in}"
%format (cataNat (g)) = "\cata{" g "}"
%format (cataLTree (g)) = "\cata{" g "}"
%format Nat0 = "\N_0"
%format muB = "\mu "
%format (frac (n)(m)) = "\frac{" n "}{" m "}"
%format (fac (n)) = "{" n "!}"
%format (underbrace (t) (p)) = "\underbrace{" t "}_{" p "}"
%format matrix = "matrix"
%format (bin (n) (k)) = "\Big(\vcenter{\xymatrix@R=1pt{" n "\\" k "}}\Big)"
%format `ominus` = "\mathbin{\ominus}"
%format % = "\mathbin{/}"
%format <-> = "{\,\leftrightarrow\,}"
%format <|> = "{\,\updownarrow\,}"
%format `minusNat`= "\mathbin{-}"
%format ==> = "\Rightarrow"
%format .==>. = "\Rightarrow"
%format .<==>. = "\Leftrightarrow"
%format .==. = "\equiv"
%format .<=. = "\leq"
%format .&&&. = "\wedge"
%format cdots = "\cdots "
%format pi = "\pi "
%format quadrado = "^2"
%format (expn (a) (n)) = "{" a "}^{" n "}" 
%format (anaBdt (g)) = "\ana{" g "}"
%format (cataBTree (g)) = "\cata{" g "}"
%format (anaFTree (g)) = "\ana{" g "}"
%format (cataFTree (g)) = "\cata{" g "}"
%format (anaList (g)) = "\ana{" g "}"
%format (cataList (g)) = "\cata{" g "}"
%format joinMonad = "μ"

%---------------------------------------------------------------------------

\title{
             Cálculo de Programas
\\
         Trabalho Prático
\\
         MiEI+LCC --- 2019/20
}

\author{
         \dium
\\
         Universidade do Minho
}


\date\mydate

\makeindex
\newcommand{\rn}[1]{\textcolor{red}{#1}}
\begin{document}

\maketitle

\begin{center}\large
\begin{tabular}{ll}
\textbf{Grupo} nr. & 95
\\\hline
a84414 & João Correia
\\
a89582 & Henrique Ribeiro
\\
a85983 & Filipe Felicio 
\end{tabular}
\end{center}

\section{Preâmbulo}

A disciplina de \CP\ tem como objectivo principal ensinar
a progra\-mação de computadores como uma disciplina científica. Para isso
parte-se de um repertório de \emph{combinadores} que formam uma álgebra da
programação (conjunto de leis universais e seus corolários) e usam-se esses
combinadores para construir programas \emph{composicionalmente}, isto é,
agregando programas já existentes.
  
Na sequência pedagógica dos planos de estudo dos dois cursos que têm
esta disciplina, restringe-se a aplicação deste método à programação
funcional em \Haskell. Assim, o presente trabalho prático coloca os
alunos perante problemas concretos que deverão ser implementados em
\Haskell.  Há ainda um outro objectivo: o de ensinar a documentar
programas, validá-los, e a produzir textos técnico-científicos de
qualidade.

\section{Documentação} Para cumprir de forma integrada os objectivos
enunciados acima vamos recorrer a uma técnica de programa\-ção dita
``\litp{literária}'' \cite{Kn92}, cujo princípio base é o seguinte:
\begin{quote}\em Um programa e a sua documentação devem coincidir.
\end{quote} Por outras palavras, o código fonte e a documentação de um
programa deverão estar no mesmo ficheiro.

O ficheiro \texttt{cp1920t.pdf} que está a ler é já um exemplo de \litp{programação
literária}: foi gerado a partir do texto fonte \texttt{cp1920t.lhs}\footnote{O
suffixo `lhs' quer dizer \emph{\lhaskell{literate Haskell}}.} que encontrará
no \MaterialPedagogico\ desta disciplina descompactando o ficheiro \texttt{cp1920t.zip}
e executando
\begin{Verbatim}[fontsize=\small]
    $ lhs2TeX cp1920t.lhs > cp1920t.tex
    $ pdflatex cp1920t
\end{Verbatim}
em que \href{https://hackage.haskell.org/package/lhs2tex}{\texttt\LhsToTeX} é
um pre-processador que faz ``pretty printing''
de código Haskell em \Latex\ e que deve desde já instalar executando
\begin{Verbatim}[fontsize=\small]
    $ cabal install lhs2tex
\end{Verbatim}
Por outro lado, o mesmo ficheiro \texttt{cp1920t.lhs} é executável e contém
o ``kit'' básico, escrito em \Haskell, para realizar o trabalho. Basta executar
\begin{Verbatim}[fontsize=\small]
    $ ghci cp1920t.lhs
\end{Verbatim}

%if False
\begin{code}
{-# OPTIONS_GHC -XNPlusKPatterns #-}
{-# LANGUAGE GeneralizedNewtypeDeriving, DeriveDataTypeable, FlexibleInstances #-}
--module Cp1920t where 
import Cp
import List  hiding (fac)
import Nat
import FTree
import BTree
import LTree
import Probability
import ListUtils
import Show
import Data.List hiding (find)
import Test.QuickCheck hiding ((><),choose,collect)
import qualified Test.QuickCheck as QuickCheck
import System.Random  hiding (split)
import System.Process
import GHC.IO.Exception
import Graphics.Gloss
import Control.Monad
import Control.Applicative hiding ((<|>))
import Exp
\end{code}
%endif

\noindent Abra o ficheiro \texttt{cp1920t.lhs} no seu editor de texto preferido
e verifique que assim é: todo o texto que se encontra dentro do ambiente
\begin{quote}\small\tt
\verb!\begin{code}!
\\ ... \\
\verb!\end{code}!
\end{quote}
vai ser seleccionado pelo \GHCi\ para ser executado.

\section{Como realizar o trabalho}
Este trabalho teórico-prático deve ser realizado por grupos de três alunos.
Os detalhes da avaliação (datas para submissão do relatório e sua defesa
oral) são os que forem publicados na \cp{página da disciplina} na \emph{internet}.

Recomenda-se uma abordagem participativa dos membros do grupo
de trabalho por forma a poderem responder às questões que serão colocadas
na \emph{defesa oral} do relatório.

Em que consiste, então, o \emph{relatório} a que se refere o parágrafo anterior?
É a edição do texto que está a ser lido, preenchendo o anexo \ref{sec:resolucao}
com as respostas. O relatório deverá conter ainda a identificação dos membros
do grupo de trabalho, no local respectivo da folha de rosto.

Para gerar o PDF integral do relatório deve-se ainda correr os comando seguintes,
que actualizam a bibliografia (com \Bibtex) e o índice remissivo (com \Makeindex),
\begin{Verbatim}[fontsize=\small]
    $ bibtex cp1920t.aux
    $ makeindex cp1920t.idx
\end{Verbatim}
e recompilar o texto como acima se indicou. Dever-se-á ainda instalar o utilitário
\QuickCheck,
que ajuda a validar programas em \Haskell\ e a biblioteca \gloss{Gloss} para
geração de gráficos 2D:
\begin{Verbatim}[fontsize=\small]
    $ cabal install QuickCheck gloss
\end{Verbatim}
Para testar uma propriedade \QuickCheck~|prop|, basta invocá-la com o comando:
\begin{verbatim}
    > quickCheck prop
    +++ OK, passed 100 tests.
\end{verbatim}
Pode mesmo controlar o número de casos de teste e sua complexidade utilizando
o comando:
\begin{verbatim}
    > quickCheckWith stdArgs { maxSuccess = 200, maxSize = 10 } prop
    +++ OK, passed 200 tests.
\end{verbatim}
Qualquer programador tem, na vida real, de ler e analisar (muito!) código
escrito por outros. No anexo \ref{sec:codigo} disponibiliza-se algum
código \Haskell\ relativo aos problemas que se seguem. Esse anexo deverá
ser consultado e analisado à medida que isso for necessário.

\Problema

Pretende-se implementar um sistema de manutenção e utilização de um dicionário.
Este terá uma estrutura muito peculiar em memória. Será construída
uma árvore em que cada nodo terá apenas uma letra da palavra e cada
folha da respectiva árvore terá a respectiva tradução (um ou mais sinónimos).
Deverá ser possível:
\begin{itemize}
\item
|dic_rd| --- procurar traduções para uma determinada palavra
\item	
|dic_in| --- inserir palavras novas (palavra e tradução)
\item
|dic_imp| --- importar dicionários do formato ``lista de pares palavra-tradução"
\item
|dic_exp| --- exportar dicionários para o formato ``lista de pares palavra-tradução".
\end{itemize}
A implementação deve ser baseada no módulo \textbf{Exp.hs} que está incluído no material deste trabalho prático,
que deve ser estudado com atenção antes de abordar este problema.

    \begin{figure}          
    \includegraphics[scale=0.15]{images/dic.png}
    \caption{Representação em memória do dicionário dado para testes.}
    \label{fig:dic}          
    \end{figure}

No anexo \ref{sec:codigo} é dado um dicionário para testes, que corresponde à figura \ref{fig:dic}.
A implementação proposta deverá garantir as seguintes propriedades:
\begin{propriedade}
Se um dicionário estiver normalizado (ver apêndice \ref{sec:codigo}) então
não perdemos informação quando o representamos em memória:
\begin{code}
prop_dic_rep x = let d = dic_norm x in (dic_exp . dic_imp) d == d
\end{code}
\end{propriedade}
\begin{propriedade}
Se um significado |s| de uma palavra |p| já existe num dicionário então adicioná-lo
em memória não altera nada:
\begin{code}
prop_dic_red p s d
   | dic_red p s d = dic_imp d == dic_in p s (dic_imp d)
   | otherwise = True
\end{code}
\end{propriedade}
\begin{propriedade}
A operação |dic_rd| implementa a procura na correspondente exportação do dicionário:
\begin{code}
prop_dic_rd (p,t) = dic_rd  p t == lookup p (dic_exp t)
\end{code}
\end{propriedade}

\Problema

Árvores binárias (elementos do tipo \BTree) são
    frequentemente usadas no armazenamento e procura de dados, porque
    suportam um vasto conjunto de ferramentas para procuras
    eficientes. Um exemplo de destaque é o caso das
    \href{https://en.wikipedia.org/wiki/Binary_search_tree}{árvores
    binárias de procura}, \emph{i.e.} árvores que seguem o
    princípio de \emph{ordenação}: para todos os nós,
    o filho à esquerda tem um
    valor menor ou igual que o valor no próprio nó; e de forma
     análoga, o filho à direita
    tem um valor maior ou igual que o valor no próprio nó.
    A Figura~\ref{fig:ex} apresenta dois exemplos de árvores binárias de procura.\footnote{
    As imagens foram geradas com recurso à função |dotBt| (disponível
    neste documento). Recomenda-se o
    uso desta função para efeitos de teste e ilustração.}

    \begin{figure}          
    \includegraphics[scale=0.26]{images/example1.png}
    \includegraphics[scale=0.26]{images/example2.png}
    \caption{Duas árvores binárias de procura; a da esquerda vai ser designada
    por $t_1$ e a da direita por $t_2$.}
    \label{fig:ex}          
    \end{figure}
  Note que tais árvores permitem reduzir \emph{significativamente}
  o espaço de procura, dado que ao procurar um valor podemos sempre
  \emph{reduzir a procura a um ramo} ao longo de cada nó visitado. Por
  exemplo, ao procurar o valor $7$ na primeira árvore ($t_1$), sabemos que nos
  podemos restringir ao ramo da direita do nó com o valor $5$ e assim
  sucessivamente. Como complemento a esta explicação, consulte
  também os \href{http://www4.di.uminho.pt/~jno/media/}{vídeos das aulas teóricas} (capítulo `pesquisa binária').

  Para verificar se uma árvore binária está ordenada,
  é útil ter em conta  a seguinte
  propriedade: considere uma árvore binária cuja raíz tem o valor
  $a$, um filho $s_1$ à esquerda e um filho $s_2$ à direita.
  Assuma que os dois filhos estão ordenados; que o elemento
  \emph{mais à direita} de $t_1$ é menor ou igual a $a$; e que o
  elemento \emph{mais à esquerda} de $t_2$ é maior ou igual a $a$.
  Então a árvore binária está ordenada. Dada esta informação,
  implemente as seguintes funções como catamorfismos de árvores binárias.
\begin{code}
maisEsq :: BTree a -> Maybe a
maisDir :: BTree a -> Maybe a
\end{code}
  Seguem alguns exemplos dos resultados que se esperam ao aplicar
  estas funções à árvore da esquerda ($t1$) e à árvore da direita ($t2$)
  da Figura~\ref{fig:ex}.
  \begin{Verbatim}[fontsize=\small]
   *Splay> maisDir t1
    Just 16
   *Splay> maisEsq t1
    Just 1
   *Splay> maisDir t2
    Just 8
   *Splay> maisEsq t2
    Just 0
  \end{Verbatim}
  \begin{propriedade}
  As funções |maisEsq| e |maisDir| são determinadas unicamente
  pela propriedade
\begin{code}
prop_inv :: BTree String -> Bool
prop_inv = maisEsq .==. maisDir . invBTree
\end{code}
  \end{propriedade}
  \begin{propriedade}
    O elemento mais à esquerda de uma árvore está presente no ramo da
    esquerda, a não ser que esse ramo esteja vazio:
\begin{code}
propEsq Empty = property Discard
propEsq x@(Node(a,(t,s))) = (maisEsq t) /= Nothing ==> (maisEsq x) == maisEsq t
\end{code}
\end{propriedade}
  A próxima tarefa deste problema consiste na implementação de uma função
  que insere um novo elemento numa árvore
  binária \emph{preservando} o princípio de ordenação,
\begin{code}
insOrd :: (Ord a) => a -> BTree a -> BTree a
\end{code}
  e de uma função que verifica se uma dada árvore binária está ordenada,
\begin{code}
isOrd :: (Ord a) => BTree a -> Bool
\end{code}
Para ambas as funções deve utilizar o que aprendeu sobre \emph{catamorfismos e
recursividade mútua}.

\noindent
\textbf{Sugestão:} Se tiver problemas em implementar
com base em catamorfismos  estas duas últimas
funções, tente implementar (com base em catamorfismos) as funções auxiliares
\begin{code}
insOrd' :: (Ord a) => a -> BTree a -> (BTree a, BTree a)
isOrd' :: (Ord a) => BTree a -> (Bool, BTree a)
\end{code}
tais que
$insOrd' \> x = \langle insOrd \> x, id \rangle$ para todo o elemento $x$
do tipo $a$
e
$isOrd' = \langle isOrd, id \rangle$.
  \begin{propriedade}
   Inserir uma sucessão de elementos numa árvore vazia gera uma árvore
   ordenada.
\begin{code}
prop_ord :: [Int] -> Bool
prop_ord = isOrd . (foldr insOrd Empty)
\end{code}
\end{propriedade}

\smallskip
  \noindent
    As árvores binárias providenciam uma boa maneira de reduzir o espaço
    de procura. Mas podemos fazer ainda melhor: podemos aproximar da
    raíz os elementos da árvore que são mais acedidos, reduzindo assim
    o espaço de procura na \emph{dimensão vertical}\footnote{Note que
    nas árvores de binária de procura a redução é feita na dimensão
    horizontal.}. Esta operação é geralmente
    referida como
    \href{https://en.wikipedia.org/wiki/Splay_tree}{\emph{splaying}} e
    é implementada com base naquilo a que chamamos
    \href{https://en.wikipedia.org/wiki/Tree_rotation}{\emph{rotações à esquerda
    e à direita de uma  árvore}}.

    Intuitivamente, a rotação à direita de uma árvore move todos os
    nós "\emph{uma casa para a sua direita}". Formalmente,
    esta operação define-se da seguinte maneira:
    \begin{enumerate}
       \item Considere uma árvore binária e designe a sua
       raíz pela letra $r$. Se $r$ não tem filhos à esquerda então simplesmente
       retornamos a árvore dada à entrada. Caso contrário,
       \item designe o filho à esquerda pela letra $l$. A árvore
       que vamos retornar tem $l$ na raíz, que mantém o filho à esquerda
       e adopta $r$ como o filho à direita. O orfão (\emph{i.e.} o anterior
       filho à direita de $l$) passa a ser o filho à esquerda de $r$.
    \end{enumerate}
    A rotação à esquerda é definida de forma análoga. As
       Figuras~\ref{exrot:fig} e \ref{exrot2:fig} apresentam dois
       exemplos de rotações à direita. Note que em ambos os casos o
       valor $2$ subiu um nível na árvore correspodente. De facto,
       podemos sempre aplicar uma \emph{sequência} de rotações numa
       árvore de forma a mover um dado nó para a raíz (dando origem
       portanto à referida operação de splaying).

    \begin{figure}
    \includegraphics[scale=0.27]{images/example1.png}
    \includegraphics[scale=0.27]{images/example3.png}
    \caption{Exemplo de uma rotação à direita. A árvore da esquerda
    é a árvore original; a árvore da direita representa a rotação à direita
    correspondente.}
    \label{exrot:fig}
    \end{figure}

    \begin{figure}
    \includegraphics[scale=0.25]{images/example2.png}
    \includegraphics[scale=0.25]{images/example4.png}
    \caption{Exemplo de uma rotação à direita. A árvore da esquerda
    é a árvore original; a árvore da direita representa a rotação à direita
    correspondente.}
    \label{exrot2:fig}
    \end{figure}

    Começe então por implementar as funções   
\begin{code}
rrot :: BTree a -> BTree a
lrot :: BTree a -> BTree a
\end{code}
    de rotação à direita e à esquerda.
    \begin{propriedade}
       As rotações à esquerda e à direita preservam a ordenação
       das árvores.
\begin{code}
prop_ord_pres_esq = forAll orderedBTree (isOrd . lrot)
prop_ord_pres_dir = forAll orderedBTree (isOrd . rrot)
\end{code}
    \end{propriedade}
De seguida implemente a operação de splaying
\begin{code}
splay :: [Bool] -> (BTree a -> BTree a)
\end{code}
como um catamorfismo de listas. O argumento |[Bool]|
representa um caminho ao longo de uma árvore, em que o valor |True|
representa "seguir pelo ramo da esquerda" e o valor |False|
representa "seguir pelo ramo da direita". O caminho ao longo de uma árvore serve
para \emph{identificar} unicamente um nó dessa árvore.
\begin{propriedade}
A operação de splay preserva a ordenação de uma árvore.
\begin{code}
prop_ord_pres_splay :: [Bool] -> Property
prop_ord_pres_splay path = forAll orderedBTree (isOrd . (splay path))
\end{code}
\end{propriedade}

\Problema

\emph{Árvores de decisão binárias} são estruturas de dados usadas na
 área de
 \href{https://www.xoriant.com/blog/product-engineering/decision-trees-machine-learning-algorithm.html}{machine
 learning} para codificar processos de decisão. Geralmente, tais
 árvores são geradas por computadores com base num vasto conjunto de
 dados e reflectem o que o computador "aprendeu" ao processar esses
 mesmos dados. Segue-se um exemplo muito simples de uma árvore de decisão
 binária:

\[
  \xymatrix{ & \text{chuva na ida?} \ar[dl]_{\text{sim}} \ar[dr]^{\text{não}} & &\\
  \text{precisa} & & \text{chuva no regresso?} \ar[dl]^{\text{sim}}
  \ar[dr]^{\text{não}} & \\
  & \text{precisa} & & \text{não precisa}
  }
\]

Esta árvore representa o processo de decisão relativo a ser preciso ou
    não levar um guarda-chuva para uma viagem, dependendo das
    condições climatéricas. Essencialmente, o processo de decisão é
    efectuado ao "percorrer" a árvore, escolhendo o ramo da esquerda ou
    da direita de acordo com a resposta à pergunta correspondente. Por
    exemplo, começando da raiz da árvore, responder |["não", "não"]|
    leva-nos à decisão |"não precisa"| e responder |["não", "sim"]|
    leva-nos à decisão |"precisa"|.

Árvores de decisão binárias podem ser codificadas em \Haskell\ usando
o seguinte tipo de dados:
\begin{code}
data Bdt a = Dec a | Query (String, (Bdt a, Bdt a)) deriving Show
\end{code}

Note que o tipo de dados |Bdt| é parametrizado por um tipo de dados
 |a|.  Isto é necessário, porque as decisões podem ser de diferentes
 tipos: por exemplo, respostas do tipo "sim ou não" (como apresentado
 acima), a escolha de números, ou
 \href{http://jkurokawa.com/2018/02/09/machine-learning-part-ii-decision-trees}{classificações}.

De forma a conseguirmos processar árvores de decisão binárias em \Haskell,
deve, antes de tudo, resolver as seguintes alíneas:
\begin{enumerate}
  \item Definir as funções |inBdt|, |outBdt|, |baseBdt|, |cataBdt|, e |anaBdt|.
  \item Apresentar no relatório o diagrama de |anaBdt|.
\end{enumerate}
Para tomar uma decisão com base numa árvore de decisão binária |t|, o
computador precisa apenas da estrutura de |t| (\emph{i.e.} pode esquecer
a informação nos nós da árvore) e de uma lista de respostas "sim ou não" (para
que possa percorrer a árvore da forma desejada). Implemente então as seguintes
funções na forma de \emph{catamorfismos}:
\begin{enumerate}
\item |extLTree : Bdt a -> LTree a| (esquece a informação presente
nos nós de uma dada árvore de decisão binária).
\begin{propriedade}
  A função |extLTree| preserva as folhas da árvore de origem.
\begin{code}
prop_pres_tips :: Bdt Int -> Bool
prop_pres_tips = tipsBdt .==. tipsLTree . extLTree
\end{code}
\end{propriedade}
\item |navLTree : LTree a -> ([Bool] -> LTree a)| (navega um elemento de
|LTree|
de acordo com uma sequência de respostas "sim ou não". Esta função deve
ser implementada como um catamorfismo de |LTree|. Neste contexto,
elementos de |[Bool]| representam sequências de respostas: o valor |True| corresponde a "sim" e portanto a "segue pelo ramo da esquerda"; o valor
|False| corresponde a "não" e portanto a "segue pelo ramo da direita".

Seguem
alguns exemplos dos resultados que se esperam ao aplicar |navLTree| a
|(extLTree bdtGC)|, em que |bdtGC| é a  àrvore de decisão binária acima descrita,
e a uma
sequência de respostas.
   \begin{Verbatim}[fontsize=\small]
    *ML> navLTree (extLTree bdtGC) []
    Fork (Leaf "Precisa",Fork (Leaf "Precisa",Leaf "N precisa"))
    *ML> navLTree (extLTree bdtGC) [False]
    Fork (Leaf "Precisa",Leaf "N precisa")
    *ML> navLTree (extLTree bdtGC) [False,True]
    Leaf "Precisa"
    *ML> navLTree (extLTree bdtGC) [False,True,True]
    Leaf "Precisa"
    *ML> navLTree (extLTree bdtGC) [False,True,True,True]
    Leaf "Precisa"
   \end{Verbatim}
\end{enumerate}
\begin{propriedade}
  Percorrer uma árvore ao longo de um caminho é equivalente a percorrer
a árvore inversa ao longo do caminho inverso.
\begin{code}
prop_inv_nav :: Bdt Int -> [Bool] -> Bool
prop_inv_nav t l = let t' = extLTree t in
  invLTree (navLTree t' l) == navLTree (invLTree t') (fmap not l)
\end{code}
\end{propriedade}
\begin{propriedade}
  Quanto mais longo for o caminho menos alternativas de fim irão existir.
\begin{code}
prop_af :: Bdt Int -> ([Bool],[Bool]) -> Property
prop_af t (l1,l2) = let t' = extLTree t
                        f = length . tipsLTree . (navLTree t')
                    in isPrefixOf l1 l2 ==> (f l1 >= f l2)
\end{code}
\end{propriedade}

\Problema

%format B = "\mathit B"
%format C = "\mathit C"
Mónades são functores com propriedades adicionais que nos permitem obter
efeitos especiais em progra\-mação. Por exemplo, a biblioteca \Probability\
oferece um mónade para abordar problemas de probabilidades. Nesta biblioteca,
o conceito de distribuição estatística é captado pelo tipo
\begin{eqnarray}
  |newtype Dist a = D {unD :: [(a, ProbRep)]}|
  \label{eq:Dist}
\end{eqnarray}
em que |ProbRep| é um real de |0| a |1|, equivalente a uma escala de $0$ a
$100 \%$.

Cada par |(a,p)| numa distribuição |d::Dist a| indica que a probabilidade
de |a| é |p|, devendo ser garantida a propriedade de  que todas as probabilidades
de |d| somam $100\%$.
Por exemplo, a seguinte distribuição de classificações por escalões de $A$ a $E$,
\[
\begin{array}{ll}
A & \rule{2mm}{3pt}\ 2\%\\
B & \rule{12mm}{3pt}\ 12\%\\
C & \rule{29mm}{3pt}\ 29\%\\
D & \rule{35mm}{3pt}\ 35\%\\
E & \rule{22mm}{3pt}\ 22\%\\
\end{array}
\]
será representada pela distribuição
\begin{code}
d1 :: Dist Char
d1 = D [('A',0.02),('B',0.12),('C',0.29),('D',0.35),('E',0.22)]
\end{code}
que o \GHCi\ mostrará assim:
\begin{Verbatim}[fontsize=\small]
'D'  35.0%
'C'  29.0%
'E'  22.0%
'B'  12.0%
'A'   2.0%
\end{Verbatim}
É possível definir geradores de distribuições, por exemplo distribuições \emph{uniformes},
\begin{code}
d2 = uniform (words "Uma frase de cinco palavras")
\end{code}
isto é
\begin{Verbatim}[fontsize=\small]
     "Uma"  20.0%
   "cinco"  20.0%
      "de"  20.0%
   "frase"  20.0%
"palavras"  20.0%
\end{Verbatim}
distribuição \emph{normais}, eg.\
\begin{code}
d3 = normal [10..20]
\end{code}
etc.\footnote{Para mais detalhes ver o código fonte de \Probability, que é uma adaptação da
biblioteca \PFP\ (``Probabilistic Functional Programming''). Para quem quiser souber mais
recomenda-se a leitura do artigo \cite{EK06}.}
|Dist| forma um \textbf{mónade} cuja unidade é |return a = D [(a,1)]| e cuja composição de Kleisli
é (simplificando a notação)
\begin{spec}
  ((kcomp f g)) a = [(y,q*p) | (x,p) <- g a, (y,q) <- f x]
\end{spec}
em que |g: A -> Dist B| e |f: B -> Dist C| são funções \textbf{monádicas} que representam
\emph{computações probabilísticas}.
Este mónade é adequado à resolução de problemas de
 \emph{probabilidades e estatística} usando programação funcional, de
 forma elegante e como caso particular da programação
 monádica. Vamos estudar a aplicação
 deste mónade ao exercício anterior, tendo em conta o facto de que nem
 sempre podemos responder com 100\% de certeza a perguntas presentes
 em árvores de decisão.


Considere a seguinte situação: a Anita vai
 trabalhar no dia seguinte
e quer saber se precisa de levar guarda-chuva.  Na verdade,
 ela tem autocarro de porta de casa até ao trabalho, e portanto
 as condições meteorológicas não são muito significativas; a não ser
 que seja segunda-feira...Às segundas é dia de feira e o autocarro vai
 sempre lotado! Nesses dias, ela prefere fazer a pé o caminho de casa
 ao trabalho, o que a obriga a levar guarda-chuva (nos dias de
 chuva). Abaixo está apresentada a árvore de decisão respectiva a este problema.

 \[
     \xymatrix{
     && \text{2a-feira?} \ar[dl]_{\text{sim}} \ar[dr]^{\text{não}} & \\
     & \text{chuva na ida?} \ar[dl]_{\text{sim}} \ar[dr]^{\text{não}}
      && \text{não precisa} \\
     \text{precisa} && \text{chuva no regresso?}
    \ar[dl]_{\text{sim}} \ar[dr]^{\text{não}} & \\
     &\text{precisa} && \text{não precisa}
     }
  \]

Assuma que a Anita não sabe em que dia está, e que a previsão da
   chuva para a ida é de 80\% enquanto que a previsão de chuva para o
   regresso é de 60\%. \emph{A Anita deve
  levar guarda-chuva?}
  Para responder a esta questão, iremos tirar partido do que se aprendeu
  no exercício anterior. De facto, a maior diferença é que agora as
  respostas ("sim" ou "não") são dadas na forma de uma distribuição sobre o tipo de dados
  |Bool|. Implemente como um catamorfismo de |LTree| a função
\begin{code}
bnavLTree :: LTree a -> ((BTree Bool) -> LTree a)
\end{code}
que percorre uma árvore dado um caminho, \emph{não} do tipo |[Bool]|, mas
do tipo |BTree Bool|. O tipo |BTree Bool| é necessário
na presença de incerteza, porque neste contexto não sabemos sempre
       qual a próxima pergunta a responder. Teremos portanto
que ter resposta para todas as perguntas na árvore de decisão.

Seguem alguns exemplos dos resultados que se esperam
       ao aplicar |bnavLTree| a |(extLTree anita)|, em que |anita| é a
       árvore de decisão acima descrita, e a uma árvore
      binária de respostas.
     \begin{Verbatim}[fontsize=\small]
      *ML> bnavLTree (extLTree anita) (Node(True, (Empty,Empty)))
      Fork (Leaf "Precisa",Fork (Leaf "Precisa",Leaf "N precisa"))
      *ML> bnavLTree (extLTree anita) (Node(True, (Node(True,(Empty,Empty)),Empty)))
      Leaf "Precisa"
      *ML> bnavLTree (extLTree anita) (Node(False, (Empty,Empty)))
      Leaf "N precisa"
     \end{Verbatim}
Por fim, implemente como um catamorfismo de |LTree| a função
\begin{code}
pbnavLTree :: LTree a -> ((BTree (Dist Bool)) -> Dist(LTree a))
\end{code}
que deverá consiste na "monadificação" da função |bnavLTree| via a mónade das
probabilidades. Use esta última implementação para responder se a Anita deve
levar guarda-chuva ou não dada a situação acima descrita.
\Problema

Os \truchet{mosaicos de Truchet} são padrões que se obtêm gerando aleatoriamente
combinações bidimensionais de ladrilhos básicos. Os que se mostram na figura
\ref{fig:tiles} são conhecidos por ladrilhos de Truchet-Smith.
A figura \ref{fig:truchet} mostra um exemplo de mosaico produzido por uma
combinação aleatória de 10x10 ladrilhos |a| e |b| (cf.\ figura
\ref{fig:tiles}).

Neste problema pretende-se programar a geração aleatória de mosaicos de
Truchet-Smith usando o mónade \random{Random} e a biblioteca \gloss{Gloss}
para produção do resultado. Para uniformização das respostas, deverão ser
seguidas as seguintes condições:
\begin{itemize}
\item	Cada ladrilho deverá ter as dimensões 80x80
\item	O programa deverá gerar mosaicos de quaisquer dimensões, mas deverá ser apresentado como figura no relatório o mosaico de 10x10 ladrilhos.
\item	Valorizar-se-ão respostas elegantes e com menos linhas de código \Haskell.
\end{itemize} 
No anexo \ref{sec:codigo} é dada uma implementação da operação de permuta aleatória de uma lista que pode ser útil para resolver este exercício.

    \begin{figure}\centering
    \includegraphics[scale=0.20]{images/tiles.png}
    \caption{Os dois ladrilhos de Truchet-Smith.}
    \label{fig:tiles}
    \end{figure}

    \begin{figure}\centering
    \includegraphics[scale=0.20]{images/truchet.png}
    \caption{Um mosaico de Truchet-Smith.}
    \label{fig:truchet}
    \end{figure}

%----------------- Programa, bibliotecas e código auxiliar --------------------%

\newpage

\part*{Anexos}

\appendix

\section{Como exprimir cálculos e diagramas em LaTeX/lhs2tex}
Estudar o texto fonte deste trabalho para obter o efeito:\footnote{Exemplos tirados de \cite{Ol18}.} 
\begin{eqnarray*}
\start
  |id = split f g|
%
\just\equiv{ universal property }
%
        |lcbr(
    p1 . id = f
  )(
    p2 . id = g
  )|
%
\just\equiv{ identity }
%
        |lcbr(
    p1 = f
  )(
    p2 = g
  )|
\qed
\end{eqnarray*}

Os diagramas podem ser produzidos recorrendo à \emph{package} \LaTeX\ 
\href{https://ctan.org/pkg/xymatrix}{xymatrix}, por exemplo: 
\begin{eqnarray*}
\xymatrix@@C=2cm{
    |Nat0|
           \ar[d]_-{|cataNat g|}
&
    |1 + Nat0|
           \ar[d]^{|id + (cataNat g)|}
           \ar[l]_-{|inNat|}
\\
     |B|
&
     |1 + B|
           \ar[l]^-{|g|}
}
\end{eqnarray*}


\section{Código fornecido}\label{sec:codigo}

\subsection*{Problema 1}
Função de representação de um dicionário:
\begin{code}
dic_imp :: [(String,[String])] -> Dict
dic_imp = Term "" . map (bmap  id singl) . untar . discollect
\end{code}
onde
\begin{code}
type Dict = Exp String String
\end{code}
Dicionário para testes:
\begin{code}
d :: [(String, [String])]
d =  [ ("ABA",["BRIM"]),
       ("ABALO",["SHOCK"]),
       ("AMIGO",["FRIEND"]),
       ("AMOR",["LOVE"]),
       ("MEDO",["FEAR"]),
       ("MUDO",["DUMB","MUTE"]),
       ("PE",["FOOT"]),
       ("PEDRA",["STONE"]),
       ("POBRE",["POOR"]),
       ("PODRE",["ROTTEN"])]
\end{code}
Normalização de um dicionário (remoção de entradas vazias):
\begin{code}
dic_norm = collect . filter p . discollect where
   p(a,b)= a > "" && b > ""
\end{code}
Teste de redundância de um significado |s| para uma palavra |p|:
\begin{code}
dic_red p s d = (p,s) `elem` discollect d
\end{code}

\subsection*{Problema 2}

Árvores usadas no texto:
\begin{code}
emp x = Node(x,(Empty,Empty))

t7 = emp 7
t16 = emp 16
t7_10_16 = Node(10,(t7,t16))
t1_2_nil = Node(2,(emp 1, Empty)) 
t' = Node(5,(t1_2_nil, t7_10_16))

t0_2_1 = Node(2, (emp 0, emp 3))
t5_6_8 = Node(6, (emp 5, emp 8))
t2 = Node(4, (t0_2_1, t5_6_8))

dotBt :: (Show a) => BTree a -> IO ExitCode
dotBt = dotpict . bmap Just Just . cBTree2Exp . (fmap show)
\end{code}

\subsection*{Problema 3}
Funções usadas para efeitos de teste:
\begin{code}
tipsBdt :: Bdt a -> [a]
tipsBdt = cataBdt (either singl ((uncurry (++)) . p2))
tipsLTree = tips
\end{code}

\subsection*{Problema 5}
Função de permutação aleatória de uma lista:
\begin{code}
permuta [] = return []
permuta x = do { (h,t) <- getR x; t' <- permuta t; return (h:t') } where
      getR x = do { i <- getStdRandom (randomR (0,length x-1)); return (x!!i,retira i x) }
      retira i x = take i x ++ drop (i+1) x
\end{code}

\subsection*{QuickCheck}
Código para geração de testes:
\begin{code}
instance Arbitrary a => Arbitrary (BTree a) where
    arbitrary = sized genbt  where
              genbt 0 = return (inBTree $ i1 ())
              genbt n = oneof [(liftM2 $ curry (inBTree . i2))
                QuickCheck.arbitrary (liftM2 (,) (genbt (n-1)) (genbt (n-1))),
                (liftM2 $ curry (inBTree . i2))
                QuickCheck.arbitrary (liftM2 (,) (genbt (n-1)) (genbt 0)),
                (liftM2 $ curry (inBTree . i2))
                QuickCheck.arbitrary (liftM2 (,) (genbt 0) (genbt (n-1)))]               

instance (Arbitrary v, Arbitrary o) => Arbitrary (Exp v o) where
    arbitrary = (genExp 10)  where
              genExp 0 = liftM (inExp . i1) QuickCheck.arbitrary
              genExp n = oneof [liftM (inExp . i2 . (\a -> (a,[]))) QuickCheck.arbitrary,
                         liftM (inExp . i1) QuickCheck.arbitrary,
                         liftM (inExp . i2 . (\(a,(b,c)) -> (a,[b,c])))
                         $ (liftM2 (,) QuickCheck.arbitrary (liftM2 (,)
                                                             (genExp (n-1)) (genExp (n-1)))),
                         liftM (inExp . i2 . (\(a,(b,c,d)) -> (a,[b,c,d])))
                         $ (liftM2 (,) QuickCheck.arbitrary (liftM3 (,,)
                                                             (genExp (n-1)) (genExp (n-1)) (genExp (n-1))))        
                      ]

orderedBTree :: Gen (BTree Int)
orderedBTree = liftM (foldr insOrd Empty) (QuickCheck.arbitrary :: Gen [Int])

instance (Arbitrary a) => Arbitrary (Bdt a) where
    arbitrary = sized genbt  where
              genbt 0 = liftM Dec QuickCheck.arbitrary
              genbt n = oneof [(liftM2 $ curry Query)
                QuickCheck.arbitrary (liftM2 (,) (genbt (n-1)) (genbt (n-1))),
                (liftM2 $ curry (Query))
                QuickCheck.arbitrary (liftM2 (,) (genbt (n-1)) (genbt 0)),
                (liftM2 $ curry (Query))
                QuickCheck.arbitrary (liftM2 (,) (genbt 0) (genbt (n-1)))]      


\end{code}

\subsection*{Outras funções auxiliares}
%----------------- Outras definições auxiliares -------------------------------------------%
Lógicas:
\begin{code}
infixr 0 .==>.
(.==>.) :: (Testable prop) => (a -> Bool) -> (a -> prop) -> a -> Property
p .==>. f = \a -> p a ==> f a

infixr 0 .<==>.
(.<==>.) :: (a -> Bool) -> (a -> Bool) -> a -> Property
p .<==>. f = \a -> (p a ==> property (f a)) .&&. (f a ==> property (p a))

infixr 4 .==.
(.==.) :: Eq b => (a -> b) -> (a -> b) -> (a -> Bool)
f .==. g = \a -> f a == g a

infixr 4 .<=.
(.<=.) :: Ord b => (a -> b) -> (a -> b) -> (a -> Bool)
f .<=. g = \a -> f a <= g a

infixr 4 .&&&.
(.&&&.) :: (a -> Bool) -> (a -> Bool) -> (a -> Bool)
f .&&&. g = \a -> ((f a) && (g a))
\end{code}
Compilação e execução dentro do interpretador:\footnote{Pode ser útil em testes
envolvendo \gloss{Gloss}. Nesse caso, o teste em causa deve fazer parte de uma função
|main|.}
\begin{code}

run = do { system "ghc cp1920t" ; system "./cp1920t" }
\end{code}

%----------------- Soluções dos alunos -----------------------------------------%

\section{Soluções dos alunos}\label{sec:resolucao}
Os alunos devem colocar neste anexo as suas soluções aos exercícios
propostos, de acordo com o "layout" que se fornece. Não podem ser
alterados os nomes ou tipos das funções dadas, mas pode ser adicionado texto e/ou 
outras funções auxiliares que sejam necessárias.

\subsection*{Problema 1}
\subsection*{QuickChecks adicionais}

\begin{code}
valid t = t == (dic_imp . dic_norm . dic_exp) t
\end{code}
\begin{propriedade}
Se um significado |s| de uma palavra |p| já existe num dicionário normalizado então adicioná-lo
em memória não altera nada:
\begin{code}
prop_dic_red1 p s d
   | d /= dic_norm d = True  
   | dic_red p s d = dic_imp d == dic_in p s (dic_imp d)
   | otherwise = True
\end{code}
\end{propriedade}
\begin{propriedade}
A operação |dic_rd| implementa a procura na correspondente exportação de um dicionário normalizado:
\begin{code}
prop_dic_rd1 (p,t)
   | valid t     = dic_rd  p t == lookup p (dic_exp t)
   | otherwise = True
\end{code}
\end{propriedade}

\subsection*{Definições auxiliares}
\begin{code}
data XNat a = Zero a | Succ (XNat a) deriving Show
inXNat = either Zero Succ
outXNat (Zero a) = Left a
outXNat (Succ n) = Right n

baseXNat f g = f -|- g
recXNat f = baseXNat id f
cataXNat a = a . (recXNat (cataXNat a)) . outXNat
anaXNat f = inXNat . (recXNat (anaXNat f)) . f
hyloXNat a c = cataXNat a . anaXNat c

codiag = either id id
tailr = hyloXNat codiag
while2 p f g = tailr ((g -|- f) . grd (not . p))

\end{code}

\subsection*{Discollect}
\begin{code}
discollect :: (Ord b, Ord a) => [(b, [a])] -> [(b, a)]
discollect = cataList g where
  g = either (const []) (uncurry (++) . (f >< id))
    where f (a,l) = map (split (const a)  id) l

\end{code}
Foi também desenvolvida um versão utilizando o operador bind
\begin{code}
discollect2 :: (Ord b, Ord a) => [(b, [a])] -> [(b, a)]
discollect2 = (>>= f) 
    where f (a,l) = map (split (const a)  id) l
\end{code}

\subsection*{Dic\_exp}
\begin{code}
dic_exp :: Dict -> [(String,[String])]
dic_exp = collect . tar

tar = cataExp g where
  g = either (singl . (split (const "") id)) (f)
  f (a,b) = map ((++) a >< id) (concat b) 

\end{code}

\subsection*{Dic\_rd}
\begin{code}
dic_rd :: String -> Dict -> Maybe [String]
dic_rd s d = while2 p loopBody exit (s,Just d) where 
              p(a,b) = (((length a) > 1) && isJust b)
              exit(_,Nothing) = Nothing
              exit([],_) = Nothing
              exit([w], Just (Var x)) = Nothing
              exit ([w],Just (Term o l)) | (o == [] || w /= head o) = Nothing
                                         |otherwise = f l 
                   where f = (either nothing (Just . cons)) . outList . map (either id p1) . filter (isLeft) . map (outExp) 
            

loopBody (s,Just (Var v)) = (s,Nothing)
loopBody(s,Just (Term o l)) | (o == []) = (s, termLsearch s l)
                  | (head s == head o) = (tail s,termLsearch (tail s) l)
                  | otherwise = (s, termLsearch s l)

termLsearch s ((Term o l):xs) = if (head s == head o) then Just (Term o l) else termLsearch s xs
termLsearch s (_:xs) = termLsearch s xs
termLsearch _ [] = Nothing 

isJust (Just _) = True
isJust _ = False

isLeft (Left _) = True
isLeft _ = False

\end{code}

\subsection*{Dic\_in}
\begin{code}
dic_in :: String -> String -> Dict -> Dict
dic_in p t d = hyloExp conquer divide (Just $ traductionToDict (p,t), d) where
        conquer = inExp . either outExp i2
        divide (Nothing, g) = i1(g)
        divide (_,Var l) = i1(Var l)
        divide (Just (Term x xs),Term o l) | (o == []) =  i2 $ (o,divide_aux (Term x xs) (False,l))
                                           | (head x == head o) = i2 $ (o,divide_aux (head xs) (False,l))
                                           | otherwise = i1(Term o l)

traductionToDict :: (String,String) -> Dict
traductionToDict = anaExp g where
  g([],t) = i1(t)
  g(p:ps,t) = i2(singl p, singl (ps,t))


divide_aux :: Dict -> (Bool,[Dict]) -> [(Maybe Dict,Dict)]
divide_aux x (bool,[]) = if (not bool) 
                         then singl (Nothing,x)
                         else []
divide_aux x (bool,((Var v):ts)) = ((Nothing,(Var v)) : (divide_aux x (test_bool,ts)))
                        where test_bool =  either (v ==) false $ outExp x 
divide_aux x (bool,((Term o l):ts)) | (o == []) = (Nothing,Term o l) : (divide_aux x (bool,ts))
                                    | (not bool && (either false ((== head o) . head .p1) $ outExp x)) = 
                                      (Just x,Term o l) : (divide_aux x (True,ts))
                                    | otherwise = (Nothing,(Term o l)) : (divide_aux x (bool,ts))

\end{code}

\subsection*{Problema 2}

\subsection*{maisDir}

Esta função aplica o catamorfismo sobre BTrees. Caso a BTree seja Empty retorna Nothing, 
caso contrário a cada iteração verifica se a árvore da Direita (p2.p2) é vazia e se for 
retorna o nodo (return . p1), se não for retorna a árvore da Direita (const (p2.p2)) 
para continuar a percorrer recursivamente. A maneira como isto é feito é conservando (através de um split) num par a função 
a aplicar ao nodo desconstruido (após outBTree) no lado esquerdo e o nodo desconstruido no lado direito com o id. 
De seguida chama-se a função Cp.ap que aplica a função do lado esquerdo ao elemento do lado direito.

\begin{code}
maisDir = cataBTree g
    where g = either (nothing) $ Cp.ap . (split (maybe (return . p1) (const (p2.p2)) . p2 . p2) id)
\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |BTree X|
           \ar[d]_-{|cataBTree (g)|}
           \ar[r]_-{|outBTree|}
&
    |1 + (X >< (BTree X)quadrado)|
           \ar[d]^-{|id + id >< (cataBTree (g)quadrado|}
\\
     |Maybe X|
&
     |1 + (X >< (Maybe X) quadrado)|
           \ar[l]^-{g}
}
\end{eqnarray*}

\subsection*{maisEsq}

Esta função funciona de forma análoga à função de cima com a única diferença ser avaliar a àrvore da esquerda
e retornar essa mesma àrvore para a chamada recursiva.

\begin{code} 

maisEsq = cataBTree g 
  where g = either (nothing) $ Cp.ap . (split (maybe (return . p1) (const (p1.p2)) . p1 . p2) id)
\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |BTree X|
           \ar[d]_-{|cataBTree (g)|}
           \ar[r]_-{|outBTree|}
&
    |1 + (X >< (BTree X)quadrado)|
           \ar[d]^-{|id + id >< (cataBTree (g)quadrado|}
\\
     |Maybe X|
&
     |1 + (X >< (Maybe X) quadrado)|
           \ar[l]^-{g}
}
\end{eqnarray*}


\subsection*{insOrd}

A insOrd usa um hilomorfismo (divide and conquer) Hard Split/Easy Join. 

Recebe um par do tipo (Maybe X, BTree X) com o elemento a inserir e a àrvore e aplica um anamorfismo de FTree
com o gene divide.

Isto para recursivamente percorrer a BTree segundo a procura binaria e construir um FTree,
conservando os ramos rejeitados pela procura binaria (passando o Nothing no lado esquerdo do par para a iteracao seguinte e colocando o caso de paragem adequado para ser injetado)
até encontrar uma árvore Empty onde injeta o novo nodo.

Depois aplica um catamorfismo com o gene conquer para converter a FTree numa BTree com o elemento inserido ordenadamente.

\begin{code}

insOrd' = undefined

insOrd a x = hyloFTree (conquer) (divide) (Just a,x)
  where divide (Just a,Empty) = i1(Node(a,(Empty,Empty)))
        divide (Just a,Node (n,(t1,t2))) | a <= n = i2(n,((Just a,t1),(Nothing,t2)))
                                         | a > n = i2(n,((Nothing,t1),(Just a,t2)))
        divide (Nothing,p) = i1(p);
        conquer = inBTree . either (outBTree) i2
        
\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |(Maybe X >< BTree X)|
           \ar[d]_-{|anaFTree (divide)|}
           \ar[r]_-{|divide|}
&
    |BTree X + (X >< (Maybe X >< BTree X) quadrado)|
           \ar[d]^-{|id + id >< (anaFTree (divide)quadrado|}
\\
     |FTree(X ,BTree X)|
           \ar[d]_-{|cataFTree (conquer)|}
&
     |BTree X + (X >< (FTree (X,BTree X)) quadrado)|
           \ar[d]^-{|id + id >< (cataFTree (conquer)quadrado|}
\\  
     |BTree X| 
&
     |BTree X + (X >< (BTree X)quadrado)|
           \ar[l]^-{conquer}        
}
\end{eqnarray*}


\subsection*{isOrd}
\begin{code}

isOrd' = cataBTree g
  where g = undefined

isOrd = p1 . cataBTree g 
      where g = either (const (True,Empty)) (split (f2 (funcaoComparacao . Node)) (Node . f))
            f = (id >< (p2 >< p2))
            f2 p (a,(b,c)) = p (f (a,(b,c)) ) && p1(b) && p1(c) 
            funcaoComparacao (Node(a,(t1,t2))) = (either (const True) ((<= a).p1) (outBTree t1)) && (either (const True) ((>= a).p1) (outBTree t2))
\end{code}


\subsection*{rrot}

Faz uma rotação à direita numa BTree

\begin{code}
rrot Empty = Empty
rrot t@(Node (a,(Empty,d))) = t
rrot (Node (black,((Node (red,(purple,green))),blue))) = Node(red,(purple,(Node (black,(green,blue)))))
\end{code}

\subsection*{lrot}

Faz uma rotação à esquerda numa BTree

\begin{code}
lrot Empty = Empty
lrot t@(Node (a,(e,Empty))) = t
lrot (Node (black,(blue,(Node (red,(green,purple)))))) = Node(red,((Node (black,(blue,green)),purple)))
\end{code}

\subsection*{Splay}

Aplica um catamorfismo de Listas para recursivamente rodar a arvore de acordo com os valores booleanos

\begin{code}
splay = cataList g
  where g = either (const id) f
        f (True,l) = rrot . l   
        f (False,l) = lrot . l

\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |List Bool|
           \ar[d]_-{|cataList (g)|}
           \ar[r]_-{|outList|}
&
    |1 + (Bool >< List Bool)|
           \ar[d]^-{|id + id >< (cataList (g)quadrado|}
\\
     |expn (BTree a) (BTree a)|
&
     |1 + (Bool >< (expn (BTree a) (BTree a)))|
           \ar[l]^-{g}
}
\end{eqnarray*}

\subsection*{Problema 3}
\subsection*{Definições iniciais}
\begin{code}

inBdt:: Either a (String,(Bdt a, Bdt a)) -> Bdt a
inBdt = either Dec Query

outBdt:: Bdt a -> Either a (String,(Bdt a, Bdt a))
outBdt (Dec a)  = i1 a
outBdt (Query(s,(b1,b2))) = i2 (s,(b1,b2)) 

baseBdt f g  = f -|- (id >< ( g >< g ))  

recBdt f = baseBdt id f

cataBdt g = g . (recBdt (cataBdt g)) . outBdt

anaBdt g = inBdt . (recBdt (anaBdt g)) . g 
\end{code}

\subsection*{Diagrama do Anamorfismo}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |Bdt A|
&
    |A + (String >< (Bdt A)quadrado)|
           \ar[l]_-{|inBdt|}
\\
     |C|    
           \ar[u]_-{|(anaBdt (g))|}
           \ar[r]^-{|g|}
&
     |A + (String >< (C)quadrado )|
           \ar[u]^{|id+(id ><(anaBdt (g)) quadrado)|}
}
\end{eqnarray*}
\subsection*{ExtLTree}
A diferença em termos estruturais entre os dois tipos de dados é a presença da String nos nodos, informação que irá ser removida na transformação para LTree
\begin{code}


extLTree :: Bdt a -> LTree a
extLTree = cataBdt g where
  g = either (Leaf) (Fork . p2)
\end{code}

\subsection*{NavLTree}
Visto que as funções do haskell são naturalmente curried, é possível dizer que  f :: a -\textgreater b -\textgreater c 
é o mesmo que f :: a -\textgreater (b -\textgreater c).

Esse facto permite-nos obter o tipo da assinatura de navLTree como sendo uma função que recebe uma LTree A e 
devolve uma função que vai [Bool] para Ltree A.


\bigbreak
\textbf{Versão pointfree}
\begin{code}

navLTree :: LTree a -> ([Bool] -> LTree a)
navLTree = cataLTree (either (const . Leaf) (\(l,r) -> Cp.cond null (Fork . split l r) (Cp.cond head (l . tail) (r . tail)))) 
\end{code}

\textbf{Versão pointwise}

\begin{code}
navLTreePointWise :: LTree a -> ([Bool] -> LTree a)
navLTreePointWise = cataLTree g 
  where g = either (\a _ -> Leaf a) f where
            f (l, r) [] = Fork (l [], r [])
            f (l, r) (True:hs) = l hs
            f (l, r) (False: hs) = r hs
\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |LTree A|
           \ar[d]_-{|cataLTree (g)|}
           \ar[r]_-{|outLTree|}
&
    |A + (LTree A)quadrado|
           \ar[d]^-{|id + (cataLTree (g))quadrado|}
\\
     |(expn ([Bool]) (LTree A))|
&
     |A + ((expn ([Bool]) (LTree A)))quadrado|
           \ar[l]^-{g}
}
\end{eqnarray*}

\subsection*{Problema 4}
\subsection*{BnavLTree}
Esta função é bastante semelhante à função \textbf{navLTree} do exercício 3, sendo a principal diferença que agora será uma BTree Bool 
a ditar a navegação e não uma lista de Boleanos.

\bigbreak
\textbf{Versão pointfree}
\begin{code}

bnavLTree = cataLTree (either (const . Leaf) (\(l,r)-> Cp.cond (Empty ==) (g (l,r)) (h (l,r))))
    where f = (const . Leaf)
          g (l,r) = Fork . split l r
          --h (l,r) = Cp.cond (p1 . outNode) (l . p1 . p2. outNode) (r . p2 . p2 . outNode)
          h (l,r) = (Cp.cond (p1) (l . p1 . p2) (r . p2 . p2 )) . outNode
          outNode (Node(a,(b,c))) = (a,(b,c))

\end{code}
\textbf{Versão pointwise}
\begin{code}
bnavLTreePointWise = cataLTree g
  where g = either (\a _ -> Leaf a) f where
            f (l, r) Empty = Fork (l Empty, r Empty)
            f (l, r) (Node(True,(left,right))) = l left
            f (l, r) (Node(False,(left,right))) = r right
\end{code}

\begin{eqnarray*}
\xymatrix@@C=2cm{
    |LTree A|
           \ar[d]_-{|cataLTree (g)|}
           \ar[r]_-{|outLTree|}
&
    |A + (LTree A)quadrado|
           \ar[d]^-{|id + (cataLTree (g))quadrado|}
\\
     |(expn ((BTree Bool)) (LTree A))|
&
     |A + ((expn ((BTree Bool)) (LTree A)))quadrado|
           \ar[l]^-{g}
}
\end{eqnarray*}

\subsection*{PbnavLTree}
Esta função irá percorrer uma LTree representante de uma situação onde em que a decisão depende de vários 
fatores que são testados sucessivamente. A probabilidade de ocorrência, ou não, de cada fator é representada por 
\textbf{Dist Bool}. Devido à natureza sucessiva destes acontecimentos, as suas probabilidades estão organizadas numa
\textbf{BTree (Dist Bool)}. Será essa BTree, em conjunto com a LTree, que será percorrida para dar resposta à probabilidade
de cada uma das respostas.

\begin{code}

pbnavLTreeDist = cataLTree g
  where g = either (\a _ -> D [(Leaf a,1)]) f where
            f (l, r) Empty = D[(Fork(((extract (l Empty))!!0),((extract (r Empty))!!0)),1)];
            f (l, r) (Node(d,(b1,b2))) = Probability.cond d (l b1) (r b2)

\end{code}
Foi também desenvolvida uma função que se serve da maquinaria monádica para abstrair a monad, no caso de estarmos numa Leaf e 
no caso em que a BTree é Empty. Esta revela-se mais intuitiva e tem a vantagem de não se estar a assumir o conteúdo de variáveis, 
ao contrário do que acontece com extract, na função anterior. 

\begin{code}
pbnavLTree = cataLTree g
  where g = either (\a _ -> return (Leaf a)) f where
            f (l, r) Empty = (prod (l Empty) (r Empty)) >>= (return . Fork)
            --f (l, r) (Node(d,(b1,b2))) = Probability.cond d (l b1) (r b2)
            f (l,r) (Node(d,(b1,b2))) = d >>= (\x -> if x then l b1 else r b2)

\end{code}

O seguinte diagrama ilustra a o funcionamento do primeiro caso da função auxiliar f.
\bigbreak
Nota: unfoldD é a operação join/multiplicação da monad Dist.

\begin{eqnarray*}
\xymatrix@@C=4cm{
    |Dist (Dist LTree A)|
          \ar[d]_-{|unfoldD|}
&
    |Dist(LTree A)quadrado)|
           \ar[l]_-{|T (return . Fork)|}
           \ar[l_d]_-{| >>= return . Fork|}
\\
     |Dist (LTree A)|
&
     |(Ltree A)quadrado|
           \ar[l]^{|return . Fork|}
}
\end{eqnarray*}


\subsection*{Problema 5}

\begin{code}

truchet1 = Pictures [ put (0,80) (Arc (-90) 0 40), put (80,0) (Arc 90 180 40) ]

truchet2 = Pictures [ put (0,0) (Arc 0 90 40), put (80,80) (Arc 180 (-90) 40) ]

--- janela para visualizar:

janela = InWindow
             "Truchet"        -- window title
             (800, 800)       -- window size
             (100,100)        -- window position

----- defs auxiliares -------------

put  = uncurry Translate 

matrix x y = do
  r <- generateMatrix x y
  display janela white r




generateMatrix :: Int -> Int -> IO Picture
generateMatrix i j =  (sequence . replicate (i * j) $ randomRIO(0,1) >>= generateTruchet) 
                         >>= (return . pictures . zipWith id l)
  where l = do { x' <- map (80 *) [0..(fromIntegral i)-1];
                    y' <- map (80 *) [0..(fromIntegral j)-1]; 
                    return(put(x',y'))}

zzz i j = do { x' <- map (80 *) [0..(fromIntegral i)-1];
                    y' <- map (80 *) [0..(fromIntegral j)-1]; 
                    return(put(x',y'))}
generateTruchet :: Integer -> IO Picture
generateTruchet = return . (Cp.cond (==0) (const truchet1) (const truchet2))




-------------------------------------------------
\end{code}


    \begin{figure}\centering
    \includegraphics[scale=1]{images/mosaico.png}
    \caption{Mosaico gerado pelo grupo}
    \label{fig:mosaico}
    \end{figure}
    

%----------------- Fim do anexo com soluções dos alunos ------------------------%

%----------------- Índice remissivo (exige makeindex) -------------------------%

\printindex

%----------------- Bibliografia (exige bibtex) --------------------------------%

\bibliographystyle{plain}
\bibliography{cp1920t}

%----------------- Fim do documento -------------------------------------------%
\end{document}
