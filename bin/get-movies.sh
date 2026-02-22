#!/bin/bash

set -e

PROJECT_PATH=/home/pet/Work/repos/movies-waybar
DB_FILE=movies.db
DB_URL="${PROJECT_PATH}/${DB_FILE}"

get_movies() {
  sqlite3 ${DB_URL} ".mode json" "SELECT * FROM movie_details order by id desc limit 10"
}

get_movies