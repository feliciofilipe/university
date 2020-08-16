module Maps where

import DataStruct
import Functions
import MapEditor

-- | Função que cria o estado para ser jogado no ModoZombie  
estadoModoZombie :: Estado
estadoModoZombie = (Estado (stringParaMapa ["+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++",
                                            "+              +2c              +1b            +0a1b2c7h                                                6g5f4e3d+",
                                            "+              +cc              +bb            +aabbcchh                                                ggffeedd+",
                                            "+              +                +              +              ++   ++++++  ++++++  ++++++                       +",
                                            "+              +                +              +             +++   ++++++  ++++++  ++++++                       +",
                                            "+              +                +              +            ++++   ++  ++      ++  ++  ++                       +",
                                            "+              p                p              +           ++ ++   ++  ++      ++  ++  ++                       +",
                                            "+              p                p              +          ++  ++   ++++++    ++++  ++++++    ++++++             +",
                                            "+              p                p              +         ++   ++   ++++++    ++++  ++++++    ++++++             +",
                                            "+              p                p              +              ++       ++      ++      ++                       +",
                                            "+              +                +              +              ++       ++      ++      ++                       +",
                                            "+              +                +              +              ++       ++  ++++++      ++                       +",
                                            "+              +                +              +              ++       ++  ++++++      ++                       +",
                                            "+              +                +              +                                                                +",
                                            "+              +                +              +                                                                +",
                                            "++++++pppp++++++                ++++++pppp++++++                            ++  ++++++       ++  ++++++         +",
                                            "+5f                                            p                           +++  ++++++     ++++  ++++++         +",
                                            "+ff                                            p                          ++++  ++  ++    ++ ++  ++             +",
                                            "+                                              p                         ++ ++  ++  ++   ++  ++  ++             +",
                                            "+                                              p                        ++  ++  ++++++  +++++++  ++++           +",
                                            "++++++pppp++++++                ++++++pppp++++++                       ++   ++  ++++++  +++++++  +++++          +",
                                            "+              +                +              +                            ++      ++       ++      ++         +",
                                            "+              +                +              +                            ++      ++       ++      ++         +",
                                            "+              +                +              +                            ++      ++       ++  +++++          +",
                                            "+              +                +              +                            ++      ++       ++  ++++           +",
                                            "+              +                +              +                                                                +",
                                            "+              +                +              +                                                                +",
                                            "+              p                p              +                                                                +",
                                            "+              p                p            2c+    +++++   +++++   +++++  +++++   +++++   +++++  ++++  ++++    +",
                                            "+              p                p            cc+      ++     +++     ++      ++     +++     ++     ++    ++     +",
                                            "+              p                p              +       ++   ++ ++   ++        ++   ++ ++   ++      ++    ++     +",
                                            "+3d            +                +              +        ++ ++   ++ ++          ++ ++   ++ ++       ++    ++     +",
                                            "+dd            +                +              +         +++     +++            +++     +++       ++++  ++++    +",
                                            "+              +                +              +                                                                +",
                                            "+              +                +              +                                                                +",
                                            "++++++pppp++++++                ++++++pppp++++++                                                                +",
                                            "+                               +              ++++++++++++++++++pppp+++++++++++++++++++++++++++++pppp+++++++++++",
                                            "+                               +              p           +            3d+                +4e             +0a1b+",
                                            "+                               +              p           +            dd+                +ee             +aabb+",
                                            "+                               +              p           +              +                +               +    +",
                                            "+                               +              p           +              +                +               +    +",
                                            "++++++++++++++++++++++++++++++++++++++++++++++++           +              +                +               +    +",
                                            "+2c                                            +           +              p                p               p    +",
                                            "+cc                                            +         3d+              p                p               p    +",
                                            "+                                              p         dd+              p                p               p    +",
                                            "+                                              p           +              p                p               p    +",
                                            "+                                              p           +              +                +               +    +",
                                            "+                                              p           +              +                +               +    +",
                                            "+                                              +           +              +                +               +    +",
                                            "+                                              +           +              +                +               +    +",
                                            "++++++pppp++++++++++++++++++++++++++++++++++++++++++++++++++              +                +               +    +",
                                            "+7h            +6g                                       1b++++++pppp++++++                +++++++pppp++++++    +",
                                            "+hh            +gg                                       bb+                                                    +",
                                            "+              +                                           +                                                    +",
                                            "+              +                                           +                                                    +",
                                            "+              p                                           +                                                    +",
                                            "+              p                                           ++++++pppp++++++                +++++++pppp++++++    +",
                                            "+              p                                           +            6g+                +2c             +    +",
                                            "+              p                                           +            gg+                +cc             +    +",
                                            "+              +                                           +              +                +               +    +",
                                            "+              +                                           +              +                +               +    +",
                                            "+4e            +0a                                         +              p                p               p    +",
                                            "+ee            +aa                                         +              p                p               p    +",
                                            "++++++pppp++++++++++++++++++++++++++++++++++++++++++++++++++              p                p               p    +",
                                            "+5f                                                 2c     +              p                p               p    +",
                                            "+ff                                                 cc     p              +                +               +    +",
                                            "+                                                          p              +                +               +    +",
                                            "+                                                          p              +                +               +    +",
                                            "+                                                          p              +                +               +    +",
                                            "+                                                          +              +                +               +    +",
                                            "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"])
                          [(Jogador (1,2) D 100 12 200 Pistol),(Jogador (12,12) E 100 12 200 Pistol),(Jogador (-9,-9) D 0 50000 50000 Pistol),(Jogador (-16,-16) D 0 0 0 Pistol),(Jogador (-30,-30) D 0 0 0 Pistol),(Jogador (10,10) C 3 1 99 Pistol)] [])


-- | Função que cria o estado inicial, ou seja, o estado na abretura do jogo (menu inicial)
estadoInicial :: Estado
estadoInicial = (Estado [] [] [])
 
-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa' 
estadoGCE :: Estado
estadoGCE =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                      "+                +xxxx+                +",
                                      "+                 ++++                 +",
                                      "+  ++++                          ++++  +",
                                      "+  +xx+                          +xx+  +",
                                      "+  +x+             ++             +x+  +",
                                      "+  ++       +     +xx+     +       ++  +",
                                      "+          +x+    +xx+    +x+          +",
                                      "+         +xx+    +xx+    +xx+         +",
                                      "+    +     ++     +xx+     ++     +    +",
                                      "+   +x+          +xxxx+          +x+   +",
                                      "+    +            +xx+            +    +",
                                      "++            +    ++    +            ++",
                                      "+x+       ++++x+        +x++++       +x+",
                                      "+x+      +xxxxxx+      +xxxxxx+      +x+",
                                      "+x+      +xxxxxx+      +xxxxxx+      +x+",
                                      "+x+       ++++x+        +x++++       +x+",
                                      "++            +    ++    +            ++",
                                      "+    +            +xx+            +    +",
                                      "+   +x+          +xxxx+          +x+   +",
                                      "+    +     ++     +xx+     ++     +    +",
                                      "+         +xx+    +xx+    +xx+         +",
                                      "+          +x+    +xx+    +x+          +",
                                      "+  ++       +     +xx+     +       ++  +",
                                      "+  +x+             ++             +x+  +",
                                      "+  +xx+                          +xx+  +",
                                      "+  ++++                          ++++  +",
                                      "+                 ++++                 +",
                                      "+                +xxxx+                +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'mapaInicial' criada na 'Tarefa1_2018li1g159'              
estadoPH :: Estado
estadoPH =  (Estado (mapaInicial(15,20)) 
                [(Jogador (7,1) D 5 5 5 Pistol),(Jogador (7,17) E 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'
estadoDD :: Estado
estadoDD =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww+",
                                      "+wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww+",
                                      "+wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww+",
                                      "+                                      +",
                                      "+                ++                 nn +",
                                      "+                             ++    nn +",
                                      "+    nn                                +",
                                      "+    nn                                +",
                                      "+                 **                 xx+",
                                      "+                                    xx+",
                                      "+                                      +",
                                      "+       **                    **       +",
                                      "+                    nn                +",
                                      "+                ++  nn                +",
                                      "+                                 ++   +",
                                      "+  nn     **         **                +",
                                      "+  nn                                  +",
                                      "+                              **      +",
                                      "+            **    ++                  +",
                                      "+    ++                                +",
                                      "+xxxx                         nn       +",
                                      "+xxxx                **       nn       +",
                                      "+xxxx       ++                         +",
                                      "+xxxx                                  +",
                                      "+                                    xx+",
                                      "+      nn                    ++      xx+",
                                      "+      nn                          xx  +",
                                      "+                                  xx  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (10,19) B 5 5 5 Pistol),(Jogador (5,1) D 5 5 5 Pistol),(Jogador (12,35) E 5 5 5 Pistol),(Jogador (27,19) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'
estadoBE :: Estado
estadoBE =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                      "+      ++      ++                      +",
                                      "+      ++      ++    **  **            +",
                                      "+xx**  ++      **    **  **            +",
                                      "+xx**  ++      **    **++**            +",
                                      "+xx**  xxxxxx****    **++**            +",
                                      "+xx**  xxxxxx**nn    ++                +",
                                      "+xx    **    **nn    ++                +",
                                      "+xx    **    **      ** xx******nn   +++",
                                      "+xx    **  **++    ++** xx******nn   +++",
                                      "+xx    **  **++    ++** xx             +",
                                      "+xxxx  ******xxxx++**** xx             +",
                                      "+xxxx  ******xxxx++**** xx**           +",
                                      "+****nn****             xx**           +",
                                      "+****nn****             xx**           +",
                                      "+                   ++**xx**           +",
                                      "+                   ++**  **xxxxxx     +",
                                      "+             xxxx++  **  **xxxxxx     +",
                                      "+         ++xxxxxx++  wwww**wwwwxx     +",
                                      "+         ++xx**  **  wwww**wwwwxx     +",
                                      "++++++**ww++  **  **  **++**wwww+++nn+++",
                                      "++++++**ww++  **  **  **++**wwww+++nn+++",
                                      "+wwwww**  **  **  **        wwww       +",
                                      "+wwwww**  **  ******        wwww       +",
                                      "+wwwww**  **  ******                   +",
                                      "+wwwww**  **                 **  **    +",
                                      "+wwwww**  nn                 **  **    +",
                                      "+wwwww**  nn                 ******    +",
                                      "+wwwww**  **                 ******    +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (10,27) E 5 5 5 Pistol),(Jogador (1,37) E 5 5 5 Pistol),(Jogador (1,1) D 5 5 5 Pistol),(Jogador (17,6) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoMP :: Estado
estadoMP =  (Estado (stringParaMapa["++++++++++++++++++++",
                                    "+   +wwwwwwwwwwwwww+",
                                    "+   +wwwwwwwwwwwwww+",
                                    "+ **+wwwwwwwwwwwwww+",
                                    "+   +wwwwwwwwwwwwww+",
                                    "+   ++++++++++++++++",
                                    "+     *            +",
                                    "+     *      *     +",
                                    "+            *     +",
                                    "+   ++++++++++++++++",
                                    "+   +wwwwwwwwwwwwww+",
                                    "+** +wwwwwwwwwwwwww+",
                                    "+   +wwwwwwwwwwwwww+",
                                    "+   +wwwwwwwwwwwwww+",
                                    "++++++++++++++++++++"]) 
                [(Jogador (1,1) B 5 5 5 Pistol),(Jogador (6,17) E 5 5 5 Pistol),(Jogador (12,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoBB :: Estado
estadoBB =  (Estado (stringParaMapa["++++++++++++++++++++",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "+                  +",
                                    "++++++++++++++++++++"])  
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,17) B 5 5 5 Pistol),(Jogador (10,17) E 5 5 5 Pistol),(Jogador (10,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoFB :: Estado
estadoFB =  (Estado (stringParaMapa["++++++++++++++++++++",
                                    "+                  +",
                                    "+    **  ******    +",
                                    "+    **  ******    +",
                                    "+    **  **        +",
                                    "+    **  **        +",
                                    "+    **********    +",
                                    "+    **********    +",
                                    "+        **  **    +",
                                    "+        **  **    +",
                                    "+    ******  **    +",
                                    "+    ******  **    +",
                                    "+                  +",
                                    "++++++++++++++++++++"]) 
                [(Jogador (11,1) C 5 5 5 Pistol),(Jogador (1,17) B 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoIP :: Estado
estadoIP =  (Estado (stringParaMapa [ "++++++++++++++++++++++++++++++++++++++++",
                                      "+  xxxx                            xx  +",
                                      "+  xxxx            **              xx  +",
                                      "+xxxx            ******              xx+",
                                      "+xxxx          ***********           xx+",
                                      "+xx            *************         +++",
                                      "+xx           ****************       nn+",
                                      "+++           ****************       nn+",
                                      "+nn          ******************        +",
                                      "+nn          **      **********        +",
                                      "+           ***      ******   *        +",
                                      "+wwww       *          ****   *        +",
                                      "+wwww       *  +  +    ***             +",
                                      "+wwww       *  +  +    ***             +",
                                      "+wwww      **          ***       wwwwww+",
                                      "+          **  ****    ***       wwwwww+",
                                      "+          ****************      wwwwww+",
                                      "+          ****************      wwwwww+",
                                      "+         ******************           +",
                                      "+         ******************           +",
                                      "+        *********************         +",
                                      "+            ****************        nn+",
                                      "+            **  ********            nn+",
                                      "+nn      ****    ******  ****      nnxx+",
                                      "+nn      ******  ****  ******      nnxx+",
                                      "+xxnn      ****        ****      nnxxxx+",
                                      "+xxnn                            nnxxxx+",
                                      "+++xxnn                        nnxxxx+++",
                                      "+++xxnn                        nnxxxx+++",
                                      "++++++++++++++++++++++++++++++++++++++++"])
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (9,17) C 5 5 5 Pistol),(Jogador (1,37) E 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoOB :: Estado
estadoOB =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+          ++          ++              +",
                                      "+          ++          ++              +",
                                      "+          ++          **    **nn**    +",
                                      "+   **xxxxxnn**        **    **nn**    +",
                                      "+www**xxxxxnn**        **    **++**    +",
                                      "+www**                 **    **++**    +",
                                      "+   **          **           ++        +",
                                      "+               **           ++        +",
                                      "+xx       ++xxxx**wwwww++    **xx****+++",
                                      "+xx       ++xxxx**wwwww++    **xx****+++",
                                      "+xxxx   **++         **nn  ++  xxnn    +",
                                      "+xxxx   **++         **nn  ++  xxnn    +",
                                      "+                nnxxxxxx++    xx**    +",
                                      "+                nnxxxxxx++    xx**    +",
                                      "+                ++xx**  **  **  **    +",
                                      "+****            ++xx**  **  **  **    +",
                                      "+****xxxxxxxx**  ++  **  **    nn**  nn+",
                                      "+****xxxxxxxx**  ++  **  **    nn**  nn+",
                                      "+nn          **  **  ******xx**++**xxxx+",
                                      "+nn      ++  **  **  ******xx**++**xxxx+",
                                      "+        ++  **  **  ******  ++        +",
                                      "+wwwwwwwwnn  **  nn    ww    ++        +",
                                      "+wwwwwwwwnn  **  nn    ww  ++          +",
                                      "+        **  **  **    ww  ++          +",
                                      "+++      **  **  **    ww  **        xx+",
                                      "+++      xx  wwwwww    ww  **        xx+",
                                      "+  xx    xx  wwwwww    ww  **nn    xx  +",
                                      "+  xx    xx  wwwwww    ww  **nn    xx  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoMC :: Estado
estadoMC =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                     "+                                      +",
                                     "+                                      +",
                                     "+                *n*+n*                +",
                                     "+                *n+*n*                +",
                                     "+                *+**n*                +",
                                     "+                ++++++  ++++          +",
                                     "+                ++++++   +++          +",
                                     "+                +n**n*  ++++          +",
                                     "+                *+**n*++++++          +",
                                     "+                *n+*n*++++++          +",
                                     "+                *n*+n*++++++          +",
                                     "+                *n**+*++++++          +",
                                     "+                ++++++                +",
                                     "+                ++++++                +",
                                     "+                *n**n+                +",
                                     "+                *n**+*                +",
                                     "+                *n*+n*                +",
                                     "+                *n+*n*                +",
                                     "+                *+**n*                +",
                                     "+                ++++++                +",
                                     "+                ++++++                +",
                                     "+                *+**n*                +",
                                     "+                *n+*n*                +",
                                     "+                *n*+n*                +",
                                     "+                *n**+*                +",
                                     "+                *n**n+                +",
                                     "+                                      +",
                                     "+                                      +",
                                     "++++++++++++++++++++++++++++++++++++++++"])
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoOAS :: Estado
estadoOAS =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                      "+  nn    **            ++xxxxxxxx      +",
                                      "+  nn    **            ++xxxxxxxx      +",
                                      "+        **   nn       ++xxxxxxxx      +",
                                      "+        **   nn       **      ++xxx**++",
                                      "+**wwwwww++            **      ++xxx**++",
                                      "+**wwwwww++            **      **      +",
                                      "+        xx      **xxxx++      **      +",
                                      "+        xx      **xxxx++ nn   **      +",
                                      "+        xx********    ww nn   **      +",
                                      "+        xx********    ww      ++wwwwww+",
                                      "+   nn       xx        ww      ++wwwwww+",
                                      "+   nn       xx  nn    ww******xx   nn +",
                                      "+            xx  nn    ww******xx   nn +",
                                      "+      **wwww++                xx      +",
                                      "+      **wwww++         nn     xx      +",
                                      "+++xxxx**    **         nn     xx nn   +",
                                      "+++xxxx**    **                xx nn   +",
                                      "+**          **xxxxxx++********xxwwwwww+",
                                      "+**   nn     **xxxxxx++********xxwwwwww+",
                                      "+**   nn     ww      ww           **   +",
                                      "+**          ww      ww        nn **   +",
                                      "+**++wwwwwwwww++xxxxxww        nn **   +",
                                      "+**++wwwwwwwww++xxxxxww           ++www+",
                                      "+  ++         ++     ww           ++www+",
                                      "+  ++         ++     ww   nn      xx   +",
                                      "+xx++         ++     ww   nn      xx   +",
                                      "+  xx         xx nn  ww           xx   +",
                                      "+  xx         xx nn  ww           xx   +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoEA :: Estado
estadoEA =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                      "+  ++****      **nn    ++nn      nnxx  +",
                                      "+  ++****      **nn    ++nn      nnxx  +",
                                      "+xx    **      **      **          xx  +",
                                      "+xx    **      **      **          xx  +",
                                      "+      ++wwwwww++      **          xx  +",
                                      "+      ++wwwwww++wwwwnn++****nnnn****+++",
                                      "+      xx      **wwwwnn++****nnnn****+++",
                                      "+++nn**xx      **      wwnn      **nn**+",
                                      "+++nn**xx      **      wwnn      **nn**+",
                                      "+      xx      **      ww        **    +",
                                      "+wwwwww++******++xxxxxx**      ++xxxxxx+",
                                      "+wwwwww++******++xxxxxx**      ++xxxxxx+",
                                      "+nn               **   **wwww**        +",
                                      "+nn  xxxxxxxxxx   nn   **wwww**        +",
                                      "+    xxxxxxxxxx   nn   **    ++     nn +",
                                      "+    xxxxxxxxxx   **www**    ++     nn +",
                                      "+    xxxxxxxxxx   **www++wwww**        +",
                                      "+    xxxxxxxxxx   nn   ++wwww**xxxxxxxx+",
                                      "+  nnxxxxxxxxxx   nn   **    **xxxxxxxx+",
                                      "+  nnxxxxxxxxxx   **  n**    **xxxxxxxx+",
                                      "+**++wwwwwwwwww++******++  ++**xxxxxxxx+",
                                      "+**++wwwwwwwwww++******++  ++**xxxxxxxx+",
                                      "+nnxxnn      nnww    nn**              +",
                                      "+  xxnn      nnww    nn**              +",
                                      "+  xx          wwxxxxxx**++******wwwwww+",
                                      "+  xx          wwxxxxxx**++******wwwwww+",
                                      "+  ++        nnww      xx        nn    +",
                                      "+  ++        nnww      xx        nn    +",
                                      "++++++++++++++++++++++++++++++++++++++++"])
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoBF :: Estado
estadoBF =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+                 ++           ww      +",
                                      "+  xxxxxx         nn           ww      +",
                                      "+  xxxxxx         nn           ww      +",
                                      "+  xxxxxx         **           ++      +",
                                      "+  xxxxxx         xx****++     ++      +",
                                      "+  xxxxxx    nn   xx****++             +",
                                      "+  xxxxxx    nn         **++           +",
                                      "+++****     ***++       **++       ww  +",
                                      "+++****     ***++       **         ww  +",
                                      "+ww            ww       **         ww  +",
                                      "+ww            ww       xxxxxxxxxxxxx  +",
                                      "+ww            ww       xxxxxxxxxxxxx  +",
                                      "+ww            ww       xxxxxxxxxxxxx  +",
                                      "+ww            wwwwwwwwwxxxxxxxxxxxxxww+",
                                      "+ww            wwwwwwwwwxxxxxxxxxxxxxww+",
                                      "+++****nnnn****++       ++             +",
                                      "+++****nnnn****++       ++            ++",
                                      "+                       **            ++",
                                      "+                       **             +",
                                      "+  xxxxxxxxxx   **      *******nnnwwwww+",
                                      "+  xxxxxxxxxx   **      *******nnnwwwww+",
                                      "+  xxxxxxxxxx                ww      ww+",
                                      "+  xxxxxxxxxx        nn      ww      ww+",
                                      "+  xxxxxxxxxx        nn      ww      ww+",
                                      "+  xxxxxxxxxx  ww            ++********+",
                                      "+  xxxxxxxxxx  ww            ++********+",
                                      "+  xxxxxxxxxx      ++                  +",
                                      "+                  ++                  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoBM :: Estado
estadoBM =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+**************************************+",
                                      "+**************************************+",
                                      "+*************************+++**********+",
                                      "+************************+nnn+*********+",
                                      "+***nn********************++nn+********+",
                                      "+*nn  nn***********+++++****+nn+*******+",
                                      "+**n  n**********++nnnnn+****+nn+******+",
                                      "+*nn**nn********+nnnnnnnn+****+nn+*****+",
                                      "+************+++nnnnnnn++*****+nnn+****+",
                                      "+***********+nnnnnnnnnn+*******+nnn+***+",
                                      "+************+nnnn+nnnn+*******+nnn+***+",
                                      "+************+nnn++nnnnnn+****+nnn+****+",
                                      "+*************+++**+nnnnnn+***+nnn+****+",
                                      "+*******++++********+nnnnnn+*+nnn+*****+",
                                      "+******+nnnn++++*****+nnnnnn+nnnn+*****+",
                                      "+******+nnnnnnnn++****+nnnnnnnnnn+*****+",
                                      "+*****++nnnnnnnnnn++++nnnnnnnnn++******+",
                                      "+****+nnnn++nnnnnnnnnnnnnnnnnnn+*******+",
                                      "+****+nnn+**+++nnnnnnnn+++nnnnnn+******+",
                                      "+****+nnn+*****++++++++***++nnnnn++****+",
                                      "+*****+++*******************++nnnnn+***+",
                                      "+*****************************+nnnn+***+",
                                      "+******************************++++****+",
                                      "+**************************************+",
                                      "++++++++++++******************+++++++  +",
                                      "+          +******************+        +",
                                      "+           ******************+        +",
                                      "+           ******************+        +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (6,4) B 5 5 5 Pistol),(Jogador (27,1) D 5 5 5 Pistol),(Jogador (27,37) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoOT :: Estado
estadoOT =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+        ++nn                          +",
                                      "+        ++nn                          +",
                                      "+                                    nn+",
                                      "+                                    nn+",
                                      "+        ++**                ++        +",
                                      "+    ++xx++**   ++                     +",
                                      "+    ++xx++**                     **   +",
                                      "+    **    **          **              +",
                                      "+    **    **                          +",
                                      "+    **    **                          +",
                                      "+**wwwwwwww**           xxxx           +",
                                      "+**wwwwwwww**           xxxx           +",
                                      "+**        ww                     ++   +",
                                      "+**        ww                          +",
                                      "+++        ww                          +",
                                      "+++        ww   nn          ++         +",
                                      "+****nn****ww   nn                     +",
                                      "+****nn****ww                          +",
                                      "+          ww         **               +",
                                      "+          ww                    **    +",
                                      "+          ww                          +",
                                      "+  xxxxxx**ww                          +",
                                      "+  xxxxxx**++**********++xxxx++xxxxxxxx+",
                                      "+  xxxxxx**++**********++xxxx++xxxxxxxx+",
                                      "+  ++      xx        nnww    ++        +",
                                      "+  ++    nnxx        nnww    ++        +",
                                      "+  ++    nnxxxxxx++    ww    nn        +",
                                      "+  ++      xxxxxx++    ww    nn        +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (14,5) B 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoBK :: Estado
estadoBK =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn+",
                                      "+nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn+",
                                      "+nn                                  nn+",
                                      "+nn          ************            nn+",
                                      "+nn        ****************          nn+",
                                      "+nn      ******************          nn+",
                                      "+nn      xxxxxxxxxxxxxxxx****        nn+",
                                      "+nn      xxxxxxxxxxxxxxxx****        nn+",
                                      "+nn    xxxx            xxxx****      nn+",
                                      "+nn    xxxx            xxxx****      nn+",
                                      "+nn    xx  ++    ++      xxxxxx      nn+",
                                      "+nn    xx  ++    ++      xxxxxx      nn+",
                                      "+nn    xx  ++    ++      xxxxxx      nn+",
                                      "+nn    xx  ++    ++      xxxxxx      nn+",
                                      "+nn    xx    xx        xxxx****      nn+",
                                      "+nn    xx    xx        xxxx****      nn+",
                                      "+nn    xxxxxxxxxxxxxxxxxx******      nn+",
                                      "+nn    xxxxxxxxxxxxxxxxxx*******     nn+",
                                      "+nn    **xxxx****xxxxxx********      nn+",
                                      "+nn    **xxxx****xxxxxx********      nn+",
                                      "+nn      ********************  ++    nn+",
                                      "+nn      ********************  ++    nn+",
                                      "+nn    ++  **++*************   ++    nn+",
                                      "+nn    ++  **++*************   ++    nn+",
                                      "+nn      ++****++      ****++++++    nn+",
                                      "+nn      ++****++      ****++++++    nn+",
                                      "+nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn+",
                                      "+nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn+",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (3,3) D 5 5 5 Pistol),(Jogador (10,13) E 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoOBA :: Estado
estadoOBA =  (Estado (stringParaMapa ["++++++++++++++++++++++++++++++++++++++++",
                                      "+  xx              ++                  +",
                                      "+  xx              ++                  +",
                                      "+  xx    ww****++  ww    xxwwww**      +",
                                      "+  xx    ww****++  ww    xxwwww**      +",
                                      "+ww++xxxx**        ww    xx    **wwww+++",
                                      "+ww++xxxx**        ww    xx    **wwww+++",
                                      "+        **xxxxxxxx++xxxx++    nn      +",
                                      "+        **xxxxxxxx++xxxx++    nn      +",
                                      "+xx**xxxxxx        ww          ******+++",
                                      "+xx**xxxxxx        ww          ******+++",
                                      "+ww++    xx      nn**          nn    xx+",
                                      "+ww++    xx      nn**          nn    xx+",
                                      "+  ++    xx      ++**xxxxxx++nn  xxxxxx+",
                                      "+  ++    xx      ++**xxxxxx++nn  xxxxxx+",
                                      "+nn**xxxx++nn**nn****xx    ww    **nn  +",
                                      "+nn**xxxx++nn**nn****xx    ww    **nn  +",
                                      "+      ww    **      xx    ww    **    +",
                                      "+      ww    **      xx    ww    **    +",
                                      "+      ww    **wwwwww++wwww++xxxx**    +",
                                      "+      ww    **wwwwww++wwww++xxxx**    +",
                                      "+**xxxx++    nn                  ww    +",
                                      "+**xxxx++    nn                  ww    +",
                                      "+            **          ++xxxx****++xx+",
                                      "+            **          ++xxxx****++xx+",
                                      "+  ++wwww++  **++xxxx++  ww    **nn**  +",
                                      "+  ++wwww++  **++xxxx++  ww    **nn**  +",
                                      "+  **    xx  ++      **  ww    **++**  +",
                                      "+  **    xx  ++      **  ww    **++**  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoFS :: Estado
estadoFS =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+                  ++                  +",
                                      "+                                      +",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "+                                      +",
                                      "+                                      +",
                                      "+                                      +",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "+                                      +",
                                      "+                                      +",
                                      "+                                      +",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "+++      ++++     ++++     ++++      +++",
                                      "++xx    xx++xx   xx++xx   xx++xx    xx++",
                                      "+ xx    xx  xx   xx  xx   xx  xx    xx +",
                                      "+                                      +",
                                      "+                  ++                  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o estado para um dos níveis
--
-- A criação do mapa baseia-se na utilização da função auxiliar 'stringParaMapa'                
estadoAB :: Estado
estadoAB =  (Estado (stringParaMapa  ["++++++++++++++++++++++++++++++++++++++++",
                                      "+  xx              ++              xx  +",
                                      "+  xx                              xx  +",
                                      "+xx++xx                          xx++xx+",
                                      "+xx++xx          ++++            xx++xx+",
                                      "+  xx            ++++              xx  +",
                                      "+  xx              ++              xx  +",
                                      "+                  ++                  +",
                                      "+                  ++                  +",
                                      "+        ++++xxxx**++**xxxx++++        +",
                                      "+        ++++xxxx**++**xxxx++++        +",
                                      "+            ++xxxxxxxxxx++            +",
                                      "+            ++xxxxxxxxxx++            +",
                                      "+xx            xxxxxxxxxx            xx+",
                                      "+xx            ++xxxxxx++            xx+",
                                      "+++xx     nn     xxxxxx     nn     xx+++",
                                      "+++xx     nn     xxxxxx     nn     xx+++",
                                      "+xx              ++xx++              xx+",
                                      "+xx            ++  xx  ++            xx+",
                                      "+              ++      ++              +",
                                      "+              ++  ++  ++              +",
                                      "+            ++    ++    ++            +",
                                      "+            ++    ++    ++            +",
                                      "+  xx                              xx  +",
                                      "+  xx          nn      nn          xx  +",
                                      "+xx++xx        nn      nn        xx++xx+",
                                      "+xx++xx                          xx++xx+",
                                      "+  xx                              xx  +",
                                      "+  xx              ++              xx  +",
                                      "++++++++++++++++++++++++++++++++++++++++"]) 
                [(Jogador (1,1) D 5 5 5 Pistol),(Jogador (1,37) B 5 5 5 Pistol),(Jogador (27,37) E 5 5 5 Pistol),(Jogador (27,1) C 5 5 5 Pistol)] 
                [])

-- | Função que cria o mapa para a maioria dos níveis
--
-- A criação do mapa baseia-se na utilização de simbolos (+, *, x, w, entre outros) como representação das pecas do mapa, para assim facil leitura e criação do mesmo.                                   
stringParaMapa :: Matriz Char -> Mapa
stringParaMapa m = map (linha) m 
    where
    linha :: String -> [Peca]
    linha "" = []
    linha (h:t) | h == '+' = Bloco Indestrutivel : (linha t)
                | h == ' ' = Vazia : (linha t)
                | h == '*' = Bloco Destrutivel : (linha t)
                | h == 'x' = Bloco Arbusto : (linha t)
                | h == 'w' = Bloco Agua : (linha t)
                | h == 'n' = Bloco TNT : (linha t)
                | h == '0' = VMJuggernog : (linha t)
                | h == 'a' = V0 : (linha t)  
                | h == '1' = VMSpeedCola : (linha t)
                | h == 'b' = V1 : (linha t)
                | h == '2' = VMMunicao : (linha t)
                | h == 'c' = V2 : (linha t)
                | h == '3' = VMMedkit : (linha t)
                | h == 'd' = V3 : (linha t)
                | h == '4' = VMSelfRevive : (linha t)
                | h == 'e' = V4 : (linha t)
                | h == '5' = VMDoubleTap : (linha t)
                | h == 'f' = V5 : (linha t)
                | h == '6' = VMAK47 : (linha t)
                | h == 'g' = V6 : (linha t)
                | h == '7' = VMM8A1 : (linha t)
                | h == 'h' = V7 : (linha t)
                | h == 'p' = Porta :(linha t)