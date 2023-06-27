#!/bin/bash
# BASEDIR="( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
# CONFIG="${BASEDIR}/../../config/config.sh"
# source "${CONFIG}"

cd ../../raw/
curl -o html_caiua.txt  https://github.com/caiuafranca/dados_curso
grep ".csv" html_caiua.txt > html_tratado_csv.txt
cat html_tratado_csv.txt | cut -d"/" -f6 | cut -d"." -f1 > link_tratado.txt
rm html_caiua.txt
rm html_tratado_csv.txt

TABLE_LIST="link_tratado.txt"
readarray tables < ${TABLE_LIST}

cd ../scripts/pre_process

for table in ${tables[@]}
do
    TARGET_DATABASE="aula_hive"
    HDFS_DIR="/datalake/raw/$table"
    TARGET_TABLE_EXTERNAL="$table"
    TARGET_TABLE_GERENCIADA="tbl_$table"
    PARTICAO="$(date --date="-0 day" "+%Y%m%d")"

    beeline -u jdbc:hive2://localhost:10000 \
    --hivevar TARGET_DATABASE="${TARGET_DATABASE}"\
    --hivevar HDFS_DIR="${HDFS_DIR}"\
    --hivevar TARGET_TABLE_EXTERNAL="${TARGET_TABLE_EXTERNAL}"\
    --hivevar TARGET_TABLE_GERENCIADA="${TARGET_TABLE_GERENCIADA}"\
    --hivevar PARTICAO="${PARTICAO}"\
    -f ../../scripts/hql/create_table_$table.hql
done

cd ../../raw/
rm link_tratado.txt