#!/bin/bash

set -e

PROJECT_PATH=/home/pet/Work/repos/movies-waybar
UPDATE_DATE_FILE="${PROJECT_PATH}/bin/.last_update_date"
DB_FILE=movies.db
DB_URL="${PROJECT_PATH}/${DB_FILE}"
DAYS_AHEAD_TO_CHECK=10

get_next_movies_count() {
  query="
SELECT count(*)
FROM movie_details
WHERE substr(\"when\", 1, 10) >= strftime('%Y/%m/%d', 'now', 'localtime')
  AND substr(\"when\", 1, 10) <= strftime('%Y/%m/%d', 'now', 'localtime', '+${DAYS_AHEAD_TO_CHECK} days')
ORDER BY \"when\";"

  sqlite3 ${DB_URL} "${query}"

  # Saving last update date
  mkdir -p $(dirname ${UPDATE_DATE_FILE})
  local last_update_date=$(date +%s)
  echo ${last_update_date} > ${UPDATE_DATE_FILE}
}

echo "🎥 $(get_next_movies_count)  "