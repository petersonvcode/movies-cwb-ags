#!/bin/bash

set -e

PROJECT_PATH=/home/pet/Work/repos/movies-waybar
DB_FILE=movies.db
DB_URL="${PROJECT_PATH}/${DB_FILE}"
DAYS_AHEAD_TO_CHECK=10

get_waybar_content() {
  query="
SELECT
  m.*,
  ${DAYS_AHEAD_TO_CHECK} as days_ahead_to_check
FROM movie_details m
WHERE substr(\"when\", 1, 10) >= strftime('%Y/%m/%d', 'now', 'localtime')
  AND substr(\"when\", 1, 10) <= strftime('%Y/%m/%d', 'now', 'localtime', '+${DAYS_AHEAD_TO_CHECK} days')
ORDER BY \"when\";"

  sqlite3 ${DB_URL} ".mode json" "${query}"
}

get_waybar_content