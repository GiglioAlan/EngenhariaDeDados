#!/bin/bash

cd ../../raw/
curl -o html_caiua.txt  https://github.com/caiuafranca/dados_curso
grep ".csv" html_caiua.txt > html_tratado_csv.txt
cat html_tratado_csv.txt | cut -d"/" -f6 | cut -d"." -f1 > link_tratado.txt
rm html_caiua.txt
rm html_tratado_csv.txt

TABLE_LIST="link_tratado.txt"
readarray tables < ${TABLE_LIST}

for table in ${tables[@]}
do
mkdir $table
chmod 777 $table
cd $table
curl -O https://raw.githubusercontent.com/caiuafranca/dados_curso/main/$table.csv
hdfs dfs -mkdir /datalake/raw/$table
hdfs dfs -chmod 777 /datalake/raw/$table
hdfs dfs -copyFromLocal $table.csv /datalake/raw/$table
cd ../../raw/
done

rm link_tratado.txt