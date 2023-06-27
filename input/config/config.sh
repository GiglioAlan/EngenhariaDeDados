#!/bin/bash

TARGET_DATABASE="aula_hive"
HDFS_DIR="/datalake/raw/categoria/"
TARGET_TABLE_EXTERNAL="categoria"
TARGET_TABLE_GERENCIADA="tbl_categoria"

PARTICAO="$(date --date="-0 day" "+%Y%m%d")"