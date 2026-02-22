PROJECT_PATH=/home/pet/Work/repos/movies-waybar
UPDATE_DATE_FILE="${PROJECT_PATH}/bin/.last_update_date"

update_interval=$((10 * 60 * 60)) # 10 hours
now=$(date +%s)
waybar_pid=$(pgrep -l "waybar" | cut -d' ' -f1)
waybar_start_date=$(date -d "$(ps -p $waybar_pid -o lstart=)" +%s)
just_started_margin=$((1 * 60)) # 1 minute

# If never updated, should update
if [ -f ${UPDATE_DATE_FILE} ]; then
  last_update_date=$(cat ${UPDATE_DATE_FILE})
else
  echo "No update date file found. Will update again"
  exit 0
fi

# If waybar just started, should update
if [ $((now - waybar_start_date)) -lt ${just_started_margin} ]; then
  echo "Waybar just started. Will update"
  exit 0
fi

# If last updated far ago, should update
if [ $((now - last_update_date)) -gt ${update_interval} ]; then
  echo Last updated $(date -d @${last_update_date}). Will update again
  exit 0 # exit 0 to signal waybar to update
else
  echo Last updated $(date -d @${last_update_date}). Will update again in $((update_interval - (now - last_update_date))) seconds
  exit 1 # exit 1 to signal waybar to not update
fi