#!/bin/bash

set -e

CURRENT_DIR=$(dirname $(realpath $0))
source ${CURRENT_DIR}/config.sh

DB_URL=$(get_config | jq -r '.dbFile')
DAYS_AHEAD_TO_CHECK=$(get_config | jq -r '.barDaysAheadToCheck')

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