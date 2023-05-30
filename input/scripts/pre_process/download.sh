#!/bin/bash

cd ../../raw/
curl -o html_caiua.txt  https://github.com/caiuafranca/dados_curso
grep ".csv" html_caiua.txt > html_tratado_csv.txt
cat html_tratado_csv.txt | cut -d"/" -f6 | cut -d"." -f1 > link_tratado.txt
rm html_caiua.txt
rm html_tratado_csv.txt

ASSUNTO_LIST="link_tratado.txt"
readarray ASSUNTOS < ${ASSUNTO_LIST}

for assunto in ${ASSUNTOS[@]}
do
mkdir $assunto
cd $assunto
curl -O https://raw.githubusercontent.com/caiuafranca/dados_curso/main/$assunto.csv
cd ../../raw/
done

rm link_tratado.txt