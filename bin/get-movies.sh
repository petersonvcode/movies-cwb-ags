#!/bin/bash

set -e

CURRENT_DIR=$(dirname $(realpath $0))
source ${CURRENT_DIR}/config.sh

DB_URL=$(get_config | jq -r '.dbFile')

get_movies() {
  sqlite3 ${DB_URL} ".mode json" "SELECT * FROM movie_details order by id desc limit 10"
}

get_movies