
## :busts_in_silhouette: Team

![Filipe Felício][filipe-pic] | ![Miguel Brandão][brandao-pic]
:---: | :---: | :---: 
[Filipe Felício][filipe] | [Miguel Brandão][brandao]

[filipe]: https://github.com/feliciofilipe
[filipe-pic]: https://github.com/feliciofilipe.png?size=120
[brandao]: https://github.com/miguelbrandao
[brandao-pic]: https://github.com/miguelbrandao.png?size=120

## :rocket: Getting Started

No ficheiro anexo pode encontrar um arquivo Zip contendo a estrutura de pastas e ficheiros que devem procurar usar no desenvolvimento e na submissão do vosso trabalho. Descarregue e expanda esse ficheiro. Logo de seguida renomeie a pasta "grupo-xx" que foi criada, substituindo o "xx" pelo número do seu grupo.

Segue-se uma breve descrição das pastas relativas ao processo de compilação e linkagem do projecto:

    src/: deverá conter o código-fonte do vosso projecto;
    obj/: deverá conter o código-objecto resultante da compilação do código-fonte.;
    bin/: deverá conter os executáveis resultantes da "linkagem" do código-objecto;
    docs/: deverá conter o relatório do desenvolvimento do projecto.

Nessa estrutura pode encontrar ainda as seguintes pastas:

    etc/: deverá conter o(s) ficheiro(s) de configuração do servidor (o ficheiro "aurrasd.conf" apresenta um exemplo de configuração);
    bin/aurrasd-filters/: contém programas executáveis para Linux (e Mac) que funcionam como filtros de áudio (recebem o conteúdo de ficheiros de áudio (em qualquer formato) pelo seu standard input e produzem o conteúdo de um ficheiro de áudio (no formato MP3) no seu standard output;
    samples/: contém ficheiros de áudio que pode usar para testar a execução dos filtros disponibilizados e para testar o correcto funcionamento do serviço a desenvolver;
    tmp/: pasta de ficheiros temporários, irrelevantes para a avaliação do trabalho, ou que tenha necessidade de gerar durante a execução do serviço a desenvolver.

Tenha em conta que os filtros disponibilizados são programas executáveis em Linux e Mac (Intel) e requerem a instalação do programa "ffmpeg". Poderá ter necessidade de proceder à instalação desse programa externo. Por exemplo, num Ubuntu poderá ter de executar o comando "sudo apt install ffmpeg". Para Mac, poderá ter de instalar o “ffmpeg” via “brew”, executando o comando “brew install ffmpeg”. Para o desenvolvimento deste trabalho não deverá ter necessidade de desenvolver qualquer filtro de áudio adicional.

Se quiser testar o funcionamento de um destes filtros poderá executar um comando tal como:

bash$ bin/aurrasd-filters/aurrasd-echo < samples/samples-1.m4a > output.mp3

Ou com encadeamento de filtros:

bash$ bin/aurrasd-filters/aurrasd-echo < samples/samples-1.m4a | bin/aurrasd-filters/aurrasd-tempo-half > output.mp3

A pasta principal comtém também um ficheiro Makefile com um conjunto de regras básicas para a compilação código-fonte, geração de executáveis (linkagem de código-objecto) e limpeza do projecto. Ainda assim poderá ter necessidade de adaptar este ficheiro conforme as especificidades do projecto. Para compilar e gerar os seus programas executáveis apenas deverá ser necessário executar o comando "make". Para limpar os ficheiros de código-objecto e os seus programas executáveis poderá fazer "make clean".

Quando submeter o trabalho desenvolvido, lembre-se de remover todos os ficheiros desnecessários para a avaliação (incluindo os ficheiros executáveis relativos ao seu cliente e servidor).

