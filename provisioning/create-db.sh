#!/bin/bash

EXPECTED_ARGS=3
E_BADARGS=65
MYSQL=`which mysql`

QUERY1="CREATE DATABASE IF NOT EXISTS $1;"
QUERY2="GRANT ALL ON *.* TO '$2'@'localhost' IDENTIFIED BY '$3';"
QUERY3="FLUSH PRIVILEGES;"
SQL="${QUERY1}${QUERY2}${QUERY3}"

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser dbpass"
  exit ${E_BADARGS}
fi

${MYSQL} -uroot -p -e "$SQL"