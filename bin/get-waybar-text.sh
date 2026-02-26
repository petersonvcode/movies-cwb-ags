#!/bin/bash

set -e

CURRENT_DIR=$(dirname $(realpath $0))
source ${CURRENT_DIR}/config.sh

DB_URL=$(get_config | jq -r '.dbFile')
DAYS_AHEAD_TO_CHECK=$(get_config | jq -r '.barDaysAheadToCheck')

get_next_movies_count() {
  query="
SELECT count(*)
FROM movie_details
WHERE substr(\"when\", 1, 10) >= strftime('%Y/%m/%d', 'now', 'localtime')
  AND substr(\"when\", 1, 10) <= strftime('%Y/%m/%d', 'now', 'localtime', '+${DAYS_AHEAD_TO_CHECK} days')
ORDER BY \"when\";"

  sqlite3 ${DB_URL} "${query}"
}

echo "🎥 $(get_next_movies_count)  "